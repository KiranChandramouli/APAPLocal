* @ValidationCode : Mjo2OTcwODk2NzU6VVRGLTg6MTcwMjg5NzMyNzg5MDpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Dec 2023 16:32:07
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM, FREAD TO CACHEREAD
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION        OfsCallBulkManager method modified
*18-12-2023          Narmadha V                       Manual R22 Conversion              Call Routine Format Modified
SUBROUTINE REDO.AZ.INV.FAC.UPD.OTIME

* Description: This is one time routine to update the L.INV.FACILITY local field in the AZ account.
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.CATEGORY
    $USING EB.Interface

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'; F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    FN.CATEGORY = 'F.CATEGORY'; F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    YFILE.NME = "CATEGORY":@FM:"AZ.ACCOUNT"
    YFIELD.NME = "L.CU.AGE":@FM:"L.INV.FACILITY"
    CALL MULTI.GET.LOC.REF(YFILE.NME,YFIELD.NME,LVAL.POSN)
    L.CU.AGE.POS = LVAL.POSN<1,1>
    L.INV.FACILITY.POS = LVAL.POSN<2,1>
RETURN

PROCESS:
********
    AZ.OFS.SOURCE = 'ACCT.REINV.OFS'
    SEL.ACCT = ''; SEL.REC = ''; SEL.LIST = ''; SEL.ERR = ''
    SEL.ACCT = "SELECT ":FN.AZ.ACCOUNT:" WITH L.INV.FACILITY EQ ''"
    CALL EB.READLIST(SEL.ACCT,SEL.REC,'',SEL.LIST,SEL.ERR)
    LOOP
        REMOVE SEL.ID FROM SEL.REC SETTING SL.POSN
    WHILE SEL.ID:SL.POSN
        AZ.ERR = ''; R.AZ.ACCOUNT = ''; YCATEG = ''; ERR.CATEGORY = ''
        R.CATEGORY = ''; YINV.VAL = ''
        CALL F.READ(FN.AZ.ACCOUNT,SEL.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
        YCATEG = R.AZ.ACCOUNT<AZ.CATEGORY>

        CALL CACHE.READ(FN.CATEGORY, YCATEG, R.CATEGORY, ERR.CATEGORY) ;* AUTO R22 CODE CONVERSION
        YINV.VAL = R.CATEGORY<EB.CAT.LOCAL.REF,L.CU.AGE.POS>
        R.AZ.DETAIL = ''
        R.AZ.DETAIL<AZ.LOCAL.REF,L.INV.FACILITY.POS> = YINV.VAL

        ACTUAL.APP.NAME = 'AZ.ACCOUNT'
        OFS.FUNCTION = 'I'
        PROCESS = 'PROCESS'
        OFS.VERSION = ''
        GTSMODE = ''
        NO.OF.AUTH = 0
        OFS.RECORD = ''
        VERSION = 'AZ.ACCOUNT,'
        MSG.ID = ''
        OFS.SRC.ID = 'REINV.DEPOSIT'
        OPTION = ''
        CALL OFS.BUILD.RECORD(ACTUAL.APP.NAME,OFS.FUNCTION,PROCESS,OFS.VERSION,GTSMODE,NO.OF.AUTH,SEL.ID,R.AZ.DETAIL,OFS.RECORD)
        OFS.MSG.VAL = VERSION:OFS.RECORD
        OFS.RESP   = ""; TXN.COMMIT = "" ;* R22 Manual conversion - Start
*CALL OFS.GLOBUS.MANAGER(AZ.OFS.SOURCE,OFS.MSG.VAL)
* CALL OFS.CALL.BULK.MANAGER(AZ.OFS.SOURCE,OFS.MSG.VAL, OFS.RESP, TXN.COMMIT) ;* R22 Manual conversion - End
         EB.Interface.OfsCallBulkManager(AZ.OFS.SOURCE,OFS.MSG.VAL, OFS.RESP, TXN.COMMIT) ;*Manual R22 Conversion
    
    REPEAT
    PRINT "Process Completed "
RETURN

END
