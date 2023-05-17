*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BUILD.CHECK.COMMON.VAR(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.E.BUILD.CHECK.COMMON.VAR
*----------------------------------------------------------

* Description   : Used to get current Account

* Linked with   : Enquiry
* In Parameter  : None
* Out Parameter : None
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
*---------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_System
$INSERT I_F.CUSTOMER.ACCOUNT

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*-----
INIT:
*-----
  F.CUSTOMER.ACCOUNT = ''
  FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
  CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

  FN.JOINT.CONTRACTS.XREF = 'F.JOINT.CONTRACTS.XREF'
  F.JOINT.CONTRACTS.XREF  = ''
  CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

  Y.VAR.ACCOUNT = System.getVariable('CURRENT.ACCT.NO')
  
  RETURN
*-------
PROCESS:
*-------
  Y.CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
 
  CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.CUSTOMER.ID,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,CUST.ERR)
  GOSUB JNT.ACCT.DETAILS

  IF NUM(Y.VAR.ACCOUNT) THEN
    LOCATE Y.VAR.ACCOUNT IN R.CUSTOMER.ACCOUNT SETTING CUS.ACCT.POS THEN
    END ELSE
      ENQ.ERROR = 'OF-SECURITY.VIOLATION'
      CALL AI.REDO.KILL.SESSION
    END
  END
  RETURN
*---------------
JNT.ACCT.DETAILS:
*---------------
  CALL F.READ(FN.JOINT.CONTRACTS.XREF,Y.CUSTOMER.ID,R.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF,JNT.XREF.ERR)
  R.CUSTOMER.ACCOUNT<-1> = R.JOINT.CONTRACTS.XREF
END
