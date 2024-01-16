* @ValidationCode : MjotMjA1NTI3MDQ3MjpDcDEyNTI6MTcwMjk4ODM0MzcyODpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:03
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
SUBROUTINE DR.REGN16.GET.CUST.SURNAME
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* 15-12-2023       Santosh C               MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $USING EB.LocalReferences ;*R22 Manual Code Conversion_Utility Check

    CUST.ID = COMI
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*   CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',TIPO.CL.POS)
    EB.LocalReferences.GetLocRef('CUSTOMER','L.CU.TIPO.CL',TIPO.CL.POS) ;*R22 Manual Code Conversion_Utility Check
    R.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    CUSTOMER.SURNAME = ''

    BEGIN CASE
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA FISICA' OR R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'CLIENTE MENOR'
            CUSTOMER.SURNAME = R.CUSTOMER<EB.CUS.FAMILY.NAME>
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA JURIDICA'
            CUSTOMER.SURNAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
    END CASE

    COMI = CUSTOMER.SURNAME

RETURN
END
