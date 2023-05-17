*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.DATE.INT.FORM(Y.DATE)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.GET.DATE.INT.FORM
* ODR NUMBER    : ODR-2009-10-0795
*--------------------------------------------------------------------------------------------------
* Description   : This routine is used for Deal slip. Will return the date in specified format
* In parameter  :
* out parameter : Y.DATE
*--------------------------------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 14-01-2011      MARIMUTHU s     ODR-2009-10-0795  Initial Creation
*--------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE

  Y.DATE = TODAY
  Y.DATE = ICONV(Y.DATE,'D')
  Y.DATE = OCONV(Y.DATE,'D')

  RETURN

END
