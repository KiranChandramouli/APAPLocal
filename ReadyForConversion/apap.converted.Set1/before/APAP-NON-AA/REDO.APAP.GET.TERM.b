*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.GET.TERM
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.GET.TERM
*----------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.GET.TERM is a conversion routine attached to the ENQUIRY>
*                    REDO.APAP.INVST.RATE, the routine fetches the value from O.DATA delimited
*                    with stars and formats them according to the selection criteria and returns the value
*                     back to O.DATA
*Linked With       :
*In  Parameter     : N/A
*Out Parameter     : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 09 NOV 2010              Dhamu S             ODR-2010-03-0098            Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT
$INSERT I_ENQUIRY.COMMON
*--------------------------------------------------------------------------------------------------------

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  AZ.ACCOUNT.ID = FIELD(O.DATA,'\',1)
  CALL F.READ(FN.AZ.ACCOUNT,AZ.ACCOUNT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,ACCT.ERR)
  MAT.DATE.VAL = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
  VALUE.DATE.VAL = R.AZ.ACCOUNT<AZ.VALUE.DATE>
  Y.REG = ''
  Y.DAYS = 'C'

  CALL CDD(Y.REG,MAT.DATE.VAL,VALUE.DATE.VAL,Y.DAYS)
  O.DATA = ''
  O.DATA = ABS(Y.DAYS)
  RETURN
END
*------------------------------------------------------------------------------------------------------------------
