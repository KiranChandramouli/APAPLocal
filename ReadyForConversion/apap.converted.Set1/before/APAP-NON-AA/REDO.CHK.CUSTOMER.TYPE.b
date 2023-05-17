*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CHK.CUSTOMER.TYPE
*--------------------------------------------------------------------------------------------------------------------------------
* DESCRIPTION :
*
* Note    : Passport number number validation will not be done against Padrones interface, user manually checks for non apap customers
*--------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Shankar Raju
* PROGRAM NAME : REDO.CHK.CUSTOMER.TYPE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------------------------------
* Date             Author             Reference         Description
*
* 11-10-2011      Shankar Raju       PACS00142987  Making CUSTOMER.NAME field as non-inputable field
*                                                  to achieve the if Client is Non-APAP & using Passport, CUSTOMER.NAME
*                                                  need to be an inputtable field.
*-----------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.ID.CARD.CHECK

  GOSUB MAKE.NO.INPUT

  RETURN
*---------------------------------------------------------------------------------------------------------------------------------------------------
MAKE.NO.INPUT:
*-------------

  T(REDO.CUS.PRF.CUSTOMER.NAME)<3> = 'NOINPUT'
  T(REDO.CUS.PRF.PASSPORT.COUNTRY)<3> = 'NOINPUT'
  RETURN
*---------------------------------------------------------------------------------------------------------------------------------------------------
END
