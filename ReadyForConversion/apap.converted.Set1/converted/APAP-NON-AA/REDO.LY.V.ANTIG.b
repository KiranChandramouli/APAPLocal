SUBROUTINE  REDO.LY.V.ANTIG
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the antiquity to be considered
*              based on the event type and event in the REDO.LY.MODALITY table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.V.ANTIG
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*24.11.2011    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.MODALITY

    IF VAL.TEXT THEN
        GOSUB PROCESS
    END

RETURN

*-------
PROCESS:
*-------

    Y.TYPE = R.NEW(REDO.MOD.TYPE)
    Y.EVENT = R.NEW(REDO.MOD.EVENT)

    IF Y.TYPE EQ '6' AND Y.EVENT EQ '5' THEN
        Y.ANTIG = R.NEW(REDO.MOD.ANTIG)
        T(REDO.MOD.PRODUCT.GROUP)<3> = 'NOINPUT'
        IF Y.ANTIG EQ '' THEN
            AF = REDO.MOD.ANTIG
            ETEXT = 'EB-REDO.LY.V.ANTIG'
            CALL STORE.END.ERROR
        END
    END

RETURN

END
