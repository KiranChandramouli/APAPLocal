* @ValidationCode : MjoyOTA0Njk1MTE6Q3AxMjUyOjE2ODU2ODkxMzY4OTA6SVRTUzotMTotMTozMzM6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 Jun 2023 12:28:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 333
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.ACCT.CREDIT.VP
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 05.04.2013
* Description  : Routine for obtaining Credit Card Information
* Type         : Validation Routine (attached to hotfield LR-28 > L.TT.CR.ACCT.NO)
* Attached to  : VERSION > TELLER Vision Plus Versions
*                VERSION > FUNDS.TRANSFER Vision Plus Versions
* Dependencies :
*---------------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
* 1.1     08.29.2014     msthandier     -                 Completing Vision+ dev
*---------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*13-04-2023              Samaran T                R22 Manual Code conversion                        CALL RTN FORMAT MODIFIED
*----------------------------------------------------------------------------------------------------------------------------
* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER

    $INSERT I_GTS.COMMON

    $INSERT I_F.REDO.CARD.BIN
    $INSERT I_F.REDO.VPLUS.MAPPING
    $USING APAP.TAM

* </region>
*RETURN - FIX-T
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************
*MG

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

    CREDIT.ACCT.ID = ''
    CREDIT.CARD.ID = ''

    Y.LOCAL.REF = 'LOCAL.REF'

    Y.LOCAL.FIELDS = ''
    Y.LOCAL.FIELDS.POS = ''

    Y.LOCAL.FIELDS<1,1>  = 'L.':Y.LET:'T.CR.CARD.NO'
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
    Y.LOCAL.FIELDS<1,15> = 'L.SUN.SEQ.NO'
    Y.LOCAL.FIELDS<1,16> = 'L.':Y.LET:'T.CR.ACCT.NO'

    CALL EB.FIND.FIELD.NO(APPLICATION, Y.LOCAL.REF)
    CALL MULTI.GET.LOC.REF(APPLICATION, Y.LOCAL.FIELDS, Y.LOCAL.FIELDS.POS)

    CR.CARD.NO.POS = Y.LOCAL.FIELDS.POS<1,1>
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
    VPL.SEQ.NO.POS = Y.LOCAL.FIELDS.POS<1,15>
    CR.CARD.ACCT = Y.LOCAL.FIELDS.POS<1,16>

    IF NOT(COMI) THEN
        COMI = R.NEW(Y.LOCAL.REF)<1,CR.CARD.ACCT>
    END
* Init L.[TF]T.CR.ACCT.NO
    CREDIT.ACCT.ID = COMI
    CREDIT.ACCT.ID = FMT(CREDIT.ACCT.ID, 'R%19')
    CREDIT.CARD.BIN = CREDIT.CARD.ID[1,6]   ;*FIX-T
    CALL CACHE.READ(FN.REDO.CARD.BIN, CREDIT.CARD.BIN, R.REDO.CARD.BIN, Y.ERR)

* Get Transaction' Currency
    IF APPLICATION EQ 'TELLER' THEN
* Get Transaction' Currency
        TXN.CURRENCY = R.NEW(TT.TE.CURRENCY.1)
        IF NOT(TXN.CURRENCY) THEN
            TXN.CURRENCY = R.NEW(TT.TE.CURRENCY.2)
        END
        Y.LET = 'T'
        Y.OVERRIDE = TT.TE.OVERRIDE
        RRCB.CURRENCIES = R.REDO.CARD.BIN<REDO.CARD.BIN.T24.CURRENCY>  ;*FIX-T
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        TXN.CURRENCY = R.NEW(FT.CURRENCY.MKT.CR)
        Y.LET = 'F'
        Y.OVERRIDE = FT.OVERRIDE
        RRCB.CURRENCIES = R.REDO.CARD.BIN<REDO.CARD.BIN.VP.CURRENCY>    ;*FIX-T
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
    IF NOT(COMI) THEN
        RETURN
    END ELSE
