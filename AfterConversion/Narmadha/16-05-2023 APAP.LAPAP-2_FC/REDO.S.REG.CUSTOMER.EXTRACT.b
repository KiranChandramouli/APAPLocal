* @ValidationCode : MjotNDAwNjU1MTc2OkNwMTI1MjoxNjgyNDA2NjY0MDQ0OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 12:41:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          FM TO @FM, VM TO @VM, ++ TO +=, F.READ TO CACHE.READ, BP Removed in Insert File
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.S.REG.CUSTOMER.EXTRACT(Y.CUSTOMER.ID,Y.PRODUCT.GROUP,Y.REL.CODE,OUT.ARR)
*----------------------------------------------------------------------------------------------------------------
* Description           : This routines is used to provide the details of Customer identification,customer type person,
*                         customer names(Family name,Given names,Short name,Name.1,Name.2) and Credit type.
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : Y.CUSTOMER.ID
* Argument#2 : Y.PRODUCT.GROUP
* Argument#3 : Y.REL.CODE
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : OUT.ARR
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION - START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.INDUSTRY
    $INSERT I_F.RELATION
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.REDO.CATEGORY.CIUU
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.COMPANY ;*AUTO R22 CODE CONVERSION - END

    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN
*----------
INITIALIZE:
*----------
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.INDUSTRY = 'F.INDUSTRY'
    F.INDUSTRY = ''
    CALL OPF(FN.INDUSTRY,F.INDUSTRY)

    FN.REDO.CATEGORY.CIUU = 'F.REDO.CATEGORY.CIUU'
    F.REDO.CATEGORY.CIUU  = ''
    CALL OPF(FN.REDO.CATEGORY.CIUU,F.REDO.CATEGORY.CIUU)

    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
    CALL OPF(FN.RELATION,F.RELATION)

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    Y.APPL.NAME = 'CUSTOMER'
    Y.APPL.FLD  = 'L.CU.PASS.NAT'
    YFLD.POS   = ''; L.CU.PASSNAT.POS = ''; Y.L.CU.PASSPORT = ''
    CALL MULTI.GET.LOC.REF(Y.APPL.NAME,Y.APPL.FLD,YFLD.POS)
    L.CU.PASSNAT.POS   = YFLD.POS<1,1>
RETURN
*-------
PROCESS:
*-------
    Y.CUS.ID = Y.CUSTOMER.ID
    GOSUB READ.CUSTOMER
    IF R.CUSTOMER THEN
        Y.NATIONALITY     = R.CUSTOMER<EB.CUS.NATIONALITY>
        Y.LEGAL.ID        = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
        Y.RESIDENCE       = R.CUSTOMER<EB.CUS.RESIDENCE>
        Y.GENDER          = R.CUSTOMER<EB.CUS.GENDER>
        Y.INDUSTRY        = R.CUSTOMER<EB.CUS.INDUSTRY>
        Y.NAME.1          = R.CUSTOMER<EB.CUS.NAME.1,R.COMPANY(EB.COM.LANGUAGE.CODE)>
        Y.NAME.2          = R.CUSTOMER<EB.CUS.NAME.2,R.COMPANY(EB.COM.LANGUAGE.CODE)>

        IF NOT(Y.NAME.1) THEN
            Y.NAME.1 = R.CUSTOMER<EB.CUS.NAME.1,1>
        END

        IF NOT(Y.NAME.2) THEN
            Y.NAME.2 = R.CUSTOMER<EB.CUS.NAME.2,1>
        END

        Y.GIVEN.NAMES     = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
        Y.FAMILY.NAME     = R.CUSTOMER<EB.CUS.FAMILY.NAME>
        Y.SHORT.NAME      = R.CUSTOMER<EB.CUS.SHORT.NAME>
        Y.RELATION.CODE   = R.CUSTOMER<EB.CUS.RELATION.CODE>
        Y.REL.CUSTOMER    = R.CUSTOMER<EB.CUS.REL.CUSTOMER>
        Y.L.CU.CIDENT     = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
        Y.L.CU.RNC        = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
        Y.L.CU.FOREIGN    = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS>
        Y.L.CU.TIPO.CL    = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>
        Y.L.CU.DEBTOR     = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.DEBTOR.POS>
        Y.L.TIP.CLI       = R.CUSTOMER<EB.CUS.LOCAL.REF,L.TIP.CLI.POS>
        Y.L.APAP.INDUSTRY = R.CUSTOMER<EB.CUS.LOCAL.REF,L.APAP.INDUSTRY.POS>
        Y.L.CU.PASSPORT    = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.PASSNAT.POS>
    END

    GOSUB READ.INDUSTRY
    GOSUB READ.REDO.CATEGORY.CIUU
    GOSUB CUST.IDENTIFICATION
    GOSUB CUST.TYPE
    GOSUB GET.CUST.NAME
    GOSUB GET.CREDIT.TYPE
*                   1           2              3               4                 5                6          7                  8
    OUT.ARR = Y.CUST.IDEN:@FM:Y.CUST.TYPE:@FM:Y.CUST.NAME:@FM:Y.CUST.GN.NAME:@FM:Y.CREDIT.TYPE:@FM:Y.BRANCH:@FM:Y.L.CU.DEBTOR:@FM:Y.L.TIP.CLI
