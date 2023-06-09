* @ValidationCode : Mjo4MzM1MjcyMzY6Q3AxMjUyOjE2ODYwNTM0ODg1NzQ6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Jun 2023 17:41:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
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

* 29-MAY-2023     Conversion tool    R22 Auto conversion       FM TO @FM, VM to @VM, ++ to +=, F.READ to CACHE.READ, = to EQ
* 29-MAY-2023      Harishvikram C   Manual R22 conversion      DR.REG.RIEN7.WORKFILE changed to FN.DR.REG.RIEN7.WORKFILE, CALL routine format modified
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_System
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.ACCT.DET.COMMON
    
    $USING APAP.REDOCHNLS

    GOSUB OPEN.FILES
    GOSUB PROCESS.PARA
RETURN

OPEN.FILES:
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.DR.REG.RIEN7.WORKFILE = 'F.DR.REG.RIEN7.WORKFILE'
    F.DR.REG.RIEN7.WORKFILE = ''
    CALL OPF(FN.DR.REG.RIEN7.WORKFILE,F.DR.REG.RIEN7.WORKFILE)

    Y.TODAY  = R.DATES(EB.DAT.LAST.WORKING.DAY)
    TIME.STAMP.VAL = TIMEDATE()
    Y.TIME = FIELD(TIME.STAMP.VAL,' ',1)
    CHANGE ":" TO '' IN Y.TIME
RETURN

PROCESS.PARA:
*
    REDO.H.REPORTS.PARAM.ID = "REDO.RN07"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)  ;*Manual R22 conversion
    TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
    OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    OUT.PATH = CHANGE(OUT.PATH,@VM,' ')
    Y.FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    Y.FIELD.NAME = CHANGE(Y.FIELD.NAME,@VM,@FM)
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

    SEL.CMD1 = "SELECT ":FN.DR.REG.RIEN7.WORKFILE:" LIKE DOP..."
    SEL.LIST1 = ''; NO.OF.RECS1 = ''; SEL.ERR1 = ''; Y.SEQ.NO = 0
    CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',NO.OF.RECS1,SEL.ERR1)
*SEL.CMD2 = "SELECT ":DR.REG.RIEN7.WORKFILE:" UNLIKE DOP..."
    SEL.CMD2 = "SELECT ":FN.DR.REG.RIEN7.WORKFILE:" UNLIKE DOP..."   ;*Manual R22 conversion
    SEL.LIST2 = ''; NO.OF.RECS2 = ''; SEL.ERR2 = ''; YE.SEQ.NO = 0
    CALL EB.READLIST(SEL.CMD2,SEL.LIST2,'',NO.OF.RECS2,SEL.ERR2)
    FOR I.VAR = 1 TO 2
        IF I.VAR EQ '1' THEN
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
        IF I.VAR EQ '1' THEN
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
        CHANGE @FM TO CHARX(13):CHARX(10) IN FINAL.ARRAY
        CHANGE @FM TO CHARX(13):CHARX(10) IN HEADER
        WRITESEQ HEADER ON FINAL.SEQ.PTR THEN
        END
        GOSUB WRITE.TO.FILE
    NEXT I.VAR
    Y.FLAG = ''
RETURN

SEL.READ.DEL:
*************
    LOOP
        REMOVE REC.ID FROM SEL.LIST SETTING SEL.POS
    WHILE REC.ID:SEL.POS
        GOSUB READ.AND.DELETE
    REPEAT
    IF I.VAR EQ '1' THEN
        REPORT.LINES = REPORT.LINES.L
    END ELSE
        REPORT.LINES = REPORT.LINES.E
    END
RETURN

READ.AND.DELETE:
*---------------
    REP.DATA = ''; ERR.DR.REG.RIEN7.WORKFILE = ''
    CALL F.READ(FN.DR.REG.RIEN7.WORKFILE,REC.ID,REP.DATA,F.DR.REG.RIEN7.WORKFILE,ERR.DR.REG.RIEN7.WORKFILE)
    IF REP.DATA THEN
        GOSUB ARRY.FORM
    END
RETURN

ARRY.FORM:
**********
    IF I.VAR EQ '1' THEN
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
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*Manual R22 conversion
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
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*Manual R22 conversion
    END
RETURN
*-------------------------------------------------------------------------
END
