SUBROUTINE REDO.E.GET.CARD
*---------------------------------------------------------------------------------
* This is aenquiry for listing all the credit cards of the customer
*this enquiry will fetch the data from sunnel interface
*---------------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : Prabhu N
* Program Name   : REDO.E.GET.CARD.LIST
* ODR NUMBER     : SUNNEL-CR
* LINKED WITH    : ENQUIRY-REDO.CCARD.LIST
*---------------------------------------------------------------------------------
*IN = N/A
*OUT = Y.FINAL.ARRAY
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*3.12.2010     ODR-2010-11-0211       Prabhu N                Initial creation
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    O.DATA=System.getVariable('CURRENT.CARD.NO')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        O.DATA = ""
    END

RETURN
END
*------------------------------*END OF SUBROUTINE*--------------------------------
