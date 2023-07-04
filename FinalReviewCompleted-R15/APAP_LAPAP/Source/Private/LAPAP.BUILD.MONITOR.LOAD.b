* @ValidationCode : MjotMTQ5NjE3NDM4OkNwMTI1MjoxNjg1NTQ5NTMxNzE5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 21:42:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
*Modification history
*Date                Who               Reference                  Description
*21-04-2023      conversion tool     R22 Auto code conversion     No changes
*21-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.BUILD.MONITOR.LOAD(ARR)
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.BUILD.MONITOR.LOAD
* Date           : 2018-06-04
* Item ID        : --------------
*========================================================================
* Brief description :
* -------------------
* This program receive as parameter ARR array from any routine in order
* to segment each value inside and assign at the same time corresponding
* values that will be sent to LAPAP.SEND.MONITOR.LOAD program.
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-06-04     Richard HC         Initial Development
*========================================================================
* Content summary :
* =================
* Table name     :CUSTOMER
* Auto Increment :N/A
* Views/versions :ALL VERSION TO REQUIRED IT
* EB record      :LAPAP.BUILD.MONITOR.LOAD
* Routine        :LAPAP.BUILD.MONITOR.LOAD
*========================================================================

****    D O  N O T  M O D I F Y  T H I S  R O U T I N E    ****

* A lot of requeriments could be depending to this program if you unknown
* all of those previous soluctions, take as sugerence doesn't edit any
* fragment of code content here. In case that you need solve particular
* cases, please kindly create a new soluction independent to this one.
*------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE


    FN.ARR = EREPLACE(ARR,",","@vm")

    ID = FN.ARR<1>
    SQL.FIELDS = FN.ARR<2>
    DATA.TYPES = FN.ARR<3>
    MON.FIELDS = FN.ARR<4>
    SQL.TABLE = FN.ARR<5>
*DEBUG
    APAP.LAPAP.lapapSendMonitorLoad(ID,SQL.FIELDS,DATA.TYPES,MON.FIELDS,SQL.TABLE);* R22 Manual conversion
RETURN

END
