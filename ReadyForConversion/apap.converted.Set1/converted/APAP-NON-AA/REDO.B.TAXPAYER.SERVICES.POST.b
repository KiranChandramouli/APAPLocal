SUBROUTINE REDO.B.TAXPAYER.SERVICES.POST
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine reads APAP.REPORT.TEMP and generates a flat file.
*
* Developed By          : Thilak Kumar K
*
* Development Reference : RegN9
*
* Attached To           : BATCH>BNK/REDO.B.TAXPAYER.SERVICES
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
* PACS00350484          Ashokkumar.V.P                  18/12/2014           Added the time and corrected the charx.
* PACS00350484          Ashokkumar.V.P                  03/04/2015           Changed the header length.
* PACS00463470          Ashokkumar.V.P                  23/06/2015           Mapping change to display for RNC and Cedula
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.TAXPAYER.SERVICES.COMMON
*
    SLEEP 20
    GOSUB INITIALIZE
    GOSUB PROCESS
*
RETURN
*-----------------------------------------------------------------------------------------------------------------
*
INITIALIZE:
*----------
*Initialize the variables
*Open the neccessary files
*-----------------------------------------------------------------------------------------------------------------
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ""
*
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    TIME.STAMP.VAL = TIMEDATE()
    Y.TIME = FIELD(TIME.STAMP.VAL,' ',1)
    CHANGE ":" TO '' IN Y.TIME

    Y.PARAM.ID = "REDO.REGN9"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
*
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.OUT.DIRECTORY = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.OUT.FILE.ID   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.TEMP.DIR      = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        Y.OUT.FILE.PATH = CHANGE(Y.OUT.DIRECTORY,@VM,'')
        Y.OUT.FILE.NAME = Y.OUT.FILE.ID:'.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.':Y.TIME:'.txt'
    END
*
    Y.TEMP.ID = ''
    FN.REDO.REPORT.TEMP = Y.TEMP.DIR
    F.REDO.REPORT.TEMP = ""
    CALL OPF(FN.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP)
*
    OPENSEQ Y.OUT.FILE.PATH,Y.OUT.FILE.NAME TO Y.SEQ.PTR ELSE
        CREATE Y.OUT.FILE.NAME ELSE
            Y.ERR.MSG = "Unable to Open '":Y.OUT.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
*
PROCESS:
*-------
*Select APAP.REPORT.TEMP
*Frame Loop and Remove the id
*Read APAP.REPORT.TEMP If Record Exits then store it to an array
*Else Raise
*-----------------------------------------------------------------------------------------------------------------
    SEL.CMD = "SELECT ":FN.REDO.REPORT.TEMP:" LIKE ":Y.OUT.FILE.ID:"..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        CALL F.READ(FN.REDO.REPORT.TEMP,Y.TEMP.ID,R.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP,TEMP.ERR)
        IF R.REDO.REPORT.TEMP NE '' THEN
            Y.TEMP.RECORD<-1> = R.REDO.REPORT.TEMP
            CALL F.DELETE(FN.REDO.REPORT.TEMP,Y.TEMP.ID)
        END ELSE
            GOSUB RAISE.ERR.C.22
        END
    REPEAT
    IF Y.TEMP.RECORD NE '' THEN
        GOSUB FORM.ARRAY
    END ELSE
        RETURN
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
*
FORM.ARRAY:
*----------
    Y.NO.OF.LINES = DCOUNT(Y.TEMP.RECORD,@FM)
*
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.NO.OF.LINES
        Y.LINE = Y.TEMP.RECORD<Y.CNT>
        Y.AMT  = FIELD(Y.LINE,'*',1,1)
        Y.REC  = FIELD(Y.LINE,'*',2,1)
*
        IF Y.TOT.AMT THEN
            Y.TOT.AMT+=Y.AMT
        END ELSE
            Y.TOT.AMT = Y.AMT
        END
*
        IF Y.RECORD THEN
            Y.RECORD:= @FM:Y.REC
        END ELSE
            Y.RECORD = Y.REC
        END
*
        Y.CNT += 1
    REPEAT
*
    GOSUB FORM.HEADER
    GOSUB WRITE.FILE
*
RETURN
*-----------------------------------------------------------------------------------------------------------------
*
FORM.HEADER:
*-----------
    Y.PERIOD = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.YEAR   = LEFT(Y.PERIOD,6)
*
    C$SPARE(451) = Y.YEAR
    C$SPARE(452) = Y.NO.OF.LINES
    C$SPARE(453) = Y.TOT.AMT
*
    MAP.FMT = "MAP"
    ID.RCON.L = "REDO.RCL.REGN9.HR"
    APP = FN.REDO.H.REPORTS.PARAM
    R.APP = R.REDO.H.REPORTS.PARAM
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    Y.ARRAY = R.RETURN.MSG
*
RETURN
*-----------------------------------------------------------------------------------------------------------------
*
WRITE.FILE:
*----------
    Y.FINAL.ARRAY = Y.ARRAY:@FM:Y.RECORD
    CHANGE @FM TO CHARX(13):CHARX(10) IN Y.FINAL.ARRAY
    WRITESEQ Y.FINAL.ARRAY APPEND TO Y.SEQ.PTR ELSE
        Y.ERR.MSG = "Unable to Write '":Y.OUT.FILE.NAME:"'"
        GOSUB RAISE.ERR.C.22
        RETURN
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
*
RAISE.ERR.C.22:
*--------------
*Handling error process
*---------------
    MON.TP = "04"
    Y.ERR.MSG = "Record not found"
    REC.CON = "REGN9-":Y.ERR.MSG
    DESC = "REGN9-":Y.ERR.MSG
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
*-----------------------------------------------------------------------------------------------------------------
END
*-----------------------------------------------------------------------------------------------------------------
