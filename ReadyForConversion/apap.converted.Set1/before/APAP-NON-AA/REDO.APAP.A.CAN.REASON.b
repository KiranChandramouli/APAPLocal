*-----------------------------------------------------------------------------
* <Rating>-71</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.A.CAN.REASON
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CON.GET.TIME
*--------------------------------------------------------------------------------------------------------
*Description       : This is a Authorization routine attached to an version, the routine will NULLIFY
*                    the L.AC.CAN.REASON & L.AC.OTH.REASON fieldsd in ACCOUNT Application if reverse the account closure transaction.
*Linked With       : ACCOUNT.CLOSURE authorise version
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date          Who             Reference                                 Description
*     ------         -----           -------------                             -------------
*   29 09 2010   Jeyachandran S    ODR-2010-03-0166                            Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ACCOUNT
$INSERT I_F.ACCOUNT.CLOSURE
$INSERT I_GTS.COMMON

  IF V$FUNCTION EQ 'D' THEN
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB MAIN.PARA
    GOSUB GOEND
  END ELSE
    IF V$FUNCTION EQ 'A' THEN
      GOSUB GEN.DEAL.SLIP
    END
  END
  RETURN
*----------
INIT:

  Y.APPL1 = 'ACCOUNT.CLOSURE':FM:'ACCOUNT'
  Y.FIELDS1 = 'L.AC.CAN.REASON'::VM:'L.AC.OTH.REASON':FM:'L.AC.CAN.REASON':VM:'L.AC.OTH.REASON'
  Y.POS1 = ''
  CALL MULTI.GET.LOC.REF(Y.APPL1,Y.FIELDS1,Y.POS1)
  Y.L.AC.CAN.REASON.POS  = Y.POS1<1,1>
  Y.L.AC.OTH.REASON.POS  = Y.POS1<1,2>
  Y.L.AC.CAN.REASON.POS1 = Y.POS1<2,1>
  Y.L.AC.OTH.REASON.POS1 = Y.POS1<2,2>

  RETURN
*-----------
OPENFILES:
*-----------
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  RETURN

*-----------
MAIN.PARA:
*------------
  Y.ID = ID.NEW

  CALL F.READ(FN.ACCOUNT,Y.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

  IF R.ACCOUNT THEN
    R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.CAN.REASON.POS1> = ''
    R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.OTH.REASON.POS1> = ''
    CALL F.WRITE(FN.ACCOUNT,Y.ID,R.ACCOUNT)
  END
  RETURN
*------------------------
GEN.DEAL.SLIP:
*------------------------
  VAR.SET.ACC = R.NEW(AC.ACL.SETTLEMENT.ACCT)

  DEAL.SLIP.ID = 'REDO.AVISO.DR'
  OFS$DEAL.SLIP.PRINTING = 1
  CALL PRODUCE.DEAL.SLIP(DEAL.SLIP.ID)

  IF VAR.SET.ACC THEN
    DEAL.SLIP.ID = 'REDO.AVISO.CR'
    OFS$DEAL.SLIP.PRINTING = 1
    CALL PRODUCE.DEAL.SLIP(DEAL.SLIP.ID)
  END

  RETURN
*----------
GOEND:
END       ;* End of program
