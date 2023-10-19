*-----------------------------------------------------------------------------
* <Rating>605</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.VALIDAR.CUENTAS(Y.PARAM, Y.RABBIT.MQ.OUT)
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_GTS.COMMON
    $INCLUDE BP I_F.L.APAP.JSON.TO.OFS
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT TAM.BP I_F.REDO.RESTRICTIVE.LIST

    GOSUB INITIALISE
    GOSUB INITABLE
    GOSUB REQUEST
    GOSUB PROCESS.N.RESPONSE

    RETURN

INITIALISE:
    Y.ERROR = ''
    Y.ERROR<3> = 'L.APAP.PROCESS.RABBIT.JSON.REQ'

    JSON.REQUEST = ''
    JSON.RESPONSE = ''

    Y.DYN.REQUEST.KEY = ''
    Y.DYN.REQUEST.VALUE = ''
    Y.DYN.REQUEST.TYPE = ''

    Y.DYN.REQUEST.OFS.KEY = ''
    Y.DYN.REQUEST.OFS.TYPE = ''

    Y.DYN.RESPONSE.KEY = ''
    Y.DYN.RESPONSE.VALUE = ''
    Y.DYN.RESPONSE.TYPE = ''

    Y.DYN.MAPPING.IN = ''
    Y.RABBIT.MQ.IN = ''

    Y.DYN.MAPPING.OUT = ''
    Y.RABBIT.MQ.OUT = ''

    Y.OFS.IN.REQUEST = ''
    Y.OFS.IN.RESPONSE =  ''

    Y.OFS.OUT.REQUEST = ''
    Y.OFS.OUT.RESPONSE = ''

    Y.OBJECT.TYPE = ''
    Y.ADDNL.INFO = ''

    Y.REASONS = ''

    RETURN

INITABLE:

**---------------------------------------
**ABRIR LA TABLA ACCOUNT
**---------------------------------------
    FN.ACC = "FBNK.ACCOUNT"
    FV.ACC = ""
    R.ACC = ""
    ACC.ERR = ""
    CALL OPF(FN.ACC,FV.ACC)

**---------------------------------------
**ABRIR LA TABLA CUSTOMER POR RNC
**---------------------------------------
    FN.CUS.L.CU.RNC = 'F.CUSTOMER.L.CU.RNC'
    F.CUS.L.CU.RNC  = ''
    CALL OPF(FN.CUS.L.CU.RNC,F.CUS.L.CU.RNC)

**---------------------------------------
**ABRIR LA TABLA CUSTOMER POR CEDULA
**---------------------------------------
    FN.CUS.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
    F.CUS.L.CU.CIDENT  = ''
    CALL OPF(FN.CUS.L.CU.CIDENT,F.CUS.L.CU.CIDENT)

**---------------------------------------
**ABRIR LA TABLA CUSTOMER POR PASAPORTE
**---------------------------------------
    FN.CUS.LEGAL.ID = 'F.REDO.CUSTOMER.LEGAL.ID'
    F.CUS.LEGAL.ID  = ''
    CALL OPF(FN.CUS.LEGAL.ID,F.CUS.LEGAL.ID)

**--------------------------------------------
**ABRIR LA TABLA LISTA RESTRITIVA POR CEDULA
**---------------------------------------------
    FN.RES.LIST = 'FBNK.REDO.RESTRICTIVE.LIST'
    F.RES.LIST  = ''
    CALL OPF(FN.RES.LIST,F.RES.LIST)
    RETURN

REQUEST:
    IF TRIM(Y.PARAM, " ", "R") = ""  THEN
        Y.ERROR<1> = 1
        Y.ERROR<2> = "BLANK MESSAGE"
        RETURN
    END

*--------------JSON.REQUEST  = Y.PARAM----------------------------
    CALL L.APAP.JSON.STRINGIFY(Y.PARAM , JSON.REQUEST)
    Y.PARAM = ''

