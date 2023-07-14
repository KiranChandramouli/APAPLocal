* @ValidationCode : MjoxOTI3NzAyNzc4OkNwMTI1MjoxNjgwNzE1OTg2MDU5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 23:03:06
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.CARDS.EXPIRY.DATE
************************************************************
*----------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Description   : This subroutine is attached as a conversion routine in the Enquiry REDO.CUR.ACCT.DET
*                 to get the no of associated card with the account
* Linked with   : Enquiry  REDO.CUR.ACCT.DET as conversion routine
* In Parameter  : None
* Out Parameter : None
*-----------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE                   WHO           REFERENCE             DESCRIPTION
*10.07.2010        PRABHU N           ODR-2010-08-0031     INITIAL CREATION
* 06.04.2023       Conversion Tool       R22               Auto Conversion     - New condition added
* 06.04.2023       Shanmugapriya M       R22               Manual Conversion   - No changes
*
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    O.DATA =System.getVariable('CURRENT.CARD')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN       ;** R22 Auto Conversion - Start
        O.DATA = ""
    END                                      ;** R22 Auto Conversion - End
    
RETURN
END
