SUBROUTINE REDO.V.ANC.CLAIM.UPD.STATUS
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep S
* Program Name  : REDO.V.ANC.CLAIM.UPD.STATUS
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Description   : This ANC routine attached in notify version for Request to update the STATUS field
* In parameter  : None
* out parameter : None
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 21-May-2011      Pradeep S          PACS00071941      Initial Creation
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.CLAIMS

    GOSUB PROCESS

RETURN
*-------
PROCESS:
*-------
    Y.CURR.STATUS = R.NEW(ISS.CL.STATUS)
    Y.CURR.CLOSE.STATUS = R.NEW(ISS.CL.CLOSING.STATUS)

    BEGIN CASE

        CASE Y.CURR.CLOSE.STATUS EQ 'ACCEPTED'
            R.NEW(ISS.CL.STATUS) = 'RESOLUCION NOTIFICADA'

        CASE Y.CURR.CLOSE.STATUS EQ 'REJECTED'
            R.NEW(ISS.CL.STATUS) = 'RECHAZADA NOTIFICADA'

    END CASE

RETURN
END
