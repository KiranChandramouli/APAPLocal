* @ValidationCode : MjotOTc0OTExNTEyOkNwMTI1MjoxNjgxNzEwNTM1MzY4OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 11:18:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BLD.SELECT.USER(ENQ.DATA)
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY

    FN.REDO.PAYMENT = 'F.REDO.PAYMENT.STOP.ACCOUNT'
    F.REDO.PAYMENT  = ''
    CALL OPF(FN.REDO.PAYMENT,F.REDO.PAYMENT)

    LOCATE "INPUTTER" IN ENQ.DATA<2,1> SETTING INP.POS THEN
        Y.SEL.INP = ENQ.DATA<4,INP.POS>
        Y.SEL.INP1 = "...":Y.SEL.INP:"_..."
        ENQ.DATA<3,INP.POS> = 'LK'
        ENQ.DATA<4,INP.POS> = Y.SEL.INP1
    END
RETURN
