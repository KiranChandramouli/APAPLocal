*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.BLD.REINV.ACC(ENQ.DATA)

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Sudharsanan S
* Program Name : REDO.BLD.REINV.ACC
*---------------------------------------------------------

* Description : This build routine is used to get the customer id value based on L.FT.AZ.ACC.REF value
*----------------------------------------------------------
* Linked With :
* In Parameter : None
* Out Parameter : None
*----------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.FUNDS.TRANSFER

FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
F.AZ.ACCOUNT = ''
CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

CALL GET.LOC.REF('FUNDS.TRANSFER','L.FT.AZ.ACC.REF',LOC.REF.POS)

Y.AZ.ACC.REF = R.NEW(FT.LOCAL.REF)<1,LOC.REF.POS>

CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ACC.REF,R.AZ.ACC,F.AZ.ACCOUNT,AZ.ERR)

VAR.CUSTOMER = R.AZ.ACC<AZ.CUSTOMER>

ENQ.DATA<2,1> = 'CUSTOMER'
ENQ.DATA<3,1> = 'EQ'
ENQ.DATA<4,1> = VAR.CUSTOMER

RETURN

END
