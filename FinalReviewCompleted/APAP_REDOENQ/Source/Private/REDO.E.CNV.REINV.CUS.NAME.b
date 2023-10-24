* @ValidationCode : MjoxNjQzNTQ2MTY1OkNwMTI1MjoxNjg1OTQ5NjcwNzY2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jun 2023 12:51:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.REINV.CUS.NAME
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : NAVEENKUMAR N
* Program Name : REDO.E.CNV.REINV.CUS.NAME
*----------------------------------------------------------
* Description : This subroutine is attached as a conversion routine in the Enquiry REDO.REINVESTED.ACCT.STMT
* Linked with : Enquiry REDO.REINVESTED.ACCT.STMT as conversion routine
* In Parameter : None
* Out Parameter : None
*-----------------------------------------------------------------------------
* Modification Details:
*=====================
* 27/08/2010 - ODR-2010-08-0192
*DATE              WHO                REFERENCE                        DESCRIPTION
*23-05-2023      HARSHA        AUTO R22 CODE CONVERSION           FM TO @FM,CONVERT TO CHANGE
*23-05-2023      HARSHA        MANUAL R22 CODE CONVERSION         Inseterd I_F.RELATION
*------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.RELATION    ;*R22 Manual Conversion - Inseterd I_F.RELATION
*
    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****
* Initialising Necessary Variables
*
    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    R.CUSTOMER = ""
    E.CUSTOMER = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    R.ACCOUNT = ""
    E.ACCOUNT = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
    FN.RELATION = "F.RELATION"
    F.RELATION = ""
    R.RELATION = ""
    E.RELATION = ""
    CALL OPF(FN.RELATION,F.RELATION)
*
    Y.ACCEPT.LIST = ""
    Y.COND.NAME = ""
    Y.SINGLE.RELATION = ""
RETURN
********
PROCESS:
********
* Main process to fetch the necessary values
*
    Y.CUSTOMER.ID = R.RECORD<AZ.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,E.CUSTOMER)
    Y.NAME = R.CUSTOMER<EB.CUS.NAME.1>
*
    Y.ID = O.DATA
    CALL F.READ(FN.ACCOUNT,Y.ID,R.ACCOUNT,F.ACCOUNT,E.ACCOUNT)
    Y.JOINT.HOLDER = R.ACCOUNT<AC.JOINT.HOLDER>
    Y.RELATION.CODE.LIST = R.ACCOUNT<AC.RELATION.CODE>
*
    LOOP
        REMOVE Y.SINGLE FROM Y.JOINT.HOLDER SETTING POSITION
        REMOVE Y.SINGLE.RELATION FROM Y.RELATION.CODE.LIST SETTING RELATION.POS
    WHILE Y.SINGLE:POSITION
        IF Y.SINGLE.RELATION GE "500" AND Y.SINGLE.RELATION LE "529" THEN
            CALL F.READ(FN.RELATION,Y.SINGLE.RELATION,R.RELATION,F.RELATION,E.RELATION)
*Y.DES = R.RELATION<1> ;*Tus Start
            Y.DES = R.RELATION<EB.REL.DESCRIPTION>;*Tus End
            GOSUB JOINT.CONDITION
            IF Y.COND.NAME THEN
                Y.ACCEPT.LIST := Y.COND.NAME :"(":Y.DES:")":@FM
            END
        END
    REPEAT
*
    CHANGE @FM TO "|" IN Y.ACCEPT.LIST ;*AUTO R22 CODE CONVERSION
    IF Y.ACCEPT.LIST THEN
        O.DATA = Y.NAME:"|":Y.ACCEPT.LIST
    END ELSE
        O.DATA = Y.NAME
    END
RETURN
****************
JOINT.CONDITION:
****************
    CALL F.READ(FN.CUSTOMER,Y.SINGLE,R.CUSTOMER,F.CUSTOMER,E.CUSTOMER)
*
    CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',REF.POS)
*
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "CLIENTE MENOR" THEN
        Y.COND.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END ELSE
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "PERSONA JURIDICA" THEN
            Y.COND.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END
    END
RETURN
*
END
