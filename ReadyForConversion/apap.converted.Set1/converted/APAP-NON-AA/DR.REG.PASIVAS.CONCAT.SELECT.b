*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.PASIVAS.CONCAT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.PASIVAS.CONCAT
* Date           : 27-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the Active rates
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author             Modification Description
*
* 09-Oct-2014   Ashokkumar.V.P       PACS00305233:- Removed multiple Account record selection.
* 16-Apr-2015   Ashokkumar.V.P       PACS00305233:- Changed for performance issue
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.PASIVAS.CONCAT.COMMON

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************
    CALL EB.CLEAR.FILE(FN.DR.REG.PASIVAS.GROUP, F.DR.REG.PASIVAS.GROUP)

    CONTROL.LIST<-1> = "SELECT.AZ"
    CONTROL.LIST<-1> = "GRP.16"
RETURN

SEL.PROCESS:
************

    LIST.PARAMETER = ""

    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "SELECT.AZ"
            LIST.PARAMETER<2> = "F.AZ.ACCOUNT"
            LIST.PARAMETER<3> = "VALUE.DATE EQ ":LAST.WORK.DAY
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

        CASE CONTROL.LIST<1,1> EQ "GRP.16"
            LIST.PARAMETER<2> = "F.ACCOUNT"
            LIST.PARAMETER<3> = "DATE.LAST.CR.CUST EQ ":LAST.WORK.DAY
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
        CASE 1
            DUMMY.LIST = ""
            CALL BATCH.BUILD.LIST("",DUMM.LIST)
    END CASE
RETURN

END
