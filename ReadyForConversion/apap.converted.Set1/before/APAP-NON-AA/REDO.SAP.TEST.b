*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  PROGRAM REDO.SAP.TEST
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.GIT.TRANSPORT.FILE
$INSERT I_F.DATES
$INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
$INSERT I_GIT.COMMON
$INSERT I_F.ENQUIRY.REPORT
$INSERT I_F.RE.STAT.REP.LINE
  *DEBUG
  Y.FILE.NAME='MBPL'
  Y.OUT.PATH='SHIV.BP'
  OPEN '',Y.OUT.PATH TO F.FILE.PATH THEN
 
  END
  READ R.FILE.DATA FROM F.FILE.PATH,Y.FILE.NAME ELSE
 
  END
  R.FILE.DATA.COUNT=DCOUNT(R.FILE.DATA,FM)
  CRT R.FILE.DATA.COUNT
  R.FILE.DATA.COUNT=10
  Y.LOOP.CNT=1
  LOOP
  WHILE Y.LOOP.CNT LE R.FILE.DATA.COUNT
    Y.LINE.DATA=R.FILE.DATA<Y.LOOP.CNT>
    CHANGE ';' TO FM IN Y.LINE.DATA
    CHANGE '+' TO VM IN Y.LINE.DATA
    R.REC<RE.SRL.TYPE>=Y.LINE.DATA<2>
    R.REC<RE.SRL.DESC>=Y.LINE.DATA<3>
    R.REC<RE.SRL.TOTAL.ACCUM> =Y.LINE.DATA<5>
    R.REC<RE.SRL.LINE.BALANCE>   =Y.LINE.DATA<6>
    R.REC<RE.SRL.PROFT.APPLIC.ID>=Y.LINE.DATA<8>
    R.REC<RE.SRL.PROFIT1>     =Y.LINE.DATA<9>
    R.REC<RE.SRL.PROFIT2>      =Y.LINE.DATA<10>
    R.REC<RE.SRL.PROFIT9>     =Y.LINE.DATA<12>
    R.REC<RE.SRL.PROFT.CURRENCY> =Y.LINE.DATA<16>

    OFS.SOURCE.ID = 'REDO.OFS.AZ.UPDATE'
    APPLICATION.NAME = 'RE.STAT.REP.LINE'
    TRANS.FUNC.VAL = 'I'
    TRANS.OPER.VAL = 'PROCESS'
    APPLICATION.NAME.VERSION = 'RE.STAT.REP.LINE,REDO.SAP.GL'
    NO.AUT = '0'
    OFS.MSG.ID = ''
    APPLICATION.ID = Y.LINE.DATA<1>
    OFS.POST.MSG = ''
    CALL OFS.BUILD.RECORD(APPLICATION.NAME,TRANS.FUNC.VAL,TRANS.OPER.VAL,APPLICATION.NAME.VERSION,"",NO.AUT,APPLICATION.ID,R.REC,OFS.REQ.MSG)
    CALL OFS.POST.MESSAGE(OFS.REQ.MSG,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
    CALL JOURNAL.UPDATE(APPLICATION.ID)
    Y.LOOP.CNT++
  REPEAT
  RETURN
END
