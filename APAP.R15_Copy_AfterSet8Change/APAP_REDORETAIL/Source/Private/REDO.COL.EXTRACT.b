* @ValidationCode : MjoxMDYxMDIyNjkzOkNwMTI1MjoxNjkwMTc0NDM4NDEwOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 10:23:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.COL.EXTRACT(CUSTOMER.ID)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-JULY-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM ,I to I.VAR and ++ to +=
* 21-JULY-2023      Harsha                R22 Manual Conversion - Varialble not found and Added APAP.REDORETAIL                          
*------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DE.ADDRESS
    $INSERT I_REDO.COL.CUSTOMER.COMMON
    $INSERT I_F.REDO.COL.TRACE.PHONE
   
   
    GOSUB INITIALISE
    IF Y.MSG EQ "" THEN
        GOSUB PROCESS
    END
RETURN
*----------------------------
INITIALISE:         * Initialise Variables, Files, etc
*----------------------------
    Y.MSG = ''
    IF CUSTOMER.ID EQ "" THEN   ;* CUSTOMER.ID VALIDATION
        Y.MSG = "CLIENTE -&- ESTA VACIO " : @FM : CUSTOMER.ID
        Y.TABLE.ID = Y.TMPCLIENTES
        Y.PROCESS.FLAG.TABLE<1,1> = ""
        GOSUB TRACE.ERROR
        RETURN
    END

*Size of the Queue
    Y.TOTAL.INSERT = 0
    Y.SIZE =  500
    DIM LIST.INSERTS.STMT(Y.SIZE)

    Y.NO.ID = "" ;     Y.CLI.TIPO.ID = ""    ;    Y.CLI.NUM.ID = ""
    Y.CLI.PRIMER.NOMBRE     = "" ;     Y.CLI.PRIMER.APELLIDO = ""
    Y.CLI.NOM.CONYUGE = ""       ;     Y.CLI.APE.CONYUGE = ""       ;    Y.CLI.TIPO.PERSONA = ""
    Y.CLI.RAZON.SOCIAL.NOM1 = "" ;     Y.CLI.RAZON.SOCIAL.NOM2 = "" ;    Y.CLI.FECHA.NACIMIENTO = ""
    Y.CLI.LUGAR.TRABAJO = ""     ;     Y.CLI.EMAIL = ""             ;    Y.CLI.FECHA.INGRESO = ""
    Y.CLI.SEXO = ""              ;     Y.CLI.ESTADO.CIVIL = ""      ;    Y.CLI.CONTACTO = ""
    Y.CLI.TELF.CONYUGE.AREA = "" ;     Y.CLI.TELF.CONYUGE.NO = ""   ;    Y.CLI.TELF.CONYUGE.EXT = ""
    Y.CLI.NOM.REPRES = ""        ;     Y.CLI.APE.REPRES = ""        ;    Y.CLI.ID.REPRES = ""
    Y.CLI.NUM.REPRES = ""
    Y.CLI.ADD.POR = ""
    Y.CLI.FECHA.ADICION = ""
    Y.CLI.MODIF.POR = ""
    Y.CLI.FECHA.MODIF = ""
    Y.CLI.CODIGO.ORIGEN = ""
    Y.CLI.TELF.TYPE = ""
    Y.CLI.CAMPO1.09 =  ""
    Y.CLI.CAMPO2.09 = ""
    Y.CLI.CAMPO3.09 = ""
    Y.CLI.CAMPO4.09 = ""
    Y.CLI.CAMPO5.09 = ""
    Y.CLI.CAMPO6.09 = ""
    Y.CLI.TELF.AREA.10 = ""
    Y.CLI.TELF.NO.10 = ""
    Y.CLI.TELF.EXT.10 = ""
    Y.CLI.TELF.AREA.11 = ""
    Y.CLI.TELF.NO.11 = ""
    Y.CLI.TELF.AREA.13 = ""
    Y.CLI.TELF.NO.13 = ""

*lectura campos locales y cola de sucesos y opf
    C.DESC='INICIO DEL PROCESO EN REDO.COL.EXTRACT'
    GOSUB STORE.MSG.ON.QUEUE

    Y.TMPCLIENTES = 'TMPCLIENTES'
    Y.TMPTELEFONOSCLIENTE = 'TMPTELEFONOSCLIENTE'
    Y.TMPDIRECCIONESCLIENTE = 'TMPDIRECCIONESCLIENTE'

