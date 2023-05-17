*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE APAP.H.CONCAT.AA.INS.NEW
* ====================================================================================
*
* Subroutine Type : Authroutine
* Attached to     : APAP.H.INSURANCE.DETAILS,REDO.AUTORIZACION
* Attached as     : Auth Rouine
* Primary Purpose : Update Concat File
*
*
* Incoming:
* ---------
* NA
*
* Outgoing:
* ---------
* NA
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular APAP
* Development by  : Jorge Valarezo
* Date            : 02 APR 2013
*=======================================================================

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.APAP.H.INSURANCE.DETAILS
$INSERT I_F.APAP.AA.INSURANCE
*
*************************************************************************
*


  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN


*
* =========
INITIALISE:
* =========
*
  FN.APAP.INSURANCE.AA = 'F.APAP.AA.INSURANCE'
  F.APAP.INSURANCE.AA = ''

  FN.INS.DET      =  'F.APAP.H.INSURANCE.DETAILS'
  F.INS.DET       =  ''

  RETURN
*
* =========
OPEN.FILES:
* =========
*
  CALL OPF(FN.APAP.INSURANCE.AA,F.APAP.INSURANCE.AA)
  CALL OPF(FN.INS.DET,F.INS.DET)
  RETURN

* ======
PROCESS:
* ======
  IF NOT(R.NEW(INS.DET.ASSOCIATED.LOAN))  THEN
    RETURN
  END

  NO.OF.LOANS = DCOUNT(R.NEW(INS.DET.ASSOCIATED.LOAN),VM)
  FOR POSSITION = 1 TO NO.OF.LOANS
    LOAN.ID = R.NEW(INS.DET.ASSOCIATED.LOAN)<1,POSSITION>
    CALL CONCAT.FILE.UPDATE(FN.APAP.INSURANCE.AA,LOAN.ID,ID.NEW,'I','AR')
  NEXT POSSITION

  RETURN
END
