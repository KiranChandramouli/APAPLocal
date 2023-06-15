* @ValidationCode : MjoxNzEwNzAyODEyOkNwMTI1MjoxNjg2MjA1NzQ1MDUxOklUU1M6LTE6LTE6MjQyNjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Jun 2023 11:59:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 2426
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.DATCUST(CU.DET.ARR)
*
* Subroutine Type : ENQUIRY ROUTINE
* Attached to     : REDO.FC.E.DATCUST
* Attached as     : NOFILE ROUTINE
* Primary Purpose : To return data to the enquiry
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* CU.DET.ARR - data returned to the enquiry
*
* Error Variables:
* ----------------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : July 17, 2010
* Gopala Krishnan R - DEFECT-2388655 - 29-DEC-2017
* Gopala Krishnan R - PACS00651129 - 08-FEB-2018
* 06-06-2023   Conversion Tool       R22 Auto Conversion     FM TO @FM AND VM TO @VM AND SM TO @SM AND I TO I.VAR AND J TO J.VAR
* 06-06-2023   ANIL KUMAR B          R22 Manual Conversion   Y.POL.NUM.POS = D.RANGE is changed Y.POL.NUM.POS = ' '
*-----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.FC.TYPEIDENT
    $INSERT I_F.REDO.FC.ENQMAIN
    $INSERT I_F.REDO.FC.ENQPARMS
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.REDO.CREATE.ARRANGEMENT


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN          ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======

*
* Y.ENQ.NAME = ENQ.SELECTION<1,1>

*  Recupera los valores de los parametros de entrada

*  El tipo de documento tendra los siguientes valores posibles:
*  CED = Cedula     - Campo local L.CU.CIDENT
*  PAS = Pasaporte  - Campo LEGAL.ID
*  RNC = RNC        - Campo L.CU.RNC

    LOCATE 'TIPO.DOC' IN D.FIELDS<1> SETTING Y.TIPO.DOCUMENTO.POS THEN
        Y.TIPO.DOCUMENTO = D.RANGE.AND.VALUE<Y.TIPO.DOCUMENTO.POS>
    END ELSE
*Y.TIPO.DOCUMENTO = D.RANGE
        Y.TIPO.DOCUMENTO = ''  ;*R22 MANUAL conversion Y.POL.NUM.POS = D.RANGE is changed Y.POL.NUM.POS = ' '
    END

    CALL F.READ(FN.REDO.FC.TYPEIDENT,Y.TIPO.DOCUMENTO,R.REDO.FC.TYPEIDENT,F.REDO.FC.TYPEIDENT,"")
    IF NOT(R.REDO.FC.TYPEIDENT) THEN

        RETURN
    END
    Y.TIPO.CLIENTE = R.REDO.FC.TYPEIDENT<FC.TI.ENQMAIN.ID>

    LOCATE 'NRO.DOC' IN D.FIELDS<1> SETTING Y.NRO.DOCUMENTO.POS THEN
        Y.NRO.DOCUMENTO = D.RANGE.AND.VALUE<Y.NRO.DOCUMENTO.POS>
    END ELSE
        Y.NRO.DOCUMENTO.POS =  ''
    END

*   Con el tipo de documento y el nro de documento se recupera el ID del cliente

    GOSUB FIND.ID
    IF NOT(R.CUSTOMER) THEN
* Error at info content

        RETURN
    END

    GOSUB GET.PARAMS
    IF NOT(R.REDO.FC.ENQMAIN) THEN
* Error at info content


        RETURN
    END

    GOSUB GET.DATA
    GOSUB END.PROCESS

RETURN          ;* from PROCESS
*-----------------------------------------------------------------------------------
* <New Subroutines>

GET.DATA:
*========
    FOR I.VAR = 1 TO COUNT.ENQPARMS
        Y.ENQPARMS.ID = Y.ENQPARMS<1,I.VAR>
        CALL F.READ(FN.REDO.FC.ENQPARMS,Y.ENQPARMS.ID,R.REDO.FC.ENQPARMS,F.REDO.FC.ENQPARMS,"")
        IF NOT(R.REDO.FC.ENQPARMS) THEN
            RETURN
        END
        GOSUB GET.DATA.DETAILS
    NEXT

