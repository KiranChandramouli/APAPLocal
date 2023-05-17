*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.CR.DEF.CLEARING.AC
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.CR.DEF.CLEARING.AC
*--------------------------------------------------------------------------------------------------------
*Description  :
*
*Linked With  : Check Record routine for FT to default Account from REDO.APAP.CLEAR.PARAM
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  25-07-2013     Deepak Kumar K        PACS00309192              Default the CAT.ACH.ACCOT in the field
*                                                                 CREDIT.ACCT.NO of FT.
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.APAP.CLEAR.PARAM
$INSERT I_F.FUNDS.TRANSFER

  FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
  F.REDO.APAP.CLEAR.PARAM = ''
  CALL OPF(FN.REDO.APAP.CLEAR.PARAM, F.REDO.APAP.CLEAR.PARAM)

  Y.PARAM.ID = 'SYSTEM'
  R.CLEAR.PARAM = ''
  Y.READ.ERR = ''
  CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM, Y.PARAM.ID, R.CLEAR.PARAM, Y.READ.ERR)

  IF NOT(R.CLEAR.PARAM<CLEAR.PARAM.CAT.ACH.ACCT>) THEN
    E = 'EB-REDO.CLR.PARAM.MISS'
  END ELSE
    R.NEW(FT.CREDIT.ACCT.NO) = R.CLEAR.PARAM<CLEAR.PARAM.OUT.RETURN>
  END

  RETURN
*--------------------------------------------------------------------------------------------------------
END
