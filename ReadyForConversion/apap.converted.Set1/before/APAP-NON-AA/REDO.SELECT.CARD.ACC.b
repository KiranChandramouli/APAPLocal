*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.SELECT.CARD.ACC(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.SELECT.CARD.ACC
*----------------------------------------------------------

* Description   : This subroutine is attached as a conversion routine in the Enquiry REDO.E.AA.ARR.ACTIVITY
*                 to get the old properrty list

* Linked with   : Enquiry REDO.SELECT.CARD.ACC as conversion routine
* In Parameter  : None
* Out Parameter : None
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*10.10.2010  PRABHU N      ODR-2010-08-0031   INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_System

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*-----
INIT:
*-----

  FN.CUSTOMER.ACC='F.CUSTOMER.ACCOUNT'
  F.CUSTOMER.ACC=''
  CALL OPF(FN.CUSTOMER.ACC,F.CUSTOMER.ACC)
  Y.VAR.EXT.CUSTOMER = System.getVariable('EXT.SMS.CUSTOMERS')
  CALL F.READ(FN.CUSTOMER.ACC,Y.VAR.EXT.CUSTOMER,R.CUSTOMER.ACC,F.CUSTOMER.ACC,ERR)
  RETURN
*-------
PROCESS:
*-------
  CHANGE FM TO SM IN R.CUSTOMER.ACC
  Y.FIELD.COUNT=DCOUNT(ENQ.DATA<1>,VM)
  ENQ.DATA<2,1>= 'ACCOUNT'
  ENQ.DATA<3,1>= 'EQ'
  ENQ.DATA<4,1>= R.CUSTOMER.ACC
  RETURN
END
