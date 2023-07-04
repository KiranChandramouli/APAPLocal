* @ValidationCode : MjoxMTQ3Mjg1MDkxOkNwMTI1MjoxNjgxMjkzODQ5MTkwOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 15:34:09
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.DS.REPAY.DEPOSIT(Y.MULTI)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* display the field description of EB.LOOKUP instead of the ID.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 16-SEP-2011         RIYAS      ODR-2011-07-0162     Initial Creation

*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  IF STATEMENT ADDED , VM to @VM
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.LOOKUP
    $INSERT I_System
    $INSERT I_F.AZ.ACCOUNT
    GOSUB INITIALSE
    GOSUB CHECK.NOTES

RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~


RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~
    Y.CURRENT.VALUE.DATE = 'FECHA:':System.getVariable("CURRENT.VALUE.DATE")
    Y.CURRENT.TITLE = ' A NOMBRE DE ':System.getVariable("CURRENT.TITLE")
    Y.CURRENT.ACCT.NO = 'CUENTA:':System.getVariable("CURRENT.ACCT.NO"):Y.CURRENT.TITLE
    Y.CURRENT.TOTAL.AMOUNT = 'MONTO:':System.getVariable("CURRENT.TOTAL.AMOUNT")
    Y.CURRENT.TOTAL.AMOUNT2 = System.getVariable("CURRENT.TOTAL.AMOUNT")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
        Y.CURRENT.TOTAL.AMOUNT2 = ""
    END ;*R22 AUTO CODE CONVERSION - END
    Y.PRINCIPAL =  System.getVariable("CURRENT.PRINCIPAL")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION - START
        Y.PRINCIPAL = ""
    END  ;*R22 AUTO CODE CONVERSION - END
    Y.CURRENT.CATEGORY.DESC = System.getVariable("CURRENT.CATEGORY.DESC")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CODE CONVERSION - START
        Y.CURRENT.CATEGORY.DESC = ""
    END   ;*R22 AUTO CODE CONVERSION -END
    Y.CURRENT.NAME = System.getVariable("CURRENT.NAME")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CODE CONVERSION - START
        Y.CURRENT.NAME = ""
    END  ;*R22 AUTO CODE CONVERSION - END
    Y.CURRENT.TITLE2 =  System.getVariable("CURRENT.TITLE2")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CODE CONVERSION - START
        Y.CURRENT.TITLE2 = ""
    END  ;*R22 AUTO CODE CONVERSION - END
    Y.CONCEPT = 'CONCEPTO:  APERTURA DE ':Y.CURRENT.CATEGORY.DESC:' NUMERO ':Y.CURRENT.NAME:' A NOMBRE DE '
    Y.CONCEPT1 = Y.CURRENT.TITLE2:' POR LA SUMA DE ':Y.PRINCIPAL
    Y.MULTI = @VM:Y.CURRENT.VALUE.DATE:@VM:' ':@VM:Y.CURRENT.ACCT.NO:@VM:' ':@VM:Y.CURRENT.TOTAL.AMOUNT:@VM:' ':@VM:Y.CONCEPT:@VM:Y.CONCEPT1
    Y.CUS.SIGNATURE = 'FIRMA:_______________'
    Y.STOP.REQUES = 'NO. IDENTIFICACION: _____________________'
    Y.AUT.SIGNATURE = 'FECHA:_________________________________'
    Y.MULTI :=@VM:' ':@VM:' ':@VM:' ':@VM:Y.CUS.SIGNATURE:@VM:' ':@VM:Y.STOP.REQUES:@VM:' ':@VM:Y.AUT.SIGNATURE

RETURN
*-------------------------------------------------------------------------
END
