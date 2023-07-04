* @ValidationCode : MjoxOTM0Nzk1MTk4OkNwMTI1MjoxNjgyMzMxNTY2MDczOklUU1M6LTE6LTE6LTEyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -12
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.COMMER.DEBTOR.BAL.SELECT
*--------------------------------------------------------------------------------------------------
*
* Description           : This is the Batch Select Routine Used to select the required Files
*
*
* Developed On          : 11-Nov-2013
*
* Developed By          : Amaravathi Krithika B
*
* Development Reference : DE08
*
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*-----------------*
* Output Parameter:
* ----------------*
* Argument#2 : NA
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
*--------------------------------------------------------------------------------------------------
* PACS00361295           Ashokkumar.V.P                 15/05/2015            Added new fields to show customer loans.
* PACS00464363           Ashokkumar.V.P                 22/06/2015            Changed to avoid ageing problem and mapping changes
* PACS00466000           Ashokkumar.V.P                 24/06/2015            Mapping changes - Remove L.CU.DEBTOR field

*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - INSERT file folder name removed T24.BP, TAM.BP, LAPAP.BP
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON                            ;** R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    $INSERT I_REDO.B.COMMER.DEBTOR.BAL.COMMON     ;** R22 Auto conversion - END

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*---
    SEL.LIST = ''; SEL.CMD = ''; NO.OF.REC = ''; SEL.ERR = ''
RETURN

PROCESS:
*------
    CALL EB.CLEAR.FILE(FN.DR.REG.DE08.WORKFILE, F.DR.REG.DE08.WORKFILE)
    SEL.CMD.CUS = "SELECT ":FN.REDO.CUSTOMER.ARRANGEMENT
    CALL EB.READLIST(SEL.CMD.CUS,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST("",SEL.LIST)
RETURN
END
