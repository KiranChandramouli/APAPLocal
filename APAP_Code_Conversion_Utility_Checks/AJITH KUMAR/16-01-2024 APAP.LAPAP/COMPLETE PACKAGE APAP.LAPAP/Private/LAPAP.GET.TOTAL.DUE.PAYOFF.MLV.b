* @ValidationCode : MjotOTQxMDMyOTYwOkNwMTI1MjoxNjkzMjk2MDIzNzQ0OjMzM3N1Oi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 29 Aug 2023 13:30:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>16</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.GET.TOTAL.DUE.PAYOFF.MLV
***********************************************************
* Ofermin - 02/10/21
* PAGO DE CANCELACION MLV:
* Hacer dos request al plan 10003 y 10004
* Sumar el campo AZXTQO-TOTAL-DUE para saber el total adeudado a la fecha
* VERSIONES: TELLER,LAPAP.PAYOFF.CANCEL.MLV.CASHIN,TELLER,LAPAP.PAYOFF.CANCEL.MLV.CHQOBCO,
* TELLER,LAPAP.PAYOFF.CANCEL.MLV.ACCT.TFR
* EB.API,RAD>LAPAP.WS.VPLUS.T24.MLV
* jars/LAPAP/ws-vplus-t24-mlv.jar
***********************************************************
*Errores Y.CAJJJ.ERROR
*1 Fatal error creating thread
*2 Cannot create JVM
*3 Cannot find class
*4 Unicode conversion error
*5 Cannot find method
*6 Cannot find object constructor
*7 Cannot instantiate object
*************************************************************
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*29/08/2023      Suresh                     R22 Manual Conversion          BP FILE REMOVED
*----------------------------------------------------------------------------------------

    $INSERT I_EQUATE ;*R22 Manual Conversion - START
    $INSERT I_COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_GTS.COMMON
    $INSERT I_F.DATES
*    $INSERT I_LAPAP.MLV.COM ;*R22 Manual Conversion - line commented - END

    GOSUB LOAD.VARIABLES
*Si el flag es true, puedo procesar, asi se evita multiples llamadas a RabbitMQ -JQ.
*    IF B.PUEDO.PROCESAR = 'true' THEN
    IF B.PUEDO.PROCESAR EQ 'true' THEN;* R22 UTILITY AUTO CONVERSION
        GOSUB INIT

    END

RETURN

