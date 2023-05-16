* @ValidationCode : MjotMTQ4MzMwODU3NzpVVEYtODoxNjg0MTU2NTc2Mjg2OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 May 2023 18:46:16
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
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.V.AUTH.PYMNT.VP
*------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED,IF CONDITION ADDED,VM TO @VM,TNO TO C$T24.SESSION.NO
*21-04-2023       Samaran T               R22 Manual Code Conversion       CALL ROUTINE FORMAT MODIFIED
*-------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Developer    : Estalin Valerio (esvalerio@apap.com.do)
* Date         : 24.03.2022
* Description  : Routine for registering a new payment by Teller
* Type         : Auth Routine
* Attached to  : VERSION > TELLER,REDO.CR.CARD.LCY.CASHIN
* Dependencies :
*-----------------------------------------------------------------------------
* <region name="INSERTS">

    $INSERT I_COMMON    ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_System

    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER

    $INSERT I_F.REDO.VPLUS.MAPPING
    $INSERT I_F.REDO.VISION.PLUS.PARAM
    $INSERT I_F.REDO.VISION.PLUS.TXN  ;*R22 AUTO CODE CONVERSION.END
    $USING APAP.TAM

* </region>

    IF V$FUNCTION NE 'R' THEN
        GOSUB INIT
        GOSUB OPEN.FILES
        GOSUB PROCESS

        R.NEW(Y.LOCAL.REF)<1,CR.CARD.NO.POS> = ''
        EXT.USER.ID = System.getVariable("EXT.EXTERNAL.USER")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 AUTO CODE CONVERSION.START
            EXT.USER.ID = ""
        END   ;*R22 AUTO CODE CONVERSION.END
        IF EXT.USER.ID EQ 'EXT.EXTERNAL.USER' THEN
            Y.TARJETA = R.NEW(Y.LOCAL.REF)<1,CR.NUM>
            Y.TARJETA  = Y.TARJETA [1,6] : '******' : Y.TARJETA [13,4]
            R.NEW(Y.LOCAL.REF)<1,CR.NUM> = Y.TARJETA

            FINDSTR 'EB-UNKNOWN.VARIABLE' IN E<1,1> SETTING POS.FM.OVER THEN
                DEL E<POS.FM.OVER>
            END

        END
    END

RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize
INIT:
***********************
    Y.CHANNEL = ''

    FN.REDO.VISION.PLUS.TXN = 'F.REDO.VISION.PLUS.TXN'
    F.REDO.VISION.PLUS.TXN = ''
    R.REDO.VISION.PLUS.TXN = ''
    REDO.VISION.PLUS.TXN.ID = ''

    FN.REDO.VISION.PLUS.PARAM = 'F.REDO.VISION.PLUS.PARAM'
    F.REDO.VISION.PLUS.PARAM = ''
    R.REDO.VISION.PLUS.TXN = ''
    REDO.VISION.PLUS.PARAM.ID = 'SYSTEM'

    FN.REDO.VPLUS.MAPPING = 'F.REDO.VPLUS.MAPPING'
    F.REDO.VPLUS.MAPPING = ''
    R.REDO.VPLUS.MAPPING = ''
    REDO.VPLUS.MAPPING.ID = 'SYSTEM'

    Y.ERR = ''
    TXN.CHANNEL = ''
    PROCESS.DATE = ''
    Y.RECORD.STATUS = ''

RETURN

***********************
* Open Files
OPEN.FILES:
***********************
    CALL OPF(FN.REDO.VISION.PLUS.PARAM, F.REDO.VISION.PLUS.PARAM)
    CALL OPF(FN.REDO.VISION.PLUS.TXN, F.REDO.VISION.PLUS.TXN)
    CALL OPF(FN.REDO.VPLUS.MAPPING, F.REDO.VPLUS.MAPPING)

RETURN

***********************
* Main Process
PROCESS:
***********************
    R.REDO.VISION.PLUS.TXN = ''

    CALL F.READU(FN.REDO.VISION.PLUS.PARAM, REDO.VISION.PLUS.PARAM.ID, R.REDO.VISION.PLUS.PARAM, F.REDO.VISION.PLUS.PARAM, Y.ERR, ' ')
    PROCESS.DATE = TODAY
    CALL APAP.TAM.redoSVpSelChannel(APPLICATION,PGM.VERSION,TRANS.CODE,Y.CHANNEL,Y.MON.CHANNEL)    ;*R22 MANUAL CODE CONVERSION

    IF APPLICATION EQ 'TELLER' THEN
        GOSUB GET.TT.FIELDS
        Y.RECORD.STATUS = TT.TE.RECORD.STATUS
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB GET.FT.FIELDS
        Y.RECORD.STATUS = FT.RECORD.STATUS
    END

    GOSUB REG.NEW.MON.TXN

