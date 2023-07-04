* @ValidationCode : MjoxODc4MzM3MjQ2OkNwMTI1MjoxNjgwNzkwMTA3MDU2OklUU1M6LTE6LTE6NzAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 700
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CHANGE.WORK.LOAD

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
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

    CALL F.READ(FN.TSA.WP,Y.TSA.WP,R.TSA.WP,F.TSA.WP,WP.ERR)
    Y.AGENT = R.TSA.WP<TS.WLP.AGENTS.REQUIRED>
    R.TSA.WP<TS.WLP.AGENTS.REQUIRED> = '1'

    CALL F.WRITE(FN.TSA.WP,Y.TSA.WP,R.TSA.WP)
    CALL F.WRITE(FN.REDO.STR.AGENT,'COB',Y.AGENT)

RETURN

END
