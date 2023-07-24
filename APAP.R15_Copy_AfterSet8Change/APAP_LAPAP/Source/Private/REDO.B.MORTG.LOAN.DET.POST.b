$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.MORTG.LOAN.DET.POST
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine reads REDO.REPORT.TEMP and generates a flat file.
*
* Developed By          : Vijayarani G
*
* Development Reference : 786872(FS-210-DE25)
*
* Attached To           : BATCH>BNK/REDO.B.MORTG.LOAN.DET
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
* PACS00362987           Ashokkumar.V.P                 29/10/2014            New mapping changes - Rewritten the whole source.
** 24-04-2023 R22 Auto Conversion 
** 24-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_REDO.B.MORTG.LOAN.DET.COMMON ;* R22 Auto conversion
*
    GOSUB INITIALISE
    GOSUB PROCESS
RETURN

INITIALISE:
************
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    FN.REDO.B.MORTG.LOAN.WORKFILE = 'F.REDO.B.MORTG.LOAN.WORKFILE'
    F.REDO.B.MORTG.LOAN.WORKFILE = ''
    CALL OPF(FN.REDO.B.MORTG.LOAN.WORKFILE,F.REDO.B.MORTG.LOAN.WORKFILE)

    Y.RECORD.PARAM.ID = "REDO.DE25"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.RECORD.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.OUT.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    END

    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    EXTRACT.FILE.ID = Y.OUT.FILE.NAME:'.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.txt'
    R.FILE.DATA = ''
*
    R.FIL = ''; FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END
RETURN

PROCESS:
********
    SEL.CMD = "SELECT ":FN.REDO.B.MORTG.LOAN.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    ID.CTR = 1
    LOOP
    WHILE ID.CTR LE ID.CNT
        R.REC = ''
        Y.SEQ.NO = FMT(ID.CTR,"R%7")
        REC.ID = ID.LIST<ID.CTR>
        CALL F.READ(FN.REDO.B.MORTG.LOAN.WORKFILE, REC.ID, R.REC, F.REDO.B.MORTG.LOAN.WORKFILE, RD.ERR)
        IF R.REC THEN
            R.FILE.DATA<-1> = Y.SEQ.NO:R.REC
        END
        ID.CTR += 1
    REPEAT
*
    WRITE R.FILE.DATA ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END
RETURN

END
