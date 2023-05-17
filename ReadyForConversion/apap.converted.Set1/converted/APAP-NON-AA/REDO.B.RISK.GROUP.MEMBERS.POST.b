SUBROUTINE REDO.B.RISK.GROUP.MEMBERS.POST
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine reads TEMP.DIR and generates a flat file
*
* Developed By          : Kalyani L K, Capgemini
*
* Development Reference : REGN4-GR03
*
* Attached To           : Batch - BNK/REDO.B.RISK.GROUP.MEMBERS
*
* Attached As           : Post Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#2 : NA
*
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* REGN4-GR03             Kalyani L K                     2014-02-14           Initial Draft
*                        Thenmalar T                     2014-03-18           Fixes done as per the changes suggested
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES

    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.RISK.GROUP.MEMBERS.COMMON

*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para of the program, from where the execution of the code starts
**
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*-----------------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the program, the files are opened
**
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM  = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.REDO.GR.REP.CUST='F.REDO.GR.REP.CUST'
    F.REDO.GR.REP.CUST =''
    CALL OPF(FN.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST)
RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts
**
    GOSUB GET.PARAM.VALUES

    CURR.MONTH = TODAY[5,2]
    CURR.MONTH = CURR.MONTH + 1 - 1

    LOCATE CURR.MONTH IN FIELD.GEN.VAL<1> SETTING FOUND.POS ELSE
        RETURN
    END

    GOSUB GET.REPORT.LINES

RETURN
*-----------------------------------------------------------------------------------------------------------------
*****************
GET.PARAM.VALUES:
*****************
* In this para of the program, the values from REDO.H.REPORTS.PARAM are fetched
**
    REDO.H.REPORTS.PARAM.ID = BATCH.DETAILS<3,1,1>
    GOSUB READ.REDO.H.REPORTS.PARAM

    FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    OUT.DIR   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>

    LOCATE 'REP.GEN.MONTH' IN R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME,1> SETTING GEN.FOUND.POS THEN
        FIELD.GEN.VAL = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,GEN.FOUND.POS>
        FIELD.GEN.VAL = RAISE(FIELD.GEN.VAL)
        FIELD.GEN.VAL = RAISE(FIELD.GEN.VAL)
    END

    CHANGE @VM TO '' IN OUT.DIR

    FINAL.OUT.FILE.NAME = FILE.NAME :'_': R.DATES(EB.DAT.LAST.WORKING.DAY) :'.csv'
    GOSUB OPEN.SEQ.FILE

RETURN
*-----------------------------------------------------------------------------------------------------------------
*****************
GET.REPORT.LINES:
*****************
* In this para of the program, the report lines are fecthed from TEMP directory
**
    OPEN TEMP.PATH TO TEMP.PTR ELSE
        INT.CODE = "REP001"
        INT.TYPE = "ONLINE"
        MON.TP   = 04
        REC.CON  = "GR03"
        DESC     = "GR03"
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END

*20140318(S)
    SEQ.NO = 1
*20140318(E)

    SEL.CMD = "SELECT ":TEMP.PATH:" LIKE ":FILE.NAME:"..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

    IF NOT(SEL.LIST) THEN
        RETURN
    END

    LOOP
        REMOVE REC.ID FROM SEL.LIST SETTING REC.POS
    WHILE REC.ID : REC.POS
*20140318(S)
        R.TEMP.PATH = '';ERR.MSG = ''
        CALL F.READ(TEMP.PATH,REC.ID,R.TEMP.PATH,TEMP.PTR,ERR.MSG)
        IF ERR.MSG NE '' THEN
*20140318(E)
            INT.CODE = "REP001"
            INT.TYPE = "ONLINE"
            MON.TP   = 04
            REC.CON  = "GR03"
            DESC     = "GR03"
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END

*20140318(S)
        REPORT.LINES = R.TEMP.PATH
        CALL F.DELETE(TEMP.PATH,REC.ID)

        GOSUB APPEND.SEQ.NUM
*20140318(E)

    REPEAT

RETURN
*-----------------------------------------------------------------------------------------------------------------
***************
APPEND.SEQ.NUM:
***************
* In this para of the program, the sequence number is added to thereport lines
**
    FINAL.ARRAY=''
    LOOP
        REMOVE REPORT.LINE FROM REPORT.LINES SETTING REP.POS
    WHILE REPORT.LINE : REP.POS
        SEQ.NO = FMT(SEQ.NO,"R%7")

        IF FINAL.ARRAY THEN
            FINAL.ARRAY = FINAL.ARRAY :@FM: SEQ.NO:REPORT.LINE
        END ELSE
            FINAL.ARRAY = SEQ.NO:REPORT.LINE
        END

        SEQ.NO += 1
    REPEAT

    IF FINAL.ARRAY THEN
        GOSUB WRITE.TO.FILE
    END
    Y.RGRC.ID='GR03':TODAY
    CALL F.READ(FN.REDO.GR.REP.CUST,Y.RGRC.ID,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,Y.REP.ERR)
    IF R.REDO.GR.REP.CUST THEN
        CALL F.DELETE(FN.REDO.GR.REP.CUST,Y.RGRC.ID)
    END
    Y.SEL.CMD="SSELECT ":FN.REDO.GR.REP.CUST:" WITH @ID LIKE GR03":TODAY:"..."
    CALL EB.READLIST(Y.SEL.CMD,Y.REP.LIST,'',NO.OF.REC,SEL.ERR)
    Y.REP.CNT=1
    LOOP
    WHILE Y.REP.CNT LE NO.OF.REC
        CALL F.READ(FN.REDO.GR.REP.CUST,Y.REP.LIST<Y.REP.CNT>,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,Y.REP.ERR)
        Y.REP.CUST.LIST<-1>=R.REDO.GR.REP.CUST
        CALL F.DELETE(FN.REDO.GR.REP.CUST,Y.REP.LIST<Y.REP.CNT>)
        Y.REP.CNT += 1
    REPEAT
    CALL F.WRITE(FN.REDO.GR.REP.CUST,Y.RGRC.ID,Y.REP.CUST.LIST)

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************************
READ.REDO.H.REPORTS.PARAM:
**************************
* In this para of the program, file REDO.H.REPORTS.PARAM is read
**
    R.REDO.H.REPORTS.PARAM  = ''
    REDO.H.REPORTS.PARAM.ER = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ER)

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************
OPEN.SEQ.FILE:
**************
* In this para of the program, the out file is opened
**
    OPENSEQ OUT.DIR, FINAL.OUT.FILE.NAME TO OUT.PTR ELSE
        INT.CODE = "REP001"
        INT.TYPE = "ONLINE"
        MON.TP   = 04
        REC.CON  = "GR03"
        DESC     = "GR03"
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************
WRITE.TO.FILE:
**************
* In this para of the program, the final array is written to the file
**
    CHANGE @FM TO CHARX(13):CHARX(10) IN FINAL.ARRAY

    WRITESEQ FINAL.ARRAY APPEND TO OUT.PTR ELSE
        INT.CODE = "REP001"
        INT.TYPE = "ONLINE"
        MON.TP   = 04
        REC.CON  = "GR03"
        DESC     = "GR03"
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
