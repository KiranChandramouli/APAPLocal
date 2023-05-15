* @ValidationCode : MjotMTkxMDIxNzUzOkNwMTI1MjoxNjgyMzE2MDEyNDAyOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 11:30:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LATAM.CARD.ORDER.VALID.STATUS
*----------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*24-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON    ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.CARD.STATUS
    $INSERT I_F.LATAM.CARD.ORDER    ;*R22 AUTO CODE CONVERSION.END

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
