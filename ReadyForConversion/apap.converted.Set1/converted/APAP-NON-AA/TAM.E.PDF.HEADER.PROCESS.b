SUBROUTINE TAM.E.PDF.HEADER.PROCESS

*-----------------------------------------------------------------------------

*Company   Name    : APAP
*Developed By      : Temenos Application Management
*Program   Name    : TAM.E.PDF.HEADER.PROCESS

*-----------------------------------------------------------------------------

*Description       : This routine is used pdf purpose
*In  Parameter     : N/A
*Out Parameter     : N/A
*ODR Number        :

*-----------------------------------------------------------------------------
*Modification History:
*-----------------------------------------------------------------------------
*    Initial Development for APAP ARC - IB
*-----------------------------------------------------------------------------
*Insert Files
*-----------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_ENQ.SES.VAR.COMMON

*-----------------------------------------------------------------------------

    PDF.HEADER = O.DATA
RETURN
END
