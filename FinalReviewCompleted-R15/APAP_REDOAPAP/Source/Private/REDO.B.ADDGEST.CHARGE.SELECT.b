* @ValidationCode : Mjo3OTQwNjMwNjM6Q3AxMjUyOjE2ODUwNzk3NjUzNzc6SVRTUzotMTotMToxMDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 May 2023 11:12:45
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
$PACKAGE APAP.REDOAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*25/05/2023      CONVERSION TOOL         AUTO R22 CODE CONVERSION                NOCHANGE
*25/05/2023      HARISH VIKRAM              MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.B.ADDGEST.CHARGE.SELECT
*-----------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.ADDGEST.CHARGE.COMMON

    CALL F.READ(FN.SL,'REDO.AA.LOAN',ID.LIST,F.SL,RET.ERROR)
    IF ID.LIST NE '' THEN
        LIST.PARAM = ''
        CALL BATCH.BUILD.LIST(LIST.PARAM,ID.LIST)
    END

RETURN
END
