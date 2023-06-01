* @ValidationCode : MjotMTQ0NDY4Nzc3NjpDcDEyNTI6MTY4NTAwMDA1NDY1MDpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 May 2023 13:04:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
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
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*25/05/2023      CONVERSION TOOL         AUTO R22 CODE CONVERSION             FM TO @FM, VM TO @VM, SM TO @SM
*25/05/2023      HARISH VIKRAM              MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.VAL.DATE.BOL.RT

    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION - START
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.VERSION
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.ACCOUNT ;*AUTO R22 CODE CONVERSION - END


    GOSUB LOAD
    GOSUB PROCESS
*====
LOAD:
*====

    Y.LOC.REF                  = R.NEW(AC.LCK.LOCAL.REF)
    Y.LOC.REF                  = CHANGE(Y.LOC.REF,@VM,@FM)
    Y.LOC.REF                  = CHANGE(Y.LOC.REF,@SM,@FM)
    Y.DAT.INI                  = Y.LOC.REF<24>
    Y.DAT.END                  = Y.LOC.REF<25>

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)
RETURN

*=======
PROCESS:
*=======
    Y.VAL.INI               = Y.DAT.INI * 1
    Y.VAL.FIN               = Y.DAT.END * 1

    IF Y.VAL.FIN LE Y.VAL.INI THEN
        TEXT = "La fecha final de la meta no puede ser menor o igual que la fecha de inicio."
        ETEXT = TEXT
        E = TEXT
        CALL ERR
    END

RETURN

END
