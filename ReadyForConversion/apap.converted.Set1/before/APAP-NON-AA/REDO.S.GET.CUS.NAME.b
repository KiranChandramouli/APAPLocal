*-----------------------------------------------------------------------------
* <Rating>-33</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.GET.CUS.NAME(CUSTOMER.NAME)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS.....
* Developed By  : Chandra Prakash T
* Program Name  : REDO.S.GET.CUS.NAME
* ODR NUMBER    : ODR-2010-01-0213
*----------------------------------------------------------------------------------
* Description   : Deal slip routine attached to FX.FXSN.PSLIP, TT.FXSN.PSLIP & FT.FXSN.SLIP to retrieve CUSTOMER name from the transaction, which
*                 depends on the application name
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 13-Jul-2010      Chandra Prakash T  ODR-2010-01-0213  Initial creation
*----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FOREX
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.TELLER

  GOSUB OPEN.FILES
  GOSUB GET.LOCAL.REF
  GOSUB PROCESS

  RETURN

*----------------------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------------------

  FN.FOREX = 'F.FOREX'
  F.FOREX = ''
  CALL OPF(FN.FOREX,F.FOREX)

  FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
  F.FUNDS.TRANSFER = ''
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

  RETURN

*----------------------------------------------------------------------------------
GET.LOCAL.REF:
*----------------------------------------------------------------------------------
  APPL.ARR = "FOREX":FM:"FUNDS.TRANSFER":FM:"TELLER"
  FIELD.ARR = "L.FX.LEGAL.ID":FM:"L.FT.LEGAL.ID":FM:"L.TT.LEGAL.ID"
  FIELD.POS = ""
  CALL MULTI.GET.LOC.REF(APPL.ARR,FIELD.ARR,FIELD.POS)

  L.FX.LEGAL.ID.POS = FIELD.POS<1,1>
  L.FT.LEGAL.ID.POS = FIELD.POS<2,1>
  L.TT.LEGAL.ID.POS = FIELD.POS<3,1>
  RETURN
*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------
  CONTRACT.NO = ID.NEW

  BEGIN CASE
*    CASE APPLICATION EQ 'FOREX'
  CASE CONTRACT.NO[1,2] EQ 'FX'
    FX.LEGAL.ID = R.NEW(FX.LOCAL.REF)<1,L.FX.LEGAL.ID.POS>
    CHANGE '.' TO FM IN FX.LEGAL.ID
    CUSTOMER.NAME = FX.LEGAL.ID<3>
*    CASE APPLICATION EQ 'FUNDS.TRANSFER'
  CASE CONTRACT.NO[1,2] EQ 'FT'
    FT.LEGAL.ID = R.NEW(FT.LOCAL.REF)<1,L.FT.LEGAL.ID.POS>
    CHANGE '.' TO FM IN FT.LEGAL.ID
    CUSTOMER.NAME = FT.LEGAL.ID<3>
*    CASE APPLICATION EQ 'TELLER'
  CASE CONTRACT.NO[1,2] EQ 'TT'
    TT.LEGAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.LEGAL.ID.POS>
    CHANGE '.' TO FM IN TT.LEGAL.ID
    CUSTOMER.NAME = TT.LEGAL.ID<3>
  END CASE

  CUSTOMER.NAME = FMT(CUSTOMER.NAME,'R#35')
  RETURN

END
