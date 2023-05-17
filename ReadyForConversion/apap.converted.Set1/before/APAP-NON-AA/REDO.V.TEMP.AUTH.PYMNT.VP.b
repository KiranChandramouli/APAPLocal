*-----------------------------------------------------------------------------
* <Rating>-72</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.V.TEMP.AUTH.PYMNT.VP
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 05.25.2013
* Description  : Routine for registering a new payment by Teller
* Type         : Auth Routine
* Attached to  : VERSION > TELLER,REDO.CR.CARD.LCY.CASHIN
* Dependencies :
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who                 Reference         Description
* 1.0       04.30.2013     lpazmino            -                 Initial Version
* 1.1       09/05/2015     Vignesh Kumaar R                      PERFORMANCE FIX REMOVING LOCK
* 1.2       02/07/2015     mgudino                               Direct Debit Issue
*-----------------------------------------------------------------------------

* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System

    $INSERT I_F.TELLER
    $INSERT I_F.REDO.FT.TT.TRANSACTION

    $INSERT I_F.REDO.VPLUS.MAPPING
    $INSERT I_F.REDO.VISION.PLUS.TXN

* </region>

    IF V$FUNCTION NE 'R' THEN
        GOSUB INIT
        GOSUB OPEN.FILES
        GOSUB PROCESS

        R.NEW(FT.TN.L.FT.CR.CARD.NO) = ''
        EXT.USER.ID = System.getVariable("EXT.EXTERNAL.USER")

        IF EXT.USER.ID EQ 'EXT.EXTERNAL.USER' THEN
            Y.TARJETA = R.REDO.VISION.PLUS.TXN<VP.TXN.CARDHOLDER.NUM>
            Y.TARJETA  = Y.TARJETA [1,6] : '******' : Y.TARJETA [13,4]
            R.NEW(FT.TN.L.FT.CR.CARD.NO) = Y.TARJETA

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
    CALL OPF(FN.REDO.VISION.PLUS.TXN, F.REDO.VISION.PLUS.TXN)
    CALL OPF(FN.REDO.VPLUS.MAPPING, F.REDO.VPLUS.MAPPING)

    RETURN

***********************
* Main Process
PROCESS:
***********************
    R.REDO.VISION.PLUS.TXN = ''

    PROCESS.DATE = TODAY
    CALL REDO.S.VP.SEL.CHANNEL(APPLICATION,PGM.VERSION,TRANS.CODE,Y.CHANNEL,Y.MON.CHANNEL)

    IF APPLICATION EQ 'REDO.FT.TT.TRANSACTION' THEN
        GOSUB GET.FT.FIELDS
        Y.RECORD.STATUS = FT.TN.RECORD.STATUS
    END

    GOSUB REG.NEW.MON.TXN

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
    TXN.CURRENCY = R.NEW(FT.TN.CREDIT.CURRENCY)
    TXN.PAYMENT.AMT = R.NEW(FT.TN.CREDIT.AMOUNT)

    IF Y.MON.CHANNEL EQ 'AUTO' THEN
        TXN.PAYMENT.AMT = R.NEW(FT.TN.DEBIT.AMOUNT)
        TXN.CURRENCY = R.NEW(FT.TN.DEBIT.CURRENCY)
    END

    TXN.TYPE = R.NEW(FT.TN.CO.CODE)[6,3]

    R.REDO.VISION.PLUS.TXN<VP.TXN.CARDHOLDER.NUM> = R.NEW(FT.TN.L.FT.CR.CARD.NO)
    R.REDO.VISION.PLUS.TXN<VP.TXN.TRANS.AMOUNT>   = TXN.PAYMENT.AMT
    R.REDO.VISION.PLUS.TXN<VP.TXN.CASH.AMT>       = TXN.PAYMENT.AMT
    R.REDO.VISION.PLUS.TXN<VP.TXN.CHEQUE.AMT>     = 0

    Y.GET.CUSTOMER = R.NEW(FT.TN.L.FT.CUSTOMER)

    IF Y.GET.CUSTOMER EQ '' THEN
        Y.GET.CUSTOMER = R.NEW(FT.TN.FT.CLIENT.COD)
    END

    R.REDO.VISION.PLUS.TXN<VP.TXN.CUSTOMER>       = Y.GET.CUSTOMER
    R.REDO.VISION.PLUS.TXN<VP.TXN.DEBIT.ACCT>     = R.NEW(FT.TN.L.FT.CR.ACCT.NO)
    R.REDO.VISION.PLUS.TXN<VP.TXN.CURRENCY>       = TXN.CURRENCY
    R.REDO.VISION.PLUS.TXN<VP.TXN.BRANCH>         = R.NEW(FT.TN.CO.CODE)
    IF NOT(R.NEW(FT.TN.L.FT.MSG.CODE)) OR  R.NEW(FT.TN.L.FT.MSG.CODE) EQ 'ERROR' THEN
        R.NEW(FT.TN.L.FT.MSG.CODE) = '000000'
    END

    IF NOT(R.REDO.VISION.PLUS.TXN<VP.TXN.CARDHOLDER.NUM>) THEN
        R.REDO.VISION.PLUS.TXN<VP.TXN.CARDHOLDER.NUM> = R.NEW(FT.TN.L.FT.CR.CARD.NO)
    END

    EXT.USER.ID = System.getVariable("EXT.EXTERNAL.USER")
    IF EXT.USER.ID NE 'EXT.EXTERNAL.USER' THEN
        R.REDO.VISION.PLUS.TXN<VP.TXN.CARDHOLDER.NUM> = System.getVariable("CURRENT.CARD.ORG.NO")
    END

    R.REDO.VISION.PLUS.TXN<VP.TXN.TRANS.AUTH> = R.NEW(FT.TN.L.FT.MSG.CODE)

    RETURN

