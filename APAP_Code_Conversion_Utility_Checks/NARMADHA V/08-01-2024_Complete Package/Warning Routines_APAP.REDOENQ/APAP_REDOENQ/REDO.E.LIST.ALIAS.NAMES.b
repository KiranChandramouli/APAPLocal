$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.LIST.ALIAS.NAMES(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Sakthi Sellappillai
* Program Name : REDO.E.GET.ACCT.USER
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry REDO.SAV.ACCOUNT.LIST
* Linked with : Enquiry REDO.SAV.ACCOUNT.LIST  as BUILD routine
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*05/05/11       PACS00055393            GANESH H                MODIFICAION
*26-08-11       PACS00102015            PRABHU N                MODIFICATION
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN , F.READ to CACHE.READ , VM to @VM , FM to @FM and SM to @SM
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.PARAMETER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ENQUIRY

    GOSUB INITIALISE
    GOSUB READ.PARAM.FILES
    GOSUB PROCESS
    GOSUB FORM.ENQ.DATA

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    F.ACCOUNT.PARAM=''
    FN.ACCOUNT.PARAM='F.ACCOUNT.PARAMETER'
*  CALL OPF(FN.ACCOUNT.PARAM,F.ACCOUNT.PARAM)

    F.CUSTOMER.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    R.CUSTOMER.ACCOUNT.REC = ''
    Y.CUST.ACCT.ERR = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    F.ACCOUNT=''
    FN.ACCOUNT='F.ACCOUNT'
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    F.AZ.ACCOUNT=''
    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    FN.ENQUIRY = 'F.ENQUIRY'
    F.ENQUIRY = ''
    CALL OPF(FN.ENQUIRY,F.ENQUIRY)

    Y.VAR.EXT.CUSTOMER = ''
    ENQ.ID='AI.REDO.SAV.ACCOUNT.LIST.CHANGE'
    Y.VAR.EXT.ACCOUNTS=''
    AC.STATUS.POS=''
    AC.FLD.POS=''
    Y.FIELD.COUNT = ''
    AC.APP='ACCOUNT'
    AC.FLD='L.AC.STATUS1'
    PRINT.AMT=''
    CALL MULTI.GET.LOC.REF(AC.APP,AC.FLD,AC.FLD.POS)
    AC.STATUS.POS=AC.FLD.POS<1,1>


RETURN
******************
READ.PARAM.FILES:
*****************
*PACS00055393-S
    SYSTEM.ID ='SYSTEM'
    CALL CACHE.READ(FN.ACCOUNT.PARAM,SYSTEM.ID,R.PARAM.REC,AC.PARAM.ERR)
    IF NOT(AC.PARAM.ERR) THEN
        CATEG.DESC       = R.PARAM.REC<AC.PAR.ACCT.CATEG.DESC>
        CHANGE @VM TO @FM IN CATEG.DESC
        FINDSTR "Savings" IN CATEG.DESC SETTING SAV.DESC.POS THEN
            SAV.CATG.START.RG=R.PARAM.REC<AC.PAR.ACCT.CATEG.STR,SAV.DESC.POS>
            SAV.CATG.END.RG = R.PARAM.REC<AC.PAR.ACCT.CATEG.END,SAV.DESC.POS>
        END
        FINDSTR "Current" IN CATEG.DESC SETTING CUR.DESC.POS THEN
            CUR.CATG.START.RG=R.PARAM.REC<AC.PAR.ACCT.CATEG.STR,CUR.DESC.POS>
            CUR.CATG.END.RG = R.PARAM.REC<AC.PAR.ACCT.CATEG.END,CUR.DESC.POS>
        END
    END
    CALL CACHE.READ(FN.ENQUIRY, ENQ.ID, R.ENQUIRY, ERR.ENQ)    ;*R22 Auto Conversion  - F.READ to CACHE.READ
    IF NOT(ERR.ENQ) THEN
        SAV.CUR.CATEG=R.ENQUIRY<ENQ.FIXED.SELECTION><1,2>
        CHANGE ' ' TO '*' IN SAV.CUR.CATEG
        SAV.CUR.END.RG=FIELD(SAV.CUR.CATEG,'*',4)
    END

    Y.VAR.EXT.CUSTOMER = System.getVariable('EXT.CUSTOMER')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.VAR.EXT.CUSTOMER = ""
    END
    R.CUSTOMER.ACCOUNT.REC= System.getVariable("EXT.CUSTOMER.ACCOUNTS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN	 ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        R.CUSTOMER.ACCOUNT.REC = ""
    END

    CHANGE @SM TO @FM IN R.CUSTOMER.ACCOUNT.REC
    TOT.ACCOUNTS = DCOUNT(R.CUSTOMER.ACCOUNT.REC,@FM)
*PACS00055393-E
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    FOR CNT.ACCT=1 TO TOT.ACCOUNTS
        ACCT.ID =R.CUSTOMER.ACCOUNT.REC<CNT.ACCT>

        GOSUB READ.ACCOUNT
        GOSUB READ.AZ.ACCOUNT
    NEXT CNT.ACCT


RETURN
**************
READ.ACCOUNT:
*************
    CALL F.READ(FN.ACCOUNT,ACCT.ID,ACCT.REC,F.ACCOUNT,ACCOUNT.ERR)
    IF NOT(ACCOUNT.ERR) THEN
        ARR.ID=ACCT.REC<AC.ARRANGEMENT.ID>
        ACCT.STATUS=ACCT.REC<AC.LOCAL.REF,AC.STATUS.POS>
        ACCT.CATEGORY = ACCT.REC<AC.CATEGORY>
        IF ACCT.STATUS EQ 'ACTIVE' THEN
            IF ACCT.CATEGORY GE CUR.CATG.START.RG AND ACCT.CATEGORY LE SAV.CUR.END.RG THEN
                Y.VAR.EXT.ACCOUNTS<-1>=ACCT.ID
            END
        END
    END

RETURN

****************
READ.AZ.ACCOUNT:
*****************
    CALL F.READ(FN.AZ.ACCOUNT,ACCT.ID,AZ.REC,F.AZ.ACCOUNT,AZ.ERR)
    IF NOT(AZ.ERR) THEN
        PRIN.AMT=AZ.REC<AZ.PRINCIPAL>
        IF PRIN.AMT GT '0' THEN
            Y.VAR.EXT.ACCOUNTS<-1>=ACCT.ID
        END
    END

RETURN
FORM.ENQ.DATA:
**************
    Y.FIELD.COUNT = DCOUNT(ENQ.DATA<2>,@VM)
    CHANGE @FM TO ' ' IN Y.VAR.EXT.ACCOUNTS
    ENQ.DATA<2, Y.FIELD.COUNT +1>= '@ID'
    ENQ.DATA<3, Y.FIELD.COUNT +1> = 'EQ'
    ENQ.DATA<4, Y.FIELD.COUNT +1>= Y.VAR.EXT.ACCOUNTS

RETURN
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
