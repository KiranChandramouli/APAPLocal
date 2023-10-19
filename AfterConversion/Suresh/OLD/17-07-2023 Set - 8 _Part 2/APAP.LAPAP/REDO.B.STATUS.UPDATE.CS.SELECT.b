* @ValidationCode : MjotMTY0NDE1MzUzMjpDcDEyNTI6MTY4OTMzOTg0Nzg1NDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Jul 2023 18:34:07
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
$PACKAGE APAP.LAPAP

SUBROUTINE REDO.B.STATUS.UPDATE.CS.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*--------------------------------------------------------------------------------
*Development for Subroutine to perform the selection of the batch job
* Revision History:
*------------------
*   20/10/2016        V.P.Ashokkumar                      R15 Upgrade Changes - Insert file name.
*13/07/2023      Conversion tool            R22 Auto Conversion            INCLUDE TO INSERT, BP removed in INSERT file
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion
    $INSERT I_EQUATE ;*R22 Auto Conversion
    $INSERT I_REDO.B.STATUS.UPDATE.CS.COMMON ;*R22 Auto Conversion

    GOSUB SEL.REC
RETURN

*-------
SEL.REC:
*-------
    SEL.CUST.CMD = ''; SEL.CUST.LIST=''; NO.OF.REC=''; SCUST.ERR = ''
    SEL.CUST.CMD="SELECT ":FN.CUSTOMER:" WITH CUSTOMER.STATUS EQ 1 AND L.CU.TARJ.CR EQ 'YES'"
    CALL EB.READLIST(SEL.CUST.CMD,SEL.CUST.LIST,'',NO.OF.REC,SCUST.ERR)
    CALL BATCH.BUILD.LIST('',SEL.CUST.LIST)
RETURN
END
