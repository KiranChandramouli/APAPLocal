* @ValidationCode : MjotMTQyMDA4MDI3MDpDcDEyNTI6MTY4MjA3MzkwMjA2NTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:15:02
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
$PACKAGE APAP.BM
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  $INSERT FILE MODIFIED
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.E.BLD.VAL.SEL(ENQ.DATA)
    $INSERT I_EQUATE ;*R22 AUTO CODE CONVERSION
    $INSERT I_COMMON
    $INSERT I_ENQUIRY.COMMON

    IF NOT(ENQ.DATA<4>) THEN
        ENQ.ERROR = 'EB-SEL.MAND'
        CALL STORE.END.ERROR
        GOSUB END1
    END
RETURN
END1:
END
