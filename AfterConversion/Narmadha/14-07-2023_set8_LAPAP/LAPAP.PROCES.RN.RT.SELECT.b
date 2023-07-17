* @ValidationCode : Mjo4Mzk0Njg4NzA6VVRGLTg6MTY4OTMyOTk4ODE4MTpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Jul 2023 15:49:48
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
SUBROUTINE LAPAP.PROCES.RN.RT.SELECT
*--------------------------------------------------------------------------------------------------
* Description           : Rutina SELECT para el proceso de actualizacion RN o RT
* Developed On          : 23-10-2021
* Developed By          : APAP
* Development Reference : ET-5416
*--------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 14-07-2023    Narmadha V             R22 Manual Conversion   No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion -START
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_LAPAP.PROCES.RN.RT.COMMON ;*R22 Auto Conversion -END



    CALL EB.CLEAR.FILE(FN.LAPAP.CONCATE.RN.RT, FV.LAPAP.CONCATE.RN.RT)
    SEL.CMD = " SELECT " : FN.AA.ARRANGEMENT.ACTIVITY:" WITH EFFECTIVE.DATE EQ ":TODAY:" AND ACTIVITY EQ ":Y.ACTIVIDAD
    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.RECS,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
