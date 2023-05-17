*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BUILD.GET.EXT.CUST(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name :REDO.E.BUILD.GET.EXT.CUST
*----------------------------------------------------------

* Description   : This subroutine is used to set selection for CUSTOMER

* Linked with   : REDO.CCARD.LIST
* In Parameter  : ENQ.DATA
* Out Parameter : ENQ.DATA
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

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*-----
INIT:
*-----
  Y.CUSTOMER= System.getVariable('EXT.SMS.CUSTOMERS')
  RETURN
*-------
PROCESS:
*-------

  BEGIN CASE
  CASE ENQ.DATA<1,1> EQ 'AI.REDO.DEBIT.CARD.LIST'
    ENQ.DATA<2,-1>='CUSTOMER.NO'
    ENQ.DATA<3,-1>='EQ'
    ENQ.DATA<4,-1>=Y.CUSTOMER

  CASE ENQ.DATA<1,1> EQ 'AI.REDO.SAV.ACCOUNT.LIST'
    Y.FIELD.COUNT=DCOUNT(ENQ.DATA<2>,VM)
    ENQ.DATA<2,Y.FIELD.COUNT+1>= 'CUSTOMER'
    ENQ.DATA<3,Y.FIELD.COUNT+1>= 'EQ'
    ENQ.DATA<4,Y.FIELD.COUNT+1> = Y.CUSTOMER


  CASE ENQ.DATA<1,1> EQ 'AI.REDO.AZ.PROD.LIST'
    Y.FIELD.COUNT=DCOUNT(ENQ.DATA<2>,VM)
    ENQ.DATA<2,Y.FIELD.COUNT+1>= 'CUSTOMER'
    ENQ.DATA<3,Y.FIELD.COUNT+1>= 'EQ'
    ENQ.DATA<4,Y.FIELD.COUNT+1> = Y.CUSTOMER
  CASE OTHERWISE

    Y.FIELD.COUNT=DCOUNT(ENQ.DATA<2>,VM)
    ENQ.DATA<2,Y.FIELD.COUNT+1>= 'CUSTOMER'
    ENQ.DATA<3,Y.FIELD.COUNT+1>= 'EQ'
    ENQ.DATA<4,Y.FIELD.COUNT+1> = Y.CUSTOMER
  END CASE

  RETURN

END
