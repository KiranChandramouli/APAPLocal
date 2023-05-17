*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE TAM.E.CONV.ST.DATE
*-------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : TAM.E.CONV.ST.DATE
*--------------------------------------------------------------------------------------------------------
*Description  : TAM.E.CONV.ST.DATE is the Conversion routine
*               This routine is used to get the START date of the month for which COB is run
*In Parameter : N/A
*Out Parameter : N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                              Reference               Description
* -----------    ----------------                 ----------------         ----------------
* 30 DEC 2010      SABARIKUMAR A                     ODR-2010-0181          Initial Creation
*---------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
  Y.DATE = TODAY
  Y.YEAR.DATE = TODAY[1,6]
  Y.FIRST.DATE = Y.YEAR.DATE:'01'
  O.DATA = Y.FIRST.DATE
  RETURN
END
