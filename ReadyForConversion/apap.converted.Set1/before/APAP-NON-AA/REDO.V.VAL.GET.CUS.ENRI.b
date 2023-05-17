*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.V.VAL.GET.CUS.ENRI

*----------------------------------------------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : VIGNESH KUMAAR M R
* Program Name : REDO.V.INP.VERIFY.STAFF
*----------------------------------------------------------------------------------------------------------------------
* This routine is used to modify the enrichment for the liquidation account per the requirement
*----------------------------------------------------------------------------------------------------------------------
* Linked with : VERSION.CONTROL of APAP.H.GARNISH.DETAILS TABLE
* In parameter : None
* out parameter : None
*----------------------------------------------------------------------------------------------------------------------
* MODIFICATION HISTORY
*----------------------------------------------------------------------------------------------------------------------
* DATE NAME Refernce DESCRIPTION
* 14-04-2013 Vignesh Kumaar R PACS00266089 To display the enrichment for CLIENTE field
*----------------------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.CUSTOMER

FN.CUSTOMER = 'F.CUSTOMER'
F.CUSTOMER = ''
CALL OPF(FN.CUSTOMER,F.CUSTOMER)

CALL GET.LOC.REF('TELLER','L.TT.CLIENT.NME',L.TT.CLIENT.NME.POS)

IF COMI NE '' THEN

CALL F.READ(FN.CUSTOMER,COMI,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
R.NEW(TT.TE.LOCAL.REF)<1,L.TT.CLIENT.NME.POS> = R.CUSTOMER<EB.CUS.SHORT.NAME>

END ELSE
R.NEW(TT.TE.LOCAL.REF)<1,L.TT.CLIENT.NME.POS> = ''
END

RETURN
