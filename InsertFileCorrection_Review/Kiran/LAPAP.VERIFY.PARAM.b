* @ValidationCode : MjotNzQ4MDM0NzY5OkNwMTI1MjoxNjg4MzYxNDM5OTQ0OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 Jul 2023 10:47:19
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
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                           AUTHOR                          Modification                 DESCRIPTION
*03/07/2023                    VIGNESHWARI              MANUAL R22 CODE CONVERSION             T24.BP is removed in insertfile
*03/07/2023                 CONVERSION TOOL             AUTO R22 CODE CONVERSION               NOCHANGE
*-----------------------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.VERIFY.PARAM

    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.CUSTOMER
    $INSERT  I_F.ACCOUNT
*    $INSERT BP I_F.ST.LAPAP.CATEGORY.PARAM

    CUSI = R.NEW(AC.CUSTOMER)
    CATI = R.NEW(AC.CATEGORY)

    FN.ACC = "F.ACCOUNT"
    F.ACC = ""


    CALL LAPAP.VERIFY.CATEGORY.PARAM(CUSI,CATI,RES)


    IF RES NE 1 THEN
        CALL REBUILD.SCREEN
        MESSAGE = "TIPO DE CLIENTE NO CORRESPONDE CON LA CATEGORIA DE CUENTA"
        E = MESSAGE
        CALL REM
*CALL ERR
        RETURN

    END

RETURN

END
