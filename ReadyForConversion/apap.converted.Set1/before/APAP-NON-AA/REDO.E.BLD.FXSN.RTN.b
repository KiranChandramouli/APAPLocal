*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BLD.FXSN.RTN(ENQ.DATA)
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This is a BUILD routine for the NOFILE ENQUIRY REDO.ENQ.FXSN.DETAILS, to select all sequence number IDs from REDO.FOREX.SEQ.NUM table
*               incase if not provided with a selection criteria
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* In Parameter    : ENQ.DATA
* Out Parameter   : ENQ.DATA
*-----------------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Chandra Prakash T
* Program Name : REDO.E.BLD.FXSN.RTN
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Who                   Reference         Description
* 11-Jun-2010      Chandra Prakash T     ODR-2010-01-0213  Initial Creation
*-----------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

  ENQ.VALUES = ENQ.DATA<3>

  LOCATE "SEQUENCE.NUMBER" IN ENQ.DATA<2> SETTING SEQ.NUM.POS ELSE

    ENQ.DATA<2,-1> = "SEQUENCE.NUMBER"
    ENQ.DATA<3,-1> = 'NE'
    ENQ.DATA<4,-1> = ''
    D.RANGE.AND.VALUE<1> = ''
  END

  RETURN

END