LOAD.VARIABLES:
***************
    B.PUEDO.PROCESAR = 'true';

    Y.TOTAL.DUE.CARD.MLV = 0;

    Y.PLANES10003           = "";
    Y.RESPONSE.PLAN.10003   = "";
    Y.CALLJ.ERROR.PLAN10003 = "";
    Y.CALLJ.ERROR.PLAN10004 = "";

    Y.PLANES10004 = "";
    Y.RESPONSE.PLAN.10004 = "";

    Y.TOTAL.DUE.PLAN10003 = 0;
    Y.TOTAL.DUE.PLAN10004 = 0;
    Y.DATETIME = R.DATES(EB.DAT.TODAY)
    Y.DATETIME = "20220519"
    Y.CREDIT.CARD.MLV = "";

    Y.EB.API.ID         = "LAPAP.GET.CARD.INFO.MLV"
    Y.EB.API.ID.BALANCE = "LAPAP.GET.CARD.BALANCE.MLV"
    Y.ORG               = "320"

    Y.LOCAL.REF = 'LOCAL.REF';
    Y.LOCAL.FIELDS = '';
    Y.LOCAL.FIELDS.POS = '';

    Y.LOCAL.FIELDS<1,1>   = 'L.TT.CR.ACCT.NO'
    Y.LOCAL.FIELDS<1,2>   = 'L.TT.CR.CARD.NO'
    Y.LOCAL.FIELDS<1,3>   = 'L.TT.MSG.DESC'
    Y.LOCAL.FIELDS<1,4>   = 'ARN.MLV'
    Y.LOCAL.FIELDS<1,5>   = 'L.TT.CLIENT.NME'
    Y.LOCAL.FIELDS<1,6>   = 'L.TT.PAY.DUE.DT'
    Y.LOCAL.FIELDS<1,7>   = 'L.TT.CR.CRD.STS'
    Y.LOCAL.FIELDS<1,8>   = 'L.TT.AC.STATUS'
    Y.LOCAL.FIELDS<1,9>   = 'L.TT.CLIENT.COD'
    Y.LOCAL.FIELDS<1,10>  = 'L.TT.DOC.NUM'
    Y.LOCAL.FIELDS<1,11>  = 'L.TT.DOC.DESC'

    CALL EB.FIND.FIELD.NO(APPLICATION, Y.LOCAL.REF)
    CALL MULTI.GET.LOC.REF(APPLICATION, Y.LOCAL.FIELDS, Y.LOCAL.FIELDS.POS)

    CR.ACCT.NO.POS  = Y.LOCAL.FIELDS.POS<1,1>
    CR.CARD.NO      = Y.LOCAL.FIELDS.POS<1,2>
    MSG.DESC.POS    = Y.LOCAL.FIELDS.POS<1,3>
    ARN.MLV         = Y.LOCAL.FIELDS.POS<1,4>
    CLIENT.NME.POS  = Y.LOCAL.FIELDS.POS<1,5>
    PAY.DUE.DT.POS  = Y.LOCAL.FIELDS.POS<1,6>
    CR.CRD.STS.POS  = Y.LOCAL.FIELDS.POS<1,7>
    AC.STATUS.POS   = Y.LOCAL.FIELDS.POS<1,8>
    CLIENT.COD.POS  = Y.LOCAL.FIELDS.POS<1,9>
    DOC.NUM.POS     = Y.LOCAL.FIELDS.POS<1,10>
    DOC.DESC.POS    = Y.LOCAL.FIELDS.POS<1,11>

    IF COMI[7,1] EQ '*' THEN
*Establezco el flag como false, asi evito multiples llamadas innecesarias a RabbitMQ -JQ.
        B.PUEDO.PROCESAR = 'false';
        RETURN
    END
    ELSE
        Y.CREDIT.CARD.MLV = COMI;
    END

    Y.CREDIT.CARD.MLV = "000":Y.CREDIT.CARD.MLV;
    COMI = COMI[1,6] : '******' : COMI[13,4]

RETURN

INIT:
*****
    GOSUB GET.CARD.INFO
    GOSUB GET.TOTAL.DUE.PLAN10003
    GOSUB GET.TOTAL.DUE.PLAN10004
    GOSUB MERGE.SUM.PLANS

    IF (Y.TOTAL.DUE.CARD.MLV GT 0) THEN
        R.NEW(Y.LOCAL.REF)<1,MSG.DESC.POS>   = 'EL MONTO TOTAL A PAGAR ES: ' : Y.TOTAL.DUE.CARD.MLV
    END
    ELSE
        R.NEW(Y.LOCAL.REF)<1,MSG.DESC.POS>        = "NO TIENE MONTO PENDIENTE";
    END

RETURN

GET.TOTAL.DUE.PLAN10003:
************************

