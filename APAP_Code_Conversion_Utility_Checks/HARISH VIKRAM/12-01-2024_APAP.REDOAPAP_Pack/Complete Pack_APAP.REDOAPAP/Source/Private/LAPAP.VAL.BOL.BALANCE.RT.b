* @ValidationCode : Mjo0MjU4MjczOTI6Q3AxMjUyOjE3MDMxNTcyMzMwODg6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Dec 2023 16:43:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*25-05-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED
*25-05-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*21-12-2023  HARISHVIKRAM          R22 Manual Conversion   GET.LOC.REF changed
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.VAL.BOL.BALANCE.RT

    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.VERSION
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.ACCOUNT ;*R22 AUTO CONVERSION END
    $USING EB.LocalReferences


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
*    CALL GET.LOC.REF("ACCOUNT","L.AC.AV.BAL",ACC.POS)
    EB.LocalReferences.GetLocRef("ACCOUNT","L.AC.AV.BAL",ACC.POS)   ;*R22 Manual Conversion
    Y.ACC.BAL               = R.ACC<AC.LOCAL.REF,ACC.POS>

    IF Y.MONTO.BOL GE Y.ACC.BAL THEN
        TEXT = "La cuenta numero ":Y.ACCOUNT:" no posee fondos suficientes. Fondos actuales de la cuenta: ":Y.ACC.BAL
        ETEXT = TEXT
        E = TEXT
        CALL ERR
    END

RETURN

END
