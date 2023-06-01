* @ValidationCode : Mjo4ODU3MjUwMjQ6Q3AxMjUyOjE2ODQyMjI3OTY1MDc6SVRTUzotMTotMToxMDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:09:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 100
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------
    $INSERT I_F.DATES
    EXECUTE 'COPY FROM ../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF TRANSF.OP.CANALES.SF.TXT TO ../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF/TEMP OVERWRITING DELETING'
RETURN
END
