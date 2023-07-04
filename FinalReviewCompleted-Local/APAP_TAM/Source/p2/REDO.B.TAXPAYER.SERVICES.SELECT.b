* @ValidationCode : MjoyNDA1ODA5OTk6Q3AxMjUyOjE2ODQ0OTEwMzAyNjM6SVRTUzotMTotMTotMTM6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -13
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.B.TAXPAYER.SERVICES.SELECT
*---------------------------------------------------------------------------------------------
*
* Description           : Batch routine to report information about Sales of Goods and / or Services made by the taxpayer during the fiscal period ended

* Developed By          : Thilak Kumar K
*
* Development Reference : RegN9
*
* Attached To           : Batch - BNK/APAP.B.TAXPAYER.SERVICES
*
* Attached As           : Online Batch Routine to COB
*---------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*---------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00350484          Ashokkumar.V.P                  18/12/2014           Report changed to run on all frequency
* PACS00463470          Ashokkumar.V.P                  23/06/2015           Mapping change to display for RNC and Cedula
** 21-04-2023 R22 Auto Conversion no changes
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_F.BATCH ;* R22 Auto conversion
    $INSERT I_REDO.B.TAXPAYER.SERVICES.COMMON ;* R22 Auto conversion
*
    GOSUB SELECT.PROCESS
*
RETURN
*---------------------------------------------------------------------------------------------
*
SELECT.PROCESS:
*--------------
    CALL EB.CLEAR.FILE(FN.DR.REG.REGN9.WORKFILE, F.DR.REG.REGN9.WORKFILE)
    SEL.CMD = "SELECT ":FN.REDO.NCF.ISSUED:" WITH DATE LIKE ":Y.DATE.REQ:"..."
*SEL.CMD = "SELECT ":FN.REDO.NCF.ISSUED:" WITH @ID EQ 7800857.20180516.FT1813602088 635703.20180518.FT1813845370 478802.20180501.FT1812121922 00112755269.20180501.TT1812125782"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,RET.CODE)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
*
RETURN
*---------------------------------------------------------------------------------------------
END
*---------------------------------------------------------------------------------------------
