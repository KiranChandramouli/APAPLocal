*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.CHECK.STATUS(ENQ.DATA)
*********************************************************************************************************
* Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By      : Temenos Application Management
* Program   Name    : REDO.NOFILE.PYMT.STOP.ACCT
*--------------------------------------------------------------------------------------------------------
* Description       : This routine is used to increase the count based upon the user's input

* Linked With       :
* In  Parameter     : Y.FINAL.ARR
* Out Parameter     : Y.FINAL.ARR
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------             -----                 -----------                -----------
* 21-DEC-2010      JEYACHANDRAN S          ODR-2010-03-0159           Initial Creation
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

  GOSUB INIT

  RETURN

*---------
INIT:

  ENQ.DATA<2,-1> := "ACCOUNT.NUMBER"
  ENQ.DATA<3,-1> := "EQ"
  ENQ.DATA<4,-1> := FIELD(ID.NEW,'.',1)

  RETURN

*****************************************************************************************************************************
END
