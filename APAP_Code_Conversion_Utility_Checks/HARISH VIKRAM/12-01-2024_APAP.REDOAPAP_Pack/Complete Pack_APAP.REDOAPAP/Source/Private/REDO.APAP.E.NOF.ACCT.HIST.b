* @ValidationCode : MjoxMTAyNzk0MTc1OkNwMTI1MjoxNzAzNTkzNjgwNjM1OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Dec 2023 17:58:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.E.NOF.ACCT.HIST(DATA.RETURN)
*-----------------------------------------------------------------------------
* R o u t i n e D e s c r i p t i o n :
* ---------------------------------------
*
* This is a nofile routine to report the transaction details for accounts
* within the entered date range
*
* Below are the selection criteria for the enquiry
* (1) Account Number
* (2) Date (Range)
* (3) Account Type (Category)
*
*-----------------------------------------------------------------------------
* M o d i f i c a t i o n H i s t o r y :
* ----------------------------------------
*
* Done By : Indumathi Saravanan, Thesys Tech, sindumathi@thesys.co.in
* Date of Coding : 16 Nov 2010
*
* Modified By : Indumathi Saravanan, Thesys Tech, sindumathi@thesys.co.in
* Date Modified : 26 Nov 2010 ;* Changes made to pick the amount after transaction field
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   = to EQ,VM to @VM , SM to @SM
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*26-12-2023      HARISHVIKRAM                 R22 Manual conversion        Changed the variable miss match in F.READ
*----------------------------------------------------------------------------------------





*-----------------------------------------------------------------------------
* Insert files that are used within the routine

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.EB.SYSTEM.ID
    $INSERT I_F.CATEGORY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.RELATION
    $INSERT I_F.EB.CONTRACT.BALANCES
    $USING EB.LocalReferences
*
    GOSUB INITIALIZE
    GOSUB SELECT.PROCESS

RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*----------

* File Variable Initialization <STARTS>

* File Names: ACCOUNT,STMT.PRINTED,STMT.ENTRY,STMT.ENTRY.DETAIL.XREF,STMT.ENTRY.DETAIL,EB.SYSTEM.ID,CATEGORY & CUSTOMER

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    FN.STMT.PRINTED = 'F.STMT.PRINTED'
    F.STMT.PRINTED = ''
    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY = ''
    FN.STMT.ENTRY.DETAIL.XREF = 'F.STMT.ENTRY.DETAIL.XREF'
    F.STMT.ENTRY.DETAIL.XREF = ''
    FN.STMT.ENTRY.DETAIL = 'F.STMT.ENTRY.DETAIL'
    F.STMT.ENTRY.DETAIL = ''
    FN.EB.SYSTEM.ID = 'F.EB.SYSTEM.ID'
    F.EB.SYSTEM.ID = ''
    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY = ''
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = '' ;* File Variable Initialization <ENDS>
    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
* Local Variable Initialization <STARTS>

    Y.AC.ID = '' ; Y.DATE.RG = '' ; Y.CATEGORY = ''
    Y.SEL.CMD = '' ; Y.SEL.LIST = '' ; NOR = ''
    RC = '' ; Y.SE.ID = '' ; Y.AUTHORISER = ''
    Y.VALUE.DATE = '' ; Y.DATE.TIME = '' ; Y.SYSTEM.ID = ''
    Y.TRANS.CODE = '' ; Y.TRANS.DESC = '' ; Y.TRANS.REF = ''
    Y.AMOUNT = '' ; Y.DR.AMOUNT = '' ; Y.CR.AMOUNT = ''
    Y.POST = '' ; Y.INPUTTER = '' ; Y.POST.AMT = 0
    Y.TIME.DATE = '' ; Y.TIME.DATE1 = '' ; Y.CLASS = '' ;* Local Variable Initialization <ENDS>

* Open the initialized file variables <STARTS>

    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.STMT.PRINTED,F.STMT.PRINTED)
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)
    CALL OPF(FN.STMT.ENTRY.DETAIL.XREF,F.STMT.ENTRY.DETAIL.XREF)
    CALL OPF(FN.STMT.ENTRY.DETAIL,F.STMT.ENTRY.DETAIL)
    CALL OPF(FN.EB.SYSTEM.ID,F.EB.SYSTEM.ID)
    CALL OPF(FN.CATEGORY,F.CATEGORY)
    CALL OPF(FN.RELATION,F.RELATION)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER) ;* Open the initialized file variables <ENDS>



RETURN

*-----------------------------------------------------------------------------
SELECT.PROCESS:
*--------------

