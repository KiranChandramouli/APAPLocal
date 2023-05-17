SUBROUTINE REDO.CLAIM.STATUS.MAP.VALIDATE
*------------------------------------------------------------------------------
*------------------------------------------------------------------------------
* DESCRIPTION : This routine is used to check the duplicate values for the table
* REDO.CLAIM.STATUS.MAP
*------------------------------------------------------------------------------
*------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Pradeep S
* PROGRAM NAME : REDO.CLAIM.STATUS.MAP.VALIDATE
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE           DESCRIPTION
* 06-AUG-2010      Pradeep S         PACS00060849         INITIAL CREATION
* ----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CLAIM.STATUS.MAP


    GOSUB PROCESS
RETURN


********
PROCESS:
********


    AF = CR.ST.CLOSED.STATUS
    CALL DUP

RETURN
END
