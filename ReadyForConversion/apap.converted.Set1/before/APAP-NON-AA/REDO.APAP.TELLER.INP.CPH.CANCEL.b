*-----------------------------------------------------------------------------
* <Rating>-80</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.TELLER.INP.CPH.CANCEL
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.TELLER.INP.CPH.CANCEL
*------------------------------------------------------------------------------

*Description  : REDO.APAP.TELLER.INP.CPH.CANCEL is an input routine for the
*               version TELLER,CLOSE.CPH which updates table
*               REDO.APAP.MORTGAGE.DETAILS



*Linked With  : TELLER,CLOSE.CPH
*In Parameter : N/A
*Out Parameter: N/A
*Linked File  : REDO.APAP.MORTGAGES.DETAIL

*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 12-08-2010       JEEVA T            ODR-2009-10-0346         Initial Creation
*--------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.TELLER
$INSERT I_F.REDO.APAP.CPH.DETAIL
$INSERT I_F.REDO.APAP.MORTGAGES.DETAIL
*--------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA
  RETURN

*--------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
  FN.REDO.APAP.MORTGAGES.DETAIL='F.REDO.APAP.MORTGAGES.DETAIL'
  F.REDO.APAP.MORTGAGES.DETAIL =''
  CALL OPF(FN.REDO.APAP.MORTGAGES.DETAIL,F.REDO.APAP.MORTGAGES.DETAIL)

  FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
  F.AZ.ACCOUNT=''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  RETURN
*--------------------------------------------------------------------------------
**********
PROCESS.PARA:
**********
  Y.DEP.NO=R.NEW(TT.TE.ACCOUNT.2)
  CALL F.READ(FN.AZ.ACCOUNT,Y.DEP.NO,R.AZ.ACCOUNT,F.AZ.ACCOUNT,Y.AZ.ACCOUNT.ERR)
  GOSUB FIND.MULTI.LOCAL.REF

  Y.MG.ACT.NO=R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.MG.ACT.NO.POS>
  Y.ACT.COUNT =DCOUNT(Y.MG.ACT.NO,SM)
  Y.COUNT=1
  LOOP
  WHILE Y.COUNT LE Y.ACT.COUNT
    Y.MG.DET.ID=FIELD(Y.MG.ACT.NO,SM,Y.COUNT,1)
    GOSUB READ.MORTGAGES.DET
    GOSUB WRITE.MORTGAGES.DET
    Y.COUNT++
  REPEAT

  RETURN
*--------------------------------------------------------------------------------
**********
READ.MORTGAGES.DET:
**********
  CALL F.READ(FN.REDO.APAP.MORTGAGES.DETAIL,Y.MG.DET.ID,R.REDO.APAP.MORTGAGES.DETAIL,F.REDO.APAP.MORTGAGES.DETAIL,Y.REDO.APAP.MORTGAGES.DETAIL.ERR)
  GOSUB ASSIGN.VALUES
  RETURN
*--------------------------------------------------------------------------------
**********
ASSIGN.VALUES:
**********
  R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.DEP.ACT.NO>=''
  R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.DEP.ACT.NAME>=''
  R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.START.DATE>=''
  R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.END.DATE>=''
  R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.MATURITY.AMT>=''
  GOSUB UPD.LIEN.AMT.AND.BAL.PRIN
  RETURN
*--------------------------------------------------------------------------------
**********
UPD.LIEN.AMT.AND.BAL.PRIN:
**********
  R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.LIEN.AMT>='0.00'
  Y.BAL.PRINC= R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.OUTS.PRINCIPLE>
  R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.BAL.PRINCIPAL>=Y.BAL.PRINC
  RETURN
*--------------------------------------------------------------------------------
**********
WRITE.MORTGAGES.DET:
**********
  CALL F.WRITE(FN.REDO.APAP.MORTGAGES.DETAIL,Y.MG.DET.ID,R.REDO.APAP.MORTGAGES.DETAIL)
  RETURN
*--------------------------------------------------------------------------------
**********
FIND.MULTI.LOCAL.REF:
**********
  APPL.ARRAY ='AZ.ACCOUNT'
  FLD.ARRAY ='L.MG.ACT.NO'
  FLD.POS =''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
  LOC.L.MG.ACT.NO.POS= FLD.POS<1,1>
  RETURN
*-------------------------------------------------------------------------
END