RETURN
*-------------------
CUST.IDENTIFICATION:
*-------------------
    IF Y.L.CU.CIDENT THEN
        Y.CUST.IDEN = Y.L.CU.CIDENT
        Y.CUST.IDEN = FMT(Y.CUST.IDEN, "R(###-#######-#)")
    END

    IF NOT(Y.CUST.IDEN) AND Y.L.CU.RNC THEN
        Y.CUST.IDEN = Y.L.CU.RNC
        Y.CUST.IDEN = FMT(Y.CUST.IDEN, "R(#-##-#####-#)")
    END
    IF NOT(Y.CUST.IDEN) AND Y.LEGAL.ID THEN
        Y.CUST.IDEN = Y.NATIONALITY:Y.LEGAL.ID
    END
    IF NOT(Y.CUST.IDEN) AND Y.L.CU.PASSPORT THEN
        YFORG.VAL = ''; YFORG.CTRY = ''
        YFORG.VAL = FIELD(Y.L.CU.PASSPORT,'-',1)
        YFORG.CTRY = FIELD(Y.L.CU.PASSPORT,'-',2)
        Y.CUST.IDEN = YFORG.CTRY:YFORG.VAL
    END
RETURN
*---------
CUST.TYPE:
*---------

    Y.EB.LOOKUP.ID = "REDO.AA.REG.REPORTS*APAP.INDUSTRY"
    GOSUB READ.EB.LOOKUP
    Y.EB.APAP.IND.VAL = R.EB.LOOKUP<EB.LU.DATA.VALUE>

    BEGIN CASE
        CASE Y.NATIONALITY EQ 'DO' AND Y.GENDER EQ 'MALE' AND (Y.L.CU.TIPO.CL EQ 'PERSONA FISICA' OR Y.L.CU.TIPO.CL EQ 'CLIENTE MENOR')
            Y.CUST.TYPE = 'P3'
        CASE Y.NATIONALITY NE 'DO' AND Y.GENDER EQ 'MALE' AND ((Y.L.CU.TIPO.CL EQ 'PERSONA FISICA' AND Y.L.CU.CIDENT NE '') OR Y.L.CU.TIPO.CL EQ 'CLIENTE MENOR')
            Y.CUST.TYPE = 'P4'
        CASE Y.NATIONALITY EQ 'DO' AND Y.GENDER EQ 'FEMALE' AND (Y.L.CU.TIPO.CL EQ 'PERSONA FISICA' OR Y.L.CU.TIPO.CL EQ 'CLIENTE MENOR')
            Y.CUST.TYPE = 'P5'
        CASE Y.NATIONALITY NE 'DO' AND Y.GENDER EQ 'FEMALE' AND ((Y.L.CU.TIPO.CL EQ 'PERSONA FISICA' AND Y.L.CU.CIDENT NE '') OR Y.L.CU.TIPO.CL EQ 'CLIENTE MENOR')
            Y.CUST.TYPE = 'P6'
        CASE Y.NATIONALITY NE 'DO' AND Y.GENDER EQ 'MALE' AND ((Y.L.CU.TIPO.CL EQ 'PERSONA FISICA' AND Y.L.CU.PASSPORT NE '') OR Y.L.CU.TIPO.CL EQ 'CLIENTE MENOR')
            Y.CUST.TYPE = 'P7'
        CASE Y.NATIONALITY NE 'DO' AND Y.GENDER EQ 'FEMALE' AND ((Y.L.CU.TIPO.CL EQ 'PERSONA FISICA' AND Y.L.CU.PASSPORT NE '') OR Y.L.CU.TIPO.CL EQ 'CLIENTE MENOR')
            Y.CUST.TYPE = 'P8'
        CASE Y.NATIONALITY EQ 'DO' AND Y.L.CU.TIPO.CL EQ 'PERSONA JURIDICA' AND Y.L.CU.RNC NE ''
            Y.CUST.TYPE = 'E1'
    END CASE
RETURN

GET.CUST.NAME:
*-------------
    IF Y.REL.CODE EQ 'Y' THEN
        GOSUB CHK.REL.CUST.GIVEN.NAME
    END ELSE
        GOSUB CHK.CUST.GIVEN.NAME
    END
RETURN
*-----------------------
CHK.REL.CUST.GIVEN.NAME:
*-----------------------
    YTEMP.FLG = 0
    IF Y.RELATION.CODE THEN
        Y.RELATION.CODE.CNT = DCOUNT(Y.RELATION.CODE,@VM)
        Y.CNT = 1
        LOOP
        WHILE Y.CNT LE Y.RELATION.CODE.CNT
            Y.RELATION.ID = Y.RELATION.CODE<1,Y.CNT>
            Y.CUS.ID      = Y.REL.CUSTOMER<1,Y.CNT>
            GOSUB CHK.RELATION.CUSTOMER
            Y.CNT += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
    END
    IF YTEMP.FLG NE 1 THEN
        GOSUB CHK.CUST.GIVEN.NAME
    END
