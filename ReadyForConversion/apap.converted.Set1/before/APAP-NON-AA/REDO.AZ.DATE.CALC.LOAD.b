*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AZ.DATE.CALC.LOAD
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: MANJU.G
* PROGRAM NAME: REDO.AZ.DATE.CALC.LOAD
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION:Difference between VALUE.DATE date and opening date of the contract MATURITY.DATE the module AZ

*IN PARAMETER: NA
*OUT PARAMETER: NA
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*25.05.2010  Manju.G     ODR-2011-05-0118      INITIAL CREATION
*----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.AZ.ACCOUNT
$INSERT I_REDO.AZ.DATE.CALC.COMMON

  GOSUB INIT
  RETURN
********
INIT:
********
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  FN.ACCOUNT.ACT = 'F.ACCOUNT.ACT'
  F.ACCOUNT.ACT = ''
  CALL OPF(FN.ACCOUNT.ACT,F.ACCOUNT.ACT)

  LREF.APPLN = 'ACCOUNT':FM:'AZ.ACCOUNT'
  LREF.FLDS = 'L.AC.AZ.STA.DAT':VM:'L.AC.AZ.MAT.DAT':FM:'L.AZ.REF.NO'
  LREF.POS = ''
  CALL MULTI.GET.LOC.REF(LREF.APPLN,LREF.FLDS,LREF.POS)
  Y.START.DT = LREF.POS<1,1>
  Y.END.DT = LREF.POS<1,2>
  POS.L.AZ.REF.NO = LREF.POS<2,1>

  RETURN
END
