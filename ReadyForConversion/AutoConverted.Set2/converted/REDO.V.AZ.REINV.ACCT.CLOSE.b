SUBROUTINE REDO.V.AZ.REINV.ACCT.CLOSE
*
* Description: This auth routine is attached to the version- 'ACCOUNT.CLOSURE,REDO.NAO.AUTH'
*              and 'ACCOUNT.CLOSURE,REDO.NAO.TELLER.AUTH' to close the reinvested deposit base account.
* Dev By     : V.P.Ashokkumar
******************************************************************************
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE

    IF APPLICATION EQ 'AZ.ACCOUNT' THEN
        GOSUB INIT
        GOSUB PROCESS
    END
RETURN

INIT:
*****
    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'; F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    FN.AZ.ACCOUNT.H = 'F.AZ.ACCOUNT$HIS'; F.AZ.ACCOUNT.H = ''
    CALL OPF(FN.AZ.ACCOUNT.H,F.AZ.ACCOUNT.H)

    LOC.REF.APP = 'ACCOUNT.CLOSURE':@FM:'AZ.ACCOUNT':@FM:'ACCOUNT'
    LOC.REF.FIELD = 'L.AC.AZ.ACC.REF':@VM:'L.AC.CAN.REASON':@VM:'L.AC.OTH.REASON':@FM:'L.AC.CAN.REASON':@VM:'L.AC.OTH.REASON':@FM:'L.AC.AZ.ACC.REF':@VM:'L.AC.REINVESTED'
    YLOC.REF = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,YLOC.REF)
    POS.AZ.ACC.REF.CLOSE    = YLOC.REF<1,1>
    POS.AC.CAN.REASON.CLOSE = YLOC.REF<1,2>
    POS.AC.OTH.REASON.CLOSE = YLOC.REF<1,3>
    POS.AC.CAN.REASON.AZ    = YLOC.REF<2,1>
    POS.AC.OTH.REASON.AZ    = YLOC.REF<2,2>
    POS.AZ.ACC.REF          = YLOC.REF<3,1>
    L.AC.REINVESTED.POS     = YLOC.REF<3,2>

    TOD.DATE = TODAY
    AZ.OFS.SOURCE = 'ACCT.REINV.OFS'
RETURN

PROCESS:
********
    YL.AC.AZ.ACC.REF = ''; YCATEG = ''; YWORKBAL = ''
    YOFS.COMPANY = ''; YREINV.VAL = ''; YFLG = 0
    ACCT.ID = ID.NEW
    GOSUB READ.ACCOUNT
    YL.AC.AZ.ACC.REF = R.NEW(AZ.INTEREST.LIQU.ACCT)
    YOFS.COMPANY = R.NEW(AZ.CO.CODE)
    YREINV.VAL = R.ACCOUNT<AC.LOCAL.REF,L.AC.REINVESTED.POS>
    TRANSACTION.ID1 = ID.NEW
    GOSUB OFS.PROCESS
RETURN

OFS.PROCESS:
************
* Capital date should be set for account with balance.
    R.ACCOUNT = ''; ACCT.ERR = ''; YWORKBAL =''
    CALL F.READ(FN.ACCOUNT,AZ.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    YWORKBAL = R.ACCOUNT<AC.WORKING.BALANCE>
    IF YWORKBAL AND YWORKBAL NE 0 THEN
        R.ACCOUNT.CLOSURE<AC.ACL.CAPITAL.DATE> = TODAY
    END
    IF R.NEW(AZ.LOCAL.REF)<1,POS.AC.CAN.REASON.AZ> THEN
        R.ACCOUNT.CLOSURE<AC.ACL.LOCAL.REF,POS.AC.CAN.REASON.CLOSE> = R.NEW(AZ.LOCAL.REF)<1,POS.AC.CAN.REASON.AZ>
    END
    IF R.NEW(AZ.LOCAL.REF)<1,POS.AC.OTH.REASON.AZ> THEN
        R.ACCOUNT.CLOSURE<AC.ACL.LOCAL.REF,POS.AC.OTH.REASON.CLOSE> = R.NEW(AZ.LOCAL.REF)<1,POS.AC.OTH.REASON.AZ>
    END
    R.ACCOUNT.CLOSURE<AC.ACL.POSTING.RESTRICT> = '90'
    R.ACCOUNT.CLOSURE<AC.ACL.CLOSE.MODE> = 'AUTO'
    R.ACCOUNT.CLOSURE<AC.ACL.CLOSE.ONLINE> = 'Y'
    R.ACCOUNT.CLOSURE<AC.ACL.LOCAL.REF,POS.AZ.ACC.REF.CLOSE> = ID.NEW

    APPLICATION.NAME = 'ACCOUNT.CLOSURE'
    OFS.FUNCTION1 = 'I'
    PROCESS1 = 'PROCESS'
    OFS.VERSION1 = ''
    GTSMODE1 = ''
    NO.OF.AUTH1 = '0'
    OFS.RECORD1 = ''
    VERSION1 = 'ACCOUNT.CLOSURE,REDO.TELLER'
    MSG.ID1 = ''
    OPTION1 = ''
    CALL OFS.BUILD.RECORD(APPLICATION.NAME,OFS.FUNCTION1,PROCESS1,VERSION1,GTSMODE1,NO.OF.AUTH1,TRANSACTION.ID1,R.ACCOUNT.CLOSURE,OFS.ACC)
    MSG.ID = ''; ERR.OFS = ''
    CALL OFS.POST.MESSAGE(OFS.ACC,MSG.ID,AZ.OFS.SOURCE,ERR.OFS)
RETURN

READ.ACCOUNT:
*************
    ACCT.ERR = ''; R.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
RETURN
END
