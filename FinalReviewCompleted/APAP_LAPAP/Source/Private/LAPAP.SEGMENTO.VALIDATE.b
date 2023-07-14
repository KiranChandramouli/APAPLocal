* @ValidationCode : MjoyMTM0NzA0NDM6Q3AxMjUyOjE2ODQyMjI4MTU2OTY6SVRTUzotMTotMToxOTA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 190
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
