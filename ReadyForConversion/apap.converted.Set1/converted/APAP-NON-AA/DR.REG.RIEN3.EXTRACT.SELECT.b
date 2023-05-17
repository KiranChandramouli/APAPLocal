*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN3.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN3.EXTRACT
* Date           : 3-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the MM.
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
    $INSERT I_DR.REG.RIEN3.EXTRACT.COMMON
    $INSERT I_F.DR.REG.RIEN3.PARAM

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END

    GOSUB SEL.PROCESS

RETURN

*-----------------------------------------------------------------------------
BUILD.CONTROL.LIST:
*******************

    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN3.WORKFILE, F.DR.REG.RIEN3.WORKFILE)

    CONTROL.LIST<-1> = "PROCESS"

RETURN
*-----------------------------------------------------------------------------
SEL.PROCESS:
************

    LIST.PARAMETER = ""

    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "PROCESS"
            LIST.PARAMETER<2> = "F.DR.REG.RIEN3.CONCAT"
            LIST.PARAMETER<3> = "@ID LIKE ":Y.TODAY:"..."
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
        CASE 1
            DUMMY.LIST = ""
            CALL BATCH.BUILD.LIST("",DUMM.LIST)
    END CASE

RETURN
*-----------------------------------------------------------------------------
END
