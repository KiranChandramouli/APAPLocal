* @ValidationCode : MjotMTY1NjkyNzA0MzpDcDEyNTI6MTY4NDQ5MTAyODk5NDpJVFNTOi0xOi0xOjU1NzoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 557
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.B.CUSTOMER.RGA.POST
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      : Nirmal.P
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description: This is a .POST Subroutine
*
*-------------------------------------------------------------------------------
* Modification History
* ***************************
*   Date       Author              Modification Description
*
* 05/02/2015  Ashokkumar.V.P        PACS00368383 - New mapping changes

** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - CALL RTN FORMAT MODIFIED
*--------------------------------------------------------------------------------
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_REDO.B.CUSTOMER.RGA.COMMON ;* R22 Auto conversion
    $USING APAP.REDOCHNLS

    GOSUB OPEN.FILES
    GOSUB PROCESS.PARA
RETURN
*-------------------------------------------------------------------------------
OPEN.FILES:
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.DR.REG.RIEN15.WORKFILE = 'F.DR.REG.RIEN15.WORKFILE'
    F.DR.REG.RIEN15.WORKFILE = ''
    CALL OPF(FN.DR.REG.RIEN15.WORKFILE,F.DR.REG.RIEN15.WORKFILE)

    Y.D = "-1C"
    Y.LST.CDAY = TODAY
    Y.LST.CDAY =Y.LST.CDAY[1,6]:'01'
    CALL CDT('',Y.LST.CDAY,Y.D)
RETURN

PROCESS.PARA:
*--------------*
    REDO.H.REPORTS.PARAM.ID = 'REDO.RN15'
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
*
    IF R.REDO.H.REPORTS.PARAM THEN
        TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        OUT.PATH = CHANGE(OUT.PATH,@VM,' ')
        Y.FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        LOCATE 'HD.SEL.CODES' IN Y.FIELD.NAME SETTING HD.POS THEN
            HEADER.DET = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,HD.POS>
        END
        FINAL.ARRAY = ''; NO.OF.CUS = 0; NO.OF.FINAL = ''; REPORT.LINE = ''; REPORT.LINES = ''
        FILENAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        FINAL.OUT.FILE.NAME = FILENAME:Y.LST.CDAY:'.txt'

        FN.CHK.DIR = OUT.PATH
        F.CHK.DIR = ""
        CALL OPF(FN.CHK.DIR,F.CHK.DIR)
        R.FIL = ''; READ.FIL.ERR = ''
        CALL F.READ(FN.CHK.DIR,FINAL.OUT.FILE.NAME,R.FIL,F.CHK.DIR,READ.FIL.ERR)
        IF R.FIL THEN
            DELETE F.CHK.DIR,FINAL.OUT.FILE.NAME
        END

        SEL.CMD = "SELECT ":FN.DR.REG.RIEN15.WORKFILE
        SEL.LIST = ''; NO.OF.RECS = ''; SEL.ERR = ''; FINAL.ARRAY=''
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)
        LOOP
            REMOVE REC.ID FROM SEL.LIST SETTING SEL.POS
        WHILE REC.ID:SEL.POS
            ERR.DR.REG.RIEN15.WORKFILE = ''; R.DR.REG.RIEN15.WORKFILE = ''
            CALL F.READ(FN.DR.REG.RIEN15.WORKFILE,REC.ID,R.DR.REG.RIEN15.WORKFILE,F.DR.REG.RIEN15.WORKFILE,ERR.DR.REG.RIEN15.WORKFILE)
            FINAL.ARRAY<-1> = R.DR.REG.RIEN15.WORKFILE
        REPEAT
        GOSUB OPEN.SEQ.FILE
        GOSUB PROCESS.FINAL.ARRAY
    END
RETURN
*
PROCESS.FINAL.ARRAY:
*-------------------*
    NO.OF.FINAL = DCOUNT(FINAL.ARRAY,@FM)
    NO.OF.FINAL = FMT(NO.OF.FINAL,"R%12")
    NO.OF.CUS = NO.OF.FINAL
    LCC.HEADER = ''
    LCC.HEADER<-1> = HEADER.DET<1,1,1>
    LCC.HEADER<-1> = FILENAME
    LCC.HEADER<-1> = '01/':Y.LST.CDAY[5,2]:'/':Y.LST.CDAY[1,4]:',':Y.LST.CDAY[7,2]:'/':Y.LST.CDAY[5,2]:'/':Y.LST.CDAY[1,4]
    LCC.HEADER<-1> =  NO.OF.CUS
    LCC.HEADER<-1> = HEADER.DET<1,1,3>
    LCC.HEADER<-1> = HEADER.DET<1,1,4>
*    LCC.HEADER = LCC.HEADER :CHARX(13):CHARX(10)
    CHANGE @FM TO CHARX(13):CHARX(10) IN FINAL.ARRAY
    CHANGE @FM TO CHARX(13):CHARX(10) IN LCC.HEADER
    WRITESEQ LCC.HEADER ON FINAL.SEQ.PTR THEN
    END
    GOSUB WRITE.TO.FILE
*
    Y.FLAG = ''
RETURN

*-------------------------------------------------------------------------------------
OPEN.SEQ.FILE:
*-------------
    OPENSEQ OUT.PATH,FINAL.OUT.FILE.NAME TO FINAL.SEQ.PTR ELSE
        CREATE FINAL.SEQ.PTR ELSE
            ERR.MSG = "Unable to open ":FINAL.OUT.FILE.NAME:""
            INT.CODE = "R15"
            INT.TYPE = "ONLINE"
            MON.TP = "02"
            REC.CON = "R15-":ERR.MSG
            DESC = "R15-":ERR.MSG
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)  ;*R22 MANUAL CODE CONVERSION
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)  ;*R22 MANUAL CODE CONVERSION
            
        END
    END
RETURN
*---------------------------------------------------------------------------------
WRITE.TO.FILE:
*--------------
    WRITESEQ FINAL.ARRAY ON FINAL.SEQ.PTR ELSE
        ERR.MSG = "Unable to write to ":FILENAME
        INT.CODE = "R15"
        INT.TYPE = "ONLINE"
        MON.TP = "02"
        REC.CON = "R15-":ERR.MSG
        DESC = "R15-":ERR.MSG
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*R22 MANUAL CODE CONVERSION
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 MANUAL CODE CONVERSION
    END
RETURN
*-------------------------------------------------------------------------
END
