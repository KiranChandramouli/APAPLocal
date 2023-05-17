SUBROUTINE REDO.B.LIST.OF.COMPANIES.POST
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :Mayurika Tiwary
*  Program   Name    :REDO.B.LIST.OF.COMPANIES.POST
***********************************************************************************
*Description: REDO.B.LIST.OF.COMPANIES needs to be created to process the report
*             which contains companies where Directors and Officers have 10% or more share.
*****************************************************************************
*linked with: BNK/REDO.B.LIST.OF.COMPANIES
*In parameter:
*Out parameter: N/A
**********************************************************************
* Modification History :
*----------------------------------------------------------------------
*------------
INSERT.FILES:
*------------
*Here all the mandatory insert files are included with their locations.

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_BATCH.FILES
*-----------------------------------------------------------------------------------------------------------------
*---------
MAIN.PARA:
*---------
* This is the para of the program, from where the execution of the code starts.
**
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*-----------------------------------------------------------------------------------------------------------------
*---------
OPEN.PARA:
*---------
* In this para of the program, the files are opened.
**
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM  = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

RETURN
*-----------------------------------------------------------------------------------------------------------------
*------------
PROCESS.PARA:
*------------
* In this para of the program, the main processing starts.
**
    GOSUB GET.PARAM.VALUES

    CURR.MONTH = TODAY[5,2]
    CURR.MONTH = TRIM(CURR.MONTH,'0','L')

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
    FINAL.OUT.FILE.NAME = FILE.NAME :'_': R.DATES(EB.DAT.LAST.WORKING.DAY):'.csv'
    GOSUB OPEN.SEQ.FILE

RETURN
*-----------------------------------------------------------------------------------------------------------------
*****************
GET.REPORT.LINES:
*****************
* In this para of the program, the report lines are fecthed from TEMP directory.
**
    OPEN TEMP.PATH TO TEMP.PTR ELSE

        INT.CODE = "REP001"
        INT.TYPE = "ONLINE"
        MON.TP   = 04
        REC.CON  = 'MV31-':ERR.MSG
        DESC     = 'MV31-':ERR.MSG
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END

    SEQ.NO = 1

    SEL.CMD = "SELECT " :TEMP.PATH: ' LIKE ':FILE.NAME:'...'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

    LOOP
        REMOVE REC.ID FROM SEL.LIST SETTING REC.POS
    WHILE REC.ID : REC.POS
        R.TEMP.PATH = '';ERR.MSG = ''
        CALL F.READ(TEMP.PATH,REC.ID,R.TEMP.PATH,TEMP.PTR,ERR.MSG)
        IF ERR.MSG NE '' THEN
            INT.CODE = "REP001"
            INT.TYPE = "ONLINE"
            MON.TP   = 04
            REC.CON  = 'MV31-':ERR.MSG
            DESC     = 'MV31-':ERR.MSG
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END


        REPORT.LINES = R.TEMP.PATH

        GOSUB APPEND.SEQ.NUM
        CALL F.DELETE(TEMP.PATH,REC.ID)

    REPEAT


RETURN
*-----------------------------------------------------------------------------------------------------------------
***************
APPEND.SEQ.NUM:
***************
* In this para of the program, the sequence number is added to the report lines.
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

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************************
READ.REDO.H.REPORTS.PARAM:
**************************
* In this para of the program, file REDO.H.REPORTS.PARAM is read.
**
    R.REDO.H.REPORTS.PARAM  = ''
    REDO.H.REPORTS.PARAM.ER = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ER)

RETURN
*------------------------------------------------------------------------------------------------------------------
**************
OPEN.SEQ.FILE:
**************
* In this para of the program, the out file is opened.
**
    OPENSEQ OUT.DIR,FINAL.OUT.FILE.NAME TO FINAL.SEQ.PTR ELSE
        ERR.MSG = "UNABLE TO OPEN '":FINAL.OUT.FILE.NAME:"'"
        INT.CODE = 'REP001'
        INT.TYPE = 'ONLINE'
        MON.TP = 04
        REC.CON = 'MV31-':ERR.MSG
        DESC = 'MV31-':ERR.MSG
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END

RETURN
*--------------------------------------------------------------------------------------------------------------------
**************
WRITE.TO.FILE:
**************
* In this para of the program, the final array is written to the file.
**
    CHANGE @FM TO CHARX(13):CHARX(10) IN FINAL.ARRAY
    WRITESEQ FINAL.ARRAY ON FINAL.SEQ.PTR ELSE
        ERR.MSG = "UNABLE TO WRITE TO FILE '":FINAL.OUT.FILE.NAME:"'"
        INT.CODE = 'REP001'
        INT.TYPE = 'ONLINE'
        MON.TP = 04
        REC.CON = 'MV31-':ERR.MSG
        DESC = 'MV31-':ERR.MSG
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------------------------------------------------
END       ;*End of program
