* @ValidationCode : MjotMTQ1OTQwNjYyMjpDcDEyNTI6MTY4MDc5MDEwNjY5ODpJVFNTOi0xOi0xOjM5NDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 394
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE APAP.B.CREATE.LN.SERVICE.LOAD
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : APAP.B.CREATE.LN.SERVICE
*-----------------------------------------------------------------------------
* Description:
*------------
*
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_APAP.B.CREATE.LN.SERVICE.COMMON

    GOSUB INIT
RETURN

INIT:
    FN.APAP.LN.OFS.CONCAT = 'F.APAP.LN.OFS.CONCAT'
    F.APAP.LN.OFS.CONCAT = ''
    CALL OPF(FN.APAP.LN.OFS.CONCAT,F.APAP.LN.OFS.CONCAT)

    FN.REDO.CREATE.ARRANGEMENT = 'F.REDO.CREATE.ARRANGEMENT'
    F.REDO.CREATE.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

    FN.LIMIT = 'F.LIMIT'
    F.LIMIT = ''
    CALL OPF(FN.LIMIT,F.LIMIT)

    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL = ''
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
RETURN
*----------------------------------------------------------------
END
