$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.DATA.CONFIRM(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : KARTHI K R
* Program Name  : REDO.E.BLD.DATA.CONFIRM
*-----------------------------------------------------------------------------
*Description: This is the build routine for the enquiry REDO.CRM.CLAIM.DATA.CONFIRM
*----
* Linked with: REDO.CRM.CLAIM.DATA.CONFIRM
* In parameter : n/a
* out parameter : None
*-----------------------------------------------------------------------------
* MODIFICATION HISTORY
*-----------------------------------------------------------------------------
*  DATE             WHO                DESCRIPTION         REFERENCE
*  05-07-2012       Karthi KR          INITIAL CREATION    PACS00205729
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    GOSUB INIT
    GOSUB OPEN.FILE
    GOSUB PROCESS
RETURN

INIT:

    Y.ID.POS = ''
    Y.ID.VAL = ''
    Y.OUT.ID = ''
    Y.CUSTOMER.L.CU.RNC.ERR = ''
    R.CUSTOMER.L.CU.RNC = ''
    R.CUSTOMER.L.CU.CIDENT = ''
    Y.CUSTOMER.L.CU.CIDENT.ERR = ''
    Y.CUST.ERR = ''
    R.CUSTOMER = ''

RETURN

OPEN.FILE:

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.CUSTOMER.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
    F.CUSTOMER.L.CU.CIDENT = ''
    CALL OPF(FN.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT)

    FN.CUSTOMER.L.CU.RNC = 'F.CUSTOMER.L.CU.RNC'
    F.CUSTOMER.L.CU.RNC = ''
    CALL OPF(FN.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC)

RETURN

PROCESS:


    LOCATE "CUSTOMER.CODE" IN ENQ.DATA<2,1> SETTING Y.ID.POS THEN
        Y.ID.VAL = ENQ.DATA<4,Y.ID.POS>
    END

    IF Y.ID.VAL NE '' THEN
        CALL F.READ(FN.CUSTOMER,Y.ID.VAL,R.CUSTOMER,F.CUSTOMER,Y.CUST.ERR)
        IF R.CUSTOMER THEN
            Y.OUT.ID = Y.ID.VAL
            ENQ.DATA<4,Y.ID.POS> =  Y.OUT.ID
        END

        IF Y.OUT.ID EQ '' THEN
            CALL F.READ(FN.CUSTOMER.L.CU.CIDENT,Y.ID.VAL,R.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT,Y.CUSTOMER.L.CU.CIDENT.ERR)
            IF R.CUSTOMER.L.CU.CIDENT THEN
                Y.OUT.ID = FIELD(R.CUSTOMER.L.CU.CIDENT,'*',2)
                ENQ.DATA<4,Y.ID.POS> =  Y.OUT.ID
            END
        END

        IF Y.OUT.ID EQ '' THEN
            CALL F.READ(FN.CUSTOMER.L.CU.RNC,Y.ID.VAL,R.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC,Y.CUSTOMER.L.CU.RNC.ERR)
            IF R.CUSTOMER.L.CU.RNC THEN
                Y.OUT.ID = FIELD(R.CUSTOMER.L.CU.RNC,'*',2)
                ENQ.DATA<4,Y.ID.POS> =  Y.OUT.ID
            END
        END
    END

RETURN

END
