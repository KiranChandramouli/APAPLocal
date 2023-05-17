*-----------------------------------------------------------------------------
* <Rating>-25</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.BCR.REPORT.BUILD
*-----------------------------------------------------------------------------
!** Simple SUBROUTINE template
* @author youremail@temenos.com
* @stereotype subroutine
* @package infra.eb
*!
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.INTERFACE.PARAM
$INSERT I_REDO.B.BCR.REPORT.BUILD.COMMON
*-----------------------------------------------------------------------------

  GOSUB INITIALISE
  IF Y.RID.LIST EQ "" THEN    ;* Nothing to do
    RETURN
  END

  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

  K.INT.CODE=''
  K.INT.TYPE='BATCH'
  K.BAT.NO=1
  K.BAT.TOT=DCOUNT(Y.RID.LIST,FM)
  K.INFO.OR=''
  K.INFO.DE=''
  K.ID.PROC=K.BAT.NO
  K.MON.TP=''
  K.DESC=''
  K.REC.CON=''
  K.EX.USER='OPERATOR'
  K.EX.PC='TNO'

  LOOP
    REMOVE Y.REDO.INT.PARAM.ID FROM Y.RID.LIST SETTING Y.POS
  WHILE Y.POS : Y.REDO.INT.PARAM.ID
    CALL F.READ(FN.REDO.INT.PARAM        , Y.REDO.INT.PARAM.ID, R.REDO.INT.PARAM, F.REDO.INT.PARAM, Y.ERR)

    IF Y.ERR NE '' THEN
      TEXT = "ERROR AL PROCESAR BURO CREDITO " : Y.ERR
      CALL FATAL.ERROR('REDO.B.BCR.REPORT.BUILD' : Y.REDO.INT.PARAM.ID)
    END
    E=''
    CALL REDO.R.BCR.REPORT.BUILD(Y.REDO.INT.PARAM.ID,'BATCH',R.REDO.INT.PARAM)
    IF E NE '' THEN
      K.INT.CODE=Y.REDO.INT.PARAM.ID
      CALL REDO.INTERFACE.REC.ACT(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)
    END
    K.BAT.NO++
  REPEAT

  RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

  Y.RID.LIST = ''   ;* List of the records into REDO.INTERFACE.PARAM to process
* Check if there are some to process
  CALL REDO.R.BCR.REPORT.GEN.LIST.GET(Y.RID.LIST)
  IF Y.RID.LIST EQ "" THEN
    RETURN          ;* Process must not be continued
  END

  FN.REDO.INT.PARAM = 'F.REDO.INTERFACE.PARAM'
  F.REDO.INT.PARAM = ''
  CALL OPF(FN.REDO.INT.PARAM, F.REDO.INT.PARAM)


  RETURN

END
