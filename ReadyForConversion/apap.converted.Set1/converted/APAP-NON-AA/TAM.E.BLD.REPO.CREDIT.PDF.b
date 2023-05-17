SUBROUTINE TAM.E.BLD.REPO.CREDIT.PDF(ENQ.DATA)
*-----------------------------------------------------------------------------

*Company   Name    : APAP
*Developed By      : Temenos Application Management
*Program   Name    : AM.E.BLD.REPO.CREDIT.PDF

*---------------------------------------------------------------------------------------------------

*Description       : This is the Build routine to reset the glodal variables.
*In  Parameter     : ENQ.DATA
*Out Parameter     : ENQ.DATA
*ODR Number        : ODR-2010-08-0031

*---------------------------------------------------------------------------------------------------
*Modification History:
*---------------------------------------------------------------------------------------------------
*    Initial Development for APAP
*---------------------------------------------------------------------------------------------------
*Insert Files
*---------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_ENQ.SES.VAR.CREDIT.COMMON

    PDF.CREDIT.HEADER = ''
    PDF.CREDIT.DATA = ''
RETURN
END