RETURN
*------------------------------
PROCESS:  * Process Each entry for the current customer
*------------------------------
*    CALL CACHE.READ('F.CUSTOMER',CUSTOMER.ID,R.CUSTOMER,YERR)
    CALL F.READ(FN.CUSTOMER, CUSTOMER.ID, R.CUSTOMER, F.CUSTOMER, YERR)
    IF YERR NE '' THEN
        Y.MSG = yRecordNotFound : @FM : CUSTOMER.ID : @VM : "F.CUSTOMER"
        Y.TABLE.ID = Y.TMPCLIENTES
        Y.PROCESS.FLAG.TABLE<1,1> = ""
        GOSUB TRACE.ERROR
        RETURN
    END

    Y.CU.SCO.COB = R.CUSTOMER<EB.CUS.LOCAL.REF,C.L.CUS.SCO.COB.POS>     ;* Get SCO.COB from Customer Table

    IF Y.PROCESS.FLAG.TABLE<1,1> EQ "TMPCLIENTES" THEN
        GOSUB CUSTOMER.STMT       ;*Ir al parrafo para extraer la informacion para la tabla de customer
    END
    IF Y.PROCESS.FLAG.TABLE<1,2> EQ "TMPTELEFONOSCLIENTE" THEN
        GOSUB PHONES.STMT         ;*Ir al Parrafo de para extraer y crear los Inserts de Phones
    END
    IF Y.PROCESS.FLAG.TABLE<1,3> EQ "TMPDIRECCIONESCLIENTE" THEN
        GOSUB ADDRESS.STMT        ;*Ir al Parrafo de para extraer y crear los Inserts de Address
    END

    IF Y.PROCESS.FLAG.TABLE<1,4> EQ "TMPMOVIMIENTOS" OR Y.PROCESS.FLAG.TABLE<1,5> EQ "TMPCREDITO"  THEN
        GOSUB PROCESS.AA          ;*Ir al Parrafo de para extraer y crear los Inserts de AA
    END

    GOSUB FINAL.WRITE.RECORD

RETURN
*-----------------------------------------------------------------------------------
GET.CUS.ID.TYPE:    *Extrae el tipo de Documento del Customer
*-----------------------------------------------------------------------------------
    BEGIN CASE
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.CI.POS> NE ""        ;*CEDULA = 1
            Y.CLI.TIPO.ID = 1
            Y.CLI.NUM.ID = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.CI.POS>

*<< PP, LEGAL.ID is mv, there was no definition, then take first position
        CASE R.CUSTOMER<EB.CUS.LEGAL.ID,1> NE ""        ;*PASAPORTE = 4
            Y.CLI.TIPO.ID = 4
            Y.CLI.NUM.ID = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
*>>

        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.RCN.POS> NE ""       ;*RCN = 2
            Y.CLI.NUM.ID = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.RCN.POS>
            Y.CLI.TIPO.ID = 2

        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.ACTANAC.POS> NE ""   ;*ACTA NACIMIENTO = 8
            Y.CLI.NUM.ID = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.ACTANAC.POS>
            Y.CLI.TIPO.ID = 8

        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.NOUNICO.POS> NE ""   ;*NUMERO UNICO = 15
            Y.CLI.NUM.ID = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.NOUNICO.POS>
            Y.CLI.TIPO.ID = 15

    END CASE

RETURN
*-----------------------
CUSTOMER.STMT:      *EXTRACT INFORMATION ABOUT CUSTOMER
*-----------------------
*ASIGNACION DEL TIPO DE DOCUMENTO
    GOSUB GET.CUS.ID.TYPE

*BUCLE PARA LA LECTURA DE RELATION.CODE PARA SABER SU CONYUGE
    Y.RELATION.CODE = R.CUSTOMER<EB.CUS.RELATION.CODE>
    NRO.REL.CODE = DCOUNT(Y.RELATION.CODE,@VM)

    I.VAR = NRO.REL.CODE
    LOOP WHILE I.VAR GE 1
        IF Y.RELATION.CODE<1,I.VAR> MATCHES "7" : @VM : "8" THEN
            Y.CUS.CODE.CONYUGE = R.CUSTOMER<EB.CUS.REL.CUSTOMER,I.VAR>
* LECTURA DE LOS CAMPOS DE CORE DEL CONYUGE
*            CALL CACHE.READ('F.CUSTOMER',Y.CUS.CODE.CONYUGE,R.CUSTOMER.CONYUGE,YERR)
            CALL F.READ(FN.CUSTOMER, Y.CUS.CODE.CONYUGE, R.CUSTOMER.CONYUGE, F.CUSTOMER, YERR)
            IF YERR NE '' THEN
                Y.MSG = yRecordNotFound : @FM : Y.CUS.CODE.CONYUGE : @VM : "F.CUSTOMER"
                Y.TABLE.ID = Y.TMPCLIENTES
                Y.PROCESS.FLAG.TABLE<1,1> = ""
                GOSUB TRACE.ERROR
                RETURN
            END
*ASIGNACION DE LA INFORMACION RESPECTO A EL CONYUGE
            Y.CLI.NOM.CONYUGE = R.CUSTOMER.CONYUGE<EB.CUS.GIVEN.NAMES>
            Y.CLI.APE.CONYUGE = R.CUSTOMER.CONYUGE<EB.CUS.FAMILY.NAME>
            Y.CLI.TELF.CONYUGE.AREA = R.CUSTOMER.CONYUGE<EB.CUS.LOCAL.REF,Y.CLI.TELF.AREA.POS,1>
            Y.CLI.TELF.CONYUGE.NO = R.CUSTOMER.CONYUGE<EB.CUS.LOCAL.REF,Y.CLI.TELF.NO.POS,1>
            Y.CLI.TELF.CONYUGE.EXT = R.CUSTOMER.CONYUGE<EB.CUS.LOCAL.REF,Y.CLI.TELF.EXT.POS,1>
        END

        IF Y.RELATION.CODE<1,I.VAR> EQ 104 THEN ;*ASIGNACION DEL TIPO DE DOCUMENTO DEL REPRESENTANTE
            Y.CUS.CODE.REPRES = R.CUSTOMER<EB.CUS.REL.CUSTOMER,I.VAR>
