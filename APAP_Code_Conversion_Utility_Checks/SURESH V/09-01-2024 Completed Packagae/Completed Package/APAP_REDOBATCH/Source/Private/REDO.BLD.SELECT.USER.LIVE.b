* @ValidationCode : MjotMTc3NTAxODYxNjpDcDEyNTI6MTY4MDc5MDExMDU1MTpJVFNTOi0xOi0xOjEwMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:30
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
SUBROUTINE REDO.BLD.SELECT.USER.LIVE(ENQ.DATA)

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY

    FN.REDO.PAYMENT = 'F.REDO.PAYMENT.STOP.ACCOUNT$NAU'
    F.REDO.PAYMENT  = ''
    CALL OPF(FN.REDO.PAYMENT,F.REDO.PAYMENT)

    LOCATE "INPUTTER" IN ENQ.DATA<2,1> SETTING INP.POS THEN
        Y.SEL.INP = ENQ.DATA<4,INP.POS>
        Y.SEL.INP1 = "...":Y.SEL.INP:"_..."
        ENQ.DATA<3,INP.POS> = 'LK'
        ENQ.DATA<4,INP.POS> = Y.SEL.INP1
    END
RETURN
