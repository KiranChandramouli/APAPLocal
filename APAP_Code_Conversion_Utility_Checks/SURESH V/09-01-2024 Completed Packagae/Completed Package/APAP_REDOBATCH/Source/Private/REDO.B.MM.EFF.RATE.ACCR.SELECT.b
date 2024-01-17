* @ValidationCode : MjotMjM4OTc1NzA4OkNwMTI1MjoxNzA0MzY1Nzg3NzA1OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Jan 2024 16:26:27
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
SUBROUTINE REDO.B.MM.EFF.RATE.ACCR.SELECT
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.MM.EFF.RATE.ACCR.SELECT
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.B.MM.EFF.RATE.ACCR.SELECT is the select routine to make a select on the
*               MM.MONEY.MARKET file with local reference field L.MM.ACCRUE.MET equal to .EFFECTIVE RATE
*Linked With  : REDO.B.MM.EFF.RATE.ACCR
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date           Who                  Reference           Description
* ------         ------               -------------       -------------
* 12 FEB 2013    Balagurunathan B     RTC-553577          Initial Creation
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_REDO.B.MM.EFF.RATE.ACCR.COMMON
    $USING EB.Service

*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

    SEL.CMD = "SELECT ":FN.MM.MONEY.MARKET:" WITH L.MM.ACCRUE.MET EQ 'EFFECTIVE RATE' AND WITH INT.PERIOD.END GE ":TODAY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.REC,SEL.ERR)

*CALL BATCH.BUILD.LIST("",SEL.LIST)
    EB.Service.BatchBuildList("",SEL.LIST);* R22 AUTO CONVERSION

RETURN
*--------------------------------------------------------------------------------------------------------
END
