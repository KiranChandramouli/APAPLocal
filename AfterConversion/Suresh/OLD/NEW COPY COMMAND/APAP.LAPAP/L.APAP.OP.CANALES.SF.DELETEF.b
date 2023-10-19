* @ValidationCode : Mjo5MzA3NTUwNzpDcDEyNTI6MTY5Mjk0Nzc2MDA5MDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Aug 2023 12:46:00
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
SUBROUTINE L.APAP.OP.CANALES.SF.DELETEF
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - Include to Insert and T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - PATH IS MODIFIED
*------------------------------------------------------------------------
    $INSERT I_F.DATES
*  EXECUTE 'COPY FROM ../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF TRANSF.OP.CANALES.SF.TXT TO ../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF/TEMP OVERWRITING DELETING' ;*R22 Manual Conversion PATH IS MODIFIED
    EXECUTE 'SH -c cp ../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF/TRANSF.OP.CANALES.SF.TXT  ../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF/TEMP OVERWRITING DELETING'
RETURN
END
