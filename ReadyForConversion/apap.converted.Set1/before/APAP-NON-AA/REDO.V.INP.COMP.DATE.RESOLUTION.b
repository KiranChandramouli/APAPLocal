*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.COMP.DATE.RESOLUTION
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION :A Validation routine is written to update the DATE.OF.RESOLUTION from the
*local parameter table REDO.SLA.PARAM
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : PRADEEP S
* PROGRAM NAME : REDO.V.INP.COMP.DATE.RESOLUTION
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 12.05.2011       Pradeep S          PACS00060849      INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.REDO.ISSUE.COMPLAINTS
$INSERT I_F.REDO.SLA.PARAM

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*------------------------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------------------------
  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER  = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.REDO.SLA.PARAM = 'F.REDO.SLA.PARAM'
  F.REDO.SLA.PARAM = ''
  CALL OPF(FN.REDO.SLA.PARAM,F.REDO.SLA.PARAM)

  FN.REDO.ISSUE.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'
  F.REDO.ISSUE.COMPLAINTS  = ''
  CALL OPF(FN.REDO.ISSUE.COMPLAINTS, F.REDO.ISSUE.COMPLAINTST)

  R.REDO.SLA.PARAM = ''
  FLAG = ''

  RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------------
  Y.TODAY = TODAY
  Y.TYPE = R.NEW(ISS.COMP.TYPE)
  Y.OPEN.DATE = R.NEW(ISS.COMP.OPENING.DATE)

  CALL F.READ(FN.REDO.SLA.PARAM,Y.TYPE,R.REDO.SLA.PARAM,F.REDO.SLA.PARAM,SLA.ERR)
  IF R.REDO.SLA.PARAM THEN
    Y.DAYS.RESOL = R.REDO.SLA.PARAM<SLA.SEG.DAYS>
    GOSUB UPDATE.DATE.RES
    GOSUB UPDATE.SER.AGR.COMP
    R.NEW(ISS.COMP.SUPPORT.GROUP) = R.REDO.SLA.PARAM<SLA.SUPPORT.GROUP>
  END
  RETURN

*---------------
UPDATE.DATE.RES:
*---------------

  DATE.TODAY = TODAY
  IF NOT(R.NEW(ISS.COMP.DATE.RESOLUTION)) THEN
    DAYS.RESOL = '+':Y.DAYS.RESOL:'C'
    CALL CDT('',DATE.TODAY,DAYS.RESOL)
    R.NEW(ISS.COMP.DATE.RESOLUTION) = DATE.TODAY
  END

  RETURN
*-------------------
UPDATE.SER.AGR.COMP:
*-------------------
  IF Y.OPEN.DATE NE '' AND Y.TODAY NE '' THEN
    NO.OF.DAYS = 'C'
    CALL CDD('',Y.OPEN.DATE,Y.TODAY,NO.OF.DAYS)
    NO.OF.DAYS = ABS(NO.OF.DAYS)
  END

  IF NO.OF.DAYS GT Y.DAYS.RESOL THEN
    R.NEW(ISS.COMP.SER.AGR.COMP) = "EXPIRED"
  END ELSE
    R.NEW(ISS.COMP.SER.AGR.COMP) = "ONTIME"
  END

  RETURN
*-------------------------------------------------------------------------------------------
END
