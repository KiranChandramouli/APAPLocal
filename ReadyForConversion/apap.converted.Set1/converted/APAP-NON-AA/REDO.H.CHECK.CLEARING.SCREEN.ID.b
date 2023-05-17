SUBROUTINE REDO.H.CHECK.CLEARING.SCREEN.ID
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This is id routine for template REDO.H.CHECK.CLEARING.SCREEN which throws error for
*               improper id inputs
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU
* PROGRAM NAME : REDO.H.CHECK.CLEARING.SCREEN
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date                         Author             Reference                   Description
* 29-JUN-2010                  MARIMUTHU        ODR-2010-02-0290              Initial creation
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER

MAIN:

    GOSUB OPENFILES
    GOSUB PROCESS

OPENFILES:

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    CALL OPF(FN.FT,F.FT)

    FN.TT = 'F.TELLER'
    F.TT = ''
    CALL OPF(FN.TT,F.TT)

RETURN

PROCESS:

    CALL F.READ(FN.FT,ID.NEW,R.FT,F.FT,FT.ERR)
    IF NOT(R.FT) THEN
        CALL F.READ(FN.TT,ID.NEW,R.TT,F.TT,TT.ERR)
        IF NOT(R.TT) THEN
            E = 'EB-INVALID.FT.TT.ID'
            ID.NEW = ''
        END
    END

RETURN

END
