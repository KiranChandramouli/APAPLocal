*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.ACC.NO
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.VAL.ACC.NO
* ODR NO      : ODR-2010-08-0469
*----------------------------------------------------------------------
*DESCRIPTION: This routine is an internal call routine called by the Batch routine REDO.VISA.GEN.ACQ.REC
*IN PARAMETER : N/A
*OUT PARAMETER: N/A
*CALLED BY : REDO.VISA.GEN.ACQ.REC
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*15.09.2010  S SUDHARSANAN    ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.VISA.GEN.ACQ.REC.COMMON
$INSERT I_F.ATM.REVERSAL
  GOSUB PROCESS
  RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

  FIELD.VALUE = FIELD(ATM.ID,'.',1)[1,16]
  RETURN
*-------------------------------------------------------------------------------
END
