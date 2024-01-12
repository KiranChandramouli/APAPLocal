* @ValidationCode : Mjo0Nzc5NTk1NTI6Q3AxMjUyOjE3MDQ4ODkyNDM2OTA6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Jan 2024 17:50:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FORM.CUST.EMPLOYEE
        
*---------------------------------------------------------------------------------
*This is main line routine
*----------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : PRABHU N
* Program Name  : REDO.FORM.CUST.EMPLOYEE
* ODR NUMBER    : ODR-2009-10-0531
*LINKED WITH:APAP.H.GARNISH.DETAILS AS version routine
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
*MODIFICATION DETAILS:
*22-03-2011     B88 PERF ISSUE     Prabhu N         Main line routine to update FBNK.REDO.CUST.EMPLOYEE.one time Run.
** 06-04-2023 R22 Auto Conversion
** 06-04-2023 Skanda R22 Manual Conversion - No changes
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.EMPLOYEE.ACCOUNTS
   $USING EB.TransactionControl

    FN.REDO.CUST.EMPLOYEE='F.REDO.CUST.EMPLOYEE'
    F.REDO.CUST.EMPLOYEE=''
    CALL OPF(FN.REDO.CUST.EMPLOYEE,F.REDO.CUST.EMPLOYEE)
    
    
    FN.REDO.EMPLOYEE.ACCOUNTS='F.REDO.EMPLOYEE.ACCOUNTS'
    F.REDO.EMPLOYEE.ACCOUNTS=''
    CALL OPF(FN.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS)

    Y.SELECT.CMD="SELECT ": FN.REDO.EMPLOYEE.ACCOUNTS
    CALL EB.READLIST(Y.SELECT.CMD,SEL.LIST,'',NO.OF.RECORD,ERR.SEL)
    Y.CNT=1
    LOOP
    WHILE Y.CNT LE NO.OF.RECORD
        CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,SEL.LIST<Y.CNT>,R.RCE,F.REDO.EMPLOYEE.ACCOUNTS,ERR)
        R.REC=R.RCE<REDO.EMP.USER.ID>
        CALL F.WRITE(FN.REDO.CUST.EMPLOYEE,R.REC,SEL.LIST<Y.CNT>)
        Y.CNT += 1 ;* R22 Auto conversion
    REPEAT
*    CALL JOURNAL.UPDATE('')
EB.TransactionControl.JournalUpdate('');* R22 UTILITY AUTO CONVERSION
RETURN
END
