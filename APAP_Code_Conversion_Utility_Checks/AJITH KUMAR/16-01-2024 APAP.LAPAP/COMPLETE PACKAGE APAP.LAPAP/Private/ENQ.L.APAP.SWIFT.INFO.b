* @ValidationCode : MjoxNzgzOTAwMTcwOkNwMTI1MjoxNzAyOTg4MzQ0MjE0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:04
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
SUBROUTINE ENQ.L.APAP.SWIFT.INFO(Y.FINAL)
*--------------------------------------------------------------------------------------------------
* Description           : This routine returns a consolidated saving customer Information
* Developed On          : 02/12/2021
* Developed By          : Estalin Valerio
* Development Reference : ---
*--------------------------------------------------------------------------------------------------
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* 15-12-2023       Santosh C               MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.LATAM.CARD.CUSTOMER
    $INSERT I_F.ALTERNATE.ACCOUNT
    $USING EB.LocalReferences ;*R22 Manual Code Conversion_Utility Check
**---------------------------------------
**ABRIR LA TABLA CUSTOMER
**---------------------------------------
    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""
    R.CUS = ""
    CUS.ERR = ""
    CALL OPF(FN.CUS,FV.CUS)
**-------------------------------------------------------------

**---------------------------------------
**ABRIR LA TABLA F.ACCOUNT
**---------------------------------------
    FN.ACC = "F.ACCOUNT"
    FV.ACC = ""
    R.ACC = ""
    ACC.ERR = ""

    FN.ALT.ACC = "F.ALTERNATE.ACCOUNT"
    FV.ALT.ACC = ""
    R.ALT.ACC = ""
    ACC.ALT.ERR = ""

    FN.CARD.CUSTOMER  = "F.LATAM.CARD.CUSTOMER"
    F.CARD.CUSTOMER  = ""
    CALL OPF(FN.CARD.CUSTOMER,F.CARD.CUSTOMER)

**-------------------------------------------------------------

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
    LOCATE "DOCUMENT" IN D.FIELDS<1> SETTING CUS.POS THEN
        CUSTOMER.IDE = D.RANGE.AND.VALUE<CUS.POS>
    END

    LOCATE "CUSTOMER.ACCOUNT" IN D.FIELDS<2> SETTING ACC.POS THEN
        F.ACCOUNT = D.RANGE.AND.VALUE<ACC.POS>
    END
**------------------------------------------------------------------------------------------------------------------------------------
    CUSTOMER.NO = ''
    DOCUMENT.TYPE = "";

    R.CUS.CIDENT = ''
    CALL F.READ(FN.CUS.L.CU.CIDENT,CUSTOMER.IDE,R.CUS.CIDENT,F.CUS.L.CU.CIDENT,CID.ERR)

    IF FIELD(R.CUS.CIDENT,"*",2) NE "" THEN
        CUSTOMER.NO = FIELD(R.CUS.CIDENT,"*",2)
        DOCUMENT.TYPE = "CEDULA"
    END

    IF (CUSTOMER.NO EQ "") THEN
        R.CUS.RNC = ''
        CALL F.READ(FN.CUS.L.CU.RNC,CUSTOMER.IDE,R.CUS.RNC,F.CUS.L.CU.RNC,RNC.ERR)
        CUSTOMER.NO = FIELD(R.CUS.RNC,"*",2)
        DOCUMENT.TYPE = "RNC"
    END

    IF (CUSTOMER.NO EQ "") THEN
        R.CUS.LEGAL = ''
        CALL F.READ(FN.CUS.LEGAL.ID,CUSTOMER.IDE,R.CUS.LEGAL,F.CUS.LEGAL.ID,LEGAL.ERR)
        CUSTOMER.NO = FIELD(R.CUS.LEGAL,"*",2)
        DOCUMENT.TYPE = "PASAPORTE"
    END

**------------------------------------------------------------------------------------------------------------------------------------

