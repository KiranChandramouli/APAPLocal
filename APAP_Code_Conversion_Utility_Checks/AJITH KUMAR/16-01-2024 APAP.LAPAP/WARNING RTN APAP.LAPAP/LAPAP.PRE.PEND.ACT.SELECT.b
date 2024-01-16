* @ValidationCode : MjotMTc5ODE0MTgzMDpDcDEyNTI6MTcwNTAzNTM5MjMwMTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jan 2024 10:26:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
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
*    $INSERT  I_BATCH.FILES
*    $INSERT  I_TSA.COMMON
    $INSERT  I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT  I_F.USER
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.REDO.H.REPORTS.PARAM
    $INSERT  I_F.ST.L.APAP.AAA.PENDIENTENAU
    $INSERT  I_F.AA.ARRANGEMENT
    $INSERT  I_LAPAP.PRE.PEND.ACT.COMMON ;*R22 Manual Conversion - END
   $USING EB.Service

    *IF NOT(CONTROL.LIST) THEN
        ControlListVal = EB.Service.getControlList() ;*R22 UTILITY MANUAL CONVERSION
    IF NOT(ControlListVal) THEN ;*R22 UTILITY MANUAL CONVERSION
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.THE.FILE
RETURN

BUILD.CONTROL.LIST:
*******************
*    CALL EB.CLEAR.FILE(FN.ST.L.APAP.AAA.PENDIENTENAU, F.ST.L.APAP.AAA.PENDIENTENAU)
EB.Service.ClearFile(FN.ST.L.APAP.AAA.PENDIENTENAU, F.ST.L.APAP.AAA.PENDIENTENAU);* R22 UTILITY AUTO CONVERSION
  *  CONTROL.LIST<-1> = "SELECT.INAU"
    ControlListVal<-1> = "SELECT.INAU"
  *  CONTROL.LIST<-1> = "SELECT.LIVE"
    ControlListVal<-1> = "SELECT.LIVE"
RETURN

*-----------------------------------------------------------------------------------------------------------------
SEL.THE.FILE:
*-----------------------------------------------------------------------------------------------------------------
    LIST.PARAMETER = ""
    BEGIN CASE
     *   CASE CONTROL.LIST<1,1> EQ "SELECT.INAU"
            CASE ControlListVal<1,1> EQ  "SELECT.INAU" ;*R22 UTILITY MANUAL CONVERSION
*SEL.CMD = "SELECT ":FN.ARRANGEMENT.ACTIVITY$NAU: " WITH EFFECTIVE.DATE EQ ":Y.FECHA.ACTUAL
*CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
*CALL BATCH.BUILD.LIST('',SEL.LIST)
            LIST.PARAMETER<2> = FN.ARRANGEMENT.ACTIVITY$NAU
            LIST.PARAMETER<3> = "EFFECTIVE.DATE EQ ":Y.FECHA.ACTUAL

   * CASE CONTROL.LIST<1,1> EQ "SELECT.LIVE"
        CASE ControlListVal<1,1> EQ "SELECT.LIVE";*R22 UTILITY MANUAL CONVERSION
            LIST.PARAMETER = ""
            LIST.PARAMETER<2> = FN.ARRANGEMENT.ACTIVITY
            LIST.PARAMETER<3> = "EFFECTIVE.DATE EQ ":Y.FECHA.ACTUAL
*CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

    END CASE
*    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
EB.Service.BatchBuildList(LIST.PARAMETER, "");* R22 UTILITY AUTO CONVERSION
RETURN
END
