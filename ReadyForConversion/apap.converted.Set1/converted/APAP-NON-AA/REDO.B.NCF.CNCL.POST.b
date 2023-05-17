*-----------------------------------------------------------------------------
* <Rating>-96</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.NCF.CNCL.POST
* ----------------------------------------------------------------------------------------------------------------
* Description           : To  update the flat file generated in the process(REDO.B.NCF.CNCL)
* Developed By          : Aravindhan B
* Development Reference : N10
* Attached To           : BATCH>BNK/REDO.B.NCF.CNCL
* Attached As           : 2nd Job, Batch Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA

*-----------------------------------------------------------------------------------------------------------------
* Modification History
**********************
*---------------------------------------------------------------------------------------------
*   Date       Author              Modification Description
*
* 05/12/2014  Ashokkumar.V.P        PACS00350467 - Corrected the wrong data selection and removed the old file
* 03/04/2015  Ashokkumar.V.P        PACS00350467 - Changed the header year length.
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_REDO.B.NCF.CNCL.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_F.REDO.L.NCF.CANCELLED
    $INSERT I_F.REDO.L.NCF.CANCEL
*--------------------------------------------------------------------------

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB READ.REDO.H.REPORTS.PARAM
    GOSUB GET.PARAM.FLD.VALS
    GOSUB PROCESS
    GOSUB CALL.RCL.API
    RETURN
*--------------------------------------------------------------------------
INIT:
***** *** To initialise all variables ***
    Y.SESSION.NO = ''; Y.OUTPUT.FILE.NAME  = '' ; Y.FREQ.REQ = '' ;Y.RCL.ID = ''
    Y.OUTPUT.DIR = '' ;  Y.REDO.H.REPORTS.PARAM.ID = ''; Y.REDO.L.NCF.CANCEL.LIST = '' ; R.NCF.REC = ''
    Y.RCL.HEAD.ID = '' ;Y.TEMP.RECS = '' ;SEL.LIST = '' ; SEL.CMD = '' ;Y.YEAR.DISP = ''; Y.LAST.WORKING.DAY = ''
    Y.TEMP.FILE.NAME = '' ; Y.OUTPUT.DIR = ''; Y.OUTPUT.FILE.NAME = ''
    RETURN
*--------------------------------------------------------------------------
OPENFILES:
********** *** To open required files ***

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.REDO.L.NCF.CANCELLED  = 'F.REDO.L.NCF.CANCELLED'
    F.REDO.L.NCF.CANCELLED = ''
    CALL OPF(FN.REDO.L.NCF.CANCELLED,F.REDO.L.NCF.CANCELLED)

    Y.REDO.H.REPORTS.PARAM.ID =  BATCH.DETAILS<3,1,1>
    Y.RCL.HEAD.ID = BATCH.DETAILS<3,1,2>
    RETURN

READ.REDO.H.REPORTS.PARAM:
************************** *** Read the Parameter table to get the required field values ****
    R.REDO.H.REPORTS.PARAM = '' ; REDO.H.REPORTS.PARAM.ERR = ''
    CALL F.READ(FN.REDO.H.REPORTS.PARAM,Y.REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ERR)
    Y.TEMP.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>

    FN.REDO.REPORT.TEMP = Y.TEMP.DIR; F.REDO.REPORT.TEMP = ""
    CALL OPF(FN.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP)
    RETURN

GET.PARAM.FLD.VALS:
******************
    C$SPARE(454) = ''; C$SPARE(453) = ''
    Y.OUTPUT.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    Y.OUT.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    Y.DATE.REQ = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.YEAR.MONTH>
    IF Y.DATE.REQ THEN
        Y.YEAR.DISP = Y.DATE.REQ[1,6]
    END ELSE
        Y.YEAR.DISP = R.DATES(EB.DAT.LAST.WORKING.DAY)[1,6]
    END
    C$SPARE(453) = Y.YEAR.DISP
    Y.LAST.WORKING.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.FREQ.REQ = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FREQUENCY.REQ>
    Y.OUTPUT.FILE.NAME  = Y.OUT.FILE.NAME:'-': Y.LAST.WORKING.DAY:".txt"
    FN.CHK.DIR = Y.OUTPUT.DIR
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    R.FIL = ''; READ.FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,Y.OUTPUT.FILE.NAME,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,Y.OUTPUT.FILE.NAME
    END
    RETURN
*--------------------------------------------------------------------------
PROCESS:
********
    SEL.CMD = "SELECT ":FN.REDO.REPORT.TEMP:" LIKE ":Y.OUT.FILE.NAME:"..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS.CNCL,RET.ERR.CNCL)
    Y.TEMP.RECS= SEL.LIST
    LOOP
        REMOVE Y.REC.ID FROM Y.TEMP.RECS SETTING Y.REC.POS
    WHILE Y.REC.ID:Y.REC.POS
        REDO.REPORT.TEMP.ERR = ''; R.REDO.REPORT.TEMP = ''
        GOSUB READ.REDO.REPORT.TEMP
        IF R.REDO.REPORT.TEMP THEN
            R.NCF.REC<-1> = R.REDO.REPORT.TEMP
        END ELSE
            IF REDO.REPORT.TEMP.ERR THEN
                INT.CODE = "REP001"
                INT.TYPE = "ONLINE"
                MON.TP   = 04
                REC.CON  = 'N10-':REDO.REPORT.TEMP.ERR
                DESC     = 'N10-':REDO.REPORT.TEMP.ERR
                CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
            END
        END
        CALL F.DELETE(FN.REDO.REPORT.TEMP,Y.REC.ID)
    REPEAT
    RETURN
CALL.RCL.API:
************
    Y.NO.OF.RECS = DCOUNT(R.NCF.REC,FM)
    C$SPARE(454) = Y.NO.OF.RECS
    MAP.FMT = 'MAP'
    ID.RCON.L = Y.RCL.HEAD.ID
    ID.APP = Y.REDO.H.REPORTS.PARAM.ID
    R.APP = R.REDO.H.REPORTS.PARAM
    APP = FN.REDO.H.REPORTS.PARAM
    R.RETURN.MSG= ''; ERR.MSG= ''
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    Y.FINAL.ARRAY = R.RETURN.MSG:FM:R.NCF.REC
    GOSUB READ.WRITE.FINAL.ARR
    RETURN

READ.WRITE.FINAL.ARR:
**********************
    WRITE Y.FINAL.ARRAY ON F.CHK.DIR, Y.OUTPUT.FILE.NAME ON ERROR
        MESSAGE.INFO<1> = "Unable to Write '":Y.OUTPUT.FILE.NAME:"'"
        GOSUB RAISE.FATAL.ERR
    END
    RETURN

READ.REDO.REPORT.TEMP:
**********************
    R.REDO.REPORT.TEMP = '' ; REDO.REPORT.TEMP.ERR = ''
    CALL F.READ(FN.REDO.REPORT.TEMP,Y.REC.ID,R.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP,REDO.REPORT.TEMP.ERR)
    RETURN
*---------------
RAISE.FATAL.ERR:
*---------------
    MON.TP = 04
    REC.CON = "N10"
    DESC = "10"
    INT.CODE = "REP001"
    INT.TYPE = "ONLINE"
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''
    CALL  REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT, INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON EX.USER,EX.PC)
    RETURN
*------------------------------------------------------End Of Record-----------------
END       ;* End of the program
