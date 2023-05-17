$PACKAGE APAP.LAPAP
SUBROUTINE ENQ.L.APAP.SWIFT.CUST(Y.FINAL)

*--------------------------------------------------------------------------------------------------
* Description           : This routine returns a consolidated saving customer Information
* Developed On          : 08/10/2020
* Developed By          : Estalin Valerio
* Development Reference : ---
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
* Defect Reference       Modified By                    Date of Change        Change Details
* --------               Estalin Valerio                    08/10/2020            Creation
*Modification
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT 
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------
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

    CUSTOMER.NO = ''
    BEGIN CASE
        CASE  F.TYPE.DOCUMENT EQ "CEDULA"
            R.CUS.CIDENT = ''
            CALL F.READ(FN.CUS.L.CU.CIDENT,CUSTOMER.IDE,R.CUS.CIDENT,F.CUS.L.CU.CIDENT,CID.ERR)
            CUSTOMER.NO = FIELD(R.CUS.CIDENT,"*",2)

        CASE  F.TYPE.DOCUMENT EQ "RNC"
            R.CUS.RNC = ''
            CALL F.READ(FN.CUS.L.CU.RNC,CUSTOMER.IDE,R.CUS.RNC,F.CUS.L.CU.RNC,RNC.ERR)
            CUSTOMER.NO = FIELD(R.CUS.RNC,"*",2)

        CASE  F.TYPE.DOCUMENT EQ "PASAPORTE"
            R.CUS.LEGAL = ''
            CALL F.READ(FN.CUS.LEGAL.ID,CUSTOMER.IDE,R.CUS.LEGAL,F.CUS.LEGAL.ID,LEGAL.ERR)
            CUSTOMER.NO = FIELD(R.CUS.LEGAL,"*",2)

    END CASE

**------------------------------------------------------------------------------------------------------------------------------------
**------------------------------------------------------------------------------------------------------------------------------------
**CONSULTAR DATOS DEL CLIENTE
**------------------------------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.CUS,CUSTOMER.NO,R.CUS, FV.CUS, CUS.ERR)

    Y.CUS.DIRECCION = R.CUS<EB.CUS.STREET> :" ": R.CUS<EB.CUS.TOWN.COUNTRY>
    Y.CUS.EMAIL = R.CUS<EB.CUS.EMAIL.1>
    Y.STATUS.CLIENTE = R.CUS<EB.CUS.CUSTOMER.STATUS>

**------------------------------------------------------------------------------------------------------------------------------------
**------------------------------------------------------------------------------------------------------------------------------------
**SETEAR LOS DATOS POR TIPO DE CLIENTE
**------------------------------------------------------------------------------------------------------------------------------------

    BEGIN CASE
        CASE  F.TYPE.DOCUMENT EQ "CEDULA"
            Y.CUS.NOMBRE = R.CUS<EB.CUS.SHORT.NAME>
            Y.CUS.APELLIDO = R.CUS<EB.CUS.GIVEN.NAMES>

        CASE  F.TYPE.DOCUMENT EQ "RNC"
            Y.CUS.NOMBRE = R.CUS<EB.CUS.SHORT.NAME>

        CASE  F.TYPE.DOCUMENT EQ "PASAPORTE"
            Y.CUS.NOMBRE = R.CUS<EB.CUS.SHORT.NAME>
            Y.CUS.APELLIDO = R.CUS<EB.CUS.GIVEN.NAMES>

    END CASE

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

    Y.FINAL<-1> = CUSTOMER.NO : "*" : CHANGE(Y.CUS.NOMBRE,","," ") : "*" : CHANGE(Y.CUS.APELLIDO,","," ") : "*" :  CHANGE(Y.CUS.DIRECCION,","," ") : "*" : CHANGE(Y.CUS.EMAIL,","," ") : "*" : Y.STATUS.CLIENTE

END
