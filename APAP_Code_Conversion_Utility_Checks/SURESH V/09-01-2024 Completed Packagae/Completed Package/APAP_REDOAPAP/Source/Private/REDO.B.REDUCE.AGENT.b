* @ValidationCode : MjotMTYwMDk2MDI1NDpDcDEyNTI6MTY4NDg1NDM5NTA3MDpJVFNTOi0xOi0xOjkwMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:35
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
SUBROUTINE REDO.B.REDUCE.AGENT
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 12-04-2023        CONVERSTION TOOL     R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.AA.INT.CLASSIFICATION
    $INSERT I_F.TSA.SERVICE
    $INSERT I_F.TSA.WORKLOAD.PROFILE


    FN.PARM = 'F.REDO.AA.INT.CLASSIFICATION'
    F.PARM = ''
    CALL OPF(FN.PARM,F.PARM)

    FN.TSA = 'F.TSA.SERVICE'
    F.TSA = ''
    CALL OPF(FN.TSA,F.TSA)

    FN.TWF = 'F.TSA.WORKLOAD.PROFILE'
    F.TWF = ''
    CALL OPF(FN.TWF,F.TWF)

    FN.REDO.STR.TSA.AGENT = 'F.REDO.STR.TSA.AGENT'
    F.REDO.STR.TSA.AGENT = ''
    CALL OPF(FN.REDO.STR.TSA.AGENT,F.REDO.STR.TSA.AGENT)


    Y.ID = 'SYSTEM'
    CALL CACHE.READ(FN.PARM,Y.ID,R.PARAM,Y.ERR)

    Y.SERVER = R.PARAM<REDO.INT.CLASS.SERVER.NAME>

    Y.TS.ID = 'COB'
*    CALL F.READ(FN.TSA,Y.TS.ID,R.TSA,F.TSA,TS.ERR)
    CALL F.READU(FN.TSA,Y.TS.ID,R.TSA,F.TSA,TS.ERR,'');* R22 UTILITY AUTO CONVERSION

    Y.TWF.ID = R.TSA<TS.TSM.WORK.PROFILE>
*    CALL F.READ(FN.TWF,Y.TWF.ID,R.TWF,F.TWF,TWF.ER)
    CALL F.READU(FN.TWF,Y.TWF.ID,R.TWF,F.TWF,TWF.ER,'');* R22 UTILITY AUTO CONVERSION

    Y.AGENTS = R.TWF<TS.WLP.AGENTS.REQUIRED>

    CALL F.WRITE(FN.REDO.STR.TSA.AGENT,Y.TWF.ID,Y.AGENTS)

    IF Y.SERVER THEN
        R.TSA<TS.TSM.SERVER.NAME> = Y.SERVER
        CALL F.WRITE(FN.TSA,Y.TS.ID,R.TSA)

        R.TWF<TS.WLP.AGENTS.REQUIRED> = 1
        CALL F.WRITE(FN.TWF,Y.TWF.ID,R.TWF)
    END

END
