* @ValidationCode : MjotMTAwMTQ0OTYzNzpDcDEyNTI6MTY4NDg0MTg1NDQzMzpJVFNTOi0xOi0xOjI5ODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:07:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 298
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*04/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             K TO K.VAR
*04/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------


PROGRAM CAPTURE.SPF

    $INSERT I_COMMON
    $INSERT I_EQUATE

    SEL.CMD = "LIST F.SPF"
    OPEN "TAM.BP" TO F.TAM THEN
        K.VAR = 1 ;*AUTO R22 CODE CONVERSION
    END

    EXECUTE SEL.CMD CAPTURING SEL.RET

    WRITE SEL.RET TO F.TAM,"CURRENT.SPF" ON ERROR
        K.VAR = -1 ;*AUTO R22 CODE CONVERSION
    END

END
