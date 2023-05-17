*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.TXN.AUTHORISE
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.ATH.IN.STLMT.RTN
*Date              : 13.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*13/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.ACCOUNT
$INSERT I_F.AC.LOCKED.EVENTS
$INSERT I_ATM.BAL.ENQ.COMMON

  IF V$FUNCTION EQ 'R' THEN

    RETURN

  END

  GOSUB LOCAL.REF.FIELDS
  GOSUB PROCESS

  RETURN


*------------------------------------------------------------------------------------
LOCAL.REF.FIELDS:
*------------------------------------------------------------------------------------

  LREF.APP = 'ACCOUNT'
  LREF.FIELDS = 'L.AC.AV.BAL'
  LOCAL.REF.POS=''
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LOCAL.REF.POS)
  L.AC.AV.BAL.POS = LOCAL.REF.POS<1,1>

  RETURN

*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------
  Y.ACC.NO=R.NEW(AC.LCK.ACCOUNT.NUMBER)


  IF R.ACCOUNT THEN
    Y.AV.BAL=R.ACCOUNT<AC.LOCAL.REF,L.AC.AV.BAL.POS>
  END

  Y.LOCK.AMT=R.NEW(AC.LCK.LOCKED.AMOUNT)

  IF Y.LOCK.AMT GT Y.AV.BAL THEN
    CURR.NO=DCOUNT(R.NEW(AC.LCK.OVERRIDE),VM) + 1
    TEXT='ACCT.UNAUTH.OD'
    CALL STORE.OVERRIDE(CURR.NO)
  END

  RETURN
END
