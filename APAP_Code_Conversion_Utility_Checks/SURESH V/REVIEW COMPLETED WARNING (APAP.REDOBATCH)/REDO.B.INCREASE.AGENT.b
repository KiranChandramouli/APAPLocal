* @ValidationCode : MjotMTc4Mzk1MDY0MDpDcDEyNTI6MTcwMzY3Mjg1MzM2MjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Dec 2023 15:57:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.INCREASE.AGENT
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                R22 Manual Conversion    Change F.READ to F.READU
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TSA.SERVICE
    $INSERT I_F.TSA.WORKLOAD.PROFILE

    FN.TSA = 'F.TSA.SERVICE'
    F.TSA = ''
    CALL OPF(FN.TSA,F.TSA)

    FN.TWF = 'F.TSA.WORKLOAD.PROFILE'
    F.TWF = ''
    CALL OPF(FN.TWF,F.TWFF.TWF)

    FN.REDO.STR.TSA.AGENT = 'F.REDO.STR.TSA.AGENT'
    F.REDO.STR.TSA.AGENT = ''
    CALL OPF(FN.REDO.STR.TSA.AGENT,F.REDO.STR.TSA.AGENT)

    Y.ID = 'COB'
*    CALL F.READ(FN.TSA,Y.ID,R.TSA,F.TSA,TS.ERR)
    CALL F.READU(FN.TSA,Y.ID,R.TSA,F.TSA,TS.ERR,"") ;*R22 Manual Conversion


    Y.TWF = R.TSA<TS.TSM.WORK.PROFILE>

*    CALL F.READ(FN.REDO.STR.TSA.AGENT,Y.TWF,R.STR.TS,F.REDO.STR.TSA.AGENT,ERR.STR)
    CALL F.READU(FN.REDO.STR.TSA.AGENT,Y.TWF,R.STR.TS,F.REDO.STR.TSA.AGENT,ERR.STR,"") ;*R22 Manual Conversion


    IF R.STR.TS THEN
        Y.AGENTS = R.STR.TS

*        CALL F.READ(FN.TWF,Y.TWF,R.TWF,F.TWF,TWF.ER)
        CALL F.READU(FN.TWF,Y.TWF,R.TWF,F.TWF,TWF.ER,"");*R22 Manual Conversion
  
        R.TWF<TS.WLP.AGENTS.REQUIRED> = Y.AGENTS

        CALL F.WRITE(FN.TWF,Y.TWF,R.TWF)

        R.TSA<TS.TSM.SERVER.NAME> = ''

        CALL F.WRITE(FN.TSA,Y.ID,R.TSA)

        CALL F.DELETE(FN.REDO.STR.TSA.AGENT,Y.TWF)
    END

END
