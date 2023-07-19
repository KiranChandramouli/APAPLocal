$PACKAGE APAP.REDOFCFI
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*14-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*14-07-2023    VICTORIA S          R22 MANUAL CONVERSION   VARIABLE NAME MODIFIED
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.FI.CONTROL.ID
*
******************************************************************************
*
*
* =============================================================================
*
*    First Release : R09
*    Developed for : APAP
*    Developed by  : Ana Noriega
*    Date          : 2010/Oct/27
*
*=======================================================================
*

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_REDO.FI.ENQ.VAR.COMMON
    $INSERT I_F.REDO.FI.CONTROL

*FI.BATCH.ID = R.RECORD<REDO.FI.CON.ID>
    FI.BATCH.ID = R.RECORD<REDO.FI.CON.TRANSACTION.ID> ;*R22 MANUAL CONVERSION
    CRT "EN REDO.FI.CONTROL.ID " : FI.BATCH.ID

RETURN
END
