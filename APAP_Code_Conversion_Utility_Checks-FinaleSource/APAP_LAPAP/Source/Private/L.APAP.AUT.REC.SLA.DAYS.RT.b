* @ValidationCode : MjoxMzkyNTA0MzMyOkNwMTI1MjoxNzAyOTg4MzQ1MjI2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.AUT.REC.SLA.DAYS.RT
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* 18-12-2023          Santosh C            MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FRONT.CLAIMS
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $USING EB.LocalReferences ;*R22 Manual Code Conversion_Utility Check


    GOSUB INI
    GOSUB PROCESS

INI:
    Y.ISS.CL.OPENING.DATE = R.NEW(ISS.CL.OPENING.DATE)
    Y.ISS.CL.DATE.RESOLUTION = R.NEW(ISS.CL.DATE.RESOLUTION)
    DAYS = "C"
RETURN
*ToDO; If DATE.RESOLUTION is not null, set up the field CLAIM.SLA with the difference in days between OPENING.DATE & DATE.RESOLUTION
PROCESS:
    IF Y.ISS.CL.DATE.RESOLUTION NE "" THEN
        CALL CDD("",Y.ISS.CL.OPENING.DATE,Y.ISS.CL.DATE.RESOLUTION,DAYS)
*       CALL GET.LOC.REF("REDO.ISSUE.CLAIMS", "CLAIM.SLA",LR.POS)
        EB.LocalReferences.GetLocRef("REDO.ISSUE.CLAIMS", "CLAIM.SLA",LR.POS) ;*R22 Manual Code Conversion_Utility Check
        R.NEW(ISS.CL.LOCAL.REF)<1,LR.POS> = DAYS
    END
RETURN

END
