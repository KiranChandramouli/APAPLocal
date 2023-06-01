* @ValidationCode : MjotMTg5NTUyOTk4OTpDcDEyNTI6MTY4NDg1Njg3OTIzODpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
