* @ValidationCode : MjoxOTAzMzU0MTg5OkNwMTI1MjoxNjgyMzMxNTY3MjE4OklUU1M6LTE6LTE6Njc3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 677
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.CR.GUARANTEE.POST
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine reads REDO.REPORT.TEMP and generates a flat file.
*
* Developed By          : Vijayarani G
*
* Development Reference : 786711(FS-200-DE03)
*
* Attached To           : BATCH>BNK/REDO.B.CR.GUARANTEE
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
* PACS00353058          Ashokkumar.V.P                  11/11/2014           Changes the fields based on new mapping
* PACS00460181          Ashokkumar.V.P                  02/06/2015           Changes the fields based on new mapping
* CI008098              Ashokkumar.V.P                  04/01/2018           Ajustar el descripción de la garantía de créditos Hipotecarios

*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM, INSERT file folder name removed T24.BP, TAM.BP, ++ TO += 1
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM
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
    Y.RECORD.PARAM.ID = "REDO.DE03"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.RECORD.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.OUT.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.TEMP.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        CHANGE @VM TO '' IN Y.TEMP.DIR
    END ELSE
        Y.ERR.MSG   = "REDO.H.REPORTS.PARAM record ":Y.RECORD.PARAM.ID:" not found"
        RETURN
    END

    FN.DR.REG.DE03.WORKFILE = 'F.DR.REG.DE03.WORKFILE'; F.DR.REG.DE03.WORKFILE =''
    CALL OPF(FN.DR.REG.DE03.WORKFILE,F.DR.REG.DE03.WORKFILE)

    TIME.STAMP.VAL = TIMEDATE()
    Y.TIME = FIELD(TIME.STAMP.VAL,' ',1)
    CHANGE ":" TO '' IN Y.TIME

    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    EXTRACT.FILE.ID = Y.OUT.FILE.NAME:'.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.':Y.TIME:'.txt'
    R.FIL = ''; READ.FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,EXTRACT.FILE.ID
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------------------------------
*Select REDO.REPORT.TEMP
*-----------------------------------------------------------------------------------------------------------------
    Y.SEQ.NO = 1; YSEQ = 1
    SEL.CMD = "SELECT ":FN.DR.REG.DE03.WORKFILE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        R.REC = ''; TEMP.ERR = ''
        CALL F.READ(FN.DR.REG.DE03.WORKFILE, Y.TEMP.ID, R.REC, F.DR.REG.DE03.WORKFILE,TEMP.ERR)
        IF R.REC THEN
            YARR.ID = ''; YARR.ID = FIELD(Y.TEMP.ID,'_',1)
            IF YSEQ NE 1 AND YARR.ID.OLD NE YARR.ID THEN
                Y.SEQ.NO += 1
            END
            Y.SEQ.NO = FMT(Y.SEQ.NO,"R%7")
            FINAL.ARRAY<-1> = Y.SEQ.NO:R.REC
            YARR.ID.OLD = YARR.ID
            YSEQ += 1                       ;** R22 Auto conversion - ++ TO += 1
        END
    REPEAT
    CRLF = CHARX(013):CHARX(010)
    CHANGE @FM TO CRLF IN FINAL.ARRAY
    WRITE FINAL.ARRAY ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        Y.ERR.MSG = "Unable to Write '":F.CHK.DIR:"'"
    END
RETURN
*------------------------------------------------------------------Final End---------------------------------------------------------------------------
END
