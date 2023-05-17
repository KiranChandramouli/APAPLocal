SUBROUTINE REDO.B.M.FX.REPORT.PROG.SELECT
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      : Nirmal.P
* Reference         :
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
* Description: This is a .SELECT Subroutine
*
*-------------------------------------------------------------------------------
* Modification History
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00375391          Ashokkumar.V.P                  16/12/2014           Rewritten the routine based on mapping
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.B.M.FX.REPORT.PROG.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_F.REDO.FX.CCY.POSN

    GOSUB INIT.VAL
    GOSUB PROCESS.PARA
RETURN
*-------------------------------------------------------------------------------
PROCESS.PARA:
*-----------
    YID.VAL = "@ID[4,8]"
    SEL.CMD = "SELECT ":FN.REDO.FX.CCY.POSN:" WITH @ID LIKE ":LCCY:"... AND (EVAL'":YID.VAL:"' GE ":START.DATE:" AND EVAL'":YID.VAL:"' LE ":END.DATE:")"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,FX.CCY.ERR)
    CALL BATCH.BUILD.LIST("",SEL.LIST)
RETURN

INIT.VAL:
*--------
    START.DATE = ''; END.DATE = ''; YID.VAL = ''; FDT.POS = ''; TDT.POS = ''
    SEL.LIST = ''; NO.OF.REC = ''; FX.CCY.ERR = ''

    Y.LAST.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YFIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    Y.FIELD.NAME = CHANGE(YFIELD.NAME,@VM,@FM)
    LOCATE 'FROM.DATE' IN Y.FIELD.NAME SETTING FDT.POS THEN
        START.DATE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,FDT.POS>
    END
    LOCATE 'TO.DATE' IN Y.FIELD.NAME SETTING TDT.POS THEN
        END.DATE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,TDT.POS>
    END

    IF LEN(START.DATE) NE 8 AND LEN(END.DATE) NE 8 THEN
        START.DATE = Y.LAST.DAY[1,4]:"0101"
        END.DATE = Y.LAST.DAY
    END
RETURN
*--------------------------------------------------------------------------------
END
