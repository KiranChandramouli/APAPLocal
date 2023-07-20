* @ValidationCode : MjotMTMzNTU5MTkzNTpDcDEyNTI6MTY4OTgzMzU2NjYyODpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Jul 2023 11:42:46
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
SUBROUTINE LAPAP.ASA.L.V.RT.LOAD

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 20-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts and Removed brackets

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ST.L.APAP.ASAMBLEA.PARTIC
    $INSERT I_LAPAP.ASA.L.V.COMMON

    GOSUB OPENER.EXEC
RETURN

OPENER.EXEC:
    FN.PA = "FBNK.ST.L.APAP.ASAMBLEA.PARTIC"
    FV.PA = ""
    CALL OPF(FN.PA,F.PA)

    EXECUTE "CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.VOTANTE"        ;*R22 Manual Conversion - Removed brackets
    EXECUTE "CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.VOTANTE$HIS"	;*R22 Manual Conversion - Removed brackets
    EXECUTE "CLEAR.FILE FBNK.ST.L.APAP.ASAMBLEA.VOTANTE$NAU"	;*R22 Manual Conversion - Removed brackets
RETURN
END
