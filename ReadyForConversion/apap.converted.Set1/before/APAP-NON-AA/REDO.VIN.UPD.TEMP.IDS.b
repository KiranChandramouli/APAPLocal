*-----------------------------------------------------------------------------
* <Rating>-46</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VIN.UPD.TEMP.IDS
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.VIN.UPD.TEMP.IDS
* ODR NUMBER    : HD1052244
*-------------------------------------------------------------------------------
* Description   : This is input routine, will be attached to the versions
*
* In parameter  : none
* out parameter : none
*-------------------------------------------------------------------------------
* Modification History :
*-------------------------------------------------------------------------------
*   DATE               WHO             REFERENCE        DESCRIPTION
* 19-01-2011        MARIMUTHU S        HD1052244        Initial Creation
* 11-04-2013   Vignesh Kumaar R        PACS00251345     To update DEPOSIT related FT in TEMP VERSION table
*-------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT ;*
$INSERT I_F.AZ.ACCOUNT ;*
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.REDO.TEMP.VERSION.IDS
*-------------------------------------------------------------------------------
MAIN:
*-------------------------------------------------------------------------------

  GOSUB OPENFILE
  IF V$FUNCTION EQ 'I' THEN
    Y.ID = APPLICATION:PGM.VERSION
    BEGIN CASE
    CASE Y.ID EQ 'FUNDS.TRANSFER,REDO.CHQ.TAX'
      CALL CACHE.READ(FN.REDO.TEMP.VERSION.IDS,'FUNDS.TRANSFER,CHQ.TAX.AUT',R.REC.TEMP.VERSION,TEMP.ERR)
      Y.ID = 'FUNDS.TRANSFER,REDO.CHQ.TAX.AUT'

    CASE Y.ID EQ 'FUNDS.TRANSFER,REDO.CHQ.NO.TAX'
      CALL CACHE.READ(FN.REDO.TEMP.VERSION.IDS,'FUNDS.TRANSFER,CHQ.NO.TAX.AUT',R.REC.TEMP.VERSION,TEMP.ERR)
      Y.ID = 'FUNDS.TRANSFER,REDO.CHQ.NO.TAX.AUT'

    CASE Y.ID EQ 'FUNDS.TRANSFER,REDO.MGR.CHQ.NO.TAX'
      CALL CACHE.READ(FN.REDO.TEMP.VERSION.IDS,'FUNDS.TRANSFER,MGR.CHQ.NO.TAX.AUT',R.REC.TEMP.VERSION,TEMP.ERR)
      Y.ID = 'FUNDS.TRANSFER,REDO.MGR.CHQ.NO.TAX.AUT'

    CASE Y.ID EQ 'TELLER,REDO.CHQ.NO.TAX'
      CALL CACHE.READ(FN.REDO.TEMP.VERSION.IDS,'TELLER,CHQ.NO.TAX.AUT',R.REC.TEMP.VERSION,TEMP.ERR)
      Y.ID = 'TELLER,REDO.CHQ.NO.TAX.AUT'

    CASE Y.ID EQ 'FUNDS.TRANSFER,REDO.MGRUSD.CHQ.TAX'
      CALL CACHE.READ(FN.REDO.TEMP.VERSION.IDS,'FUNDS.TRANSFER,MGRUSD.CHQ.TAX.AUT',R.REC.TEMP.VERSION,TEMP.ERR)
      Y.ID = 'FUNDS.TRANSFER,REDO.MGRUSD.CHQ.TAX.AUT'

* Fix for PACS00251345 [To update DEPOSIT related FT in TEMP VERSION table #1]

    CASE OTHERWISE
      CALL CACHE.READ(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION,TEMP.ERR)

      GOSUB CHECK.FOR.DEPOSIT.TYPE

    END CASE

* End of Fix

    IF R.REC.TEMP.VERSION EQ '' THEN
      R.REC.TEMP.VERSION<REDO.TEM.TXN.ID> = ID.NEW
      CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION)
    END ELSE
      LOCATE ID.NEW IN R.REC.TEMP.VERSION<REDO.TEM.TXN.ID,1> SETTING POS.ID ELSE
        Y.TXN.ID = R.REC.TEMP.VERSION<REDO.TEM.TXN.ID>
        Y.CNT = DCOUNT(Y.TXN.ID,VM)
        R.REC.TEMP.VERSION<REDO.TEM.TXN.ID,Y.CNT+1> = ID.NEW
        CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION)
      END
    END
  END

  GOSUB PROGRAM.END
*-------------------------------------------------------------------------------
OPENFILE:
*-------------------------------------------------------------------------------
  FN.REDO.TEMP.VERSION.IDS = 'F.REDO.TEMP.VERSION.IDS'
  F.REDO.TEMP.VERSION.IDS = ''
  CALL OPF(FN.REDO.TEMP.VERSION.IDS,F.REDO.TEMP.VERSION.IDS)

* Fix for PACS00251345 [To update DEPOSIT related FT in TEMP VERSION table #2]

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

* End of Fix

  RETURN

*-------------------------------------------------------------------------------
CHECK.FOR.DEPOSIT.TYPE:
*-------------------------------------------------------------------------------

  GET.FT.DEBIT.ACCT = R.NEW(FT.DEBIT.ACCT.NO)
  CALL F.READ(FN.AZ.ACCOUNT,GET.FT.DEBIT.ACCT,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ERR)

  IF NOT(R.AZ.ACCOUNT) THEN

    CALL F.READ(FN.ACCOUNT,GET.FT.DEBIT.ACCT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    GET.AC.CATEG = R.ACCOUNT<AC.CATEGORY>

    IF GET.AC.CATEG GE 6010 AND GET.AC.CATEG LE 6020 THEN
      R.REC.TEMP.VERSION<REDO.TEM.FT.TYPE> = 'DEPOSIT'
    END
  END ELSE
    R.REC.TEMP.VERSION<REDO.TEM.FT.TYPE> = 'DEPOSIT'
  END

  RETURN

*-------------------------------------------------------------------------------
PROGRAM.END:

END
