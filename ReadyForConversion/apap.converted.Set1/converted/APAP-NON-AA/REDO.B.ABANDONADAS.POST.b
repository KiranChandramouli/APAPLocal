SUBROUTINE REDO.B.ABANDONADAS.POST
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      : Nirmal.P
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description: This is a .POST Subroutine
*
*-------------------------------------------------------------------------------
* Modification History
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00392015          Ashokkumar.V.P                  19/11/2014           Changes based on mapping.
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.ABANDONADAS.COMMON
    $INSERT I_F.DATES

    SLEEP 30
    GOSUB PROCESS.PARA
RETURN

PROCESS.PARA:
    REDO.H.REPORTS.PARAM.ID = "REDO.ABAN"
    Y.TODAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
*
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.OUT.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.TEMP.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        CHANGE @VM TO '' IN Y.TEMP.DIR
    END
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    FN.REDO.REPORT.TEMP = Y.TEMP.DIR
    F.REDO.REPORT.TEMP = ""
    CALL OPF(FN.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP)

    EXTRACT.FILE.ID = Y.OUT.FILE.NAME:'.':Y.TODAY:'.txt'
    R.FIL = ''; READ.FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END
RETURN

PROCESS:
*-----------------------------------------------------------------------------------------------------------------
*Select REDO.REPORT.TEMP
*Frame Loop and Remove the id
*Read REDO.REPORT.TEMP If Record Exits then store it to an array
*Else Raise error C.22
*-----------------------------------------------------------------------------------------------------------------
    Y.SEQ.NO = 1
    SEL.CMD = "SELECT ":FN.REDO.REPORT.TEMP:" LIKE ":Y.OUT.FILE.NAME:"..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        R.REDO.REPORT.TEMP = ''; TEMP.ERR = ''
        CALL F.READ(FN.REDO.REPORT.TEMP,Y.TEMP.ID,R.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP,TEMP.ERR)
        IF TEMP.ERR THEN
            INT.CODE = "REP001"
            INT.TYPE = "ONLINE"
            MON.TP   = 04
            REC.CON  = 'DE05-':TEMP.ERR
            DESC     = 'DE05-':TEMP.ERR
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END
        IF R.REDO.REPORT.TEMP THEN
            FINAL.ARRAY<-1> = R.REDO.REPORT.TEMP
        END
        CALL F.DELETE(FN.REDO.REPORT.TEMP,Y.TEMP.ID)
    REPEAT

    WRITE FINAL.ARRAY ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        Y.ERR.MSG = "Unable to Write '":F.CHK.DIR:"'"
        GOSUB RAISE.ERR.C.22
    END
RETURN

*-----------------------------------------------------------------------------------------------------------------
RAISE.ERR.C.22:
*-----------------------------------------------------------------------------------------------------------------
*Handling error process
*-----------------------------------------------------------------------------------------------------------------
    MON.TP = "04"
    REC.CON = "ABAN.":Y.ERR.MSG
    DESC = "ABAN.":Y.ERR.MSG
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
*------------------------------------------------------------------Final End---------------------------------------------------------------------------
END