*----------------LOAD DYN FROM JSON ---------------------------
    CALL L.APAP.JSON.TO.DYN.OFS(JSON.REQUEST, Y.DYN.REQUEST.KEY, Y.DYN.REQUEST.VALUE, Y.DYN.REQUEST.TYPE, Y.ERROR)
    IF Y.ERROR<1> = 1 THEN
        RETURN
    END

    JSON.REQUEST = Y.DYN.REQUEST.VALUE
    CHANGE ']'  TO @VM IN JSON.REQUEST

    CANT_OBJECT = DCOUNT(JSON.REQUEST, @VM)
    FOR CONTA=1 TO CANT_OBJECT STEP 1

        Y.REGISTER= JSON.REQUEST<1,CONTA>
        CHANGE ',' TO @FM IN Y.REGISTER
        CHANGE ':' TO @VM IN Y.REGISTER

        Y.TYPE      =  CHANGE(Y.REGISTER<1,2>,'"','')
        Y.NUMBER    =  CHANGE(Y.REGISTER<2,2>,'"','')
        Y.CURRENCY  =  CHANGE(Y.REGISTER<3,2>,'"','')
        Y.AMOUNT    =  CHANGE(Y.REGISTER<4,2>,'"','')
        Y.OPERATION =  CHANGE(Y.REGISTER<5,2>,'"','')
        Y.IDTYPE    =  CHANGE(Y.REGISTER<6,2>,'"','')
        Y.IDNUMBER  =  CHANGE(CHANGE(Y.REGISTER<7,2>,'"',''),'}','' )
        Y.VAR.OPER  =  UPCASE(Y.OPERATION)

        GOSUB CONSULTAR.INFO.CUENTA
        GOSUB CONSULTAR.CLIENTE
        GOSUB CAN.DO.PROCESS

        IF Y.CAN.DO.OPERAT EQ 'true' THEN
            IF (CONTA = CANT_OBJECT) THEN
                Y.REGISTER.PROCESS = '{"type": "': Y.TYPE :'" , "number": "': Y.NUMBER :'" ,"currency": "': Y.CURRENCY :'" ,"amount": "': Y.AMOUNT :'" ,"operation": "': Y.OPERATION :'" ,"idType": "': Y.IDTYPE :'" ,"idNumber": "': Y.IDNUMBER :'","canDoOperation": ': Y.CAN.DO.OPERAT :'}'
            END
            ELSE
                Y.REGISTER.PROCESS = '{"type": "': Y.TYPE :'" , "number": "': Y.NUMBER :'" ,"currency": "': Y.CURRENCY :'" ,"amount": "': Y.AMOUNT :'" ,"operation": "': Y.OPERATION :'" ,"idType": "': Y.IDTYPE :'" ,"idNumber": "': Y.IDNUMBER :'","canDoOperation": ': Y.CAN.DO.OPERAT :'},'
            END
        END
        ELSE
            IF (CONTA = CANT_OBJECT) THEN
                Y.REGISTER.PROCESS = '{"type": "': Y.TYPE :'" , "number": "': Y.NUMBER:'" ,"currency": "': Y.CURRENCY :'" ,"amount": "': Y.AMOUNT :'" ,"operation": "': Y.OPERATION :'" ,"idType": "': Y.IDTYPE :'" ,"idNumber": "': Y.IDNUMBER :'","canDoOperation": ': Y.CAN.DO.OPERAT :',"reasons": [': Y.REASONS :']}'
            END
            ELSE
                Y.REGISTER.PROCESS = '{"type": "': Y.TYPE :'" , "number": "': Y.NUMBER :'" ,"currency": "': Y.CURRENCY :'" ,"amount": "': Y.AMOUNT :'" ,"operation": "': Y.OPERATION :'" ,"idType": "': Y.IDTYPE :'" ,"idNumber": "': Y.IDNUMBER :'","canDoOperation": ': Y.CAN.DO.OPERAT :',"reasons": [': Y.REASONS :']},'
            END
        END

        JSON.REQUEST.PROCESS<-1> = Y.REGISTER.PROCESS

    NEXT CONTA

    RETURN

*----------------- INFORMACION DE LA CUENTA ----------------------
CONSULTAR.INFO.CUENTA:

    CALL F.READ(FN.ACC,Y.NUMBER,R.ACC,FV.ACC,ACC.ERR)
    Y.POSTING.RESTRICT  = R.ACC<AC.POSTING.RESTRICT>
    Y.ACC.CUSTOMER      = R.ACC<AC.CUSTOMER>
    Y.JOINT.PRIMERO     = R.ACC<AC.JOINT.HOLDER,1>
    Y.JOINT.SEGUNDO     = R.ACC<AC.JOINT.HOLDER,2>

    CALL GET.LOC.REF("ACCOUNT", "L.AC.STATUS1", L.AC.STATUS1.POS)
    Y.L.AC.STATUS1  = R.ACC<AC.LOCAL.REF,L.AC.STATUS1.POS>

    CALL GET.LOC.REF("ACCOUNT", "L.AC.STATUS2", L.AC.STATUS2.POS)
    Y.L.AC.STATUS2  = R.ACC<AC.LOCAL.REF,L.AC.STATUS2.POS>

    CALL GET.LOC.REF("ACCOUNT", "L.AC.AV.BAL", L.AC.AV.BAL.POS)
    Y.ACC.BALANCE  = R.ACC<AC.LOCAL.REF,L.AC.AV.BAL.POS>

    RETURN