**---------------------------BUSCAR LA CUENTA EN ALTERNATE.ACCOUNT-------------------------------
    IF LEN(F.ACCOUNT) GT 10 AND LEFT(F.ACCOUNT,1) NE 1 THEN

        CALL F.READ(FN.ALT.ACC,F.ACCOUNT,R.ALT.ACC, FV.ALT.ACC, ACC.ALT.ERR)
        Y.ALT.ACCOUNT = R.ALT.ACC<AAC.GLOBUS.ACCT.NUMBER>

        IF Y.ALT.ACCOUNT NE "" THEN
            F.ACCOUNT = Y.ALT.ACCOUNT
        END
    END
**---------------------------FIN BUSCAR LA CUENTA EN ALTERNATE.ACCOUNT-------------------------------

**-----------------------------------------------------------------------------------------------
** GET INFO ACCOUNT
**-----------------------------------------------------------------------------------------------
    CALL F.READ(FN.ACC,F.ACCOUNT,R.ACC, FV.ACC, ACC.ERR)
    Y.ACC.CUSTOMER    = R.ACC<AC.CUSTOMER>
    Y.JOINT.PRIMERO   = R.ACC<AC.JOINT.HOLDER,1>
    Y.JOINT.SEGUNDO   = R.ACC<AC.JOINT.HOLDER,2>

*   CALL GET.LOC.REF("ACCOUNT", "L.AC.STATUS1", L.AC.STATUS1.POS)
    EB.LocalReferences.GetLocRef("ACCOUNT", "L.AC.STATUS1", L.AC.STATUS1.POS) ;*R22 Manual Code Conversion_Utility Check
    Y.L.AC.STATUS1  = R.ACC<AC.LOCAL.REF,L.AC.STATUS1.POS>

**------------------------------------OBTENER CUSTOMER NO ----------------------------------------------------------------


**----------------------------FIN CONSULTAR JOINS.HOLDER---------------------------------------------------

**------------------------------------------------------------------------------------------------------------------------------------
**CONSULTAR DATOS DEL CLIENTE
**------------------------------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.CUS,CUSTOMER.NO,R.CUS, FV.CUS, CUS.ERR)

    Y.CUS.DIRECCION = R.CUS<EB.CUS.STREET> :" ": R.CUS<EB.CUS.TOWN.COUNTRY>
    Y.CUS.EMAIL = R.CUS<EB.CUS.EMAIL.1>
    Y.STATUS.CLIENTE = R.CUS<EB.CUS.CUSTOMER.STATUS>
    Y.DOCUMENT.PASSPORT  = R.CUS<EB.CUS.LEGAL.ID>
    Y.CUS.NOMBRE = R.CUS<EB.CUS.SHORT.NAME>
    Y.CUS.APELLIDO = R.CUS<EB.CUS.GIVEN.NAMES>

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

**------------------------------------------------------------------------------------------------------------------------------------
** VALIDATE ACCOUNT
**------------------------------------------------------------------------------------------------------------------------------------
    Y.ACCOUNT.VALID = 0
    IF (CUSTOMER.NO NE "" AND  Y.ACC.CUSTOMER "") THEN
        IF CUSTOMER.NO EQ  Y.ACC.CUSTOMER OR CUSTOMER.NO EQ Y.JOINT.PRIMERO OR  CUSTOMER.NO EQ Y.JOINT.SEGUNDO THEN
            Y.ACCOUNT.VALID = 1
        END
    END

    IF Y.ACCOUNT.VALID EQ 0 THEN
        Y.ACCOUNT.VALID = "FALSE"
    END
    ELSE
        Y.ACCOUNT.VALID = "TRUE"
    END

    Y.FINAL<-1> = CUSTOMER.NO : "*" : CHANGE(Y.CUS.NOMBRE,","," ") : "*" : CHANGE(Y.CUS.APELLIDO,","," ") : "*" :  CHANGE(Y.CUS.DIRECCION,","," ") : "*" : CHANGE(Y.CUS.EMAIL,","," ") : "*" : Y.STATUS.CLIENTE  : "*" : Y.ACCOUNT.VALID : "*" : Y.L.AC.STATUS1: "*" : CUSTOMER.IDE

END
