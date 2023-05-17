SUBROUTINE DR.REG.RIEN9.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN9.EXTRACT
* Date           : 3-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the MM and SEC.TRADE in DOP and non DOP.
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 28-08-2014     V.P.Ashokkumar       PACS00313072- Filter to avoid ARC-IB records.
* 09-12-2014     V.P.Ashokkumar       PACS00313072- Removed the AUTH status.
* 10-02-2015     V.P.Ashokkumar       PACS00313072- Fixed the select problem
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.RIEN9.EXTRACT.COMMON
    $INSERT I_F.DR.REG.RIEN9.PARAM

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************

    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN9.WORKFILE, F.DR.REG.RIEN9.WORKFILE)
    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN9.WORKFILE.FCY, F.DR.REG.RIEN9.WORKFILE.FCY)
    CONTROL.LIST<-1> = "AA.DETAIL"
RETURN

SEL.PROCESS:
************
    LIST.PARAMETER = ""
    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "AA.DETAIL"
            LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
*        LIST.PARAMETER<3> = "START.DATE LE ":Y.LAST.DAY
*        LIST.PARAMETER<3> := " AND WITH ARR.STATUS NE 'AUTH'"         ;* Changed as per APAP.
            LIST.PARAMETER<3> := "PRODUCT.LINE EQ 'LENDING'"
*       LIST.PARAMETER<7> = "FILTER"
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
        CASE 1
            DUMMY.LIST = ""
            CALL BATCH.BUILD.LIST("",DUMM.LIST)
    END CASE
RETURN
*-----------------------------------------------------------------------------
END
