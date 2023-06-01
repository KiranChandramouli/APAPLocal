* @ValidationCode : MjotNDI2MjYzMjYyOkNwMTI1MjoxNjg0ODU2ODc5MTk4OklUU1M6LTE6LTE6MzkzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 393
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*10-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM tO @VM , = to EQ
*10-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*-----------------------------------------------------------------------------
SUBROUTINE DR.REGN22.GET.CUST.TYPE
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.SEC.TRADE
*
    FN.SEC.TRADE = 'F.SEC.TRADE'
    F.SEC.TRADE = ''
    CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)
    R.SEC.TRADE = ''
    CALL GET.LOC.REF('SEC.TRADE','L.ST.CPTY',L.ST.CPTY.POS)
    CALL F.READ(FN.SEC.TRADE,COMI,R.SEC.TRADE,F.SEC.TRADE,SEC.TRADE.ERR)
    BEGIN CASE
        CASE R.SEC.TRADE<SC.SBS.BROKER.TYPE> EQ 'CO'
            CUST.ID = R.SEC.TRADE<SC.SBS.BROKER.NO>
        CASE R.SEC.TRADE<SC.SBS.BROKER.TYPE> EQ 'B'
            CUST.ID = R.SEC.TRADE<SC.SBS.LOCAL.REF,L.ST.CPTY.POS>
    END CASE
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
* CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',TIPO.CL.POS)
* R.CUSTOMER = ''

    Y.APPLICATION = 'CUSTOMER'
    Y.FIELDS = 'L.CU.TIPO.CL':@VM:'L.APAP.INDUSTRY'
    Y.FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELDS,Y.FIELD.POS)
    TIPO.CL.POS = Y.FIELD.POS<1,1>
    Y.APAP.INDUS.POS = Y.FIELD.POS<1,2>

    CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    CUSTOMER.TYPE = ''
    Y.APAP.INDUS = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.APAP.INDUS.POS>

    BEGIN CASE

        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA FISICA' AND R.CUSTOMER<EB.CUS.NATIONALITY> EQ 'DO' ;*R22 AUTO CODE CONVERSION
            IF R.CUSTOMER<EB.CUS.GENDER> EQ 'MALE' THEN
                CUSTOMER.TYPE = 'P3'
            END ELSE
                CUSTOMER.TYPE = 'P5'
            END
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA FISICA' AND R.CUSTOMER<EB.CUS.NATIONALITY> NE 'DO' AND R.CUSTOMER< EB.CUS.RESIDENCE> EQ 'DO'
            IF R.CUSTOMER<EB.CUS.GENDER> EQ 'MALE' THEN
                CUSTOMER.TYPE = 'P4'
            END ELSE
                CUSTOMER.TYPE = 'P6'
            END
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA FISICA' AND R.CUSTOMER<EB.CUS.NATIONALITY> NE 'DO' AND R.CUSTOMER< EB.CUS.RESIDENCE> NE 'DO'
            IF R.CUSTOMER<EB.CUS.GENDER> EQ 'MALE' THEN
                CUSTOMER.TYPE = 'P7'
            END ELSE
                CUSTOMER.TYPE = 'P8'
            END

        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA JURIDICA' AND R.CUSTOMER<EB.CUS.NATIONALITY> EQ 'DO'
            CUSTOMER.TYPE = 'E1'
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA JURIDICA' AND R.CUSTOMER<EB.CUS.NATIONALITY> NE 'DO'
* IF R.CUSTOMER<EB.CUS.INDUSTRY> LT '1065' AND R.CUSTOMER<EB.CUS.INDUSTRY> GT '1069' THEN
            IF Y.APAP.INDUS LT '1065' AND Y.APAP.INDUS GT '1069' THEN
                CUSTOMER.TYPE = 'E2'
            END ELSE
                CUSTOMER.TYPE = 'E3'
            END
    END CASE
*
    COMI = CUSTOMER.TYPE
*
RETURN
END
