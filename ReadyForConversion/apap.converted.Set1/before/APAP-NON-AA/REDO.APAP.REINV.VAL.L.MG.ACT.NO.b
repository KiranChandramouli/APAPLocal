*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.REINV.VAL.L.MG.ACT.NO
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.REINV.VAL.L.MG.ACT.NO
*------------------------------------------------------------------------------
*Description  : REDO.APAP.REINV.VAL.L.MG.ACT.NO is a validation routine for the
*               version REDO.H.AZ.REINV.DEPOSIT, CPH which restricts the user
*               from entering values into field mortgage account no if the
*               category code is not of CPH. Also alerts the user to link loan
*               if CPH category is used and no loan is linked
*Linked With  : REDO.H.AZ.REINV.DEPOSIT,CPH
*In Parameter : N/A
*Out Parameter: N/A
*Linked File  : I_F.REDO.APAP.CPH.PARAMETER,I_F. REDO.H.AZ.REINV.DEPOSIT
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 03-08-2010       JEEVA T             ODR-2009-10-0346        Initial Creation
*--------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.APAP.CPH.PARAMETER
$INSERT I_F.REDO.H.AZ.REINV.DEPOSIT
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
  FN.REDO.APAP.CPH.PARAMETER='F.REDO.APAP.CPH.PARAMETER'
  F.REDO.APAP.CPH.PARAMETER= ''
  CALL OPF(FN.REDO.APAP.CPH.PARAMETER,F.REDO.APAP.CPH.PARAMETER)
  RETURN
*-------------------------------------------------------------------------
**********
PROCESS.PARA:
**********

  Y.MG.ACT.NOS=COMI
  GOSUB READ.CPH.PARAMETER
  Y.DEP.CAT =R.NEW(REDO.AZ.REINV.PRODUCT.CODE)
  GOSUB VAL.CATEGORY.AND.LOAN
  RETURN
*--------------------------------------------------------------------------------
**********
READ.CPH.PARAMETER:
**********
  CALL CACHE.READ(FN.REDO.APAP.CPH.PARAMETER,'SYSTEM',R.REDO.APAP.CPH.PARAMETER,REDO.APAP.CPH.PARAMETER.ERR)
  Y.CPH.CATS=R.REDO.APAP.CPH.PARAMETER<CPH.PARAM.CPH.CATEGORY>
  RETURN
*---------------------------------------------------------------------------------------------------------------------------------
**********
VAL.CATEGORY.AND.LOAN:
**********

  CHANGE VM TO FM IN Y.CPH.CATS
  LOCATE Y.DEP.CAT IN Y.CPH.CATS SETTING Y.DEP.CAT.POS THEN
    IF  NOT(Y.MG.ACT.NOS) THEN
      ETEXT = 'EB-REDO.NO.LOAN.LINKED'
      CALL STORE.END.ERROR
      RETURN
    END
  END ELSE
    IF Y.MG.ACT.NOS THEN
      ETEXT = 'EB-REDO.NOT.CPH.CAT'
      CALL STORE.END.ERROR
      RETURN
    END
  END
  CALL REDO.APAP.REINV.VAL.FHA.DETS
  RETURN
*---------------------------------------------------------------------------------------------------------------------------------
END
