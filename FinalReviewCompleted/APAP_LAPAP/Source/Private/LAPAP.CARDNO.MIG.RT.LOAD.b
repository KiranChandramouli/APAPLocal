* @ValidationCode : Mjo2OTQyMzE5NTM6Q3AxMjUyOjE2OTI4ODE3MDU4NTM6SVRTUzotMTotMToyOTQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Aug 2023 18:25:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 294
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.CARDNO.MIG.RT.LOAD
*--------------------------------------------------------------------------------------------------------
*MODIFICATION HISTORY
* Date                  Who                    Reference                        Description
* ----                  ----                     ----                              ----
* 09-08-2023           Samaran T         R22 Manual Code Conversion     BP is removed from insert file.
*-------------------------------------------------------------------------------------------------------------
    $INSERT I_EQUATE ; * R22 MANUAL CODE CONVERSION.START
    $INSERT I_F.COMPANY
    $INSERT I_F.LAPAP.BIN.SEQ.CTRL
    $INSERT I_F.LAPAP.CARD.GEN.CARDS
    $INSERT I_F.REDO.CARD.NUMBERS
    $INSERT I_LAPAP.CARDNO.MIG.COMMON ; * R22 MANUAL CODE CONVERSION.END

    GOSUB OPENER

RETURN

OPENER:
    FN.BIN.CTRL = "F.ST.LAPAP.BIN.SEQ.CTRL"
    F.BIN.CTRL = ""
    CALL OPF(FN.BIN.CTRL , F.BIN.CTRL)

    FN.GEN.CARDS = 'F.ST.LAPAP.CARD.GEN.CARDS'
    F.GEN.CARDS = ''
    CALL OPF(FN.GEN.CARDS,F.GEN.CARDS)

    FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
    F.REDO.CARD.NUMBERS = ''
    CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

    FN.ST.LAPAP.BIN.CTRL.TEMP = 'F.ST.LAPAP.BIN.CTRL.TEMP'
    F.ST.LAPAP.BIN.CTRL.TEMP = ''
*CALL OPF(FN.ST.LAPAP.BIN.CTRL.TEMP,F.ST.LAPAP.BIN.CTRL.TEMP)

    Y.BIN.CTRL.ARR = ''
RETURN
END
