* @ValidationCode : Mjo3MzU1MTY0NzY6Q3AxMjUyOjE2ODQyMjI3NzI3NTc6SVRTUzotMTotMTotNjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:09:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -6
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   T24.BP is removed ,VM to@VM
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE DR.REG.213IF02.GET.CUST.TYPE(CUSTOMER.TYPE,TIPO.CL.POS)
    $INSERT I_COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    R.CUSTOMER = CUSTOMER.TYPE
    CUSTOMER.TYPE = ''

    Y.APPLICATION = 'CUSTOMER'
    Y.FIELDS = 'L.APAP.INDUSTRY':@VM:'L.CU.TIPO.CL':@VM:'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.PASS.NAT'
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELDS,Y.FIELD.POS)
    Y.APAP.INDUS.POS = Y.FIELD.POS<1,1>
    L.CU.TIPO.CL.POS = Y.FIELD.POS<1,2>
    L.CU.CIDENT.POS = Y.FIELD.POS<1,3>
    L.CU.RNC.POS = Y.FIELD.POS<1,4>
    L.CU.FOREIGN.POS = Y.FIELD.POS<1,5>

    CUS.NATION = R.CUSTOMER<EB.CUS.NATIONALITY>
    CUS.GENDER = R.CUSTOMER<EB.CUS.GENDER>
    CUS.RESID = R.CUSTOMER<EB.CUS.RESIDENCE>
    CU.TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>
    CUS.INDUST = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.APAP.INDUS.POS>
    YCUS.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
    YCUS.RNC = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
    YCUS.FOREIGN = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS>

    CUST.TYPE = ''
    BEGIN CASE
        CASE CUS.NATION EQ 'DO' AND CUS.GENDER EQ 'MALE' AND CU.TIPO.CL EQ 'PERSONA FISICA' AND YCUS.CIDENT NE ''
            CUST.TYPE = 'P3'
        CASE CUS.NATION NE 'DO' AND CUS.GENDER EQ 'MALE' AND CU.TIPO.CL EQ 'PERSONA FISICA' AND YCUS.CIDENT NE ''
            CUST.TYPE = 'P4'
        CASE CUS.NATION EQ 'DO' AND CUS.GENDER EQ 'FEMALE' AND CU.TIPO.CL EQ 'PERSONA FISICA' AND YCUS.CIDENT NE ''
            CUST.TYPE = 'P5'
        CASE CUS.NATION NE 'DO' AND CUS.GENDER EQ 'FEMALE' AND CU.TIPO.CL EQ 'PERSONA FISICA' AND YCUS.CIDENT NE ''
            CUST.TYPE = 'P6'
        CASE CUS.NATION NE 'DO' AND CUS.GENDER EQ 'MALE' AND CU.TIPO.CL EQ 'PERSONA FISICA' AND YCUS.FOREIGN NE ''
            CUST.TYPE = 'P7'
        CASE CUS.NATION NE 'DO' AND CUS.GENDER EQ 'FEMALE' AND CU.TIPO.CL EQ 'PERSONA FISICA' AND YCUS.FOREIGN NE ''
            CUST.TYPE = 'P8'
        CASE CUS.NATION EQ 'DO' AND CU.TIPO.CL EQ 'PERSONA JURIDICA' AND YCUS.RNC NE ''
            CUST.TYPE = 'E1'
*    CASE CUS.NATION NE 'DO' AND CU.TIPO.CL EQ 'PERSONA JURIDICA' AND (CUS.INDUST LT '651000' AND CUS.INDUST NE '')
*        CUST.TYPE = 'E2'
*    CASE CUS.NATION NE 'DO' AND CU.TIPO.CL EQ 'PERSONA JURIDICA' AND CUS.INDUST GT '659990'
*        CUST.TYPE = 'E2'
*    CASE CUS.NATION NE 'DO' AND CU.TIPO.CL EQ 'PERSONA JURIDICA' AND (CUS.INDUST GE '651000' AND CUS.INDUST LE '659990')
*        CUST.TYPE = 'E3'
    END CASE
    CUSTOMER.TYPE = CUST.TYPE
RETURN
END
