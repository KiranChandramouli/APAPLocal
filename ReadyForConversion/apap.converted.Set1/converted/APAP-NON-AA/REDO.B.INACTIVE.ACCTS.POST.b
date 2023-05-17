SUBROUTINE REDO.B.INACTIVE.ACCTS.POST
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine reads REDO.REPORT.TEMP and generates a flat file.
*
*
* Developed By          : Nowful Rahman M
*
* Development Reference : 199_CA02
*
* Attached To           : BATCH>BNK/REDO.B.INACTIVE.ACCTS
*
* Attached As           : Batch Routine
*-----------------------------------------------------------------------------------------------------------------
*------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*-----------------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00353060          Ashokkumar.V.P                  07/11/2014           Changes based on mapping.
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM

    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------------------------------------------
*Intialize the variables
*Open the neccessary files
*-----------------------------------------------------------------------------------------------------------------
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.DR.REG.CA02.WORKFILE = 'F.DR.REG.CA02.WORKFILE'; F.DR.REG.CA02.WORKFILE =''
    CALL OPF(FN.DR.REG.CA02.WORKFILE,F.DR.REG.CA02.WORKFILE)

    Y.PARAM.ID = "REDO.CA02"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.OUT.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.TEMP.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        CHANGE @VM TO '' IN Y.TEMP.DIR
    END

    F.CHK.DIR = ''; FINAL.ARRAY = ''; REPORT.LINE = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    TIME.STAMP.VAL = TIMEDATE()
    Y.TIME = FIELD(TIME.STAMP.VAL,' ',1)
    CHANGE ":" TO '' IN Y.TIME
    EXTRACT.FILE.ID = Y.OUT.FILE.NAME:'.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.':Y.TIME:'.txt'
    R.FIL = ''; READ.FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------------------------------
*Select REDO.REPORT.TEMP
*Frame Loop and Remove the id
*Read REDO.REPORT.TEMP If Record Exits then store it to an array
*Else Raise
*-----------------------------------------------------------------------------------------------------------------
    Y.SEQ.NO = 1
    SEL.CMD = "SELECT ":FN.DR.REG.CA02.WORKFILE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        R.CA02.REC = '';  TEMP.ERR = ''
        CALL F.READ(FN.DR.REG.CA02.WORKFILE,Y.TEMP.ID,R.CA02.REC, F.DR.REG.CA02.WORKFILE,TEMP.ERR)
        IF R.CA02.REC THEN
            Y.SEQ.NO = FMT(Y.SEQ.NO,"R%7")
            FINAL.ARRAY<-1> = Y.SEQ.NO:R.CA02.REC
            Y.SEQ.NO += 1
        END
    REPEAT

    CHANGE @FM TO CHARX(13):CHARX(10) IN FINAL.ARRAY
    WRITE FINAL.ARRAY ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        Y.ERR.MSG = "Unable to Write '":F.CHK.DIR:"'"
        GOSUB RAISE.ERR.C.22
    END
RETURN

RAISE.ERR.C.22:
*-----------------------------------------------------------------------------------------------------------------
*Handling error process
*-----------------------------------------------------------------------------------------------------------------
    MON.TP = "04"
    REC.CON = "CA02.":Y.ERR.MSG
    DESC = "CA02.":Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
RETURN
*------------------------------------------------------------------Final End-------------------------------------------
END
