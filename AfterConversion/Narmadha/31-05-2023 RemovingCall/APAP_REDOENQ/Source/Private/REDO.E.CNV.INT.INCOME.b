* @ValidationCode : Mjo2Njk0Nzk5MjE6Q3AxMjUyOjE2ODIwNzMzODI3OTQ6SVRTUzotMTotMTo5NzA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 970
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.INT.INCOME
*----------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : NAVEENKUMAR N
* Program Name  : REDO.E.CNV.INT.INCOME
*----------------------------------------------------------
* Description   : This subroutine is attached as a conversion routine in the Enquiry REDO.REINVESTED.ACCT.STMT
* Linked with   : Enquiry REDO.REINVESTED.ACCT.STMT as conversion routine
* In Parameter  : None
* Out Parameter : None
*-----------------------------------------------------------------------------
* Modification Details:
*=====================
* 24/08/2010 - ODR-2010-08-0192
* 17-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, VM to @VM,  ++ to +=
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.ACCOUNT
*   $INSERT I_F.STMT.ENTRY ;*R22 Auto conversion
    $INSERT I_F.STMT.ACCT.CR
    $INSERT I_F.ACCOUNT.STATEMENT
*
    GOSUB INIT

    GOSUB PROCESS
RETURN
*****
INIT:
*****
* Initialising Necessary Variables
*
    FN.STMT.ENTRY  = "F.STMT.ENTRY"
    F.STMT.ENTRY   = ""
    R.STMT.ENTRY   = ""
    E.STMT.ENTRY   = ""
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.STMT.ACCT.CR  = "F.STMT.ACCT.CR"
    F.STMT.ACCT.CR   = ""
    R.STMT.ACCT.CR   = ""
    E.STMT.ACCT.CR   = ""
    CALL OPF(FN.STMT.ACCT.CR,F.STMT.ACCT.CR)

    FN.ACCOUNT.STATEMENT="F.ACCOUNT.STATEMENT"
    F.ACCOUNT.STATEMENT = ""
    R.ACCOUNT.STATEMENT = ""
    E.ACCOUNT.STATEMENT = ""
    CALL OPF(FN.ACCOUNT.STATEMENT,F.ACCOUNT.STATEMENT)

*
    FN.ACCOUNT     = "F.ACCOUNT"
    F.ACCOUNT      = ""
    R.ACCOUNT      = ""
    E.ACCOUNT      = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*

    FN.AZ.ACCOUNT     = "F.AZ.ACCOUNT"
    F.AZ.ACCOUNT      = ""
    R.AZ.ACCOUNT      = ""
    E.AZ.ACCOUNT      = ""
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    Y.CR.AMOUNT    = ""
    TOT.CR.AMOUNT  = ""
    Y.ID.LIST      = ""
    Y.SE.ID.LIST   = ""
    Y.CR.INT.AMT   = ""
    Y.BASE.CR.AMOUNT = ""
    Y.AZ.CR.AMOUNT = ""


    LOC.REF.APPLICATION="ACCOUNT"
    LOC.REF.FIELDS='L.AC.AZ.ACC.REF'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AC.AZ.ACC.REF=LOC.REF.POS<1,1>
