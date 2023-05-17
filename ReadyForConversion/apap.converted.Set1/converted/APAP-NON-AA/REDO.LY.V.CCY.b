SUBROUTINE  REDO.LY.V.CCY
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the currency in REDO.LY.MODALITY application.
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.V.CCY
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*16.11.2011    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.MODALITY

    IF VAL.TEXT THEN
        GOSUB PROCESS
    END

RETURN

********
PROCESS:
*******

    Y.TYPE = R.NEW(REDO.MOD.TYPE)
    Y.CCY = R.NEW(REDO.MOD.CURRENCY)

    T(REDO.MOD.APP.TXN)<3> = 'NOINPUT'

*    IF Y.CCY EQ '' THEN
    IF Y.CCY EQ '' AND Y.TYPE NE '7' THEN
        AF = REDO.MOD.CURRENCY
        ETEXT = 'EB-REDO.CHECK.FIELDS':@FM:Y.TYPE
        CALL STORE.END.ERROR
    END

RETURN

END
