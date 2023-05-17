*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AUTH.CHECK.LIMIT

***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RIYAS
* PROGRAM NAME: REDO.AUTH.CHECK.LIMIT
* ODR NO      : ODR-2010-09-0148
*-----------------------------------------------------------------------------
*DESCRIPTION: This is AUTH routine for REDO.CLEARING.INWARD,APPROVE to clear reason

*IN PARAMETER :  NA
*OUT PARAMETER: NA
*LINKED WITH  : REDO.CLEARING.INWARD,APPROVE
*----------------------------------------------------------------------
* Modification History :
* DATE             WHO               REFERENCE           DESCRIPTION
* 27-04-2012       RIYAS           PACS00131732          sub process
*----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.APAP.CLEARING.INWARD
  IF V$FUNCTION EQ 'A' THEN
    GOSUB PROCESS
  END
  RETURN
*----------------------------------------------------------------------
********
PROCESS:
********

  Y.STATUS.PAID = R.NEW(CLEAR.CHQ.STATUS)
  IF Y.STATUS.PAID EQ 'PAID' THEN
    R.NEW(CLEAR.CHQ.REASON) = ''
  END

  RETURN
END
