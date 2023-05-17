*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.UPD.BRANCH.LIMIT(Y.BRANCH.ID)

*-------------------------------------------------------------------L-------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.UPD.BRANCH.LIMIT
*--------------------------------------------------------------------------------
* Description: This is batch routine to clear the daily balance for each branch
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 20-Oct-2011    Pradeep S      PACS00149084      INITIAL CREATION
*
*----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.APAP.FX.BRN.POSN
$INSERT I_REDO.B.UPD.BRANCH.LIMIT.COMMON

  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

  R.REDO.APAP.FX.BRN.POSN = ''
  CALL F.READ(FN.REDO.APAP.FX.BRN.POSN,Y.BRANCH.ID,R.REDO.APAP.FX.BRN.POSN,F.REDO.APAP.FX.BRN.POSN,ERR)
  IF R.REDO.APAP.FX.BRN.POSN THEN
    R.REDO.APAP.FX.BRN.POSN<REDO.BRN.POSN.BRN.TDY.TXN.VALUE> = ''
    CALL F.WRITE(FN.REDO.APAP.FX.BRN.POSN,Y.BRANCH.ID,R.REDO.APAP.FX.BRN.POSN)
  END

  RETURN
END