RETURN
*-------------------
GET.DATA.DETAILS:
*===============
    Y.APLICACION = R.REDO.FC.ENQPARMS<FC.PG.APLICACION>
    Y.CAMPO = R.REDO.FC.ENQPARMS<FC.PG.CAMPO>
    Y.RUTINA = R.REDO.FC.ENQPARMS<FC.PG.RUTINA>
    Y.CAT.INI = R.REDO.FC.ENQPARMS<FC.PG.CATEG.INI>
    Y.CAT.FIN = R.REDO.FC.ENQPARMS<FC.PG.CATEG.FIN>
    COUNT.CAMPO = DCOUNT(Y.CAMPO,@VM)
    Y.STATUS.LOAN= ""

    FN.REDO.FC.GENERICO = "F.":Y.APLICACION
    CALL OPF(FN.REDO.FC.GENERICO, F.REDO.FC.GENERICO)
    IF Y.APLICACION NE "CUSTOMER" THEN
        GOSUB DATA.ACCT

        NRO.REGS = DCOUNT(R.CONCAT,@FM)
        GOSUB GETGATEG
        NRO.REGS = DCOUNT(R.CONCAT,@FM)
    END ELSE
        R.CONCAT = ID.CLIENT
        NRO.REGS = 1
    END
    FOR J.VAR = 1 TO NRO.REGS
        Y.ID.APP = R.CONCAT<J.VAR>
        CALL F.READ(FN.REDO.FC.GENERICO,Y.ID.APP,R.REDO.FC.GENERICO,F.REDO.FC.GENERICO,"")
        IF  Y.APLICACION EQ "AA.ARRANGEMENT" THEN
            Y.STATUS.LOAN = R.REDO.FC.GENERICO<AA.ARR.ARR.STATUS>
            Y.PROD = R.REDO.FC.GENERICO<AA.ARR.PRODUCT,1>
        END
*TUS AA Changes 20161021
*    IF (Y.STATUS.LOAN EQ "CURRENT" OR Y.STATUS.LOAN EQ "MATURED" OR Y.STATUS.LOAN EQ "EXPIRED") OR Y.APLICACION NE "AA.ARRANGEMENT" THEN
        IF (Y.STATUS.LOAN EQ "CURRENT" OR Y.STATUS.LOAN EQ "PENDING.CLOSURE" OR Y.STATUS.LOAN EQ "EXPIRED") OR Y.APLICACION NE "AA.ARRANGEMENT" THEN
*TUS END
*IF Y.PROD EQ "N3TEST" OR Y.APLICACION NE "AA.ARRANGEMENT" THEN

            CU.DET.ARR <-1> = "****":Y.APLICACION:"*":Y.ID.APP:"****"
            FOR K.VAR = 1 TO COUNT.CAMPO
                Y.CUR.CAMPO = Y.CAMPO<1,K.VAR>
                Y.CUR.RUTINA = Y.RUTINA<1,K.VAR>
                GOSUB APP.PROCESS
            NEXT
        END
    NEXT
RETURN

