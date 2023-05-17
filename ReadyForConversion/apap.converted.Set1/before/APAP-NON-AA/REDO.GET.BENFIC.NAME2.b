*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.BENFIC.NAME2(VAR.BEN.NAME2)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.GET.BENF.NAME
* ODR NUMBER    : ODR-2009-10-0795
*----------------------------------------------------------------------------------------------------
* Description   : This routine is used for Deal slip. Will return the name as per the requirement
* In parameter  :
* out parameter : Y.NAME
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 13-sept-2011      JEEVA T        PACS00127058
*----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.RELATION
$INSERT I_F.CUSTOMER
$INSERT I_F.VERSION
$INSERT I_GTS.COMMON
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.REDO.PRINT.CHQ.LIST
$INSERT I_F.TELLER


  GOSUB PROCESS.FILE


  RETURN

*----------------------------------------------------------------------------------------------------
PROCESS.FILE:
*---------------------------------------------------------------------------------------------------

  VAR.AC.ID = ''
*    VAR.BEN.NAME2 = ''
  Y.BENEFIC.NAME = R.NEW(PRINT.CHQ.LIST.BENEFICIARY)

  CHANGE VM TO FM IN Y.BENEFIC.NAME
  Y.VAR.BEN.NAME1 = Y.BENEFIC.NAME<1>
  Y.VAR.BEN.NAME2 = Y.BENEFIC.NAME<2>
  IF Y.VAR.BEN.NAME2 EQ '' THEN
    Y.VAR.BEN.NAME2 = Y.BENEFIC.NAME<1>
  END

*    IF PGM.VERSION EQ ",REPRINT" OR R.VERSION(EB.VER.D.SLIP.FORMAT) EQ "CHQ.PRINT.ADMIN" THEN
*        Y.VAR.BEN.NAME2 = Y.BENEFIC.NAME<2>
*    END

*    IF R.VERSION(EB.VER.D.SLIP.FORMAT) EQ "CHQ.PRINT.ADM.M" THEN
*        Y.VAR.BEN.NAME2 = Y.BENEFIC.NAME<2>
*    END

*    IF NOT(Y.VAR.BEN.NAME2) THEN
*        Y.VAR.BEN.NAME2 = VAR.BEN.NAME
*    END

  Y.CHQ.TYPE = R.NEW(PRINT.CHQ.LIST.CHQ.TYPE)
*    IF Y.CHQ.TYPE EQ 'ADMIN' THEN
  Y.AMOUNT = R.NEW(PRINT.CHQ.LIST.AMOUNT)
  Y.AMOUNT = FMT(Y.AMOUNT,'L2,#18')
  VAR.LEN.NAME = LEN(Y.VAR.BEN.NAME2)
*        Y.LENGTH = 130 - VAR.LEN.NAME - 65
  Y.LENGTH = 62 - VAR.LEN.NAME
*        VAR.BEN.NAME2 = VAR.BEN.NAME2:SPACE(Y.LENGTH):Y.AMOUNT
  IF VAR.BEN.NAME2 EQ 'AMT' THEN
    VAR.BEN.NAME2 = Y.AMOUNT
  END ELSE
    VAR.BEN.NAME2 = Y.VAR.BEN.NAME2
  END
*    END


  RETURN
END
