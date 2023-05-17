*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.TRANS.CODE
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.VAL.TRANS.CODE
* ODR NO      : B.166
*----------------------------------------------------------------------
*DESCRIPTION: This routine is an internal call routine called by the Batch routine REDO.VISA.GEN.ACQ.REC
*IN PARAMETER : N/A
*OUT PARAMETER: N/A
*CALLED BY : REDO.VISA.GEN.ACQ.REC
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*15.09.2010  S SUDHARSANAN    B.166            INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.VISA.GEN.ACQ.REC.COMMON
$INSERT I_F.ATM.REVERSAL
$INSERT I_F.REDO.CR.DB.MAP

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
* All files needed throughtout the routine are opened and all variables are intialized here
  FN.REDO.CR.DB.MAP = 'F.REDO.CR.DB.MAP'
  F.REDO.CR.DB.MAP = ''
  CALL OPF(FN.REDO.CR.DB.MAP,F.REDO.CR.DB.MAP)
  RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
  CALL CACHE.READ(FN.REDO.CR.DB.MAP,'SYSTEM',R.REDO.CR.DB.MAP,REDO.MAP.ERR)
  Y.PROCESS.CODE = R.ATM.REVERSAL<AT.REV.PROCESS.CODE>[1,2]
  LOCATE Y.PROCESS.CODE IN R.REDO.CR.DB.MAP<REDO.CR.DB.MAP.TXN.TYPE,1> SETTING POS THEN
    FIELD.VALUE = R.REDO.CR.DB.MAP<REDO.CR.DB.MAP.STML.TC.CODE,POS>
  END
  RETURN
*-------------------------------------------------------------------------------
END
