<<<<<<< Updated upstream
* @ValidationCode : MjotNzc1NTM1MzgyOlVURi04OjE2ODkxNDMzNzU4NDE6SVRTUzotMTotMTo1MjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Jul 2023 11:59:35
* @ValidationInfo : Encoding          : UTF-8
=======
* @ValidationCode : MjotMTgwODIwMDg3MjpDcDEyNTI6MTY4NDIyMjgxODUxNzpJVFNTOi0xOi0xOjUyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:18
* @ValidationInfo : Encoding          : Cp1252
>>>>>>> Stashed changes
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 52
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.V.VAL.PYMNT.VP
*-----------------------------------------------------------------------------
* Developer    : Estalin Valerio
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 05.25.2013
* Description  : Routine for validating a new credit card payment
* Type         : Input Routine
* Attached to  : Vision Plus Transactionsal VERSIONs (TT y FT)
* Dependencies :
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who                 Reference           Description
* 1.0       03.11.2022     Estalin Valerio       -                 Initial Version
*-----------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*21-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM,IF CONDITION ADDED,< TO LT,INSERT FILE MODIFIED
*21-04-2023              Samaran T                R22 Manual Code conversion                        CALL ROUTINE FORMAT MODIFIED
*-----------------------------------------------------------------------------------------------------------------------------------------

* <region name="INSERTS">

    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_System
    $INSERT I_F.REDO.VISION.PLUS.TXN
    $INSERT I_F.DATES    ;*R22 AUTO CODE CONVERSION.END
    $USING APAP.TAM
    $USING APAP.REDOSRTN


* </region>

    IF OFS$OPERATION EQ 'PROCESS' THEN
        GOSUB INIT
        GOSUB PROCESS
    END

RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize
INIT:
***********************
    IF APPLICATION EQ 'TELLER' THEN
        Y.LET = 'T'
        Y.OVERRIDE.LOCAL.REF = TT.TE.OVERRIDE
        MONTO.TRANSACCION = R.NEW(TT.TE.AMOUNT.LOCAL.1)
<<<<<<< Updated upstream
        MONEDA = R.NEW(TT.TE.CURRENCY.2)
        
=======
>>>>>>> Stashed changes
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.LET = 'F'
        Y.OVERRIDE.LOCAL.REF = FT.OVERRIDE
        MONTO.TRANSACCION = R.NEW(FT.CREDIT.AMOUNT)
<<<<<<< Updated upstream
        MONEDA = R.NEW(FT.CREDIT.CURRENCY)
=======
>>>>>>> Stashed changes
    END

    ALLOW.OFFLINE = ''
    TXN.RESULT = ''
    R.REDO.VISION.PLUS.TXN = ''
    FN.REDO.VISION.PLUS.TXN = 'F.REDO.VISION.PLUS.TXN'
    F.REDO.VISION.PLUS.TXN = ''
    R.REDO.VISION.PLUS.TXN = ''
    REDO.VISION.PLUS.TXN.ID = ''
    CALL OPF(FN.REDO.VISION.PLUS.TXN,F.REDO.VISION.PLUS.TXN)
    TXN.VERSION = APPLICATION : PGM.VERSION
    BALANCE.MINIMO.MLV = 0
    IS.MLV.ACCOUNT = 'false';

    Y.EB.API.ID       = "LAPAP.GET.PROCESS.PAYOFF.MLV"
    Y.EB.API.ID.BALANCE = "LAPAP.GET.CARD.BALANCE.MLV"

    Y.LOCAL.REF = 'LOCAL.REF'

    Y.LOCAL.FIELDS = ''
    Y.LOCAL.FIELDS.POS = ''

    Y.LOCAL.FIELDS<1,1> = 'L.':Y.LET:'T.MSG.CODE'
    Y.LOCAL.FIELDS<1,2> = 'L.':Y.LET:'T.CR.CARD.NO'
    Y.LOCAL.FIELDS<1,3> = 'L.SUN.SEQ.NO'

    CALL EB.FIND.FIELD.NO(APPLICATION, Y.LOCAL.REF)
    CALL MULTI.GET.LOC.REF(APPLICATION, Y.LOCAL.FIELDS, Y.LOCAL.FIELDS.POS)

    MSG.CODE.POS    = Y.LOCAL.FIELDS.POS<1,1>
    CR.ACCT.NO.POS  = Y.LOCAL.FIELDS.POS<1,2>
    CR.ACC.NO.CARD  = Y.LOCAL.FIELDS.POS<1,3>

