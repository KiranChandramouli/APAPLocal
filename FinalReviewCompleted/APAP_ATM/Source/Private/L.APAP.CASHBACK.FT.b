* @ValidationCode : MjotOTYzNzE1Njc1OkNwMTI1MjoxNjk3MDI5MzA3MDg1OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Oct 2023 18:31:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM


SUBROUTINE L.APAP.CASHBACK.FT
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       = to EQ, FM to @FM
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ATM.REVERSAL ;*R22 Auto conversion - END

    GOSUB READ.ACCOUNT
    GOSUB FT.PROCESS
RETURN

FT.PROCESS:
***********

    IF Y.L.PRESENCIAL EQ 'APAPPMovil' AND Y.L.TYPE.TRANS EQ '00'  THEN

        YTRAN.AMT = YDEBIT.AMT * 0.01

        Y.VER.NAME = 'FUNDS.TRANSFER,L.CASHBACK.VIRTUAL'
        Y.APP.NAME = 'FUNDS.TRANSFER'
        Y.FUNC = 'I'
        Y.PRO.VAL = "PROCESS"
        Y.GTS.CONTROL = ""
        Y.NO.OF.AUTH = ""
        FINAL.OFS = ""
        Y.TRANS.ID = ""

        CALL EB.ROUND.AMOUNT(LCCY,YTRAN.AMT,"2","")

        R.FT<FT.CREDIT.AMOUNT> = YTRAN.AMT
        R.FT<FT.CREDIT.ACCT.NO> = YDEBIT.ACCT
        R.FT<FT.LOCAL.REF,Y.L.LIQ.ID.POS>  = Y.ATM.REV.ID

        CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.FT,FINAL.OFS)

        OFS.MSG.ID = ''
        OFS.SOURCE.ID = "DM.OFS.SRC.VAL"
        OPTIONS = ''

        CALL OFS.POST.MESSAGE(FINAL.OFS,OFS.MSG.ID,OFS.SOURCE.ID,OPTIONS)

    END

RETURN

READ.ACCOUNT:
**************
    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'; F.ATM.REVERSAL = ''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

    ERR.ACCOUNT = '';
    R.ACCOUNT = '';
    Y.ACCOUNT.BALANCE = 0
    Y.L.PRESENCIAL.POS = '';
    Y.L.TYPE.TRANS.POS = '';
    Y.L.LIQ.ID.POS = '';
    Y.L.PRESENCIAL = '';
    Y.L.TYPE.TRANS = '';
    Y.L.LIQ.ID = '';
    YVAL.POSN = ''
    Y.TRAN.AMT = ''
    Y.DEBIT.INTERNAL = ''

    YFILE.NAME = 'ACCOUNT':@FM:'FUNDS.TRANSFER'
    YFIELD.NME = 'L.PRESENCIAL':@FM:'AT.UNIQUE.ID'
    CALL MULTI.GET.LOC.REF(YFILE.NAME,YFIELD.NME,YVAL.POSN)
    Y.L.PRESENCIAL.POS = YVAL.POSN<1,1>
    Y.L.LIQ.ID.POS     = 123

    YDEBIT.ACCT = R.NEW(FT.DEBIT.ACCT.NO)

    Y.ATM.REV.ID = R.NEW(FT.LOCAL.REF)<1,Y.L.LIQ.ID.POS>

    YDEBIT.AMT = R.NEW(FT.DEBIT.AMOUNT)

    IF NOT(YDEBIT.AMT) THEN

        YDEBIT.AMT = R.NEW(FT.CREDIT.AMOUNT)

    END


    CALL F.READ(FN.ACCOUNT,YDEBIT.ACCT,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)

    Y.L.PRESENCIAL = R.ACCOUNT<AC.LOCAL.REF,Y.L.PRESENCIAL.POS>

    CALL F.READ(FN.ATM.REVERSAL,Y.ATM.REV.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ERR.ATM)

    Y.L.TYPE.TRANS = R.ATM.REVERSAL<AT.REV.PROCESS.CODE>

    Y.L.TYPE.TRANS = LEFT(Y.L.TYPE.TRANS,2)

RETURN

END
