SUBROUTINE REDO.E.CONV.CLAIM.DATE
*-----------------------------------------------------------------------------
* DESCRIPTION : A Conversion routine to format the date and is attached to
* six enquiries REDO.ENQ.CLAIM.STATUS.OPEN, REDO.ENQ.CLAIM.STATUS.CLOSE, REDO.ENQ.REQUEST.STATUS.OPEN,
* REDO.ENQ.REQUEST.STATUS.CLOSE, REDO.ENQ.COMPLAINT.STATUS.OPEN, REDO.ENQ.COMPLAINTS.STATUS.CLOSE
*
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : B RENUGADEVI
* PROGRAM NAME : REDO.E.CONV.CLAIM.DATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 25-AUG-2010       BRENUGADEVI        ODR-2009-12-0283  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS
RETURN

********
PROCESS:
********

    Y.ODATA         = O.DATA
    Y.YEAR          = Y.ODATA[1,4]
    Y.MONTH         = Y.ODATA[5,2]
    Y.DATE          = Y.ODATA[7,2]
    Y.COR.DATE      = Y.DATE:"/":Y.MONTH:"/":Y.YEAR
    O.DATA          = Y.COR.DATE
RETURN
END
