* @ValidationCode : MjotMjAyNzc4OTI4ODpDcDEyNTI6MTY4MDc5MDEwNjczMzpJVFNTOi0xOi0xOi01OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -5
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.ACH.TRANSFER.ROU.SELECT
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.B.ACH.TRANSFER.ROU.SELECT
* ODR NUMBER    : PACS0006290 - ODR-2011-01-0492
*--------------------------------------------------------------------------------------
* Description   : This routine will run while daily cob and create FT records
* In parameter  : Y.ID
* out parameter : none
*--------------------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE                      DESCRIPTION
* 01-06-2011      MARIMUTHU s     ODR-2011-01-0492 (PACS0006290)    Initial Creation
* 04-APR-2023     Conversion tool    R22 Auto conversion            No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion           No changes
*--------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.ACH.TRANSFER.ROU.COMMON

MAIN:


    SEL.CMD = 'SELECT ':FN.REDO.ACH.TRANSFER.DETAILS:' WITH TRANS.ACH EQ "NO" BY CLIENT.ID BY DEPOSIT.NO'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN

END
