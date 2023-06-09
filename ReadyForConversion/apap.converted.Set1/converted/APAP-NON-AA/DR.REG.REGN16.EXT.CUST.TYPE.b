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
    FLD.NAME = 'L.CU.TIPO.CL':@VM:'L.APAP.INDUSTRY'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.NAME,FLD.NAME,FLD.POS)
    TIPO.CL.POS = FLD.POS<1,1>
    Y.L.APAP.INDUS.POS = FLD.POS<1,2>
*
    BEGIN CASE

        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA FISICA' AND R.CUSTOMER<EB.CUS.NATIONALITY> EQ 'DO'
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

        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA JURIDICA' AND R.CUSTOMER<EB.CUS.NATIONALITY> EQ 'DO'
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
