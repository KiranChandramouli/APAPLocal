*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BLD.CONTACT.LOG(ENQ.DATA)
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : H GANESH
* Program Name  : REDO.E.BLD.VAL.ACCOUNT
*-------------------------------------------------------------------------
* Description: This routine is a build routine attached to all enquiries
* which have account no as selection field to restrict unauthorised access
*----------------------------------------------------------
* Linked with: All enquiries with Customer no as selection field
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 01-09-10          ODR-2010-08-0031              Routine to validate Account

*------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.ACCOUNT
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.UNAUTH.STAFF.LOG
$INSERT I_F.REDO.EMPLOYEE.ACCOUNTS

  GOSUB OPENFILES
  GOSUB PROCESS

  RETURN

*---------
OPENFILES:
*---------

  FN.REDO.W.CONTACT.LOG = 'F.REDO.W.CONTACT.LOG'
  F.REDO.W.CONTACT.LOG =''
  CALL OPF(FN.REDO.W.CONTACT.LOG,F.REDO.W.CONTACT.LOG)

  RETURN

*------------
PROCESS:
*-------------
  LOCATE 'CONTACT.CLIENT' IN ENQ.DATA<2,1> SETTING POS.CON THEN
    VAR.CONT.CLIENT = ENQ.DATA<4,POS.CON>
  END
  Y.ID = 'CRM-CONCATE':'*':VAR.CONT.CLIENT

  CALL F.READ(FN.REDO.W.CONTACT.LOG,Y.ID,R.REDO.W.CONTACT.LOG,F.REDO.W.CONTACT.LOG,Y.ERR)

  Y.VAL = R.REDO.W.CONTACT.LOG
  CHANGE FM TO ' ' IN Y.VAL
  ENQ.DATA<2,-1> = "@ID"
  ENQ.DATA<3,-1> = "EQ"
  ENQ.DATA<4,-1> = Y.VAL

  RETURN
END
