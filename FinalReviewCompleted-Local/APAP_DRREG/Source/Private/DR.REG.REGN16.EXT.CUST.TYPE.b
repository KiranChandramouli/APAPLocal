* @ValidationCode : MjotMTExOTg0NDE3OkNwMTI1MjoxNjgwNzYzNzg1NzkwOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 12:19:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*06-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM , = to EQ
*06-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE DR.REG.REGN16.EXT.CUST.TYPE
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
*
    CUS.ID = COMI
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
*
    APPL.NAME = 'CUSTOMER'
    FLD.NAME = 'L.CU.TIPO.CL':@VM:'L.APAP.INDUSTRY' ;*R22 AUTO CODE CONVERSION
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.NAME,FLD.NAME,FLD.POS)
    TIPO.CL.POS = FLD.POS<1,1>
    Y.L.APAP.INDUS.POS = FLD.POS<1,2>
*
    BEGIN CASE

        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA FISICA' AND R.CUSTOMER<EB.CUS.NATIONALITY> EQ 'DO' ;*R22 AUTO CODE CONVERSION
            IF R.CUSTOMER<EB.CUS.GENDER> EQ 'MALE' THEN
                CUSTOMER.TYPE =  'P3'
            END ELSE
                CUSTOMER.TYPE =  'P5'
            END
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA FISICA' AND R.CUSTOMER<EB.CUS.NATIONALITY> NE 'DO' AND R.CUSTOMER< EB.CUS.RESIDENCE> EQ 'DO'
            IF R.CUSTOMER<EB.CUS.GENDER> EQ 'MALE' THEN
                CUSTOMER.TYPE =  'P4'
            END ELSE
                CUSTOMER.TYPE =  'P6'
            END
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA FISICA' AND R.CUSTOMER<EB.CUS.NATIONALITY> NE 'DO' AND R.CUSTOMER< EB.CUS.RESIDENCE> NE 'DO'
            IF R.CUSTOMER<EB.CUS.GENDER> EQ 'MALE' THEN
                CUSTOMER.TYPE =  'P7'
            END ELSE
                CUSTOMER.TYPE =  'P8'
            END

        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA JURIDICA' AND R.CUSTOMER<EB.CUS.NATIONALITY> EQ 'DO' ;*R22 AUTO CODE CONVERSION
            CUSTOMER.TYPE =  'E1'
        CASE  R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA JURIDICA' AND R.CUSTOMER<EB.CUS.NATIONALITY> NE 'DO'
            Y.L.APAP.INDUS = R.CUSTOMER<EB.CUS.LOCAL.REF><1,Y.L.APAP.INDUS.POS>
*       IF R.CUSTOMER<EB.CUS.INDUSTRY> LT '1065' AND R.CUSTOMER<EB.CUS.INDUSTRY> GT '1069' THEN
            IF Y.L.APAP.INDUS LT '1065' AND Y.L.APAP.INDUS GT '1069' THEN
                CUSTOMER.TYPE = 'E2'
            END ELSE
                CUSTOMER.TYPE = 'E3'
            END
    END CASE
*
    COMI = CUSTOMER.TYPE
*
RETURN
*
END
