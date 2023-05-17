*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.BEF.AUT.PRINT.DSLIP
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : IVAN ROMAN
* PROGRAM NAME : REDO.V.BEF.AUT.PRINT.DSLIP
*----------------------------------------------------------
* DESCRIPTION : This Auth routine is used for printing the required Deal Slips
*------------------------------------------------------------
*    IN PARAMETER: NONE
*    OUT PARAMETER: NONE
* Modification History:
*----------------------------------------------------------------
* DATE            WHO            REFERENCE          DESCRIPTION
* 2012.07.11      I ROMAN        PACS00186440 G8    OFS$DEAL.SLIP.PRINTING
* variable was moved to PROCESS section to avoid DEAL.SLIP.FORMAT screen empty
* PRT.ADVICED.PRODUCED added after DS generation
*----------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.DEAL.SLIP.FORMAT
$INSERT I_GTS.COMMON
$INSERT I_DEAL.SLIP.COMMON
$INSERT I_F.VERSION
$INSERT I_F.TELLER

  GOSUB INIT
  GOSUB PROCESS
  RETURN

INIT:
*****

  RETURN

PROCESS:
*********
*
  IF R.NEW(TT.TE.RECORD.STATUS) EQ 'INAU' THEN
    OFS$DEAL.SLIP.PRINTING = 1
    W.FUNCTION = RAISE(R.VERSION(EB.VER.D.SLIP.FUNCTION))
    W.DSFORMAT = RAISE(R.VERSION(EB.VER.D.SLIP.FORMAT))
    LOCATE "C" IN W.FUNCTION<1> SETTING DS.POS THEN
      DEAL.SLIP.ID = W.DSFORMAT<DS.POS>
      CALL PRODUCE.DEAL.SLIP(DEAL.SLIP.ID)
      PRT.ADVICED.PRODUCED = ""
    END
  END ELSE
    IF R.NEW(TT.TE.RECORD.STATUS) EQ 'INA2' THEN
      PRT.ADVICED.PRODUCED = 1
    END

  END

  RETURN
END
