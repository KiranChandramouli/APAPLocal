*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ACC.REASON.UPDATE
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This routine is attached as Auth Routine in Deposit Closure Version.
* It is used to update the cancel reason from deposit account
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH R
* PROGRAM NAME : REDO.ACC.REASON.UPDATE
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO               REFERENCE         DESCRIPTION
* 26-JUN-12        GANESH R          PACS00203772      Initial
* -----------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.ACCOUNT

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------
INIT:
*-------------------------------------------------------------------------------
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  LOC.REF.APP = 'ACCOUNT':FM:'AZ.ACCOUNT'
  LOC.REF.FIELD = 'L.AC.CAN.REASON':VM:'L.AC.OTH.REASON':FM:'L.AC.CAN.REASON':VM:'L.AC.OTH.REASON'
  LOC.REF.POS = ''
  CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.REF.POS)
  POS.AC.CAN.REASON.CLOSE = LOC.REF.POS<1,1>
  POS.AC.OTH.REASON.CLOSE = LOC.REF.POS<1,2>
  POS.AC.CAN.REASON.AZ    = LOC.REF.POS<2,1>
  POS.AC.OTH.REASON.AZ    = LOC.REF.POS<2,2>
  RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------
* This is the main para used to check the category and update the charge related fields
  VAR.ACC.ID = ID.NEW
  CALL F.READ(FN.ACCOUNT,VAR.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
  R.ACCOUNT<AC.LOCAL.REF,POS.AC.CAN.REASON.CLOSE> = R.NEW(AZ.LOCAL.REF)<1,POS.AC.CAN.REASON.AZ>
  R.ACCOUNT<AC.LOCAL.REF,POS.AC.OTH.REASON.CLOSE> = R.NEW(AZ.LOCAL.REF)<1,POS.AC.OTH.REASON.AZ>
  CALL F.WRITE(FN.ACCOUNT,VAR.ACC.ID,R.ACCOUNT)

  RETURN
*---------------------------------------------------------------------------------------------------------------
END