************************************
* Register New Monetary Transaction
REG.NEW.MON.TXN:
************************************

    Y.STATUS = R.NEW(FT.TN.RECORD.STATUS)

    IF V$FUNCTION EQ 'R' OR Y.STATUS[1,3] EQ 'RNA' THEN
        RETURN
    END

* Obtain ID
*    SEQ.NO = R.REDO.VISION.PLUS.PARAM<VP.PARAM.VP.TXN.SEQ> + 1

    BASE.REFERENCE =''
    CALL ALLOCATE.UNIQUE.TIME(BASE.REFERENCE)
    BASE.REFERENCE = BASE.REFERENCE * 100
    LEN.BASE.REFERENCE = LEN(BASE.REFERENCE)
    BASE.REFERENCE = BASE.REFERENCE[LEN.BASE.REFERENCE-4,4]

* Fill the remaining fields for the new VP Transaction of the payment
    REDO.VISION.PLUS.TXN.ID = PROCESS.DATE : '.' : ID.NEW : '.' : FMT(BASE.REFERENCE,"R%4")

* TT/FT @ID
    R.REDO.VISION.PLUS.TXN<VP.TXN.TXN.REF> = ID.NEW

* Obtain Trans Code by Channel
    CALL CACHE.READ(FN.REDO.VPLUS.MAPPING, REDO.VPLUS.MAPPING.ID, R.REDO.VPLUS.MAPPING, Y.ERR)
    LOCATE TRANS.CODE IN R.REDO.VPLUS.MAPPING<VP.MAP.TRANS.CODE,1> SETTING TRANS.CODE.POS THEN
* TransMonCode
        TRANS.MON.CODE = FIELD(R.REDO.VPLUS.MAPPING<VP.MAP.TRANS.MON.CODE>,VM,TRANS.CODE.POS)
        TRANS.DESC = FIELD(R.REDO.VPLUS.MAPPING<VP.MAP.TRANS.DESC>,VM,TRANS.CODE.POS)
    END

    R.REDO.VISION.PLUS.TXN<VP.TXN.TRANS.CODE> = TRANS.MON.CODE
    R.REDO.VISION.PLUS.TXN<VP.TXN.ADV.PYMT.AMT> = 0
    R.REDO.VISION.PLUS.TXN<VP.TXN.POSTING.DATE> = PROCESS.DATE
    R.REDO.VISION.PLUS.TXN<VP.TXN.CHANNEL> = TRANS.CODE
    R.REDO.VISION.PLUS.TXN<VP.TXN.TRANS.TYPE> = TXN.TYPE : ' ' : TRANS.DESC
    R.REDO.VISION.PLUS.TXN<VP.TXN.TERMINAL> = TNO
    R.REDO.VISION.PLUS.TXN<VP.TXN.STATUS> = 'PEND'

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
    CALL F.WRITE(FN.REDO.VISION.PLUS.TXN, REDO.VISION.PLUS.TXN.ID, R.REDO.VISION.PLUS.TXN)
* </region>

END