*            CALL CACHE.READ('F.CUSTOMER',Y.CUS.CODE.REPRES,R.CUSTOMER.REPRES,YERR)
            CALL F.READ(FN.CUSTOMER, Y.CUS.CODE.REPRES, R.CUSTOMER.REPRES, F.CUSTOMER, YERR)
            IF YERR NE '' THEN
                Y.MSG = yRecordNotFound : @FM : Y.CUS.CODE.REPRES : @VM : "F.CUSTOMER"
                Y.TABLE.ID = Y.TMPCLIENTES
                Y.PROCESS.FLAG.TABLE<1,1> = ""
                GOSUB TRACE.ERROR
                RETURN
            END
            GOSUB GET.REPRES.ID.TYPE
            Y.CLI.NOM.REPRES = R.CUSTOMER.REPRES<EB.CUS.GIVEN.NAMES>
            Y.CLI.APE.REPRES = R.CUSTOMER.REPRES<EB.CUS.FAMILY.NAME>
        END
        I.VAR -= 1
    REPEAT

*Tipo de Customer Registrado(Persona Fisica, Persona Jurida, etc...)
    Y.CLI.TIPO.PERSONA = R.CUSTOMER<EB.CUS.LOCAL.REF, Y.CLI.TIPO.CL.POS>
    NRO.REL.CODE.PER = DCOUNT(Y.CLI.TIPO.PERSONA,@SM)

* PP, take first position   for NAME.1 & NAME.2
    I.VAR = NRO.REL.CODE.PER
    LOOP WHILE I.VAR GE 1
        IF Y.CLI.TIPO.PERSONA<1,1,I.VAR> EQ 1 THEN        ;*ASIGNACION NOMBRE CLIENTE JURIDICA
            Y.CLI.RAZON.SOCIAL.NOM1 = R.CUSTOMER<EB.CUS.NAME.1, 1>
            Y.CLI.RAZON.SOCIAL.NOM2 = R.CUSTOMER<EB.CUS.NAME.2, 1>
        END  ELSE
            IF Y.CLI.TIPO.PERSONA<1,1,I.VAR> EQ 0 THEN      ;*ASIGNACION NOMBRE Y APELLIDO CLIENTE NATURAL
                Y.CLI.PRIMER.NOMBRE = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
                Y.CLI.PRIMER.APELLIDO = R.CUSTOMER<EB.CUS.FAMILY.NAME>
            END
        END
        I.VAR -= 1
    REPEAT
*Extracion de datos Generales de Customer
    Y.CLI.FECHA.NACIMIENTO = R.CUSTOMER<EB.CUS.DATE.OF.BIRTH>
* PP take first position for Employers.Name & Email, no definition available
    Y.CLI.LUGAR.TRABAJO = R.CUSTOMER<EB.CUS.EMPLOYERS.NAME, 1>
    Y.CLI.EMAIL = R.CUSTOMER<EB.CUS.EMAIL.1, 1>
    Y.CLI.FECHA.INGRESO = R.CUSTOMER<EB.CUS.CUSTOMER.SINCE>
    Y.CLI.SEXO = R.CUSTOMER<EB.CUS.GENDER>
    Y.CLI.ESTADO.CIVIL = R.CUSTOMER<EB.CUS.MARITAL.STATUS>
    Y.CLI.CONTACTO =  R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TEL.P.CONT>

*CAMPOS DE AUDITORIA DEL REGISTRO DE CUSTOMER
    Y.CLI.ADD.POR = R.CUSTOMER<EB.CUS.INPUTTER, 1>  ;* Who created the row
    Y.CLI.FECHA.ADICION = R.CUSTOMER<EB.CUS.DATE.TIME, 1>     ;* When the row was created
    Y.L.AUDIT.POS = DCOUNT(R.CUSTOMER<EB.CUS.INPUTTER>, @VM)
    Y.CLI.MODIF.POR = R.CUSTOMER<EB.CUS.INPUTTER, Y.L.AUDIT.POS>        ;* Last inputter & date
    Y.CLI.FECHA.MODIF = R.CUSTOMER<EB.CUS.DATE.TIME, Y.L.AUDIT.POS>

*Y.CLI.CODIGO.ORIGEN = "" *;Extraccion de los valores de direccion
    Y.CLI.CAMPO1.09 =  CHANGE(R.CUSTOMER<EB.CUS.ADDRESS>,@VM,' ')
    Y.CLI.CAMPO1.09 = CHANGE (Y.CLI.CAMPO1.09, @SM, ' ')
    Y.CLI.CAMPO2.09 = CHANGE(R.CUSTOMER<EB.CUS.STREET>, @VM, ' ')
    Y.CLI.CAMPO3.09 = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.CAMPO3.09.POS >
    Y.CLI.CAMPO4.09 = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.CAMPO4.09.POS >
    Y.CLI.CAMPO5.09 = R.CUSTOMER<EB.CUS.COUNTRY, 1> ;* No definition, take first position
    Y.CLI.CAMPO6.09 = R.CUSTOMER<EB.CUS.TOWN.COUNTRY, 1>      ;* No definition, take first position

* VERIFICAR CAMPO DE DIRECCION ;* cambia los espacios de la direccion almacenada en el R.CUSTOMER<EB.CUS.ADDRESS> por MV
    Y.ADDRESS.09 = CHANGE(Y.CLI.CAMPO1.09,@VM,' ')

    GOSUB GET.CUSTOMER.PHONES

