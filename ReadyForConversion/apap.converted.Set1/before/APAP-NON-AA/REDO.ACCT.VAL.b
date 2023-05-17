*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ACCT.VAL
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.ACCT.VAL
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to check valid notification value
*Linked With       : ACCOUNT,REDO.ACCT.ENTR
*In  Parameter     :
*Out Parameter     :
*Files  Used       : ACCOUNT            As          I Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 06/09/2010       NATCHIMUTHU.P            HD1029093               Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT

  GOSUB INIT
  GOSUB PROCESS.PARA
  RETURN

INIT:
*******
* DEBUG
  LOC.REF.APPL= "ACCOUNT"
  LOC.REF.FIELDS= "L.AC.NOTIFY.1"
  LOC.REF.POS= " "
  CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
  Y.NOTIFY.POS   =  LOC.REF.POS<1,1>
  Y.NOTIFY1 = R.NEW(AC.LOCAL.REF)<1,Y.NOTIFY.POS>
  RETURN


PROCESS.PARA:
*************
  LOOP
    REMOVE Y.NOTIFY FROM Y.NOTIFY1 SETTING POS
  WHILE Y.NOTIFY:POS
    IF Y.NOTIFY EQ 'EMPLOYEE' OR Y.NOTIFY EQ 'TELLER' OR Y.NOTIFY EQ 'STOP.CHEQUE' OR Y.NOTIFY EQ 'RETURNED.CHEQUE' THEN
      AF = L.AC.NOTIFY.1
      ETEXT = 'CO-MANDATORY.REMARKS'
      CALL STORE.END.ERROR
    END
  REPEAT
  RETURN

END

*------------------------------------------------------------------------------------------------------
* PROGRAM END
*-------------------------------------------------------------------------------------------------------
