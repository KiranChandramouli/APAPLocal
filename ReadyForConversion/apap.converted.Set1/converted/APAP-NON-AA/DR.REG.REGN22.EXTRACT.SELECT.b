*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.REGN22.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.REGN22.EXTRACT
* Date           : 3-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the REDO.ISSUE.CLAIMS Details for each Customer
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.REGN22.EXTRACT.COMMON

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END

    GOSUB SEL.PROCESS

RETURN

*-----------------------------------------------------------------------------
BUILD.CONTROL.LIST:
*******************

    CALL EB.CLEAR.FILE(FN.DR.REG.REGN22.WORKFILE,F.DR.REG.REGN22.WORKFILE)

    CONTROL.LIST<-1> = "TRADE.DETAIL"

RETURN
*-----------------------------------------------------------------------------

SEL.PROCESS:
************

    LIST.PARAMETER = ""

    BEGIN CASE

        CASE CONTROL.LIST<1,1> EQ "TRADE.DETAIL"
            LIST.PARAMETER<2> = "F.SEC.TRADE"
            LIST.PARAMETER<3> = "VALUE.DATE EQ ":LAST.WORK.DAY
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

        CASE 1
            DUMMY.LIST = ""
            CALL BATCH.BUILD.LIST("",DUMM.LIST)
    END CASE


RETURN
*-----------------------------------------------------------------------------
END
