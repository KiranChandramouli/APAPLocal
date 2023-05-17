SUBROUTINE REDO.PURGE.MASSIVE.RATE.LOAD
*--------------------------------------------------------------
* Description : This routine is to delete the one month backdated log of
* F.REDO.MASSIVE.RATE.CHANGE. This is month end batch job
*--------------------------------------------------------------
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*14.07.2011  H GANESH      PACS00055012 - B.16 INITIAL CREATION
*----------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.PURGE.MASSIVE.RATE.COMMON

    GOSUB PROCESS
RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------

    FN.REDO.MASSIVE.RATE.CHANGE = 'F.REDO.MASSIVE.RATE.CHANGE'
    F.REDO.MASSIVE.RATE.CHANGE  = ''
    CALL OPF(FN.REDO.MASSIVE.RATE.CHANGE,F.REDO.MASSIVE.RATE.CHANGE)

RETURN
END
