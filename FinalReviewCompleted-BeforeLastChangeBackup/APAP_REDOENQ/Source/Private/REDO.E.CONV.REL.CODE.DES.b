$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.REL.CODE.DES
****************************************************
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : SABARI KUMAR A
* Program Name : REDO.E.CONV.REL.CODE.DES
*-----------------------------------------------------------------------------

* Description : This subroutine is attached as a conversion routine
* If the field L.CU.TIPO.CL has the value "PERSONA FISICA" OR "CLIENTE MENOR" then
* concat the "GIVEN.NAMES" field and "FAMILY.NAME" field from CUSTOMER application
* If the field L.CU.TIPO.CL has the value "PERSONA JURIDICA" then concat the
* "NAME.1" field and "NAME.2" field from CUSTOMER application

*------------------------------------------------------------------------------
* In Parameter : None
* Out Parameter : None
*------------------------------------------------------------------------------
* Modification History:
* 18-Mar-2011 A.SabariKumar ODR-2010-08-0181 Initial Creation
*  DATE             WHO                   REFERENCE                  
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
*------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.RELATION

    GOSUB INITIALIZE
    GOSUB OPENING
    GOSUB FIELD.CHECK

RETURN

*------------------------------------------------------------------------------
INITIALIZE:
*------------
* The variables are initialized here

    REF.POS = ''
    CONCAT1 = ''
    Y.NAME1 = ''
    Y.NAME2 = ''
    Y.RELATION.CODE = ''
    Y.REL.DESC = ''
RETURN

*-----------------------------------------------------------------------------
OPENING:
*---------
* Open all necessary files

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
    CALL OPF(FN.RELATION,F.RELATION)

RETURN

*-----------------------------------------------------------------------------
FIELD.CHECK:
*-------------
* The local field L.CU.TIPO.CL value is checked here and based on the result,
* the values are concatenated

    CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',REF.POS)
    Y.ACC.NO = O.DATA
    CALL F.READ(FN.ACCOUNT,Y.ACC.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    O.DATA = ''

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "CLIENTE MENOR" THEN
        Y.NAME1 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END ELSE
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "PERSONA JURIDICA" THEN
            Y.NAME1 = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END
    END
    Y.RELATION.CODE = R.CUSTOMER<EB.CUS.RELATION.CODE>
    IF Y.RELATION.CODE GE 500 AND Y.RELATION.CODE LE 529 THEN
        CALL F.READ(FN.RELATION,Y.RELATION.CODE,R.RELATION,F.RELATION,REL.ERR)
        Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>
        Y.ACC.JOINT.HOLD = R.ACCOUNT<AC.JOINT.HOLDER>
        CALL F.READ(FN.CUSTOMER,Y.ACC.JOINT.HOLD,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
        Y.NAME = R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS>
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "CLIENTE MENOR" THEN
            Y.NAME2 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
        END ELSE
            IF R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "PERSONA JURIDICA" THEN
                Y.NAME2 = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
            END
        END
    END
    O.DATA = Y.NAME1:' ':Y.REL.DESC:' ':Y.NAME2

RETURN
*---------------------------------------------------------------------------------
END
