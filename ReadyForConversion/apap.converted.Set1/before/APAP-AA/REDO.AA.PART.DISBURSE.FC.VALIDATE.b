*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AA.PART.DISBURSE.FC.VALIDATE
*-----------------------------------------------------------------------------
*    First Release :
*    Developed for : APAP
*    Developed by  : TAM
*    Date          : 2012-NOV-28
*    Attached to   :
*    Attached as   :
*
* This is .validate routine to check the amount entered in REDO.AA.PART.DISBURSE.FC

* Modification History:

* PACS00236823           Marimuthu S        28-Nov-2012

*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.AA.PART.DISBURSE.FC

  Y.DIS.CHARGE = R.NEW(REDO.PDIS.CHARG.AMOUNT)
  Y.DIS.AMT = R.NEW(REDO.PDIS.DIS.AMT)
  Y.DIS.AMOUNT.TOT =  R.NEW(REDO.PDIS.DIS.AMT.TOT)

  Y.DIS.AMT.ALL=SUM(Y.DIS.AMT) + SUM(Y.DIS.CHARGE)

  IF Y.DIS.AMT.ALL NE Y.DIS.AMOUNT.TOT THEN
    AF = REDO.PDIS.DIS.AMT
    ETEXT = "EB-FC-TYPE-DISBT-NO.SAME"
    CALL STORE.END.ERROR
  END

END
