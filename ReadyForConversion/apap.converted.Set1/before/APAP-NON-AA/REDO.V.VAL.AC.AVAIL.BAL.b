*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.AC.AVAIL.BAL
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.AC.AVAIL.BAL
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is the input routine to validate the garnishment amount of the debit account
*
*
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 07-JUN-2011        Prabhu.N       PACS000701064       Routine modified
* 12-JUL-2011        Prabhu.N       PACS000701064       Routine modified-override modification
* 02-SEP-2011        Marimuthu S    PACS000112741
* 09-SEP-2011        Marimuthu S    PACS00121111        Override Blocking
* 15-FEB-2012        Marimuthu S    PACS00249331
*-------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.AC.LOCKED.EVENTS
$INSERT I_F.ACCOUNT
$INSERT I_F.TELLER
$INSERT I_System



  GOSUB INIT
  RETURN
*---
INIT:
*---

  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
  F.CUSTOMER.ACCOUNT=''
  CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

  LREF.APP = 'ACCOUNT'
  LREF.FIELDS = 'L.AC.AV.BAL'
  LREF.POS=''
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)

  L.AC.LOCK.POS=LREF.POS<1,1>


  IF APPLICATION EQ 'FUNDS.TRANSFER' THEN

    CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),VM)
    Y.DEBIT.AMOUNT= R.NEW(FT.DEBIT.AMOUNT)
    Y.VAR.ACC.NO=R.NEW(FT.DEBIT.ACCT.NO)

    IF NUM(Y.VAR.ACC.NO[1,3]) ELSE
      RETURN
    END


    CALL F.READ(FN.ACCOUNT,Y.VAR.ACC.NO,R.ACCOUNT,F.ACCOUNT,ERR)

    Y.AC.AVAIL.BAL=R.ACCOUNT<AC.LOCAL.REF,LREF.POS>
    Y.NOSTRO=R.ACCOUNT<AC.LIMIT.REF>
**PACS000112741 - S
    IF NOT(R.ACCOUNT<AC.ARRANGEMENT.ID>) AND Y.NOSTRO NE 'NOSTRO' AND PGM.VERSION NE ',REDO.MULTI.REPAY.CHQ.DISB' PGM.VERSION NE ',REDO.MULTI.AA.ACPOAP.DISB' AND PGM.VERSION NE ',REDO.MULTI.AA.ACCRAP.DISB' AND PGM.VERSION NE ',REDO.MULTI.AA.ACRP.DISB' AND PGM.VERSION NE ', REDO.AA.OTI' AND PGM.VERSION NE 'REDO.AA.ACDP' AND PGM.VERSION NE ',REDO.AA.CASH' AND PGM.VERSION NE ',CHQ.OTHERS.LOAN' AND PGM.VERSION NE ',REDO.AA.LTC' AND PGM.VERSION NE ',CHQ.OTHERS.LOAN.DUM' AND PGM.VERSION NE ',REDO.TRF.ONE' AND PGM.VERSION NE ',REDO.TRF.TWO' THEN
      IF  Y.AC.AVAIL.BAL LT '0' THEN
*PACS00071064.1-S
        TEXT='AMT.LIM.EXCEED':FM:Y.VAR.ACC.NO
*PACS00071064.1-E
        CALL STORE.OVERRIDE(CURR.NO+1)
      END
    END
**PACS000112741 -E
  END

  IF APPLICATION EQ 'TELLER' AND R.NEW(TT.TE.TRANSACTION.CODE) NE 80 THEN
    CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),VM)
    Y.MARKER=R.NEW(TT.TE.DR.CR.MARKER)
    IF Y.MARKER EQ 'CREDIT' THEN
      Y.VAR.ACC.NO=R.NEW(TT.TE.ACCOUNT.2)
    END
    ELSE
      Y.VAR.ACC.NO=R.NEW(TT.TE.ACCOUNT.1)
    END
    CALL F.READ(FN.ACCOUNT,Y.VAR.ACC.NO,R.ACCOUNT,F.ACCOUNT,ERR)
    Y.AC.AVAIL.BAL=R.ACCOUNT<AC.LOCAL.REF,LREF.POS>
    Y.CUSTOMER=R.ACCOUNT<AC.CUSTOMER>
    Y.NOSTRO=R.ACCOUNT<AC.LIMIT.REF>
    IF Y.AC.AVAIL.BAL LT '0' AND Y.CUSTOMER NE '' AND Y.NOSTRO NE 'NOSTRO' THEN
      TEXT='AMT.LIM.EXCEED'
      CALL STORE.OVERRIDE(CURR.NO+1)
    END
  END
  RETURN
END
*---------------------------------------------*END OF SUBROUTINE*-------------------------------------------