* Check if a Credit Card has already been set
        CREDIT.CARD.ID = R.NEW(Y.LOCAL.REF)<1,CR.CARD.NO.POS>
        IF NOT(CREDIT.CARD.ID) THEN
            GOSUB INVOKE.VP.WS.CB
        END ELSE
            Y.CC.MASK = CREDIT.CARD.ID[7,6]
            IF Y.CC.MASK NE '******' THEN
                GOSUB INVOKE.VP.WS.CB
            END
        END
    END

RETURN

**************************************************
* Invoke VP Web Service 'CONSULTA_BALANCE'
* using Credit Card Account
INVOKE.VP.WS.CB:
**************************************************
    ACTIVATION = 'WS_T24_VPLUS'

    WS.DATA = ''
    WS.DATA<1> = 'CONSULTA_BALANCE'
    WS.DATA<2> = CREDIT.ACCT.ID
*CALL REDO.S.VP.SEL.CHANNEL(APPLICATION,PGM.VERSION,Y.MAP.ID,Y.CHANNEL,Y.MON.CHANNEL)
    APAP.TAM.redoSVpSelChannel(APPLICATION,PGM.VERSION,Y.MAP.ID,Y.CHANNEL,Y.MON.CHANNEL)   ;*R22 MANAUAL CODE CONVERSION
    WS.DATA<3> = Y.CHANNEL

* Invoke VisionPlus Web Service
*APAP.TAM.REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA)
    APAP.TAM.redoVpWsConsumer(ACTIVATION, WS.DATA)   ;*R22 MANAUAL CODE CONVERSION

* Credit Card exits - Info obtained OK

    IF WS.DATA<1> EQ 'OK' THEN
* Credit Card Number
        CREDIT.CARD.ID = WS.DATA<2>[4,16]
*PACS00654727-FIX-START
        COMI=WS.DATA<3>[4,16]
        CREDIT.CARD.BIN = CREDIT.CARD.ID[1,6]   ;*FIX-T
        CALL CACHE.READ(FN.REDO.CARD.BIN, CREDIT.CARD.BIN, R.REDO.CARD.BIN, Y.ERR)

* Get Transaction' Currency
        IF APPLICATION EQ 'TELLER' THEN
* Get Transaction' Currency
            TXN.CURRENCY = R.NEW(TT.TE.CURRENCY.1)
            IF NOT(TXN.CURRENCY) THEN
                TXN.CURRENCY = R.NEW(TT.TE.CURRENCY.2)
            END
            Y.LET = 'T'
            Y.OVERRIDE = TT.TE.OVERRIDE
            RRCB.CURRENCIES = R.REDO.CARD.BIN<REDO.CARD.BIN.T24.CURRENCY>  ;*FIX-T
        END
        IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
            TXN.CURRENCY = R.NEW(FT.CURRENCY.MKT.CR)
            Y.LET = 'F'
            Y.OVERRIDE = FT.OVERRIDE
            RRCB.CURRENCIES = R.REDO.CARD.BIN<REDO.CARD.BIN.VP.CURRENCY>    ;*FIX-T
        END
        CHANGE @VM TO @FM IN RRCB.CURRENCIES
*PACS00654727-FIX-END
* Vplus Internal Credit Card Number
        R.NEW(Y.LOCAL.REF)<1,VPL.SEQ.NO.POS> = CREDIT.CARD.ID
* Enmask
        R.NEW(Y.LOCAL.REF)<1,CR.CARD.NO.POS> = CREDIT.CARD.ID[1,6] : '******' : CREDIT.CARD.ID[13,4]  ;*FIX-T
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
        Y.GET.CC.CODE = FIELD(WS.DATA<12>,'/',1)  ;*FIX-T
        Y.GET.CC.CODE = TRIM(Y.GET.CC.CODE,'0','L') ;*FIX-T
        R.NEW(Y.LOCAL.REF)<1,CLIENT.COD.POS> = Y.GET.CC.CODE ;*FIX-T

