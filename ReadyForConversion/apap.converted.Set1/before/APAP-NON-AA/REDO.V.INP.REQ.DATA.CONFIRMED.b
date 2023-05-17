*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.REQ.DATA.CONFIRMED
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This Input routine is used to check if the CUSTOMER has
* any previous claims in the same PRODUCT & TYPE & TRANSACTIOn.AMOUNT. If the same claim exits
* then OVERRIDE is displayed
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RENUGADEVI B
* PROGRAM NAME : REDO.V.INP.REQ.DATA.CONFIRMED
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 25-AUG-2010       RENUGADEVI B       ODR-2009-12-0283  INITIAL CREATION
* 22-MAY-2011       PRADEEP S          PACS00060849      DATA.CONFIRMED check corrected
* ----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.ISSUE.REQUESTS
  GOSUB INIT
  GOSUB PROCESS
  RETURN
*****
INIT:
*****
  FN.REDO.ISSUE.REQUESTS  = 'F.REDO.ISSUE.REQUESTS'
  F.REDO.ISSUE.REQUESTS   = ''
  CALL OPF(FN.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS)
  RETURN


********
PROCESS:
********

*IF R.NEW(ISS.REQ.STATUS) = 'OPEN' THEN
  IF R.NEW(ISS.REQ.DATA.CONFIRMED) EQ 'NO' THEN
    AF   = ISS.REQ.DATA.CONFIRMED
    ETEXT ='EB-REDO.CUSTOMER.DATA.CONFIRMED'
    CALL STORE.END.ERROR
  END
*END

  RETURN
END
