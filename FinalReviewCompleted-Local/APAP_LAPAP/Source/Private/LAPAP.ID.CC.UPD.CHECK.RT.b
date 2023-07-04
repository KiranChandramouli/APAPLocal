* @ValidationCode : MjotMjEwMzY4MzMzNTpDcDEyNTI6MTY4NDIyMjgxMDAzNTpJVFNTOi0xOi0xOjE5NzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 197
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