*CONCATENAR INFORMACION DEL CLIENTE
    Y.RAZON.SOCIAL = Y.CLI.RAZON.SOCIAL.NOM1:' ':Y.CLI.RAZON.SOCIAL.NOM2
    Y.TEL.CONYUGE = Y.CLI.TELF.CONYUGE.AREA:' ':Y.CLI.TELF.CONYUGE.NO:' ':Y.CLI.TELF.CONYUGE.EXT
    Y.NOM.APE.REPRES = Y.CLI.NOM.REPRES:' ':Y.CLI.APE.REPRES

*DIRECCION
    Y.CAMPO.9 = Y.ADDRESS.09:' ':Y.CLI.CAMPO2.09:' ':Y.CLI.CAMPO3.09:' ':Y.CLI.CAMPO4.09:' ':Y.CLI.CAMPO5.09:' ':Y.CLI.CAMPO6.09

*TELEFONO
    Y.CAMPO.10 = Y.CLI.TELF.AREA.10:' ':Y.CLI.TELF.NO.10:' ':Y.CLI.TELF.EXT.10
    Y.CAMPO.11 = Y.CLI.TELF.AREA.11:' ':Y.CLI.TELF.NO.11
    Y.CAMPO.13 = Y.CLI.TELF.AREA.13:' ':Y.CLI.TELF.NO.13

*ESTRUCTURA DE LA INSTRUCCION INSERT DE CLIENTES
*Y.LINEA = C_DML_STMT_CLIENTES			;*R22 Manual Conversion - Varialble not found
    Y.LINEA = ""
    Y.LINEA := "1,'T24',":CUSTOMER.ID:"," : redoOracleNull(Y.CLI.TIPO.ID) : "," : redoOracleNull("'": Y.CLI.NUM.ID[1,20]:"'"):",":redoOracleNull("'":Y.CLI.PRIMER.NOMBRE[1,60]:"'"): ",NULL, "  ;*1-7
    Y.LINEA := redoOracleNull("'":Y.CLI.PRIMER.APELLIDO[1,60]:"'"):",NULL,NULL,":redoOracleNull("'":Y.CLI.NOM.CONYUGE[1,40]:"'"):",NULL,NULL,":redoOracleNull("'":Y.CLI.TIPO.PERSONA[1,1]:"'"):",":redoOracleNull("'":Y.RAZON.SOCIAL[1,200]:"'"):","        ;*8-15
    Y.LINEA := redoOracleDate(Y.CLI.FECHA.NACIMIENTO,'yyyyMMdd'): ",":redoOracleNull("'":Y.CLI.LUGAR.TRABAJO[1,250]:"'"):",":redoOracleNull("'": Y.CLI.EMAIL[1,30]:"'"):"," ;*16-18
    Y.LINEA := redoOracleDate(Y.CLI.FECHA.INGRESO,'yyyyMMdd'): ",":redoOracleNull("'": Y.CLI.SEXO[1,10]:"'"):",": redoOracleNull("'" : Y.CLI.ESTADO.CIVIL[1,30] : "'") : ","          ;*19-21
    Y.LINEA := redoOracleNull("'": Y.CLI.CONTACTO[1,300]:"'"):",":redoOracleNull("'" : Y.TEL.CONYUGE[1,10] : "'") :",NULL,NULL,":redoOracleNull(Y.CLI.ID.REPRES):",":redoOracleNull("'": Y.CLI.NUM.REPRES[1,20]:"'"):",":redoOracleNull("'": Y.NOM.APE.REPRES[1,250]:"'"):      ;*22-28
    Y.LINEA := ",NULL,":redoOracleNull("'": Y.CLI.ADD.POR[1,20]:"'"):",":redoOracleDate(Y.CLI.FECHA.ADICION,'yyMMddhh24mi'): ",":redoOracleNull("'":Y.CLI.MODIF.POR[1,20]:"'"):","    ;*29-31
    Y.LINEA := redoOracleDate(Y.CLI.FECHA.MODIF,'yyMMddhh24mi'):",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, "    ;*32-40
    Y.LINEA := redoOracleNull("'": Y.CAMPO.9[1,400]:"'"):",":redoOracleNull("'": Y.CAMPO.10[1,400]:"'"):",":redoOracleNull("'":Y.CAMPO.11[1,400]:"'"):",NULL,":redoOracleNull("'":Y.CAMPO.13[1,400]:"'"):",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, "  ;*41-54
    Y.LINEA := "NULL,NULL,NULL,NULL,NULL,NULL,NULL," : redoOracleNull("'" : Y.CU.SCO.COB : "'") : ",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, "          ;*55-76
    Y.LINEA := "NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) "    ;*77-92

    R.COL.QUEUE = ''
    R.COL.QUEUE<1> = Y.TMPCLIENTES
    R.COL.QUEUE<2> = Y.LINEA

    GOSUB WRITE.RECORD

RETURN
*-------------------
PHONES.STMT:
*-------------------
    GOSUB GET.CUSTOMER.PHONES
    IF Y.CLI.TELF.TYPE EQ "" THEN         ;*PHONE TYPE VALIDATION
        Y.MSG = "EL CLIENTE " : CUSTOMER.ID : " NO TIENE TELEFONOS REGISTRADOS "    ;* Warning Message
        CALL OCOMO(Y.MSG)
        RETURN
    END

