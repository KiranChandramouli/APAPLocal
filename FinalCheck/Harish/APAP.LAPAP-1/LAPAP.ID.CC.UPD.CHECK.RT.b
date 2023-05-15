* @ValidationCode : MjotMjEwMzY4MzMzNTpDcDEyNTI6MTY4MjA3MDAzNjQ2MDpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:10:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.ID.CC.UPD.CHECK.RT
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE               WHO                REFERENCE           DESCRIPTION

* 21-APR-2023   Conversion tool       R22 Auto conversion     BP is removed in Insert File
* 21-APR-2023    Narmadha V           R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------


    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE ;*R22 Auto conversion - END


    IF V$FUNCTION EQ 'S' THEN
        RETURN
    END

    FN.APP = 'FBNK.ST.LAPAP.MOD.DIRECCIONES'
    F.APP =''
    CALL OPF(FN.APP,F.APP)

    Y.REC.ID = V$DISPLAY

    CALL F.READ(FN.APP,Y.REC.ID,R.CC,F.APP,ERR.CC)

    IF R.CC NE '' THEN
        E = 'OPERACION NO PERMITIDA'
*TEXT = E
*CALL REM
    END
*DEBUG
RETURN

END
