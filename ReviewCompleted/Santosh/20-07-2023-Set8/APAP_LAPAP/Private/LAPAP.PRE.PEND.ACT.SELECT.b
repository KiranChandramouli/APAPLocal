* @ValidationCode : MjoxMzk2NTc0MDA5OlVURi04OjE2ODk4MzA5ODY4OTE6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Jul 2023 10:59:46
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
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.PRE.PEND.ACT.SELECT
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     No Changes
* 14-07-2023    Narmadha V             R22 Manual Conversion   BP is removed in insert file
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON ;*R22 Manual Conversion - START
    $INSERT  I_EQUATE
    $INSERT  I_BATCH.FILES
    $INSERT  I_TSA.COMMON
    $INSERT  I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT  I_F.USER
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.REDO.H.REPORTS.PARAM
    $INSERT  I_F.ST.L.APAP.AAA.PENDIENTENAU
    $INSERT  I_F.AA.ARRANGEMENT
    $INSERT  I_LAPAP.PRE.PEND.ACT.COMMON ;*R22 Manual Conversion - END

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.THE.FILE
RETURN

BUILD.CONTROL.LIST:
*******************
    CALL EB.CLEAR.FILE(FN.ST.L.APAP.AAA.PENDIENTENAU, F.ST.L.APAP.AAA.PENDIENTENAU)
    CONTROL.LIST<-1> = "SELECT.INAU"
    CONTROL.LIST<-1> = "SELECT.LIVE"
RETURN

*-----------------------------------------------------------------------------------------------------------------
SEL.THE.FILE:
*-----------------------------------------------------------------------------------------------------------------
    LIST.PARAMETER = ""
    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "SELECT.INAU"
*SEL.CMD = "SELECT ":FN.ARRANGEMENT.ACTIVITY$NAU: " WITH EFFECTIVE.DATE EQ ":Y.FECHA.ACTUAL
*CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
*CALL BATCH.BUILD.LIST('',SEL.LIST)
            LIST.PARAMETER<2> = FN.ARRANGEMENT.ACTIVITY$NAU
            LIST.PARAMETER<3> = "EFFECTIVE.DATE EQ ":Y.FECHA.ACTUAL

        CASE CONTROL.LIST<1,1> EQ "SELECT.LIVE"
            LIST.PARAMETER = ""
            LIST.PARAMETER<2> = FN.ARRANGEMENT.ACTIVITY
            LIST.PARAMETER<3> = "EFFECTIVE.DATE EQ ":Y.FECHA.ACTUAL
*CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

    END CASE
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
RETURN
END