*1003: No facturado de avance de efectivo
    Y.TOTAL.PLAN10003 = 0;
    Y.ACCOUNT.MLV = R.NEW(Y.LOCAL.REF)<1,CR.ACCT.NO.POS>

    IF (Y.ACCOUNT.MLV NE "") THEN
        Y.PARAMETRO = '{"ORG": 320,"ACCT_NBR":"':Y.ACCOUNT.MLV:'","PLN_NBR":"10003","PMT_DATE":"':Y.DATETIME:'"}';

        CALL EB.CALL.JAVA.API(Y.EB.API.ID, Y.PARAMETRO, Y.RESPONSE, Y.CALLJ.ERROR.PLAN10003);

        IF Y.CALLJ.ERROR.PLAN10003 GT 0 OR Y.RESPONSE EQ "Error consultando Webservices" THEN
            MESSAGE = "Error consultando planes 10004"
            E = MESSAGE
            ETEXT = E
            CALL ERR
            RETURN
        END ELSE

            Y.RESPONSE.PLAN.10003 = Y.RESPONSE
            CHANGE '{'  TO ''  IN Y.RESPONSE.PLAN.10003
            CHANGE '},' TO @FM IN Y.RESPONSE.PLAN.10003
            CHANGE ','  TO @VM IN Y.RESPONSE.PLAN.10003
            CHANGE ':'  TO @SM IN Y.RESPONSE.PLAN.10003

            Y.CANT.10003 = DCOUNT(Y.RESPONSE.PLAN.10003, @FM)

            IF Y.RESPONSE EQ "[]" THEN
                Y.CANT.10003 = 0
            END

            FOR CONTA=1 TO Y.CANT.10003 STEP 1

                Y.VALOR= Y.RESPONSE.PLAN.10003<CONTA,10,2>
                Y.ARN=   Y.RESPONSE.PLAN.10003<CONTA,9,2>

                CHANGE '"'  TO '' IN Y.VALOR
                CHANGE '}]' TO '' IN Y.VALOR

                Y.TOTAL.PLAN10003 = Y.VALOR * 1
                Y.TOTAL.PLAN10003 = OCONV(Y.TOTAL.PLAN10003,'MR2')

                IF Y.TOTAL.PLAN10003 GT 0 THEN
                    R.NEW(TT.TE.LOCAL.REF)<1,ARN.MLV,CONTA> = "10003" : "|" : Y.ARN : "|" :  Y.TOTAL.PLAN10003
                    Y.TOTAL.DUE.PLAN10003 = Y.TOTAL.DUE.PLAN10003 + Y.TOTAL.PLAN10003
                END

            NEXT CONTA
        END
    END
RETURN

GET.TOTAL.DUE.PLAN10004:
***********************
*1004: No facturado de compra en comercios

    Y.TOTAL.PLAN10004 = 0;
    Y.ACCOUNT.MLV = R.NEW(Y.LOCAL.REF)<1,CR.ACCT.NO.POS>

    IF (Y.ACCOUNT.MLV NE "") THEN
        Y.PARAMETRO = '{"ORG": 320,"ACCT_NBR":"':Y.ACCOUNT.MLV:'","PLN_NBR":"10004","PMT_DATE":"':Y.DATETIME:'"}';

        CALL EB.CALL.JAVA.API(Y.EB.API.ID, Y.PARAMETRO, Y.RESPONSE.10004, Y.CALLJ.ERROR.PLAN10004);

        IF Y.CALLJ.ERROR.PLAN10004 GT 0 OR Y.RESPONSE.10004 EQ "Error consultando Webservices" THEN
            MESSAGE = "Error consultando planes 10004"
            E = MESSAGE
            ETEXT = E
            CALL ERR
            RETURN
        END ELSE

            Y.RESPONSE.PLAN.10004 = Y.RESPONSE.10004
            CHANGE '{'  TO ''  IN Y.RESPONSE.PLAN.10004
            CHANGE '},' TO @FM IN Y.RESPONSE.PLAN.10004
            CHANGE ','  TO @VM IN Y.RESPONSE.PLAN.10004
            CHANGE ':'  TO @SM IN Y.RESPONSE.PLAN.10004

            Y.CANT = DCOUNT(Y.RESPONSE.PLAN.10004, @FM)

            IF Y.RESPONSE.10004 EQ "[]" THEN
                Y.CANT = 0
            END

            FOR CONTA = 1 TO Y.CANT STEP 1

                Y.VALOR= Y.RESPONSE.PLAN.10004<CONTA,10,2>
                Y.ARN=   Y.RESPONSE.PLAN.10004<CONTA,9,2>

                CHANGE '"'  TO '' IN Y.VALOR
                CHANGE '}]' TO '' IN Y.VALOR

                Y.TOTAL.PLAN10004 = Y.VALOR * 1
                Y.TOTAL.PLAN10004 = OCONV(Y.TOTAL.PLAN10004,'MR2')

                IF Y.TOTAL.PLAN10004 GT 0 THEN
                    R.NEW(TT.TE.LOCAL.REF)<1,ARN.MLV,CONTA + Y.CANT.10003> = "10004" : "|" : Y.ARN : "|" :  Y.TOTAL.PLAN10004
                    Y.TOTAL.DUE.PLAN10004 = Y.TOTAL.DUE.PLAN10004 + Y.TOTAL.PLAN10004
                END

            NEXT CONTA
        END
    END
