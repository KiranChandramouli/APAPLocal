* @ValidationCode : MjotMTg2MzUwNjYwOTpDcDEyNTI6MTcwMzY3ODM5OTAzMDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Dec 2023 17:29:59
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
SUBROUTINE REDO.B.INT.CALC.SELECT
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.B.INT.CALC.SELECT
*-------------------------------------------------------------------------
* Description: This routine is a select routine used to Select the records
*
*----------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                                   DESCRIPTION
* 22-11-10          ODR-2010-09-0251                       Initial Creation
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C    Manual R22 conversion      No changes
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.LIMIT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT.DEBIT.INT
    $INSERT I_F.GROUP.DEBIT.INT
*    $INSERT I_BATCH.FILES;*R22 Manual Conversion
    $INSERT I_F.REDO.INTEREST.REVERSE
    $INSERT I_REDO.B.INT.CALC.COMMON
    
    $USING EB.Service

    GOSUB PROCESS
RETURN

PROCESS:

*    SEL.CMD = "SELECT ":FN.ACCOUNT:" WITH L.AC.TRANS.INT EQ Y "
*    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.ERR)
    SEL.LIST = R.REDO.W.ACCOUNT.UPDATE
*   CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST) ;*R22 Manual Conversion

RETURN

END
