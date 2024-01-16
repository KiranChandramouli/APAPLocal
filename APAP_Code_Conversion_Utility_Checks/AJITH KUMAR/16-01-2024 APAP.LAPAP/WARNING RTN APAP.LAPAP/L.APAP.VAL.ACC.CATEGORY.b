* @ValidationCode : MjotMTczMzEyMjg0MTpDcDEyNTI6MTY4MjMzNTk0NDUzMDpJVFNTOi0xOi0xOjE5NzoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 197
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                REM TO DISPLAY.MESSAGE(TEXT, '') , BP REMOVED
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*------------------------------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.ACC.CATEGORY
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT ;* AUTO R22 CODE CONVERSION END
   $USING EB.OverrideProcessing
    FN.AC = "F.ACCOUNT"
    F.AC = ""
    VarAC = COMI
*DEBUG
    CALL F.READ(FN.AC, VarAC, R.AC, F.AC, '')
    VarCategory = R.AC<AC.CATEGORY>
    IF (VarCategory[1,2] EQ "66" OR VarCategory[1,1] EQ "3") THEN
*DEBUG
        TEXT = "CUENTA INVALIDA"
*        CALL DISPLAY.MESSAGE(TEXT, '') ;* AUTO R22 CODE CONVERSION REM TO DISPLAY.MESSAGE(TEXT, '')
EB.OverrideProcessing.DisplayMessage(TEXT, '') ;* AUTO R22 CODE CONVERSION REM TO DISPLAY.MESSAGE(TEXT, '');* R22 UTILITY AUTO CONVERSION
        ETEXT = TEXT
        PRINT E
        CALL STORE.END.ERROR
    END
RETURN
END