APP.PROCESS:

    IF Y.CUR.RUTINA THEN
        IF Y.CUR.CAMPO EQ "COLLATERAL" OR Y.CUR.CAMPO EQ "AC.HISTORY" OR Y.CUR.CAMPO EQ "AZ.HISTORY" OR Y.CUR.CAMPO EQ "AA.HISTORY"  THEN
            BEGIN CASE
                CASE Y.CUR.CAMPO EQ "COLLATERAL"
                    CU.DET.ARR <-1> = "****COLLATERAL****"
                CASE Y.CUR.CAMPO EQ "AC.HISTORY"
                    CU.DET.ARR <-1> = "****ACCOUNT HISTORY****"
                CASE Y.CUR.CAMPO EQ "AZ.HISTORY"
                    CU.DET.ARR <-1> = "****DEPOSIT HISTORY****"
                CASE Y.CUR.CAMPO EQ "AA.HISTORY"
                    CU.DET.ARR <-1> = "****LOAN HISTORY****"

            END CASE
            CALL @Y.CUR.RUTINA(Y.ID.APP,CU.DET.ARR)
        END ELSE
            Y.VALUE.FLD = R.REDO.FC.GENERICO
            CALL @Y.CUR.RUTINA(Y.ID.APP,Y.VALUE.FLD)
            IF NOT(Y.VALUE.FLD) THEN
                Y.VALUE.FLD = "NULO"
            END
            CHANGE @VM TO '_' IN Y.VALUE.FLD
            Y.VALUE.FLD =  Y.CUR.CAMPO:'*':Y.VALUE.FLD
            CU.DET.ARR <-1>= Y.VALUE.FLD
        END
    END ELSE
        GOSUB GETPOSVALFLD
        CHANGE @VM TO '_' IN Y.VALUE.FLD
        CU.DET.ARR <-1>= Y.VALUE.FLD
    END
RETURN
*==========
END.PROCESS:
*==========
* Activity report - Succesful process

RETURN
*==========
APP2.PROCESS:
*==========

    FOR Y.VAR=1 TO NRO.CATEG
        Y.CUR.CATINI = Y.CAT.INI<1,Y.VAR>
        Y.CUR.CATFIN = Y.CAT.FIN<1,Y.VAR>

        IF (Y.CATEGORY GE Y.CUR.CATINI AND Y.CATEGORY LE Y.CUR.CATFIN) OR B.VACIO THEN
            BEGIN CASE
                CASE Y.APLICACION EQ "AA.ARRANGEMENT"
                    IF R.ACCOUNT<AC.ARRANGEMENT.ID> THEN
                        R.CONCAT.AUX<-1> = R.ACCOUNT<AC.ARRANGEMENT.ID>
                    END
                CASE Y.APLICACION EQ "AZ.ACCOUNT"
                    IF R.ACCOUNT<AC.ALL.IN.ONE.PRODUCT> THEN
                        R.CONCAT.AUX<-1> = Y.CUENTA
                    END

                CASE 1
                    IF Y.CUENTA THEN
                        R.CONCAT.AUX<-1> = Y.CUENTA
                    END
            END CASE
            Y.VAR = 99
        END

    NEXT
RETURN
*=======
GETGATEG:
*=======

    NRO.CATEG = DCOUNT(Y.CAT.INI, @VM)
    R.CONCAT.AUX = ""
    B.VACIO = ""
    FOR X.VAR=1 TO NRO.REGS
        Y.CUENTA = R.CONCAT<X.VAR>
        CALL F.READ(FN.ACCOUNT,Y.CUENTA,R.ACCOUNT,F.ACCOUNT,"")
        Y.CATEGORY = R.ACCOUNT<AC.CATEGORY>
        IF NRO.CATEG EQ 0 THEN
            NRO.CATEG = 1
            B.VACIO = "TRUE"
        END
        GOSUB APP2.PROCESS
    NEXT
    R.CONCAT = R.CONCAT.AUX
RETURN

*------------------------
GETPOSVALFLD:
*===========

    Y.OPFLD = FIELD(Y.CUR.CAMPO,'.',1)
    IF Y.OPFLD EQ "L" THEN
*Campos locales
        Y.FIELD.NAME = Y.CUR.CAMPO
        Y.FIELD.NO = 0
        CALL GET.LOC.REF (Y.APLICACION,Y.FIELD.NAME,Y.FIELD.NO)
        Y.FIELDLOC.NO = Y.FIELD.NO
        Y.FIELD.NO = "LOCAL.REF"
        CALL EB.FIND.FIELD.NO(Y.APLICACION, Y.FIELD.NO)
        IF Y.FIELD.NO AND Y.FIELDLOC.NO THEN
            Y.VALUE.FLD =  R.REDO.FC.GENERICO <Y.FIELD.NO,Y.FIELDLOC.NO>
        END ELSE
            Y.VALUE.FLD = Y.CUR.CAMPO:"*NO.EXISTE"
        END

    END ELSE

