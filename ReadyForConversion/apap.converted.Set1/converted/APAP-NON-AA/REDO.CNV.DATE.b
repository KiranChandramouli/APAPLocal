SUBROUTINE REDO.CNV.DATE
*------------------------------------------------------------------------------------------------------
*DESCRIPTION
* conversion routine to display date in MM/DD/YYYY format
*------------------------------------------------------------------------------------------------------
*APPLICATION
* enquiry REDO.E.SEC.TRADE
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
* PROGRAM NAME : REDO.CNV.DATE
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO         REFERENCE         DESCRIPTION
*23.08.2010      Janani     ODR-2011-02-0009 INITIAL CREATION
*
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS
RETURN

*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------
    IF O.DATA THEN
        O.DATA = O.DATA[5,2]:"/":O.DATA[7,2]:"/":O.DATA[1,4]
    END
RETURN
*------------------------------------------------------------
END
