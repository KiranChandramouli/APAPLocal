*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE TAM.E.PDF.DATA.CREDIT
*-----------------------------------------------------------------------------

*Company   Name    : APAP
*Developed By      : Temenos Application Management
*Program   Name    : TAM.E.PDF.DATA.CREDIT

*-----------------------------------------------------------------------------

*Description       : This routine is used pdf purpose
*In  Parameter     : N/A
*Out Parameter     : N/A
*ODR Number        :

*-----------------------------------------------------------------------------
*Modification History:
*-----------------------------------------------------------------------------
*    Initial Development for APAP ARC - IB
*-----------------------------------------------------------------------------
*Insert Files
*-----------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_ENQ.SES.VAR.CREDIT.COMMON

*-----------------------------------------------------------------------------

  IF PDF.CREDIT.DATA EQ '' THEN
    PDF.CREDIT.DATA = O.DATA
  END ELSE
    PDF.CREDIT.DATA := O.DATA
  END
  O.DATA = PDF.CREDIT.DATA
  RETURN
END
