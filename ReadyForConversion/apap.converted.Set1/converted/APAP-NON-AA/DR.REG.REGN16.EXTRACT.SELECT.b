SUBROUTINE DR.REG.REGN16.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.REGN16.EXTRACT
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
    $INSERT I_DR.REG.REGN16.EXTRACT.COMMON
    $INSERT I_F.DR.REG.REGN16.EXT.PARAM
    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END

    GOSUB SEL.PROCESS

RETURN

*-----------------------------------------------------------------------------
BUILD.CONTROL.LIST:
*******************

    CALL EB.CLEAR.FILE(FN.DR.REG.REGN16.WORKFILE, F.DR.REG.REGN16.WORKFILE)
    CONTROL.LIST<-1> = "CLAIMS.DETAIL"

RETURN
*-----------------------------------------------------------------------------
SEL.PROCESS:
************

    LIST.PARAMETER = ""

    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "CLAIMS.DETAIL"
            LIST.PARAMETER<2> = "F.REDO.ISSUE.CLAIMS"
            LIST.PARAMETER<3> = "OPENING.DATE GE ":REP.START.DATE:" AND WITH OPENING.DATE LE ":REP.END.DATE:" AND WITH TYPE EQ ":TYPE.VAL
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
        CASE 1
            DUMMY.LIST = ""
            CALL BATCH.BUILD.LIST("",DUMM.LIST)
    END CASE


RETURN
*-----------------------------------------------------------------------------
END
