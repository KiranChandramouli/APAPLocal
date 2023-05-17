*-----------------------------------------------------------------------------
* <Rating>-35</Rating>
*-----------------------------------------------------------------------------

  SUBROUTINE REDO.MON.POST.MAP.QUEUE(P.REC.ID,P.MAP.ID,P.FUNCT,P.OPERATOR,P.COMPANY,P.APP,P.OBJ,P.REC.OLD,P.REC.NEW,P.ACC.OLD,P.ACC.NEW,O.ERR)
*
*    SUBROUTINE REDO.MON.POST.MAP.QUEUE(MAP.REC, MAP.MAPPING.ID)
*
*-----------------------------------------------------------------------------------------------
*
* Modifications:
*
* 30/08/10 - Created by Cesar Yepez
*
*
*-----------------------------------------------------------------------------------------------
*

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_TT.COMMON
$INSERT I_TT.EQUATE
*
*-----------------------------------------------------------------------------------------------
*
* Main processing
*
*DEBUG
  GOSUB INITIALISE
  GOSUB CREATE.MESSAGE
  GOSUB WRITE.MESSAGE
*
  RETURN
*
*-----------------------------------------------------------------------------------------------
*
INITIALISE:
*
*DEBUG
  FN.REDO.MON.MAP.QUEUE = 'F.REDO.MON.MAP.QUEUE'
  F.REDO.MON.MAP.QUEUE = ''
  CALL OPF(FN.REDO.MON.MAP.QUEUE, F.REDO.MON.MAP.QUEUE)


  Y.DATE = DATE()
  Y.DATE = OCONV(Y.DATE,"DY") : FMT(OCONV(Y.DATE,"DM"),"2'0'R") : FMT(OCONV(Y.DATE,"DD"),"2'0'R")

  Y.TIME = TIME()
  Y.TIME = OCONV(Y.TIME,'MTS')

  Y.MSG = ''
  Y.PIPE = '|'

  Y.TELLER.ID = TT$TID
  IF Y.TELLER.ID EQ '' THEN
    Y.TELLER.ID = '9999'
  END

*
  RETURN
*-----------------------------------------------------------------------------------------------
CREATE.MESSAGE:

*DEBUG
*Get Unique Id
  Y.MSG.ID = ''
  CALL ALLOCATE.UNIQUE.TIME(Y.MSG.ID)
  Y.ID.SEQ = EREPLACE(Y.MSG.ID,'.','')
  Y.ID.SEQ = DATE(): Y.ID.SEQ
  Y.MSG.ID = DATE(): Y.MSG.ID

*Record Conversion
  IF P.REC.NEW NE '' THEN
    CONVERT FM TO Y.PIPE IN P.REC.NEW
  END

  IF P.REC.OLD NE '' THEN
    CONVERT FM TO Y.PIPE IN P.REC.OLD
  END

  IF P.ACC.NEW NE '' THEN
    CONVERT FM TO Y.PIPE IN P.ACC.NEW
  END

  IF P.ACC.OLD NE '' THEN
    CONVERT FM TO Y.PIPE IN P.ACC.OLD
  END

*Create Message
  Y.MSG<1> = P.REC.ID
  Y.MSG<2> = P.MAP.ID
  Y.MSG<3> = P.FUNCT
  Y.MSG<4> = Y.DATE
  Y.MSG<5> = Y.TIME
  Y.MSG<6> = P.OPERATOR
  Y.MSG<7> = P.COMPANY
  Y.MSG<8> = P.APP
  Y.MSG<9> = P.OBJ
  Y.MSG<10> = Y.ID.SEQ
  Y.MSG<11> = Y.TELLER.ID

*Before and After Transaction
  Y.MSG<20> = P.REC.NEW
  Y.MSG<21> = P.REC.OLD


*Before and After Account
  Y.MSG<30> = P.ACC.NEW
  Y.MSG<31> = P.ACC.OLD


  RETURN

*-----------------------------------------------------------------------------------------------
*
WRITE.MESSAGE:
*
*DEBUG
  Y.ID = Y.MSG.ID: '-' : P.MAP.ID
*    CALL F.WRITE(FN.REDO.MON.MAP.QUEUE, Y.ID, Y.MSG)

  WRITE Y.MSG TO F.REDO.MON.MAP.QUEUE,Y.ID ON ERROR
 
    O.ERR = "ERROR WRITE FILE REDO.MON.MAP.QUEUE"
  END

  RETURN

*
*-----------------------------------------------------------------------------------------------
*
END