*    CALL CACHE.READ('F.REDO.COL.TRACE.PHONE',CUSTOMER.ID,R.COL.TRACE.PHONE,Y.ERR)
    CALL F.READ(FN.REDO.COL.TRACE.PHONE, CUSTOMER.ID, R.COL.TRACE.PHONE, F.REDO.COL.TRACE.PHONE, YERR)


    Y.CLI.TELF.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TELF.TYPE.POS>
    NRO.REL.CODE.TEL = DCOUNT(Y.CLI.TELF.TYPE,@SM)

    Y.TEL.TYPE.LIST = ''
    Y.TEL.TYPE.SEQ  = ''
    I.VAR = 1
    LOOP WHILE I.VAR LE NRO.REL.CODE.TEL
*Y.INSERT.TEL = C_DML_STMT_TELEFONOS		;*R22 Manual Conversion - Varialble not found
        Y.INSERT.TEL = ""
        Y.CLI.TELF.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF, Y.CLI.TELF.TYPE.POS, I.VAR>
        IF Y.CLI.TELF.TYPE NE '' THEN
            GOSUB PROC.PHONES
        END
        I.VAR += 1
    REPEAT

RETURN

*-------------------
PROC.PHONES:
*-------------------
    IF NUM(Y.CLI.TELF.TYPE) EQ @FALSE THEN          ;* Warning Message - Phone Number is not Numeric
        Y.MSG = "EL TIPO DE TELEFONO -&- DEBE SER NUMERICO EN CLIENTE & " : @FM : Y.CLI.TELF.TYPE : @VM : CUSTOMER.ID
        CALL OCOMO(Y.MSG)
        RETURN
    END

    Y.TEL.DATE.TIME.ADD = "" ;     Y.TEL.USER          = ""    ;     Y.TEL.DATE.TIME.UPD = ""
    GOSUB GET.TEL.AUDIT.INFO

    Y.CLI.TELF.NO = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TELF.NO.POS,I.VAR>
    Y.CLI.TELF.EXT = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TELF.EXT.POS,I.VAR>
    GOSUB GET.TEL.SEQUENCE

    Y.INSERT.TEL := CUSTOMER.ID:",":Y.CLI.TELF.TYPE:"," : Y.CURR.TEL.SEQ :",":"1":",":redoOracleNull("'":Y.CLI.TELF.NO[1,56]:"'"):","
    Y.INSERT.TEL := redoOracleNull("'":Y.CLI.TELF.EXT[1,5]:"'"):",":redoOracleNull("'":Y.CLI.ADD.POR[1,20]:"'"):","
    Y.INSERT.TEL := redoOracleDate(Y.TEL.DATE.TIME.ADD,'yyMMddhh24mi'):",":redoOracleNull("'":Y.TEL.USER[1,20]:"'"):","
    Y.INSERT.TEL := redoOracleDate(Y.TEL.DATE.TIME.UPD,'yyMMddhh24mi'):",":"'":"COLLECTOR":"')"
    R.COL.QUEUE = ''
    R.COL.QUEUE<1> = Y.TMPTELEFONOSCLIENTE
    R.COL.QUEUE<2> = Y.INSERT.TEL
    GOSUB WRITE.RECORD
RETURN

*-------------------
GET.CUSTOMER.PHONES:*BUCLE PARA LA LECTURA DEL CAMPO LOCAL DEL CLIENTE CORRESPONDIENTE A TELEFONOS
*-------------------
IF Y.CLI.TELF.TYPE NE "" THEN
RETURN
END

Y.CLI.TELF.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TELF.TYPE.POS>
NRO.REL.CODE.TEL = DCOUNT(Y.CLI.TELF.TYPE,@SM)

I.VAR = NRO.REL.CODE.TEL
LOOP WHILE I.VAR GE 1
BEGIN CASE
    CASE Y.CLI.TELF.TYPE<1,1,I.VAR> EQ "05"
        Y.CLI.TELF.AREA.10 = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TELF.AREA.POS,I.VAR>
        Y.CLI.TELF.NO.10 = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TELF.NO.POS,I.VAR>
        Y.CLI.TELF.EXT.10 = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TELF.EXT.POS,I.VAR>
    CASE Y.CLI.TELF.TYPE<1,1,I.VAR> EQ "01"
        Y.CLI.TELF.AREA.11 = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TELF.AREA.POS,I.VAR>
        Y.CLI.TELF.NO.11 = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TELF.NO.POS,I.VAR>
    CASE Y.CLI.TELF.TYPE<1,1,I.VAR> EQ "06"
        Y.CLI.TELF.AREA.13 = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TELF.AREA.POS,I.VAR>
        Y.CLI.TELF.NO.13 = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TELF.NO.POS,I.VAR>
END CASE
I.VAR -= 1
REPEAT
RETURN
*-------------
ADDRESS.STMT:       *OBTENER TMPCLIENTEDIRECCIONES   18-inicio
*-------------
    Y.CLI.COD.EMPRESA = 1
    Y.CLI.COD.CLIENTE = CUSTOMER.ID
    Y.CLI.REFER.GEOGRAFICA = 1
*GET TMPDirClienteModificaco
    Y.CLI.DIR.MODIFICADO = 0

