*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.CON.LNS.BY.DEBTOR.POST
*-----------------------------------------------------------------------------
* Description           : This routine reads REDO.REPORTS.TEMP and generates a flat file in a path specified in
*                         OUT.DIR field of REDO.H.REPORTS.PARAM table.
*
* Developed On          : 10-Sep-2013
*
* Developed By          : Emmanuel James Natraj Livingston
*
* Development Reference : 786790(FS-205-DE13)
*
* Attached To           : BATCH>BNK/REDO.B.CON.LNS.BY.DEBTOR
*
* Attached As           : COB Singlethreaded Routine
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*-----------------*
* Output Parameter:
* ----------------*
* Argument#2 : NA
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*    INTERNAL       Emmanuel James Natraj Livingston     24/10/2013      Delimiter Changed from "-" to "^"
* PACS00365441           Ashokkumar.V.P                  27/02/2015      Optimized the relation between the customer
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
*
    SLEEP 30
    GOSUB INITIALISATION
    GOSUB MAIN.PROCESS
    RETURN

*--------------
INITIALISATION:
**-------------
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    Y.PARAM.ID = "REDO.DE13"
*
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
*
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.OUT.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.OUT.FILE.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.TEMP.DIR      = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        CHANGE VM TO '' IN Y.TEMP.DIR
    END ELSE
        Y.ERR.MSG   = "REDO.H.REPORTS.PARAM record ":Y.PARAM.ID:" not found"
        GOSUB RAISE.ERR.C.22
        RETURN
    END
    FN.REDO.REPORT.TEMP = Y.TEMP.DIR
    F.REDO.REPORT.TEMP = ""
    CALL OPF(FN.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP)
    CHANGE VM TO '' IN Y.OUT.FILE.PATH
    TIME.STAMP.VAL = TIMEDATE()
    Y.TIME = FIELD(TIME.STAMP.VAL,' ',1)
    CHANGE ":" TO '' IN Y.TIME
    Y.FILE.NAME = Y.OUT.FILE.NAME:'_':R.DATES(EB.DAT.LAST.WORKING.DAY):'.':Y.TIME:'.txt'
    OPENSEQ Y.OUT.FILE.PATH,Y.FILE.NAME TO Y.SEQ.PTR ELSE
        CREATE Y.FILE.NAME ELSE
            Y.ERR.MSG   = "Unable to Open '":Y.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END
    RETURN
*------------
MAIN.PROCESS:
**-----------
    SEL.CMD = "SELECT ":FN.REDO.REPORT.TEMP:" WITH @ID LIKE ":"...":Y.OUT.FILE.NAME:"..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        CALL F.READ(FN.REDO.REPORT.TEMP,Y.TEMP.ID,R.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP,TEMP.ERR)
        IF R.REDO.REPORT.TEMP THEN
            IF Y.TEMP.RECORD THEN
                Y.TEMP.RECORD := FM:R.REDO.REPORT.TEMP
            END ELSE
                Y.TEMP.RECORD = R.REDO.REPORT.TEMP
            END
        END
        CALL F.DELETE(FN.REDO.REPORT.TEMP,Y.TEMP.ID)
    REPEAT
    IF Y.TEMP.RECORD THEN
        Y.STRING = Y.TEMP.RECORD
        GOSUB APPEND.SEQ.NO
    END

    RETURN
*-------------
APPEND.SEQ.NO:
*-------------
*
    Y.NO.OF.LINES = DCOUNT(Y.STRING,FM)
    Y.LAST.VAL = Y.NO.OF.LINES
    Y.LOOP.CNT = '1'
    Y.SEQ.NO = '1'
    LOOP
    WHILE Y.LAST.VAL GE Y.LOOP.CNT
        Y.LINE =FIELD(Y.STRING<Y.LAST.VAL>,"^",2)
        Y.SEQ.NUM = FMT(Y.SEQ.NO,"R%7")
        IF Y.FINAL.LINE THEN
            Y.FINAL.LINE = Y.FINAL.LINE :FM: Y.SEQ.NUM:Y.LINE
        END ELSE
            Y.FINAL.LINE = Y.SEQ.NUM:Y.LINE
        END

        Y.SEQ.NO++
        Y.LAST.VAL--
    REPEAT

    IF Y.FINAL.LINE THEN
        CHANGE FM TO CHARX(10) IN Y.FINAL.LINE
        WRITESEQ Y.FINAL.LINE APPEND TO Y.SEQ.PTR ELSE
            Y.ERR.MSG = "Unable to Write '":Y.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END

    RETURN
*--------------
RAISE.ERR.C.22:
*--------------
*
    MON.TP   = "13"
    REC.CON  = "DE13-":Y.ERR.MSG
    DESC     = "DE13-":Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO   = ''
    BAT.TOT  = ''
    INFO.OR  = ''
    INFO.DE  = ''
    ID.PROC  = ''
    EX.USER  = ''
    EX.PC    = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*
    RETURN
*
END
