*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.LIST.TRANS.CR.ACCT(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name : REDO.E.ELIM.LOAN.PRODUCT
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry AI.REDO.LOAN.ACCT.TO
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*12/09/11      PACS00125978             Prabhu N                MODIFICAION
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_F.CUSTOMER.ACCOUNT
$INSERT I_F.STMT.ENTRY
$INSERT I_F.FUNDS.TRANSFER

  GOSUB INITIALISE
  GOSUB SEND.LIST.ACCTS
  RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------


  CUSTOMER.ACCTS = System.getVariable("EXT.CUSTOMER.ACCOUNTS")
  SELECTED.ACCT = System.getVariable("CURRENT.DEBIT.ACCT.NO")
  

  CHANGE SM TO FM IN CUSTOMER.ACCTS

  LOCATE SELECTED.ACCT IN CUSTOMER.ACCTS SETTING SEL.ACCT.POS THEN
    DEL CUSTOMER.ACCTS<SEL.ACCT.POS>

  END

  RETURN
*----------------------------------------------------------------------------
SEND.LIST.ACCTS:
*-----------------------------------------------------------------------------

  CHANGE FM TO ' ' IN CUSTOMER.ACCTS
  ENQ.DATA<2,1>='@ID'
  ENQ.DATA<3,1>='EQ'
  ENQ.DATA<4,1>=CUSTOMER.ACCTS

  RETURN
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
