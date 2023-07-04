* @ValidationCode : MjotMjkwNzE3OTIxOkNwMTI1MjoxNjgyNDE1MTUxMzg2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 15:02:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.UPD.CUS.ACTANAC.SELECT

* Correction routine to update the file F.CUSTOMER.L.CU.ACTANAC
*---------------------------------------------------------------------------
*Modification history
*Date                Who               Reference                  Description
*11-04-2023      conversion tool     R22 Auto code conversion     No changes
*11-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_REDO.S.UPD.CUS.ACTANAC.COMMON

    GOSUB PROCESS

RETURN

*********
PROCESS:
*********
* Main process to selct all the customer with actanac id

    SEL.LIST = ''

    SEL.CMD = "SELECT ":FN.CUS:" WITH L.CU.ACTANAC NE '' "

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)

    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
