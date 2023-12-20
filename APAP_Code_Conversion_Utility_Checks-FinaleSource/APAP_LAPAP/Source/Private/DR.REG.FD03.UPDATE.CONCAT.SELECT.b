* @ValidationCode : MjotMTE2NzQ2ODg3NTpDcDEyNTI6MTcwMjk4ODM0MTg3NjpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
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
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  REGREP.BP,LAPAP.BP,T24.BP is removed ,$INCLUDE to$INSERT
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE ;*R22 AUTO CODE CONVERSION
    $INSERT I_BATCH.FILES

    $INSERT I_DR.REG.FD03.UPDATE.CONCAT.COMMON
    $INSERT I_F.DR.REG.FD03.PARAM ;*R22 AUTO CODE CONVERSION


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