RETURN
********
PROCESS:
********
* Main process to fetch the necessary values
*

    Y.INTEREST.LIQ.ACCT = R.RECORD<AZ.INTEREST.LIQU.ACCT>
    Y.INT.LIQ.ACCT = Y.INTEREST.LIQ.ACCT:'...'
    CALL F.READ(FN.ACCOUNT,Y.INTEREST.LIQ.ACCT,R.ACCOUNT,F.ACCOUNT,E.ACCOUNT)
    Y.BASE.ACCOUNT = R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.AZ.ACC.REF>:'...'
    Y.MAIN.ACCOUNT = R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.AZ.ACC.REF>
    CALL F.READ(FN.ACCOUNT.STATEMENT,Y.MAIN.ACCOUNT,R.ACCOUNT.STATEMENT,F.ACCOUNT.STATEMENT,E.ACCOUNT.STATEMENT)
    Y.VALUE.DATE = R.ACCOUNT.STATEMENT<AC.STA.FQU1.LAST.DATE>
    IF NOT(Y.VALUE.DATE) THEN
        CALL F.READ(FN.AZ.ACCOUNT,Y.MAIN.ACCOUNT,R.AZ.ACCOUNT,F.AZ.ACCOUNT,E.AZ.ACCOUNT)
        Y.VALUE.DATE =  R.AZ.ACCOUNT<AZ.VALUE.DATE>
    END
    Y.AZ.CR.AMOUNT   = R.ACCOUNT<AC.ACCR.CR.AMOUNT>
    IF Y.MAIN.ACCOUNT AND Y.INTEREST.LIQ.ACCT THEN
        SEL.ACCT.CR  = "SELECT ":FN.STMT.ACCT.CR:" WITH @ID LIKE ":Y.INT.LIQ.ACCT:" OR @ID LIKE ":Y.BASE.ACCOUNT
        CALL EB.READLIST(SEL.ACCT.CR,SEL.ACCR.ID,'',NO.OF.REC.ARR,SEL.RET.ARR)
    END

    LOOP
        REMOVE Y.ACCR.ID FROM SEL.ACCR.ID SETTING Y.ACCR.POS
    WHILE Y.ACCR.ID:Y.ACCR.POS

        GOSUB ALL.DETAILS
    REPEAT
    R.ACCOUNTS = ''
    CALL F.READ(FN.ACCOUNT,Y.MAIN.ACCOUNT,R.ACCOUNTS,F.ACCOUNT,E.ACCOUNT)
    Y.BASE.CR.AMOUNT   = R.ACCOUNTS<AC.ACCR.CR.AMOUNT>
    TOT.CR.AMOUNT = Y.BASE.CR.AMOUNT + Y.AZ.CR.AMOUNT + Y.CR.INT.AMT
    O.DATA        = TOT.CR.AMOUNT
RETURN
************
ALL.DETAILS:
************
    ENQ.SEL = ENQ.SELECTION<2>
    CHANGE @VM TO @FM IN ENQ.SEL
*
    LOCATE "MATURITY.DATE" IN ENQ.SEL SETTING MATURITY.POS THEN
        Y.CLOSE.DATE = ENQ.SELECTION<4,MATURITY.POS>
    END
    IF NOT(Y.CLOSE.DATE) THEN
        Y.CLOSE.DATE = TODAY
    END
*
    CALL F.READ(FN.STMT.ACCT.CR,Y.ACCR.ID,R.STMT.ACCT.CR,F.STMT.ACCT.CR,E.STMT.ACCT.CR)
    Y.TOT.CR.INT.DATE = R.STMT.ACCT.CR<IC.STMCR.CR.INT.DATE>
    Y.TOT.CR.INT.AMT  = R.STMT.ACCT.CR<IC.STMCR.CR.INT.AMT>
    Y.TOT.DATE = DCOUNT(Y.TOT.CR.INT.DATE,@VM)
    CHANGE @VM TO @FM IN Y.TOT.CR.INT.DATE
    CHANGE @VM TO @FM IN Y.TOT.CR.INT.AMT
    Y.INIT.DATE  = 1
    LOOP
    WHILE Y.INIT.DATE LE Y.TOT.DATE
        Y.CR.INT.DATE  = Y.TOT.CR.INT.DATE<Y.INIT.DATE>

        IF Y.CR.INT.DATE GE Y.VALUE.DATE AND Y.CR.INT.DATE LE Y.CLOSE.DATE THEN
            Y.CR.INT.AMT += Y.TOT.CR.INT.AMT<Y.INIT.DATE>
        END
        Y.INIT.DATE += 1
    REPEAT

RETURN
*******************
END
