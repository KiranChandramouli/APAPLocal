*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.ENQ.CONV.GET.DATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.ENQ.CONV.GET.DATE
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the TIME
*                    from TIME.STAMP and returns it to O.DATA
*Linked With       : Enquiry REDO.APAP.ENQ.INV.GEN.RPT
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date              Who                  Reference                                 Description
*     ------            -----                -------------                             -------------
*    16.11.2010     Akthar Rasool S         ODR-2010-03-0180                         Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
  Y.TIME.DATE = TIMEDATE()
  O.DATA = Y.TIME.DATE[9,12]
  RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
