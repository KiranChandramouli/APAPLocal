* @ValidationCode : MjoxMzk1ODg1NDQ4OkNwMTI1MjoxNjgyMzM1OTQ1MDI2OklUU1M6LTE6LTE6LTE6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 REM TO DISPLAY.MESSAGE
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.FR.CL.CLM.AMT.RT
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.REDO.FRONT.CLAIMS
   $USING EB.OverrideProcessing

    Y.AMOUNT = COMI

    IF (Y.AMOUNT GT 99999999.99) THEN
        TEXT = "VALOR MAXIMO PERMITIDO 99,999,999.99"
*        CALL DISPLAY.MESSAGE(TEXT, '') ;* AUTO R22 CODE CONVERSION REM TO DISPLAY.MESSAGE
EB.OverrideProcessing.DisplayMessage(TEXT, '') ;* AUTO R22 CODE CONVERSION REM TO DISPLAY.MESSAGE;* R22 UTILITY AUTO CONVERSION
        ETEXT = TEXT
        CALL STORE.END.ERROR
    END
RETURN
END
