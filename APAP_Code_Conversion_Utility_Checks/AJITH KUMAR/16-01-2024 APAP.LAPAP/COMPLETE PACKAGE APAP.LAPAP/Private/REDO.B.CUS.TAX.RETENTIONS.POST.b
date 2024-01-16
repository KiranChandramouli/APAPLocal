$PACKAGE APAP.LAPAP
* @(#) REDO.B.CUS.TAX.RETENTIONS.POST Ported to jBASE 16:17:06  28 NOV 2017
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.CUS.TAX.RETENTIONS.POST
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine reads APAP.REPORT.TEMP and generates a flat file.
*
* Developed By          : Amravathi Krithika B
*
* Development Reference : RegN11
*
* Attached To           : BATCH>BNK/REDO.B.CUS.TAX.RETENTIONS
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
* PACS00375393           Ashokkumar.V.P                 11/12/2014            New mapping changes - Rewritten the whole source.
* APAP-132               Ashokkumar.V.P                 03/02/2016            Spliting the file based on customer identification
** 24-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 24-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_REDO.B.CUS.TAX.RETENTIONS.COMMON ;* R22 Auto conversion
    $INSERT I_F.REDO.H.TAX.DATA.CHECKS ;* R22 Auto conversion
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
    YNON.ARRAY = ''; Y.ARRAY = ''
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"; F.REDO.H.REPORTS.PARAM = ""
    R.REDO.H.REPORTS.PARAM = ""; PARAM.ERR = ''
    FN.REDO.H.TAX.DATA.CHECKS = 'F.REDO.H.TAX.DATA.CHECKS'; F.REDO.H.TAX.DATA.CHECKS = ''
    FN.DR.REG.REGN11.WORKFILE = 'F.DR.REG.REGN11.WORKFILE'; F.DR.REG.REGN11.WORKFILE =''
    CALL OPF(FN.REDO.H.TAX.DATA.CHECKS,F.REDO.H.TAX.DATA.CHECKS)
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    CALL OPF(FN.DR.REG.REGN11.WORKFILE,F.DR.REG.REGN11.WORKFILE)

    Y.PARAM.ID = "REDO.REGN11"
    Y.RCL.ID = "REDO.RCL.REGN11"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.OUT.DIRECTORY = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.OUT.FILE.ID   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.OUT.FILE.PATH = CHANGE(Y.OUT.DIRECTORY,@VM,'')
        Y.OUT.FILE.NAME = Y.OUT.FILE.ID
        Y.INFO.CODE     = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.INFO.CODE>
        Y.RNC.ID        = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.APAP.ID>
        Y.TEMP.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
    END
*
    Y.REP.FLG = ''; R.FIL = ''; FIL.ERR = ''
    FN.CHK.DIR = Y.OUT.DIRECTORY
    F.CHK.DIR = ""
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    EXTRACT.FILE.ID = Y.OUT.FILE.NAME:'.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.txt'
    EXTRACT.FILENON.ID = Y.OUT.FILE.NAME:'_OTHERS.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.txt'
    EXTRACT.FILE.DGID = 'DG01.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.txt'
*    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    CALL F.READU(FN.CHK.DIR,EXTRACT.FILE.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR,'');* R22 UTILITY AUTO CONVERSION
    IF R.FIL THEN
        CALL F.DELETE(FN.CHK.DIR,EXTRACT.FILE.ID)
    END
    Y.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.H.TAX.DATA.CHECKS,Y.ID,R.REDO.H.TAX.DATA.CHECKS,Y.TDC.ERR)
    Y.REP.GEN   = R.REDO.H.TAX.DATA.CHECKS<REDO.TAX.REPORT.GEN>
    Y.DATE.FROM = R.REDO.H.TAX.DATA.CHECKS<REDO.TAX.DATE.FROM>
    Y.DATE.TO   = R.REDO.H.TAX.DATA.CHECKS<REDO.TAX.DATE.TO>
    IF Y.DATE.FROM AND Y.DATE.TO AND Y.REP.GEN EQ 'YES' THEN
        Y.REP.FLG = '1'
    END
    IF NOT(Y.REP.FLG) THEN
        Y.DATE.FROM = R.DATES(EB.DAT.LAST.WORKING.DAY)[1,6]:'01'
        Y.DATE.TO = TODAY
        CALL CDT('',Y.DATE.TO,'-1C')
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
*
PROCESS:
*-------
*Frame Loop and Remove the id
*Read APAP.REPORT.TEMP If Record Exits then store it to an array.then Get the TAX amount values.If the customer
*is same then add the Tax amount values else Write the Tax amount as it is.
*Else Raise
*-----------------------------------------------------------------------------------------------------------------
*
    REPORT.LINES = ''; YFLD1.LST = ''; YFLD2.LST = ''; YFLD3.LST = ''; YFLD4.LST = ''; YCUSM.LST = ''
    SEL.CMD = ''; SEL.LIST =''; NO.OF.REC = ''; RET.CODE = ''; YCUSM.DGLST = ''; YDG.ARRY = ''; YCNT.SEQ = 0
    SEL.CMD = "SSELECT ":FN.DR.REG.REGN11.WORKFILE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    SEL.LIST = SORT(SEL.LIST)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        R.DR.REG.REGN11.WORKFILE = ''; DR.REG.REGN11.WORKFILE.ERR = ''
        CALL F.READ(FN.DR.REG.REGN11.WORKFILE,Y.TEMP.ID,R.DR.REG.REGN11.WORKFILE,F.DR.REG.REGN11.WORKFILE,DR.REG.REGN11.WORKFILE.ERR)
        IF R.DR.REG.REGN11.WORKFILE AND Y.TEMP.ID[1,6] EQ 'REGN11' THEN
            YFLD1 = ''; YFLD2 = ''; YFLD3 = ''; YFLD4 = ''; YTEP.FLD4 = ''
            YFLD1 = FIELD(R.DR.REG.REGN11.WORKFILE,',',1)
            YFLD2 = FIELD(R.DR.REG.REGN11.WORKFILE,',',2)
            YFLD3 = FIELD(R.DR.REG.REGN11.WORKFILE,',',3)
            YFLD4 = FIELD(R.DR.REG.REGN11.WORKFILE,',',4)

            LOCATE YFLD1:YFLD3 IN YCUSM.LST SETTING CUS.POS THEN
                YTEP.FLD4 = YFLD4.LST<CUS.POS>
                YFLD4.LST<CUS.POS> = YTEP.FLD4 + YFLD4
            END ELSE
                YFLD1.LST<-1> = YFLD1
                YFLD2.LST<-1> = YFLD2
                YFLD3.LST<-1> = YFLD3
                YFLD4.LST<-1> = YFLD4
                YCUSM.LST<-1> = YFLD1:YFLD3
            END
        END
        IF R.DR.REG.REGN11.WORKFILE AND Y.TEMP.ID[1,4] EQ 'DG01' THEN
            YCNT.SEQ += 1 ;* R22 Auto conversion
            YDG.ARRY<-1> = FMT(YCNT.SEQ,'R%7'):R.DR.REG.REGN11.WORKFILE
        END
    REPEAT
    GOSUB DG01.FIN.ARRY
    GOSUB FINAL.ARRAY
    GOSUB FORM.HEADEAR.VALS
    GOSUB FORM.HEADEAR.ZERO
    IF YNON.ARRAY OR Y.ARRAY THEN
        R.REDO.H.TAX.DATA.CHECKS<REDO.TAX.REPORT.GEN> = "NO"
        R.REDO.H.TAX.DATA.CHECKS<REDO.TAX.DATE.FROM> = ''
        R.REDO.H.TAX.DATA.CHECKS<REDO.TAX.DATE.TO> = ''
        CALL F.WRITE(FN.REDO.H.TAX.DATA.CHECKS,Y.ID,R.REDO.H.TAX.DATA.CHECKS)
    END
