* @ValidationCode : Mjo2MTA3NDg3ODE6Q3AxMjUyOjE2ODQ4NDIxMDA4MjY6SVRTUzotMTotMTo0OTk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 499
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
    CALL JOURNAL.UPDATE('')
RETURN
END