RETURN

*************************
* Get Teller information
GET.TT.FIELDS:
*************************
    Y.LOCAL.REF = 'LOCAL.REF'

    Y.LOCAL.FIELDS = ''
    Y.LOCAL.FIELDS.POS = ''

* Using internal VPlus Credit Card Number
* 'L.SUN.SEQ.NO' instead of 'L.TT.CR.CARD.NO'
    Y.LOCAL.FIELDS<1,1> = 'L.SUN.SEQ.NO'
    Y.LOCAL.FIELDS<1,2> = 'L.TT.CLIENT.COD'
    Y.LOCAL.FIELDS<1,3> = 'L.TT.CR.ACCT.NO'
    Y.LOCAL.FIELDS<1,4> = 'L.TT.MSG.CODE'
    Y.LOCAL.FIELDS<1,5> = 'L.TT.CR.CARD.NO'

    GOSUB GET.LOCAL.FIELDS

    CR.CARD.NO.POS = Y.LOCAL.FIELDS.POS<1,1>
    CLIENT.COD.POS = Y.LOCAL.FIELDS.POS<1,2>
    CR.ACCT.NO.POS = Y.LOCAL.FIELDS.POS<1,3>
    MSG.CODE.POS   = Y.LOCAL.FIELDS.POS<1,4>
    CR.NUM      = Y.LOCAL.FIELDS.POS<1,5>

    TXN.CURRENCY = R.NEW(TT.TE.CURRENCY.1)
    IF PGM.VERSION EQ ',REDO.CR.CARD.LCY.CASHIN.FCY.ACCT' THEN
        TXN.CURRENCY = R.NEW(TT.TE.CURRENCY.2)
    END
    TXN.PAYMENT.AMT = ''

    IF TXN.CURRENCY EQ LCCY THEN
        TXN.PAYMENT.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
    END ELSE
        TXN.PAYMENT.AMT = R.NEW(TT.TE.AMOUNT.FCY.1)
    END

    TXN.TYPE = R.NEW(TT.TE.CO.CODE)[7,3]
*R.NEW(TT.TE.TRANSACTION.CODE)

    R.REDO.VISION.PLUS.TXN<VP.TXN.CARDHOLDER.NUM> = R.NEW(Y.LOCAL.REF)<1,CR.CARD.NO.POS>
    R.REDO.VISION.PLUS.TXN<VP.TXN.TRANS.AMOUNT> = TXN.PAYMENT.AMT

    IF Y.MON.CHANNEL EQ 'TELLER' OR Y.MON.CHANNEL EQ 'CAV' THEN
        R.REDO.VISION.PLUS.TXN<VP.TXN.CASH.AMT> = TXN.PAYMENT.AMT
        R.REDO.VISION.PLUS.TXN<VP.TXN.CHEQUE.AMT> = 0
    END
    IF Y.MON.CHANNEL EQ 'TELLER.CHK' THEN
        R.REDO.VISION.PLUS.TXN<VP.TXN.CASH.AMT> = 0
        R.REDO.VISION.PLUS.TXN<VP.TXN.CHEQUE.AMT> = TXN.PAYMENT.AMT
    END

    R.REDO.VISION.PLUS.TXN<VP.TXN.CUSTOMER> = R.NEW(Y.LOCAL.REF)<1,CLIENT.COD.POS>
    R.REDO.VISION.PLUS.TXN<VP.TXN.DEBIT.ACCT> = R.NEW(Y.LOCAL.REF)<1,CR.ACCT.NO.POS>
    R.REDO.VISION.PLUS.TXN<VP.TXN.CURRENCY> = TXN.CURRENCY
    R.REDO.VISION.PLUS.TXN<VP.TXN.BRANCH> = R.NEW(TT.TE.CO.CODE)
    Y.INSERT.MONOSIN = R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS>

    IF NOT(R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS>) OR  R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> EQ 'ERROR' THEN
        R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> = '000000'
    END
    R.REDO.VISION.PLUS.TXN<VP.TXN.TRANS.AUTH> = R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS>

    IF NOT(R.REDO.VISION.PLUS.TXN<VP.TXN.CARDHOLDER.NUM>) THEN
        R.REDO.VISION.PLUS.TXN<VP.TXN.CARDHOLDER.NUM> = R.NEW(Y.LOCAL.REF)<1,CR.NUM>
    END

