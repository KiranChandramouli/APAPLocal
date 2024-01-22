* @ValidationCode : MjoxMTM0OTMwMTk5OlVURi04OjE3MDU5MTczNzAwMDA6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Jan 2024 15:26:10
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.ENQ.GET.STMT.DATES
*
* Client : APAP
* Description: The conversion routine attached to the Enquiry 'REDO.ACCT.STMT.HIST' to get the statement balance.
*
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 12-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM , Added FN variable , < to LT , = to EQ and VM to @VM
* 12-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 03-01-2024         Narmadha V            R22 Utility Changes,Manual R22 Conversion -  CALL OPF ADDED
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.STATEMENT
    $INSERT I_F.AC.STMT.PARAMETER
*

    GOSUB INIT
    GOSUB PROCESS
RETURN


INIT:
*****
    FN.ACCT.STMT.PRINT = 'F.ACCT.STMT.PRINT'; F.ACCT.STMT.PRINT = ""
    CALL OPF(FN.ACCT.STMT.PRINT,F.ACCT.STMT.PRINT) ;*Manual R22 Conversion -  CALL OPF ADDED
    FN.ACCT.STMT.PRINT.2 = "F.ACCT.STMT.PRINT"   ;*R22 Auto Conversion  - Added FN variable
    CALL OPF(FN.ACCT.STMT.PRINT.2, F.ACCT.STMT.PRINT)
    FN.ACCOUNT.STATEMENT = 'F.ACCOUNT.STATEMENT'; F.ACCOUNT.STATEMENT = ""
    CALL OPF(FN.ACCOUNT.STATEMENT,F.ACCOUNT.STATEMENT) ;*Manual R22 Conversion -  CALL OPF ADDED
    FN.ACCOUNT.STATEMENT.2 = "F.ACCOUNT.STATEMENT"	;*R22 Auto Conversion  - Added FN variable
    CALL OPF(FN.ACCOUNT.STATEMENT.2, F.ACCOUNT.STATEMENT)
    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT) ;*Manual R22 Conversion -  CALL OPF ADDED
    FN.ACCOUNT.2 = "F.ACCOUNT"	               ;*R22 Auto Conversion  - Added FN variable
    CALL OPF(FN.ACCOUNT.2, F.ACCOUNT)
    FN.AC.STMT.PARAMETER = 'F.AC.STMT.PARAMETER'; F.AC.STMT.PARAMETER = ''
    CALL OPF(FN.AC.STMT.PARAMETER,F.AC.STMT.PARAMETER)
RETURN

PROCESS:
********
    ACCT.NO = O.DATA

    AC.STMT.REC = ""; ACCT.STMT.PRINT = ''
    CALL F.READ(FN.ACCT.STMT.PRINT, ACCT.NO, AC.STMT.REC, F.ACCT.STMT.PRINT,ACCT.STMT.PRINT.ERR)
    ACCT.STMT.REC = ""; ACCOUNT.STATEMENT = ''
    CALL F.READ(FN.ACCOUNT.STATEMENT, ACCT.NO, ACCT.STMT.REC, F.ACCOUNT.STATEMENT,ERR.ACCOUNT.STATEMENT)

    R.RECORD<1> = LOWER(FIELDS(AC.STMT.REC,"/",1))          ;* Dates
    R.RECORD<2> = LOWER(FIELDS(AC.STMT.REC,"/",2))          ;* Opening balance
    R.RECORD<3> = R.RECORD<2> ; DEL R.RECORD<3,1> ;* Closing balance

    Y.STMT.CNT = DCOUNT(R.RECORD<1>,@VM)
    Y.LAST.STMT.DATE = R.RECORD<1,Y.STMT.CNT>
    Y.LAST.BAL = ACCT.STMT.REC<AC.STA.FQU1.LAST.BALANCE>    ;* Last closing balance
    IF Y.LAST.BAL EQ '' THEN
        Y.LAST.BAL = 0
    END

    IF ACCT.STMT.REC THEN
        IF Y.LAST.STMT.DATE LT TODAY THEN
            R.RECORD<3,-1> = Y.LAST.BAL
            R.RECORD<1,-1> = TODAY
            R.RECORD<2,-1> = Y.LAST.BAL
        END ELSE
            IF Y.STMT.CNT NE 1 THEN
                R.RECORD<3,Y.STMT.CNT-1> = Y.LAST.BAL
            END
            R.RECORD<1,Y.STMT.CNT> = TODAY
            R.RECORD<2,Y.STMT.CNT> = Y.LAST.BAL
        END

        R.ACCT = ""; ERR.ACCOUNT = ''
        CALL F.READ(FN.ACCOUNT, ACCT.NO, R.ACCT, F.ACCOUNT,ERR.ACCOUNT)
        ERR.AC.STMT.PARAMETER = ''; R.AC.STMT.PARAMETER = ''; FWD.MVMT.REQD = ''
*CALL CACHE.READ(FN.AC.STMT.PARAMETER,'SYSTEM',R.AC.STMT.PARAMETER,ERR.AC.STMT.PARAMETER)
        IDVAR.1 = 'SYSTEM' ;* R22 Utility Changes
        CALL CACHE.READ(FN.AC.STMT.PARAMETER,IDVAR.1,R.AC.STMT.PARAMETER,ERR.AC.STMT.PARAMETER);* R22 Utility Changes
        FWD.MVMT.REQD = R.AC.STMT.PARAMETER<AC.STP.FWD.MVMT.REQD>

        IF FWD.MVMT.REQD THEN
            CNT = DCOUNT(R.ACCT<AC.VALUE.DATED.BAL>,@VM)
            IF CNT THEN
                R.RECORD<3,-1> = R.ACCT<AC.VALUE.DATED.BAL,CNT>
            END ELSE
                R.RECORD<3,-1> = R.ACCT<AC.ONLINE.ACTUAL.BAL>
            END
        END ELSE
            R.RECORD<3,-1> = R.ACCT<AC.ONLINE.ACTUAL.BAL>
        END

    END ELSE
        R.RECORD<3,-1> = "0"  ;* Must be closed
    END
    VM.COUNT = DCOUNT(R.RECORD<1>,@VM)

RETURN

END
