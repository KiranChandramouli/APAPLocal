* @ValidationCode : MjotMTIyMzY4NzA5NzpDcDEyNTI6MTcwNDE3NjcyMjU1NzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Jan 2024 11:55:22
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
SUBROUTINE REDO.B.LOAN.PRD.UPD.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : SHANKAR RAJU
* Program Name : REDO.B.LOAN.PRD.UPD.SELECT
*--------------------------------------------------------------------------------
* Description: Subroutine to perform the selection of the batch job

* Linked with   : None
* In Parameter  : None
* Out Parameter : SEL.CUSTOMER.LIST
*--------------------------------------------------------------------------------
* Modification History:
*02/01/2010 - ODR-2009-10-0535
*Development for Subroutine to perform the selection of the batch job
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*02/01/2024         Suresh                R22 Manual Conversion   CALL routine modified
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.LOAN.PRD.UPD.COMMON
    $USING EB.Service

    GOSUB INIT
    GOSUB SEL.REC

RETURN
*----
INIT:
*----
    SEL.CUSTOMER.CMD="SELECT ":FN.CUST.PRD.LIST:" WITH PRD.STATUS EQ 'ACTIVE' AND WITH TYPE.OF.CUST EQ 'LOAN'"
    SEL.CUSTOMER.LIST=''
    NO.OF.REC=''
RETURN
*-------
SEL.REC:
*-------
    CALL EB.READLIST(SEL.CUSTOMER.CMD,SEL.CUSTOMER.LIST,'',NO.OF.REC,AZ.ERR)
*    CALL BATCH.BUILD.LIST('', SEL.CUSTOMER.LIST)
    EB.Service.BatchBuildList('', SEL.CUSTOMER.LIST) ;*R22 Manual Conversion
RETURN
END
