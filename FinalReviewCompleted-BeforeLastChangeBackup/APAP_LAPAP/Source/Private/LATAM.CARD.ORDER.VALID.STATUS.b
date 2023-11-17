* @ValidationCode : MjotMTkxMDIxNzUzOkNwMTI1MjoxNjg0MjIyODE5Njk1OklUU1M6LTE6LTE6MjAwOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
