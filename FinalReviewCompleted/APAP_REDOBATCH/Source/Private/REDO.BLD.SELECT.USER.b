* @ValidationCode : MjotOTc0OTExNTEyOkNwMTI1MjoxNjg0ODU0NDA0MjY1OklUU1M6LTE6LTE6MTAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 100
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
