* @ValidationCode : MjotMTM0MjA4NTc5MDpDcDEyNTI6MTcwNDcxNDE4MDA2NzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 Jan 2024 17:13:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.YER.END.FX.SALE.PRE.SELECT
*----------------------------------------------------------------------------------------------------------
* Description           : This Select routine is used to Select the details of Last Year Sales in Forex
*
* Developed By          : Amaravathi Krithika B
*
* Development Reference : RegN21
*
* Attached To           : BATCH>BNK/REDO.B.YER.END.FX.SALE
*
* Attached As           : Batch Routine
*----------------------------------------------------------------------------------------------------------
*------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*----------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*----------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*----------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*----------------------------------------------------------------------------------------------------------
*XXXX                   <<name of modifier>>                                 <<modification details goes he
* R22 Auto conversion      Conversion tool            04-APR-2023              No changes
* 04-APR-2023               Harishvikram C   Manual R22 conversion      No changes
*----------------------------------------------------------------------------------------------------------
* Include files
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.YER.END.FX.SALE.PRE.COMMON
    $INSERT I_F.FOREX
    $USING EB.Service
    GOSUB INIT
    GOSUB DELETE.HIST.PREV.REC
    GOSUB PROCESS
RETURN
INIT:
*---
    SEL.LIST = ''
    CMD = ''
RETURN
DELETE.HIST.PREV.REC:
*-------------------
    CMD = "CLEAR.FILE ":FN.REDO.FX.HIST.LIST
    EXECUTE CMD
RETURN
PROCESS:
*------
    SEL.FX = "SELECT ":FN.FX.HIST:" WITH @ID LIKE ":Y.YEAR:"..."
    CALL EB.READLIST(SEL.FX,SEL.LIST,'',NO.OF.REC,SEL.ERR)
*    CALL BATCH.BUILD.LIST("",SEL.LIST)
    EB.Service.BatchBuildList("",SEL.LIST);* R22 UTILITY AUTO CONVERSION
RETURN
END
