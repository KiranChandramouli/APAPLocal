* @ValidationCode : Mjo4MTc1OTUyOTQ6Q3AxMjUyOjE2ODQyMjI4MTA5MTY6SVRTUzotMTotMTo5ODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 98
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.LIMITE.CURRENCY.PARAM
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.LIMITE.CURRENCY.PARAM
* Date           : 2019-1017
* Item ID        :
*========================================================================
* Brief description :
* -------------------
* type : ID ROUTINE
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-05-04     Richard HC                Initial Development
* 21-APR-2023    Conversion tool           R22 Auto conversion     BP is removed in Insert File
* 21-APR-2023    Narmadha V                R22 Manual Conversion    No Changes
*========================================================================
* Content summary :
* =================
* Table name     :
* Auto Increment :
* Views/versions :
* EB record      :
* Routine        :
*========================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CURRENCY


    FN.CURR = "F.CURRENCY"
    F.CURR = ""
    CALL OPF(FN.CURR,F.CURR)

    ID = V$DISPLAY

    CALL CACHE.READ(FN.CURR, ID, R.CURR, ERR) ;*R22 Auto conversion

    IF ERR THEN
        E = 'INGRESE UN TIPO DE MONEDA VALIDO  - Ejemplo: [ USD | EUR | JPY |ETC... ]'
    END

*   CALL System.setVariable('CURRENT.OLD.RECORD.ID',ID)

RETURN


END
