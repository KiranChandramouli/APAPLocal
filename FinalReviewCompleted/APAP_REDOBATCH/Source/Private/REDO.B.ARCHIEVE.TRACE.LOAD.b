* @ValidationCode : MjotNzg2MDE3ODQzOkNwMTI1MjoxNjg0ODU0Mzc5NzE4OklUU1M6LTE6LTE6MTgyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 182
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.ARCHIEVE.TRACE.LOAD

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AUDIT.TRAIL.LOG
    $INSERT I_F.REDO.EX.AUDIT.TRAIL.LOG
    $INSERT I_REDO.B.ARCHIEVE.TRACE.COMMON

    GOSUB INIT
    GOSUB PROCESS

RETURN

*----
INIT:
*----
*-------------------------------------------------
* This section initialises the necessary variables
* Date                  who                   Reference              
* 06-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------

    FN.REDO.AUDIT.TRAIL.LOG = 'F.REDO.AUDIT.TRAIL.LOG'
    F.REDO.AUDIT.TRAIL.LOG  = ''
    R.REDO.AUDIT.TRAIL.LOG  = ''
    CALL OPF(FN.REDO.AUDIT.TRAIL.LOG,F.REDO.AUDIT.TRAIL.LOG)

    FN.REDO.EX.AUDIT.TRAIL.LOG = 'F.REDO.EX.AUDIT.TRAIL.LOG'
    F.REDO.EX.AUDIT.TRAIL.LOG  = ''
    R.REDO.EX.AUDIT.TRAIL.LOG  = ''
    CALL OPF(FN.REDO.EX.AUDIT.TRAIL.LOG,F.REDO.EX.AUDIT.TRAIL.LOG)

RETURN

PROCESS:

    CALL CACHE.READ(FN.REDO.EX.AUDIT.TRAIL.LOG,'SYSTEM',R.REDO.EX.AUDIT.TRAIL.LOG,ERR.AUDIT.LOG.EX)
    Y.PATH = R.REDO.EX.AUDIT.TRAIL.LOG<REDO.EX.TRAIL.INFORMATION>

RETURN
END
