* @ValidationCode : MjotMTMzNTU5MTkzNTpDcDEyNTI6MTY5MDE2NzUzOTc4NDpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
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
