<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationCode : MjoxODkxNzE0NTY5OkNwMTI1MjoxNjkwMjY0MzgxNDU0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:23:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
=======
=======
>>>>>>> Stashed changes
* @ValidationCode : MjoyMDc1Mzk3NzQ1OkNwMTI1MjoxNjg0ODU0Mzg3MzE0OklUU1M6LTE6LTE6LTI6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -2
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
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
<<<<<<< Updated upstream
<<<<<<< Updated upstream
* Date                  who                   Reference
=======
* Date                  who                   Reference              
>>>>>>> Stashed changes
=======
* Date                  who                   Reference              
>>>>>>> Stashed changes
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ACH.PROCESS
    $INSERT I_F.REDO.ACH.PROCESS.DET
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.ACH.PARAM
    $INSERT I_REDO.B.GEN.ACH.REJINW.FILE.COMMON
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    $USING APAP.REDOCHNLS
=======

>>>>>>> Stashed changes
=======

>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*      CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
=======
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
>>>>>>> Stashed changes
=======
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
>>>>>>> Stashed changes
    END
RETURN
END
