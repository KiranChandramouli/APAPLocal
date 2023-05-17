*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AZ.DSLIP.RTN(Y.RET)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Arulprakasam P
* PROGRAM NAME: REDO.DS.SECURITY.TERM
* ODR NO      : ODR-2010-07-0082
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the Product selected for LETTER

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE              WHO            REFERENCE             DESCRIPTION
* NA            Arulprakasam P   ODR-2010-07-0082       Initial Draft
* 28-May-2011   H Ganesh         PACS00023978 - B.29    Modified as per the issue
*----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT

  GOSUB LOC.REF
  GOSUB PROCESS
  RETURN

LOC.REF:
*******
  APPL.ARRAY = 'AZ.ACCOUNT'
  FLD.ARRAY  = 'L.TYPE.INT.PAY'
  FLD.POS    = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
  LOC.L.TYPE.INT.PAY = FLD.POS<1,1>
  RETURN

PROCESS:
********
*IF Y.NOMI.ACC THEN
*Y.RET= "PAGADEROS MENSUALMENTE MEDIANTE CREDITO A CUENTA ":Y.NOMI.ACC
*END
  Y.INT.PAY = R.NEW(AZ.LOCAL.REF)<1,LOC.L.TYPE.INT.PAY>
  IF Y.INT.PAY EQ 'Credit.To.Account' THEN
    Y.RET = "PAGADEROS MENSUALMENTE MEDIANTE "
    Y.STR = "CREDITO A CUENTA ":R.NEW(AZ.INTEREST.LIQU.ACCT)
    Y.RET<1,-1> = FMT(Y.STR,"R#63")

    RETURN
  END
  IF Y.INT.PAY EQ 'Reinvested' THEN
    Y.RET="PAGADEROS MENSUALMENTE MEDIANTE "
    Y.STR="REINVERSION"
    Y.RET<1,-1> = FMT(Y.STR,"R#49")
    RETURN
  END
  IF Y.INT.PAY EQ 'Admin.check' THEN
    Y.RET="PAGADEROS MENSUALMENTE MEDIANTE "
    Y.STR="CHEQUE DE ADMINISTRACION"
    Y.RET<1,-1> = FMT(Y.STR,"R#60")
    RETURN
  END
  IF Y.INT.PAY EQ 'Transfer.via.ACH' THEN
    Y.RET="PAGADEROS MENSUALMENTE MEDIANTE "
    Y.STR="TRANSFERENCIA VIA ACH"
    Y.RET<1,-1> = FMT(Y.STR,"R#57")
    RETURN
  END
*END


  RETURN

END
