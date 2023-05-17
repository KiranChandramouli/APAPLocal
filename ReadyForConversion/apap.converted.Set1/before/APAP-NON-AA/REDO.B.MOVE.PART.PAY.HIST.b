*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.MOVE.PART.PAY.HIST(RECORD.ID)
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH
* PROGRAM NAME : REDO.B.MOVE.PART.PAY.HIST
*----------------------------------------------------------


* DESCRIPTION : This routine is a multi threaded routine to process the bill numbers and move them to History state
*
*
*------------------------------------------------------------

*    LINKED WITH : REDO.B.MOVE.PART.PAY.HIST.LOAD,REDO.B.MOVE.PART.PAY.HIST.SELECT
*    IN PARAMETER: NONE
*    OUT PARAMETER: NONE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*31.05.2010      GANESH            ODR-2010-08-0017        INITIAL CREATION
*----------------------------------------------------------------------


*-------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_BATCH.FILES
$INSERT I_REDO.B.MOVE.PART.PAY.HIST.COMMON
$INSERT I_F.AA.BILL.DETAILS
$INSERT I_F.REDO.H.PART.PAY.FT
$INSERT I_F.REDO.H.PART.PAY.TT
  V.WORK.FILE.LIST = CONTROL.LIST<1,1>
  IF V.WORK.FILE.LIST EQ 'FT.LIST' THEN
    GOSUB FT.PROCESS
  END
  IF V.WORK.FILE.LIST EQ 'TT.LIST' THEN
    GOSUB TT.PROCESS
  END
  RETURN

***********
FT.PROCESS:

  PAY.FT.ID = RECORD.ID
  CALL F.READ(FN.REDO.H.PART.PAY.FT,PAY.FT.ID,R.REDO.H.PART.PAY.FT,F.REDO.H.PART.PAY.FT,PAY.FT.ERR)
  VAR.BILL.NUM = R.REDO.H.PART.PAY.FT<PART.PAY.BILL.NUMBER>
  CALL F.READ(FN.AA.BILL.DETAILS,VAR.BILL.NUM,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,AA.BILL.ERR)
  VAR.BILL.STATUS = R.AA.BILL.DETAILS<AA.BD.SETTLE.STATUS,1>
  IF VAR.BILL.STATUS EQ 'REPAID' THEN
    CALL F.WRITE(FN.REDO.H.PART.PAY.FT.HIS,PAY.FT.ID,R.REDO.H.PART.PAY.FT)
    CALL F.DELETE(FN.REDO.H.PART.PAY.FT,PAY.FT.ID)
  END
  RETURN

************
TT.PROCESS:

  PAY.TT.ID = RECORD.ID
  CALL F.READ(FN.REDO.H.PART.PAY.TT,PAY.TT.ID,R.REDO.H.PART.PAY.TT,F.REDO.H.PART.PAY.TT,PAY.TT.ERR)
  VAR.BILL.NUM = R.REDO.H.PART.PAY.TT<PART.PAY.BILL.NUMBER>
  CALL F.READ(FN.AA.BILL.DETAILS,VAR.BILL.NUM,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,AA.BILL.ERR)
  VAR.BILL.STATUS = R.AA.BILL.DETAILS<AA.BD.SETTLE.STATUS,1>
  IF VAR.BILL.STATUS EQ 'REPAID' THEN
    CALL F.WRITE(FN.REDO.H.PART.PAY.TT.HIS,PAY.TT.ID,R.REDO.H.PART.PAY.TT)
    CALL F.DELETE(FN.REDO.H.PART.PAY.TT,PAY.TT.ID)
  END
  RETURN
END