RETURN

MERGE.SUM.PLANS:
**************
    Y.TOTAL.DUE.CARD.MLV = Y.TOTAL.DUE.PLAN10003 + Y.TOTAL.DUE.PLAN10004;
RETURN


GET.CARD.INFO:
************************
    Y.PARAMETRO.CARD.INFO = '{"Numero_tarjeta":"': Y.CREDIT.CARD.MLV:'","Canal_id":"T24"}'

    CALL EB.CALL.JAVA.API(Y.EB.API.ID.BALANCE, Y.PARAMETRO.CARD.INFO, Y.RESPONSE.CARD.INFO, Y.CALLJ.ERROR.CARD.INFO);

    IF Y.CALLJ.ERROR.CARD.INFO GT 0 OR Y.RESPONSE.CARD.INFO EQ "Error consultando informacion de la tarjeta" THEN
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

        Y.CUSTOMER.CODE = FIELD(CHANGE(Y.RESPONSE.CARD.INFO.MLV<1,34,2>,'"',''),'/',1)

        Y.CARD.HOLDER    = CHANGE(Y.RESPONSE.CARD.INFO.MLV<1,30,2>,'"','')
        Y.ACCOUNT.CARD   = CHANGE(CHANGE(Y.RESPONSE.CARD.INFO.MLV<1,37,2>,'"',''),'}','')
        Y.PAY.DUE.DT.POS = CHANGE(CHANGE(CHANGE(Y.RESPONSE.CARD.INFO.MLV<1,19,2>,'"',''),'T00',''),'-','')
        Y.CR.CRD.STS.POS = CHANGE(Y.RESPONSE.CARD.INFO.MLV<1,27,2>,'"','')
        Y.AC.STATUS.POS  = CHANGE(Y.RESPONSE.CARD.INFO.MLV<1,26,2>,'"','')
        Y.CLIENT.COD.POS = Y.CUSTOMER.CODE<1> * 1
        Y.DOC.NUM.POS    = CHANGE(Y.RESPONSE.CARD.INFO.MLV<1,33,2>,'"','')
        Y.DOC.DESC.POS   = CHANGE(CHANGE(Y.RESPONSE.CARD.INFO.MLV<1,35,2>,'}',''),'"','')

        R.NEW(Y.LOCAL.REF)<1,CLIENT.NME.POS> = Y.CARD.HOLDER
        R.NEW(Y.LOCAL.REF)<1,CR.ACCT.NO.POS> = Y.ACCOUNT.CARD
        R.NEW(Y.LOCAL.REF)<1,PAY.DUE.DT.POS> = Y.PAY.DUE.DT.POS
        R.NEW(Y.LOCAL.REF)<1,CR.CRD.STS.POS> = Y.CR.CRD.STS.POS
        R.NEW(Y.LOCAL.REF)<1,AC.STATUS.POS>  = Y.AC.STATUS.POS
        R.NEW(Y.LOCAL.REF)<1,CLIENT.COD.POS> = Y.CLIENT.COD.POS
        R.NEW(Y.LOCAL.REF)<1,DOC.NUM.POS>    = Y.DOC.NUM.POS
        R.NEW(Y.LOCAL.REF)<1,DOC.DESC.POS>   = Y.DOC.DESC.POS

    END

RETURN
