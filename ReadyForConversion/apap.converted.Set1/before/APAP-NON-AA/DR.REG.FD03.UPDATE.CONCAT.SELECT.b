*-----------------------------------------------------------------------------
* <Rating>-33</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE DR.REG.FD03.UPDATE.CONCAT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.FD03.UPDATE.CONCAT
* Date           : 10-June-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the transactions over 1000 USD made by individual customer
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

    $INCLUDE REGREP.BP I_DR.REG.FD03.UPDATE.CONCAT.COMMON
    $INCLUDE REGREP.BP I_F.DR.REG.FD03.PARAM

    GOSUB INIT.PARA
    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END

    GOSUB SEL.PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT.PARA:
**********
    RETURN
*-----------------------------------------------------------------------------
BUILD.CONTROL.LIST:
*******************

*    CALL EB.CLEAR.FILE(FN.DR.REG.FD03.WORKFILE, FV.DR.REG.FD03.WORKFILE)    ;* Clear the WORK file before building for Today

    CONTROL.LIST<-1> = "TRANSACTION.DETAIL"

    RETURN
*-----------------------------------------------------------------------------
SEL.PROCESS:
************

    LIST.PARAMETER = ""
    NEW.CUS.LIST   = ""

    BEGIN CASE

    CASE CONTROL.LIST<1,1> EQ "TRANSACTION.DETAIL"
        LIST.PARAMETER<2> = "F.ACCT.ENT.LWORK.DAY"
        LIST.PARAMETER<7> = "FILTER"    ;* Call Fillter Routine to filer out the Internal Accounts from process
        CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

    CASE 1
        DUMMY.LIST = ""
        CALL BATCH.BUILD.LIST("",DUMM.LIST)
    END CASE


    RETURN

*-----------------------------------------------------------------------------
END
