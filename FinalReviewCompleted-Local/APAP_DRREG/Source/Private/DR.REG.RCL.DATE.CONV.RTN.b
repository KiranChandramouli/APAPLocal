* @ValidationCode : MjotMTg0Mjc3NDQyODpDcDEyNTI6MTY4MDY4MTA4ODUxNzphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:21:28
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
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE DR.REG.RCL.DATE.CONV.RTN
    $INSERT I_COMMON
    $INSERT I_EQUATE

    OPEN.DATE = COMI
    IF OPEN.DATE THEN
        FORM.OPEN.DATE = OPEN.DATE[7,2]:'/':OPEN.DATE[5,2]:'/':OPEN.DATE[1,4]
        COMI = FORM.OPEN.DATE
    END ELSE
        COMI = ''
    END
RETURN
END
