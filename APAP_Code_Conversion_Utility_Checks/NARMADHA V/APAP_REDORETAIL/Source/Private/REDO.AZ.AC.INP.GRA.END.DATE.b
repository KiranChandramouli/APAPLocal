* @ValidationCode : MjotMTk1ODk3MzcxMjpDcDEyNTI6MTY4MTI4MzkzOTE5MDpJVFNTOi0xOi0xOjE3ODoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:48:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 178
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.AZ.AC.INP.GRA.END.DATE
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AZ.AC.INP.GRA.END.DATE
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a INPUT ROUTINE to get the value of L.AZ.GRACE.DAYS of version
*                    AZ.ACCOUNT,RE.It is used to check if user input a different
*                    grace days in the field L.AZ.GRACE.DAYS. If so then the corresponding maturity date
*                    will be populated against the field L.AZ.GR.END.DAT
*In Parameter      :
*Out Parameter     :
*Files  Used       : AZ.ACCOUNT               As             I/O          Mode
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  14/06/2010       REKHA S            ODR-2009-10-0336 N.18      Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER

    GOSUB INIT
    GOSUB MAIN.PROCESS
RETURN
*--------------------------------------------------------------------------------------------------------
INIT:
*****
    FN.APP = 'F.AZ.PRODUCT.PARAMETER'
    F.APP = ''
    CALL OPF(FN.APP,F.APP)

    MATURITY.DATE = ''
    LOC.L.AZ.GRACE.DAYS = ''
    LOC.L.AZ.GR.END.DAT = ''
RETURN
*--------------------------------------------------------------------------------------------------------
MAIN.PROCESS:
*************

    GOSUB GET.LOCAL.FLD.POS

    APP.ID =  R.NEW(AZ.ALL.IN.ONE.PRODUCT)
    CALL F.READ(FN.APP,APP.ID,R.APP,F.APP,APP.ERR)
    GRACE.DAYS = R.APP<AZ.APP.LOCAL.REF,LOC.L.AZ.GRACE.DAYS.APP>
    IF GRACE.DAYS THEN
        R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.GRACE.DAYS> = GRACE.DAYS
        NO.OF.DAYS = '+':GRACE.DAYS:'W'
        MATURITY.DATE = R.NEW(AZ.MATURITY.DATE)
        CALL CDT('',MATURITY.DATE,NO.OF.DAYS)
        R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.GR.END.DAT> = MATURITY.DATE
    END
RETURN
*---------------------------------------------------------------------------------------------------------
GET.LOCAL.FLD.POS:
******************
    APPL.ARRAY = 'AZ.ACCOUNT':@FM:'AZ.PRODUCT.PARAMETER'
    FLD.ARRAY  = 'L.AZ.GR.END.DAT':@VM:'L.AZ.GRACE.DAYS':@FM:'L.AZ.GRACE.DAYS'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.AZ.GR.END.DAT     = FLD.POS<1,1>
    LOC.L.AZ.GRACE.DAYS     = FLD.POS<1,2>
    LOC.L.AZ.GRACE.DAYS.APP = FLD.POS<2,1>
RETURN
*----------------------------------------------------------------------------------------------------------
END
