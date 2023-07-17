$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.GET.CHEQUE.USER(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name : REDO.E.GET.CHEQUE.USER
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry AI.REDO.BANK.STOP.PAY.ACCT.LIST
* Linked with : Enquiry AI.REDO.BANK.STOP.PAY.ACCT.LIST as BUILD routine
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*23/08/11      PACS001002015          Prabhu N                MODIFICAION
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion  - VM to @VM , FM to @FM , SM to @SM and ++ to +=
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.CHEQUE.ISSUE
    GOSUB INITIALISE
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.CHEQUE.ISSUE.ACCOUNT='F.CHEQUE.ISSUE.ACCOUNT'
    F.CHEQUE.ISSUE.ACCOUNT=''
    CALL OPF(FN.CHEQUE.ISSUE.ACCOUNT,F.CHEQUE.ISSUE.ACCOUNT)

    FN.CHEQUE.ISSUE='F.CHEQUE.ISSUE'
    F.CHEQUE.ISSUE=''
    CALL OPF(FN.CHEQUE.ISSUE,F.CHEQUE.ISSUE)

    R.CUSTOMER.ACCOUNT.REC= System.getVariable("EXT.CUSTOMER.ACCOUNTS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        R.CUSTOMER.ACCOUNT.REC = ""
    END

    CHANGE @SM TO @FM IN R.CUSTOMER.ACCOUNT.REC
    TOT.ACCOUNTS = DCOUNT(R.CUSTOMER.ACCOUNT.REC,@FM)
    Y.LOOP.CNT=1
    LOOP
    WHILE Y.LOOP.CNT LE TOT.ACCOUNTS
        CALL F.READ(FN.CHEQUE.ISSUE.ACCOUNT,R.CUSTOMER.ACCOUNT.REC<Y.LOOP.CNT>,R.CHEQUE.ISSUE.ACCOUNT,F.CHEQUE.ISSUE.ACCOUNT,ERR)
        IF NOT(ERR) THEN
            GOSUB CHEQUE.STATUS
        END
        Y.LOOP.CNT += 1
    REPEAT
    CHANGE @FM TO ' ' IN Y.VAR.EXT.ACCOUNTS
    ENQ.DATA<2, 1>= '@ID'
    ENQ.DATA<3, 1> = 'EQ'
    ENQ.DATA<4, 1>= Y.VAR.EXT.ACCOUNTS

RETURN
*-------------------------------
CHEQUE.STATUS:
*-------------------------------
    Y.CHEQUE.ISSUE.LIST=R.CHEQUE.ISSUE.ACCOUNT
    Y.CHEQUE.ISSUE.TOT =DCOUNT(R.CHEQUE.ISSUE.ACCOUNT,@FM)
    Y.CHEQUE.ISSUE.CNT=1
    LOOP
    WHILE Y.CHEQUE.ISSUE.CNT LE Y.CHEQUE.ISSUE.TOT
        CALL F.READ(FN.CHEQUE.ISSUE,R.CHEQUE.ISSUE.ACCOUNT<Y.CHEQUE.ISSUE.CNT>,R.CHEQUE.ISSUE,F.CHEQUE.ISSUE,ERR)
        IF R.CHEQUE.ISSUE<CHEQUE.IS.CHEQUE.STATUS> EQ '90' THEN
            Y.VAR.EXT.ACCOUNTS<-1>=R.CUSTOMER.ACCOUNT.REC<Y.LOOP.CNT>
            RETURN
        END
        Y.CHEQUE.ISSUE.CNT += 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
