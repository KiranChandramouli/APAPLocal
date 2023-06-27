* @ValidationCode : MjozNzYzMDk0NjI6VVRGLTg6MTY4NDIyMjgyNDgxNTpJVFNTOi0xOi0xOjMwMjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:24
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 302
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.LIST.AFFI.FOR.INDIV.POST
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This is an batch routine used to process the records from CUSTOMER file with required
**                        selection and generate report in the parameterized out folder
*
* Developed By          : Shiva Prasad Y, Capgemini
*
* Development Reference : 786892-218-MV33
*
* Attached To           : Batch - BNK/REDO.B.LIST.AFFI.FOR.INDIV
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
** 24-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 24-04-2023 Skanda R22 Manual Conversion - Call method format changed
*-----------------------------------------------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $USING APAP.REDOCHNLS
*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para of the program, from where the execution of the code starts
**
    SLEEP 30
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

RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts
**
    GOSUB GET.PARAM.DETAILS

    CURR.MONTH = TODAY[5,2]
    CURR.MONTH = TRIM(CURR.MONTH,'0','L')

    LOCATE CURR.MONTH IN REP.GEN.MONTHS<1,1,1> SETTING FOUND.POS ELSE
        RETURN
    END

    GOSUB GET.REPORT.LINES

RETURN
*-----------------------------------------------------------------------------------------------------------------
******************
GET.PARAM.DETAILS:
******************
* In this para of the program, the values from REDO.H.REPORTS.PARAM are fetched
**
    REDO.H.REPORTS.PARAM.ID = "REDO.MV33"
    GOSUB READ.REDO.H.REPORTS.PARAM

    FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
    OUT.PATH  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    CHANGE @VM TO '' IN OUT.PATH

    FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    LOCATE 'REP.GEN.MONTH' IN FIELD.NAME<1,1> SETTING GEN.FOUND.POS THEN
        REP.GEN.MONTHS = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,GEN.FOUND.POS>
    END

    FINAL.OUT.FILE.NAME = FILE.NAME:'_':R.DATES(EB.DAT.LAST.WORKING.DAY):'.csv'
    GOSUB OPEN.SEQ.FILE

RETURN
*-----------------------------------------------------------------------------------------------------------------
*****************
GET.REPORT.LINES:
*****************
* In this para of the program, the report lines are fecthed from TEMP directory
**
    OPEN TEMP.PATH TO TEMP.PTR ELSE
        ERR.MSG  = "Unable to open:'":TEMP.PATH:"'"
        INT.CODE = 'REP001'
        INT.TYPE = 'ONLINE'
        MON.TP   = 04
        REC.CON  = 'MV33-':ERR.MSG
        DESC     = 'MV33-':ERR.MSG
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*R22 Manual Conversion
    END

    SEQ.NO = 1

    SEL.CMD = 'SELECT ':TEMP.PATH:' LIKE ':FILE.NAME:'...'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    IF NOT(SEL.LIST) THEN
        RETURN
    END

    LOOP
        REMOVE REC.ID FROM SEL.LIST SETTING REC.POS
    WHILE REC.ID : REC.POS
        R.TEMP.PATH = '';ERR.MSG = ''
        CALL F.READ(TEMP.PATH,REC.ID,R.TEMP.PATH,TEMP.PTR,ERR.MSG)
        IF ERR.MSG NE '' THEN
            ERR.MSG  = "Unable to read rcord :'":REC.ID:"'"
            INT.CODE = 'REP001'
            INT.TYPE = 'ONLINE'
            MON.TP   = 04
            REC.CON  = 'MV33-':ERR.MSG
            DESC     = 'MV33-':ERR.MSG
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*R22 Manual Conversion
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

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************
OPEN.SEQ.FILE:
**************
* In this para of the program, the OUT FILE is opened
**
    IF OUT.PATH AND FINAL.OUT.FILE.NAME THEN
        OPENSEQ OUT.PATH,FINAL.OUT.FILE.NAME TO FINAL.SEQ.PTR  ELSE
            CREATE FINAL.SEQ.PTR ELSE
                GOSUB C22.LOG
            END
        END
    END
    ELSE
        GOSUB C22.LOG
    END
RETURN

********
C22.LOG:
********
    ERR.MSG  = "Unable to open '":FINAL.OUT.FILE.NAME:"'"
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    MON.TP   = 04
    REC.CON  = 'MV33-':ERR.MSG
    DESC     = 'MV33-':ERR.MSG
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*R22 Manual Conversion
RETURN
*-----------------------------------------------------------------------------------------------------------------
**************************
READ.REDO.H.REPORTS.PARAM:
**************************
* In this para of the program, file REDO.H.REPORTS.PARAM is read
**
    R.REDO.H.REPORTS.PARAM  = ''; REDO.H.REPORTS.PARAM.ER = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ER)

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************
WRITE.TO.FILE:
**************
* In this para of the program, the final array is written to the file
**
    CHANGE @FM TO CHARX(13):CHARX(10) IN FINAL.ARRAY
    WRITESEQ FINAL.ARRAY APPEND TO FINAL.SEQ.PTR ELSE
        ERR.MSG  = "Unable to write '":FINAL.OUT.FILE.NAME:"'"
        INT.CODE = 'REP001'
        INT.TYPE = 'ONLINE'
        MON.TP   = 04
        REC.CON  = 'MV33-':ERR.MSG
        DESC     = 'MV33-':ERR.MSG
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*R22 Manual Conversion
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