*   R.NEW(Y.LOCAL.REF)<1,CLIENT.COD.POS> = WS.DATA<12> ;*FIX-T
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
        R.NEW(Y.LOCAL.REF)<1,MSG.DESC.POS> = 'TRANSACCION PROCESADA CORRECTAMENTE' ;*FIX-T
        R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> = ''

        ID.COMPORTAMIENTO = WS.DATA<35>
        BEGIN CASE
            CASE ID.COMPORTAMIENTO EQ 1         ;* No Acepta Pago
                ETEXT = 'ST-VP-NO.CARD.PAY'
                CALL STORE.END.ERROR
                RETURN
            CASE ID.COMPORTAMIENTO EQ 2         ;* Acepta Pago con Autorizacion
*FIX-T -START
*    TEXT = 'ST-VP-NO.ONLINE.PYMNT' : FM : 'Y'
*    IF R.NEW(Y.OVERRIDE) THEN
*      Y.OV.POS = DCOUNT(R.NEW(Y.OVERRIDE), VM) + 1
*    END ELSE
*      Y.OV.POS = 1
*    END
*     CALL STORE.OVERRIDE(Y.OV.POS)
                TEXT    = 'REDO.LEGAL.STATUS'
                CURR.NO = DCOUNT(R.NEW(Y.OVERRIDE),@VM)+ 1
                CALL STORE.OVERRIDE(CURR.NO)
                RETURN
*FIX-T - END
        END CASE

        GOSUB CHECK.CC.CCY

*   GOSUB INVOKE.VP.WS.OI   ;*FIX-T
    END ELSE
        COMI = ''

* Credit Card Number
        R.NEW(Y.LOCAL.REF)<1,CR.CARD.NO.POS> = ''
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
* Vplus Internal Credit Card Number
        R.NEW(Y.LOCAL.REF)<1,VPL.SEQ.NO.POS> = ''
    END

RETURN

**************************************************
* Invoke VP Web Service 'OnlineInformation'
INVOKE.VP.WS.OI:
**************************************************
    CREDIT.CARD.BIN = CREDIT.CARD.ID[1,6]
    CREDIT.CARD.ID  = FMT(CREDIT.CARD.ID, 'R%19')

    CALL CACHE.READ(FN.REDO.CARD.BIN, CREDIT.CARD.BIN, R.REDO.CARD.BIN, Y.ERR)

* WS Invocation
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
*CALL REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA)
        APAP.TAM.redoVpWsConsumer(ACTIVATION, WS.DATA)   ;*R22 MANAUAL CODE CONVERSION
    END ELSE
        WS.DATA = ''
        WS.DATA<1> = 'ERROR'
    END

* Credit Card exits - Info obtained OK
    IF WS.DATA<1> EQ 'OK' THEN
* ONLINE Bal In Local Curncy
        R.NEW(Y.LOCAL.REF)<1,BAL.IN.LCY.POS> = WS.DATA<4>
    END ELSE
* Error handling
* IF WS.DATA<1> EQ 'ERROR' AND OFS$OPERATION EQ 'PROCESS' THEN
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

RETURN

***********************************
* Check if the currency is allowed
* for the Credit Card
CHECK.CC.CCY:
***********************************
    LOCATE TXN.CURRENCY IN RRCB.CURRENCIES SETTING TXN.CURRENCY.POS ELSE
        ETEXT = "ST-VP-NO.CCY.ALLOWED" : @FM : CREDIT.CARD.ID : @VM : TXN.CURRENCY
        IF APPLICATION EQ 'TELLER' THEN
            AF = TT.TE.CURRENCY.1
        END
        IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
            AF = FT.DEBIT.CURRENCY
        END
        CALL STORE.END.ERROR
    END

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
