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

    FI.BATCH.ID = R.RECORD<REDO.FI.CON.ID>
    CRT "EN REDO.FI.CONTROL.ID " : FI.BATCH.ID

RETURN
END
