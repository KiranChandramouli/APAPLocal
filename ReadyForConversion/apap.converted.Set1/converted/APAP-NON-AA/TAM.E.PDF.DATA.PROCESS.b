SUBROUTINE TAM.E.PDF.DATA.PROCESS
*-----------------------------------------------------------------------------

*Company   Name    : APAP
*Developed By      : Temenos Application Management
*Program   Name    : TAM.E.PDF.DATA.PROCESS

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

    IF PDF.DATA EQ '' THEN
        PDF.DATA = PDF.HEADER
    END ELSE
        PDF.DATA := O.DATA
    END
    O.DATA = PDF.DATA
RETURN
END
