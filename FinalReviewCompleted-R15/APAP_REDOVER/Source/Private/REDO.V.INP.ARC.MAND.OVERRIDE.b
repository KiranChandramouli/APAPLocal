* @ValidationCode : MjotNzcwMjkxOTczOkNwMTI1MjoxNjgyNDEyMzQ3NDE0OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE  REDO.V.INP.ARC.MAND.OVERRIDE
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------


* INPUT/OUTPUT:
*--------------

* OUT : N/A

* DEPENDDENCIES:
*Modification history
*Date                Who               Reference                  Description
*13-04-2023      conversion tool     R22 Auto code conversion     No changes
*13-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.ACCOUNT
    $INSERT I_GTS.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.STANDING.ORDER
    GOSUB PROCESS
RETURN

*~~~~~~~~~~~~~~~
PROCESS:
*~~~~~~~~~~~~~~~

    TEXT  = 'EB-MINIMUM.SIGNATORY.NOT.REACHED'      ;* Set TEXT for Override
    CALL STORE.OVERRIDE(CURR.NO)          ;* Raise the Override

RETURN
END
