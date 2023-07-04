* @ValidationCode : MjoxODkyNDY2MDMzOkNwMTI1MjoxNjg0ODU0Mzg3NTAyOklUU1M6LTE6LTE6OTAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 900
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.INCREASE.AGENT
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
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
    CALL F.READ(FN.TSA,Y.ID,R.TSA,F.TSA,TS.ERR)

    Y.TWF = R.TSA<TS.TSM.WORK.PROFILE>

    CALL F.READ(FN.REDO.STR.TSA.AGENT,Y.TWF,R.STR.TS,F.REDO.STR.TSA.AGENT,ERR.STR)

    IF R.STR.TS THEN
        Y.AGENTS = R.STR.TS

        CALL F.READ(FN.TWF,Y.TWF,R.TWF,F.TWF,TWF.ER)
        R.TWF<TS.WLP.AGENTS.REQUIRED> = Y.AGENTS

        CALL F.WRITE(FN.TWF,Y.TWF,R.TWF)

        R.TSA<TS.TSM.SERVER.NAME> = ''

        CALL F.WRITE(FN.TSA,Y.ID,R.TSA)

        CALL F.DELETE(FN.REDO.STR.TSA.AGENT,Y.TWF)
    END

END
