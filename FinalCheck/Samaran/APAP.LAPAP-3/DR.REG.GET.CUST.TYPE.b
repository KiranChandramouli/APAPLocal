* @ValidationCode : MjotMTA3MDI3NTQxMjpDcDEyNTI6MTY4MjMyMzUxNDE4OTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 13:35:14
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
$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.GET.CUST.TYPE(R.CUSTOMER,OUT.ARR)
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 06/10/2014        Ashokkumar.V.P            PACS00312712 - Common routine to get the Customer type and Identication number
* 20/11/2014        Ashokkumar.V.P            PACS00312712 - Reinitialized the R.CUSTOMER value.
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  T24.BP is removed ,$INCLUDE to$INSERT ,FM to@FM,VMto@VM
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT

    GOSUB INIT
    GOSUB GET.VALUES
    GOSUB GET.CUST.IDEN
    GOSUB GET.CUST.TYPE
    OUT.ARR = CUST.TYPE:@FM:CUST.IDEN
RETURN

INIT:
*****
    GOSUB INIT.V
    Y.APPLICATION = 'CUSTOMER'
    Y.FIELDS = 'L.APAP.INDUSTRY':@VM:'L.CU.TIPO.CL':@VM:'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.PASS.NAT':@VM:'L.CU.NOUNICO':@VM:'L.CU.ACTANAC'
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELDS,Y.FIELD.POS)
    Y.APAP.INDUS.POS = Y.FIELD.POS<1,1>
    L.CU.TIPO.CL.POS = Y.FIELD.POS<1,2>
    L.CU.CIDENT.POS = Y.FIELD.POS<1,3>
    L.CU.RNC.POS = Y.FIELD.POS<1,4>
    L.CU.PASS.NAT.POS = Y.FIELD.POS<1,5>
    L.CU.NOUNICO.POS = Y.FIELD.POS<1,6>
    L.CU.ACTANAC.POS = Y.FIELD.POS<1,7>
RETURN

INIT.V:
*******
    CUS.NATION = ''; CUS.GENDER = ''; CUS.RESID = ''; CU.TIPO.CL = ''; CUS.INDUST = ''; YCUS.CIDENT = ''
    YCUS.RNC = ''; YCUS.FOREIGN = ''; YCUS.LEGAL = ''; CUST.TYPE = ''; CUST.IDEN = ''; L.CU.PASS.NAT.POS = ''
    Y.FIELD.POS = ''; Y.APAP.INDUS.POS = ''; L.CU.CIDENT.POS = ''; L.CU.RNC.POS = ''; L.CU.TIPO.CL.POS = ''
RETURN

GET.VALUES:
***********
    CUS.NATION = R.CUSTOMER<EB.CUS.NATIONALITY>
    CUS.GENDER = R.CUSTOMER<EB.CUS.GENDER>
    CUS.RESID = R.CUSTOMER<EB.CUS.RESIDENCE>
    CU.TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>
    CUS.INDUST = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.APAP.INDUS.POS>
    YCUS.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
    YCUS.RNC = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
    YCUS.FOREIGN = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.PASS.NAT.POS>
    YCUS.LEGAL = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    Y.L.CU.ACTANAC = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.ACTANAC.POS>
    Y.L.CU.NOUNICO = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.NOUNICO.POS>
RETURN

GET.CUST.IDEN:
**************
    BEGIN CASE
        CASE YCUS.CIDENT NE ''
            CUST.IDEN = YCUS.CIDENT[1,3]:'-':YCUS.CIDENT[4,7]:'-':YCUS.CIDENT[11,1]
        CASE YCUS.RNC NE ''
            CUST.IDEN = YCUS.RNC[1,1]:'-':YCUS.RNC[2,2]:'-':YCUS.RNC[4,5]:'-':YCUS.RNC[9,1]
        CASE Y.L.CU.ACTANAC NE ''
            CUST.IDEN = Y.L.CU.ACTANAC
        CASE Y.L.CU.NOUNICO NE ''
            CUST.IDEN = Y.L.CU.NOUNICO
        CASE YCUS.LEGAL NE ''
            CUST.IDEN = CUS.NATION:YCUS.LEGAL
        CASE YCUS.FOREIGN NE ''
            YFORG.VAL = ''; YFORG.CTRY = ''
            YFORG.VAL = FIELD(YCUS.FOREIGN,'-',1)
            YFORG.CTRY = FIELD(YCUS.FOREIGN,'-',2)
            CUST.IDEN = YFORG.CTRY:YFORG.VAL
    END CASE
RETURN

GET.CUST.TYPE:
**************
    BEGIN CASE
        CASE CUS.NATION EQ 'DO' AND CUS.GENDER EQ 'MALE' AND (CU.TIPO.CL EQ 'PERSONA FISICA' OR CU.TIPO.CL EQ 'CLIENTE MENOR')
            CUST.TYPE = 'P3'
        CASE CUS.NATION NE 'DO' AND CUS.GENDER EQ 'MALE' AND ((CU.TIPO.CL EQ 'PERSONA FISICA' AND YCUS.CIDENT NE '') OR CU.TIPO.CL EQ 'CLIENTE MENOR')
            CUST.TYPE = 'P4'
        CASE CUS.NATION EQ 'DO' AND CUS.GENDER EQ 'FEMALE' AND (CU.TIPO.CL EQ 'PERSONA FISICA' OR CU.TIPO.CL EQ 'CLIENTE MENOR')
            CUST.TYPE = 'P5'
        CASE CUS.NATION NE 'DO' AND CUS.GENDER EQ 'FEMALE' AND ((CU.TIPO.CL EQ 'PERSONA FISICA' AND YCUS.CIDENT NE '') OR CU.TIPO.CL EQ 'CLIENTE MENOR')
            CUST.TYPE = 'P6'
        CASE CUS.NATION NE 'DO' AND CUS.GENDER EQ 'MALE' AND ((CU.TIPO.CL EQ 'PERSONA FISICA' AND YCUS.FOREIGN NE '') OR CU.TIPO.CL EQ 'CLIENTE MENOR')
            CUST.TYPE = 'P7'
        CASE CUS.NATION NE 'DO' AND CUS.GENDER EQ 'FEMALE' AND ((CU.TIPO.CL EQ 'PERSONA FISICA' AND YCUS.FOREIGN NE '') OR CU.TIPO.CL EQ 'CLIENTE MENOR')
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
RETURN
END
