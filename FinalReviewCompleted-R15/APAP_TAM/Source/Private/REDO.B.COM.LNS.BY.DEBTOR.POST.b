* @ValidationCode : Mjo0NDE3MTcyNTU6Q3AxMjUyOjE2ODMwMzQyNDkyNjI6SVRTUzotMTotMTo2NjM6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 May 2023 19:00:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 663
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.B.COM.LNS.BY.DEBTOR.POST
*-----------------------------------------------------------------------------
* Description           : This routine reads temporary flat file and generates a flat file in a path specified in
*                         OUT.DIR field of REDO.H.REPORTS.PARAM table.
*
* Developed On          : 14-Nov-2013
*
* Developed By          : Amaravathi Krithika B
*
* Development Reference : DE11
*
* Attached To           : BATCH>BNK/REDO.B.COM.LNS.BY.DEBTOR
*
* Attached As           : COB Singlethreaded Routine
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*-----------------*
* Output Parameter:
* ----------------*
* Argument#2 : NA
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)             NA                              NA                     NA
* PACS00382500           Ashokkumar.V.P                  06/03/2015      Added new fields based on mapping
*
* Date             Who                   Reference      Description
* 24.04.2023       Conversion Tool       R22            Auto Conversion     - INSERT file folder name removed T24.BP & TAM.BP, FM TO @FM, VM TO @VM
* 24.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
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
    Y.PARAM.ID = "REDO.DE11"
    R.REDO.H.REPORTS.PARAM = ''; PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
*
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.OUT.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.OUT.FILE.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.TEMP.DIR      = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        CHANGE @VM TO '' IN Y.TEMP.DIR
    END ELSE
        Y.ERR.MSG   = "REDO.H.REPORTS.PARAM record ":Y.PARAM.ID:" not found"
        GOSUB RAISE.ERR.C.22
        RETURN
    END
    FN.DR.REG.DE11.WORKFILE = 'F.DR.REG.DE11.WORKFILE'
    F.DR.REG.DE11.WORKFILE = ''
    CALL OPF(FN.DR.REG.DE11.WORKFILE, F.DR.REG.DE11.WORKFILE)

    TIME.STAMP.VAL = TIMEDATE()
    Y.TIME = FIELD(TIME.STAMP.VAL,' ',1)
    CHANGE ":" TO '' IN Y.TIME

    FN.CHK.DIR = Y.OUT.FILE.PATH
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    CHANGE @VM TO '' IN Y.OUT.FILE.PATH
    Y.FILE.NAME = Y.OUT.FILE.NAME:'_':R.DATES(EB.DAT.LAST.WORKING.DAY):'.':Y.TIME:'.txt'

    R.FIL = ''; READ.FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,Y.FILE.NAME,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        CALL F.DELETE(FN.CHK.DIR,Y.FILE.NAME)
    END
RETURN
*------------
MAIN.PROCESS:
**-----------
    SEL.CMD = "SELECT ":FN.DR.REG.DE11.WORKFILE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        R.REC = ''; TEMP.ERR = ''
        CALL F.READ(FN.DR.REG.DE11.WORKFILE, Y.TEMP.ID, R.REC, F.DR.REG.DE11.WORKFILE,TEMP.ERR)
        IF R.REC THEN
            Y.TEMP.RECORD<-1> = R.REC
        END
    REPEAT
    IF Y.TEMP.RECORD THEN
        Y.STRING = Y.TEMP.RECORD
        GOSUB APPEND.SEQ.NO
    END

RETURN
*-------------
APPEND.SEQ.NO:
*-------------
*
    Y.SEQ.NO = 1
    LOOP
        REMOVE SEL.ID FROM Y.STRING SETTING S.POSN
    WHILE SEL.ID:S.POSN
        YSEQ.NO = ''
        YSEQ.NO = FMT(Y.SEQ.NO,"R%7")
        Y.FINAL.LINE<-1> = YSEQ.NO:SEL.ID
        Y.SEQ.NO += 1
    REPEAT
    CHANGE @FM TO CHARX(013):CHARX(010) IN Y.FINAL.LINE
    WRITE Y.FINAL.LINE ON F.CHK.DIR, Y.FILE.NAME ON ERROR
        Y.ERR.MSG = "Unable to Write '":F.CHK.DIR:"'"
        GOSUB RAISE.ERR.C.22
    END
RETURN

*--------------
RAISE.ERR.C.22:
*--------------
*
    MON.TP   = "11"
    REC.CON  = "DE11-":Y.ERR.MSG
    DESC     = "DE11-":Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO   = ''
    BAT.TOT  = ''
    INFO.OR  = ''
    INFO.DE  = ''
    ID.PROC  = ''
    EX.USER  = ''
    EX.PC    = ''
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
** R22 Manual conversion
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*
RETURN
*
END
