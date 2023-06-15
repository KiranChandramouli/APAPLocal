* @ValidationCode : MjoxODI1MzIyNzc3OkNwMTI1MjoxNjg0MjIyODA3NzkyOklUU1M6LTE6LTE6MTAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 100
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*========================================================================
SUBROUTINE LAPAP.DELETE.CUST.PRD.LIST.LOAD
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.DELETE.CUST.PRD.LIST.LOAD
* Date           : 2018-01-31
* Item ID        : CN00
*========================================================================
* Brief description :
* -------------------
* This a multi-threading program for inject data in monitor interface
* without use any version.
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-01-31     Richard HC        Initial Development
*Modification history
*Date                Who               Reference                  Description
*21-04-2023      conversion tool     R22 Auto code conversion     No changes
*21-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*========================================================================
* Content summary :
* =================
* Table name     :
* Auto Increment : N/A
* Views/versions : N/A
* EB record      : LAPAP.DELETE.CUST.PRD.LIST.LOAD
* Routine        : LAPAP.DELETE.CUST.PRD.LIST.LOAD
*========================================================================


    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.CUST.PRD.LIST

    FN.PRD.LIST = "F.REDO.CUST.PRD.LIST"
    F.PRD.LIST = ""
    CALL OPF(FN.PRD.LIST,F.PRD.LIST)

RETURN

END
