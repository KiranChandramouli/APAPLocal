* @ValidationCode : MjotMTg5NTUyOTk4OTpDcDEyNTI6MTY4MTEyMjQzMzAxNDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 15:57:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*10-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*10-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*-----------------------------------------------------------------------------
SUBROUTINE DR.REGN22.RCL.MARKET.TYPE
    $INSERT I_COMMON
    $INSERT I_EQUATE

    MKT.TYPE = COMI
    BEGIN CASE
        CASE MKT.TYPE EQ 'S'
            MKT.TYPE = 'SP'
        CASE MKT.TYPE EQ 'F'
            MKT.TYPE = 'FD'
        CASE MKT.TYPE EQ 'N'
            MKT.TYPE = 'ND'
    END CASE

    COMI = MKT.TYPE

RETURN
END
