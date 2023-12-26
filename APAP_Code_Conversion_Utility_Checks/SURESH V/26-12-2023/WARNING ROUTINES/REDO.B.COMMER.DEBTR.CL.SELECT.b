* @ValidationCode : MjotMzU4MjQ4Njg3OkNwMTI1MjoxNzAzNTY1MjM2MDg4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Dec 2023 10:03:56
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.COMMER.DEBTR.CL.SELECT
*
* Description           : This is the Batch Main Process Routine used to process the all AA Customer Id
*                         and get the Report Related details and Write the details in file.
*
* Development Reference : CL01
*
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
* PACS00466001           Ashokkumar.V.P                 29/06/2016            Initial Release
* 04-APR-2023     	 Conversion tool    		R22 Auto conversion       No changes
* 04-APR-2023          Harishvikram C          Manual R22 conversion      No changes
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    $INSERT I_REDO.B.COMMER.DEBTR.CL.COMMON
    
    $USING EB.Service
   

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*---
    SEL.LIST = ''; SEL.CMD = ''; NO.OF.REC = ''; SEL.ERR = ''
RETURN

PROCESS:
*------
*    CALL EB.CLEAR.FILE(FN.DR.REG.CL01.WORKFILE, F.DR.REG.CL01.WORKFILE)
    EB.Service.ClearFile(FN.DR.REG.CL01.WORKFILE, F.DR.REG.CL01.WORKFILE) ;*R22 Manual Conversion
    SEL.CMD.CUS = "SELECT ":FN.REDO.CUSTOMER.ARRANGEMENT
    CALL EB.READLIST(SEL.CMD.CUS,SEL.LIST,'',NO.OF.REC,SEL.ERR)
*    CALL BATCH.BUILD.LIST("",SEL.LIST)
    EB.Service.BatchBuildList("",SEL.LIST) ;*R22 Manual Conversion
RETURN
END
