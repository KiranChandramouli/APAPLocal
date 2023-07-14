* @ValidationCode : MjotMTM0NTkxNTQ5NzpVVEYtODoxNjg5MzQwMTAwOTY0OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Jul 2023 18:38:20
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
*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.SEND.MONITOR.LOAD(ID,SQL.FIELDS,DATA.TYPES,MON.FIELDS,SQL.TABLE)
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.SEND.MONITOR.LOAD
* Date           : 2018-06-04
* Item ID        : --------------
*========================================================================
* Brief description :
* -------------------
* This program receive from LAPAP.BUILD.MONITOR.LOAD routine, values that
* will sent directly to monitor interface.
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-06-04     Richard HC         Initial Development
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 14-07-2023    Narmadha V             R22 Manual Conversion   No Changes
*========================================================================
* Content summary :
* =================
* Table name     :
* Auto Increment :N/A
* Views/versions :ALL VERSION TO REQUIRED IT
* EB record      :LAPAP.SEND.MONITOR.LOAD
* Routine        :LAPAP.SEND.MONITOR.LOAD
*========================================================================

****    D O  N O T  M O D I F Y  T H I S  R O U T I N E    ****

* A lot of requeriments could be depending to this program if you unknown
* all of those previous soluctions, take as sugerence doesn't edit any
* fragment of code content here. In case that you need solve particular
* cases, please kindly create a new soluction independent to this one.
*------------------------------------------------------------------------


    $INSERT I_COMMON ;*R22 Auto Conversion -START
    $INSERT I_EQUATE
    $INSERT I_LAPAP.FUND.SEND.MONITOR ;*R22 Auto Conversion -END

    FN.MON = "F.REDO.MON.SEND.QUEUE"
    F.MON = ""

    CALL OPF(FN.MON,F.MON)

    ARR<1,1> = SQL.FIELDS     ;*SQL fields description
    ARR<2,1> = DATA.TYPES     ;*Monitor data type
    ARR<3,1> = MON.FIELDS     ;*Monitor fields description
    ARR<4,1> = SQL.TABLE      ;*SQL table name

    CALL F.WRITE(FN.MON,ID,ARR)
    CALL JOURNAL.UPDATE('')

RETURN

END
