* @ValidationCode : Mjo4MDc1MTE5OTQ6Q3AxMjUyOjE2ODA2NzY2NjAxMTg6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 12:07:40
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
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   = to EQ
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE DR.REG.GET.CUSTOMER.TYPE(CUSTOMER.TYPE,TIPO.CL.POS)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    Y.LOC.APPLICATION = 'CUSTOMER'
    Y.LOC.FIELD = 'L.APAP.INDUSTRY'
    Y.LOC.FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(Y.LOC.APPLICATION,Y.LOC.FIELD,Y.LOC.FIELD.POS)

    Y.L.APAP.INDUS.POS = Y.LOC.FIELD.POS<1,1>

    R.CUSTOMER = CUSTOMER.TYPE
    CUSTOMER.TYPE = ''
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

        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA JURIDICA' AND R.CUSTOMER<EB.CUS.NATIONALITY> EQ 'DO'  ;*R22 AUTO CODE CONVERSION
            CUSTOMER.TYPE =  'E1'
        CASE  R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA JURIDICA' AND R.CUSTOMER<EB.CUS.NATIONALITY> NE 'DO'
            Y.L.APAP.INDUS = R.CUSTOMER<EB.CUS.LOCAL.REF><1,Y.L.APAP.INDUS.POS>
*       IF R.CUSTOMER<EB.CUS.INDUSTRY> LT '651000' AND R.CUSTOMER<EB.CUS.INDUSTRY> GT '659990' THEN
            IF Y.L.APAP.INDUS LT '651000' AND Y.L.APAP.INDUS GT '659990' THEN
                CUSTOMER.TYPE = 'E2'
            END ELSE
                CUSTOMER.TYPE = 'E3'
            END
    END CASE

RETURN
END
