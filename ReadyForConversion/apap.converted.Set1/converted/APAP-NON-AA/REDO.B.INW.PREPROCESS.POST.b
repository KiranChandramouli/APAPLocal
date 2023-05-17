SUBROUTINE REDO.B.INW.PREPROCESS.POST
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : ganesh r
* PROGRAM NAME : REDO.B.INW.PREPROCESS.POST
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 21.09.2010  ganesh r           ODR-2010-09-0148   INITIAL CREATION
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.INW.PREPROCESS.COMMON
*------------------------------------------------------------------------------------------

    GOSUB PROCESS
RETURN

PROCESS:
*------------------------------------------------------------------------------------------

    IF Y.POST.ID THEN
        DAEMON.CMD = "DELETE ":VAR.FILE.PATH:" *"
        EXECUTE DAEMON.CMD
    END
RETURN

END
