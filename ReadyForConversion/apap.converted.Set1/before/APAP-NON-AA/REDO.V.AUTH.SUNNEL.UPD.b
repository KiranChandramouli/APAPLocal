*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.AUTH.SUNNEL.UPD
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.CREDIT
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as authorization routine in all the version used
*                  in the development N.83.It will fetch the value from sunnel interface
*                  and assigns it in R.NEW
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2009-10-0536    Initial Creation
* 03-DEC-2010        Prabhu.N       ODR-2010-11-0211    Modified based on Sunnel
* 12-JAN-2011        Kavitha.S      ODR-2010-11-0211    Added logic based on B.126 TFS
*26 JUN 2011         Prabhu N       PACS00061657        Added teller logic with credit and debit marker
*-------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.ACCOUNT
$INSERT I_F.T24.FUND.SERVICES

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  IF APPLICATION EQ 'TELLER' THEN
    Y.CR.DR.MARKER=R.NEW(TT.TE.DR.CR.MARKER)
    IF Y.CR.DR.MARKER EQ 'CREDIT' THEN
      Y.CR.CURRENCY=R.NEW(TT.TE.CURRENCY.1)
      IF Y.CR.CURRENCY EQ 'DOP' THEN
        Y.ARRAY='BE_P_PAGOS_SUNNEL_T24'
      END
      ELSE
        Y.ARRAY='BE_P_PAGOS_SUNNEL_T24.USD'
      END
    END
    ELSE
      Y.CR.CURRENCY=R.NEW(TT.TE.CURRENCY.2)
      IF Y.CR.CURRENCY EQ 'DOP' THEN
        Y.ARRAY='BE_P_PAGOS_SUNNEL_T24.DM'
      END
      ELSE
        Y.ARRAY='BE_P_PAGOS_SUNNEL_T24.USD.DM'
      END
    END
  END

  IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
    IF R.NEW(FT.CREDIT.CURRENCY) EQ 'DOP' THEN
      Y.ARRAY='BE_P_PAGOS_SUNNEL_T24.FT.DOP'
    END
    ELSE
      Y.ARRAY='BE_P_PAGOS_SUNNEL_T24.FT.USD'
    END
  END

  IF APPLICATION EQ 'T24.FUND.SERVICES' THEN
    ACCOUNT.NO = R.NEW(TFS.PRIMARY.ACCOUNT)
    CALL F.READ(FN.ACCOUNT,ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,ERR)
    ACC.CURRENCY = R.ACCOUNT<AC.CURRENCY>

    IF ACC.CURRENCY EQ "DOP" THEN
      Y.ARRAY = 'BE_P_PAGOS_SUNNEL_TFS_DOP'
    END ELSE
      Y.ARRAY= 'BE_P_PAGOS_SUNNEL_TFS_USD'
    END
  END

  CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)

  RETURN
END
