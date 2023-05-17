SUBROUTINE REDO.APAP.CONV.DES.CONV
*************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: PRADEEP P
* PROGRAM NAME: REDO.APAP.CONV.DES.CONV
* ODR NO      : ODR-2010-03-0088
*----------------------------------------------------------------------
* DESCRIPTION:   This is a conversion routine attached to the Enquiry
*                REDO.APAP.ENQ.REJ.DEBT.DET/REP which converts '$' to '*'
*                in the incoming CATEGORY description value
* IN PARAMETER : O.DATA
* OUT PARAMETER: 0.DATA
* LINKED WITH  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE        WHO           REFERENCE         DESCRIPTION
* 13-Dec-2010  PRADEEP P    ODR-2010-03-0088  INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS
RETURN
*-------
PROCESS:
*-------
    IF O.DATA THEN
        CHANGE '$' TO '*' IN O.DATA
    END
RETURN
END
