* @ValidationCode : MjotNDk5NzY5OTE2OkNwMTI1MjoxNjgwOTQwNzExNjc5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Apr 2023 13:28:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
