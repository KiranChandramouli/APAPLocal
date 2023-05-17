SUBROUTINE REDO.V.TEMP.CREDIT.VP
*---------------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 05.04.2013
* Description  : Routine for obtaining Credit Card Information
* Type         : Validation Routine (attached to hotfield L.FT.CR.CARD.NO)
* Attached to  : VERSION > REDO.FT.TT.TRANSACTION Vision Plus Versions
* Dependencies :
*---------------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who                  Reference         Description
* 1.0       29/06/2017     Edwin Charles D      R15 Upgrade -     Initial Version
*---------------------------------------------------------------------------------

* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_System
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CARD.BIN
    $INSERT I_F.REDO.VPLUS.MAPPING
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_F.REDO.FT.TT.TRANSACTION

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

    IF APPLICATION EQ 'REDO.FT.TT.TRANSACTION' THEN
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
        IF NOT(R.NEW(FT.TN.L.FT.CR.CARD.NO)) OR R.NEW(FT.TN.L.FT.CR.CARD.NO)[7,6] EQ '******' THEN
            COMI =  R.NEW(FT.TN.L.SUN.SEQ.NO)
        END ELSE
            COMI =  R.NEW(FT.TN.L.FT.CR.CARD.NO)
        END
    END

    IF PGM.VERSION EQ ',REDO.AA.LTCC' AND COMI[7,6] EQ '******' THEN
        IF NOT(R.NEW(FT.TN.L.FT.CR.CARD.NO)) OR R.NEW(FT.TN.L.FT.CR.CARD.NO)[7,6] EQ '******' THEN
            COMI =  R.NEW(FT.TN.L.SUN.SEQ.NO)
        END ELSE
            COMI =  R.NEW(FT.TN.L.FT.CR.CARD.NO)
        END
    END


    CREDIT.CARD.ID  = COMI
    CREDIT.CARD.BIN = CREDIT.CARD.ID[1,6]
    CREDIT.CARD.ID  = FMT(CREDIT.CARD.ID, 'R%19')

    CALL CACHE.READ(FN.REDO.CARD.BIN, CREDIT.CARD.BIN, R.REDO.CARD.BIN, Y.ERR)

* Get Transaction' Currency
    IF APPLICATION EQ 'REDO.FT.TT.TRANSACTION' THEN
        TXN.CURRENCY = R.NEW(FT.TN.CURRENCY.MKT.CR)
        Y.LET = 'F'
        Y.OVERRIDE = FT.TN.OVERRIDE
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
        R.NEW(FT.TN.L.FT.CR.ACCT.NO) = WS.DATA<3>[4,16]
* Bal In Local Curncy
        R.NEW(FT.TN.L.FT.BAL.IN.LCY) = WS.DATA<28>
* Bal In Usd
        R.NEW(FT.TN.L.FT.BAL.IN.USD) = WS.DATA<29>
* Min Pay Local Curncy
        R.NEW(FT.TN.L.FT.MINPAY.LCY) = WS.DATA<6> + WS.DATA<26>
* Minimum Pay Usd
        R.NEW(FT.TN.L.FT.MINPAY.USD) = WS.DATA<7> + WS.DATA<27>
* Payment Due Date
        R.NEW(FT.TN.L.FT.PAY.DUE.DT) = WS.DATA<8>

        GOSUB CHECK.STATUS

* Card Holder Name
        R.NEW(FT.TN.L.FT.CLIENT.NME) = WS.DATA<11>
* Client Code
        Y.GET.CC.CODE = FIELD(WS.DATA<12>,'/',1)
        Y.GET.CC.CODE = TRIM(Y.GET.CC.CODE,'0','L')
        R.NEW(FT.TN.FT.CLIENT.COD) = Y.GET.CC.CODE
* Numero Identificacion
        R.NEW(FT.TN.L.FT.DOC.NUM) = WS.DATA<13>
* Tipo de Identificacion
        Y.TIPO.DOC = WS.DATA<14>
        IF Y.TIPO.DOC THEN
            R.NEW(FT.TN.L.FT.DOC.DESC) = WS.DATA<14>
        END ELSE
* TODO Confirmar - Default temporal
            R.NEW(FT.TN.L.FT.DOC.DESC) = "CEDULA"
        END
* Msg Det
        R.NEW(FT.TN.L.FT.MSG.DESC) = 'TRANSACCION PROCESADA CORRECTAMENTE'
        R.NEW(FT.TN.L.FT.MSG.CODE) = ''

* Vplus Internal Credit Card Number
        R.NEW(FT.TN.L.SUN.SEQ.NO) = COMI
        Y.CC.CARD.VAL = COMI:' - ':WS.DATA<12>:' - ':WS.DATA<11>
* Enmask CC Number
        COMI = COMI[1,6] : '******' : COMI[13,4]

        R.NEW(FT.TN.L.FT.CR.CARD.NO) = COMI

        ID.COMPORTAMIENTO = WS.DATA<35>