RETURN

FINAL.ARRAY:
************
    YCNT = 0; YRPT.ARRY = ''; YRPT.ARRY.ZERO = ''
    LOOP
        REMOVE FLD.ID FROM YCUSM.LST SETTING FIN.POS
    WHILE FLD.ID:FIN.POS
        YCNT += 1 ;* R22 Auto conversion
        YVAL1 = YFLD1.LST<YCNT>
        YVAL2 = YFLD2.LST<YCNT>
        YVAL3 = YFLD3.LST<YCNT>
        YVAL4 = YFLD4.LST<YCNT>
        IF YVAL2 EQ 2 OR YVAL2 EQ 1 THEN
            YRPT.ARRY<-1> = FMT(YVAL1,"L#11"):FMT(YVAL2,"R%1"):FMT(YVAL3,"R%6"):FMT(YVAL4,"R2%12")
        END ELSE
            YRPT.ARRY.ZERO<-1> = FMT(YVAL1,"L#11"):FMT(YVAL2,"R%1"):FMT(YVAL3,"R%6"):FMT(YVAL4,"R2%12")
        END
    REPEAT
    YRPT.ARRY = SORT(YRPT.ARRY)
    YRPT.ARRY.ZERO = SORT(YRPT.ARRY.ZERO)
RETURN

