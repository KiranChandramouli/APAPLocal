*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LATAM.CARD.ORDER.VALID.STATUS

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.CARD.STATUS
    $INSERT TAM.BP I_F.LATAM.CARD.ORDER

    FN.LATAM = "F.LATAM.CARD.ORDER"
    F.LATAM = ""

    CARD.ID = ID.NEW
    VERSION.STATUS = COMI

    CALL OPF(FN.LATAM,F.LATAM)
    CALL F.READ(FN.LATAM,CARD.ID,R.LATAM,F.LATAM,LATAM.ERR)
    CARD.STATUS = R.LATAM<CARD.IS.CARD.STATUS>

    IF VERSION.STATUS EQ 94 THEN
        IF CARD.STATUS EQ 51 OR CARD.STATUS EQ 75 OR CARD.STATUS EQ 96 OR CARD.STATUS EQ 94 THEN

            RETURN

        END ELSE

            ETEXT = " EL ESTADO ACTUAL DE ESTE PRODUCTO [":CARD.STATUS:"] NO PERMITE ESTE TIPO DE CAMBIOS [":VERSION.STATUS:"]"
            CALL STORE.END.ERROR
            RETURN

        END


    END


END