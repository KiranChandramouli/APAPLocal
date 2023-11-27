* @ValidationCode : Mjo4MDMxNzI4NTU6Q3AxMjUyOjE3MDA4NDI2Mzg4NDc6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Nov 2023 21:47:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

SUBROUTINE ENQ.L.APAP.CUST.INFO(Y.FINAL)
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*21/11/2023         Suresh             R22 Manual Conversion           Latest Routine Changes Merged
*----------------------------------------------------------------------------------------
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
**------------------------------------------------------------------------------------------------------------------------------------
**------------------------------
** Locales
**------------------------------
    APPL.NAME.ARR<1> = 'CUSTOMER' ;
    FLD.NAME.ARR<1,1> = 'L.CU.SEGMENTO' ;
    FLD.NAME.ARR<1,2> = 'L.CU.CIDENT' ;
    FLD.NAME.ARR<1,3> = 'L.CU.RNC' ;
    FLD.NAME.ARR<1,4> = 'L.CU.PASS.NAT' ;
    FLD.NAME.ARR<1,5> = 'L.TIP.CLI' ; ;* Latest Routine - Changes START
    FLD.NAME.ARR<1,6> = 'L.CU.TEL.AREA' ;
    FLD.NAME.ARR<1,7> = 'L.CU.TEL.NO' ; ;* Latest Routine - Changes END

    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    L.CUS.SEG.POS = FLD.POS.ARR<1,1>
    L.CU.CIDENT.POS = FLD.POS.ARR<1,2>
    L.CU.RNC.POS = FLD.POS.ARR<1,3>
    L.CU.PASS.NAT.POS = FLD.POS.ARR<1,4>
    L.TIP.CLI.POS = FLD.POS.ARR<1,5> ;* Latest Routine - Changes
    L.CU.TEL.AREA.POS = FLD.POS.ARR<1,6> ;* Latest Routine  - Changes
    L.CU.TEL.NO.POS = FLD.POS.ARR<1,7> ;* Latest Routine  - Changes
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
        CASE F.TYPE.DOCUMENT EQ "CUSTID" ;* Latest Routine- Changes START
            CUSTOMER.NO = CUSTOMER.IDE
            GOSUB CONSULTAR
            GOSUB RESULTADO ;* Latest Routine- Changes END
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
    Y.L.TIP.CLI = R.CUS<EB.CUS.LOCAL.REF, L.TIP.CLI.POS,1> ;* Latest Routine- Changes START
    Y.MARITAL.STATUS = R.CUS<EB.CUS.MARITAL.STATUS>
    Y.CUSTOMER.NO = CUSTOMER.IDE ;* Latest Routine- Changes END
    L.CU.PASS.NAT = R.CUS<EB.CUS.LOCAL.REF, L.CU.PASS.NAT.POS>

    CALL GET.LOC.REF("CUSTOMER", "L.CU.TIPO.CL", L.CU.TIPO.CL.POS)
    Y.CUSTOMER.TYPE = R.CUS<EB.CUS.LOCAL.REF, L.CU.TIPO.CL.POS>
    Y.L.CU.TEL.NO = R.CUS<EB.CUS.LOCAL.REF, L.CU.TEL.NO.POS> ;* Latest Routine- Changes START
    Y.TEL.1 = R.CUS<EB.CUS.LOCAL.REF, L.CU.TEL.AREA.POS,1> : '-':R.CUS<EB.CUS.LOCAL.REF, L.CU.TEL.NO.POS,1>
    Y.TEL.2 = R.CUS<EB.CUS.LOCAL.REF, L.CU.TEL.AREA.POS,2> : '-':R.CUS<EB.CUS.LOCAL.REF, L.CU.TEL.NO.POS,2> ;* Latest Routine- Changes END
    Y.IDENTIFICACION = ''
    IF (Y.L.CU.CIDENT NE '') THEN
        Y.IDENTIFICACION = Y.L.CU.CIDENT
    END
    ELSE IF (Y.L.CU.RNC NE '') THEN  ;* Latest Routine- Changes START
        Y.IDENTIFICACION = Y.L.CU.RNC
    END
    ELSE IF (L.CU.PASS.NAT NE '') THEN
        Y.IDENTIFICACION = L.CU.PASS.NAT
    END
    ELSE
        Y.IDENTIFICACION = Y.CUSTOMER.NO  ;* Latest Routine- Changes END
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
*          Y.CUS.NOMBRE = R.CUS<EB.CUS.SHORT.NAME> ;* Latest Routine Received - Changes
            Y.CUS.NOMBRE = R.CUS<EB.CUS.NAME.1,1>:" ":R.CUS<EB.CUS.NAME.2,1>
            Y.CUS.APELLIDO = ''
        CASE  F.TYPE.DOCUMENT EQ "PASAPORTE"
            Y.CUS.NOMBRE = R.CUS<EB.CUS.GIVEN.NAMES>
            Y.CUS.APELLIDO = R.CUS<EB.CUS.FAMILY.NAME>
*Latest Routine- Changes START
        CASE  F.TYPE.DOCUMENT EQ "CUSTID"
            IF (R.CUS<EB.CUS.GIVEN.NAMES> EQ '') THEN
                Y.CUS.NOMBRE = R.CUS<EB.CUS.NAME.1,1>:" ":R.CUS<EB.CUS.NAME.2,1>
            END
            ELSE
                Y.CUS.NOMBRE = R.CUS<EB.CUS.GIVEN.NAMES>
                Y.CUS.APELLIDO = R.CUS<EB.CUS.FAMILY.NAME>
            END
*Latest Routine- Changes END
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
    
    ELSE IF  Y.CUSTOMER.TYPE EQ "PERSONA JURIDICA" THEN  ;* Latest Routine- Changes
        Y.CUS.SEGMENTO = "CORPORATIVO"
    END
    ELSE
        Y.CUS.SEGMENTO = "EFECTIVO"
        
    END

RETURN
RESULTADO:
    IF CUSTOMER.NO NE '' THEN
*       Y.FINAL<-1> = CUSTOMER.NO : "*" : Y.CUS.NOMBRE : "*" : Y.CUS.APELLIDO : "*" :  Y.CUS.DIRECCION : "*" : Y.CUS.EMAIL : "*" : Y.STATUS.CLIENTE : "*" : Y.CUS.SEGMENTO : "*" : Y.IDENTIFICACION
        Y.FINAL<-1> = CUSTOMER.NO : "*" : Y.CUS.NOMBRE : "*" : Y.CUS.APELLIDO : "*" :  Y.CUS.DIRECCION : "*" : Y.CUS.EMAIL : "*" : Y.STATUS.CLIENTE : "*" : Y.CUS.SEGMENTO : "*" : Y.IDENTIFICACION : "*" : Y.L.TIP.CLI : "*" : Y.MARITAL.STATUS : "*" : Y.L.CU.TEL.NO ;* Latest Routine - Changes
    END ELSE
        Y.FINAL<-1> = "-1" : "*" : "NO ENCONTRADO" : "*" : "NO ENCONTRADO" : "*" :  Y.CUS.DIRECCION : "*" : Y.CUS.EMAIL : "*" : "NO ENCONTRADO" : "*" : "N/A"
    END
RETURN
END
