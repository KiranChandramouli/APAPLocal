SUBROUTINE REDO.CNV.BROKER.NO
*------------------------------------------------------------------------------------------------------
*DESCRIPTION
* conversion routine to fetch the RNC or CIDENT value from CUSTOMER
*------------------------------------------------------------------------------------------------------
*APPLICATION
* Enquiry REDO.E.SEC.TRADE
*-------------------------------------------------------------------------------------------------------

*
* Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.CNV.RNC
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO         REFERENCE         DESCRIPTION
*23.08.2010      Janani     ODR-2011-02-0009   INITIAL CREATION
*
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS
RETURN

*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------

    O.DATA = FIELD(O.DATA,@VM,1,1)

RETURN
*--------
END
