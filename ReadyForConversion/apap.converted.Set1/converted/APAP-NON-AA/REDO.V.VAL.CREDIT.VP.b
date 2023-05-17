SUBROUTINE REDO.V.VAL.CREDIT.VP
*---------------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 05.04.2013
* Description  : Routine for obtaining Credit Card Information
* Type         : Validation Routine (attached to hotfield LR-27 > L.TT.CR.CARD.NO)
* Attached to  : VERSION > TELLER Vision Plus Versions
*                VERSION > FUNDS.TRANSFER Vision Plus Versions
* Dependencies :
*---------------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who                  Reference         Description
* 1.0       04.30.2013     lpazmino             -                 Initial Version
* 1.1       08.29.2014     msthandier           -                 Completing Vision+ dev
* 1.2       13.03.2015     Vignesh Kumaar R     PACS00424073      ACH Vision Plus Payment
* 2.0 MG
* 2.1       09/05/2015     Vignesh Kumaar R                       PRODUCTION PERFORMANCE FIX
* 2.2       26/06/2015     Marcelo.Gudino                          Disbursement Validation
*---------------------------------------------------------------------------------

* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.USER
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER

    $INSERT I_System
    $INSERT I_GTS.COMMON

    $INSERT I_F.REDO.CARD.BIN
    $INSERT I_F.REDO.VPLUS.MAPPING
    $INSERT I_F.EB.EXTERNAL.USER

* </region>

    IF NOT(COMI) OR COMI[7,6] EQ '******' THEN
        IF PGM.VERSION NE ',REDO.AA.LTCC' THEN
            RETURN
        END
    END

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

    IF VP.FLAG THEN
        COMI = System.getVariable("CURRENT.CARD.ORG.NO")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            COMI = ""
        END
        COMI = COMI[1,4] : '-xxxx-xxxx-' : COMI[13,4]
    END

    FINDSTR 'EB-UNKNOWN.VARIABLE' IN E<1,1> SETTING POS.FM.OVER THEN
        DEL E<POS.FM.OVER>
    END

RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************

    VP.FLAG = ''
    IF APPLICATION EQ 'TELLER' THEN
        Y.LET = 'T'
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.LET = 'F'
    END

    Y.CHANNEL = ''
    Y.MON.CHANNEL = ''

    FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
    F.REDO.CARD.BIN  = ''

    FN.REDO.VPLUS.MAPPING = 'F.REDO.VPLUS.MAPPING'
    F.REDO.VPLUS.MAPPING = ''
    REDO.VPLUS.MAPPING.ID = 'SYSTEM'

    TXN.CURRENCY = ''
    ORG.ID = ''

    Y.LOCAL.REF = 'LOCAL.REF'

    Y.LOCAL.FIELDS = ''
    Y.LOCAL.FIELDS.POS = ''

    Y.LOCAL.FIELDS<1,1>  = 'L.':Y.LET:'T.CR.ACCT.NO'
    Y.LOCAL.FIELDS<1,2>  = 'L.':Y.LET:'T.CLIENT.NME'
    Y.LOCAL.FIELDS<1,3>  = 'L.':Y.LET:'T.BAL.IN.LCY'
    Y.LOCAL.FIELDS<1,4>  = 'L.':Y.LET:'T.BAL.IN.USD'
    Y.LOCAL.FIELDS<1,5>  = 'L.':Y.LET:'T.MINPAY.LCY'
    Y.LOCAL.FIELDS<1,6>  = 'L.':Y.LET:'T.MINPAY.USD'
    Y.LOCAL.FIELDS<1,7>  = 'L.':Y.LET:'T.PAY.DUE.DT'
    Y.LOCAL.FIELDS<1,8>  = 'L.':Y.LET:'T.CR.CRD.STS'
    Y.LOCAL.FIELDS<1,9>  = 'L.':Y.LET:'T.AC.STATUS'
    Y.LOCAL.FIELDS<1,10> = 'L.':Y.LET:'T.CLIENT.COD'
    Y.LOCAL.FIELDS<1,11> = 'L.':Y.LET:'T.DOC.NUM'
    Y.LOCAL.FIELDS<1,12> = 'L.':Y.LET:'T.DOC.DESC'
    Y.LOCAL.FIELDS<1,13> = 'L.':Y.LET:'T.MSG.DESC'
    Y.LOCAL.FIELDS<1,14> = 'L.':Y.LET:'T.MSG.CODE'
    Y.LOCAL.FIELDS<1,15> = 'L.':Y.LET:'T.CR.CARD.NO'
    Y.LOCAL.FIELDS<1,16> =  'L.SUN.SEQ.NO'


    CALL EB.FIND.FIELD.NO(APPLICATION, Y.LOCAL.REF)
    CALL MULTI.GET.LOC.REF(APPLICATION, Y.LOCAL.FIELDS, Y.LOCAL.FIELDS.POS)

    CR.ACCT.NO.POS = Y.LOCAL.FIELDS.POS<1,1>
    CLIENT.NME.POS = Y.LOCAL.FIELDS.POS<1,2>
    BAL.IN.LCY.POS = Y.LOCAL.FIELDS.POS<1,3>
    BAL.IN.USD.POS = Y.LOCAL.FIELDS.POS<1,4>
    MINPAY.LCY.POS = Y.LOCAL.FIELDS.POS<1,5>
    MINPAY.USD.POS = Y.LOCAL.FIELDS.POS<1,6>
    PAY.DUE.DT.POS = Y.LOCAL.FIELDS.POS<1,7>
    CR.CRD.STS.POS = Y.LOCAL.FIELDS.POS<1,8>
    AC.STATUS.POS  = Y.LOCAL.FIELDS.POS<1,9>
    CLIENT.COD.POS = Y.LOCAL.FIELDS.POS<1,10>
    DOC.NUM.POS    = Y.LOCAL.FIELDS.POS<1,11>
    DOC.DESC.POS   = Y.LOCAL.FIELDS.POS<1,12>
    MSG.DESC.POS   = Y.LOCAL.FIELDS.POS<1,13>
    MSG.CODE.POS   = Y.LOCAL.FIELDS.POS<1,14>
    CR.CARD.NO   =  Y.LOCAL.FIELDS.POS<1,15>
    VPL.SEQ.NO.POS = Y.LOCAL.FIELDS.POS<1,16>

    EXT.USER.ID = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        EXT.USER.ID = ""
    END
    IF EXT.USER.ID NE 'EXT.EXTERNAL.USER' THEN
        COMI = System.getVariable("CURRENT.CARD.ORG.NO")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            COMI = ""
        END
        VP.FLAG = 1
    END

    IF PGM.VERSION EQ ',REDO.AA.LTCC' AND NOT(COMI) THEN
        IF NOT(R.NEW(Y.LOCAL.REF)<1,CR.CARD.NO>) OR R.NEW(Y.LOCAL.REF)<1,CR.CARD.NO>[7,6] EQ '******' THEN
            COMI =  R.NEW(Y.LOCAL.REF)<1,VPL.SEQ.NO.POS>
        END ELSE
            COMI =  R.NEW(Y.LOCAL.REF)<1,CR.CARD.NO>
        END
    END

    IF PGM.VERSION EQ ',REDO.AA.LTCC' AND COMI[7,6] EQ '******' THEN
        IF NOT(R.NEW(Y.LOCAL.REF)<1,CR.CARD.NO>) OR R.NEW(Y.LOCAL.REF)<1,CR.CARD.NO>[7,6] EQ '******' THEN
            COMI =  R.NEW(Y.LOCAL.REF)<1,VPL.SEQ.NO.POS>
        END ELSE
            COMI =  R.NEW(Y.LOCAL.REF)<1,CR.CARD.NO>
        END
    END


*    L.[TF]T.CR.CARD.NO
    CREDIT.CARD.ID  = COMI
    CREDIT.CARD.BIN = CREDIT.CARD.ID[1,6]
    CREDIT.CARD.ID  = FMT(CREDIT.CARD.ID, 'R%19')

    CALL CACHE.READ(FN.REDO.CARD.BIN, CREDIT.CARD.BIN, R.REDO.CARD.BIN, Y.ERR)

* Get Transaction' Currency
    IF APPLICATION EQ 'TELLER' THEN
        TXN.CURRENCY = R.NEW(TT.TE.CURRENCY.1)
        IF NOT(TXN.CURRENCY) THEN
            TXN.CURRENCY = R.NEW(TT.TE.CURRENCY.2)
        END
        Y.LET = 'T'
        Y.OVERRIDE = TT.TE.OVERRIDE
        RRCB.CURRENCIES = R.REDO.CARD.BIN<REDO.CARD.BIN.T24.CURRENCY>
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        TXN.CURRENCY = R.NEW(FT.CURRENCY.MKT.CR)
        Y.LET = 'F'
        Y.OVERRIDE = FT.OVERRIDE
        RRCB.CURRENCIES = R.REDO.CARD.BIN<REDO.CARD.BIN.VP.CURRENCY>
    END

    CHANGE @VM TO @FM IN RRCB.CURRENCIES

