SUBROUTINE REDO.V.REINV.REV.TXN
*-----------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.V.REINV.REV.TXN
*-----------------------------------------------------------------------------------
* Description:
*-----------------------------------------------------------------------------------
* This validation routine should be attached to the VERSION FUNDS.TRANSFER,REV.REINV.WDL
* to reverse the transaction that was already completed withdraw. The version will be
* parsed from an ENQUIRY to populate the local reference field L.FT.AZ.TXN.REF
*-----------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
* DATE WHO REFERENCE DESCRIPTION
* 16-06-2010 SUJITHA.S ODR-2009-10-0332 INITIAL CREATION
*
*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS
RETURN

*-------------------------------------------------------------------------------------
INIT:
*-------------------------------------------------------------------------------------

    FN.FUNDS.TRANSFER='F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER=''
    R.FUNDS.TRANSFER=''

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    R.ACCOUNT=''

    LOC.REF.APPL='FUNDS.TRANSFER'
    LOC.REF.FLD='L.FT.AZ.TXN.REF'
    LOC.REF.POS=''

RETURN

*---------------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------------

    CALL GET.LOC.REF(LOC.REF.APPL,LOC.REF.FLD,LOC.REF.POS)
    Y.FUNDS.TRANSFER.ID=R.NEW(FT.LOCAL.REF)<1,LOC.REF.POS>

    CALL F.READ(FN.FUNDS.TRANSFER,COMI,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,Y.ERR)
    R.NEW(FT.TRANSACTION.TYPE)=R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
    R.NEW(FT.CREDIT.ACCT.NO)=R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
    R.NEW(FT.DEBIT.ACCT.NO)=R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>
    R.NEW(FT.DEBIT.AMOUNT)=R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>
    R.NEW(FT.DEBIT.VALUE.DATE)=TODAY
    R.NEW(FT.CREDIT.VALUE.DATE)=TODAY

    CALL F.READ(FN.ACCOUNT,R.NEW(FT.DEBIT.ACCT.NO),R.ACCOUNT,F.ACCOUNT,Y.ERR)
    R.NEW(FT.DEBIT.CURRENCY)=R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>

RETURN

END
