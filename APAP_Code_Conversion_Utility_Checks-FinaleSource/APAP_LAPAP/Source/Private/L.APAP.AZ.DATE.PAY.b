* @ValidationCode : MjotMTI4Mzk3ODUzMzpDcDEyNTI6MTcwMjk4ODM0NTI4OTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
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
SUBROUTINE L.APAP.AZ.DATE.PAY
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* 18-12-2023         Santosh C             MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $USING EB.LocalReferences



    VAR.VALUE.DATE = R.NEW(AZ.VALUE.DATE)[7,2]

*   CALL GET.LOC.REF("AZ.ACCOUNT","PAYMENT.DATE",ACC.POS)
    EB.LocalReferences.GetLocRef("AZ.ACCOUNT","PAYMENT.DATE",ACC.POS) ;*R22 Manual Code Conversion_Utility Check

    R.NEW(AZ.LOCAL.REF)<1,ACC.POS> = VAR.VALUE.DATE

END
