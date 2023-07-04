* @ValidationCode : MjotMTQ0MTgxNjYxMjpDcDEyNTI6MTY4NDgzNjAzNDQ0MjpJVFNTOi0xOi0xOjI3NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 275
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CHECK.ID
*----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEYACHANDRAN S
* PROGRAM NAME:
* ODR NO      :
*----------------------------------------------------------------------
* DESCRIPTION  :This routine is used to check whether the account number is valid or not
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
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MULTI.TRANSACTION.SERVICE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCT.ACTIVITY

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
RETURN
*-------------
PROCESS:

    Y.ACC.ID = COMI
    SEL.CMD = "SELECT ":FN.ACCOUNT:" WITH @ID EQ ":Y.ACC.ID
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)
    Y.TYPE = R.NEW(REDO.MTS.SETTLEMENT.TYPE)
    Y.OPERATION = R.NEW(REDO.MTS.OPERATION)

    IF Y.TYPE EQ 'MULTIPLE' THEN
        T(REDO.MTS.ARRANGEMENT.ID)<3> = 'NOINPUT'
    END

*    IF Y.TYPE EQ 'SINGLE' AND Y.OPERATION EQ 'REPAYMENT' THEN
    IF Y.OPERATION EQ 'REPAYMENT' AND Y.ACC.ID NE '' THEN
        IF SEL.LIST EQ '' THEN
            ETEXT = 'TT-ACC.ID'
            CALL STORE.END.ERROR
        END
    END

    Y.RESIDUAL.VAL = R.NEW(REDO.MTS.RESIDUAL)
    IF Y.RESIDUAL.VAL EQ 'NO' THEN
        T(REDO.MTS.RESIDUAL.MODE)<3> = 'NOINPUT'
    END

RETURN
*--------------
GOEND:
END
