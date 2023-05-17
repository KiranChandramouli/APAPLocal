*-----------------------------------------------------------------------------
* <Rating>-44</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.FT.LOAN.STATUS.COND
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Sakthi Sellappillai
*Program   Name    :REDO.V.INP.FT.LOAN.STATUS.COND
*Developed for     :ODR-2010-08-0031
*---------------------------------------------------------------------------------
*DESCRIPTION: This is the internal call routine which updates the value of the local reference fields
* L.LOAN.STATUS.1 & L.LOAN.COND in FUNDS.TRANSFER application
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
* Dependencies:
*---------------
* CALLS     : REDO.CRR.GET.CONDITIONS
* CALLED BY : -NA-
* Revision History:
*------------------
*   Date               who                       Reference                Description
*===========          =============              ================         ==================
* 11-10-2010         Sakthi Sellappillai        ODR-2010-08-0031         Initial Creation
* 28-APR-2011      H GANESH           CR009              Change the Vetting value of local field
*---------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.OVERDUE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_GTS.COMMON
$INSERT I_EB.TRANS.COMMON



  IF OFS$OPERATION EQ 'VALIDATE' THEN
    RETURN
  END
*Return in Commit stage
  IF cTxn_CommitRequests EQ '1' THEN
    RETURN
  END



  IF MESSAGE EQ 'VAL' THEN
    RETURN
  END

  GOSUB GET.LRF.POS
  GOSUB PROCESS
  RETURN

*-----------
GET.LRF.POS:
*-----------
*----------------------------------------------------------------------
* This section gets the position of the local reference field positions
*----------------------------------------------------------------------

  LR.APP = 'AA.PRD.DES.OVERDUE':FM:'FUNDS.TRANSFER'
  LR.FLDS = 'L.LOAN.STATUS.1':VM:'L.LOAN.COND':FM
  LR.FLDS := 'L.LOAN.STATUS.1':VM:'L.LOAN.COND'
  LR.POS = ''
  CALL MULTI.GET.LOC.REF(LR.APP,LR.FLDS,LR.POS)

  OD.LOAN.STATUS.POS = LR.POS<1,1>
  OD.LOAN.COND.POS =  LR.POS<1,2>
  FT.LOAN.STATUS.POS = LR.POS<2,1>
  FT.LOAN.COND.POS =  LR.POS<2,2>

  RETURN

*-------
PROCESS:
*-------
*------------------------------------------------------------------------------------------------------------------------------------
* This section gets the latest overdue record for the arrangement id and stores the value of loan status and condition in R.NEW of FT
*------------------------------------------------------------------------------------------------------------------------------------

  ARR.ID =  ECOMI
  PROP.CLASS = 'OVERDUE'
  PROPERTY = ''
  R.Condition = ''
  ERR.MSG = ''
  EFF.DATE = ''
  CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
  LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
  LOAN.COND = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>
  CHANGE SM TO VM IN LOAN.STATUS
  CHANGE SM TO VM IN LOAN.COND
  R.NEW(FT.LOCAL.REF)<1,FT.LOAN.STATUS.POS> = LOAN.STATUS
  R.NEW(FT.LOCAL.REF)<1,FT.LOAN.COND.POS> = LOAN.COND
*    IF ('JudicialCollection' MATCHES LOAN.STATUS) OR ('Write-off' MATCHES LOAN.STATUS) OR ('Legal' MATCHES LOAN.COND) THEN
  IF LOAN.STATUS THEN
    DISP.STATUS = LOAN.STATUS
    IF LOAN.COND THEN
      DISP.STATUS : = VM:LOAN.COND
    END
    CHANGE VM TO ' ' IN DISP.STATUS
    AF = FT.CREDIT.ACCT.NO
    AV = 1
    AS = 1
    ETEXT = 'EB-STATUS.COND':FM:DISP.STATUS
    CALL STORE.END.ERROR
  END
  RETURN
END
