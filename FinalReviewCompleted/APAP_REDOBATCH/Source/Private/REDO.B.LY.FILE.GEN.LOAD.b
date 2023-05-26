* @ValidationCode : MjoxMTk0MDQ3OTQ2OkNwMTI1MjoxNjg0ODU0MzkwMTk4OklUU1M6LTE6LTE6NDY3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 467
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LY.FILE.GEN.LOAD
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine performs initialisation and gets the details from the parameter table REDO.LY.PROGRAM
*  and stores it in the common variable
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date           who           Reference            Description
* 03-MAY-2010   S.Marimuthu  ODR-2009-12-0276      Initial Creation
* 28-Sep-2010   S.Sudharsanan  0DR-2010-09-0012     Modification has done as per the CR-021
* Date                  who                   Reference              
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_F.REDO.LY.POINTS
    $INSERT I_F.REDO.LY.POINTS.TOT
    $INSERT I_F.REDO.LY.LOG
    $INSERT I_F.DATES
    $INSERT I_REDO.B.LY.FILE.GEN.COMMON
    $INSERT I_F.REDO.LY.PARAMTCM
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB READ.PARAM
    GOSUB PROGRAM.END
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------


    Y.PATH = ''
    F.PATH = ''

    G.DATE = ''
    I.DATE = DATE()
    CALL DIETER.DATE(G.DATE,I.DATE,'')

    Y.NEXT.WRK.DAY = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    NEXT.MONTH = Y.NEXT.WRK.DAY[5,2]

    CUR.MONTH = TODAY[5,2]
    CUR.YEAR  = TODAY[1,4]
    FIRST.MONTH.DAY=TODAY[1,6]:'01'

RETURN
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM = ''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

    FN.REDO.LY.POINTS = 'F.REDO.LY.POINTS'
    F.REDO.LY.POINTS = ''
    CALL OPF(FN.REDO.LY.POINTS,F.REDO.LY.POINTS)

    FN.REDO.LY.POINTS.TOT = 'F.REDO.LY.POINTS.TOT'
    F.REDO.LY.POINTS.TOT = ''
    CALL OPF(FN.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT)

    FN.REDO.LY.PARAMTCM = 'F.REDO.LY.PARAMTCM'
    F.REDO.LY.PARAMTCM = ''
    CALL OPF(FN.REDO.LY.PARAMTCM,F.REDO.LY.PARAMTCM)

    FN.REDO.LY.LOG = 'F.REDO.LY.LOG'
    F.REDO.LY.LOG = ''
    CALL OPF(FN.REDO.LY.LOG,F.REDO.LY.LOG)

    FLAG.COUNT = ''
    RECNUM = ''
    VAR.TOT.REC = ''
RETURN
*-----------------------------------------------------------------------------
READ.PARAM:
*-----------------------------------------------------------------------------
    IF NEXT.MONTH EQ CUR.MONTH THEN
        FILE.NAME = 'PGDIARIO':TODAY[7,2]:TODAY[5,2]:TODAY[1,4]
        LASTMONTHWDAY = 'N'
    END ELSE
        FILE.NAME = 'PGMENSUAL':TODAY[7,2]:TODAY[5,2]:TODAY[1,4]
        LASTMONTHWDAY = 'Y'
    END

    CALL CACHE.READ(FN.REDO.LY.PARAMTCM,'SYSTEM',R.REC.PARAM,PARAM.ERR)

    Y.PATH = R.REC.PARAM<REDO.PARAM.GEN.PATH.FG>

    OPENSEQ Y.PATH,FILE.NAME TO F.PATH ELSE
        CREATE F.PATH ELSE
        END
    END

RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------
END
