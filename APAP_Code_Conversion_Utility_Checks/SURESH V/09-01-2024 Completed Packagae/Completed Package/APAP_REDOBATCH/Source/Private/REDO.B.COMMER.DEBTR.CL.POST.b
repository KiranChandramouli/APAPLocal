* @ValidationCode : MjotNzY4NzIyNDU6Q3AxMjUyOjE3MDM1NjUwMDY4NDc6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Dec 2023 10:00:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.COMMER.DEBTR.CL.POST
*
* Description           : This is the Batch Main Process Routine used to process the all AA Customer Id
*                         and get the Report Related details and Write the details in file.
*
* Development Reference : CL01
*
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
* PACS00466001           Ashokkumar.V.P                 29/06/2016            Initial Release
* 04-APR-2023    	    Conversion tool  		 R22 Auto conversion     FM TO @FM, VM to @VM
* 04-APR-2023           Harishvikram C          Manual R22 conversion    CALL method format changed
*26/12/2023             Suresh                  R22 Manual Conversion    Change F.READ to F.READU
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $USING APAP.REDOCHNLS
*

    GOSUB INITIALISATION
    GOSUB MAIN.PROCESS
RETURN

*--------------
INITIALISATION:
**-------------
*
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    Y.PARAM.ID = "REDO.CL01"
    R.REDO.H.REPORTS.PARAM = ''; PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.OUT.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.OUT.FILE.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        CHANGE @VM TO '' IN Y.OUT.FILE.NAME
    END ELSE
        Y.ERR.MSG   = "REDO.H.REPORTS.PARAM record ":Y.PARAM.ID:" not found"
        GOSUB RAISE.ERR.C.22
        RETURN
    END
    FN.DR.REG.CL01.WORKFILE = 'F.DR.REG.CL01.WORKFILE'
    F.DR.REG.CL01.WORKFILE = ''
    CALL OPF(FN.DR.REG.CL01.WORKFILE, F.DR.REG.CL01.WORKFILE)

    FN.CHK.DIR = Y.OUT.FILE.PATH
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    CHANGE @VM TO '' IN Y.OUT.FILE.PATH
    Y.FILE.NAME = Y.OUT.FILE.NAME:'_':R.DATES(EB.DAT.LAST.WORKING.DAY):'.txt'

    R.FIL = ''; READ.FIL.ERR = ''
*    CALL F.READ(FN.CHK.DIR,Y.FILE.NAME,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    CALL F.READU(FN.CHK.DIR,Y.FILE.NAME,R.FIL,F.CHK.DIR,READ.FIL.ERR,"") ;*R22 Manual Conversion
    IF R.FIL THEN
        CALL F.DELETE(FN.CHK.DIR,Y.FILE.NAME)
    END
RETURN
*------------
MAIN.PROCESS:
**-----------
    SEL.CMD = ''; SEL.LIST = ''; NO.OF.REC = ''; RET.CODE = ''
    SEL.CMD = "SELECT ":FN.DR.REG.CL01.WORKFILE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        R.REC = ''; TEMP.ERR = ''
        CALL F.READ(FN.DR.REG.CL01.WORKFILE, Y.TEMP.ID, R.REC, F.DR.REG.CL01.WORKFILE,TEMP.ERR)
        IF TEMP.ERR THEN
            INT.CODE = "REP001"
            INT.TYPE = "ONLINE"
            MON.TP   = 04
            REC.CON  = 'CL01-':TEMP.ERR
            DESC     = 'CL01-':TEMP.ERR
*        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*Manual R22 conversion
        END ELSE
            FINAL.ARRAY<-1> = R.REC
        END
    REPEAT
    CRLF = CHARX(013):CHARX(010)
    CHANGE @FM TO CRLF IN FINAL.ARRAY
    WRITE FINAL.ARRAY ON F.CHK.DIR, Y.FILE.NAME ON ERROR
        Y.ERR.MSG = "Unable to Write '":F.CHK.DIR:"'"
        GOSUB RAISE.ERR.C.22
    END
RETURN
*--------------
RAISE.ERR.C.22:
*--------------
    MON.TP   = "08"
    REC.CON  = "CL01-":Y.ERR.MSG
    DESC     = "CL01-":Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO   = ''
    BAT.TOT  = ''
    INFO.OR  = ''
    INFO.DE  = ''
    ID.PROC  = ''
    EX.USER  = ''
    EX.PC    = ''
*   CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE, INT.TYPE, BAT.NO, BAT.TOT, INFO.OR, INFO.DE, ID.PROC, MON.TP, DESC, REC.CON, EX.USER, EX.EC) ;*Manual R22 conversion
RETURN
*
END
