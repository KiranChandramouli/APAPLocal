*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.COMP.DATA.CONFIRMED
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
* PROGRAM NAME : REDO.V.INP.COMP.DATA.CONFIRMED
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 25-AUG-2010       RENUGADEVI B       ODR-2009-12-0283  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.ISSUE.COMPLAINTS
  GOSUB INIT
  GOSUB PROCESS
  RETURN
*****
INIT:
*****
  FN.REDO.ISSUE.COMPLAINTS  = 'F.REDO.ISSUE.COMPLAINTS'
  F.REDO.ISSUE.COMPLAINTS   = ''
  CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)
  RETURN

********
PROCESS:
********

  IF R.NEW(ISS.COMP.STATUS) EQ 'OPEN' THEN
    IF R.NEW(ISS.COMP.DATA.CONFIRMED) EQ '' THEN
      AF   = ISS.COMP.DATA.CONFIRMED
      ETEXT ='EB-REDO.CUSTOMER.DATA.CONFIRMED'
      CALL STORE.END.ERROR
    END
  END

  RETURN
END
