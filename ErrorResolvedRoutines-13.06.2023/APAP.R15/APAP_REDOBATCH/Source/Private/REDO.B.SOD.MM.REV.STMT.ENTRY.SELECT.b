* @ValidationCode : MjotNjAzMDIyNjE1OkNwMTI1MjoxNjgwNjkwNDYwNzkxOklUU1M6LTE6LTE6LTE0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:57:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -14
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.SOD.MM.REV.STMT.ENTRY.SELECT
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
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_REDO.B.MM.EFF.RATE.ACCR.COMMON

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

    CALL BATCH.BUILD.LIST("",SEL.LIST)

RETURN
*--------------------------------------------------------------------------------------------------------
END
