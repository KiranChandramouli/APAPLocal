* @ValidationCode : MjotNTM4NDExMTA4OkNwMTI1MjoxNjgwNzY1NTUzMzYyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 12:49:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.H.ASSIGN.RTN
*----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEYACHANDRAN S
* PROGRAM NAME:
* ODR NO      :
*----------------------------------------------------------------------
* DESCRIPTION  :This validation routine is attached in REDO.H.ASSIGNMENT application for checking the fields are inputted
*               properly or not
* IN PARAMETER :NA
* OUT PARAMETER:NA
* LINKED WITH  :
* LINKED FILE  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                 REFERENCE           DESCRIPTION
* 28.02.2011   Jeyachandran S      ODR-2009-11-0200       INITIAL CREATION
* 06.04.2023   Conversion Tool           R22              Auto Conversion     - No changes
* 06.04.2023   Shanmugapriya M           R22              Manual Conversion   - No changes
*
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.ASSIGNMENT

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB GOEND
RETURN
*-----------
INIT:
    Y.VAL = ''
    Y.ACC.VAL = ''
RETURN

*------------
OPENFILES:

    FN.REDO.H.ASSIGNMENT = 'F.REDO.H.ASSIGNMENT'
    F.REDO.H.ASSIGNMENT = ''
    CALL OPF(FN.REDO.H.ASSIGNMENT,F.REDO.H.ASSIGNMENT)
RETURN
*-------------
PROCESS:

    Y.VAL = R.NEW(REDO.ASSIGN.PAY.METHOD)
    IF Y.VAL EQ "ACCOUNT DEBIT" THEN
        GOSUB CHECK.PROCESS
    END
RETURN
*-------------
CHECK.PROCESS:

    Y.ACC.VAL = R.NEW(REDO.ASSIGN.DEBIT.ACCOUNT)
    Y.TOT.AMT = R.NEW(REDO.ASSIGN.AMOUNT)
    R.NEW(REDO.ASSIGN.AMOUNT)       = FMT(Y.TOT.AMT,"R2#10")
    R.NEW(REDO.ASSIGN.DATE)      = TODAY
    IF Y.ACC.VAL EQ '' THEN
        AF=REDO.ASSIGN.DEBIT.ACCOUNT
        ETEXT = 'EB-ACCT.CHK'
        CALL STORE.END.ERROR
    END
*-------------
GOEND:
END
