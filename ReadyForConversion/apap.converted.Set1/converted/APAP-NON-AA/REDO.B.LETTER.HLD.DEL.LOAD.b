SUBROUTINE REDO.B.LETTER.HLD.DEL.LOAD
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.B.LETTER.HLD.DEL.LOAD
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is the Load Routine  to delete the record that is in
*status HOLD



*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*18.03.2010  H GANESH     ODR-2009-10-0838   INITIAL CREATION
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LETTER.ISSUE
    $INSERT I_REDO.B.LETTER.HLD.DEL.COMMON

    GOSUB INIT
RETURN


*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

    FN.REDO.LETTER.ISSUE='F.REDO.LETTER.ISSUE$NAU'
    F.REDO.LETTER.ISSUE=''

RETURN
END
