*-----------------------------------------------------------------------------
* <Rating>19</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.PREV.CERT.DEPOSITS.POST
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine reads REDO.B.PREV.CERT.DEPOSITS and generates a flat file.
*
* Developed By          : Amaravathi Krithika B
*
* Development Reference : 198_CA01
*
* Attached To           : BATCH>BNK/REDO.B.PREV.CERT.DEPOSITS
*
* Attached As           : Batch Routine
*-----------------------------------------------------------------------------------------------------------------
*------------------------
* Input Parameter:
* ---------------*
* Argument#3 : NA
*-----------------*
* Output Parameter:
* ----------------*
* Argument#6 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
*XXXX                   <<name of modifier>>                                 <<modification details goes here>>
*-----------------------------------------------------------------------------------------------------------------
* Include files

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.DATES
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM

    SLEEP 30
    GOSUB INITIALIZE
    GOSUB PROCESS
    RETURN

INITIALIZE:
*----------
    FN.REDO.H.REPORT.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORT.PARAM = ""
    CALL OPF(FN.REDO.H.REPORT.PARAM,F.REDO.H.REPORT.PARAM)
    Y.PARAM.ID = "REDO.CA01"

    CALL CACHE.READ(FN.REDO.H.REPORT.PARAM,Y.PARAM.ID,R.REDO.H.REPORT.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORT.PARAM NE '' THEN
        Y.OUT.FILE.NAME = R.REDO.H.REPORT.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.OUT.FILE.PATH = R.REDO.H.REPORT.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.TEMP.DIR = R.REDO.H.REPORT.PARAM<REDO.REP.PARAM.TEMP.DIR>
        CHANGE VM TO '' IN Y.TEMP.DIR
    END ELSE
        Y.ERR.MSG   = "REDO.H.REPORT.PARAM record ":Y.PARAM.ID:" not found"
        GOSUB RAISE.ERR.C.22
        RETURN
    END
*
    FN.REDO.REPORT.TEMP = Y.TEMP.DIR
    F.REDO.REPORT.TEMP = ""
    CALL OPF(FN.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP)
*
    Y.OUT.FILE.PATH = CHANGE(Y.OUT.FILE.PATH,VM,'')
    Y.FILE.NAME = Y.OUT.FILE.NAME:'.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.txt'
    OPENSEQ Y.OUT.FILE.PATH,Y.FILE.NAME TO Y.SEQ.PTR ELSE
        CREATE Y.FILE.NAME ELSE
            Y.ERR.MSG = "Unable to Open '":Y.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END
    RETURN
*
PROCESS:
*-------
*
    SEL.CMD = "SELECT ":FN.REDO.REPORT.TEMP:" LIKE ":Y.OUT.FILE.NAME:"..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        R.REDO.REPORT.TEMP = ''
        TEMP.ERR = ''
        CALL F.READ(FN.REDO.REPORT.TEMP,Y.TEMP.ID,R.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP,TEMP.ERR)
        IF TEMP.ERR THEN
            INT.CODE = "REP001"
            INT.TYPE = "ONLINE"
            MON.TP   = 04
            REC.CON  = 'CA01-':TEMP.ERR
            DESC     = 'CA01-':TEMP.ERR
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END ELSE
            IF R.REDO.REPORT.TEMP THEN
                CHANGE FM TO CHARX(13):CHARX(10) IN R.REDO.REPORT.TEMP
                WRITESEQ R.REDO.REPORT.TEMP APPEND TO Y.SEQ.PTR ELSE
                    Y.ERR.MSG = "Unable to Write '":Y.FILE.NAME:"'"
                    GOSUB RAISE.ERR.C.22
                    RETURN
                END
            END
        END
        CALL F.DELETE(FN.REDO.REPORT.TEMP,Y.TEMP.ID)
    REPEAT
    RETURN
*
RAISE.ERR.C.22:
*-------------
    MON.TP = "04"
    REC.CON = "CA01-":Y.ERR.MSG
    DESC = "CA01-":Y.ERR.MSG
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
END
