*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.CLEAR.RETURN.POST
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
* PROGRAM NAME : REDO.B.CLEAR.RETURN.POST
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 21.09.2010  ganesh r           ODR-2010-09-0251   INITIAL CREATION
*------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.CLEAR.RETURN.COMMON
*------------------------------------------------------------------------------------------
  GOSUB PROCESS
  RETURN

PROCESS:
*------------------------------------------------------------------------------------------
*below 3 lines commented to improve performance
*    IF INT.CODE THEN
*        CALL REDO.INTERFACE.ACT.POST(INT.CODE)
*    END
  SEL.CMD = "SELECT ":VAR.FILE.PATH
  CALL EB.READLIST(SEL.CMD,FILE.LIST,'',NO.OF.REC,RET.ERR)

  LOOP
    REMOVE VAR.APERTA.ID FROM FILE.LIST SETTING FILE.POS
  WHILE VAR.APERTA.ID:FILE.POS

    DAEMON.CMD = "DELETE ":VAR.FILE.PATH:" ":VAR.APERTA.ID
    EXECUTE DAEMON.CMD

  REPEAT
  RETURN

END
