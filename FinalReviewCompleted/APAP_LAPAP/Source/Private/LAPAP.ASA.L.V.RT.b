* @ValidationCode : MjotMTQ0MjI3ODkyNzpDcDEyNTI6MTY5MDE2NzUzOTgxNTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
