* @ValidationCode : Mjo3OTkxMDQ4NzpDcDEyNTI6MTY4MTgxMzg0MzEzNTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 16:00:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.V.ACC.ID
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
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  NO CHANGE
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
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

    Y.SET.MODE = COMI
    Y.RESIDUAL.MODE = R.NEW(REDO.MTS.RESIDUAL.MODE)
*   IF (Y.SET.MODE EQ 'CASH' OR Y.SET.MODE EQ 'CASH and CHEQUE') AND (Y.RESIDUAL.MODE EQ '' OR Y.RESIDUAL.MODE EQ 'CASH') THEN
    IF (Y.SET.MODE EQ 'CASH' AND Y.RESIDUAL.MODE EQ 'CASH') OR (Y.SET.MODE EQ 'CASH and CHEQUE' AND Y.RESIDUAL.MODE EQ 'CASH') OR (Y.SET.MODE EQ 'CHEQUE' AND Y.RESIDUAL.MODE EQ 'CASH') THEN
        R.NEW(REDO.MTS.VERSION.1) = 'TELLER,CASHBACK.1'
        R.NEW(REDO.MTS.VERSION.2) = 'TELLER,CASHBACK.2'
        R.NEW(REDO.MTS.VERSION.3) = 'TELLER,CASHBACK.3'
    END

    IF (Y.SET.MODE EQ 'CASH' AND Y.RESIDUAL.MODE EQ '') OR (Y.SET.MODE EQ 'CASH and CHEQUE' AND Y.RESIDUAL.MODE EQ '') THEN
        R.NEW(REDO.MTS.VERSION.1) = 'TELLER,CASHBACK.1'
        R.NEW(REDO.MTS.VERSION.2) = 'TELLER,CASHBACK.2'
        R.NEW(REDO.MTS.VERSION.3) = 'TELLER,CASHBACK.3'
    END

    IF (Y.SET.MODE EQ 'CHEQUE' AND Y.RESIDUAL.MODE EQ 'CHEQUE') THEN
        R.NEW(REDO.MTS.VERSION.1) = ''
        R.NEW(REDO.MTS.VERSION.2) = ''
        R.NEW(REDO.MTS.VERSION.3) = ''
    END

    IF (Y.SET.MODE EQ 'CHEQUE' AND Y.RESIDUAL.MODE EQ '') THEN
        R.NEW(REDO.MTS.VERSION.1) = ''
        R.NEW(REDO.MTS.VERSION.2) = ''
        R.NEW(REDO.MTS.VERSION.3) = ''
    END

    IF (Y.SET.MODE EQ 'CASH' AND Y.RESIDUAL.MODE EQ 'CHEQUE') OR (Y.SET.MODE EQ 'CASH and CHEQUE' AND Y.RESIDUAL.MODE EQ 'CHEQUE') THEN
        R.NEW(REDO.MTS.VERSION.1) = 'TELLER,CASHBACK.1'
        R.NEW(REDO.MTS.VERSION.2) = 'TELLER,CASHBACK.2'
        R.NEW(REDO.MTS.VERSION.3) = 'TELLER,CASHBACK.3'
    END

    Y.RESIDUAL.VAL = R.NEW(REDO.MTS.RESIDUAL)
    IF Y.RESIDUAL.VAL EQ 'NO' THEN
        T(REDO.MTS.RESIDUAL.MODE)<3> = 'NOINPUT'
    END

RETURN
*--------------
GOEND:
END
