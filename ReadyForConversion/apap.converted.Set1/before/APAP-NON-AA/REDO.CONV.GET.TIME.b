*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.GET.TIME
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CONV.GET.TIME
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the TIME
*                    from TIME.STAMP and returns it to O.DATA
*Linked With       : Enquiry ENQ.REDO.OVERDRAFT.ACCOUNT
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date          Who                       Reference                                 Description
*     ------         -----                    -------------                             -------------
* 18 NOV 2010     NATCHIMUTHU. P              ODR-2010-03-0089                          Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON


MAIN.PARA:
**********

  GOSUB PROCESS.PARA

  RETURN

PROCESS.PARA:
*************

  Y.TIME.DATE = TIMEDATE()
  O.DATA = Y.TIME.DATE[1,8]

  RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
*---------------------------------------------------------------------------------------------------------
