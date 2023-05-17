SUBROUTINE REDO.B.GEN.ACH.REJINW.FILE.SELECT
*-----------------------------------------------------------------------------
*DESCRIPTION:
*-----------------------------------------------------------------------------
* Input/Output:
*-----------------------------------------------------------------------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*------------------------------------------------------------------------------
* CALLS : -NA-
* CALLED BY : -NA-
*-------------------------------------------------------------------------------
* Revision History:
*--------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 04-Oct-2010        Harish.Y       ODR-2009-12-0290    Initial Creation
* 10-APR-2013        Shesharaj     PERF-CHANGE            Performance Changes
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ACH.PROCESS
    $INSERT I_F.REDO.ACH.PROCESS.DET
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.ACH.PARAM
    $INSERT I_REDO.B.GEN.ACH.REJINW.FILE.COMMON


*!*PERF-CHANGE - Start
*!    SEL.CMD = "SELECT ":FN.REDO.ACH.PROCESS:" WITH EXEC.DATE EQ ":TODAY:" AND PROCESS.TYPE EQ REDO.ACH.INWARD OR PROCESS.TYPE EQ REDO.ACH.REJ.OUTWARD"
    SEL.CMD = "SELECT ":FN.REDO.ACH.PROCESS:" WITH EXEC.DATE EQ ":TODAY : "  AND REJ.GEN NE YES"      ;* Other Conditions are handled in REDO.B.GEN.ACH.REJINW.FILE routine
*!*PERF-CHANGE - End

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
    IF NOT(NOR) THEN
        INT.CODE = Y.INTERF.ID;
        INT.TYPE = 'BATCH';
        BAT.NO = '1';
        BAT.TOT = '1';
        INFO.OR = 'T24';
        INFO.DE = 'T24';
        ID.PROC = 'ACH004';
        MON.TP = '01';
        DESC = 'There are no files to be processed';
        REC.CON = 'REDO.B.GEN.ACH.REJINW.FILE.SELECT';
        EX.USER = OPERATOR;
        EX.PC = '' ;
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END
RETURN
END
