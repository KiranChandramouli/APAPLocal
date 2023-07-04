* @ValidationCode : Mjo2MTY4MzMyMjpDcDEyNTI6MTY4NDgzNjA0MzA4NjpJVFNTOi0xOi0xOjY3NDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 674
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.MULTI.GET.BILLS
*----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEYACHANDRAN S
* PROGRAM NAME:
* ODR NO      :
*----------------------------------------------------------------------
* DESCRIPTION  :This routine is used to retrieve the values(OD amount and OD Bills) from AA.ACCOUNT.DETAILS application.
* IN PARAMETER :NA
* OUT PARAMETER:NA
* LINKED WITH  :
* LINKED FILE  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                 REFERENCE           DESCRIPTION
* 28.09.2010   Jeyachandran S                           INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   SM to @SM , FM to @FM , VM to @VM , ++ to +=
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MULTI.TRANSACTION.SERVICE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.BILL.DETAILS

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB GOEND
RETURN
*---------
INIT:
RETURN

*--------------
OPENFILES:

    FN.MULTI.TRANSACTION.SERVICE = 'F.MULTI.TRANSACTION.SERVICE'
    F.MULTI.TRANSACTION.SERVICE = ''
    CALL OPF(FN.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCT.ACTIVITY = 'F.ACCT.ACTIVITY'
    F.ACCT.ACTIVITY = ''
    CALL OPF(FN.ACCT.ACTIVITY,F.ACCT.ACTIVITY)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)
RETURN
*-------------
PROCESS:

    Y.MULTI.ARR.ID = COMI
    Y.TYPE = R.NEW(REDO.MTS.SETTLEMENT.TYPE)
    Y.PAY.MODE = R.NEW(REDO.MTS.PAYMENT.MODE)<1,AV>
    Y.PAY.MODE4 = R.NEW(REDO.MTS.PAYMENT.MODE)
    Y.OPERATION = R.NEW(REDO.MTS.OPERATION)

    IF Y.TYPE EQ 'MULTIPLE' THEN
        T(REDO.MTS.ARRANGEMENT.ID)<3> = 'NOINPUT'
    END

    IF Y.TYPE EQ 'MULTIPLE' AND Y.PAY.MODE NE '' AND Y.OPERATION EQ 'REPAYMENT' THEN
        CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.MULTI.ARR.ID,R.AA.ACCOUNT.DETAILS ,F.AA.ACCOUNT.DETAILS,ERR)
        VAR.BILL.LIST        =R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
        VAR.BILL.STATUS.LIST = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.STATUS>
        VAR.SET.STATUS.LIST  = R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
        CHANGE @SM TO @FM IN VAR.BILL.LIST
        CHANGE @VM TO @FM IN VAR.BILL.LIST
        CHANGE @SM TO @FM IN VAR.BILL.STATUS.LIST
        CHANGE @VM TO @FM IN VAR.BILL.STATUS.LIST
        CHANGE @SM TO @FM IN VAR.SET.STATUS.LIST
        CHANGE @VM TO @FM IN VAR.SET.STATUS.LIST
        VAR.BILL.LIST.SIZE=DCOUNT(VAR.BILL.LIST,@FM)
        BILL.CNT=1
        VAR.BILL.CNT=0
        VAR.OS.AMOUNT= 0
        LOOP
            VAR.BILL.LIST.ID = VAR.BILL.LIST<BILL.CNT>
            VAR.SET.STATUS   = VAR.SET.STATUS.LIST<BILL.CNT>
            VAR.BILL.STATUS  = VAR.BILL.STATUS.LIST<BILL.CNT>
            IF VAR.SET.STATUS EQ 'UNPAID' THEN
                CALL F.READ(FN.AA.BILL.DETAILS,VAR.BILL.LIST.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,ERR)
                VAR.BILL.CNT += 1 ;*R22 AUTO CODE CONVERSION
                VAR.OS.AMOUNT+= SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
            END
        WHILE BILL.CNT LE VAR.BILL.LIST.SIZE
            BILL.CNT += 1 ;*R22 AUTO CODE CONVERSION
        REPEAT
        R.NEW(REDO.MTS.OD.AMT)<1,AV> = VAR.OS.AMOUNT
        R.NEW(REDO.MTS.OD.BILLS)<1,AV> = VAR.BILL.CNT
    END

    IF Y.OPERATION NE 'REPAYMENT' THEN
        R.NEW(REDO.MTS.OD.AMT) = ''
        R.NEW(REDO.MTS.OD.BILLS) = ''
    END
RETURN
*--------------
GOEND:
END
