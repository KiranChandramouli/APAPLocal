* @ValidationCode : MjotMjA5MDcyMDY4OTpDcDEyNTI6MTY5MTU4NDI2NzgwMTp2aWN0bzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Aug 2023 18:01:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*09-08-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.VAL.DIF.BOLS.RT

    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.VERSION
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.ACCOUNT ;*R22 MANUAL CONVERSION END


    GOSUB LOAD
    GOSUB PROCESS
*====
LOAD:
*====
    Y.BOL.DEBIT                = ID.NEW
    Y.MONTO.BOL                = R.NEW(AC.LCK.LOCKED.AMOUNT)
    Y.ACCOUNT                  = R.NEW(AC.LCK.ACCOUNT.NUMBER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)
RETURN

*=======
PROCESS:
*=======

    R.AC.LOCK = ''; AC.LOCK.ERR = ''
    CALL F.READ(FN.AC.LOCKED.EVENTS,Y.BOL.DEBIT,R.AC.LOCK,F.AC.LOCKED.EVENTS,AC.LOCK.ERR)

    Y.MON.REAL         = R.AC.LOCK<AC.LCK.LOCKED.AMOUNT>

    R.ACC = ''; ACC.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACC,F.ACCOUNT,ACC.ERR)
    ACC.POS = '';
    CALL GET.LOC.REF("ACCOUNT","L.AC.AV.BAL",ACC.POS)
    Y.ACC.BAL               = R.ACC<AC.LOCAL.REF,ACC.POS>

    Y.DIFERENCIA            = Y.MONTO.BOL - Y.MON.REAL

    IF Y.DIFERENCIA GT Y.ACC.BAL THEN
        TEXT = "La cuenta numero: ":Y.ACCOUNT:" no posee fondos suficientes. Fondos actuales de la cuenta: ":Y.ACC.BAL
        ETEXT = TEXT
        E = TEXT
        CALL ERR
    END

RETURN

END
