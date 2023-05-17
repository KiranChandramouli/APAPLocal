*-----------------------------------------------------------------------------
* <Rating>-56</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.YER.END.FX.SALE.POST
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
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
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00375392          Ashokkumar.V.P                  16/12/2014           Rewritten the routine based on mapping
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT TAM.BP I_REDO.B.YER.END.FX.SALE.COMMON

    GOSUB PROCESS.PARA
    GOSUB PROCESS
    RETURN

PROCESS.PARA:
*
    START.DATE = ''; END.DATE = ''; R.REDO.H.REPORTS.PARAM = ''; REDO.PARAM.ERR = ''; Y.FIN.ARRAY = ''
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'; F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    REDO.H.REPORTS.PARAM.ID = BATCH.DETAILS<3,1,1>
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
    Y.OUT.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
    Y.TEMP.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
    Y.OUT.FILE.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    Y.GROUP.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    Y.GROUP.NAME = CHANGE(Y.GROUP.NAME,VM,FM)
    Y.TODAY  = R.DATES(EB.DAT.LAST.WORKING.DAY)

    LOCATE 'FROM.DATE' IN Y.GROUP.NAME SETTING FDT.POS THEN
        START.DATE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,FDT.POS>[1,6]
    END
    LOCATE 'TO.DATE' IN Y.GROUP.NAME SETTING TDT.POS THEN
        END.DATE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,TDT.POS>[1,6]
    END

    IF LEN(START.DATE) NE 8 AND LEN(END.DATE) NE 8 THEN
        START.DATE = Y.TODAY[1,4]:"01"
        END.DATE = Y.TODAY[1,6]
    END

    LOCATE 'HD.SEL.CODE' IN Y.GROUP.NAME SETTING HD.POS THEN
        HEADER.DET.1 = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,HD.POS,1>
        HEADER.DET.2 = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,HD.POS,2>
    END

    FN.REDO.REPORT.TEMP = Y.TEMP.DIR; F.REDO.REPORT.TEMP = ""
    CALL OPF(FN.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP)

    Y.TODAY  = R.DATES(EB.DAT.LAST.WORKING.DAY)
    TIME.STAMP.VAL = TIMEDATE()
    Y.TIME = FIELD(TIME.STAMP.VAL,' ',1)
    CHANGE ":" TO '' IN Y.TIME
    Y.OUT.FILE.PATH = CHANGE(Y.OUT.FILE.PATH,VM,'')
    Y.FILE.NAME = Y.OUT.FILE.NAME:'.':Y.TODAY:'.':Y.TIME:'.txt'
    OPENSEQ Y.OUT.FILE.PATH,Y.FILE.NAME TO Y.SEQ.PTR ELSE
        CREATE Y.FILE.NAME ELSE
            Y.ERR.MSG   = "Unable to Open '":Y.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END
    RETURN
*-----------------------------------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------------------------------
*Select REDO.REPORT.TEMP
*Frame Loop and Remove the id
*Read REDO.REPORT.TEMP If Record Exits then store it to an array
*Else Raise
*-----------------------------------------------------------------------------------------------------------------
    Y.SEQ.NO = 0; YTOT.LCY.VAL = 0
    SEL.CMD = "SELECT ":FN.REDO.REPORT.TEMP:" LIKE ":Y.OUT.FILE.NAME:".TEMP..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        R.REDO.REPORT.TEMP = ''; TEMP.ERR = ''
        CALL F.READ(FN.REDO.REPORT.TEMP,Y.TEMP.ID,R.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP,TEMP.ERR)
        IF TEMP.ERR THEN
            INT.CODE = "REP001"
            INT.TYPE = "ONLINE"
            MON.TP   = 04
            REC.CON  = 'RGN21-':TEMP.ERR
            DESC     = 'RGN21-':TEMP.ERR
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END ELSE
            REPORT.LINES = R.REDO.REPORT.TEMP
            GOSUB APP.SEQ.NO
        END
        CALL F.DELETE(FN.REDO.REPORT.TEMP,Y.TEMP.ID)
    REPEAT

    HEADER.DET.1 = FMT(HEADER.DET.1,"R%3")
    HEADER.DET.2 = FMT(HEADER.DET.2,"R#11")
    START.DATE = FMT(START.DATE,"R%6")
    END.DATE = FMT(END.DATE,"R%6")
    Y.SEQ.NO = FMT(Y.SEQ.NO,"R%12")
    YTOT.LCY.VAL = FMT(YTOT.LCY.VAL,"R2%16")
    YHEADER.ARRY = HEADER.DET.1:HEADER.DET.2:START.DATE:END.DATE:Y.SEQ.NO:YTOT.LCY.VAL
    Y.FIN.ARRY = YHEADER.ARRY:FM:Y.FINAL.ARRY
    IF Y.FIN.ARRY THEN
        GOSUB WRITE.ARRY
    END
    RETURN
*-----------------------------------------------------------------------------------------------------------------
APP.SEQ.NO:
*-----------------------------------------------------------------------------------------------------------------
*Append the Sequential Number to the line
*-----------------------------------------------------------------------------------------------------------------
    REPORT.LINE = ''; REP.POS = ''
    LOOP
        REMOVE REPORT.LINE FROM REPORT.LINES SETTING REP.POS
    WHILE REPORT.LINE:REP.POS
        YARRY.VAL = ''; YLOCAL.AMT = 0
        YLOCAL.AMT = FIELD(REPORT.LINE,'*',2)
        YARRY.VAL = FIELD(REPORT.LINE,'*',1)
        FINAL.ARRAY<-1> = YARRY.VAL
        YTOT.LCY.VAL += YLOCAL.AMT
        Y.SEQ.NO += 1
    REPEAT
    Y.FINAL.ARRY<-1> = FINAL.ARRAY
    FINAL.ARRAY = ''
    RETURN

WRITE.ARRY:
************
    CHANGE FM TO CHARX(13):CHARX(10) IN Y.FIN.ARRY
    WRITESEQ Y.FIN.ARRY ON Y.SEQ.PTR ELSE
        Y.ERR.MSG = "UNABLE TO WRITE TO FILE '":Y.FILE.NAME:"'"
        GOSUB RAISE.ERR.C.22
        RETURN
    END
    R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,FDT.POS> = ''
    R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,TDT.POS> = ''
    CALL F.WRITE(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM)
    RETURN

*-----------------------------------------------------------------------------------------------------------------
RAISE.ERR.C.22:
*-----------------------------------------------------------------------------------------------------------------
*Handling error process
*-----------------------------------------------------------------------------------------------------------------
    MON.TP = "04"
    REC.CON = "RGN21.":Y.ERR.MSG
    DESC = "RGN21.":Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    RETURN
*------------------------------------------------------------------Final End-------------------------------------------
END
