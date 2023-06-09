SUBROUTINE REDO.B.ADDGEST.CORRECT.POST
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

***PICKUP_POINT***
    FN.TEMP.FILE.PATH = '&TEMP&'
    OPEN FN.TEMP.FILE.PATH TO F.TEMP.FILE.PATH ELSE
    END
****WRITING_LOCATION****
    FN.EXP.FILE.PATH = '../EXTRACT/MASSIVE.BP/FINAL'
    OPEN FN.EXP.FILE.PATH TO F.EXP.FILE.PATH ELSE
        Y.MK.CMD = "mkdir ../EXTRACT/MASSIVE.BP/FINAL"
        EXECUTE Y.MK.CMD
        OPEN FN.EXP.FILE.PATH TO F.EXP.FILE.PATH ELSE
        END
    END


    FILE.NAME = "CORRECTION_LOG_REPORT"
    SEQ.CNT = ''
    SEL.CMD = "SELECT ":FN.EXP.FILE.PATH
    CALL EB.READLIST(SEL.CMD,Y.ID.LIST,'',NO.OF.REC,RET.CODE)
    Y.SEQ.NO = '.V':NO.OF.REC+1
    Y.FILE.NAME = FILE.NAME:Y.SEQ.NO:".csv"
    FINAL.ARRAY.LIST = '' ; TEMP.ARRAY.LIST = ''
    Y.SEQ.NO = 1
    SEL.CMD = "SELECT ":FN.TEMP.FILE.PATH
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    TEMP.ARRAY.LIST = ''
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING SEL.POS
    WHILE Y.TEMP.ID:SEL.POS
        R.TEMP.FILE.PATH = ''; TEMP.ERR = ''
        CALL F.READ(FN.TEMP.FILE.PATH,Y.TEMP.ID,R.TEMP.FILE.PATH, F.TEMP.FILE.PATH,TEMP.ERR)
        Y.SEQ.NO = FMT(Y.SEQ.NO,"R%7")
        TEMP.ARRAY.LIST<-1> = R.TEMP.FILE.PATH
        DELETE F.TEMP.FILE.PATH,Y.TEMP.ID
    REPEAT

    FINAL.ARRAY.LIST<1> = 'ARRANGEMENT':'|':'STATUS'
    FINAL.ARRAY.LIST<-1> = TEMP.ARRAY.LIST
    WRITE FINAL.ARRAY.LIST ON F.EXP.FILE.PATH, Y.FILE.NAME ON ERROR
        Y.ERR.MSG = "Unable to Write '":F.EXP.FILE.PATH:"'"
    END
