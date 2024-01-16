* @ValidationCode : MjotMjAxNjM4MjI2MzpDcDEyNTI6MTY5MzIwNzUxNzE2NzpJVFNTOi0xOi0xOi03OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 28 Aug 2023 12:55:17
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
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.PROCESS.TXN.DIVI.SELECT
***********************************************************
*----------------------------------------------------------
*
* COMPANY NAME    : APAP
* DEVELOPED BY    : ROQUEZADA
*
*----------------------------------------------------------
*
* DESCRIPTION     : AUTHORISATION routine to be used in FT versions
*                   to save USD/EUR transfer in historic table
*------------------------------------------------------------
*
* Modification History :
*-----------------------
*  DATE             WHO             REFERENCE                    DESCRIPTION
*2022-09-12       ROQUEZADA                                         CREATE
*09/08/2023       VIGNESHWARI MANUAL R22 CODE CONVERSION  T24.BP,BP & LAPAP.BP is removed in insertfile , FM TO @FM
*----------------------------------------------------------------------
*
    $INSERT I_COMMON ;*MANUAL R22 CODE CONVERSION-START-T24.BP is removed in insertfile
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System  ;*MANUAL R22 CODE CONVERSION-END
    $INSERT I_F.ST.LAPAP.TRANS.DIVISA.SDT ;*MANUAL R22 CODE CONVERSION-BP is removed in insertfile
    $INSERT I_LAPAP.PROCESS.TXN.DIV.COMMON   ;*MANUAL R22 CODE CONVERSION-LAPAP.BP is removed in insertfile
   $USING EB.Service

    GOSUB SELECT

RETURN

* ===
SELECT:
* ===

    NO.OF.REC = ''; SEL.ERR = ''; Y.COUNT.DIV = ''; DIV.POS = '';
    SEL.CMD = "SELECT ":FN.TRANS.DIVISA.SDT:" WITH STATUS.REG EQ ":Y.STATUS.REG;
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR);
    Y.COUNT.DIV = DCOUNT(SEL.LIST,@FM);

    IF Y.COUNT.DIV GT 0 THEN
        Y.DATA = SEL.LIST;
*        CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION
    END

RETURN

END