RETURN

***********************
* Main Process
PROCESS:
***********************

    IF APPLICATION EQ 'TELLER'  THEN
        BEGIN CASE
* Pago Caja Efectivo/TFR
            CASE TXN.VERSION MATCHES '...CASHIN...' OR TXN.VERSION MATCHES '...TFR...'
                GOSUB GET.CARD.INFO
                ALLOW.OFFLINE = 1
<<<<<<< Updated upstream

                IF IS.MLV.ACCOUNT EQ "true" AND MONEDA EQ "DOP"  THEN
=======
                IF IS.MLV.ACCOUNT EQ "true" THEN
>>>>>>> Stashed changes
                    IF (MONTO.TRANSACCION LT BALANCE.MINIMO.MLV) THEN
                        GOSUB PAYMENT
                    END
                    ELSE
                        APAP.TAM.redoVpCcPayment(ALLOW.OFFLINE, TXN.RESULT)    ;*R22 MANUAL CODE CONVERSION
                    END
                END
                ELSE
                    APAP.TAM.redoVpCcPayment(ALLOW.OFFLINE, TXN.RESULT)    ;*R22 MANUAL CODE CONVERSION
                END

* Pago Cheque
* Estos pagos no se registran en linea, solo por archivo monetario
            CASE TXN.VERSION MATCHES '...CHQ...'
                GOSUB SET.OFFLINE.TXN
        END CASE
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB GET.CARD.INFO
        ALLOW.OFFLINE = 1

<<<<<<< Updated upstream

        IF IS.MLV.ACCOUNT EQ "true" AND MONEDA EQ "DOP"  THEN
=======
        IF IS.MLV.ACCOUNT EQ "true" THEN
