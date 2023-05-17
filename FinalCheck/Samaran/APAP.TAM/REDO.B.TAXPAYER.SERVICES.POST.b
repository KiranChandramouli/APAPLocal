$PACKAGE APAP.TAM
SUBROUTINE REDO.B.TAXPAYER.SERVICES.POST
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine reads APAP.REPORT.TEMP and generates a flat file.
*
* Developed By          : Thilak Kumar K
*
* Development Reference : RegN9
*
* Attached To           : BATCH>BNK/REDO.B.TAXPAYER.SERVICES
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
* PACS00350484          Ashokkumar.V.P                  18/12/2014           Added the time and corrected the charx.
* PACS00350484          Ashokkumar.V.P                  03/04/2015           Changed the header length.
* PACS00463470          Ashokkumar.V.P                  23/06/2015           Mapping change to display for RNC and Cedula
*                       Ashokkumar.V.P                  20/01/2015           Seperate report for non REGN9 NCF's.
** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_REDO.B.TAXPAYER.SERVICES.COMMON ;* R22 Auto conversion
*
    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------------------------------------------
*
INITIALIZE:
*----------
*Initialize the variables
*Open the neccessary files
*-----------------------------------------------------------------------------------------------------------------
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.DR.REG.REGN9.WORKFILE = 'F.DR.REG.REGN9.WORKFILE'; F.DR.REG.REGN9.WORKFILE =''
    CALL OPF(FN.DR.REG.REGN9.WORKFILE,F.DR.REG.REGN9.WORKFILE)

    Y.PARAM.ID = "REDO.REGN9"
    PARAM.ERR = ''; R.REDO.H.REPORTS.PARAM = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.OUT.DIRECTORY = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.OUT.FILE.ID   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.OUT.FILE.PATH = CHANGE(Y.OUT.DIRECTORY,@VM,'')
        EXTRACT.FILE.ID = Y.OUT.FILE.ID:'.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.txt'
        EXTRACT.FILENON.ID = Y.OUT.FILE.ID:'_OTHERS.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.txt'
    END
*
    Y.TEMP.ID = ''; R.FIL = ''; FIL.ERR = ''
    Y.RECORD = ''; YN.RECORD = ''; Y.CNT = 0; YN.CNT = 0
    FN.CHK.DIR = Y.OUT.DIRECTORY
    F.CHK.DIR = ""
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
*
    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        CALL F.DELETE(FN.CHK.DIR,EXTRACT.FILE.ID)
        CALL F.DELETE(FN.CHK.DIR,EXTRACT.FILENON.ID)
    END
    Y.PERIOD = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.YEAR   = LEFT(Y.PERIOD,6)
RETURN
*-----------------------------------------------------------------------------------------------------------------
*
PROCESS:
*-------
    Y.TOT.AMT = 0; YN.TOT.AMT = 0
    SEL.CMD = "SELECT ":FN.DR.REG.REGN9.WORKFILE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        R.DR.REG.REGN9.WORKFILE = ''; DR.REG.REGN9.WORKFILE.ERR = ''
        CALL F.READ(FN.DR.REG.REGN9.WORKFILE,Y.TEMP.ID,R.DR.REG.REGN9.WORKFILE,F.DR.REG.REGN9.WORKFILE,DR.REG.REGN9.WORKFILE.ERR)
        IF R.DR.REG.REGN9.WORKFILE THEN
            Y.AMT = ''; YTP.VAL = ''
            Y.AMT  = R.DR.REG.REGN9.WORKFILE[71,12]
            IF Y.TEMP.ID[1,4] EQ 'NONV' THEN
                YN.CNT += 1 ;* R22 Auto conversion
                YN.TOT.AMT+=Y.AMT
                YN.RECORD<-1> = R.DR.REG.REGN9.WORKFILE
            END ELSE
                Y.CNT += 1 ;* R22 Auto conversion
                Y.TOT.AMT+=Y.AMT
                Y.RECORD<-1> = R.DR.REG.REGN9.WORKFILE
            END
        END
    REPEAT
    GOSUB FORM.ARRAY
RETURN
*-----------------------------------------------------------------------------------------------------------------

FORM.ARRAY:
*----------
    GOSUB FORM.HEADER
    GOSUB FORM.HEADER.NON
    GOSUB WRITE.FILE
RETURN
*-----------------------------------------------------------------------------------------------------------------
*
FORM.HEADER:
*-----------
*
    C$SPARE(451) = Y.YEAR
    C$SPARE(452) = Y.CNT
*    C$SPARE(453) = Y.TOT.AMT
*
    MAP.FMT = "MAP"; R.RETURN.MSG = ''; Y.ARRAY = ''
    ID.RCON.L = "REDO.RCL.REGN9.HR"
    APP = FN.REDO.H.REPORTS.PARAM
    R.APP = R.REDO.H.REPORTS.PARAM
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    Y.ARRAY = R.RETURN.MSG
RETURN

FORM.HEADER.NON:
*---------------
*
    C$SPARE(451) = Y.YEAR
    C$SPARE(452) = YN.CNT
    C$SPARE(453) = YN.TOT.AMT
*
    MAP.FMT = "MAP"; R.RETURN.MSG = ''; YN.ARRAY = ''
    ID.RCON.L = "REDO.RCL.REGN9.HR"
    APP = FN.REDO.H.REPORTS.PARAM
    R.APP = R.REDO.H.REPORTS.PARAM
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    YN.ARRAY = R.RETURN.MSG
RETURN
*-----------------------------------------------------------------------------------------------------------------
*
WRITE.FILE:
*----------
    Y.FINAL.ARRAY = Y.ARRAY:@FM:Y.RECORD
    CHANGE @FM TO CHARX(13):CHARX(10) IN Y.FINAL.ARRAY
    CALL F.WRITE(FN.CHK.DIR,EXTRACT.FILE.ID,Y.FINAL.ARRAY)
    IF YN.RECORD THEN
        YN.FINAL.ARRAY = YN.ARRAY:@FM:YN.RECORD
        CHANGE @FM TO CHARX(13):CHARX(10) IN YN.FINAL.ARRAY
        CALL F.WRITE(FN.CHK.DIR,EXTRACT.FILENON.ID,YN.FINAL.ARRAY)
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
END
*-----------------------------------------------------------------------------------------------------------------
