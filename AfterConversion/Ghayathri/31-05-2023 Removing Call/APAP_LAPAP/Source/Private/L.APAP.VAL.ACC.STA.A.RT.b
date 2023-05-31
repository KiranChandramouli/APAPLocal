* @ValidationCode : MjoyMTg5MTA0Nzg6Q3AxMjUyOjE2ODIzMzU5NDQ1NzE6SVRTUzotMTotMTo5NDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
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
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 BP REMOVED
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.ACC.STA.A.RT
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT ;* AUTO R22 CODE CONVERSION  END
    FN.AC = "F.ACCOUNT"
    F.AC = ""

    P.ACCOUNT.ID = COMI
**DEBUG
    CALL F.READ(FN.AC, P.ACCOUNT.ID, R.AC, F.AC, '')

    CALL GET.LOC.REF("ACCOUNT", "L.AC.STATUS",AC.POS)
    Y.ACCOUNT.STATUS = R.AC<AC.LOCAL.REF,AC.POS>
    IF (Y.ACCOUNT.STATUS NE "IM") THEN
** DEBUG
        TEXT = "CUENTA INVALIDA, CODIGO ESTATUS DIFERENTE (IM) : " : Y.ACCOUNT.STATUS
**CALL REM
**ETEXT = TEXT
        E = TEXT
** CALL ERR
**CALL STORE.END.ERROR
    END
RETURN
END
