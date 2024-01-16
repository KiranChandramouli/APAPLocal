* @ValidationCode : MjoxNzYxNzExNjA2OkNwMTI1MjoxNjgyMzM1OTQ0NTAwOklUU1M6LTE6LTE6OTQ6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 94
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                REM TO DISPLAY.MESSAGE(TEXT, '')
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*---------------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.ACC.BAL.CE
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
   $USING EB.OverrideProcessing
    FN.AC = "F.ACCOUNT"
    F.AC = ""
*DEBUG
    VarAC = COMI
*DEBUG
*CALL F.READ(FN.AC, VarAC, R.AC, F.AC, '')
*VarBalance = R.AC<AC.ONLINE.ACTUAL.BAL>
    VarBalance = VarAC
    IF (VarBalance NE 0 AND VarBalance NE '') THEN
*DEBUG
        TEXT = "CUENTA INVALIDA, BALANCE NO ES CERO"
*        CALL DISPLAY.MESSAGE(TEXT, '') ;* AUTO R22 CODE CONVERSION REM TO DISPLAY.MESSAGE(TEXT, '')
EB.OverrideProcessing.DisplayMessage(TEXT, '') ;* AUTO R22 CODE CONVERSION REM TO DISPLAY.MESSAGE(TEXT, '');* R22 UTILITY AUTO CONVERSION
        ETEXT = TEXT
        PRINT E
        CALL STORE.END.ERROR
    END
RETURN
END
