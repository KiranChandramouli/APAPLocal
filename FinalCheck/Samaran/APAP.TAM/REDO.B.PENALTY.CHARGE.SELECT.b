$PACKAGE APAP.TAM
SUBROUTINE REDO.B.PENALTY.CHARGE.SELECT
*------------------------------------------------------------------------
* Description: This is a Select-Routine for BATCH>BNK/REDO.B.PENALTY.CHARGE in order
* to raise the penalty charge on Frequency basis.
*
*------------------------------------------------------------------------
* Input Argument : NA
* Out Argument   : NA
* Deals With     : BATCH>BNK/REDO.B.PENALTY.CHARGE
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                          DESCRIPTION
* 07-NOV-2011     H GANESH     ODR-2011-08-0106 CR-PENALTY CHARGE            Initial Draft.
** 21-04-2023 R22 Auto Conversion no changes
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.PENALTY.CHARGE.COMMON

    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
    Y.CNTR = 0
    LOOP
    WHILE Y.CNTR LT 1 DO
        GOSUB PROCESS.SUB
    REPEAT

    SEL.CMD = 'SELECT ':FN.REDO.CONCAT.PENALTY.CHARGE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

PROCESS.SUB:

    SEL.OFS = 'SELECT ':FN.OFS
    CALL EB.READLIST(SEL.OFS,SEL.LIS,'',NO.OFS,OF.ERR)
    IF NO.OFS EQ 0  THEN
        Y.CNTR = 2
    END

RETURN
END
