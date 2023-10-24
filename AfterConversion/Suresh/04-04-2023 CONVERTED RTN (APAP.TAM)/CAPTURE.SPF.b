* @ValidationCode : MjotMTAwMTQ0OTYzNzpDcDEyNTI6MTY4MDYwNTMxMDMyNzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:18:30
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
