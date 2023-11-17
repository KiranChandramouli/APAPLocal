$PACKAGE APAP.LAPAP
SUBROUTINE ENQ.L.APAP.FIM.CUST(Y.FINAL)
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT 
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER

**---------------------------------------
**ABRIR LA TABLA CUSTOMER
**---------------------------------------
    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""
    R.CUS = ""
    CUS.ERR = ""
    CALL OPF(FN.CUS,FV.CUS)

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

**-------------------------------------------------------------

**---------------------------------------------------------------------------------------------
**SENTENCIA LOCATE
**---------------------------------------------------------------------------------------------
    LOCATE "DOCUMENT.TYPE" IN D.FIELDS<1> SETTING CUS.POS THEN
        F.TYPE.DOCUMENT = D.RANGE.AND.VALUE<CUS.POS>
    END

    LOCATE "DOCUMENT" IN D.FIELDS<1> SETTING CUS.POS THEN
        CUSTOMER.IDE = D.RANGE.AND.VALUE<CUS.POS>
    END

    IF F.TYPE.DOCUMENT EQ "NOMBRE" THEN
        CHANGE @SM TO ' ' IN CUSTOMER.IDE
    END
**------------------------------------------------------------------------------------------------------------------------------------
**------------------------------
** Locales
**------------------------------
    APPL.NAME.ARR<1> = 'CUSTOMER' ;
    FLD.NAME.ARR<1,1> = 'L.CU.SEGMENTO' ;
    FLD.NAME.ARR<1,2> = 'L.CU.CIDENT' ;
    FLD.NAME.ARR<1,3> = 'L.CU.RNC' ;
    FLD.NAME.ARR<1,4> = 'L.CU.PASS.NAT' ;

    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    L.CUS.SEG.POS = FLD.POS.ARR<1,1>
    L.CU.CIDENT.POS = FLD.POS.ARR<1,2>
    L.CU.RNC.POS = FLD.POS.ARR<1,3>
    L.CU.PASS.NAT.POS = FLD.POS.ARR<1,4>
**-----------------------------------------------------

    CUSTOMER.NO = ''
    BEGIN CASE
        CASE  F.TYPE.DOCUMENT EQ "CEDULA"
            R.CUS.CIDENT = ''
            CALL F.READ(FN.CUS.L.CU.CIDENT,CUSTOMER.IDE,R.CUS.CIDENT,F.CUS.L.CU.CIDENT,CID.ERR)
            CUSTOMER.NO = FIELD(R.CUS.CIDENT,"*",2)
            GOSUB CONSULTAR
            GOSUB RESULTADO
        CASE  F.TYPE.DOCUMENT EQ "RNC"
            R.CUS.RNC = ''
            CALL F.READ(FN.CUS.L.CU.RNC,CUSTOMER.IDE,R.CUS.RNC,F.CUS.L.CU.RNC,RNC.ERR)
            CUSTOMER.NO = FIELD(R.CUS.RNC,"*",2)
            GOSUB CONSULTAR
            GOSUB RESULTADO

        CASE  F.TYPE.DOCUMENT EQ "PASAPORTE"
            R.CUS.LEGAL = ''
            CALL F.READ(FN.CUS.LEGAL.ID,CUSTOMER.IDE,R.CUS.LEGAL,F.CUS.LEGAL.ID,LEGAL.ERR)
            CUSTOMER.NO = FIELD(R.CUS.LEGAL,"*",2)
            GOSUB CONSULTAR
            GOSUB RESULTADO
        CASE F.TYPE.DOCUMENT EQ "NOMBRE"
            SEL.CUS.CMD = "SELECT " : FN.CUS : " WITH SHORT.NAME LIKE '..." : CUSTOMER.IDE : "...'"
            CALL EB.READLIST(SEL.CUS.CMD,SEL.CUS.LIST,"",NO.OF.RECS.CUS,SEL.CUS.ERROR)
            LOOP
                REMOVE Y.CUS.ID FROM SEL.CUS.LIST SETTING CUS.POS.2
            WHILE Y.CUS.ID:CUS.POS.2
                CUSTOMER.NO = Y.CUS.ID
                GOSUB CONSULTAR
                GOSUB RESULTADO
            REPEAT

    END CASE

CONSULTAR:
**------------------------------------------------------------------------------------------------------------------------------------
**------------------------------------------------------------------------------------------------------------------------------------
**CONSULTAR DATOS DEL CLIENTE
**------------------------------------------------------------------------------------------------------------------------------------


    CALL F.READ(FN.CUS,CUSTOMER.NO,R.CUS, FV.CUS, CUS.ERR)

    Y.CUS.DIRECCION = R.CUS<EB.CUS.STREET> :" ": R.CUS<EB.CUS.TOWN.COUNTRY>
    Y.CUS.EMAIL = R.CUS<EB.CUS.EMAIL.1>
    Y.STATUS.CLIENTE = R.CUS<EB.CUS.CUSTOMER.STATUS>
    Y.CUS.EMPLEADO  = R.CUS<EB.CUS.FAX.1>

    Y.L.CU.CIDENT = R.CUS<EB.CUS.LOCAL.REF, L.CU.CIDENT.POS>
    Y.L.CU.RNC = R.CUS<EB.CUS.LOCAL.REF, L.CU.RNC.POS>
    L.CU.PASS.NAT = R.CUS<EB.CUS.LOCAL.REF, L.CU.PASS.NAT.POS>

    CALL GET.LOC.REF("CUSTOMER", "L.CU.TIPO.CL", L.CU.TIPO.CL.POS)
    Y.CUSTOMER.TYPE = R.CUS<EB.CUS.LOCAL.REF, L.CU.TIPO.CL.POS>

    Y.IDENTIFICACION = ''
    IF (Y.L.CU.CIDENT NE '') THEN
        Y.IDENTIFICACION = Y.L.CU.CIDENT
    END
    IF (Y.L.CU.RNC NE '') THEN
        Y.IDENTIFICACION = Y.L.CU.RNC
    END
    IF (L.CU.PASS.NAT NE '') THEN
        Y.IDENTIFICACION = L.CU.PASS.NAT
    END
