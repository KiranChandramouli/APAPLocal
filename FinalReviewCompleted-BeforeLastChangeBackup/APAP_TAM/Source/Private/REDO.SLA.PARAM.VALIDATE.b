$PACKAGE APAP.TAM
SUBROUTINE REDO.SLA.PARAM.VALIDATE
*------------------------------------------------------------------------------
*------------------------------------------------------------------------------
* DESCRIPTION : This routine is used to check the ID value for the table
* REDO.SLA.PARAM
*------------------------------------------------------------------------------
*------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Pradeep S
* PROGRAM NAME : REDO.SLA.PARAM.VALIDATE
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE           DESCRIPTION
* 06-AUG-2010      Pradeep S         PACS00060849         INITIAL CREATION
** 17-04-2023 R22 Auto Conversion no changes
** 17-04-2023 Skanda R22 Manual Conversion - No changes
* ----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.SLA.PARAM


    GOSUB PROCESS
RETURN


********
PROCESS:
********


    AF = SLA.DESCRIPTION
    CALL DUP

    AF = SLA.DOC.REQUIRE
    CALL DUP

    AF = SLA.START.CHANNEL
    CALL DUP

RETURN
END
