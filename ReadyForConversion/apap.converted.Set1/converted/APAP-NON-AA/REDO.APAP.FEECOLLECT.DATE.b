SUBROUTINE REDO.APAP.FEECOLLECT.DATE
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RIYAS
* PROGRAM NAME: REDO.APAP.FEECOLLECT.DATE
*----------------------------------------------------------------------
*IN PARAMETER : NA
*OUT PARAMETER: NA
*LINKED WITH  : REDO.APAP.FEECOLLECT.DATE
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
* DATE           WHO           REFERENCE         DESCRIPTION
*28.10.2011     RIYAS      ODR-2010-08-0017    INITIAL CREATION
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.FEECOLLECT

    FN.REDO.FEECOLLECT = 'F.REDO.FEECOLLECT'
    F.REDO.FEECOLLECT = ''
    CALL OPF(FN.REDO.FEECOLLECT,F.REDO.FEECOLLECT)
    Y.TODAY= TODAY[5,4]
    R.NEW(REDO.FEE.EVENT.DATE)= Y.TODAY

RETURN
