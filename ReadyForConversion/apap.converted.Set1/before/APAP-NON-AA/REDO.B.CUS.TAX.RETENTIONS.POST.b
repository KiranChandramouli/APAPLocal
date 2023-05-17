*-----------------------------------------------------------------------------
* <Rating>-78</Rating>
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
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT TAM.BP I_REDO.B.CUS.TAX.RETENTIONS.COMMON
    $INSERT TAM.BP I_F.REDO.H.TAX.DATA.CHECKS
*

    GOSUB INITIALIZE
    GOSUB PROCESS
*
    RETURN
*-----------------------------------------------------------------------------------------------------------------
*
INITIALIZE:
*----------
*Initialize the variables
*Open the neccessary files
*-----------------------------------------------------------------------------------------------------------------
*
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ""
    R.REDO.H.REPORTS.PARAM = ""
*
    FN.REDO.H.TAX.DATA.CHECKS = 'F.REDO.H.TAX.DATA.CHECKS'
    F.REDO.H.TAX.DATA.CHECKS = ''

    CALL OPF(FN.REDO.H.TAX.DATA.CHECKS,F.REDO.H.TAX.DATA.CHECKS)
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    Y.PARAM.ID = BATCH.DETAILS<3,1,1>
    Y.RCL.ID = BATCH.DETAILS<3,1,2>
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
*
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.OUT.DIRECTORY = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.OUT.FILE.ID   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.OUT.FILE.PATH = CHANGE(Y.OUT.DIRECTORY,VM,'')
        Y.OUT.FILE.NAME = Y.OUT.FILE.ID
        Y.INFO.CODE     = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.INFO.CODE>
        Y.RNC.ID        = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.APAP.ID>
        Y.TEMP.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
    END
*
    Y.REP.FLG = ''
    FN.REDO.REPORT.TEMP = Y.TEMP.DIR
    F.REDO.REPORT.TEMP = ""
    CALL OPF(FN.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP)
*
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

    TIME.STAMP.VAL = TIMEDATE()
    Y.TIME = FIELD(TIME.STAMP.VAL,' ',1)
    CHANGE ":" TO '' IN Y.TIME
    Y.OUT.FILE.PATH = CHANGE(Y.OUT.FILE.PATH,VM,'')
    Y.FILE.NAME = Y.OUT.FILE.NAME:'.':R.DATES(EB.DAT.LAST.WORKING.DAY):'.':Y.TIME:'.txt'
    OPENSEQ Y.OUT.FILE.PATH,Y.FILE.NAME TO Y.SEQ.PTR ELSE
        CREATE Y.FILE.NAME ELSE
            Y.ERR.MSG   = "Unable to Open '":Y.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END
    RETURN
*-----------------------------------------------------------------------------------------------------------------
*
PROCESS:
*-------
*Select APAP.REPORT.TEMP
*Frame Loop and Remove the id
*Read APAP.REPORT.TEMP If Record Exits then store it to an array.then Get the TAX amount values.If the customer
*is same then add the Tax amount values else Write the Tax amount as it is.
*Else Raise
*-----------------------------------------------------------------------------------------------------------------
*
    REPORT.LINES = ''; YFLD1.LST = ''; YFLD2.LST = ''; YFLD3.LST = ''; YFLD4.LST = ''
    SEL.CMD = "SELECT ":FN.REDO.REPORT.TEMP:" WITH @ID LIKE ":Y.OUT.FILE.NAME:".TEMP..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        R.REDO.REPORT.TEMP = ''
        TEMP.ERR = ''
        CALL F.READ(FN.REDO.REPORT.TEMP,Y.TEMP.ID,R.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP,TEMP.ERR)
        IF TEMP.ERR THEN
            INT.CODE = "REP001"
            INT.TYPE = "ONLINE"
            MON.TP   = 04
            REC.CON  = 'REGN11-':TEMP.ERR
            DESC     = 'REGN11-':TEMP.ERR
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END ELSE
            REPORT.LINES = R.REDO.REPORT.TEMP
            REPORT.LINES = SORT(REPORT.LINES)
            GOSUB ARRAY.FORMATION
        END
        CALL F.DELETE(FN.REDO.REPORT.TEMP,Y.TEMP.ID)
    REPEAT
    GOSUB FINAL.ARRAY
    GOSUB FORM.HEADEAR.VALS
    RETURN
*-----------------------------------------------------------------------------------------------------------------
ARRAY.FORMATION:
****************
    LOOP
        REMOVE SEL.ID FROM REPORT.LINES SETTING POSN
    WHILE SEL.ID:POSN
        YFLD1 = FIELD(SEL.ID,',',1)
        YFLD2 = FIELD(SEL.ID,',',2)
        YFLD3 = FIELD(SEL.ID,',',3)
        YFLD4 = FIELD(SEL.ID,',',4)

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
    REPEAT
    RETURN

FINAL.ARRAY:
************
    YCNT = 0; YRPT.ARRY = ''
    LOOP
        REMOVE FLD.ID FROM YCUSM.LST SETTING FIN.POS
    WHILE FLD.ID:FIN.POS
        YCNT++
        YVAL1 = YFLD1.LST<YCNT>
        YVAL2 = YFLD2.LST<YCNT>
        YVAL3 = YFLD3.LST<YCNT>
        YVAL4 = YFLD4.LST<YCNT>
        YRPT.ARRY<-1> = FMT(YVAL1,"L#11"):FMT(YVAL2,"R%1"):FMT(YVAL3,"R%6"):FMT(YVAL4,"R2%12")
    REPEAT
    YRPT.ARRY = SORT(YRPT.ARRY)
    RETURN

FORM.HEADEAR.VALS:
*----------------
    Y.NO.OF.RECS = ''
    C$SPARE(451) = Y.INFO.CODE
    C$SPARE(452) = Y.RNC.ID
    C$SPARE(453) = Y.DATE.FROM
    C$SPARE(454) = Y.DATE.TO
    Y.NO.OF.RECS = DCOUNT(YRPT.ARRY,FM)
    C$SPARE(455) = Y.NO.OF.RECS
    IF Y.NO.OF.RECS GE '1' THEN
        MAP.FMT = 'MAP'
        ID.RCON.L = Y.RCL.ID
        ID.APP = Y.PARAM.ID
        R.APP = R.REDO.H.REPORTS.PARAM
        R.APP = ''
        APP = FN.REDO.H.REPORTS.PARAM
        R.RETURN.MSG= ''; ERR.MSG= ''
        CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
        Y.ARRAY = R.RETURN.MSG:FM:YRPT.ARRY
        IF Y.ARRAY THEN
            GOSUB WRITE.FINAL.ARR
        END
    END
    RETURN

WRITE.FINAL.ARR:
****************
    CHANGE FM TO CHARX(13):CHARX(10) IN Y.ARRAY
    WRITESEQ Y.ARRAY ON Y.SEQ.PTR ELSE
        Y.ERR.MSG = "UNABLE TO WRITE TO FILE '":Y.FILE.NAME:"'"
        GOSUB RAISE.ERR.C.22
        RETURN
    END

    R.REDO.H.TAX.DATA.CHECKS<REDO.TAX.REPORT.GEN> = "NO"
    CALL F.WRITE(FN.REDO.H.TAX.DATA.CHECKS,Y.ID,R.REDO.H.TAX.DATA.CHECKS)
    RETURN

RAISE.ERR.C.22:
*--------------
    MON.TP = "04"
    Y.ERR.MSG = "Record not found"
    REC.CON = "REGN11-":Y.ERR.MSG
    DESC = "REGN11-":Y.ERR.MSG
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
END
