*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.DS.BUY.SOURCE(BUY.SOURCE)
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :SUDHARSANAN S
*Program Name :REDO.DS.BUY.SOURCE
*Modify :btorresalbornoz
*---------------------------------------------------------------------------------
*DESCRIPTION :This program is used to get the BUY SOURCE value from EB.LOOKUP TABLE
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
LOC.REF.FIELD = 'L.TT.FX.BUY.SRC'
LOC.REF.APP = 'TELLER'
LOC.POS = ''
CALL GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)
* Single GET.LOC.REF need not be changed - Updated by TUS-Convert
VAR.BUY.SOURCE = R.NEW(TT.TE.LOCAL.REF)<1,LOC.POS>

VIRTUAL.TAB.ID='L.TT.FX.BUY.SRC'
CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
CHANGE '_' TO FM IN Y.LOOKUP.LIST
CHANGE '_' TO FM IN Y.LOOKUP.DESC

LOCATE VAR.BUY.SOURCE IN Y.LOOKUP.LIST SETTING POS1 THEN
IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN ;* This is for english user
BUY.SOURCE=Y.LOOKUP.DESC<POS1,1>
END
IF R.USER<EB.USE.LANGUAGE> EQ 2 AND Y.LOOKUP.DESC<POS1,2> NE '' THEN
BUY.SOURCE=Y.LOOKUP.DESC<POS1,2> ;* This is for spanish user
END ELSE
BUY.SOURCE=Y.LOOKUP.DESC<POS1,1>
END
END ELSE
BUY.SOURCE = ''
END
BUY.SOURCE = BUY.SOURCE<1,1,1>
BUY.SOURCE = BUY.SOURCE[1,21]
BUY.SOURCE = FMT(BUY.SOURCE,"21R")

RETURN
END