RETURN
*-------------------
CHK.CUST.GIVEN.NAME:
*-------------------
    IF Y.L.CU.TIPO.CL EQ "PERSONA FISICA" OR Y.L.CU.TIPO.CL EQ "CLIENTE MENOR" THEN
        Y.CUST.NAME    = Y.GIVEN.NAMES
        Y.CUST.GN.NAME = Y.FAMILY.NAME
    END
    IF Y.L.CU.TIPO.CL EQ "PERSONA JURIDICA" THEN
        Y.CUST.NAME    = Y.NAME.1:' ':Y.NAME.2
        Y.CUST.GN.NAME = Y.SHORT.NAME
    END
RETURN

CHK.RELATION.CUSTOMER:
*---------------------
    IF Y.RELATION.ID GE 500 AND Y.RELATION.ID LE 529 THEN
        Y.REL.GIVEN.NAMES = '' ; Y.REL.NAME1 = '' ; Y.REL.NAME2 = '' ; Y.REL.DESC = ''
        GOSUB READ.RELATION
        GOSUB READ.CUSTOMER
        Y.REL.GIVEN.NAMES = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
        Y.REL.NAME1       = R.CUSTOMER<EB.CUS.NAME.1>
        Y.REL.NAME2       = R.CUSTOMER<EB.CUS.NAME.2>
        IF Y.L.CU.TIPO.CL EQ "PERSONA FISICA" OR Y.L.CU.TIPO.CL EQ "CLIENTE MENOR" THEN
            Y.CUST.NAME<1,-1> = Y.GIVEN.NAMES:Y.REL.DESC:Y.REL.GIVEN.NAMES
            Y.CUST.GN.NAME    = Y.FAMILY.NAME
        END
        IF Y.L.CU.TIPO.CL EQ "PERSONA JURIDICA" THEN
            Y.CUST.NAME<1,-1> = Y.NAME.1:Y.NAME.2:Y.REL.DESC:Y.REL.NAME1:Y.REL.NAME2
            Y.CUST.GN.NAME    = Y.SHORT.NAME
        END
        YTEMP.FLG = 1
    END
RETURN

GET.CREDIT.TYPE:
*---------------
    IF Y.PRODUCT.GROUP EQ "COMERCIAL" THEN
        Y.CREDIT.TYPE  = Y.L.CU.DEBTOR
    END ELSE
        Y.EB.LOOKUP.ID = 'REDO.AA.REG.REPORTS*PRODUCT.GROUP'
        GOSUB READ.EB.LOOKUP
        Y.DATA.NAME  = R.EB.LOOKUP<EB.LU.DATA.NAME>
        Y.DATA.VALUE = R.EB.LOOKUP<EB.LU.DATA.VALUE>
        LOCATE Y.PRODUCT.GROUP IN Y.DATA.NAME<1,1> SETTING Y.PRD.POS THEN
            Y.CREDIT.TYPE = Y.DATA.VALUE<1,Y.PRD.POS>
        END
    END
RETURN
*-------------
READ.CUSTOMER:
*-------------
    R.CUSTOMER = '' ; CUS.ERR = ''
    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    Y.CUS.ID = ''

RETURN
*-------------
READ.INDUSTRY:
*-------------
    R.INDUSTRY = '' ; IND.ERR = ''
    CALL CACHE.READ(FN.INDUSTRY, Y.INDUSTRY, R.INDUSTRY, IND.ERR) ;*AUTO R22 CODE CONVERSION
    IF R.INDUSTRY THEN
        Y.L.AA.CATEG = R.INDUSTRY<EB.IND.LOCAL.REF,L.AA.CATEG.POS>
    END
RETURN
*-----------------------
READ.REDO.CATEGORY.CIUU:
*-----------------------
    R.REDO.CATEGORY.CIUU = '' ; REDO.CATEG.ERR = ''
    CALL F.READ(FN.REDO.CATEGORY.CIUU,Y.L.AA.CATEG,R.REDO.CATEGORY.CIUU,F.REDO.CATEGORY.CIUU,REDO.CATEG.ERR)
    IF R.REDO.CATEGORY.CIUU THEN
        Y.BRANCH = R.REDO.CATEGORY.CIUU<CAT.CIU.BRANCH>
    END
RETURN
*-------------
READ.RELATION:
*-------------
    R.RELATION = '' ; REL.ERR = ''
    CALL F.READ(FN.RELATION,Y.RELATION.ID,R.RELATION,F.RELATION,REL.ERR)
    IF R.RELATION THEN
        Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>
    END
    Y.RELATION.ID = ''
RETURN
*--------------
READ.EB.LOOKUP:
*--------------
    R.EB.LOOKUP = '' ; ERR.EB.LOOKUP = ''
    CALL F.READ(FN.EB.LOOKUP,Y.EB.LOOKUP.ID,R.EB.LOOKUP,F.EB.LOOKUP,ERR.EB.LOOKUP)
    Y.EB.LOOKUP.ID = ''
RETURN
*---------------------------------------------------End Of Record-----------------------------------------------------
END
