*-----------------------------------------------------------------------------
* <Rating>-72</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.ACCT.DET.POST
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
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00361294          Ashokkumar.V.P                  14/11/2014           Changes based on mapping.
*-----------------------------------------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.DATES
    $INSERT T24.BP I_System
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT TAM.BP I_REDO.B.ACCT.DET.COMMON

    SLEEP 30
    GOSUB OPEN.FILES
    GOSUB PROCESS.PARA
    RETURN

OPEN.FILES:
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    Y.TODAY  = R.DATES(EB.DAT.LAST.WORKING.DAY)
    TIME.STAMP.VAL = TIMEDATE()
    Y.TIME = FIELD(TIME.STAMP.VAL,' ',1)
    CHANGE ":" TO '' IN Y.TIME

    RETURN

PROCESS.PARA:
*
    REDO.H.REPORTS.PARAM.ID = "REDO.RN07"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
    TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
    OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    OUT.PATH = CHANGE(OUT.PATH,VM,' ')
    Y.FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    Y.FIELD.NAME = CHANGE(Y.FIELD.NAME,VM,FM)
    LOCATE 'HD.SEL.CODES' IN Y.FIELD.NAME SETTING HD.POS THEN
        HEADER.DET = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,HD.POS>
    END
    FILENAME.L = HEADER.DET<1,1,2>
    FILENAME.E = HEADER.DET<1,1,3>
    LCC.HEADER = ''
    FCC.HEADER = ''
    LCC.HEADER<-1> = HEADER.DET<1,1,1>
    LCC.HEADER<-1> = FILENAME.L
    LCC.HEADER<-1> = '01/':Y.TODAY[5,2]:'/':Y.TODAY[1,4]:',':Y.TODAY[7,2]:'/':Y.TODAY[5,2]:'/':Y.TODAY[1,4]
    FCC.HEADER<-1> = HEADER.DET<1,1,1>
    FCC.HEADER<-1> = FILENAME.E
    FCC.HEADER<-1> = '01/':Y.TODAY[5,2]:'/':Y.TODAY[1,4]:',':Y.TODAY[7,2]:'/':Y.TODAY[5,2]:'/':Y.TODAY[1,4]

    SEL.CMD1 = "SELECT ":TEMP.PATH:" LIKE ":FILENAME.L:"..."
    SEL.LIST1 = ''; NO.OF.RECS1 = ''; SEL.ERR1 = ''; Y.SEQ.NO = 0
    CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',NO.OF.RECS1,SEL.ERR1)
    SEL.CMD2 = "SELECT ":TEMP.PATH:" LIKE ":FILENAME.E:"..."
    SEL.LIST2 = ''; NO.OF.RECS2 = ''; SEL.ERR2 = ''; YE.SEQ.NO = 0
    CALL EB.READLIST(SEL.CMD2,SEL.LIST2,'',NO.OF.RECS2,SEL.ERR2)
    FOR I = 1 TO 2
        IF I EQ '1' THEN
            FILENAME = FILENAME.L
            SEL.LIST = SEL.LIST1
            FINAL.OUT.FILE.NAME = FILENAME.L:'.':Y.TIME:'.txt'
        END ELSE
            FILENAME = FILENAME.E
            SEL.LIST = SEL.LIST2
            FINAL.OUT.FILE.NAME = FILENAME.E:'.':Y.TIME:'.txt'
        END
        REPORT.LINES.L = ''
        REPORT.LINES.E = ''
        REPORT.LINES = ''
        FINAL.ARRAY = ''
        GOSUB SEL.READ.DEL
        GOSUB OPEN.SEQ.FILE
        Y.SEQ.NO = 0
        LOOP
            REMOVE REPORT.LINE FROM REPORT.LINES SETTING REP.LINE.POS
        WHILE REPORT.LINE:REP.LINE.POS
            FINAL.ARRAY<-1> = REPORT.LINE
            Y.SEQ.NO += 1
        REPEAT
        IF I EQ '1' THEN
            Y.SEQ.NO = FMT(Y.SEQ.NO,"R%12")
            LCC.HEADER<-1> = Y.SEQ.NO
            LCC.HEADER<-1> = HEADER.DET<1,1,4>
            LCC.HEADER<-1> = HEADER.DET<1,1,5>
            HEADER = LCC.HEADER
        END ELSE
            Y.SEQ.NO = FMT(Y.SEQ.NO,"R%12")
            FCC.HEADER<-1> = Y.SEQ.NO
            FCC.HEADER<-1> = HEADER.DET<1,1,4>
            FCC.HEADER<-1> = HEADER.DET<1,1,5>
            HEADER = FCC.HEADER
        END
        CHANGE FM TO CHARX(13):CHARX(10) IN FINAL.ARRAY
        CHANGE FM TO CHARX(13):CHARX(10) IN HEADER
        WRITESEQ HEADER ON FINAL.SEQ.PTR THEN
        END
        GOSUB WRITE.TO.FILE
    NEXT I
    Y.FLAG = ''
    RETURN

SEL.READ.DEL:
*************
    LOOP
        REMOVE REC.ID FROM SEL.LIST SETTING SEL.POS
    WHILE REC.ID:SEL.POS
        GOSUB READ.AND.DELETE
    REPEAT
    IF I EQ '1' THEN
        REPORT.LINES = REPORT.LINES.L
    END ELSE
        REPORT.LINES = REPORT.LINES.E
    END
    RETURN

READ.AND.DELETE:
*---------------
    OPEN TEMP.PATH TO SEQ.PTR.READ THEN
        READ REP.DATA FROM SEQ.PTR.READ,REC.ID THEN
            GOSUB ARRY.FORM
            CLOSE SEQ.PTR.READ
        END
    END
    OPEN TEMP.PATH TO SEQ.PTR.DEL THEN
        DELETE SEQ.PTR.DEL,REC.ID
    END
    RETURN

ARRY.FORM:
**********
    IF NOT(REP.DATA) THEN
        RETURN
    END
    IF I EQ '1' THEN
        REPORT.LINES.L<-1> = REP.DATA
    END ELSE
        REPORT.LINES.E<-1> = REP.DATA
    END
    RETURN

OPEN.SEQ.FILE:
*-------------
    OPENSEQ OUT.PATH,FINAL.OUT.FILE.NAME TO FINAL.SEQ.PTR ELSE
        DELETESEQ OUT.PATH,FINAL.OUT.FILE.NAME THEN
        END ELSE
            NULL
        END
        CREATE FINAL.SEQ.PTR ELSE
            ERR.MSG = "Unable to open ":FINAL.OUT.FILE.NAME:""
            INT.CODE = "R07"
            INT.TYPE = "ONLINE"
            MON.TP = "02"
            REC.CON = "R07-":ERR.MSG
            DESC = "R07-":ERR.MSG
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END
    END
    RETURN
*---------------------------------------------------------------------------------
WRITE.TO.FILE:
*--------------
    WRITESEQ FINAL.ARRAY ON FINAL.SEQ.PTR ELSE
        ERR.MSG = "Unable to write to ":FILE.NAME
        INT.CODE = "R07"
        INT.TYPE = "ONLINE"
        MON.TP = "02"
        REC.CON = "R07-":ERR.MSG
        DESC = "R07-":ERR.MSG
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END
    RETURN
*-------------------------------------------------------------------------
END
