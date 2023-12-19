* @ValidationCode : MjotMjQxNDE1NzMzOkNwMTI1MjoxNjgxMjAyMzY1MDY0OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 14:09:25
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

*Description:
* This routine is attached to the Customer versions for create a new customer record and return appropriate error msgs
*================================================================================================================
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : V.APAP.CUST.MNEMONIC.FILL
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 11.06.2010      SUDHARSANAN S     ODR-2010-03-0128  INITIAL CREATION
* 11.04.2023      Conversion Tool       R22            Auto Conversion     - FM TO @FM
* 11.04.2023      Shanmugapriya M       R22            Manual Conversion   - No changes
*
* ----------------------------------------------------------------------------------------------------
*===================================================================================================================
$PACKAGE APAP.TAM
SUBROUTINE V.APAP.CUST.MNEMONIC.FILL

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

INITIALISE:

    CUST.MNEMONIC = ""
RETURN

PROCESS:
    CUST.MNEMONIC = R.NEW(EB.CUS.MNEMONIC)
    IF (LEN(ID.NEW) GE 1) AND (LEN(ID.NEW) LE 9) THEN
        IF CUST.MNEMONIC EQ '' AND ID.NEW NE '' THEN
            R.NEW(EB.CUS.MNEMONIC) = 'A':ID.NEW
        END
    END ELSE
        E = "EB-CUST.MNEMONIC":@FM:ID.NEW
    END
RETURN
END
