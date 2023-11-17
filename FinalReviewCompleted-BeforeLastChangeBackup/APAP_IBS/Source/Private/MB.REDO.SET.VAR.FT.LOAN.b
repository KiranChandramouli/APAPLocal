* @ValidationCode : MjoxMTgxOTQ3ODE5OkNwMTI1MjoxNjk4NDA1NTQwMTc4OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Oct 2023 16:49:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.REDO.SET.VAR.FT.LOAN
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                  Nochanges
*-----------------------------------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Description :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_EB.EXTERNAL.COMMON

*-----------------------------------------------------------------------------

    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
* Main Process
PROCESS:
*-------

    Y.INSTALLMENT = R.NEW(FT.LOCAL.REF)<1,11,1>
    Y.TOTAL.DUES = R.NEW(FT.LOCAL.REF)<1,10,1>
    Y.CUSTOMER =  R.NEW(FT.DEBIT.CUSTOMER)
    Y.LOAN.AC.ID = R.NEW(FT.CREDIT.ACCT.NO)
    CALL System.setVariable('CURRENT.ARR.AMT',Y.TOTAL.DUES)
    CALL System.setVariable('CURRENT.UNP.BILL',1)
    CALL System.setVariable('CURRENT.BILL.AMT',Y.TOTAL.DUES)
    CALL System.setVariable('CURRENT.EX.DATE',TODAY)
    CALL System.setVariable('CURRENT.NEXT.BILL',Y.INSTALLMENT)
    CALL System.setVariable('EXT.CUSTOMER',Y.CUSTOMER)
    CALL System.setVariable('CURRENT.CREDIT.ACCT.NO',Y.LOAN.AC.ID)
    CALL System.setVariable('EXT.SMS.CUSTOMERS',Y.CUSTOMER)

    RETURN

*-----------------------------------------------------------------------------

END
