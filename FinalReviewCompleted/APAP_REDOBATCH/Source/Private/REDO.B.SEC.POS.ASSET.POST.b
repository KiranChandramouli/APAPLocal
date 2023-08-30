* @ValidationCode : MjoxNTk1OTYxMjM2OkNwMTI1MjoxNjkwMjY0NDUwMTcwOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:24:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.SEC.POS.ASSET.POST
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine reads REDO.REPORT.TEMP and generates a flat file.
*
* Developed By          : Vijayarani G
*
* Development Reference : 786942(FS-219-OA01)
*
* Attached To           : BATCH>BNK/REDO.B.SEC.POS.ASSET
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
* Date                   who                   Reference
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $USING APAP.REDOCHNLS
   
*
    GOSUB INITIALISE
    GOSUB PROCESS
*
RETURN
*-----------------------------------------------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------------------------------------------
*Intialize the variables
*Open the neccessary files
*-----------------------------------------------------------------------------------------------------------------
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    Y.RECORD.PARAM.ID = BATCH.DETAILS<3,1,1>
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.RECORD.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.OUT.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.OUT.FILE.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.TEMP.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        CHANGE @VM TO '' IN Y.TEMP.DIR
    END ELSE
        Y.ERR.MSG   = "REDO.H.REPORTS.PARAM record ":Y.RECORD.PARAM.ID:" not found"
        GOSUB RAISE.ERR.C.22
        RETURN
    END
*
    FN.REDO.REPORT.TEMP = Y.TEMP.DIR
    F.REDO.REPORT.TEMP = ""
    CALL OPF(FN.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP)
*
    Y.OUT.FILE.PATH = CHANGE(Y.OUT.FILE.PATH,@VM,'')
    Y.FILE.NAME = Y.OUT.FILE.NAME:'.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.txt'
    OPENSEQ Y.OUT.FILE.PATH,Y.FILE.NAME TO Y.SEQ.PTR ELSE
        CREATE Y.FILE.NAME ELSE
            Y.ERR.MSG   = "Unable to Open '":Y.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------------------------------
*Select REDO.REPORT.TEMP
*-----------------------------------------------------------------------------------------------------------------
    SEL.CMD = "SELECT ":FN.REDO.REPORT.TEMP:" WITH @ID LIKE ":Y.OUT.FILE.NAME:"..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        CALL F.READ(FN.REDO.REPORT.TEMP,Y.TEMP.ID,R.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP,TEMP.ERR)
        IF R.REDO.REPORT.TEMP NE '' THEN
            Y.TEMP.RECORD = R.REDO.REPORT.TEMP
            GOSUB APP.SEQ.NO
            CALL F.DELETE(FN.REDO.REPORT.TEMP,Y.TEMP.ID)
        END
    REPEAT
*
RETURN
*-----------------------------------------------------------------------------------------------------------------
APP.SEQ.NO:
*-----------------------------------------------------------------------------------------------------------------
*Append the Sequential Number to the line
*-----------------------------------------------------------------------------------------------------------------

    Y.FINAL.LINE = ""
    Y.NO.OF.LINES = DCOUNT(Y.TEMP.RECORD,@FM)
    Y.SEQ.NO = 1
    LOOP
    WHILE Y.SEQ.NO LE Y.NO.OF.LINES
        Y.LINE = Y.TEMP.RECORD<Y.SEQ.NO>
        Y.SEQ.NUM = FMT(Y.SEQ.NO,"R%7")
        IF Y.FINAL.LINE THEN
            Y.FINAL.LINE = Y.FINAL.LINE :@FM: Y.SEQ.NUM:Y.LINE
        END ELSE
            Y.FINAL.LINE = Y.SEQ.NUM:Y.LINE
        END

        Y.SEQ.NO += 1
    REPEAT

    IF Y.FINAL.LINE THEN
        CHANGE @FM TO CHARX(13):CHARX(10) IN Y.FINAL.LINE
        WRITESEQ Y.FINAL.LINE APPEND ON Y.SEQ.PTR ELSE
            Y.ERR.MSG = "Unable to Write '":Y.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
RAISE.ERR.C.22:
*-----------------------------------------------------------------------------------------------------------------
*Handling Fatal error to halt the process
*-----------------------------------------------------------------------------------------------------------------
    MON.TP = "01"
    REC.CON = "OA01-":Y.ERR.MSG
    DESC = "OA01-":Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO   = ''
    BAT.TOT  = ''
    INFO.OR  = ''
    INFO.DE  = ''
    ID.PROC  = ''
    EX.USER  = ''
    EX.PC    = ''
*    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
RETURN

*------------------------------------------------------------------Final End---------------------------------------------------------------------------
END
