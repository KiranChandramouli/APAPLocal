* @ValidationCode : Mjo2MTUxODQ5NjA6Q3AxMjUyOjE2ODQyMjI4MTM1NDQ6SVRTUzotMTotMTotMTg6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -18
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.PROCESS.PAYOFF.MLV
***********************************************************
* esvalerio - 13/10/21
* PAGO DE CANCELACION MLV:
* VERSIONES: TELLER,LAPAP.PAYOFF.CANCEL.MLV.CASHIN,TELLER,LAPAP.PAYOFF.CANCEL.MLV.CHQOBCO,
* TELLER,LAPAP.PAYOFF.CANCEL.MLV.ACCT.TFR
* EB.API,RAD>LAPAP.WS.VPLUS.T24.MLV
* jars/LAPAP/ws-vplus-t24-mlv.jar
***********************************************************
* 500 PESOS! Se ve mucho doc pero luego me lo vas agradecer
***********************************************************
**Errores Y.CAJJJ.ERROR
*1 Fatal error creating thread
*2 Cannot create JVM
*3 Cannot find class
*4 Unicode conversion error
*5 Cannot find method
*6 Cannot find object constructor
*7 Cannot instantiate object
*************************************************************

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO             REFERENCE                   DESCRIPTION

* 21-APR-2023  Conversion tool      R22 Auto conversion     BP is removed in Insert File , = to EQ , FM to @FM
* 21-APR-2023    Narmadha V         R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------
    $INSERT I_EQUATE ;*R22 Auto conversion - START
    $INSERT I_COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_GTS.COMMON
    $INSERT I_F.DATES ;*R22 Auto conversion - END

*Quitar este Return Luego
*RETURN

    GOSUB LOAD.VARIABLES
    GOSUB INIT

RETURN


LOAD.VARIABLES:
***************

    Y.EB.API.ID      = "LAPAP.GET.PROCESS.PAYOFF.MLV"

    Y.LOCAL.REF = 'LOCAL.REF';
    Y.LOCAL.FIELDS = '';
    Y.LOCAL.FIELDS.POS = '';

    Y.LOCAL.FIELDS<1,1>   = 'L.TT.CR.ACCT.NO'
    Y.LOCAL.FIELDS<1,2>   = 'L.TT.CR.CARD.NO'
    Y.LOCAL.FIELDS<1,3>   = 'L.TT.MSG.DESC'
    Y.LOCAL.FIELDS<1,4>   = 'ARN.MLV'

    CALL EB.FIND.FIELD.NO(APPLICATION, Y.LOCAL.REF)
    CALL MULTI.GET.LOC.REF(APPLICATION, Y.LOCAL.FIELDS, Y.LOCAL.FIELDS.POS)

    CR.ACCT.NO.POS = Y.LOCAL.FIELDS.POS<1,1>
    CR.CARD.NO     = Y.LOCAL.FIELDS.POS<1,2>
    MSG.DESC.POS   = Y.LOCAL.FIELDS.POS<1,3>
    ARN.MLV        = Y.LOCAL.FIELDS.POS<1,4>

RETURN


INIT:
*****
    GOSUB PAYMENT
RETURN

PAYMENT:

************************
    Y.VALORES = R.NEW(Y.LOCAL.REF)<1,ARN.MLV>
    Y.CANTIDAD = DCOUNT(Y.VALORES,@SM)

    Y.CREDIT.CARD.MLV = R.NEW(Y.LOCAL.REF)<1,CR.ACCT.NO.POS>;
    Y.PAY.REFERENCE = "00000"
    Y.CHANNEL.ID = "T24"
    Y.TRANS.CODE = "8363"
    Y.TRANS.DESC = "CANCELACION"
    Y.TYPE.TXN = 1
    Y.DATETIME = R.DATES(EB.DAT.TODAY)
    Y.CANT.CUOTA = 0
    Y.ORG = 320

    FOR CONTA = 1 TO Y.CANTIDAD STEP 1
        Y.ACTUAL        = Y.VALORES<1,1,CONTA>
        Y.NUMERO.PLAN   = FIELD(Y.ACTUAL,'|',1)
        Y.ARN           = CHANGE(FIELD(Y.ACTUAL,'|',2),'"','')
        Y.MONTO         = FIELD(Y.ACTUAL,'|',3)

        IF CONTA EQ Y.CANTIDAD THEN
            Y.PLAN = '{"Numero_plan":"' : Y.NUMERO.PLAN :'", "Arn":"' : Y.ARN :'", "Monto":"' : Y.MONTO :'"}'
        END
        ELSE
            Y.PLAN = '{"Numero_plan":"' : Y.NUMERO.PLAN :'", "Arn":"' : Y.ARN :'", "Monto":"' : Y.MONTO :'"},'
        END
        Y.PLANES = Y.PLANES : Y.PLAN;
    NEXT CONTA

    Y.PARAMETROS = '{ "Numero_tarjeta":"' : Y.CREDIT.CARD.MLV :'", "Org": "':Y.ORG:'", "Canal_id": "':Y.CHANNEL.ID :'", "Fecha_hora_trans":"': Y.DATETIME :'","Referencia_pago": "': Y.PAY.REFERENCE :'", "Trans_code":"':Y.TRANS.CODE:'", "Trans_desc":"': Y.TRANS.DESC :'", "Tipo_txn":"': Y.TYPE.TXN : '", "Cantidad_cuotas":"':Y.CANT.CUOTA: '", "Planes":[':Y.PLANES:']}'

    CALL EB.CALL.JAVA.API(Y.EB.API.ID, Y.PARAMETROS, Y.RESPONSE, Y.CALLJ.ERROR);

    IF Y.CALLJ.ERROR GT 0 OR  Y.RESPONSE EQ "Error insertando datos en el monosin" THEN
        MESSAGE = "Error insertando en el monosin"
        E = MESSAGE
        ETEXT = E
        CALL ERR
        RETURN
    END ELSE
        Y.RESPONSE = CHANGE(Y.RESPONSE,',',@FM);
    END


RETURN
