*========================================================================
*-----------------------------------------------------------------------------
* <Rating>-4</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.SEND.MONITOR.FROM.VERSION(ID,SQL.FIELDS,DATA.TYPES,MON.FIELDS,SQL.TABLE)
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.SEND.MONITOR.FROM.VERSION
* Date           : 2019-10-22
* Item ID        : --------------
*========================================================================
* Brief description :
* -------------------
* This program receive from LAPAP.BUILD.MONITOR.FROM.VERSION routine, values that
* will be write directly to monitor interface.
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2019-10-22     Richard HC         Initial Development
*========================================================================
* Content summary :
* =================
* Table name     :
* Auto Increment :N/A
* Views/versions :ALL VERSION TO REQUIRED IT
* EB record      :LAPAP.SEND.MONITOR.FROM.VERSION
* Routine        :LAPAP.SEND.MONITOR.FROM.VERSION
*========================================================================

****    D O  N O T  M O D I F Y  T H I S  R O U T I N E    ****

* A lot of requeriments could be depending to this program if you unknown
* all of those previous soluctions, take as sugerence doesn't edit any
* fragment of code content here. In case that you need solve particular
* cases, please kindly create a new soluction independent to this one.
*------------------------------------------------------------------------

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT LAPAP.BP I_LAPAP.FUND.SEND.MONITOR

    FN.MON = "F.REDO.MON.SEND.QUEUE"
    F.MON = ""

    CALL OPF(FN.MON,F.MON)

    ARR<1,1> = SQL.FIELDS     ;*SQL fields description
    ARR<2,1> = DATA.TYPES     ;*Monitor data type
    ARR<3,1> = MON.FIELDS     ;*Monitor fields description
    ARR<4,1> = SQL.TABLE      ;*SQL table name

    CALL F.WRITE(FN.MON,ID,ARR)
    RETURN

END
