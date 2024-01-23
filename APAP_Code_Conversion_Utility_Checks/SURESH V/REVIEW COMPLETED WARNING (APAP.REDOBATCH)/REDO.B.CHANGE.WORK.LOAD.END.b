* @ValidationCode : MjotNDQzNDE5MDI5OkNwMTI1MjoxNzAzMTYyODgzOTMxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Dec 2023 18:18:03
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
SUBROUTINE REDO.B.CHANGE.WORK.LOAD.END
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 10-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*20/12/2023         Suresh                 R22 Manual Conversion  CALL routine modified, F.READ TO F.READU
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
*  CALL F.READ(FN.REDO.STR.AGENT,Y.ID,R.REDO.STR.AGENT,F.REDO.STR.AGENT,AG.ERR)
    CALL F.READU(FN.REDO.STR.AGENT,Y.ID,R.REDO.STR.AGENT,F.REDO.STR.AGENT,AG.ERR,"") ;*R22 Manual Conversion
    Y.AGENT = R.REDO.STR.AGENT<1>

*  CALL F.READ(FN.TSA.WP,Y.TSA.WP,R.TSA.WP,F.TSA.WP,WP.ERR)
    CALL F.READU(FN.TSA.WP,Y.TSA.WP,R.TSA.WP,F.TSA.WP,WP.ERR,"") ;*R22 Manual Conversion
    R.TSA.WP<TS.WLP.AGENTS.REQUIRED> = Y.AGENT

    CALL F.WRITE(FN.TSA.WP,Y.TSA.WP,R.TSA.WP)
    IDVAR='COB';*R22 Manual Conversion
*    CALL F.DELETE(FN.REDO.STR.AGENT,'COB')
    CALL F.DELETE(FN.REDO.STR.AGENT,IDVAR) ;*R22 Manual Conversion

RETURN

END
