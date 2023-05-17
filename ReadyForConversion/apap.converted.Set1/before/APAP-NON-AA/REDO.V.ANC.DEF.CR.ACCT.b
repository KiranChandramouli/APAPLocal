*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.ANC.DEF.CR.ACCT
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This AUTO.CONTENT.ROUTINE  is used to populate credit account number based on company
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NATCHIMUTHU.P
* PROGRAM NAME : REDO.V.ANC.DEF.CR.ACCT
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 20.07.2010       NATCHIMUTHU.P    ODR-2010-02-0001  INITIAL CREATION
* -----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.COMPANY

  GOSUB PROCESS
  RETURN

PROCESS:
*-------
* USD-12801-0007-0017

  Y.SU.DIV.CODE = R.COMPANY(EB.COM.SUB.DIVISION.CODE)
  Y.CREDIT.ACCT.NO = "USD128010007"
  R.NEW(FT.CREDIT.ACCT.NO)=Y.CREDIT.ACCT.NO:Y.SU.DIV.CODE
  RETURN
*------------------------------------------------------------------------------------------------------------
END
