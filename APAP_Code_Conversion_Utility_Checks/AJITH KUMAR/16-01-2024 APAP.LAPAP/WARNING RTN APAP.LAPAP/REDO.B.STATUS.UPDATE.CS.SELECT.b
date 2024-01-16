* @ValidationCode : MjotMTY0NDE1MzUzMjpDcDEyNTI6MTY4OTc0NDU2OTQzNjpJVFNTOi0xOi0xOi03OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Jul 2023 10:59:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
   $USING EB.Service

    GOSUB SEL.REC
RETURN

*-------
SEL.REC:
*-------
    SEL.CUST.CMD = ''; SEL.CUST.LIST=''; NO.OF.REC=''; SCUST.ERR = ''
    SEL.CUST.CMD="SELECT ":FN.CUSTOMER:" WITH CUSTOMER.STATUS EQ 1 AND L.CU.TARJ.CR EQ 'YES'"
    CALL EB.READLIST(SEL.CUST.CMD,SEL.CUST.LIST,'',NO.OF.REC,SCUST.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.CUST.LIST)
EB.Service.BatchBuildList('',SEL.CUST.LIST);* R22 UTILITY AUTO CONVERSION
RETURN
END
