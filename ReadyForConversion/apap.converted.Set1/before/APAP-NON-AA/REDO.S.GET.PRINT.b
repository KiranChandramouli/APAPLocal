*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.GET.PRINT
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SHANKAR RAJU
*Program   Name    :REDO.S.GET.PRINT
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to default the value for PRINT to 'Y'

* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

  VAR.DATA = O.DATA
  O.DATA = 'Y'

  RETURN
END
