* @ValidationCode : MjoxMjcyMzczMzE1OkNwMTI1MjoxNjgyNDEyMzI5NjI0OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.ID.SCV.CURR
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------
* Modification History
* DATE            ODR                          BY              DESCRIPTION
* 25-08-2011      FS-360                       Manju.G          For enquiry REDO.SCV.CONTACT.CURR.SCV
*05-04-2023       R22 Auto Code conversion    Conversion Tool    IF CONDITION ADDED
*05-04-2023       Manual R22 Code Conversion  Samaran T           No Changes
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
    IF COMI EQ 'CURRENT.LOG' THEN
        Y.VARIABLE = "CURRENT.LOG"
        COMI = System.getVariable(Y.VARIABLE)
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CODE CONVERSION
            COMI = ""  ;*R22 AUTO CODE CONVERSION
        END
    END

RETURN
END
