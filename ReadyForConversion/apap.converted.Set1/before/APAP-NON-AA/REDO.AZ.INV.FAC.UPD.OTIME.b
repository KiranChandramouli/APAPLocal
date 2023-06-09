*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.AZ.INV.FAC.UPD.OTIME

* Description: This is one time routine to update the L.INV.FACILITY local field in the AZ account.
*
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.AZ.ACCOUNT
    $INSERT T24.BP I_F.CATEGORY

    GOSUB INIT
    GOSUB PROCESS
    RETURN

INIT:
*****
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'; F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    FN.CATEGORY = 'F.CATEGORY'; F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    YFILE.NME = "CATEGORY":FM:"AZ.ACCOUNT"
    YFIELD.NME = "L.CU.AGE":FM:"L.INV.FACILITY"
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

        CALL F.READ(FN.CATEGORY,YCATEG,R.CATEGORY,F.CATEGORY,ERR.CATEGORY)
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

        CALL OFS.GLOBUS.MANAGER(AZ.OFS.SOURCE,OFS.MSG.VAL)
    REPEAT
    PRINT "Process Completed "
    RETURN

END
