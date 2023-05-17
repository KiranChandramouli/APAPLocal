*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.DS.MET.PAY.METHOD(PAY.METHOD)
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :BTORRESALBORNOZ
*Program Name :REDO.DS.MET.PAY.METHOD
*Modify :btorresalbornoz
*---------------------------------------------------------------------------------
*DESCRIPTION :This program is used to get the PAY.METHOD value from EB.LOOKUP TABLE
* ----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.USER
GOSUB PROCESS
RETURN
*********
PROCESS:
*********

LOC.REF.FIELD = 'L.TT.MET.OF.PAY'
LOC.REF.APP = 'TELLER'
LOC.POS = ''
CALL GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)
VAR.PAY.METHOD = R.NEW(TT.TE.LOCAL.REF)<1,LOC.POS>

IF VAR.PAY.METHOD = 'CASH' THEN
PAY.METHOD = 'EFECTIVO'
END
IF VAR.PAY.METHOD = 'CHECK' THEN
PAY.METHOD = 'CHEQUE'
END
PAY.METHOD=FMT(PAY.METHOD,'R8')
RETURN
END