DG01.FIN.ARRY:
**************
    R.FIL = ''; READ.FIL.ERR = ''
*    CALL F.READ(FN.CHK.DIR,EXTRACT.FILE.DGID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    CALL F.READU(FN.CHK.DIR,EXTRACT.FILE.DGID,R.FIL,F.CHK.DIR,READ.FIL.ERR,'');* R22 UTILITY AUTO CONVERSION
    IF R.FIL THEN
        CALL F.DELETE(FN.CHK.DIR,EXTRACT.FILE.DGID)
    END
    IF YDG.ARRY THEN
        CHANGE @FM TO CHARX(13):CHARX(10) IN YDG.ARRY
        CALL F.WRITE(FN.CHK.DIR,EXTRACT.FILE.DGID,YDG.ARRY)
    END
RETURN

FORM.HEADEAR.VALS:
*----------------
    Y.NO.OF.RECS = ''
    C$SPARE(451) = Y.INFO.CODE
    C$SPARE(452) = Y.RNC.ID
    C$SPARE(453) = Y.DATE.FROM
    C$SPARE(454) = Y.DATE.TO
    Y.NO.OF.RECS = DCOUNT(YRPT.ARRY,@FM)
    C$SPARE(455) = Y.NO.OF.RECS
    IF Y.NO.OF.RECS GE '1' THEN
        MAP.FMT = 'MAP'
        ID.RCON.L = Y.RCL.ID
        ID.APP = Y.PARAM.ID
        R.APP = R.REDO.H.REPORTS.PARAM
        R.APP = ''
        APP = FN.REDO.H.REPORTS.PARAM
        R.RETURN.MSG= ''; ERR.MSG= ''; Y.ARRAY = ''
        CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
        Y.ARRAY = R.RETURN.MSG:@FM:YRPT.ARRY
        IF Y.ARRAY THEN
            CHANGE @FM TO CHARX(13):CHARX(10) IN Y.ARRAY
            CALL F.WRITE(FN.CHK.DIR,EXTRACT.FILE.ID,Y.ARRAY)
        END
    END
RETURN

FORM.HEADEAR.ZERO:
******************
    R.FIL = ''; READ.FIL.ERR = ''; Y.NO.OF.RECS = ''
*    CALL F.READ(FN.CHK.DIR,EXTRACT.FILENON.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    CALL F.READU(FN.CHK.DIR,EXTRACT.FILENON.ID,R.FIL,F.CHK.DIR,READ.FIL.ERR,'');* R22 UTILITY AUTO CONVERSION
    IF R.FIL THEN
        CALL F.DELETE(FN.CHK.DIR,EXTRACT.FILENON.ID)
    END
    C$SPARE(451) = Y.INFO.CODE
    C$SPARE(452) = Y.RNC.ID
    C$SPARE(453) = Y.DATE.FROM
    C$SPARE(454) = Y.DATE.TO
    Y.NO.OF.RECS = DCOUNT(YRPT.ARRY.ZERO,@FM)
    C$SPARE(455) = Y.NO.OF.RECS
    IF Y.NO.OF.RECS GE '1' THEN
        MAP.FMT = 'MAP'
        ID.RCON.L = Y.RCL.ID
        ID.APP = Y.PARAM.ID
        R.APP = R.REDO.H.REPORTS.PARAM
        R.APP = ''
        APP = FN.REDO.H.REPORTS.PARAM
        R.RETURN.MSG= ''; ERR.MSG= ''; YNON.ARRAY = ''
        CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
        YNON.ARRAY = R.RETURN.MSG:@FM:YRPT.ARRY.ZERO
        IF YNON.ARRAY THEN
            CHANGE @FM TO CHARX(13):CHARX(10) IN YNON.ARRAY
            CALL F.WRITE(FN.CHK.DIR,EXTRACT.FILENON.ID,YNON.ARRAY)
        END
    END
RETURN

END
