*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INP.REINV.AZ.ACC.BAL.FT.TAX
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.INP.REINV.AZ.ACC.BAL.FT.TAX
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
*          This validation routine should be attached to the VERSION TELLER,REINV.WDL to populate
* ACCOUNT.1 field and currency
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 10.07.2012       Sudhar         Group11      CREATION
*----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER


  GOSUB GET.LOC.VALUES
  GOSUB PROCESS

  RETURN
*-----------------------------------------------------------------------------
GET.LOC.VALUES:
*----------------
* Get the Needed Local table position
!
  LOC.REF.APPL='FUNDS.TRANSFER'
  LOC.REF.FIELDS="L.FT.REINV.AMT":VM:"INTEREST.AMOUNT"
  LOC.REF.POS=" "
  CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
  POS.L.FT.REINV.AMT=LOC.REF.POS<1,1>
  POS.INTEREST.AMOUNT=LOC.REF.POS<1,2>

  RETURN
*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------
  VAR.DEBIT.AMOUNT =  R.NEW(FT.DEBIT.AMOUNT)
  VAR.INT.AMT = R.NEW(FT.LOCAL.REF)<1,POS.INTEREST.AMOUNT>
  Y.INT.REINV.AMT = R.NEW(FT.LOCAL.REF)<1,POS.L.FT.REINV.AMT>
  IF VAR.INT.AMT NE VAR.DEBIT.AMOUNT THEN
    AF = FT.DEBIT.AMOUNT
    ETEXT = 'FT-DEBIT.INT.AMOUNT':FM:VAR.INT.AMT
    CALL STORE.END.ERROR
    RETURN
  END

  IF VAR.DEBIT.AMOUNT GT Y.INT.REINV.AMT THEN
    AF = FT.DEBIT.AMOUNT
    ETEXT="FT-REINV.WDL"
    CALL STORE.END.ERROR
  END


  RETURN
END
