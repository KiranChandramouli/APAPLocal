*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.SET.COMP
*---------------------------------------------------------------------------------
*This routine launch the version of CRM CLAIMS and sets the ID
*----------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : Prabhu N
* Program Name  :
* ODR NUMBER    :
* HD Reference  : HD1100441
*LINKED WITH:APAP.H.GARNISH.DETAILS AS version routine
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
*MODIFICATION DETAILS:
*
* 16-02-2011        Prabhu.N         HD1100441      Auto Launch of VERSION
*----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_System
$INSERT I_F.REDO.FRONT.COMPLAINTS
$INSERT I_REDO.SET.REQ.COMP.ID
  GOSUB PROCESS
  RETURN

PROCESS:

  FN.CUST.COMPLAINTS='F.REDO.CUSTOMER.COMPLAINTS'
  F.CUST.COMPLAINTS=''
  CALL OPF(FN.CUST.COMPLAINTS,F.CUST.COMPLAINTS)

  Y.VAR.ID=R.NEW(FR.CM.CUSTOMER.CODE)
  CALL F.READ(FN.CUST.COMPLAINTS,Y.VAR.ID,R.COMPLAINTS,F.CUST.COMPLAINTS,ERR)
  Y.VAR.CUS.NO=1
  IF R.COMPLAINTS THEN
    Y.VAR.CUS.NO=R.COMPLAINTS
  END
  R.COMPLAINTS+=1
  Y.VAR.CUS.SEQ=FMT(Y.VAR.CUS.NO,"R%7")
  Y.ID.FORM=Y.VAR.ID : '.' : Y.VAR.CUS.SEQ : '.' : ID.NEW
  Y.CUST.ID=R.NEW(FR.CM.CUSTOMER.CODE)
  Y.ACC.ID=R.NEW(FR.CM.ACCOUNT.ID)
  MATBUILD Y.CURRENT.REC FROM R.NEW,1,86
  CHANGE FM TO '*##' IN Y.CURRENT.REC
  CALL System.setVariable("CURRENT.REC",Y.CURRENT.REC)
  CALL F.WRITE(FN.CUST.COMPLAINTS,Y.VAR.ID,R.COMPLAINTS)
  CRM.CUR.TXN.ID=Y.ID.FORM
  RETURN
*--------------
END
