* @ValidationCode : MjoxNDQ1OTUxNDkwOkNwMTI1MjoxNjg0MTM4MTE1OTI1OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 May 2023 13:38:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.BM
SUBROUTINE REDO.E.BLD.VAL.SEL(ENQ.DATA)
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  $INSERT FILE MODIFIED
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------


    
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
