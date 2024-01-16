* @ValidationCode : MjotMzk4ODg1MDY0OlVURi04OjE3MDUwNDg1ODI2Nzg6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Jan 2024 14:06:22
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.PARAM.PURGE.SELECT
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns
*------------------------------------------------------------------------------------------
* LINKED WITH
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* PROGRAM NAME : REDO.APAP.PARAM.PURGE.SELECT
* ODR          : ODR-2011-03-0113
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                     REFERENCE               DESCRIPTION
*===========      =================        =================       ================
*14.04.2011       JANANI                   ODR-2011-03-0113       INITIAL CREATION
* Date                   who                   Reference
* 06-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION FM TO @FM AND SM TO @SM AND VM TO @VM
* 06-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
* 12.01.2024         Harish Vikaram C     Manual R22 Conversion   Comment Insert File
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.PARAM.COMMON
    $INSERT I_F.APAP.REDO.PURGE.PARAM
*   $INSERT I_BATCH.FILES ;*Manual R22 Changes
    $USING EB.Service

    GOSUB PROCESS

RETURN

********
PROCESS:
*********

    IF CONTROL.LIST EQ '' THEN
        Y.APP = R.APAP.REDO.PURGE.PARAM<REDO.PARAM.PURGE.APPLICATION>
        Y.APP.LOC = R.APAP.REDO.PURGE.PARAM<REDO.PARAM.PURGE.APPLICATION,Y.DATE.INIT>
        CHANGE @VM TO @FM IN Y.APP
        CHANGE @SM TO @FM IN Y.APP
        CONTROL.LIST = Y.APP
    END

    IF CONTROL.LIST THEN

        LOCATE CONTROL.LIST<1,1> IN Y.APP.LOC<1,1,1> SETTING Y.APP.POS THEN
            Y.PARAM.DATE = R.APAP.REDO.PURGE.PARAM<REDO.PARAM.PURGE.PURGE.TILL,Y.DATE.INIT>
            T.DATE.TIME = Y.PARAM.DATE[3,6]:"2359"
            FN.APPLICATION  = 'F.':CONTROL.LIST<1,1>
            F.APPLICATION = ''
            CALL OPF(FN.APPLICATION,F.APPLICATION)
            SEL.CMD ="SELECT ":FN.APPLICATION:" WITH DATE.TIME LE ":T.DATE.TIME
            CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,REC.ERR)
*CALL BATCH.BUILD.LIST('',SEL.LIST)
            EB.Service.BatchBuildList('',SEL.LIST);* R22 Utility Changes
        END ELSE
            Y.DATE.INIT += 1
            Y.APP.LOC = R.APAP.REDO.PURGE.PARAM<REDO.PARAM.PURGE.APPLICATION,Y.DATE.INIT>
            LOCATE CONTROL.LIST<1,1> IN Y.APP.LOC<1,1,1> SETTING Y.APP.POS THEN
                Y.PARAM.DATE = R.APAP.REDO.PURGE.PARAM<REDO.PARAM.PURGE.PURGE.TILL,Y.DATE.INIT>
                T.DATE.TIME = Y.PARAM.DATE[3,6]:"2359"
                FN.APPLICATION  = 'F.':CONTROL.LIST<1,1>
                F.APPLICATION = ''
                CALL OPF(FN.APPLICATION,F.APPLICATION)
                SEL.CMD ="SELECT ":FN.APPLICATION:" WITH DATE.TIME LE ":T.DATE.TIME
                CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,REC.ERR)
*CALL BATCH.BUILD.LIST('',SEL.LIST)
                EB.Service.BatchBuildList('',SEL.LIST);* R22 Utility Changes
            END
        END

    END

RETURN

***************************************
END
*---------------------End of Subroutine--------------------------------------------------------------
