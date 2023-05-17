*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.REINV.AUTH.ADMIN
*-------------------------------------------
* DESCRIPTION: This routine is to update the REDO.TEMP.VERSION.IDS.

*----------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE           DESCRIPTION
* 14-Jul-2011     H Ganesh    PACS00072695 - N.11   Initial Draft.


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.REDO.TEMP.VERSION.IDS


  GOSUB INIT
  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
  FN.REDO.TEMP.VERSION.IDS = 'F.REDO.TEMP.VERSION.IDS'
  F.REDO.TEMP.VERSION.IDS = ''
  CALL OPF(FN.REDO.TEMP.VERSION.IDS,F.REDO.TEMP.VERSION.IDS)
  RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

  Y.VERSION.ID = 'FUNDS.TRANSFER,CHQ.REV.AUTH'
  CALL F.READ(FN.REDO.TEMP.VERSION.IDS,Y.VERSION.ID,R.VERSION.IDS,F.REDO.TEMP.VERSION.IDS,VERSION.ERR)
  LOCATE ID.NEW IN R.VERSION.IDS<REDO.TEM.REV.TXN.ID,1> SETTING POS THEN
    DEL R.VERSION.IDS<REDO.TEM.REV.TXN.ID,POS>
    DEL R.VERSION.IDS<REDO.TEM.REV.TXN.DATE,POS>
    CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.VERSION.ID,R.VERSION.IDS)
  END

  RETURN
END
