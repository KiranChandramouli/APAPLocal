*
*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE DR.REG.COMM.LOAN.SECTOR.EXT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.COMMERCIAL.LOAN.SECTOR.EXTRACT
* Date           : 16-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the AA.ARRANGEMENT application where the AA.GROUP.PRODUCT = COMERCIAL
* and the AA.STATUS is equal to  ("CURRENT" or "EXPIRED")
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 03-Oct-2014  Ashokkumar           PACS00305229:- Displaying Credit lines details
* 12-May-2015  Ashokkumar.V.P       PACS00305229:- Added new fields mapping change
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INCLUDE REGREP.BP I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON
    $INCLUDE REGREP.BP I_DR.REG.COMM.LOAN.SECTOR.COMMON

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.PROCESS
    RETURN

*-----------------------------------------------------------------------------
BUILD.CONTROL.LIST:
*******************

    CALL EB.CLEAR.FILE(FN.DR.REG.COM.LOAN.SECTOR.WORKFILE,F.DR.REG.COM.LOAN.SECTOR.WORKFILE)

    CONTROL.LIST<-1> = "AA.DETAILS"

    RETURN
*-----------------------------------------------------------------------------

SEL.PROCESS:
************

    LIST.PARAMETER = ""

    BEGIN CASE
    CASE CONTROL.LIST<1,1> EQ "AA.DETAILS"
        LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
        LIST.PARAMETER<3> := "PRODUCT.LINE EQ ":"LENDING"
        LIST.PARAMETER<3> := " AND PRODUCT.GROUP EQ ":Y.TXNPGRP.VAL.ARR
        CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
    CASE 1
        DUMMY.LIST = ""
        CALL BATCH.BUILD.LIST("",DUMM.LIST)
    END CASE

    RETURN
*-----------------------------------------------------------------------------
END