* BUILD THE QUERY TO GET THE ADDRESS ID'S  19- inicio
    Y.ADDRESS = ID.COMPANY : ".C-" : CUSTOMER.ID : ".PRINT."  ;*GB0010001.C-100589.PRINT..
    Y.SEQ = 1

    LOOP WHILE Y.SEQ > 0 DO
        Y.DE.ADDRESS.LIST.ID = Y.ADDRESS:Y.SEQ
*        CALL CACHE.READ('F.DE.ADDRESS',Y.DE.ADDRESS.LIST.ID,R.DE.ADDRESS,YERR)
        CALL F.READ(FN.DE.ADDRESS, Y.DE.ADDRESS.LIST.ID,R.DE.ADDRESS, F.DE.ADDRESS, YERR)

        IF YERR NE '' AND Y.SEQ EQ 1 THEN
            Y.MSG = yRecordNotFound : @FM : Y.DE.ADDRESS.LIST.ID : @VM : ' DE.ADDRESS APPLICATION'
            Y.TABLE.ID = Y.TMPDIRECCIONESCLIENTE
            Y.PROCESS.FLAG.TABLE<1,3> = ""
            GOSUB TRACE.ERROR
            RETURN
        END
        IF YERR NE '' THEN
            Y.SEQ = 0
            RETURN        ;*CONTINUE
        END
*        CALL CACHE.READ('F.DE.ADDRESS$HIS',Y.DE.ADDRESS.LIST.ID:";1",R.DE.ADDRESS.OLD,YERR)
        R.DE.ADDRESS.OLD = ''
        CALL F.READ(FN.DE.ADDRESS$HIS, Y.DE.ADDRESS.LIST.ID:";1", R.DE.ADDRESS.OLD, F.DE.ADDRESS$HIS, YERR)
        IF YERR NE '' THEN
* It could be the first record
        END

        Y.CLI.COUNTRY = R.DE.ADDRESS<DE.ADD.COUNTRY,1>          ;* PACS00169639
        Y.CLI.COUNTRY.TOWN =  R.DE.ADDRESS<DE.ADD.TOWN.COUNTY,1>          ;* PACS00169639
        Y.L.AUD.POSITION = DCOUNT(R.DE.ADDRESS<DE.ADD.INPUTTER>, @VM)
        Y.CLI.INPUTTER.LAST = R.DE.ADDRESS<DE.ADD.INPUTTER, Y.L.AUD.POSITION>
        Y.CLI.DATE.TIME.LAST = R.DE.ADDRESS<DE.ADD.DATE.TIME, Y.L.AUD.POSITION>

        IF R.DE.ADDRESS.OLD NE "" THEN
            Y.CLI.INPUTTER.ADD = R.DE.ADDRESS.OLD<DE.ADD.INPUTTER, 1>
            Y.CLI.DATE.TIME.ADD = R.DE.ADDRESS.OLD<DE.ADD.DATE.TIME, 1>
        END ELSE
            Y.CLI.INPUTTER.ADD = R.DE.ADDRESS<DE.ADD.INPUTTER, 1>
            Y.CLI.DATE.TIME.ADD = R.DE.ADDRESS<DE.ADD.DATE.TIME, 1>
        END

        Y.CLI.TIPO.DIRECCION = R.DE.ADDRESS<DE.ADD.LOCAL.REF,Y.CLI.TIPO.DIRECCION.POS>
        Y.CLI.APR.POSTAL = R.DE.ADDRESS<DE.ADD.LOCAL.REF,Y.CLI.APR.POSTAL.POS>
        Y.CLI.NO.DIRECCION = R.DE.ADDRESS<DE.ADD.LOCAL.REF,Y.CLI.NO.DIRECCION.POS>
        Y.MSG = ""
*20.4
        IF Y.CLI.TIPO.DIRECCION NE '' THEN
            GOSUB PROCESS.CUS.ADDRESS
            IF Y.MSG THEN
                RETURN
            END
        END ELSE
            CALL OCOMO("OMITIENDO DIRECCION DE.ADDRESS [" : Y.DE.ADDRESS.LIST.ID : "] L.DA.TIPO.RES ESTA VACIO")
        END

        Y.SEQ += 1

    REPEAT
RETURN
*-----------------------------------------------------------------------------------
PROCESS.CUS.ADDRESS:* Call to process each AA
*-----------------------------------------------------------------------------------
GOSUB GET.ADDRESS.TYPE.COL
IF Y.MSG THEN
RETURN
END

IF Y.CLI.NO.DIRECCION EQ "" THEN      ;*ADDRESS CODE VALIDATION
Y.CLI.NO.DIRECCION = 1    ;* BY Default set 1, PACS00169639
END

Y.CLI.STREET.ADDR.DESC = Y.CLI.NO.DIRECCION:" ":R.DE.ADDRESS<DE.ADD.STREET.ADDRESS,1>:" ":Y.CLI.CAMPO3.09.POS:" ":Y.CLI.CAMPO4.09.POS:" ":Y.CLI.COUNTRY:" ":Y.CLI.COUNTRY.TOWN

