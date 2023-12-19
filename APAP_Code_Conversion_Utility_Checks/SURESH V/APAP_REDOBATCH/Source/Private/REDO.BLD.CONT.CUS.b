* @ValidationCode : MjotMTQwMDQ5ODA4MjpDcDEyNTI6MTY4NDg1NDQwNDA3NzpJVFNTOi0xOi0xOjE4NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 186
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BLD.CONT.CUS(ENQ.DATA)
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------
* Modification History
* DATE            ODR           BY              DESCRIPTION
* 25-08-2011      FS-360       Manju.G          For enquiry REDO.SCV.CONTACT.CURR.SCV
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - ADDED IF E EQ "EB-UNKNOWN.VARIABLE" THEN VARIABLE NULL AND END
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_System

    GOSUB INITIALISE
    GOSUB PROCESS
*
RETURN

INITIALISE:
*************

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.CR.CONTACT = 'F.CR.CONTACT.LOG'
    F.CR.CONTACT = ''
    CALL OPF(FN.CR.CONTACT,F.CR.CONTACT)

RETURN

PROCESS:
**********

    Y.CURR.VALUE = System.getVariable("CURRENT.CONTENT")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CONVERSTION ADDED IF E EQ "EB-UNKNOWN.VARIABLE" THEN VARIABLE NULL AND END
        Y.CURR.VALUE = ""
    END


    ENQ.DATA<2,-1> = "CONTRACT.ID"
    ENQ.DATA<3,-1> = "EQ"
    ENQ.DATA<4,-1> = Y.CURR.VALUE
RETURN
END
