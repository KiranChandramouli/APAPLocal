*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.GET.DCARD.DETAILS(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name :
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry AI.REDO.LOAN.ACCT.TO
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*26/08/11      PACS00112995          Prabhu N                MODIFICAION
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
  GOSUB GET.CARD.RENEW.DETAILS
  RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

  CARD.RENEW.ID=''

  CUSTOMER.ID = System.getVariable("EXT.SMS.CUSTOMERS")

  ACCT.NO = System.getVariable("CURRENT.ACCT.NO")

  CARD.RENEW.ID=CUSTOMER.ID:"-":ACCT.NO

  RETURN
*----------------------------------------------------------------------------
GET.CARD.RENEW.DETAILS:
*-----------------------------------------------------------------------------


  IF CARD.RENEW.ID THEN

    ENQ.DATA<2,1>='@ID'
    ENQ.DATA<3,1>='EQ'
    ENQ.DATA<4,1>= CARD.RENEW.ID
  END

  RETURN
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
