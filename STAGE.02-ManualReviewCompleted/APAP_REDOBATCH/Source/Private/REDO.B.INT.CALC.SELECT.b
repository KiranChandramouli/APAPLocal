* @ValidationCode : MjoxODg4OTE4MzQ6Q3AxMjUyOjE2ODExMTE4OTQ2MDg6SVRTUzotMTotMTotNzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:01:34
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
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.INTEREST.REVERSE
    $INSERT I_REDO.B.INT.CALC.COMMON

    GOSUB PROCESS
RETURN

PROCESS:

*    SEL.CMD = "SELECT ":FN.ACCOUNT:" WITH L.AC.TRANS.INT EQ Y "
*    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.ERR)
    SEL.LIST = R.REDO.W.ACCOUNT.UPDATE
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