* Fetching the selection criteria values here

    LOCATE "ACCOUNT.NUMBER" IN D.FIELDS<1> SETTING FIELD1.POS THEN
        Y.AC.ID = D.RANGE.AND.VALUE<FIELD1.POS>
    END

    LOCATE "DATE" IN D.FIELDS<1> SETTING FIELD2.POS THEN
        Y.DATE.RG = D.RANGE.AND.VALUE<FIELD2.POS>
    END

    LOCATE "ACCOUNT.TYPE" IN D.FIELDS<1> SETTING FIELD3.POS THEN
        Y.CATEGORY = D.RANGE.AND.VALUE<FIELD3.POS>
    END

    Y.TIME.DATE = TIMEDATE() ; Y.TIME.DATE1 = Y.TIME.DATE[1,8] ;* Fetching current time

    IF Y.AC.ID THEN
* Y.CLASS = '' ; Y.CLASS = "Account Number - ":Y.AC.ID
        Y.SEL.CMD = "SSELECT ":FN.STMT.PRINTED:" WITH @ID LIKE ":Y.AC.ID:"-..."
        GOSUB MAIN.SELECT
    END ELSE
        Y.SEL.CMD = "SSELECT ":FN.STMT.PRINTED
        GOSUB MAIN.SELECT
    END

RETURN

*-----------------------------------------------------------------------------
MAIN.SELECT:
*-----------

* Main select from the file STMT.PRINTED and while reading check the date range entered
* in the selection with the date in the @ID and cross check the A/C category if selection
* has the account type in it

    CALL EB.READLIST(Y.SEL.CMD,Y.SEL.LIST,'',NOR,RC)
    IF Y.SEL.LIST THEN
        LOOP
            REMOVE Y.SP.ID FROM Y.SEL.LIST SETTING ID.POS
        WHILE Y.SP.ID:ID.POS
            GOSUB ACCOUNT.READ
        REPEAT
    END

RETURN

*-----------------------------------------------------------------------------
ACCOUNT.READ:
*------------

    Y.ACCT.NO = '' ; Y.ACCT.NO = FIELD(Y.SP.ID,'-',1,1)
    Y.ID.DATE = '' ; Y.ID.DATE = FIELD(Y.SP.ID,'-',2,1)
    R.ACCOUNT = '' ; Y.READ.ERR = '' ; Y.POST.AMT = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,Y.READ.ERR)
*TUS START
    CALL EB.READ.HVT ('EB.CONTRACT.BALANCES',Y.ACCT.NO, R.ECB, ECB.ERR)
*TUS END
    IF R.ACCOUNT THEN
        GOSUB GET.AC.CUS.DETAILS
        IF Y.CATEGORY THEN
            IF Y.CATEGORY EQ Y.AC.CATEG THEN ;* If selection category matches AC category
                GOSUB CHECK.DATE
            END
        END ELSE
            GOSUB CHECK.DATE
        END
    END

RETURN

*-----------------------------------------------------------------------------
GET.AC.CUS.DETAILS:
*------------------

    Y.ACCT.CCY = '' ; Y.ACCT.CCY = R.ACCOUNT<AC.CURRENCY>
    Y.AC.CATEG = '' ; Y.AC.CATEG = R.ACCOUNT<AC.CATEGORY>
    Y.ALT.AC = '' ; Y.ALT.AC = R.ACCOUNT<AC.ALT.ACCT.ID>
    Y.OP.AC.BAL = '' ;
*TUS START
*Y.OP.AC.BAL = R.ACCOUNT<AC.OPEN.ACTUAL.BAL>
    Y.OP.AC.BAL = R.ECB<ECB.OPEN.ACTUAL.BAL>
*TUS END
    Y.CUST.ID = '' ; Y.CUST.ID = R.ACCOUNT<AC.CUSTOMER>

*
    IF Y.CUST.ID THEN
        LOC.L.CU.TIPO.CL.POS = '' ; Y.ACC.NAMES = '' ; Y.CUS.NAME = '' ; Y.CUS.NAMES = ''
