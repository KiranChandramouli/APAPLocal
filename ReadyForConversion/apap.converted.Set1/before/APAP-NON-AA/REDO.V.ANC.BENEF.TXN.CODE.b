*--------------------------------------------------------------------------------------------------------
* <Rating>-40</Rating>
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.V.ANC.BENEF.TXN.CODE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.ANC.BENEF.TXN.CODE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a validation routine to check and default the Credit account number
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.BENEFICIARY

*--------------------------------------------------------------------------------------------------------
  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN
*--------------------------------------------------------------------------------------------------------
OPEN.FILES:
************
  FN.BENEFICIARY = 'F.BENEFICIARY'
  F.BENEFICIARY = ''
  CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)

  LOC.REF.APPLICATION="BENEFICIARY"
  LOC.REF.FIELDS='L.BEN.PROD.TYPE'
  LOC.REF.POS=''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  POS.L.BEN.PROD.TYPE = LOC.REF.POS<1,1>
  RETURN
*------------------------------------------------------------------------------------------------------------
PROCESS:
*********
  Y.PROD.TYPE = COMI

  IF PGM.VERSION EQ ',AI.REDO.ADD.OTHER.BANK.BEN' OR PGM.VERSION EQ ',AI.REDO.ADD.OTHER.BANK.BEN.CONFIRM' THEN
    GOSUB OTHER.BNK.BENIFICIARY
  END
  IF PGM.VERSION EQ ',AI.REDO.ADD.OWN.BANK.BEN' OR PGM.VERSION EQ ',AI.REDO.ADD.OWN.BANK.BEN.CONFIRM' THEN
    GOSUB OWN.BNK.BENIFICIARY
  END
  RETURN
*******************
OWN.BNK.BENIFICIARY:
*******************
  IF Y.PROD.TYPE EQ 'LOAN' THEN
    R.NEW(ARC.BEN.TRANSACTION.TYPE) = 'ACIT'
  END ELSE
    IF Y.PROD.TYPE EQ 'CARDS' THEN
      R.NEW(ARC.BEN.TRANSACTION.TYPE) = 'AC09'
    END
    ELSE
      R.NEW(ARC.BEN.TRANSACTION.TYPE) = 'AC14'
    END
  END
  RETURN
**********************
OTHER.BNK.BENIFICIARY:
**********************

  IF Y.PROD.TYPE EQ 'LOAN' THEN
    R.NEW(ARC.BEN.TRANSACTION.TYPE) = 'AC08'
  END ELSE
    IF Y.PROD.TYPE EQ 'CARDS' THEN
      R.NEW(ARC.BEN.TRANSACTION.TYPE) = 'AC28'
    END
    ELSE
      R.NEW(ARC.BEN.TRANSACTION.TYPE) = 'AC25'
    END
  END
  RETURN
*------------------------------------------------------------------------------------------------------------
END
