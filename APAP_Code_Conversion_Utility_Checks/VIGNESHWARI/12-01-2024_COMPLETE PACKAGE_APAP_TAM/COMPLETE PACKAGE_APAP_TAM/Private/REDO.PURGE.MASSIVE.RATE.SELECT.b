* @ValidationCode : MjotMTEyOTE1NDkyOTpDcDEyNTI6MTcwNDg4NjIzMTE3MjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Jan 2024 17:00:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.PURGE.MASSIVE.RATE.SELECT
*--------------------------------------------------------------
* Description : This routine is to delete the one month backdated log of
* F.REDO.MASSIVE.RATE.CHANGE. This is month end batch job
*--------------------------------------------------------------
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*14.07.2011  H GANESH      PACS00055012 - B.16 INITIAL CREATION
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*----------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.PURGE.MASSIVE.RATE.COMMON
    $USING EB.Service


    GOSUB PROCESS
RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------
    Y.DATE = TODAY
    YREGION = ''
    YDAYS.ORIG = '-30C'
    CALL CDT(YREGION,Y.DATE,YDAYS.ORIG)

    SEL.CMD = 'SELECT ':FN.REDO.MASSIVE.RATE.CHANGE:' WITH @ID LT ':Y.DATE:'...'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN
END