CONSULTAR.CLIENTE:
*----------------- Obtener codigo de cliente basado en el documento ----------------------
    CUSTOMER.NO = ''
    BEGIN CASE
    CASE  UPCASE(Y.IDTYPE) EQ "CEDULA"
        R.CUS.CIDENT = ''
        CALL F.READ(FN.CUS.L.CU.CIDENT,Y.IDNUMBER,R.CUS.CIDENT,F.CUS.L.CU.CIDENT,CID.ERR)
        CUSTOMER.NO = FIELD(R.CUS.CIDENT,"*",2)

    CASE  UPCASE(Y.IDTYPE) EQ "RNC"
        R.CUS.RNC = ''
        CALL F.READ(FN.CUS.L.CU.RNC,Y.IDNUMBER,R.CUS.RNC,F.CUS.L.CU.RNC,RNC.ERR)
        CUSTOMER.NO = FIELD(R.CUS.RNC,"*",2)

    CASE UPCASE(Y.IDTYPE) EQ "PASAPORTE"
        R.CUS.LEGAL = ''
        CALL F.READ(FN.CUS.LEGAL.ID,Y.IDNUMBER,R.CUS.LEGAL,F.CUS.LEGAL.ID,LEGAL.ERR)
        CUSTOMER.NO = FIELD(R.CUS.LEGAL,"*",2)

    END CASE

    RETURN

*--------------------DETERMINAR SI PUEDE TRANSACCIONAR LA CUENTA--------------------

CAN.DO.PROCESS:
    Y.CAN.DO.OPERAT = 'true'
    OPERACTION.BLOCK = ''
    MENSAJE.BLOQUEO = ''
    ID.MENSAJE = ''
    Y.REASONS = ''

    IF Y.L.AC.STATUS1 EQ '3YINACTIVE' THEN
        Y.CAN.DO.OPERAT = 'false'
        OPERACTION.BLOCK = 'ALL'
        MENSAJE.BLOQUEO = 'Account Status inactive 3 years'
        ID.MENSAJE = '1'


        Y.REASONS<-1> = '{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'

    END

    IF Y.L.AC.STATUS1 EQ 'ABANDONED' THEN
        Y.CAN.DO.OPERAT = 'false'
        OPERACTION.BLOCK = 'ALL'
        MENSAJE.BLOQUEO = 'Account Status abandoned'
        ID.MENSAJE = '2'

        IF Y.REASONS EQ "" THEN
            Y.REASONS<-1> = '{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END
        ELSE
            Y.REASONS<-1> = ',{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END

    END

    IF Y.L.AC.STATUS2 EQ 'DECEASED' THEN
        Y.CAN.DO.OPERAT = 'false'
        OPERACTION.BLOCK = 'ALL'
        MENSAJE.BLOQUEO = 'Customer is deseased'
        ID.MENSAJE = '3'

        IF Y.REASONS EQ "" THEN
            Y.REASONS<-1> = '{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END
        ELSE
            Y.REASONS<-1> = ',{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END
    END

    BEGIN CASE
    CASE Y.POSTING.RESTRICT EQ 1 AND Y.VAR.OPER EQ 'DEBIT'
        Y.CAN.DO.OPERAT = 'false'
        MENSAJE.BLOQUEO = 'Posting restrict no debit'
        ID.MENSAJE = '4'

        IF Y.REASONS EQ "" THEN
            Y.REASONS<-1> = '{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END
        ELSE
            Y.REASONS<-1> = ',{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END

    CASE Y.POSTING.RESTRICT EQ 2 AND Y.VAR.OPER EQ 'CREDIT'
        Y.CAN.DO.OPERAT = 'false'
        MENSAJE.BLOQUEO = 'Posting restrict no credit'
        ID.MENSAJE = '5'

        IF Y.REASONS EQ "" THEN
            Y.REASONS<-1> = '{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END
        ELSE
            Y.REASONS<-1> = ',{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END

    CASE Y.POSTING.RESTRICT EQ 3
        Y.CAN.DO.OPERAT = 'false'
        MENSAJE.BLOQUEO = 'Posting restrict no debit no credit'
        ID.MENSAJE = '6'

        IF Y.REASONS EQ "" THEN
            Y.REASONS<-1> = '{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END
        ELSE
            Y.REASONS<-1> = ',{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END

    CASE Y.POSTING.RESTRICT EQ 4
        Y.CAN.DO.OPERAT = 'false'
        MENSAJE.BLOQUEO = 'Posting restrict prevelac no debit no credit'
        ID.MENSAJE = '7'

        IF Y.REASONS EQ "" THEN
            Y.REASONS<-1> = '{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END
        ELSE
            Y.REASONS<-1> = ',{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END

    CASE Y.POSTING.RESTRICT EQ 5
        Y.CAN.DO.OPERAT = 'false'
        MENSAJE.BLOQUEO = 'Posting resctrict no credit Security'
        ID.MENSAJE = '8'

        IF Y.REASONS EQ "" THEN
            Y.REASONS<-1> = '{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END
        ELSE
            Y.REASONS<-1> = ',{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END

    CASE Y.POSTING.RESTRICT EQ 6 AND Y.VAR.OPER EQ 'CREDIT'
        Y.CAN.DO.OPERAT = 'false'
        MENSAJE.BLOQUEO = 'Posting restrict prevelac  no credit'
        ID.MENSAJE = '9'

        IF Y.REASONS EQ "" THEN
            Y.REASONS<-1> = '{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END
        ELSE
            Y.REASONS<-1> = ',{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END

    CASE Y.POSTING.RESTRICT EQ 50 AND Y.VAR.OPER EQ 'DEBIT'
        Y.CAN.DO.OPERAT = 'false'
        MENSAJE.BLOQUEO = 'Posting restrict no debit alert'
        ID.MENSAJE = '10'

        IF Y.REASONS EQ "" THEN
            Y.REASONS<-1> = '{"code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END
        ELSE
            Y.REASONS<-1> = ',{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END

    END CASE

