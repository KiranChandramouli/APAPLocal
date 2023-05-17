*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CHK.CARD.DAMAGE
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: SWAMINATHAN
* PROGRAM NAME: REDO.CHK.CARD.DAMAGE
* ODR NO      : ODR-2010-03-0400
*----------------------------------------------------------------------
*DESCRIPTION: This routine is validation routine to check card status activation
*REDO.CARD.DAMAGE,CREATE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*9.03.2011  Swaminathan    ODR-2010-03-0400  INITIAL CREATION
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.REDO.CARD.DAMAGE


  IF V$FUNCTION EQ 'I' THEN
    Y.COUNT = DCOUNT(R.NEW(REDO.CARD.DAM.CARD.TYPE),VM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.COUNT
      Y.DAM.VAL = R.NEW(REDO.CARD.DAM.REASON)<1,Y.CNT>
      Y.DAM = DCOUNT(Y.DAM.VAL,SM)
      Y.DAM.COUNT = 1
      LOOP
      WHILE Y.DAM GT Y.DAM.COUNT
        DEL R.NEW(REDO.CARD.DAM.REASON)<1,Y.CNT,Y.DAM>
        DEL R.NEW(REDO.CARD.DAM.REMARKS)<1,Y.CNT,Y.DAM>
        DEL R.NEW(REDO.CARD.DAM.CARD.NUMBER)<1,Y.CNT,Y.DAM>
        Y.DAM = Y.DAM - 1
      REPEAT
      Y.CNT = Y.CNT + 1
    REPEAT
    R.NEW(REDO.CARD.DAM.REASON)<1,1> =  ''
    R.NEW(REDO.CARD.DAM.REMARKS)<1,1> =  ''
    R.NEW(REDO.CARD.DAM.CARD.NUMBER)<1,1> = ''
  END
  RETURN
END
