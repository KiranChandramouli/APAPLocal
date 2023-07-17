* @ValidationCode : MjotMjAyNDgxNzIwNjpDcDEyNTI6MTY4OTMyMTE1MjQ5NTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Jul 2023 13:22:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion             Nochange
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.L.ATH.TERM.LOC.NAME(Y.ATH.ID)

    $INSERT I_COMMON ;*R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.ATH.SETTLMENT
    $INSERT I_REDO.L.ATH.TERM.LOC.NAME.COMMON ;*R22 Auto Conversion - End


    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    R.REDO.ATH.SETTLEMENT=''; Y.ERR = ''; Y.ATM.CITY.STATE = ''
    Y.TERM.LOC.VAL = ''; Y.TERM.OWN.NAME = ''; Y.TERM.ID = ''
RETURN

PROCESS:
********
    CALL F.READ(FN.REDO.ATH.SETTLMENT,Y.ATH.ID,R.REDO.ATH.SETTLEMENT,F.REDO.ATH.SETTLMENT,Y.ERR)
    IF NOT(R.REDO.ATH.SETTLEMENT) THEN
        RETURN
    END

    Y.TERM.LOC.VAL = R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.LOC.NAME>
    IF Y.TERM.LOC.VAL THEN
        R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.LOC.NAME>=UTF8(Y.TERM.LOC.VAL)
    END

    Y.TERM.OWN.NAME = R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.OWNER.NAME>
    IF Y.TERM.OWN.NAME THEN
        R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.OWNER.NAME>=UTF8(Y.TERM.OWN.NAME)
    END

    Y.TERM.ID = R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.FIID>
    IF Y.TERM.ID THEN
        R.REDO.ATH.SETTLEMENT<ATH.SETT.TERM.FIID>=UTF8(Y.TERM.ID)
    END

    Y.ATM.CITY.STATE = R.REDO.ATH.SETTLEMENT<ATH.SETT.ATM.CITY.STATE>
    IF Y.ATM.CITY.STATE THEN
        R.REDO.ATH.SETTLEMENT<ATH.SETT.ATM.CITY.STATE>=UTF8(Y.ATM.CITY.STATE)
    END
    CALL F.WRITE(FN.REDO.ATH.SETTLMENT,Y.ATH.ID,R.REDO.ATH.SETTLEMENT)

RETURN
END
