*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.COL.FF.EXTRACT.POST
*------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.INTERFACE.PARAM
$INSERT I_REDO.COL.CUSTOMER.COMMON
$INSERT I_F.TSA.SERVICE
  GOSUB INITIALISE

  RETURN

INITIALISE:

  Y.EXTRACT.OUT.PATH=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.AUTO.PATH>
  LOOP
    REMOVE C.TABLE.ID FROM C.TABLES SETTING POS
  WHILE C.TABLE.ID:POS
    GOSUB TABLE.PROCESS
  REPEAT
  EXE.TOUCH='touch ':Y.EXTRACT.OUT.PATH:'/chk_file'
  SHELL.TCH ='SH -c '
  DAEMON.TCH = SHELL.TCH:EXE.TOUCH
  EXECUTE DAEMON.TCH RETURNING RETURN.VALUE CAPTURING CAPTURE.TCH.VALUE
  FN.TSA.SERVICE='F.TSA.SERVICE'
  F.TSA.SERVICE =''
  CALL OPF(FN.TSA.SERVICE,F.TSA.SERVICE)

  Y.TSA.ID='BNK/REDO.COL.POST.LOG'
  CALL F.READ(FN.TSA.SERVICE,Y.TSA.ID,R.TSA.SERVICE,F.TSA.SERVICE,ERR)
  R.TSA.SERVICE<TS.TSM.SERVICE.CONTROL>='AUTO'
  CALL F.WRITE(FN.TSA.SERVICE,Y.TSA.ID,R.TSA.SERVICE)
  RETURN


TABLE.PROCESS:
  SHELL.CMD ='SH -c '
  EXEC.COM="cat "
  OLD.OUT.FILES = 'SESSION':C.TABLE.ID:'*'
  EXE.CAT = "cat ":Y.EXTRACT.OUT.PATH:"/":OLD.OUT.FILES:" >> ":Y.EXTRACT.OUT.PATH:"/":C.TABLE.ID:'.txt'
  EXE.RM="rm ":Y.EXTRACT.OUT.PATH:"/":OLD.OUT.FILES

  DAEMON.CMD = SHELL.CMD:EXE.CAT
  DAEMON.REM.CMD = SHELL.CMD:EXE.RM

  EXECUTE DAEMON.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.CAT.VALUE
  EXECUTE DAEMON.REM.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.REM.VALUE

  RETURN
END
