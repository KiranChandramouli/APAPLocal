*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.A.CARD.TYPE
**********************************************************************
* Company Name : ASOCIACISN POPULAR DE AHORROS Y PRISTAMOS
* Developed By : S.DHAMU
* Program Name : REDO.A.CARD.TYPE
************************************************************************
*Description : This is the authorisation routine for CARD.TYPE
* This will update the table REDO.CARD.BIN with
* CARD.TYPE name when it is authorized
**************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CARD.BIN
$INSERT I_F.CARD.TYPE



GOSUB INIT
GOSUB PROCESS

RETURN

*****
INIT:
*****

FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
F.REDO.CARD.BIN = ''
CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)


RETURN

*******
PROCESS:
*******

Y.L.CT.BIN.POS = ''
CALL GET.LOC.REF('CARD.TYPE','L.CT.BIN',Y.L.CT.BIN.POS)
BIN.ID = R.NEW(CARD.TYPE.LOCAL.REF)<1,Y.L.CT.BIN.POS>
REDO.BIN.ERR = ''
CALL F.READ(FN.REDO.CARD.BIN,BIN.ID,R.REDO.CARD.BIN,F.REDO.CARD.BIN,REDO.BIN.ERR)
LOCATE ID.NEW IN R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE,1> SETTING POS ELSE
* Updating multivalue field CARD.TYPE in REDO.CARD.BIN PACS00033279
R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE,-1> = ID.NEW
CALL F.WRITE(FN.REDO.CARD.BIN,BIN.ID,R.REDO.CARD.BIN)
* Updating multivalue field CARD.TYPE in REDO.CARD.BIN PACS00033279
END
RETURN
******************************************
END
