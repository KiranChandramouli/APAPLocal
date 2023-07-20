* @ValidationCode : MjotMTQ0MjI3ODkyNzpDcDEyNTI6MTY4OTIyNzAwMzQwODpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jul 2023 11:13:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.ASA.L.V.RT(PARTICIPANTE)

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 20-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts 

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ST.L.APAP.ASAMBLEA.PARTIC
    $INSERT I_LAPAP.ASA.L.V.COMMON

    GOSUB EJECUTAR.LIMPIEZA.1


EJECUTAR.LIMPIEZA.1:

    Y.TABLA = FN.PA
    Y.PUNTERO = F.PA

    CALL OCOMO("TABLA: " : Y.TABLA)
    CALL OCOMO("PUNTERO: " : Y.PUNTERO)
    CALL F.READ(FN.PA,PARTICIPANTE,R.PA, F.PA, PA.ERR)
    IF R.PA NE '' THEN
        R.PA<ST.L.APA.CUENTA.PARTICIPO> = ''
        R.PA<ST.L.APA.CLIENTE.PARTICIPO> = ''

        CALL F.WRITE(FN.PA, PARTICIPANTE, R.PA)
        CALL JOURNAL.UPDATE(PARTICIPANTE)

    END

RETURN
END