RETURN

***********************
* Open Files
OPEN.FILES:
***********************
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)
    CALL OPF(FN.REDO.VPLUS.MAPPING,F.REDO.VPLUS.MAPPING)

RETURN

***********************
* Main Process
PROCESS:
***********************

    GOSUB INVOKE.VP.WS.CB

RETURN

**************************************************
* Invoke VP Web Service 'CONSULTA_BALANCE'
INVOKE.VP.WS.CB:
**************************************************
    ACTIVATION = 'WS_T24_VPLUS'
    WS.DATA = ''
    WS.DATA<1> = 'CONSULTA_BALANCE'
    WS.DATA<2> = CREDIT.CARD.ID
    CALL REDO.S.VP.SEL.CHANNEL(APPLICATION,PGM.VERSION,TRANS.CODE,Y.CHANNEL,Y.MON.CHANNEL)
    WS.DATA<3> = Y.CHANNEL

* Invoke VisionPlus Web Service


    CALL REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA)

* Credit Card exits - Info obtained OK
    IF WS.DATA<1> EQ 'OK' THEN
* Credit Card Account
        R.NEW(Y.LOCAL.REF)<1,CR.ACCT.NO.POS> = WS.DATA<3>[4,16]
* Bal In Local Curncy
        R.NEW(Y.LOCAL.REF)<1,BAL.IN.LCY.POS> = WS.DATA<28>
* Bal In Usd
        R.NEW(Y.LOCAL.REF)<1,BAL.IN.USD.POS> = WS.DATA<29>
* Min Pay Local Curncy
        R.NEW(Y.LOCAL.REF)<1,MINPAY.LCY.POS> = WS.DATA<6> + WS.DATA<26>
* Minimum Pay Usd
        R.NEW(Y.LOCAL.REF)<1,MINPAY.USD.POS> = WS.DATA<7> + WS.DATA<27>
* Payment Due Date
        R.NEW(Y.LOCAL.REF)<1,PAY.DUE.DT.POS> = WS.DATA<8>

        GOSUB CHECK.STATUS

* Card Holder Name
        R.NEW(Y.LOCAL.REF)<1,CLIENT.NME.POS> = WS.DATA<11>
* Client Code
        Y.GET.CC.CODE = FIELD(WS.DATA<12>,'/',1)
        Y.GET.CC.CODE = TRIM(Y.GET.CC.CODE,'0','L')
        R.NEW(Y.LOCAL.REF)<1,CLIENT.COD.POS> = Y.GET.CC.CODE
* Numero Identificacion
        R.NEW(Y.LOCAL.REF)<1,DOC.NUM.POS> = WS.DATA<13>
* Tipo de Identificacion
        Y.TIPO.DOC = WS.DATA<14>
        IF Y.TIPO.DOC THEN
            R.NEW(Y.LOCAL.REF)<1,DOC.DESC.POS> = WS.DATA<14>
        END ELSE
* TODO Confirmar - Default temporal
            R.NEW(Y.LOCAL.REF)<1,DOC.DESC.POS> = "CEDULA"
        END
* Msg Det
        R.NEW(Y.LOCAL.REF)<1,MSG.DESC.POS> = 'TRANSACCION PROCESADA CORRECTAMENTE'
        R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> = ''

* Vplus Internal Credit Card Number
        R.NEW(Y.LOCAL.REF)<1,VPL.SEQ.NO.POS> = COMI
        Y.CC.CARD.VAL = COMI:' - ':WS.DATA<12>:' - ':WS.DATA<11>
* Enmask CC Number
        COMI = COMI[1,6] : '******' : COMI[13,4]

        R.NEW(Y.LOCAL.REF)<1,CR.CARD.NO> = COMI

        ID.COMPORTAMIENTO = WS.DATA<35>

