* @ValidationCode : Mjo3ODc4MTk1ODc6Q3AxMjUyOjE2ODU1NDk1MzE3MDM6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
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
SUBROUTINE LAPAP.BUILD.MONITOR.FROM.VERSION(ARR)
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.BUILD.MONITOR.FROM.VERSION
* Date           : 2019-10-22
* Item ID        : --------------
*========================================================================
* Brief description :
* -------------------
* This program receive as parameter an array from any routine in order
* to segment each value and send it to LAPAP.SEND.MONITOR.FROM.VERSION program.
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2019-10-22     Richard HC         Initial Development
*========================================================================
* Content summary :
* =================
* Table name     :CUSTOMER
* Auto Increment :N/A
* Views/versions :ALL VERSION TO REQUIRED IT
* EB record      :LAPAP.BUILD.MONITOR.FROM.VERSION
* Routine        :LAPAP.BUILD.MONITOR.FROM.VERSION
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

    APAP.LAPAP.lapapSendMonitorFromVersion(ID,SQL.FIELDS,DATA.TYPES,MON.FIELDS,SQL.TABLE);* R22 Manual conversion
RETURN


END
