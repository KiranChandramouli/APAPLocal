SUBROUTINE REDO.ENQ.CONV.SPACES
*------------------------------------------------------------------------------------------------------
*DESCRIPTION
* returns the list of IDs that is created to fetch stock register ID

*------------------------------------------------------------------------------------------------------
*APPLICATION
* build routine to be attached in the enquiry REDO.CARD.STOCK.REGISTER
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.ENQ.CONV.SPACES
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO               REFERENCE         DESCRIPTION
*17.07.2012      balagurunathan     ODR-2010-08-0469   INITIAL CREATION
*
* ----------------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    Y.VAL=O.DATA
    Y.VAL=FIELD(Y.VAL," ",1)
    O.DATA=Y.VAL



RETURN

END
