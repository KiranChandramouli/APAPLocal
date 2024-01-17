* @ValidationCode : MjotMTM1NzM2MjA4MTpDcDEyNTI6MTcwNDQzNjYxNTE2MDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jan 2024 12:06:55
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.REPORTE.ACTIVIDAD.SELECT
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      :
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description: This is a .SELECT Subroutine
*
*-------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*-----------------------------------------------------------------------------------------------------------------
* PACS00363969           Ashokkumar.V.P                 27/11/2014            Changed to show the AA loan with START.DATE less than today.
* PACS00466618           Ashokkumar.V.P                 26/06/2015            Fixed the NAB account created on same date for old NAB loans.
* Date                  who                   Reference
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_REDO.B.REPORTE.ACTIVIDAD.COMMON
    $USING EB.Service

    GOSUB PROCESS.PARA
RETURN
*-------------------------------------------------------------------------------
PROCESS.PARA:
*------------
*
    LIST.PARAMETER = ''
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
*    LIST.PARAMETER<3> = "START.DATE LE ":Y.LAST.DAY
    LIST.PARAMETER<3> := "PRODUCT.LINE EQ ":"LENDING"
*    LIST.PARAMETER<3> := " AND ((ARR.STATUS EQ ":Y.SEL.VAL.1:") OR (ARR.STATUS EQ ":Y.SEL.VAL.2:"))"
*    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
    EB.Service.BatchBuildList(LIST.PARAMETER, "");* R22 UTILITY AUTO CONVERSION
RETURN
END
 