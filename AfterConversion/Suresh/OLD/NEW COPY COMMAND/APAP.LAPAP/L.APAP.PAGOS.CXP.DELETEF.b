* @ValidationCode : MjotMTQ2NjYxNDM1MTpDcDEyNTI6MTY5Mjk0Nzk1MjA2MDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Aug 2023 12:49:12
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
SUBROUTINE L.APAP.PAGOS.CXP.DELETEF
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 13-APRIL-2023      Harsha                R22 Manual Conversion - PATH IS MODIFIED
*------------------------------------------------------------------------
*    EXECUTE 'COPY FROM ../interface/FLAT.INTERFACE/PAGOS.CXP PAGOS.CXP.TXT TO ../interface/FLAT.INTERFACE/PAGOS.CXP/TEMP OVERWRITING DELETING' ;*R22 Manual Conversion PATH IS MODIFIED
    EXECUTE 'SH -c cp ../interface/FLAT.INTERFACE/PAGOS.CXP/PAGOS.CXP.TXT ../interface/FLAT.INTERFACE/PAGOS.CXP/TEMP OVERWRITING DELETING'
    
RETURN
 
END
