*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FT.TT

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System
$INSERT I_F.REDO.STORE.SPOOL.ID

  FN.REDO.STORE.SPOOL.ID = 'F.REDO.STORE.SPOOL.ID'
  F.REDO.STORE.SPOOL.ID = ''
  CALL OPF(FN.REDO.STORE.SPOOL.ID,F.REDO.STORE.SPOOL.ID)

  Y.DD = O.DATA
  Y.DATA = System.getVariable("CURRENT.INDA.ID")
  
  IF Y.DATA EQ 'CURRENT.INDA.ID' THEN
    RETURN
  END ELSE
    CALL F.READ(FN.REDO.STORE.SPOOL.ID,Y.DATA,R.REDO.STORE.SPOOL.ID,F.REDO.STORE.SPOOL.ID,SPL.ERR)
    IF R.REDO.STORE.SPOOL.ID THEN
*      LOCATE Y.DD IN R.REDO.STORE.SPOOL.ID<1,1> SETTING POS THEN
* Tus Start
 LOCATE Y.DD IN R.REDO.STORE.SPOOL.ID<RD.SPL.SPOOL.ID,1> SETTING POS THEN
 * Tus End
        O.DATA = Y.DATA
      END
    END
  END

  RETURN

END
