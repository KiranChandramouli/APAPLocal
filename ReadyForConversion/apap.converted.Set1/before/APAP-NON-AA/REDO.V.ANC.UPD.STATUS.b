*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.ANC.UPD.STATUS
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep S
* Program Name  : REDO.V.ANC.UPD.STATUS
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Description   : This ANC routine attached in notify version for Request to update the STATUS field
* In parameter  : None
* out parameter : None
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 21-May-2011      Pradeep S          PACS00060849      Initial Creation
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.ISSUE.REQUESTS

  GOSUB PROCESS

  RETURN
*-------
PROCESS:
*-------
  Y.CURR.STATUS = R.NEW(ISS.REQ.STATUS)
  Y.CURR.CLOSE.STATUS = R.NEW(ISS.REQ.CLOSING.STATUS)

  BEGIN CASE

  CASE Y.CURR.CLOSE.STATUS EQ 'ACCEPTED'
    R.NEW(ISS.REQ.STATUS) = 'RESOLUCION NOTIFICADA'

  CASE Y.CURR.CLOSE.STATUS EQ 'REJECTED'
    R.NEW(ISS.REQ.STATUS) = 'RECHAZADA NOTIFICADA'

  END CASE

  RETURN
END