*---------------------------------------------
*    VALIDAR QUE TENGA BALANCE SUFICIENTE
*--------------------------------------------

    IF Y.ACC.BALANCE < Y.AMOUNT AND Y.VAR.OPER EQ 'DEBIT' THEN
        Y.CAN.DO.OPERAT = 'false'
        MENSAJE.BLOQUEO = 'insufficient funds'
        ID.MENSAJE = '11'

        IF Y.REASONS EQ "" THEN
            Y.REASONS<-1> = '{"code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END
        ELSE
            Y.REASONS<-1> = ',{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END

    END

*--------------------------------------------------
*    VALIDAR QUE LA CUENTA PERTENECE AL CLIENTE
*--------------------------------------------------
    IF CUSTOMER.NO NE "" THEN
        IF Y.ACC.CUSTOMER EQ CUSTOMER.NO OR Y.JOINT.PRIMERO EQ CUSTOMER.NO OR Y.JOINT.SEGUNDO EQ CUSTOMER.NO THEN

        END
        ELSE
            Y.CAN.DO.OPERAT = 'false'
            MENSAJE.BLOQUEO = 'account does not belong to the customer'
            ID.MENSAJE = '12'

            IF Y.REASONS EQ "" THEN
                Y.REASONS<-1> = '{"code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
            END
            ELSE
                Y.REASONS<-1> = ',{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
            END
        END
    END
    ELSE
        Y.CAN.DO.OPERAT = 'false'
        MENSAJE.BLOQUEO = 'account does not belong to the customer'
        ID.MENSAJE = '12'

        IF Y.REASONS EQ "" THEN
            Y.REASONS<-1> = '{"code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END
        ELSE
            Y.REASONS<-1> = ',{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END

    END

*--------------------------------------------------
*    VALIDAR SI LA CUENTA EXISTE
*--------------------------------------------------
    IF Y.ACC.CUSTOMER EQ "" THEN
        Y.CAN.DO.OPERAT = 'false'
        MENSAJE.BLOQUEO = 'account does not exists'
        ID.MENSAJE = '13'

        IF Y.REASONS EQ "" THEN
            Y.REASONS<-1> = '{"code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END
        ELSE
            Y.REASONS<-1> = ',{ "code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        END
    END

*------------------------------------------------------------
*    VALIDAR SI LA CUENTA SE ENCUENTRA EN LISTA RESTRICTIVA
*------------------------------------------------------------

    SEL.CMD.RL = 'SELECT ' : FN.RES.LIST : ' WITH NUMERO.DOCUMENTO EQ ' : Y.IDNUMBER
    CALL EB.READLIST(SEL.CMD.RL, SEL.REC,'', SEL.LIST, SEL.ERR)

* DEBUG
    LOOP
        REMOVE Y.ACC.CUSTOMER.RL FROM SEL.REC SETTING TAG
    WHILE Y.ACC.CUSTOMER.RL:TAG
        Y.CAN.DO.OPERAT = 'false'
        MENSAJE.BLOQUEO = 'Account customer is on internal restrictive list'
        ID.MENSAJE = '14'
        Y.REASONS<-1> = '{"code": "':ID.MENSAJE:'", "message": "':MENSAJE.BLOQUEO:'" }'
        RETURN
    REPEAT

    RETURN

PROCESS.N.RESPONSE:
    CHANGE @FM TO '' IN JSON.REQUEST.PROCESS
    Y.RABBIT.MQ.OUT  = '[': JSON.REQUEST.PROCESS :']'
    RETURN
    RETURN
END
