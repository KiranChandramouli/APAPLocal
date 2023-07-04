* @ValidationCode : MjoxMzExNDQ4ODU6Q3AxMjUyOjE2ODQ4MzYwMzgwNTE6SVRTUzotMTotMTozNzA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 370
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.E.CUS.NAME

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : GANESH R
* Program Name : REDO.APAP.E.CUS.NAME
* Reference No : ODR-2010-03-0182
*---------------------------------------------------------

* Description : This subroutine is attached as a conversion routine
* to populate the label NOMBRE/RAZON SOCIAL
* If the field L.CU.TIPO.CL has the value "PERSONA FISICA" OR "CLIENTE MENOR" then
* concat the "GIVEN.NAMES" field and "FAMILY.NAME" field from CUSTOMER application
* If the field L.CU.TIPO.CL has the value "PERSONA JURIDICA" then concat the
* "NAME.1" field and "NAME.2" field from CUSTOMER application

*----------------------------------------------------------
* Linked With : Enquiry REPO.CU.VINCULADOS
* In Parameter : O.DATA
* Out Parameter : O.DATA
*----------------------------------------------------------
* *MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @ VM , ++ to +=
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------





*----------------------------------------------------------
* *----------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON

    GOSUB INITIALIZE
    GOSUB OPENING
    GOSUB FIELD.CHECK

RETURN

INITIALIZE:
*------------------------------------------------------------
* The variables are initialized here
*------------------------------------------------------------

    REF.POS = ''

RETURN
*------------------------------------------------------------
OPENING:
*------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN

FIELD.CHECK:
*------------------------------------------------------------
* The local field L.CU.TIPO.CL value is checked here and based on the result,
* the values are concatenated
*------------------------------------------------------------
    ACCT.ID = O.DATA
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    CALL MULTI.GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',REF.POS)
    REL.CODE = R.ACCOUNT<AC.RELATION.CODE>
    REL.COUNT = DCOUNT(REL.CODE,@VM)
    VAR.COUNT = 1
    LOOP
        REMOVE REL.ID FROM REL.CODE SETTING REL.POS
    WHILE VAR.COUNT LE REL.COUNT
        IF REL.ID GE 530 AND REL.ID LE 549 THEN
            CUSTOMER.ID = R.ACCOUNT<AC.JOINT.HOLDER,VAR.COUNT>
            CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
            TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF><1,REF.POS>
            GOSUB GET.NAMES
        END
        VAR.COUNT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT
    CHANGE @FM TO @VM IN Y.CUS.NAMES
    O.DATA = Y.CUS.NAMES

RETURN

GET.NAMES:

    IF TIPO.CL EQ "PERSONA FISICA" OR TIPO.CL EQ "CLIENTE MENOR" THEN
        Y.CUS.NAMES<-1> =  R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END ELSE
        IF TIPO.CL EQ "PERSONA JURIDICA" THEN
            Y.CUS.NAMES<-1> = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END
    END
RETURN
END
