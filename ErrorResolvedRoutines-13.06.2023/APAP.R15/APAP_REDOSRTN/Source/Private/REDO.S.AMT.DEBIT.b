* @ValidationCode : MjoxMzU5NzI0NjM0OkNwMTI1MjoxNjgyNDE1MTM2OTgzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 15:02:16
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
$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.AMT.DEBIT(Y.AMT.DEBIT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :KREDO.S.AMT.DEBIT
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the debited amount for the paticular transaction
*Modification history
*Date                Who               Reference                  Description
*06-04-2023      conversion tool     R22 Auto code conversion     No changes
*06-04-2023      Mohanraj R          R22 Manual code conversion   No changes

* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    GOSUB PROCESS
RETURN

PROCESS:

    Y.OUT = R.NEW(FT.AMOUNT.DEBITED)
    LEN.AMT.DBT = LEN(Y.OUT)
    AMT.DEBIT = Y.OUT[4,LEN.AMT.DBT]
    Y.AMT.DEBIT = TRIM(FMT(AMT.DEBIT,"L2,#19")," ",'B')
RETURN

END
