*-----------------------------------------------------------------------------
* <Rating>-34</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.CONS.LOAN.DET.POST
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine reads REDO.REPORT.TEMP and generates a flat file.
*
* Developed By          : Vijayarani G
*
* Development Reference : 786834(FS-209-DE23)
*
* Attached To           : BATCH>BNK/REDO.B.CONS.LOAN.DET
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
* PACS00340818           Ashokkumar.V.P                 31/10/2014            New mapping changes - Rewritten the whole source.
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM

    GOSUB INITIALISE
    GOSUB PROCESS
    RETURN

INITIALISE:
*-----------------------------------------------------------------------------------------------------------------
*Intialize the variables
*Open the neccessary files
*-----------------------------------------------------------------------------------------------------------------
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    Y.RECORD.PARAM.ID = "REDO.DE23"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.RECORD.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.OUT.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    END ELSE
        Y.ERR.MSG   = "REDO.H.REPORTS.PARAM record ":Y.RECORD.PARAM.ID:" not found"
        GOSUB RAISE.ERR.C.22
        RETURN
    END
*
    FN.DR.REG.DE23.WORKFILE = 'F.DR.REG.DE23.WORKFILE'; F.DR.REG.DE23.WORKFILE =''
    CALL OPF(FN.DR.REG.DE23.WORKFILE,F.DR.REG.DE23.WORKFILE)

    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    EXTRACT.FILE.ID = Y.OUT.FILE.NAME:'.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.txt'

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
*-----------------------------------------------------------------------------------------------------------------
    Y.SEQ.NO = 1
    SEL.CMD = "SELECT ":FN.DR.REG.DE23.WORKFILE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        R.REC = ''; TEMP.ERR = ''
        CALL F.READ(FN.DR.REG.DE23.WORKFILE, Y.TEMP.ID, R.REC, F.DR.REG.DE23.WORKFILE,TEMP.ERR)
        IF TEMP.ERR THEN
            INT.CODE = "REP001"
            INT.TYPE = "ONLINE"
            MON.TP   = 04
            REC.CON  = 'DE23-':TEMP.ERR
            DESC     = 'DE23-':TEMP.ERR
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END ELSE
            Y.SEQ.NO = FMT(Y.SEQ.NO,"R%7")
            FINAL.ARRAY<-1> = Y.SEQ.NO:R.REC
            Y.SEQ.NO += 1
        END
    REPEAT
    CRLF = CHARX(013):CHARX(010)
    CHANGE FM TO CRLF IN FINAL.ARRAY
    WRITE FINAL.ARRAY ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        Y.ERR.MSG = "Unable to Write '":F.CHK.DIR:"'"
        GOSUB RAISE.ERR.C.22
    END
    RETURN
*-----------------------------------------------------------------------------------------------------------------
RAISE.ERR.C.22:
*-----------------------------------------------------------------------------------------------------------------
*Handling Fatal error to halt the process
*-----------------------------------------------------------------------------------------------------------------
    MON.TP = "23"
    REC.CON = "DE23-":Y.ERR.MSG
    DESC = "DE23-":Y.ERR.MSG
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

    RETURN
*------------------------------------------------------------------Final End---------------------------------------------------------------------------
END
