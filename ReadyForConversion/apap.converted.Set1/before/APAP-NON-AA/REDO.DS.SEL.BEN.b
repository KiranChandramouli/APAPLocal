*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.DS.SEL.BEN(BEN.DST3)
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :BTORRESALBORNOZ
*Program Name :REDO.DS.SEL.BEN
*---------------------------------------------------------------------------------
*DESCRIPTION :This program is used to get the SELL DESTINATION value from EB.LOOKUP TABLE
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
LOC.REF.FIELD = 'L.TT.BENEFICIAR'
LOC.REF.APP = 'TELLER'
LOC.POS = ''
CALL GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)  
BEN.DST = R.NEW(TT.TE.LOCAL.REF)<1,LOC.POS>
BEN.DST1=BEN.DST<1,1,1>
BEN.DST2=BEN.DST1[1,29]
BEN.DST3=FMT(BEN.DST2,'R,#29')
RETURN
END