*Campos de la aplicacion
        Y.FIELD.NO = Y.CUR.CAMPO
        IF Y.CUR.CAMPO EQ "@ID" THEN
            Y.VALUE.FLD = Y.ID.APP
        END ELSE
            CALL EB.FIND.FIELD.NO(Y.APLICACION, Y.FIELD.NO)
            IF Y.FIELD.NO THEN
                Y.VALUE.FLD =  R.REDO.FC.GENERICO <Y.FIELD.NO>
            END ELSE
                Y.VALUE.FLD = Y.CUR.CAMPO:"*NO.EXISTE"
            END
        END
    END
    IF NOT(Y.VALUE.FLD) THEN
        Y.VALUE.FLD = Y.CUR.CAMPO:"*NULO"
    END ELSE
        Y.VALUE.FLD = Y.CUR.CAMPO:"*":Y.VALUE.FLD
    END

RETURN
*------------------------
DATA.ACCT:
*=========

    ID.CLIENT.NEW     = ''
    ID.CLIENT.TEMP     = ''
    ID.CLIENT.SIGNER    = ''
    PRODUCT.LINE   = ''
    LINKED.APPL    = ''
    LINKED.APPL.ID   = ''
    OTHER.PARTY.ROLE  = ''
*  FN.CONCAT = "F.CUSTOMER.ACCOUNT"
*  CALL OPF(FN.CONCAT,F.CONCAT)
*  CALL F.READ(FN.CONCAT,ID.CLIENT,R.CONCAT,F.CONCAT,"")
*DEFECT-2388655 - S
*  IF R.CONCAT EQ '' THEN
*  SEL.CMD = 'SELECT ':FN.AA.ARR.CUSTOMER:' WITH OTHER.PARTY EQ ':ID.CLIENT
*  CALL EB.READLIST(SEL.CMD, ID.CLIENT, '', NO.AA.CUS, ERR.AA.CUS)
*  CALL F.READ(FN.AA.ARR.CUSTOMER,ID.CLIENT,R.AA.ARR.CUSTOMER,F.AA.ARR.CUSTOMER,ERR.AA.ARR.CUSTOMER)
*  ID.CLIENT = R.AA.ARR.CUSTOMER<AA.CUS.OWNER>
*  CALL F.READ(FN.CONCAT,ID.CLIENT,R.CONCAT,F.CONCAT,"")
*  END
*DEFECT-2388655 - E
*PACS00651129 - S
    FN.CONCAT = "F.CUSTOMER.ACCOUNT"
    CALL OPF(FN.CONCAT,F.CONCAT)
    ID.CLIENT.NEW     = ID.CLIENT
    ID.CLIENT.TEMP     = ID.CLIENT
    ID.CLIENT.SIGNER    = ID.CLIENT
    R.CONCAT.TEMP       = ''
    CUSTOMER.ROLE = ''
    SEL.CMD = 'SELECT ':FN.AA.ARR.CUSTOMER:' WITH OTHER.PARTY EQ ':ID.CLIENT
    CALL EB.READLIST(SEL.CMD, ID.CLIENT, '', NO.AA.CUS, ERR.AA.CUS)

    IF NO.AA.CUS GE 1 THEN
        ID.CLIENT = ID.CLIENT<1>
        ID.CLIENT.1 = FIELD(ID.CLIENT,'-',1)
        ID.CLIENT.2 = FIELD(ID.CLIENT,'-',1)
        CALL F.READ(FN.AA.ARR.CUSTOMER,ID.CLIENT,R.AA.ARR.CUSTOMER,F.AA.ARR.CUSTOMER,ERR.AA.ARR.CUSTOMER)
        LOCATE ID.CLIENT.NEW IN R.AA.ARR.CUSTOMER<AA.CUS.OTHER.PARTY, 1> SETTING POS1 THEN
            CUSTOMER.ROLE = R.AA.ARR.CUSTOMER<AA.CUS.ROLE,POS1>
        END

