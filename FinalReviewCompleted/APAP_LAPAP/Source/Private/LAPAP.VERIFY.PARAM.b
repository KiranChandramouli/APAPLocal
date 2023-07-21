* @ValidationCode : MjotMTY3MDMwMjE4NTpDcDEyNTI6MTY4OTI0NTk0ODQ5NDp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jul 2023 16:29:08
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
*-----------------------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE		  AUTHOR		         Modification                 DESCRIPTION
*13/07/2023	VIGNESHWARI          MANUAL R22 CODE CONVERSION	     NOCHANGE
*13/07/2023	CONVERSION TOOL      AUTO R22 CODE CONVERSION	   T24.BP is removed in insertfile,'REM' changed to 'DISPLAY.MESSAGE(TEXT, '')'
*---------------------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE LAPAP.VERIFY.PARAM

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ST.LAPAP.CATEGORY.PARAM
    
    
    CUSI = R.NEW(AC.CUSTOMER)
    CATI = R.NEW(AC.CATEGORY)

    FN.ACC = "F.ACCOUNT"
    F.ACC = ""


    CALL LAPAP.VERIFY.CATEGORY.PARAM(CUSI,CATI,RES)


    IF RES NE 1 THEN
        CALL REBUILD.SCREEN
        MESSAGE = "TIPO DE CLIENTE NO CORRESPONDE CON LA CATEGORIA DE CUENTA"
        E = MESSAGE
        CALL DISPLAY.MESSAGE(TEXT, '')
*CALL ERR
        RETURN

    END

RETURN

END
