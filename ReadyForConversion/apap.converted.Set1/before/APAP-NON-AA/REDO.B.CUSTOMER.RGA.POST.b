*-----------------------------------------------------------------------------
* <Rating>-63</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.CUSTOMER.RGA.POST
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      : Nirmal.P
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine
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
*
*-------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.DATES
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT TAM.BP I_REDO.B.CUSTOMER.RGA.COMMON

    GOSUB OPEN.FILES
    GOSUB PROCESS.PARA
    RETURN
*-------------------------------------------------------------------------------
OPEN.FILES:
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    Y.D = "-1C"
    Y.LST.CDAY = TODAY
    Y.LST.CDAY =Y.LST.CDAY[1,6]:'01'
    CALL CDT('',Y.LST.CDAY,Y.D)

    RETURN
PROCESS.PARA:
*--------------*
    REDO.H.REPORTS.PARAM.ID = BATCH.DETAILS<3,1,1>
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
*
    IF R.REDO.H.REPORTS.PARAM THEN
        TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        OUT.PATH = CHANGE(OUT.PATH,VM,' ')
        Y.FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        LOCATE 'HD.SEL.CODES' IN Y.FIELD.NAME SETTING HD.POS THEN
            HEADER.DET = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,HD.POS>
        END
        FINAL.ARRAY = ''; NO.OF.CUS = 0; NO.OF.FINAL = '';
        REPORT.LINE = ''; REPORT.LINES = ''
        FILENAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        FINAL.OUT.FILE.NAME = FILENAME:Y.LST.CDAY:'.txt'
*
        SEL.CMD = "SELECT ":TEMP.PATH:" LIKE ":FILENAME:"..."
        SEL.LIST = ''; NO.OF.RECS = ''; SEL.ERR = ''
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)
        LOOP
            REMOVE REC.ID FROM SEL.LIST SETTING SEL.POS
        WHILE REC.ID:SEL.POS
            GOSUB READ.AND.DELETE
        REPEAT
        GOSUB OPEN.SEQ.FILE
        GOSUB PROCESS.FINAL.ARRAY
    END
    RETURN
*
PROCESS.FINAL.ARRAY:
*-------------------*
    FINAL.ARRAY=''
    LOOP
        REMOVE REPORT.LINE FROM REPORT.LINES SETTING REP.LINE.POS
    WHILE REPORT.LINE:REP.LINE.POS
        FINAL.ARRAY<-1> = REPORT.LINE
    REPEAT
    NO.OF.FINAL = DCOUNT(FINAL.ARRAY,@FM)
    NO.OF.FINAL = FMT(NO.OF.FINAL,"R%12")
    NO.OF.CUS = NO.OF.FINAL
    LCC.HEADER = ''
    LCC.HEADER<-1> = HEADER.DET<1,1,1>
    LCC.HEADER<-1> = FILENAME
    LCC.HEADER<-1> = '01/':Y.LST.CDAY[5,2]:'/':Y.LST.CDAY[1,4]:',':Y.LST.CDAY[7,2]:'/':Y.LST.CDAY[5,2]:'/':Y.LST.CDAY[1,4]
    LCC.HEADER<-1> =  NO.OF.CUS
    LCC.HEADER<-1> = HEADER.DET<1,1,3>
    LCC.HEADER<-1> = HEADER.DET<1,1,4>
*LCC.HEADER = LCC.HEADER :CHARX(13):CHARX(10)
    CHANGE FM TO CHARX(13):CHARX(10) IN FINAL.ARRAY
    CHANGE FM TO CHARX(13):CHARX(10) IN LCC.HEADER
    WRITESEQ LCC.HEADER ON FINAL.SEQ.PTR THEN
    END
    GOSUB WRITE.TO.FILE
*
    Y.FLAG = ''
    RETURN
*---------------------------------------------------------------------------------
READ.AND.DELETE:
*--------------
*
    OPEN TEMP.PATH TO SEQ.PTR.READ THEN
        READ REP.DATA FROM SEQ.PTR.READ,REC.ID THEN
            IF REP.DATA THEN
                REPORT.LINES<-1> = REP.DATA
            END
            CLOSE SEQ.PTR.READ
        END
    END
    OPEN TEMP.PATH TO SEQ.PTR.DEL THEN
        DELETE SEQ.PTR.DEL,REC.ID
    END
    RETURN
*-------------------------------------------------------------------------------------
OPEN.SEQ.FILE:
*-------------
    OPENSEQ OUT.PATH,FINAL.OUT.FILE.NAME TO FINAL.SEQ.PTR ELSE
        CREATE FINAL.SEQ.PTR ELSE
            ERR.MSG = "Unable to open ":FINAL.OUT.FILE.NAME:""
            INT.CODE = "R15"
            INT.TYPE = "ONLINE"
            MON.TP = "02"
            REC.CON = "R15-":ERR.MSG
            DESC = "R15-":ERR.MSG
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END
    END
    RETURN
*---------------------------------------------------------------------------------
WRITE.TO.FILE:
*--------------
    WRITESEQ FINAL.ARRAY ON FINAL.SEQ.PTR ELSE
        ERR.MSG = "Unable to write to ":FILENAME
        INT.CODE = "R15"
        INT.TYPE = "ONLINE"
        MON.TP = "02"
        REC.CON = "R15-":ERR.MSG
        DESC = "R15-":ERR.MSG
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END
    RETURN
*-------------------------------------------------------------------------
END