* Fix for PACS00424073 [ACH Vision Plus Payment]

        IF (PGM.VERSION EQ ',CARD.IN' OR PGM.VERSION EQ ',REDO.VP.DIRECT.DEBIT') AND (ID.COMPORTAMIENTO EQ 1 OR ID.COMPORTAMIENTO EQ 2) THEN
            CALL REDO.S.NOTIFY.INTERFACE.ACT('VPL003', 'ONLINE', '04', 'Email ':Y.CC.CARD.VAL:' TRANSACCION RECHAZADA-WS MASTERDATA', ' ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '')
            AF = FT.TN.L.FT.CR.CARD.NO
*            AV = CR.CARD.NO
            ETEXT = 'ST-VP-NO.CARD.PAY'
            CALL STORE.END.ERROR
            RETURN
        END

* End of Fix

        IF VP.FLAG EQ 1 AND (ID.COMPORTAMIENTO EQ 1 OR ID.COMPORTAMIENTO EQ 2) THEN
            AF = FT.TN.L.FT.CR.CARD.NO
*            AV = CR.CARD.NO
            ETEXT = 'ST-VP-NO.CARD.PAY'
            CALL STORE.END.ERROR
            RETURN
        END ELSE
            BEGIN CASE
                CASE ID.COMPORTAMIENTO EQ 1 ;* No Acepta Pago
                    AF = FT.TN.L.FT.CR.CARD.NO
*                AV = CR.CARD.NO
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
        AF = FT.TN.L.FT.CR.CARD.NO
        ETEXT = 'ST-VP-NO.CARD.PAY'
        CALL STORE.END.ERROR
        RETURN
    END

    IF PGM.VERSION EQ ',REDO.AA.LTCC' THEN
        ETEXT = 'ST-INVALID.CARD.NUM'
        AF = FT.TN.L.FT.CR.CARD.NO
        CALL STORE.END.ERROR
        RETURN
    END

* Credit Card Account
    R.NEW(FT.TN.L.FT.CR.CARD.NO) = ''
* Bal In Local Curncy
    R.NEW(FT.TN.L.FT.BAL.IN.LCY) = ''
* Bal In Usd
    R.NEW(FT.TN.L.FT.BAL.IN.USD) = ''
* Min Pay Local Curncy
    R.NEW(FT.TN.L.FT.MINPAY.LCY) = ''
* Minimum Pay Usd
    R.NEW(FT.TN.L.FT.MINPAY.USD) = ''
* Payment Due Date
    R.NEW(FT.TN.L.FT.PAY.DUE.DT) = ''
* Ccard Status
    R.NEW(FT.TN.L.FT.CR.CRD.STS) = ''
* Account Status
    R.NEW(FT.TN.L.FT.AC.STATUS) = ''
* Card Holder Name
    R.NEW(FT.TN.L.FT.CLIENT.NME) = ''
* Client Code
    R.NEW(FT.TN.FT.CLIENT.COD) = ''
* Numero Identificacion
    R.NEW(FT.TN.L.FT.DOC.NUM) = ''
* Tipo de Identificacion
    R.NEW(FT.TN.L.FT.DOC.DESC) = ''
* Msg Det
    R.NEW(FT.TN.L.FT.MSG.DESC) = FIELD(WS.DATA<2>,' - ',2)
    R.NEW(FT.TN.L.FT.MSG.CODE) = FIELD(WS.DATA<2>,' - ',1)
    IF NOT(R.NEW(FT.TN.L.FT.MSG.CODE)) OR R.NEW(FT.TN.L.FT.MSG.CODE) EQ 'OFFLINE'  THEN
        R.NEW(FT.TN.L.FT.MSG.CODE) = "000000"
    END
* Vplus Internal Credit Card Number
    R.NEW(FT.TN.L.SUN.SEQ.NO) = ''

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
        R.NEW(FT.TN.L.FT.BAL.IN.LCY) = WS.DATA<4>
    END ELSE
* Error handling (ERROR/OFFLINE)
* IF WS.DATA<1> EQ 'ERROR' AND OFS$OPERATION EQ 'PROCESS' THEN
        IF VP.FLAG NE 1 THEN
            TEXT = "ST-VP-NO.ONLINE.AVAIL" : @FM : WS.DATA<2>
            AF = FT.TN.L.FT.BAL.IN.LCY

            IF R.NEW(FT.TN.OVERRIDE) THEN
                Y.OV.POS = DCOUNT(R.NEW(FT.TN.OVERRIDE), @VM) + 1
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
    IF APPLICATION EQ 'REDO.FT.TT.TRANSACTION' THEN
        AF = FT.TN.DEBIT.CURRENCY
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

    R.NEW(FT.TN.L.FT.CR.CRD.STS) = CC.STATUS.DESC

* Account Status
    ACCT.STATUS = WS.DATA<10>
    ACCT.STATUS.DESC = ''

    LOCATE ACCT.STATUS IN R.REDO.VPLUS.MAPPING<VP.MAP.VP.STATUS.CODE,1> SETTING ACCT.STATUS.POS THEN
        ACCT.STATUS.DESC = R.REDO.VPLUS.MAPPING<VP.MAP.STATUS.DESC,ACCT.STATUS.POS>
    END ELSE
        ACCT.STATUS.DESC = ACCT.STATUS
    END

    R.NEW(FT.TN.L.FT.AC.STATUS) = ACCT.STATUS.DESC

RETURN

* </region>

END
