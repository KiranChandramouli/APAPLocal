SUBROUTINE REDO.V.INP.DUM.ROU
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is used as input routine to make chage to the field COMMENTS.
*-------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 26-09-2011        S.MARIMUTHU     PACS00128531         Initial Creation
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AA.DISBURSE.METHOD

MAIN:

    Y.COMMENTS = R.NEW(DIS.MET.COMMENTS)
    IF Y.COMMENTS EQ '' THEN
        R.NEW(DIS.MET.COMMENTS) = 'PRINT'
    END ELSE
        R.NEW(DIS.MET.COMMENTS) = ''
    END

RETURN

END
