* @ValidationCode : MjotMTc0NDc4MzEwMDpDcDEyNTI6MTY4NDg1NDM4MTc4ODpJVFNTOi0xOi0xOjgwMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 800
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CHANGE.WORK.LOAD.END
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 10-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TSA.WORKLOAD.PROFILE
    $INSERT I_F.TSA.SERVICE

    FN.TSA.SERVICE = 'F.TSA.SERVICE'
    F.TSA.SERVICE = ''
    CALL OPF(FN.TSA.SERVICE,F.TSA.SERVICE)

    FN.TSA.WP = 'F.TSA.WORKLOAD.PROFILE'
    F.TSA.WP = ''
    CALL OPF(FN.TSA.WP,F.TSA.WP)

    FN.REDO.STR.AGENT = 'F.REDO.STR.AGENT'
    F.REDO.STR.AGENT = ''
    CALL OPF(FN.REDO.STR.AGENT,F.REDO.STR.AGENT)


    Y.ID = 'COB'
    CALL F.READ(FN.TSA.SERVICE,Y.ID,R.TSA.SERVICE,F.TSA.SERVICE,TSA.ERR)
    Y.TSA.WP = R.TSA.SERVICE<TS.TSM.WORK.PROFILE>

    Y.ID = 'COB'
    CALL F.READ(FN.REDO.STR.AGENT,Y.ID,R.REDO.STR.AGENT,F.REDO.STR.AGENT,AG.ERR)
    Y.AGENT = R.REDO.STR.AGENT<1>

    CALL F.READ(FN.TSA.WP,Y.TSA.WP,R.TSA.WP,F.TSA.WP,WP.ERR)
    R.TSA.WP<TS.WLP.AGENTS.REQUIRED> = Y.AGENT

    CALL F.WRITE(FN.TSA.WP,Y.TSA.WP,R.TSA.WP)
    CALL F.DELETE(FN.REDO.STR.AGENT,'COB')

RETURN

END