*        CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',LOC.L.CU.TIPO.CL.POS)
        EB.LocalReferences.GetLocRef('CUSTOMER','L.CU.TIPO.CL',LOC.L.CU.TIPO.CL.POS)          ;*R22 Manual Conversion

        R.CUSTOMER = '' ; ERR.CUSTOMER = ''
        CALL F.READ(FN.CUSTOMER,Y.CUST.ID,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
*
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
        END
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END
        IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
        END
*
        Y.REL.CNT = DCOUNT(R.ACCOUNT<AC.RELATION.CODE,@VM)
        Y.CNT = 1
        IF Y.REL.CNT THEN
            LOOP
            WHILE Y.CNT LE Y.REL.CNT
                Y.REL.CODE = R.ACCOUNT<AC.RELATION.CODE,Y.CNT>
                Y.JOINT.HOLDER = R.ACCOUNT<AC.JOINT.HOLDER,Y.CNT>
                IF Y.REL.CODE GE 500 AND Y.REL.CODE LE 529 THEN
                    R.RELATION = '' ; ERR.RELATION = ''
                    CALL F.READ(FN.RELATION,Y.REL.CODE,R.RELATION,F.RELATION,ERR.RELATION)
                    IF R.RELATION THEN
                        Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>
                    END
                    R.CUSTOMER1 = '' ; ERR.CUSTOMER1 = ''
*                    CALL F.READ(FN.USTOMER,Y.JOINT.HOLDER,R.CUSTOMER1,F.CUSTOMER,ERR.CUSTOMER)
                    CALL F.READ(FN.CUSTOMER,Y.JOINT.HOLDER,R.CUSTOMER1,F.CUSTOMER,ERR.CUSTOMER)     ;*R22 Manual Conversion
                    Y.CUS.NAMES = ''

                    IF R.CUSTOMER1<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER1<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
                        Y.CUS.NAMES = R.CUSTOMER1<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER1<EB.CUS.FAMILY.NAME>
                    END
                    IF R.CUSTOMER1<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
                        Y.CUS.NAMES = R.CUSTOMER1<EB.CUS.NAME.1,1>:" ":R.CUSTOMER1<EB.CUS.NAME.2,1>
                    END
                    IF NOT(R.CUSTOMER1<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
                        Y.CUS.NAMES = R.CUSTOMER1<EB.CUS.SHORT.NAME,1>
                    END
                    Y.ACC.NAMES<-1> = Y.CUS.NAME:'-':Y.REL.DESC:'-':Y.CUS.NAMES
                END
                Y.CNT += 1
            REPEAT
            CHANGE @FM TO @VM IN Y.ACC.NAMES
        END
        IF Y.ACC.NAMES THEN
            Y.ACCT.NAME = Y.ACC.NAMES
        END ELSE
            IF Y.CUS.NAME THEN
                Y.ACCT.NAME = Y.CUS.NAME
            END
        END
    END ELSE
        Y.ACCT.NAME = R.ACCOUNT<AC.ACCOUNT.TITLE.1>
    END
*

RETURN

*-----------------------------------------------------------------------------
CHECK.DATE:
*-----------

    IF Y.DATE.RG THEN
        Y.FROM.DATE = '' ; Y.FROM.DATE = FIELD(Y.DATE.RG,@SM,1,1)
        Y.TO.DATE = '' ; Y.TO.DATE = FIELD(Y.DATE.RG,@SM,2,1)
        IF (Y.ID.DATE GE Y.FROM.DATE) AND (Y.ID.DATE LE Y.TO.DATE) THEN ;* If selection date is within range
            GOSUB FETCH.VALUES
        END
    END ELSE
        GOSUB FETCH.VALUES
    END

RETURN

*-----------------------------------------------------------------------------
FETCH.VALUES:
*------------

    R.STMT.PRINTED = '' ; Y.READ.ERR = ''
    CALL F.READ(FN.STMT.PRINTED,Y.SP.ID,R.STMT.PRINTED,F.STMT.PRINTED,Y.READ.ERR)
    IF R.STMT.PRINTED THEN
        Y.SE.COUNT = '' ; Y.SE.COUNT = DCOUNT(R.STMT.PRINTED,@FM)
        Y.SE.CTR = 1
        LOOP
        WHILE Y.SE.CTR LE Y.SE.COUNT
            Y.SE.ID = R.STMT.PRINTED<Y.SE.CTR>
            GOSUB READ.STMT.ENTRY
            GOSUB DATA.EXTRACT
            Y.SE.CTR +=1
        REPEAT
    END

RETURN

*-----------------------------------------------------------------------------
READ.STMT.ENTRY:
*---------------

    R.STMT.ENTRY = '' ; Y.READ.ERR = ''
    CALL F.READ(FN.STMT.ENTRY,Y.SE.ID,R.STMT.ENTRY,F.STMT.ENTRY,Y.READ.ERR)
    IF (R.STMT.ENTRY) AND NOT(ALPHA(Y.SE.ID)) THEN
        Y.VALUE.DATE = '' ; Y.VALUE.DATE = R.STMT.ENTRY<AC.STE.VALUE.DATE>
        Y.DATE.TIME = '' ; Y.DATE.TIME = R.STMT.ENTRY<AC.STE.DATE.TIME>
        Y.SYSTEM.ID = '' ; Y.SYSTEM.ID = R.STMT.ENTRY<AC.STE.SYSTEM.ID>
        Y.TRANS.CODE = '' ; Y.TRANS.CODE = R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
        Y.TRANS.REF = '' ; Y.TRANS.REF = R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
        Y.AMOUNT = '' ; Y.AMOUNT = R.STMT.ENTRY<AC.STE.AMOUNT.LCY>

        Y.INPUTTER = '' ; Y.INPUTTER = R.STMT.ENTRY<AC.STE.INPUTTER>
        Y.AUTHORISER = '' ; Y.AUTHORISER = R.STMT.ENTRY<AC.STE.AUTHORISER>
*
        Y.INPUTTER = FIELD(R.STMT.ENTRY<AC.STE.INPUTTER,1>,'_',2,1)
        D.IN.CNT = DCOUNT(Y.INPUTTER,@VM) + 1 ; Y.IN.CNT = 2
        IF D.IN.CNT GT 1 THEN
            LOOP
            WHILE Y.IN.CNT LE D.IN.CNT
                Y.INPUTTER := '/':FIELD(R.STMT.ENTRY<AC.STE.INPUTTER,Y.IN.CNT>,'_',2,1)
                Y.IN.CNT += 1
            REPEAT
        END
*
        Y.AUTHORISER = FIELD(Y.AUTHORISER,'_',2,1)

        IF Y.AMOUNT LT 0 THEN
            Y.DR.AMOUNT = Y.AMOUNT ; Y.CR.AMOUNT = 0
        END ELSE
            Y.CR.AMOUNT = Y.AMOUNT ; Y.DR.AMOUNT = 0
        END

        Y.POST = Y.OP.AC.BAL + Y.AMOUNT
        Y.POST.AMT += Y.POST

        IF Y.SYSTEM.ID THEN
            GOSUB GET.SYSTEM.ID
        END

        IF Y.AC.CATEG THEN
            GOSUB GET.CATEG.DESC
        END
    END ELSE
        Y.SE.DET.ID = '' ; Y.SE.DET.ID = Y.SE.ID:'-1'
        GOSUB READ.STMT.ENTRY.DETAIL.XREF
    END

RETURN

*-----------------------------------------------------------------------------
READ.STMT.ENTRY.DETAIL.XREF:
*---------------------------

    R.STMT.ENTRY.DETAIL.XREF = '' ; Y.READ.ERR = ''
    CALL F.READ(FN.STMT.ENTRY.DETAIL.XREF,Y.SE.DET.ID,R.STMT.ENTRY.DETAIL.XREF,F.STMT.ENTRY.DETAIL.XREF,Y.READ.ERR)
    IF R.STMT.ENTRY.DETAIL.XREF THEN
        Y.SE.DET.COUNT = '' ; Y.SE.DET.COUNT = DCOUNT(R.STMT.ENTRY.DETAIL.XREF,@FM)
        Y.SE.DET.CTR = 1
        LOOP
        WHILE Y.SE.DET.CTR LE Y.SE.DET.COUNT
            Y.SED.ID = R.STMT.ENTRY.DETAIL.XREF<Y.SE.DET.CTR>
            GOSUB READ.STMT.ENTRY.DETAIL
            Y.SE.DET.CTR += 1
        REPEAT
    END

RETURN

*-----------------------------------------------------------------------------
READ.STMT.ENTRY.DETAIL:
*----------------------

    R.STMT.ENTRY.DETAIL = '' ; Y.READ.ERR = ''
*    CALL F.READ(FN.R.STMT.ENTRY.DETAIL,Y.SED.ID,R.STMT.ENTRY.DETAIL,F.STMT.ENTRY.DETAIL,Y.READ.ERR)
    CALL F.READ(FN.STMT.ENTRY.DETAIL,Y.SED.ID,R.STMT.ENTRY.DETAIL,F.STMT.ENTRY.DETAIL,Y.READ.ERR)       ;*R22 Manual Conversion
    IF R.STMT.ENTRY.DETAIL THEN
        Y.VALUE.DATE = '' ; Y.VALUE.DATE = R.STMT.ENTRY.DETAIL<AC.STE.VALUE.DATE>
        Y.DATE.TIME = '' ; Y.DATE.TIME = R.STMT.ENTRY.DETAIL<AC.STE.DATE.TIME>
        Y.SYSTEM.ID = '' ; Y.SYSTEM.ID = R.STMT.ENTRY.DETAIL<AC.STE.SYSTEM.ID>
        Y.TRANS.CODE = '' ; Y.TRANS.CODE = R.STMT.ENTRY.DETAIL<AC.STE.TRANSACTION.CODE>
        Y.TRANS.REF = '' ; Y.TRANS.REF = R.STMT.ENTRY.DETAIL<AC.STE.TRANS.REFERENCE>
        Y.AMOUNT = '' ; Y.AMOUNT = R.STMT.ENTRY.DETAIL<AC.STE.AMOUNT.LCY>
        Y.INPUTTER = '' ; Y.INPUTTER = R.STMT.ENTRY.DETAIL<AC.STE.INPUTTER>
        Y.AUTHORISER = '' ; Y.AUTHORISER = R.STMT.ENTRY.DETAIL<AC.STE.AUTHORISER>
        Y.INPUTTER = FIELD(Y.INPUTTER,'_',2,1)
        Y.AUTHORISER = FIELD(Y.AUTHORISER,'_',2,1)

        IF Y.AMOUNT LT 0 THEN
            Y.DR.AMOUNT = Y.AMOUNT ; Y.CR.AMOUNT = 0
        END ELSE
            Y.CR.AMOUNT = Y.AMOUNT ; Y.DR.AMOUNT = 0
        END

        Y.POST = Y.OP.AC.BAL + Y.AMOUNT
        Y.POST.AMT += Y.POST

        IF Y.SYSTEM.ID THEN
            GOSUB GET.SYSTEM.ID
        END

        IF Y.AC.CATEG THEN
            GOSUB GET.CATEG.DESC
        END
    END

RETURN

*-----------------------------------------------------------------------------
GET.SYSTEM.ID:
*------------

    Y.TRANS.DESC = '' ; R.EB.SYSTEM.ID = '' ; Y.READ.ERR = ''
    CALL CACHE.READ(FN.EB.SYSTEM.ID, Y.SYSTEM.ID, R.EB.SYSTEM.ID, Y.READ.ERR)
    IF R.EB.SYSTEM.ID THEN
        Y.TRANS.DESC = R.EB.SYSTEM.ID<SID.DESCRIPTION,1>
    END

RETURN

*-----------------------------------------------------------------------------
GET.CATEG.DESC:
*-------------

    Y.CATEG.DESC = '' ; R.CATEGORY = '' ; Y.READ.ERR = ''
    CALL CACHE.READ(FN.CATEGORY, Y.AC.CATEG, R.CATEGORY, Y.READ.ERR)
    IF R.CATEGORY THEN
        Y.CATEG.DESC = R.CATEGORY<EB.CAT.DESCRIPTION,1>
        CHANGE '*' TO '' IN Y.CATEG.DESC
    END

RETURN

*-----------------------------------------------------------------------------
DATA.EXTRACT:
*------------

    IF DATA.RETURN EQ '' THEN
        DATA.RETURN = Y.ACCT.NO :'*': Y.CATEG.DESC :'*': Y.ALT.AC :'*':
        DATA.RETURN := Y.ACCT.NAME :'*': Y.ACCT.CCY :'*': Y.OP.AC.BAL :'*':
        DATA.RETURN := Y.VALUE.DATE :'*': Y.DATE.TIME :'*': Y.SYSTEM.ID :'*':
        DATA.RETURN := Y.TRANS.CODE :'*': Y.TRANS.DESC :'*': Y.TRANS.REF :'*':
        DATA.RETURN := Y.DR.AMOUNT :'*': Y.CR.AMOUNT :'*': Y.POST.AMT :'*':
        DATA.RETURN := Y.INPUTTER :'*': Y.AUTHORISER :'*': Y.TIME.DATE1 :'*':
* DATA.RETURN := Y.CLASS
    END ELSE
        DATA.RETURN :=@FM: Y.ACCT.NO :'*': Y.CATEG.DESC :'*': Y.ALT.AC :'*':
        DATA.RETURN := Y.ACCT.NAME :'*': Y.ACCT.CCY :'*': Y.OP.AC.BAL :'*':
        DATA.RETURN := Y.VALUE.DATE :'*': Y.DATE.TIME :'*': Y.SYSTEM.ID :'*':
        DATA.RETURN := Y.TRANS.CODE :'*': Y.TRANS.DESC :'*': Y.TRANS.REF :'*':
        DATA.RETURN := Y.DR.AMOUNT :'*': Y.CR.AMOUNT :'*': Y.POST.AMT :'*':
        DATA.RETURN := Y.INPUTTER :'*': Y.AUTHORISER :'*': Y.TIME.DATE1 :'*':
* DATA.RETURN := Y.CLASS
    END

RETURN

*-----------------------------------------------------------------------------
END