>>>>>>> Stashed changes
            IF (MONTO.TRANSACCION LT BALANCE.MINIMO.MLV) THEN
                GOSUB PAYMENT
            END
            ELSE
                APAP.TAM.redoVpCcPayment(ALLOW.OFFLINE, TXN.RESULT)    ;*R22 MANUAL CODE CONVERSION
            END
        END
        ELSE
            APAP.TAM.redoVpCcPayment(ALLOW.OFFLINE, TXN.RESULT)  ;*R22 MANUAL CODE CONVERSION
        END
    END

    IF TXN.RESULT<1> EQ 'OFFLINE' OR TXN.RESULT<1> EQ 'ERROR' THEN

        APAP.REDOSRTN.redoSNotifyInterfaceAct('VPL003', 'ONLINE', '04', 'Email PAGO SE APLICARA OFFLINE - ID: ':ID.NEW , ' ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '')    ;*R22 MANUAL CODE CONVERSION

        EXT.USER.ID = System.getVariable("EXT.EXTERNAL.USER")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN     ;*R22 AUTO CODE CONVERSION.START
            EXT.USER.ID = ""
        END   ;*R22 AUTO CODE CONVERSION.END
        IF EXT.USER.ID EQ 'EXT.EXTERNAL.USER' THEN

            TEXT    = 'ST-VP-NO.ONLINE.PYMNT'
            CURR.NO = DCOUNT(R.NEW(Y.OVERRIDE.LOCAL.REF),@VM)+ 1
            CALL STORE.OVERRIDE(CURR.NO)
        END

        FINDSTR 'EB-UNKNOWN.VARIABLE' IN E<1,1> SETTING POS.FM.OVER THEN
            DEL E<POS.FM.OVER>
        END

        GOSUB SET.OFFLINE.TXN
    END

RETURN

*************************************
* Set Transaction Offline Processing
SET.OFFLINE.TXN:
*************************************
    R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> = '000000'
RETURN

PAYMENT:
************************
    Y.PAY.REFERENCE = "00000"
    Y.CHANNEL.ID = "T24"
    Y.TRANS.CODE = "8247"
    Y.TRANS.DESC = "PAGO"
    Y.TYPE.TXN = 1
    Y.DATETIME = R.DATES(EB.DAT.TODAY)
    Y.ORG = 320

    Y.PLAN = '{"Numero_plan":"' : "" :'", "Arn":"' : "" :'", "Monto":"' : MONTO.TRANSACCION :'"}'
    Y.PARAMETROS = '{ "Numero_tarjeta":"' : Y.CREDIT.CARD.MLV :'", "Org": "':Y.ORG:'", "Canal_id": "':Y.CHANNEL.ID :'", "Fecha_hora_trans":"': Y.DATETIME :'","Referencia_pago": "': Y.PAY.REFERENCE :'", "Trans_code":"':Y.TRANS.CODE:'", "Trans_desc":"': Y.TRANS.DESC :'", "Tipo_txn":"': Y.TYPE.TXN : '", "Cantidad_cuotas":"':'1': '", "Planes":[':Y.PLAN:']}'

    CALL EB.CALL.JAVA.API(Y.EB.API.ID, Y.PARAMETROS, Y.RESPONSE, Y.CALLJ.ERROR);

    IF Y.CALLJ.ERROR GT 0 OR  Y.RESPONSE EQ "Error insertando datos en el monosin" THEN
        MESSAGE = "Error insertando en el monosin"
        E = MESSAGE
        ETEXT = E
        CALL ERR
        RETURN
    END ELSE
        Y.RESPONSE = CHANGE(Y.RESPONSE,',',@FM);
        R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> = 'XXXX'
    END

RETURN


GET.CARD.INFO:
************************
    Y.CREDIT.CARD.MLV = R.NEW(Y.LOCAL.REF)<1,CR.ACC.NO.CARD>;
    Y.CREDIT.CARD.MLV = "000":Y.CREDIT.CARD.MLV;
    Y.PARAMETRO.CARD.INFO = '{"Numero_tarjeta":"': Y.CREDIT.CARD.MLV:'","Canal_id":"T24"}'

    CALL EB.CALL.JAVA.API(Y.EB.API.ID.BALANCE, Y.PARAMETRO.CARD.INFO, Y.RESPONSE.CARD.INFO, Y.CALLJ.ERROR.CARD.INFO);

    IF Y.CALLJ.ERROR.CARD.INFO GT 0 OR Y.RESPONSE.CARD.INFO EQ "Error consultando informacion de la tarjeta" OR Y.RESPONSE.CARD.INFO EQ "-2*null" THEN
        MESSAGE = "Error consultando info de la tarjeta"
        E = MESSAGE
        ETEXT = E
        CALL ERR
        RETURN
    END ELSE

        Y.RESPONSE.CARD.INFO.MLV = Y.RESPONSE.CARD.INFO
        CHANGE '{'  TO ''  IN Y.RESPONSE.CARD.INFO.MLV
        CHANGE '},' TO @FM IN Y.RESPONSE.CARD.INFO.MLV
        CHANGE ','  TO @VM IN Y.RESPONSE.CARD.INFO.MLV
        CHANGE ':'  TO @SM IN Y.RESPONSE.CARD.INFO.MLV

        MLV.ACCOUNT = CHANGE(Y.RESPONSE.CARD.INFO.MLV<1,37,2>,'"','')

        IF (MLV.ACCOUNT NE 'null') THEN
            BALANCE.MINIMO.MLV = CHANGE(CHANGE(Y.RESPONSE.CARD.INFO.MLV<1,38,2>,'"',''),"}","")
            IS.MLV.ACCOUNT = 'true'

            IF BALANCE.MINIMO.MLV EQ 'null' THEN
                BALANCE.MINIMO.MLV = 0
            END
        END
        ELSE
            BALANCE.MINIMO.MLV = 0
        END
    END

RETURN
* </region>

END
