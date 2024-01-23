* @ValidationCode : MjoxNjA0NTc4MjU5OkNwMTI1MjoxNzAzMTM5MjkyMjA5OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Dec 2023 11:44:52
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
*20/12/2023         Suresh                 R22 Manual Conversion  IDVAR Variable Changed
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
    IDVAR='SYSTEM' ;*R22 Manual Conversion
*    CALL CACHE.READ(FN.REDO.EX.AUDIT.TRAIL.LOG,'SYSTEM',R.REDO.EX.AUDIT.TRAIL.LOG,ERR.AUDIT.LOG.EX)
    CALL CACHE.READ(FN.REDO.EX.AUDIT.TRAIL.LOG,IDVAR,R.REDO.EX.AUDIT.TRAIL.LOG,ERR.AUDIT.LOG.EX) ;*R22 Manual Conversion
    Y.PATH = R.REDO.EX.AUDIT.TRAIL.LOG<REDO.EX.TRAIL.INFORMATION>

RETURN
END
