*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DSLIP.CU.NUMBER(DS.CRR2)
*------------------------------------------------------------------------------------------------------
* DESCRIPTION:
* Deal slip routine for displaying Customer Number in TT.FXSN.SLIP Deal Slip
*------------------------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN     : DS.CRR2
* OUT    : DS.CRR2
*------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.DSF.FXSN
* LINKED WITH  : TT.FXSN.SLIP Deal slip
* ----------------------------------------------------------------------------
* Modification History :
*-----------------------
*   DATE             WHO                  REFERENCE          DESCRIPTION
* 27.05.2010      A C Rajkumar        ODR-2010-01-0213     INITIAL CREATION
*----------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.FOREX.SEQ.NUM
*
  FN.REDO.FOREX.SEQ.NUM = "F.REDO.FOREX.SEQ.NUM"
  F.REDO.FOREX.SEQ.NUM  = ""
  CALL OPF(FN.REDO.FOREX.SEQ.NUM, F.REDO.FOREX.SEQ.NUM)
*
  SEL.CMD.SESSION = "SELECT ":FN.REDO.FOREX.SEQ.NUM:" WITH FX.TXN.ID EQ ":DS.CRR2
  CALL EB.READLIST(SEL.CMD.SESSION,Y.FXSN.ID,'',NO.OF.SESSION.REC,SEL.ERR.SESSION)
*
  CALL F.READ(FN.REDO.FOREX.SEQ.NUM,Y.FXSN.ID, R.REC.REDO.FOREX.SEQ.NUM, F.REDO.FOREX.SEQ.NUM, Y.ERR.REDO.FOREX.SEQ.NUM)
*
  Y.CUSTOMER.NUMBER = R.REC.REDO.FOREX.SEQ.NUM<REDO.FXSN.CUSTOMER.NO>
*
  DS.CRR2 = Y.CUSTOMER.NUMBER
*
  RETURN
END
