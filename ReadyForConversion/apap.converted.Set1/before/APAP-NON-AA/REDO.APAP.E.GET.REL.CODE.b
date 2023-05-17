*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.APAP.E.GET.REL.CODE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.E.GET.REL.CODE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.E.GET.REL.CODE is a conversion routine attached to the ENQUITY>
*                     REDO.APAP.PROX.ACCT, the routine fetches the value from O.DATA delimited with stars
*                     and formats them according to the selection criteria and returns the value back to O.DATA
*Linked With       :
*In  Parameter     : O.DATA
*Out Parameter     : O.DATA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 18 OCT 2010             Mudassir V           ODR-2010-03-0182        Initial Creation
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_ENQUIRY.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
  GOSUB OPEN.FILE
  GOSUB PROCESS.PARA

  RETURN
*-------------------------------------------------------------------------------------------------------
**********
OPEN.FILE:
**********
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  RETURN

*-------------------------------------------------------------------------------------------------------

*************
PROCESS.PARA:
*************
  TEMP.DATA = O.DATA
  CALL F.READ(FN.ACCOUNT,TEMP.DATA,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
  Y.REL.CODE = R.ACCOUNT<AC.RELATION.CODE>
  IF Y.REL.CODE THEN
    O.DATA = ''
    LOOP
      REMOVE Y.DATA FROM Y.REL.CODE SETTING Y.POS
    WHILE Y.DATA:Y.POS
      IF Y.DATA GE 530 AND Y.DATA LE 549 THEN
        O.DATA<-1> = Y.DATA
      END
    REPEAT
  END
  ELSE
    O.DATA = ''
  END
  RETURN
END
