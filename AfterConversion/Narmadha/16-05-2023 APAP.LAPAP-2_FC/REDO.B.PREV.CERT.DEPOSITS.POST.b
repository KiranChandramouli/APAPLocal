* @ValidationCode : MjotOTAwNTY4NjQ0OlVURi04OjE2ODQxNDM3NTQ2MTU6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 May 2023 15:12:34
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
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
** 24-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 24-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------------------------------------------
*XXXX                   <<name of modifier>>                                 <<modification details goes here>>
*-----------------------------------------------------------------------------------------------------------------
* Include files

    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $USING APAP.REDOCHNLS

    SLEEP 30
    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN

INITIALIZE:
*----------
    FN.REDO.H.REPORT.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORT.PARAM = ""
    CALL OPF(FN.REDO.H.REPORT.PARAM,F.REDO.H.REPORT.PARAM)
    FN.DR.REG.CA01.WORKFILE = 'F.DR.REG.CA01.WORKFILE'
    F.DR.REG.CA01.WORKFILE = ''
    CALL OPF(FN.DR.REG.CA01.WORKFILE,F.DR.REG.CA01.WORKFILE)
    Y.PARAM.ID = "REDO.CA01"
    R.REDO.H.REPORTS.PARAM = ''; PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.H.REPORT.PARAM,Y.PARAM.ID,R.REDO.H.REPORT.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORT.PARAM NE '' THEN
        Y.OUT.FILE.NAME = R.REDO.H.REPORT.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.OUT.FILE.PATH = R.REDO.H.REPORT.PARAM<REDO.REP.PARAM.OUT.DIR>
    END ELSE
        Y.ERR.MSG   = "REDO.H.REPORT.PARAM record ":Y.PARAM.ID:" not found"
        GOSUB RAISE.ERR.C.22
        RETURN
    END
*
    FN.CHK.DIR=R.REDO.H.REPORT.PARAM<REDO.REP.PARAM.OUT.DIR>
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    Y.FILE.NAME = Y.OUT.FILE.NAME:'.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.txt'
    CALL F.READ(FN.CHK.DIR,Y.FILE.NAME,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,Y.FILE.NAME
    END
RETURN
*
PROCESS:
*-------
    R.FILE.DATA = ''
    SEL.CMD = "SELECT ":FN.DR.REG.CA01.WORKFILE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        R.REDO.REPORT.TEMP = '';        TEMP.ERR = ''
        CALL F.READ(FN.DR.REG.CA01.WORKFILE,Y.TEMP.ID,R.REDO.REPORT.TEMP,F.DR.REG.CA01.WORKFILE,TEMP.ERR)
        IF R.REDO.REPORT.TEMP THEN
            R.FILE.DATA<-1> = R.REDO.REPORT.TEMP
        END
    REPEAT
    CHANGE @FM TO CHARX(13):CHARX(10) IN R.FILE.DATA
    WRITE R.FILE.DATA ON F.CHK.DIR, Y.FILE.NAME ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END
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
    CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*R22 Manual Conversion
RETURN
END
