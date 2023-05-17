*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FRAME.FILE.TRAILER
*********************************************************************************
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.FRAME.FILE.TRAILER
***********************************************************************************
*Description:    This routine will frame the trailer message based on values updated
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*07.12.2010   S DHAMU       ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON
$INSERT I_BATCH.FILES
$INSERT I_F.REDO.VISA.STLMT.MAPPING


  GOSUB INIT
  GOSUB PROCESS

  RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
  FN.REDO.VISA.STLMT.MAPPING='F.REDO.VISA.STLMT.MAPPING'
  F.REDO.VISA.STLMT.MAPPING=''
  CALL OPF(FN.REDO.VISA.STLMT.MAPPING,F.REDO.VISA.STLMT.MAPPING)

  TRAILER.LINE=''
  RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------


  SYSTEM.ID ='920'
  CALL F.READ(FN.REDO.VISA.STLMT.MAPPING,SYSTEM.ID,R.REDO.VISA.STLMT.MAPPING,F.REDO.VISA.STLMT.MAPPING,VISA.STLMT.MAPPING.ERR)
  TRAILER.LINE = ''
  FIELD.NAME  = R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NAME>
  Y.FLD.COUNT=DCOUNT(FIELD.NAME,VM)
  Y.VAR.NO=1

  LOOP

  WHILE Y.VAR.NO LE Y.FLD.COUNT
    Y.FIELD.VALUE=''

    IF R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.CONSTANT,Y.VAR.NO>  NE '' THEN
      Y.FIELD.VALUE = R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.CONSTANT,Y.VAR.NO>
    END

    OUT.VERIFY.RTN = R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.VERIFY.OUT.RTN,Y.VAR.NO>

    IF OUT.VERIFY.RTN NE '' THEN
      CALL @OUT.VERIFY.RTN
    END

    PADDING.STR = R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.PADDING,Y.VAR.NO>
    END.POS  = R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.END.POS,Y.VAR.NO>
    START.POS = R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.START.POS,Y.VAR.NO>
*LEN.FIELD = END.POS - START.POS + 1
    LEN.FIELD = END.POS
    CALL REDO.FMT.OUT.PADDING
    TRAILER.LINE = TRAILER.LINE:Y.FIELD.VALUE
    Y.VAR.NO++
  REPEAT

  FILE.TRAILER=TRAILER.LINE
  RETURN

END
