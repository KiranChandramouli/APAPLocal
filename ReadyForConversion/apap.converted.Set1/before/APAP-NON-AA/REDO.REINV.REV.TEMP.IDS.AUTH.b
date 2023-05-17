*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.REINV.REV.TEMP.IDS.AUTH
*-------------------------------------------------------

* DESCRIPTION: This routine is to update the REDO.TEMP.VERSION.IDS.


*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
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

  Y.ID = APPLICATION:PGM.VERSION
  CALL CACHE.READ(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION,TEMP.ERR)

  IF R.REC.TEMP.VERSION THEN

    LOCATE ID.NEW IN R.REC.TEMP.VERSION<REDO.TEM.TXN.ID,1> SETTING POS.ID THEN
      DEL R.REC.TEMP.VERSION<REDO.TEM.TXN.ID,POS.ID>
      DEL R.REC.TEMP.VERSION<REDO.TEM.PRV.TXN.ID,POS.ID>
      R.REC.TEMP.VERSION<REDO.TEM.AUT.TXN.ID,POS.ID> = ID.NEW
      R.REC.TEMP.VERSION<REDO.TEM.PROCESS.DATE,POS.ID> = TODAY
      CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION)
    END
  END

  RETURN
END
