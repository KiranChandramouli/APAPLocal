* @ValidationCode : MjotNzc2MTM5MzA5OkNwMTI1MjoxNzAzMTYyMDA2MjQ2OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Dec 2023 18:03:26
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
SUBROUTINE REDO.B.CHANGE.WORK.LOAD

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*20/12/2023         Suresh          R22 Manual Conversion     IDVAR Variable Changed, F.READ TO F.READU
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

*  CALL F.READ(FN.TSA.WP,Y.TSA.WP,R.TSA.WP,F.TSA.WP,WP.ERR)
    CALL F.READU(FN.TSA.WP,Y.TSA.WP,R.TSA.WP,F.TSA.WP,WP.ERR,"") ;*R22 Manual Conversion
    Y.AGENT = R.TSA.WP<TS.WLP.AGENTS.REQUIRED>
    R.TSA.WP<TS.WLP.AGENTS.REQUIRED> = '1'

    CALL F.WRITE(FN.TSA.WP,Y.TSA.WP,R.TSA.WP)
    IDVAR='COB' ;*R22 Manual Conversion
*   CALL F.WRITE(FN.REDO.STR.AGENT,'COB',Y.AGENT)
    CALL F.WRITE(FN.REDO.STR.AGENT,IDVAR,Y.AGENT) ;*R22 Manual Conversion

RETURN

END
