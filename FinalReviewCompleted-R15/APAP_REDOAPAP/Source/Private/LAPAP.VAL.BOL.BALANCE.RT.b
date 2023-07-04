* @ValidationCode : Mjo0ODgyODM4MTg6Q3AxMjUyOjE2ODUwMTUyMzIyNzc6dmljdG86LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 May 2023 17:17:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*25-05-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED
*25-05-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.VAL.BOL.BALANCE.RT

    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.VERSION
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.ACCOUNT ;*R22 AUTO CONVERSION END


    GOSUB LOAD
    GOSUB PROCESS
*====
LOAD:
*====

    Y.MONTO.BOL                = R.NEW(AC.LCK.LOCKED.AMOUNT)
    Y.ACCOUNT                  = R.NEW(AC.LCK.ACCOUNT.NUMBER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN

*=======
PROCESS:
*=======

    R.ACC = ''; ACC.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACC,F.ACCOUNT,ACC.ERR)
    ACC.POS = '';
    CALL GET.LOC.REF("ACCOUNT","L.AC.AV.BAL",ACC.POS)
    Y.ACC.BAL               = R.ACC<AC.LOCAL.REF,ACC.POS>

    IF Y.MONTO.BOL GE Y.ACC.BAL THEN
        TEXT = "La cuenta numero ":Y.ACCOUNT:" no posee fondos suficientes. Fondos actuales de la cuenta: ":Y.ACC.BAL
        ETEXT = TEXT
        E = TEXT
        CALL ERR
    END

RETURN

END