RETURN
*************************************** GET.LOCAL.FIELDS
GET.LOCAL.FIELDS:
    CALL EB.FIND.FIELD.NO(APPLICATION, Y.LOCAL.REF)
    CALL MULTI.GET.LOC.REF(APPLICATION, Y.LOCAL.FIELDS, Y.LOCAL.FIELDS.POS)
RETURN
*************************************** GET.LOCAL.FIELDS

*********************************
* Get Funds Transfer information
GET.FT.FIELDS:
*********************************
    Y.LOCAL.REF = 'LOCAL.REF'

    Y.LOCAL.FIELDS = ''
    Y.LOCAL.FIELDS.POS = ''

* Using internal VPlus Credit Card Number
* 'L.SUN.SEQ.NO' instead of 'L.TT.CR.CARD.NO'
    Y.LOCAL.FIELDS<1,1> = 'L.SUN.SEQ.NO'
    Y.LOCAL.FIELDS<1,2> = 'L.FT.CR.ACCT.NO'
    Y.LOCAL.FIELDS<1,3> = 'L.FT.MSG.CODE'
    Y.LOCAL.FIELDS<1,4> = 'L.FT.CR.CARD.NO'
    Y.LOCAL.FIELDS<1,5> = 'L.FT.CLIENT.COD'

    GOSUB GET.LOCAL.FIELDS

    CR.CARD.NO.POS = Y.LOCAL.FIELDS.POS<1,1>
    CR.ACCT.NO.POS = Y.LOCAL.FIELDS.POS<1,2>
    MSG.CODE.POS   = Y.LOCAL.FIELDS.POS<1,3>
    CR.NUM         = Y.LOCAL.FIELDS.POS<1,4>
    CLIENT.COD.POS = Y.LOCAL.FIELDS.POS<1,5>

    TXN.CURRENCY = R.NEW(FT.CREDIT.CURRENCY)
    TXN.PAYMENT.AMT = R.NEW(FT.CREDIT.AMOUNT)
    TXN.TYPE = R.NEW(FT.CO.CODE)[6,3]
*R.NEW(FT.TRANSACTION.TYPE)

    R.REDO.VISION.PLUS.TXN<VP.TXN.CARDHOLDER.NUM> = R.NEW(Y.LOCAL.REF)<1,CR.CARD.NO.POS>
    R.REDO.VISION.PLUS.TXN<VP.TXN.TRANS.AMOUNT>   = TXN.PAYMENT.AMT
    R.REDO.VISION.PLUS.TXN<VP.TXN.CASH.AMT>       = TXN.PAYMENT.AMT
    R.REDO.VISION.PLUS.TXN<VP.TXN.CHEQUE.AMT>     = 0

    Y.GET.CUSTOMER = R.NEW(FT.DEBIT.CUSTOMER)

    IF Y.GET.CUSTOMER EQ '' THEN
        Y.GET.CUSTOMER = R.NEW(Y.LOCAL.REF)<1,CLIENT.COD.POS>
    END

    R.REDO.VISION.PLUS.TXN<VP.TXN.CUSTOMER>       = Y.GET.CUSTOMER
    R.REDO.VISION.PLUS.TXN<VP.TXN.DEBIT.ACCT>     = R.NEW(Y.LOCAL.REF)<1,CR.ACCT.NO.POS>
    R.REDO.VISION.PLUS.TXN<VP.TXN.CURRENCY>       = TXN.CURRENCY
    R.REDO.VISION.PLUS.TXN<VP.TXN.BRANCH>         = R.NEW(FT.CO.CODE)
    Y.INSERT.MONOSIN = R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS>

    IF NOT(R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS>) OR  R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> EQ 'ERROR' THEN
        R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> = '000000'
    END

    IF NOT(R.REDO.VISION.PLUS.TXN<VP.TXN.CARDHOLDER.NUM>) THEN
        R.REDO.VISION.PLUS.TXN<VP.TXN.CARDHOLDER.NUM> = R.NEW(Y.LOCAL.REF)<1,CR.NUM>
    END

    EXT.USER.ID = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN    ;*R22 AUTO CODE CONVERSION.START
        EXT.USER.ID = ""
    END    ;*R22 AUTO CODE CONVERSION.END
    IF EXT.USER.ID NE 'EXT.EXTERNAL.USER' THEN
        R.REDO.VISION.PLUS.TXN<VP.TXN.CARDHOLDER.NUM> = System.getVariable("CURRENT.CARD.ORG.NO")
    END

    R.REDO.VISION.PLUS.TXN<VP.TXN.TRANS.AUTH> = R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS>

