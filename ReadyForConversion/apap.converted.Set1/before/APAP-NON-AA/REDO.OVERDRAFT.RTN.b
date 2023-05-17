*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.OVERDRAFT.RTN
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.OVERDRAFT.RTN
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the
*                    from account and limit application and returns it to O.DATA
*Linked With       : Enquiry ENQ.REDO.OVERDRAFT.ACCOUNT
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date           Who               Reference                                 Description
*     ------         -----             -------------                             -------------
* 16 NOV 2010       NATCHIMUTHU.P        ODR-2010-03-0089                         Initial Creation
*
*********************************************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.ACCOUNT
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ACCOUNT.OVERDRAWN


  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)


  FN.ACCOUNT.OVERDRAWN = 'F.ACCOUNT.OVERDRAWN'
  F.ACCOUNT.OVERDRAWN  = ''
  CALL OPF(FN.ACCOUNT.OVERDRAWN,F.ACCOUNT.OVERDRAWN)

  ACCOUNT.ID = O.DATA

  CALL F.READ(FN.ACCOUNT.OVERDRAWN,ACCOUNT.ID,R.ACCOUNT.OVERDRAWN,F.ACCOUNT.OVERDRAWN,Y.ERR)
  IF R.ACCOUNT.OVERDRAWN THEN
    Y.DATE.FIRST.OD  =  R.ACCOUNT.OVERDRAWN<AC.OD.DATE.FIRST.OD>
    Y.TODAY          = TODAY
    NO.OF.DAYS = 'C'
    CALL CDD('',Y.DATE.FIRST.OD,Y.TODAY,NO.OF.DAYS)
    O.DATA = NO.OF.DAYS
  END ELSE
    O.DATA = ''
  END
  RETURN
END
*-----------------------------------------------------------------------------------------------------------------------------
* PROGRAM END
*------------------------------------------------------------------------------------------------------------------------------
