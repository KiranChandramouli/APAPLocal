$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.MG.LNS.BY.DEBTOR.POST
*-----------------------------------------------------------------------------
* Description           : This routine reads temporary flat file and generates a flat file in a path specified in
*                         OUT.DIR field of REDO.H.REPORTS.PARAM table
*
* Developed On          : 22-Oct-2013
*
* Developed By          : Emmanuel James Natraj Livingston
*
* Development Reference : 786816(FS-206-DE15)
*
* Attached To           : BATCH>BNK/REDO.B.MG.LNS.BY.DEBTOR
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
* PACS00355150           Ashokkumar.V.P                  24/02/2015      Optimized the relation between the customer.
** 24-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 24-04-2023 Skanda R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
*
    GOSUB INITIALISATION
    GOSUB MAIN.PROCESS
RETURN

*--------------
INITIALISATION:
*--------------

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.DR.REG.DE15.WORKFILE = 'F.DR.REG.DE15.WORKFILE'
    F.DR.REG.DE15.WORKFILE = ''
    CALL OPF(FN.DR.REG.DE15.WORKFILE,F.DR.REG.DE15.WORKFILE)
*
    Y.PARAM.ID = "REDO.DE15"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
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
    FN.CHK.DIR = Y.OUT.FILE.PATH
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    CHANGE @VM TO '' IN Y.OUT.FILE.PATH
    TIME.STAMP.VAL = TIMEDATE()
    Y.TIME = FIELD(TIME.STAMP.VAL,' ',1)
    CHANGE ":" TO '' IN Y.TIME
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
    SEL.CMD = ''; SEL.LIST = ''; NO.OF.REC = ''; RET.CODE = ''
    SEL.CMD = "SELECT ":FN.DR.REG.DE15.WORKFILE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        R.DR.REG.DE15.WORKFILE = ''; TEMP.ERR = ''
        CALL F.READ(FN.DR.REG.DE15.WORKFILE,Y.TEMP.ID,R.DR.REG.DE15.WORKFILE,F.DR.REG.DE15.WORKFILE,TEMP.ERR)
        IF R.DR.REG.DE15.WORKFILE THEN
            Y.TEMP.RECORD<-1> = R.DR.REG.DE15.WORKFILE
        END
    REPEAT
    IF Y.TEMP.RECORD THEN
        Y.STRING = Y.TEMP.RECORD
        GOSUB APPEND.SEQ.NO
    END
RETURN
*
*-------------
APPEND.SEQ.NO:
*-------------
    Y.SEQ.NO = 1
    LOOP
        REMOVE SEL.ID FROM Y.STRING SETTING S.POSN
    WHILE SEL.ID:S.POSN
        YSEQ.NO = ''
        YSEQ.NO = FMT(Y.SEQ.NO,"R%7")
        Y.FINAL.LINE<-1> = YSEQ.NO:SEL.ID
        Y.SEQ.NO += 1
    REPEAT

    CHANGE @FM TO CHARX(13):CHARX(10) IN Y.FINAL.LINE
    WRITE Y.FINAL.LINE ON F.CHK.DIR, Y.FILE.NAME ON ERROR
        Y.ERR.MSG = "Unable to Write '":F.CHK.DIR
        GOSUB RAISE.ERR.C.22
        RETURN
    END
RETURN
*--------------
RAISE.ERR.C.22:
*--------------
    MON.TP   = "15"
    REC.CON  = "DE15-":Y.ERR.MSG
    DESC     = "DE15-":Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO   = ''
    BAT.TOT  = ''
    INFO.OR  = ''
    INFO.DE  = ''
    ID.PROC  = ''
    EX.USER  = ''
    EX.PC    = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*
RETURN
*
END