*       ID.CLIENT.TEMP = R.AA.ARR.CUSTOMER<AA.CUS.PRIMARY.OWNER>

        IF CUSTOMER.ROLE EQ 'CO-SIGNER' THEN
            CALL F.READ(FN.CONCAT,ID.CLIENT.SIGNER,R.CONCAT.TEMP,F.CONCAT,"")
            R.CONCAT<-1> = R.CONCAT.TEMP
            SEL.CMD.1 = 'SELECT ':FN.REDO.CREATE.ARRANGEMENT:' WITH ID.ARRANGEMENT EQ ':ID.CLIENT.1:' AND OTHER.PARTY EQ ':ID.CLIENT.NEW
            CALL EB.READLIST(SEL.CMD.1, ID.CLIENT.1, '', NO.REDO.CRE.ARR, ERR.REDO.CRE.ARR)
            CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,ID.CLIENT.1,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,ERR.REDO.CREATE.ARRANGEMENT)
            OTHER.PARTY.ROLE = R.REDO.CREATE.ARRANGEMENT<REDO.FC.OTHER.PARTY.ROLE>
            IF OTHER.PARTY.ROLE EQ CUSTOMER.ROLE THEN
                CALL F.READ(FN.AA.ARRANGEMENT,ID.CLIENT.2,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ERR.AA.ARRANGEMENT)
                PRODUCT.LINE = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.LINE>
                LINKED.APPL = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL>
                LINKED.APPL.ID = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
                IF PRODUCT.LINE EQ 'LENDING' AND LINKED.APPL EQ 'ACCOUNT' AND LINKED.APPL.ID NE '' THEN
                    CHANGE @VM TO @FM IN LINKED.APPL.ID
                    CHANGE @SM TO @FM IN LINKED.APPL.ID
                    R.CONCAT<-1> = LINKED.APPL.ID
                END
            END
        END ELSE
            CALL F.READ(FN.CONCAT,ID.CLIENT.TEMP,R.CONCAT.1,F.CONCAT,"")
            R.CONCAT<-1> = R.CONCAT.1
            CALL F.READ(FN.AA.ARRANGEMENT,ID.CLIENT.2,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ERR.AA.ARRANGEMENT)
            PRODUCT.LINE = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.LINE>
            LINKED.APPL = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL>
            LINKED.APPL.ID = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
            IF PRODUCT.LINE EQ 'LENDING' AND LINKED.APPL EQ 'ACCOUNT' AND LINKED.APPL.ID NE '' THEN
                CHANGE @VM TO @FM IN LINKED.APPL.ID
                CHANGE @SM TO @FM IN LINKED.APPL.ID
                R.CONCAT<-1> = LINKED.APPL.ID
            END
        END
    END ELSE
        CALL F.READ(FN.CONCAT,ID.CLIENT.TEMP,R.CONCAT.2,F.CONCAT,"")
        R.CONCAT<-1> = R.CONCAT.2
    END


    ID.CLIENT = ID.CLIENT.NEW
RETURN
*PACS00651129 - E
*---------------

GET.PARAMS:
*==========
    CALL F.READ(FN.REDO.FC.ENQMAIN,Y.TIPO.CLIENTE,R.REDO.FC.ENQMAIN,F.REDO.FC.ENQMAIN,"")
    IF NOT(R.REDO.FC.ENQMAIN) THEN
        RETURN
    END
    Y.ENQPARMS = R.REDO.FC.ENQMAIN<FC.PP.ENQPARMS.ID>
    COUNT.ENQPARMS = DCOUNT(Y.ENQPARMS,@VM)
RETURN
*-----------------------
FIND.ID:
*=======
    BEGIN CASE
        CASE Y.TIPO.DOCUMENTO EQ "CED"
            FN.REDO.FC.GENERICO = "F.CUSTOMER.L.CU.CIDENT"
        CASE Y.TIPO.DOCUMENTO EQ "PAS"
            FN.REDO.FC.GENERICO = "F.CUSTOMER.L.CU.PASS.NAT"
        CASE Y.TIPO.DOCUMENTO EQ "RNC"
            FN.REDO.FC.GENERICO = "F.CUSTOMER.L.CU.RNC"
    END CASE
