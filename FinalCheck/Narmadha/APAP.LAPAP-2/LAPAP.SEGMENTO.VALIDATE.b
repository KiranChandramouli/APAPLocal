* @ValidationCode : MjoyMTM0NzA0NDM6Q3AxMjUyOjE2ODIwNjk3Njc1NDI6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:06:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.SEGMENTO.VALIDATE
*----------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON    ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT JBC.h
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.VERSION    ;*R22 AUTO CODE CONVERSION.END

    GOSUB LOAD.APLICATIONS
    GOSUB VALIDATE.SEGMENTO

LOAD.APLICATIONS:

    FN.EB.LOOKUP = 'F.EB.LOOKUP'; F.EB.LOOKUP = ''
    CALL OPF (FN.EB.LOOKUP,F.EB.LOOKUP)

    Y.SEGMENTO                = ID.NEW
RETURN

VALIDATE.SEGMENTO:

    Y.SEGMENTO.ID             = "SEGMENTO*":Y.SEGMENTO
    R.LOOKUP =''; LOOKUP.ERR ='';
    CALL F.READ(FN.EB.LOOKUP,Y.SEGMENTO.ID,R.LOOKUP,F.EB.LOOKUP,LOOKUP.ERR)
    IF NOT (R.LOOKUP) THEN

        MESSAGE = "EL SEGMENTO ":Y.SEGMENTO:" NO ES VALIDO"
        E = MESSAGE
        ETEXT = E
        CALL ERR
        RETURN

    END
RETURN
END