RETURN


************************************
* Register New Monetary Transaction
REG.NEW.MON.TXN:
************************************

    Y.STATUS = R.NEW(Y.RECORD.STATUS)

    IF V$FUNCTION EQ 'R' OR Y.STATUS[1,3] EQ 'RNA' THEN
        RETURN
    END

* Obtain ID
    SEQ.NO = R.REDO.VISION.PLUS.PARAM<VP.PARAM.VP.TXN.SEQ> + 1

* Update Sequential
    R.REDO.VISION.PLUS.PARAM<VP.PARAM.VP.TXN.SEQ> = SEQ.NO
    CALL F.WRITE(FN.REDO.VISION.PLUS.PARAM, REDO.VISION.PLUS.PARAM.ID, R.REDO.VISION.PLUS.PARAM)
    CALL F.RELEASE(FN.REDO.VISION.PLUS.PARAM, REDO.VISION.PLUS.PARAM.ID, F.REDO.VISION.PLUS.PARAM)

* Fill the remaining fields for the new VP Transaction of the payment
    REDO.VISION.PLUS.TXN.ID = PROCESS.DATE : '.' : FMT(SEQ.NO,"R%4")

* TT/FT @ID
    R.REDO.VISION.PLUS.TXN<VP.TXN.TXN.REF> = ID.NEW

** Set common fields for TT/FT

* Obtain Trans Code by Channel
    CALL CACHE.READ(FN.REDO.VPLUS.MAPPING, REDO.VPLUS.MAPPING.ID, R.REDO.VPLUS.MAPPING, Y.ERR)
    LOCATE TRANS.CODE IN R.REDO.VPLUS.MAPPING<VP.MAP.TRANS.CODE,1> SETTING TRANS.CODE.POS THEN
* TransMonCode
        TRANS.MON.CODE = FIELD(R.REDO.VPLUS.MAPPING<VP.MAP.TRANS.MON.CODE>,@VM,TRANS.CODE.POS)
        TRANS.DESC = FIELD(R.REDO.VPLUS.MAPPING<VP.MAP.TRANS.DESC>,@VM,TRANS.CODE.POS)
    END

    R.REDO.VISION.PLUS.TXN<VP.TXN.TRANS.CODE> = TRANS.MON.CODE
    R.REDO.VISION.PLUS.TXN<VP.TXN.ADV.PYMT.AMT> = 0
    R.REDO.VISION.PLUS.TXN<VP.TXN.POSTING.DATE> = PROCESS.DATE
    R.REDO.VISION.PLUS.TXN<VP.TXN.CHANNEL> = TRANS.CODE
    R.REDO.VISION.PLUS.TXN<VP.TXN.TRANS.TYPE> = TXN.TYPE : ' ' : TRANS.DESC
    R.REDO.VISION.PLUS.TXN<VP.TXN.TERMINAL> = C$T24.SESSION.NO    ;*R22 AUTO CODE CONVERSION
    R.REDO.VISION.PLUS.TXN<VP.TXN.STATUS> = 'PEND'
    IF PGM.VERSION EQ ',REDO.APAP.CC.LCY.CASHWDL' THEN
        R.REDO.VISION.PLUS.TXN<VP.TXN.STATUS> = 'CON'
    END

* Transform to OFS Message
    Y.APPLICATION  = 'REDO.VISION.PLUS.TXN'
    Y.VERSION = Y.APPLICATION : ',' : 'INPUT'
    TRANS.FUNC.VAL = "I"
    TRANS.OPER.VAL = "PROCESS"
    NO.AUTH = "0"

    OFS.SOURCE  = "VP.OFS"
    OFS.MSG.ID  = ""
    OFS.OPTIONS = ""

* Send VPlus Transaction Registration
    IF ( Y.INSERT.MONOSIN NE "XXXX") THEN
        CALL OFS.BUILD.RECORD(Y.APPLICATION, TRANS.FUNC.VAL, TRANS.OPER.VAL, Y.VERSION, '', NO.AUTH, REDO.VISION.PLUS.TXN.ID, R.REDO.VISION.PLUS.TXN, OFS.MSG.REQ)
        CALL OFS.POST.MESSAGE(OFS.MSG.REQ, OFS.MSG.ID, OFS.SOURCE, OFS.OPTIONS)
    END

RETURN

* </region>

END
