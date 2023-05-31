$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.AMT
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------
* Modification History
* DATE            ODR           BY              DESCRIPTION
* 25-08-2011      PACS00190859  KAVITHA     For enquiry
*
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.USER
    $INSERT I_F.REDO.REJECT.REASON

    GOSUB PROCESS

RETURN

PROCESS:
**********
    Y.VAR  = O.DATA
    Y.RESULT = FMT(Y.VAR,"L2,#25")
    O.DATA = TRIM(Y.RESULT,' ',"R")
RETURN
END
