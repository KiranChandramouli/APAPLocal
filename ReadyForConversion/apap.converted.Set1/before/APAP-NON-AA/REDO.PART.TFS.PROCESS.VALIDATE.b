*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.PART.TFS.PROCESS.VALIDATE
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.PART.TFS.PROCESS table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.PART.TFS.PROCESS.VALIDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*29.06.2010      SUDHARSANAN S     ODR-2010-08-0017 INITIAL CREATION
* -----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.PART.TFS.PROCESS
$INSERT I_GTS.COMMON
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.TFS.TRANSACTION

  GOSUB INIT
  GOSUB PROCESS
  RETURN

*---
INIT:
*---

  FN.TFS.TRANSACTION = 'F.TFS.TRANSACTION'
  F.TFS.TRANSACTION = ''
  CALL OPF(FN.TFS.TRANSACTION,F.TFS.TRANSACTION)

  VAR.TRAN.TYPE = ''

  RETURN
*-------
PROCESS:
*-------
*Checking valid curreny for arrangement account
  VAR.TRAN.TYPE = R.NEW(PAY.PART.TFS.TRAN.TYPE)
  Y.CNT = DCOUNT(VAR.TRAN.TYPE,VM)
  FOR Y.COUNT=1 TO Y.CNT
    Y.TXN = R.NEW(PAY.PART.TFS.TRAN.TYPE)<1,Y.COUNT>
    CALL F.READ(FN.TFS.TRANSACTION,Y.TXN,R.TFS.TRAN,F.TFS.TRANSACTION,TFS.TRAN.ERR)
    Y.SURR.ACC = R.TFS.TRAN<TFS.TXN.SURROGATE.AC>
    IF Y.SURR.ACC EQ '' THEN
      Y.ACCT.NO = R.NEW(PAY.PART.TFS.ACCOUNT.NUMBER)<1,Y.COUNT>
      IF Y.ACCT.NO NE '' THEN
        AF = PAY.PART.TFS.ACCOUNT.NUMBER
        AV = Y.COUNT
        ETEXT = 'EB-INPUT.NOT.ALLOW'
        CALL STORE.END.ERROR
      END
    END
  NEXT Y.COUNT
  RETURN
*------------------------------------------------------------------------------------
END
