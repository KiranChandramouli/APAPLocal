$PACKAGE APAP.REDOENQ
SUBROUTINE E.REDO.BUILD.COMPANIES(ENQ.DATA)
*
* ====================================================================================
*
*     RETURNS COMPANIES TO WHICH THE USER IS GRANTED ACCESS
*
* ====================================================================================
*
*   PACS00136782 - 20110930 -
*
* ====================================================================================
*
* Subroutine Type : BUILD.ROUTINE
* Attached to     : REDO.BRANCH.STATUS
* Attached as     :
* Primary Purpose :
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : JoaquC-n Costa C
* Date            : 2011-10-04
*  DATE             WHO                   REFERENCE                  
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.USER
    $INSERT I_F.COMPANY
*


    GOSUB PROCESS

RETURN
*
* ======
PROCESS:
* ======
*

    IF ENQ.DATA<4,1> THEN
        IF ENQ.DATA<4,1> NE ID.COMPANY THEN
            ENQ.ERROR  ='EB-OTHER.COMPANY.ID.NOT.ALLOWED'
            RETURN
        END
    END
    ENQ.DATA<2,1> = "@ID"
    ENQ.DATA<3,1> = "EQ"
    ENQ.DATA<4,1> = ID.COMPANY
RETURN

*

END
