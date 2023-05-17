*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.GET.MATURITY.AMT(AZ.SCHEDULES.ID,Y.MATURITY.AMOUNT)
*------------------------------------------------------------------------------
*Company   Name     : APAP Bank
*Developed By       : Temenos Application Management
*Program   Name     : REDO.APAP.GET.MATURITY.AMT
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.GET.MATURITY.AMT is a subroutine used to calculate the maturity amount
*                    for an deposit account
*Used in           : Routines REDO.APAP.INP.CAP.COVER, REDO.APAP.INP.CPH.OPEN,REDO.APAP.INP.CPH.MODIFY and
*                    REDO.APAP.NOFILE.MG.ACCT.NO
*In  Parameter     : AZ.SCHEDULES.ID
*Out Parameter     : Y.MATURITY.AMOUNT
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  26/07/2010      Rashmitha M        ODR-2009-10-0346         Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AZ.SCHEDULES
*--------------------------------------------------------------------------------------------------------
  FN.AZ.SCHEDULES = 'F.AZ.SCHEDULES'
  F.AZ.SCHEDULES  = ''
  CALL OPF(FN.AZ.SCHEDULES,F.AZ.SCHEDULES)

  FN.AZ.SCHEDULES.NAU = 'F.AZ.SCHEDULES.NAU'
  F.AZ.SCHEDULES.NAU  = ''
  CALL OPF(FN.AZ.SCHEDULES.NAU,F.AZ.SCHEDULES.NAU)

  GOSUB READ.AZ.SCHEDULES
  IF R.AZ.SCHEDULES THEN
    GOSUB GET.MAT.AMT
    RETURN
  END

  GOSUB READ.AZ.SCHEDULES.NAU
  IF R.AZ.SCHEDULES THEN
    GOSUB GET.MAT.AMT
    RETURN
  END
  RETURN
*--------------------------------------------------------------------------------------------------------
GET.MAT.AMT:

  Y.AMT.LIST = R.AZ.SCHEDULES<AZ.SLS.TOT.REPAY.AMT>
  Y.MATURITY.AMOUNT = Y.AMT.LIST<1,DCOUNT(Y.AMT.LIST,VM)>

  RETURN
*--------------------------------------------------------------------------------------------------------
READ.AZ.SCHEDULES:

  R.AZ.SCHEDULES  = ''
  AZ.SCHEDULES.ER = ''
  CALL F.READ(FN.AZ.SCHEDULES,AZ.SCHEDULES.ID,R.AZ.SCHEDULES,F.AZ.SCHEDULES,AZ.SCHEDULES.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
READ.AZ.SCHEDULES.NAU:

  R.AZ.SCHEDULES  = ''
  AZ.SCHEDULES.NAU.ER = ''
  CALL F.READ(FN.AZ.SCHEDULES.NAU,AZ.SCHEDULES.ID,R.AZ.SCHEDULES,F.AZ.SCHEDULES.NAU,AZ.SCHEDULES.NAU.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
END