* Fix for PACS00424073 [ACH Vision Plus Payment]

        IF (PGM.VERSION EQ ',CARD.IN' OR PGM.VERSION EQ ',REDO.VP.DIRECT.DEBIT') AND (ID.COMPORTAMIENTO EQ 1 OR ID.COMPORTAMIENTO EQ 2) THEN
            CALL REDO.S.NOTIFY.INTERFACE.ACT('VPL003', 'ONLINE', '04', 'Email ':Y.CC.CARD.VAL:' TRANSACCION RECHAZADA-WS MASTERDATA', ' ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '')
            AF = Y.LOCAL.REF
            AV = CR.CARD.NO
            ETEXT = 'ST-VP-NO.CARD.PAY'
            CALL STORE.END.ERROR
            RETURN
        END

* End of Fix

        IF VP.FLAG EQ 1 AND (ID.COMPORTAMIENTO EQ 1 OR ID.COMPORTAMIENTO EQ 2) THEN
            AF = Y.LOCAL.REF
            AV = CR.CARD.NO
            ETEXT = 'ST-VP-NO.CARD.PAY'
            CALL STORE.END.ERROR
            RETURN
        END ELSE
            BEGIN CASE
                CASE ID.COMPORTAMIENTO EQ 1 ;* No Acepta Pago
                    AF = Y.LOCAL.REF
                    AV = CR.CARD.NO
                    ETEXT = 'ST-VP-NO.CARD.PAY'
                    CALL STORE.END.ERROR
                    RETURN
                CASE ID.COMPORTAMIENTO EQ 2 ;* Acepta Pago con Autorizacion
                    TEXT    = 'REDO.LEGAL.STATUS'
                    CURR.NO = DCOUNT(R.NEW(Y.OVERRIDE),@VM)+ 1
                    CALL STORE.OVERRIDE(CURR.NO)
                    RETURN
            END CASE
        END

        GOSUB CHECK.CC.CCY

*        GOSUB INVOKE.VP.WS.OI
    END ELSE
        GOSUB WS.NOT.OK

    END

RETURN
**************************************************
WS.NOT.OK:
* CC Number
    Y.CC.CARD.VAL = COMI:' - ':WS.DATA<12>:' - ':WS.DATA<11>
    COMI = ''

    IF (PGM.VERSION EQ ',CARD.IN' OR PGM.VERSION EQ ',REDO.VP.DIRECT.DEBIT') THEN
        CALL REDO.S.NOTIFY.INTERFACE.ACT('VPL003', 'ONLINE', '04', 'Email ':Y.CC.CARD.VAL:' TRANSACCION RECHAZADA-WS MASTERDATA' , ' ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '')
        AF = Y.LOCAL.REF
        AV = CR.CARD.NO
        ETEXT = 'ST-VP-NO.CARD.PAY'
        CALL STORE.END.ERROR
        RETURN
    END

    IF PGM.VERSION EQ ',REDO.APAP.CC.LCY.CASHWDL' OR  PGM.VERSION EQ ',REDO.AA.LTCC' THEN
        ETEXT = 'ST-INVALID.CARD.NUM'
        AF = Y.LOCAL.REF
        AV = CR.CARD.NO
        CALL STORE.END.ERROR
        RETURN
    END

* Credit Card Account
    R.NEW(Y.LOCAL.REF)<1,CR.ACCT.NO.POS> = ''
* Bal In Local Curncy
    R.NEW(Y.LOCAL.REF)<1,BAL.IN.LCY.POS> = ''
* Bal In Usd
    R.NEW(Y.LOCAL.REF)<1,BAL.IN.USD.POS> = ''
* Min Pay Local Curncy
    R.NEW(Y.LOCAL.REF)<1,MINPAY.LCY.POS> = ''
* Minimum Pay Usd
    R.NEW(Y.LOCAL.REF)<1,MINPAY.USD.POS> = ''
* Payment Due Date
    R.NEW(Y.LOCAL.REF)<1,PAY.DUE.DT.POS> = ''
* Ccard Status
    R.NEW(Y.LOCAL.REF)<1,CR.CRD.STS.POS> = ''
* Account Status
    R.NEW(Y.LOCAL.REF)<1,AC.STATUS.POS> = ''
* Card Holder Name
    R.NEW(Y.LOCAL.REF)<1,CLIENT.NME.POS> = ''
* Client Code
    R.NEW(Y.LOCAL.REF)<1,CLIENT.COD.POS> = ''
* Numero Identificacion
    R.NEW(Y.LOCAL.REF)<1,DOC.NUM.POS> = ''
* Tipo de Identificacion
    R.NEW(Y.LOCAL.REF)<1,DOC.DESC.POS> = ''
* Msg Det
    R.NEW(Y.LOCAL.REF)<1,MSG.DESC.POS> = FIELD(WS.DATA<2>,' - ',2)
    R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> = FIELD(WS.DATA<2>,' - ',1)
    IF NOT(R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS>) OR R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> EQ 'OFFLINE'  THEN
        R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> = "000000"
    END
* Vplus Internal Credit Card Number
    R.NEW(Y.LOCAL.REF)<1,VPL.SEQ.NO.POS> = ''

RETURN
**************************************************
**************************************************
* Invoke VP Web Service 'OnlineInformation'
INVOKE.VP.WS.OI:
**************************************************
    ACTIVATION = 'VP_ONLINE_TXN_SERVICE'

    WS.DATA = ''
    WS.DATA<1> = 'ONLINE_INFO'
    WS.DATA<2> = CREDIT.CARD.ID

* Obtain Org ID
    LOCATE TXN.CURRENCY IN RRCB.CURRENCIES SETTING TXN.CURRENCY.POS THEN
* OrgId
        ORG.ID = FIELD(R.REDO.CARD.BIN<REDO.CARD.BIN.ORG.ID>,@VM,TXN.CURRENCY.POS)
        WS.DATA<3> = ORG.ID
* Mercant Number
        MERCHANT.NUMBER = R.REDO.CARD.BIN<REDO.CARD.BIN.MERCHANT.NUMBER>
        WS.DATA<4> = MERCHANT.NUMBER

* Invoke VisionPlus Web Service
        CALL REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA)
    END ELSE
        WS.DATA = ''
        WS.DATA<1> = 'ERROR'
    END

* Credit Card exits - Info obtained OK
    IF WS.DATA<1> EQ 'OK' THEN
* ONLINE Bal In Local Curncy
        R.NEW(Y.LOCAL.REF)<1,BAL.IN.LCY.POS> = WS.DATA<4>
    END ELSE
* Error handling (ERROR/OFFLINE)
* IF WS.DATA<1> EQ 'ERROR' AND OFS$OPERATION EQ 'PROCESS' THEN
        IF VP.FLAG NE 1 THEN
            TEXT = "ST-VP-NO.ONLINE.AVAIL" : @FM : WS.DATA<2>
            AF = Y.LOCAL.REF
            AV = BAL.IN.LCY.POS

            IF R.NEW(Y.OVERRIDE) THEN
                Y.OV.POS = DCOUNT(R.NEW(Y.OVERRIDE), @VM) + 1
            END ELSE
                Y.OV.POS = 1
            END
            CALL STORE.OVERRIDE(Y.OV.POS)
        END
    END

RETURN

***********************************
* Check if the currency is allowed
* for the Credit Card
CHECK.CC.CCY:
***********************************
    LOCATE TXN.CURRENCY IN RRCB.CURRENCIES SETTING TXN.CURRENCY.POS THEN
        RETURN
    END

    ETEXT = "ST-VP-NO.CCY.ALLOWED" : @FM : CREDIT.CARD.ID : @VM : TXN.CURRENCY
    IF APPLICATION EQ 'TELLER' THEN
        AF = TT.TE.CURRENCY.1
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        AF = FT.DEBIT.CURRENCY
    END
    CALL STORE.END.ERROR


RETURN

***********************************
* Check status
CHECK.STATUS:
***********************************
* Ccard Status
    CC.STATUS = WS.DATA<9>
    CC.STATUS.DESC = ''
    CALL CACHE.READ(FN.REDO.VPLUS.MAPPING, REDO.VPLUS.MAPPING.ID, R.REDO.VPLUS.MAPPING, Y.ERR)

    LOCATE CC.STATUS IN R.REDO.VPLUS.MAPPING<VP.MAP.VP.STATUS.CODE,1> SETTING CC.STATUS.POS THEN
        CC.STATUS.DESC = R.REDO.VPLUS.MAPPING<VP.MAP.STATUS.DESC,CC.STATUS.POS>
    END ELSE
        CC.STATUS.DESC = CC.STATUS
    END

    R.NEW(Y.LOCAL.REF)<1,CR.CRD.STS.POS> = CC.STATUS.DESC

* Account Status
    ACCT.STATUS = WS.DATA<10>
    ACCT.STATUS.DESC = ''

    LOCATE ACCT.STATUS IN R.REDO.VPLUS.MAPPING<VP.MAP.VP.STATUS.CODE,1> SETTING ACCT.STATUS.POS THEN
        ACCT.STATUS.DESC = R.REDO.VPLUS.MAPPING<VP.MAP.STATUS.DESC,ACCT.STATUS.POS>
    END ELSE
        ACCT.STATUS.DESC = ACCT.STATUS
    END

    R.NEW(Y.LOCAL.REF)<1,AC.STATUS.POS> = ACCT.STATUS.DESC

RETURN

* </region>

END
