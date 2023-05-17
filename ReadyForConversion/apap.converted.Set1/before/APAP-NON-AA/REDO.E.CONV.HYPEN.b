*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CONV.HYPEN

*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Madhupriya
*Program   Name    :REDO.E.CONV.HYPEN
*Reference Number  : ODR-2009-12-0283
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is to remove the hypen in the customer name
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ENQUIRY

  Y.VAL = ''
  Y.VAL = O.DATA

  CHANGE '-' TO " " IN Y.VAL

  O.DATA = Y.VAL

  RETURN
END
