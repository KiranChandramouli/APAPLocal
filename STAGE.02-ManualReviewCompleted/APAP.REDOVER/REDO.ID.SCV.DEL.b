* @ValidationCode : MjotMjExMTUxNTQwNjpDcDEyNTI6MTY4MDY5MDYxNDM1OTpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 16:00:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.ID.SCV.DEL
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------
* Modification History
* DATE            ODR                              BY                     DESCRIPTION
* 25-08-2011      FS-360                        Manju.G               For enquiry REDO.SCV.CONTACT.CURR.SCV
*05-04-2023      R22 Auto Code conversion     Conversion Tool        IF CONDITION ADDED
*05-04-2023      Manual R22 Code Conversion   Samaran T               No Changes
*------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_F.ENQUIRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER

    GOSUB INITIALISE
    GOSUB PROCESS
*
RETURN

INITIALISE:
*************

    FN.CR.CONTACT = 'F.CR.CONTACT.LOG'
    F.CR.CONTACT = ''
    CALL OPF(FN.CR.CONTACT,F.CR.CONTACT)

RETURN

PROCESS:
**********
    IF COMI EQ 'CURRENT.DEL' THEN
        Y.VARIABLE = "CURRENT.DEL"
        COMI = System.getVariable(Y.VARIABLE)
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CODE CONVERSION
            COMI = ""  ;*R22 AUTO CODE CONVERSION
        END
    END

RETURN
END
