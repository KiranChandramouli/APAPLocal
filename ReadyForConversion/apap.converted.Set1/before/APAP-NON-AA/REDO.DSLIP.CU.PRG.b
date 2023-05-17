*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DSLIP.CU.PRG(DS.CRR1)
*------------------------------------------------------------------------------------------------------
* DESCRIPTION:
* Deal slip routine for displaying Customer Name
*------------------------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN     : -NA-
* OUT    : DS.CRR1
*------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.DSLIP.CU.PRG
* LINKED WITH  : TT.CHQ.PSLIP deal slip
* ----------------------------------------------------------------------------
* Modification History :
*-----------------------
*   DATE             WHO                  REFERENCE          DESCRIPTION
* 26.07.2010      NATCHIMUTHU.P         ODR-2010-01-0001     INITIAL CREATION
*----------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_F.TELLER
*
  FN.TELLER = 'F.TELLER'
  F.TELLER  = ''
  CALL OPF(FN.TELLER, F.TELLER)
*
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT, F.ACCOUNT)
*
  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER  = ''
  CALL OPF(FN.CUSTOMER, F.CUSTOMER)
*
  SEL.CMD.SESSION = "SELECT ":FN.TELLER:" WITH @ID EQ ":DS.CRR1
  CALL EB.READLIST(SEL.CMD.SESSION,Y.TELLER.ID,'',NO.OF.SESSION.REC,SEL.ERR.SESSION)
*
  CALL F.READ(FN.TELLER, Y.TELLER.ID, R.REC.TELLER, F.TELLER, Y.ERR.TELLER)
*
  Y.ACCOUNT   = R.REC.TELLER<TT.TE.ACCOUNT.2>
*
  CALL F.READ(FN.ACCOUNT, Y.ACCOUNT, R.REC.ACCOUNT, F.ACCOUNT, Y.ERR.ACCOUNT)
*
  Y.CUSTOMER = R.REC.ACCOUNT<AC.CUSTOMER>
*
  CALL F.READ(FN.CUSTOMER, Y.CUSTOMER, R.REC.CUSTOMER, F.CUSTOMER, Y.ERR.CUSTOMER)
*
  DS.CRR1 = R.REC.CUSTOMER<EB.CUS.NAME.1>
*
  RETURN
END
