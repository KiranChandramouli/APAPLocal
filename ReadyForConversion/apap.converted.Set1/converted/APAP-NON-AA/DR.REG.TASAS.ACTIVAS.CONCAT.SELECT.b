*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.TASAS.ACTIVAS.CONCAT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.TASAS.ACTIVAS.CONCAT
* Date           : 27-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the Active rates
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*  ======        ========            ==========================
* 09-Oct-2014  Ashokkumar.V.P      PACS00305233:- Changed the parameter values
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.TASAS.ACTIVAS.CONCAT.COMMON

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************

    CALL EB.CLEAR.FILE(FN.DR.REG.ACTIVAS.GROUP, F.DR.REG.ACTIVAS.GROUP)

    CONTROL.LIST<-1> = "SELECT.AA"
    CONTROL.LIST<-1> = "SELECT.MM"
RETURN

SEL.PROCESS:
************

    LIST.PARAMETER = ""

    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "SELECT.AA"
            LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
            LIST.PARAMETER<3> = "ARR.STATUS EQ CURRENT AND START.DATE EQ ":LAST.WORK.DAY
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

        CASE CONTROL.LIST<1,1> EQ "SELECT.MM"
            LIST.PARAMETER<2> = "F.MM.MONEY.MARKET"
            LIST.PARAMETER<3> = "(VALUE.DATE EQ ":LAST.WORK.DAY:" OR ROLLOVER.DATE EQ ":LAST.WORK.DAY:") AND WITH CATEGORY EQ ":CAT.LIST
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

        CASE 1
            DUMMY.LIST = ""
            CALL BATCH.BUILD.LIST("",DUMM.LIST)
    END CASE
RETURN

END