*PACS00949183 - Start
    IF Y.TIPO.DOCUMENTO EQ "PAS" THEN

*SEL.CMD = 'SELECT ':FN.REDO.FC.GENERICO:' LIKE ':Y.NRO.DOCUMENTO:'...'
        SEL.CMD = 'SELECT ':FN.REDO.FC.GENERICO:' LIKE "':"'":Y.NRO.DOCUMENTO:"'":'...':'"'
*PACS00949183 - End
        LISTA.HDR = ''
        NO.REC.HEADER = ''
        RET.CODE = ''
        CALL EB.READLIST(SEL.CMD, LISTA.HDR, '', NO.REC.HEADER, RET.CODE)
        REMOVE Y.NRO.DOCUMENTO FROM LISTA.HDR SETTING POS
    END

    CALL OPF(FN.REDO.FC.GENERICO, F.REDO.FC.GENERICO)
    CALL F.READ(FN.REDO.FC.GENERICO,Y.NRO.DOCUMENTO,R.REDO.FC.GENERICO,F.REDO.FC.GENERICO,"")
    IF R.REDO.FC.GENERICO THEN
        TEMP.ID=R.REDO.FC.GENERICO<1>
        ID.CLIENT = FIELD(TEMP.ID,'*',2)
        CALL F.READ(FN.CUSTOMER,ID.CLIENT,R.CUSTOMER,F.CUSTOMER,"")
    END

RETURN

* </New Subroutines>
*-----------------------------------------------------------------------------------*
INITIALISE:
*=========
* Variables
    Y.INT.CODE = 'FC001'
    Y.INT.TYPE = 'ONLINE'
    Y.INT.INFO = 'FC'
    Y.INT.MONT = ''
    Y.INT.DESC = ''
    Y.INT.DATA = ''
    Y.INT.USER = OPERATOR
    Y.INT.EXPC = 'LOCALHOST'  ;* Temp until finding a common variable to set the current terminal which is running the proces

* Punteros

    F.CUSTOMER = ''
    FN.CUSTOMER = 'F.CUSTOMER'

    F.ACCOUNT = ''
    FN.ACCOUNT = 'F.ACCOUNT'

    FN.REDO.FC.TYPEIDENT = 'F.REDO.FC.TYPEIDENT'
    F.REDO.FC.TYPEIDENT = ''

    F.REDO.FC.ENQMAIN = ''
    FN.REDO.FC.ENQMAIN = 'F.REDO.FC.ENQMAIN'

    F.REDO.FC.ENQPARMS = ''
    FN.REDO.FC.ENQPARMS = 'F.REDO.FC.ENQPARMS'

    F.REDO.FC.GENERICO = ''
    FN.REDO.FC.GENERICO = ''

    F.AA.ARR.CUSTOMER = ''
    FN.AA.ARR.CUSTOMER = 'F.AA.ARR.CUSTOMER'

    FN.REDO.CREATE.ARRANGEMENT = 'F.REDO.CREATE.ARRANGEMENT'
    F.REDO.CREATE.ARRANGEMENT = ''

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''

    PROCESS.GOAHEAD = 1

RETURN          ;* From INITIALISE
*-----------------------------------------------------------------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.REDO.FC.TYPEIDENT, F.REDO.FC.TYPEIDENT)
    CALL OPF(FN.REDO.FC.ENQMAIN,F.REDO.FC.ENQMAIN)
    CALL OPF(FN.REDO.FC.ENQPARMS,F.REDO.FC.ENQPARMS)
    CALL OPF(FN.AA.ARR.CUSTOMER,F.AA.ARR.CUSTOMER)
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

RETURN          ;* From OPEN.FILES
*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*======================

RETURN          ;* From CHECK.PRELIM.CONDITIONS
*-----------------------------------------------------------------------------------
END
