*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CNV.TERM.MTH
*----------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : NAVEENKUMAR N
* Program Name  : REDO.E.CNV.TERM.MTH
*----------------------------------------------------------
* Description   : This subroutine is attached as a conversion routine in the Enquiry REDO.REINVESTED.ACCT.STMT
*
* Linked with   : Enquiry REDO.REINVESTED.ACCT.STMT as conversion routine
* In Parameter  : None
* Out Parameter : None
*-----------------------------------------------------------------------------
* Modification Details:
*=====================
* 24/08/2010 - ODR-2010-08-0192
*------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.AZ.ACCOUNT
$INSERT I_ENQUIRY.COMMON
*
  GOSUB INIT
  GOSUB PROCESS
  RETURN
*----------
INIT:
*----------
  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT  = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
*
  RETURN
*-------
PROCESS:
*-------
! Process to fetch the Number of months to between value date and Maturity date
  Y.VALUE.DATE    = R.RECORD<AZ.VALUE.DATE>
  Y.MATURITY.DATE = R.RECORD<AZ.MATURITY.DATE>
  NO.OF.MONTHS = ""
  NO.OF.DAYS = ""
*
  CALL EB.NO.OF.MONTHS(Y.VALUE.DATE,Y.MATURITY.DATE,NO.OF.MONTHS)
  NO.OF.DAYS = 'C'
  CALL CDD('',Y.VALUE.DATE,Y.MATURITY.DATE,NO.OF.DAYS)

  IF NO.OF.MONTHS THEN
    IF NO.OF.MONTHS GT 1 THEN
      Y.MONTHS = "MESES"
      O.DATA = NO.OF.MONTHS:Y.MONTHS
    END ELSE
      Y.MONTHS = "MES"
      O.DATA = NO.OF.MONTHS:Y.MONTHS
    END
  END ELSE
    IF NO.OF.DAYS GT 1 THEN
      Y.DAYS = "DIAS"
      O.DATA = NO.OF.MONTHS:Y.DAYS
    END ELSE
      Y.DAYS = "DIA"
      O.DATA = NO.OF.MONTHS:Y.DAYS
    END
  END

*
  RETURN
END