*DEBUG
**------------------------------------------------------------------------------------------------------------------------------------
**------------------------------------------------------------------------------------------------------------------------------------
**SETEAR LOS DATOS POR TIPO DE CLIENTE
**------------------------------------------------------------------------------------------------------------------------------------

    BEGIN CASE
        CASE  F.TYPE.DOCUMENT EQ "CEDULA"
            Y.CUS.NOMBRE = R.CUS<EB.CUS.GIVEN.NAMES>
            Y.CUS.APELLIDO = R.CUS<EB.CUS.FAMILY.NAME>
*DEBUG
        CASE  F.TYPE.DOCUMENT EQ "RNC"
            Y.CUS.NOMBRE = R.CUS<EB.CUS.SHORT.NAME>
            Y.CUS.APELLIDO = ''
        CASE  F.TYPE.DOCUMENT EQ "PASAPORTE"
            Y.CUS.NOMBRE = R.CUS<EB.CUS.GIVEN.NAMES>
            Y.CUS.APELLIDO = R.CUS<EB.CUS.FAMILY.NAME>

        CASE F.TYPE.DOCUMENT EQ "NOMBRE"
            Y.CUS.NOMBRE = R.CUS<EB.CUS.GIVEN.NAMES>
            Y.CUS.APELLIDO = R.CUS<EB.CUS.FAMILY.NAME>
    END CASE

    CHANGE ',' TO ' ' IN Y.CUS.NOMBRE
    CHANGE '[' TO '' IN Y.CUS.NOMBRE
    CHANGE ']' TO '' IN Y.CUS.NOMBRE
    CHANGE '{' TO '' IN Y.CUS.NOMBRE
    CHANGE '}' TO '' IN Y.CUS.NOMBRE

    CHANGE ',' TO ' ' IN Y.CUS.APELLIDO
    CHANGE '[' TO '' IN Y.CUS.APELLIDO
    CHANGE ']' TO '' IN Y.CUS.APELLIDO
    CHANGE '{' TO '' IN Y.CUS.APELLIDO
    CHANGE '}' TO '' IN Y.CUS.APELLIDO

    CHANGE ',' TO ' ' IN Y.CUS.DIRECCION
    CHANGE '[' TO '' IN Y.CUS.DIRECCION
    CHANGE ']' TO '' IN Y.CUS.DIRECCION
    CHANGE '{' TO '' IN Y.CUS.DIRECCION
    CHANGE '}' TO '' IN Y.CUS.DIRECCION
**------------------------------------------------------------------------------------------------------------------------------------
**------------------------------------------------------------------------------------------------------------------------------------
** SETEAR LA DESCRIPCION DEL ESTADO POR CODIGO
**------------------------------------------------------------------------------------------------------------------------------------

    BEGIN CASE
        CASE   Y.STATUS.CLIENTE EQ "1"
            Y.STATUS.CLIENTE = "ACTIVO"

        CASE  Y.STATUS.CLIENTE EQ "2"
            Y.STATUS.CLIENTE = "INACTIVO"

        CASE   Y.STATUS.CLIENTE EQ "3"
            Y.STATUS.CLIENTE = "FALLECIDO"

        CASE   Y.STATUS.CLIENTE EQ "4"
            Y.STATUS.CLIENTE = "CERRADO"

    END CASE

**------------------------------
** Segmento del cliente
**------------------------------

    IF  Y.CUS.EMPLEADO NE "" THEN
        Y.CUS.SEGMENTO = "EMPLEADO"
    END
    ELSE
        IF  Y.CUSTOMER.TYPE EQ "PERSONA JURIDICA" THEN
            Y.CUS.SEGMENTO = "CORPORATIVO"
        END
        ELSE
            Y.CUS.SEGMENTO = "EFECTIVO"
        END
    END

RETURN
RESULTADO:
    IF CUSTOMER.NO NE '' THEN
        Y.FINAL<-1> = CUSTOMER.NO : "*" : Y.CUS.NOMBRE : "*" : Y.CUS.APELLIDO : "*" :  Y.CUS.DIRECCION : "*" : Y.CUS.EMAIL : "*" : Y.STATUS.CLIENTE : "*" : Y.CUS.SEGMENTO : "*" : Y.IDENTIFICACION
    END ELSE
        Y.FINAL<-1> = "-1" : "*" : "NO ENCONTRADO" : "*" : "NO ENCONTRADO" : "*" :  Y.CUS.DIRECCION : "*" : Y.CUS.EMAIL : "*" : "NO ENCONTRADO" : "*" : "N/A" : "N/A"
    END
RETURN
END