Y.LINEA.DIR.CLI = ""
Y.CLI.NO.DIRECCION = Y.SEQ
*Y.LINEA.DIR.CLI  = C_DML_STMT_DIRECCION		;*R22 Manual Conversion - Varialble not found
Y.LINEA.DIR.CLI  = ""
Y.LINEA.DIR.CLI := Y.CLI.COD.EMPRESA:",":Y.CLI.COD.CLIENTE:","
Y.LINEA.DIR.CLI := Y.CLI.NO.DIRECCION : "," : Y.CLI.TIPO.DIRECCION:",'":redoOracleNull(Y.CLI.STREET.ADDR.DESC)[1,200]:"',":redoOracleNull(Y.CLI.REFER.GEOGRAFICA)[1,6]
Y.LINEA.DIR.CLI := ",":redoOracleNull("'":Y.CLI.APR.POSTAL[1,1]:"'"):",":redoOracleNull("'":Y.CLI.DIR.MODIFICADO[1,20]:"'"):",":redoOracleNull("'":Y.CLI.INPUTTER.ADD[1,20]:"'"):"," :redoOracleDate(Y.CLI.DATE.TIME.ADD,"yyMMddhh24mi")
Y.LINEA.DIR.CLI := ",":redoOracleNull("'":Y.CLI.INPUTTER.LAST[1,20]:"'"):",":redoOracleDate(Y.CLI.DATE.TIME.LAST,"yyMMddhh24mi"): ")"


R.COL.QUEUE = ''
R.COL.QUEUE<1> = Y.TMPDIRECCIONESCLIENTE
R.COL.QUEUE<2> = Y.LINEA.DIR.CLI
GOSUB WRITE.RECORD
RETURN
*-----------------------------------------------------------------------------------
PROCESS.AA:         * Call to process each AA
*-----------------------------------------------------------------------------------
    Y.CREDIT = ""
    Y.CREDIT.TXN = ""
    APAP.REDORETAIL.redoColExtractCredit(CUSTOMER.ID, Y.CREDIT, Y.CREDIT.TXN)		;*R22 Manual Conversion - Added APAP.REDORETAIL
    IF E THEN
        RETURN
    END
    IF Y.PROCESS.FLAG.TABLE<1,5> EQ "TMPCREDITO" THEN
        Y.TOTAL.E = DCOUNT(Y.CREDIT,@FM)
        Y.I = 1
        LOOP WHILE Y.I LE Y.TOTAL.E
            R.COL.QUEUE = ""
            R.COL.QUEUE<1> = "TMPCREDITO"
            R.COL.QUEUE<2> = Y.CREDIT<Y.I,1>
            R.COL.QUEUE<4> = Y.CREDIT<Y.I,2>
            GOSUB WRITE.RECORD
            Y.I += 1
        REPEAT
    END
    IF Y.PROCESS.FLAG.TABLE<1,4> EQ "TMPMOVIMIENTOS" THEN
        Y.TOTAL.E = DCOUNT(Y.CREDIT.TXN,@FM)
        Y.I = 1
        LOOP WHILE Y.I LE Y.TOTAL.E
            R.COL.QUEUE = ""
            R.COL.QUEUE<1> = "TMPMOVIMIENTOS"
            R.COL.QUEUE<2> = Y.CREDIT.TXN<Y.I,1>
            R.COL.QUEUE<4> = Y.CREDIT.TXN<Y.I,2>
            GOSUB WRITE.RECORD
            Y.I += 1
        REPEAT
    END
RETURN
*-----------------------------------------------------------------------------------
WRITE.RECORD:
*-----------------------------------------------------------------------------------
    Y.TOTAL.INSERT += 1
    LIST.INSERTS.STMT(Y.TOTAL.INSERT) = R.COL.QUEUE
RETURN
*-----------------------------------------------------------------------------------
TRACE.ERROR:        * Trace Error, Y.MSG is the error message, Y.TABLE.ID identifier of the Table
*-----------------------------------------------------------------------------------
*         Y.MSG = "ERROR, L.DA.NO.DIR ESTA VACIO EN ":CUSTOMER.ID
    CALL OCOMO(Y.MSG)
    CALL TXT(Y.MSG)
    Y.MSG = Y.MSG : "-" : CUSTOMER.ID
    ROUTINE.NAME = "REDO.COL.EXTRACT"
    CALL REDO.R.COL.EXTRACT.ERROR(Y.MSG, ROUTINE.NAME,Y.TABLE.ID)
    CALL REDO.R.COL.PROCESS.TRACE('EXTRACT', 20, 1, Y.TABLE.ID, '', Y.MSG)
    C.MON.TP='08'
    C.ID.PROC = REDO.INTERFACE.PARAM.ID
C.DESC=Y.MSG:
    GOSUB STORE.MSG.ON.QUEUE

RETURN
*-----------------------------------------------------------------------------------
FINAL.WRITE.RECORD:
*-----------------------------------------------------------------------------------
    I.VAR = 1
    LOOP WHILE I.VAR LE Y.TOTAL.INSERT
        Y.QUEUE.ID = ''
        CALL ALLOCATE.UNIQUE.TIME(Y.QUEUE.ID)
        Y.QUEUE.ID = DATE():Y.QUEUE.ID
        R.REDO.COL.QUEUE = LIST.INSERTS.STMT(I.VAR)

*    WRITE R.REDO.COL.QUEUE TO F.REDO.COL.QUEUE, Y.QUEUE.ID ;*Tus Start
        CALL F.WRITE(FN.REDO.COL.QUEUE,Y.QUEUE.ID,R.REDO.COL.QUEUE);*Tus End
        CALL REDO.R.COL.PROCESS.TRACE('EXTRACT', 10, 1, R.REDO.COL.QUEUE<1>, R.REDO.COL.QUEUE<4>, "")
        C.MON.TP='01'
        C.DESC = 'GRABA EL REGISTRO EN F.REDO.COL.QUEUE'
        C.ID.PROC = Y.QUEUE.ID
        GOSUB STORE.MSG.ON.QUEUE
        I.VAR += 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------------
