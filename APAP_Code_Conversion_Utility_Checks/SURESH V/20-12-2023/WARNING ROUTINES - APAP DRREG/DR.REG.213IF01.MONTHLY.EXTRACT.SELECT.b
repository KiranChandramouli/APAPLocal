* @ValidationCode : Mjo0MDI0NDA2ODE6Q3AxMjUyOjE3MDI2NDA1MzgyODY6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Dec 2023 17:12:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.



$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.213IF01.MONTHLY.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.213IF01.MONTHLY.EXTRACT
* Date           : 2-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the transactions over 10000 USD made by individual customer
*-----------------------------------------------------------------------------
*
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*04-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*04-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION       NO CHANGE
*14/12/2023       Suresh                      R22 Manual Conversion        Call routine modified
*----------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
*  $INSERT I_BATCH.FILES ;*R22 Manual Conversion

    $INSERT I_DR.REG.213IF01.MONTHLY.EXTRACT.COMMON
    $INSERT I_F.DR.REG.213IF01.PARAM

    $USING EB.Service
    
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

*   CALL EB.CLEAR.FILE(FN.DR.REG.213IF01.WORKFILE, F.DR.REG.213IF01.WORKFILE)     ;* Clear the WORK file before building for Today
    EB.Service.ClearFile(FN.DR.REG.213IF01.WORKFILE, F.DR.REG.213IF01.WORKFILE)   ;*R22 Manual Conversion
    
    CONTROL.LIST<-1> = "TRANSACTION.DETAIL"

RETURN
*-----------------------------------------------------------------------------
SEL.PROCESS:
************

    LIST.PARAMETER = ""

    BEGIN CASE

        CASE CONTROL.LIST<1,1> EQ "TRANSACTION.DETAIL"
            LAST.WRK.DATE.MMYY = LAST.WRK.DATE[1,6]
            LIST.PARAMETER<2> = "F.DR.REG.213IF01.CONCAT"
            LIST.PARAMETER<3> = "@ID LIKE ...":LAST.WRK.DATE.MMYY:"... AND WITH RTE.FLAG EQ 'YES'"
*           CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
            EB.Service.BatchBuildList(LIST.PARAMETER, "") ;*R22 Manual Conversion

        CASE 1
            DUMMY.LIST = ""
*           CALL BATCH.BUILD.LIST("",DUMM.LIST)
            EB.Service.BatchBuildList("",DUMM.LIST) ;*R22 Manual Conversion
    END CASE


RETURN

*-----------------------------------------------------------------------------
END
