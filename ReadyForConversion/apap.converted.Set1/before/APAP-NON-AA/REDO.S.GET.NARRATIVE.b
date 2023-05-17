*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.GET.NARRATIVE
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.GET.NARRATIVE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the Bank name
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

  VAR.DATA = O.DATA
  O.DATA = 'DEVUELTO'

  RETURN
END
