* @ValidationCode : MjotNDIxMjQ1NzQ4OkNwMTI1MjoxNjgxMzAyODkxNDIwOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 18:04:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.REINV.WAIVE.TAX.AMT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.V.REINV.WAIVE.TAX.AMT
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
*            This validation routine is be attached to the VERSION FUNDS.TRANSFER,REINV.WDL
* to populate DEBIT.ACCOUNT number and currency
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
*  16  mar 2012      RIYAS        PACS00186956      ISSUE FIXING
*----------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*12-04-2023            Conversion Tool             R22 Auto Code conversion                    F.READ TO CACHE.READ
*12-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_REDO.TELLER.PROCESS.COMMON
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.REDO.CHEQUE.PROCESS

    GOSUB INIT
    GOSUB GET.LOC.VALUES
    GOSUB PROCESS
RETURN

*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.REDO.CHEQUE.PROCESS = 'F.REDO.CHEQUE.PROCESS'
    F.REDO.CHEQUE.PROCESS = ''
    CALL OPF(FN.REDO.CHEQUE.PROCESS,F.REDO.CHEQUE.PROCESS)

    FN.FTTC = 'F.FT.TXN.TYPE.CONDITION'
    F.FTTC = ''
    CALL OPF(FN.FTTC,F.FTTC)

    FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE = ''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

RETURN

*-----------------------------------------------------------------------------
GET.LOC.VALUES:
*----------------
* Get the Needed Local table position
*
    LOC.REF.APPL="FUNDS.TRANSFER"
    LOC.REF.FIELDS='WAIVE.TAX'
    LOC.REF.POS=" "
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    POS.WAIVE.TAX  = LOC.REF.POS<1,1>



RETURN
*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------

    Y.REDO.CHEQUE.PROCESS.ID = VAR.PROCESS.ID
    CALL F.READ(FN.REDO.CHEQUE.PROCESS,Y.REDO.CHEQUE.PROCESS.ID,R.REDO.CHEQUE.PROCESS,F.REDO.CHEQUE.PROCESS,Y.ERR)
    Y.AMOUNT = R.REDO.CHEQUE.PROCESS<CHQ.PRO.DEBIT.AMOUNT>
    Y.FT.TRANSACTION.TYPE = R.NEW(FT.TRANSACTION.TYPE)
    CALL CACHE.READ(FN.FTTC, Y.FT.TRANSACTION.TYPE, R.FTTC, FTTC.ERR)    ;*R22 AUTO CODE CONVERSION
    Y.FT.COMM.TYPES  =  R.FTTC<FT6.COMM.TYPES>
    CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.FT.COMM.TYPES, R.FT.COMMISSION.TYPE, FT.COMMISSION.TYPE.ERR)   ;*R22 AUTO CODE CONVERSION
    Y.FC.PERCENTAGE = R.FT.COMMISSION.TYPE<FT4.PERCENTAGE>/100
    Y.COMMISSION.AMOUNT =  Y.AMOUNT * Y.FC.PERCENTAGE
    Y.FINAL.AMOUNT  = Y.AMOUNT - Y.COMMISSION.AMOUNT
    IF COMI EQ 'NO' THEN
        R.NEW(FT.DEBIT.AMOUNT) = Y.FINAL.AMOUNT
        R.NEW(FT.COMMISSION.TYPE) = Y.FT.COMM.TYPES
        R.NEW(FT.COMMISSION.AMT) = R.NEW(FT.DEBIT.CURRENCY):' ':Y.COMMISSION.AMOUNT
    END ELSE
        R.NEW(FT.DEBIT.AMOUNT) = Y.AMOUNT
    END
RETURN
END
