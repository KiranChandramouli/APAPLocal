*-----------------------------------------------------------------------------
* <Rating>-24</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.AUTH.OVE.MESSAGE
*-------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : SUDHARSANAN S
* Program Name : REDO.AUTH.OVE.MESSAGE
* ODR Number : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description :This validation routine is used to warn when the user does any
* change to the ACI table manually by triggering a Warning Message

* Linked with: ACI,MAN.UPD
* In parameter : None
* out parameter : None
***---------------------------------------------------------------
***--------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*08.09.2010 S SUDHARSANAN HD1036878 INITIAL CREATION
*---------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.ACCOUNT.CREDIT.INT

GOSUB INIT
GOSUB PROCESS
RETURN
*--------------
INIT:
*---------------

FN.ACCOUNT = 'F.ACCOUNT'
F.ACCOUNT = ''
CALL OPF(FN.ACCOUNT,F.ACCOUNT)

LOC.REF.POS = ''

CALL GET.LOC.REF('ACCOUNT','L.AC.MAN.UPD',LOC.REF.POS)
RETURN
*--------------
PROCESS:
*--------------
Y.ACI.ID = ID.NEW
Y.ACC.ID = FIELD(Y.ACI.ID,'-',1)

CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
Y.MAN.UPD = R.ACCOUNT<AC.LOCAL.REF,LOC.REF.POS>
IF Y.MAN.UPD EQ 'NO' THEN
* TEXT = ''
* TEXT = 'To Keep Changes Set L.AC.MAN.UPD on the Account record to YES'
* CALL REM
* E = 'EB-ACI.MAN.UPD'
TEXT='EB-ACI.MAN.UPD'
CALL STORE.OVERRIDE(CURR.NO)
END
RETURN

END
