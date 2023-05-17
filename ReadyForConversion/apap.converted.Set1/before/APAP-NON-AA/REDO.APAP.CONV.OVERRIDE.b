*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.CONV.OVERRIDE

* Description: This routine is the nofile enquiry routine to fetch the details of
* account closure records in INAO status

*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 26-02-2011      H GANESH      PACS00034162    Initial Draft
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.TELLER.ID

  GOSUB PROCESS
  RETURN

* ----------------------------------------------------------------------------
PROCESS:
* ----------------------------------------------------------------------------
  TEMP.REC = R.RECORD
  TEMP.OVERRIDE = R.RECORD<TT.TID.OVERRIDE>
  CHANGE SM TO '*' IN TEMP.OVERRIDE
  R.RECORD<TT.TID.OVERRIDE> = TEMP.OVERRIDE
  RETURN
END