GET.TEL.SEQUENCE:
*-----------------------------------------------------------------------------------
    LOCATE Y.CLI.TELF.TYPE IN Y.TEL.TYPE.LIST<1> SETTING Y.POS THEN
        Y.CURR.TEL.SEQ = Y.TEL.TYPE.SEQ<Y.POS>
        Y.TEL.TYPE.SEQ<Y.POS> = (Y.CURR.TEL.SEQ + 1)
    END ELSE
        Y.CURR.TEL.SEQ = 1
        Y.TEL.TYPE.SEQ<Y.POS> = 2
        Y.TEL.TYPE.LIST<Y.POS> = Y.CLI.TELF.TYPE
    END
RETURN
*-----------------------------------------------------------------------------------
GET.REPRES.ID.TYPE:
*-----------------------------------------------------------------------------------
    BEGIN CASE
        CASE R.CUSTOMER.REPRES<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.CI.POS> NE "" ;*CEDULA = 1
            Y.CLI.ID.REPRES = 1
            Y.CLI.NUM.REPRES = R.CUSTOMER.REPRES<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.CI.POS>
        CASE R.CUSTOMER.REPRES<EB.CUS.LEGAL.ID> NE ""   ;*PASAPORTE = 4
            Y.CLI.ID.REPRES = 4
            Y.CLI.NUM.REPRES = R.CUSTOMER<EB.CUS.LEGAL.ID>
        CASE R.CUSTOMER.REPRES<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.RCN.POS> NE ""          ;*RCN = 2
            Y.CLI.NUM.REPRES = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.RCN.POS>
            Y.CLI.ID.REPRES = 2
        CASE R.CUSTOMER.REPRES<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.ACTANAC.POS> NE ""      ;*ACTA NACIMIENTO = 8
            Y.CLI.NUM.REPRES = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.ACTANAC.POS>
            Y.CLI.ID.REPRES = 8
        CASE R.CUSTOMER.REPRES<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.NOUNICO.POS> NE ""      ;*NUMERO UNICO = 15
            Y.CLI.NUM.REPRES = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CLI.TIPO.ID.NOUNICO.POS>
            Y.CLI.ID.REPRES = 15
    END CASE
RETURN
*-----------------------------------------------------------------------------------
GET.TEL.AUDIT.INFO:
*-----------------------------------------------------------------------------------
    FIND Y.CLI.TELF.TYPE IN R.COL.TRACE.PHONE<REDO.COL.TP.PHONE.TYPE,1> SETTING Y.FM.POS,Y.VM.POS THEN
        Y.TEL.DATE.TIME.ADD = R.COL.TRACE.PHONE<REDO.COL.TP.CREATION.DATE,Y.VM.POS>
        Y.TEL.USER          = R.COL.TRACE.PHONE<REDO.COL.TP.LAST.IMPUTTER,Y.VM.POS>
        Y.TEL.DATE.TIME.UPD = R.COL.TRACE.PHONE<REDO.COL.TP.LAST.UPD.DATE,Y.VM.POS>
    END ELSE
        Y.TEL.DATE.TIME.ADD = Y.CLI.FECHA.ADICION
        Y.TEL.USER          = Y.CLI.MODIF.POR
        Y.TEL.DATE.TIME.UPD = Y.CLI.FECHA.MODIF
    END
    Y.TEL.USER = Y.TEL.USER[1,20]

RETURN
*-----------------------------------------------------------------------------------
GET.ADDRESS.TYPE.COL:
*-----------------------------------------------------------------------------------
    Y.ADD.TYPE.LIST = ""        ;*valor statico de  Y.ADD.TYPE.LIST
    Y.ADD.TYPE.LIST = C.ADD.TYPE.LIST

    LOCATE Y.CLI.TIPO.DIRECCION IN Y.ADD.TYPE.LIST<1,1> SETTING Y.POS THEN
        Y.CLI.TIPO.DIRECCION = Y.ADD.TYPE.LIST<2,Y.POS>
    END ELSE
        Y.MSG = yNonMappingValue : @FM : Y.CLI.TIPO.DIRECCION : @VM : "TIPO.DIRECCION" : @VM : CUSTOMER.ID
        Y.TABLE.ID = Y.TMPDIRECCIONESCLIENTE
        Y.PROCESS.FLAG.TABLE<1,3> = ""
        GOSUB TRACE.ERROR
        RETURN
    END
RETURN
*-----------------------------------------------------------------------------------
STORE.MSG.ON.QUEUE:
*-----------------------------------------------------------------------------------
    Y.MSG.QUEUE.ID = ''
    CALL ALLOCATE.UNIQUE.TIME(Y.MSG.QUEUE.ID)
    Y.MSG.QUEUE.ID = ID.COMPANY:'.':TODAY:'.':Y.MSG.QUEUE.ID
    R.REDO.COL.MSG.QUEUE = C.DESC
    WRITE R.REDO.COL.MSG.QUEUE TO F.REDO.COL.MSG.QUEUE, Y.MSG.QUEUE.ID ON ERROR W.ERROR = "NO GRABA"


RETURN
*-----------------------------------------------------------------------------------
END
