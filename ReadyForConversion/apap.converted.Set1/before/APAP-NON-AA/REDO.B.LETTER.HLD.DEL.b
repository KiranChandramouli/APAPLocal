*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.LETTER.HLD.DEL(SEL.INT.LIST)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.B.LETTER.HLD.DEL
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is the Main Routine for BATCH routine(REDO.B.LETTER.HLD.DEL)
* to delete the record that is in status HOLD



*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*18.03.2010  H GANESH     ODR-2009-10-0838   INITIAL CREATION
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.LETTER.ISSUE
$INSERT I_REDO.B.LETTER.HLD.DEL.COMMON

  GOSUB PROCESS
  RETURN


*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

  Y.LETTER.ISSUE.ID=SEL.INT.LIST
  CALL F.DELETE(FN.REDO.LETTER.ISSUE,Y.LETTER.ISSUE.ID)
  RETURN

END
