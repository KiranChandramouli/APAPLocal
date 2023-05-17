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
    CALL CACHE.READ(FN.FTTC, Y.FT.TRANSACTION.TYPE, R.FTTC, FTTC.ERR)
    Y.FT.COMM.TYPES  =  R.FTTC<FT6.COMM.TYPES>
    CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.FT.COMM.TYPES, R.FT.COMMISSION.TYPE, FT.COMMISSION.TYPE.ERR)
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
