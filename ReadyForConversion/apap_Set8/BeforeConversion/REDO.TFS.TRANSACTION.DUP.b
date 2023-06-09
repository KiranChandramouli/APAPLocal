  SUBROUTINE REDO.TFS.TRANSACTION.DUP
*--------------------------------------------------
* Description: This is the Validation routine for the TFS to avoid the duplicate
*               of TRANSACTION.
*--------------------------------------------------
* Date          Who              Reference                      Comments
* 14 Apr 2013  H Ganesh         PACS00255601 - TFS ISSUE       Initial Draft
*--------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.T24.FUND.SERVICES

  GOSUB PROCESS

  RETURN
*--------------------------------------------------
PROCESS:
*--------------------------------------------------


  IF FIELD(OFS$HOT.FIELD,'.',1) EQ 'TRANSACTION' THEN
    R.NEW(TFS.WAIVE.CHARGE)<1,AV> = 'NO'
  END

  LOCATE COMI IN R.NEW(TFS.TRANSACTION)<1,1> SETTING POS THEN
    IF POS NE AV THEN
      ETEXT = 'SC-DUPLICATES.NOT.ALLOW'
      CALL STORE.END.ERROR
    END

  END


  RETURN
END
