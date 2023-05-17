*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CHK.REQUEST.QTY.LIMIT
*---------------------------------------
* Description : This validation routine is checks the request qty limit. If its exceeds 1000 then raise the error message.
*               The instruction of increasing cache size is given under the below pacs ticket.
* Issue Ref   : PACS00254644
*---------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.ORDER.DETAILS

  GOSUB PROCESS
  RETURN
*-----------------------------------------
PROCESS:
*---------

  Y.REQ.QTY = COMI

  IF Y.REQ.QTY GT '1000' THEN
    ETEXT = 'EB-REDO.CHECK.REQUEST.INVENTORY'
    CALL STORE.END.ERROR
  END
  RETURN
*-----------------
END
