*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.MON.E.CUSTID

*-----------------------------------------------------------------------------
* Primary Purpose: Returns identification and identification type of a customer given as parameter
*                  Used as conversion routine in Enquiries. Internally reuse routine REDO.RAD.MON.CUSTID.OPER
* Input Parameters: CUSTOMER.CODE
* Output Parameters: Identification @ Identification type
*-----------------------------------------------------------------------------
* Modification History:
*
* 22/09/10 - Cesar Yepez
*            New Development
*
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

  COMI.BACKUP = COMI
  COMI = O.DATA
  CALL REDO.RAD.MON.CUSTID.OPER
  O.DATA = COMI
  COMI = COMI.BACKUP


  RETURN
*-----------------------------------------------------------------------------------

END






















