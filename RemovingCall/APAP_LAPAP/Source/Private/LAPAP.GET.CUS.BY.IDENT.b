* @ValidationCode : MjotODc3NjEyMjE1OkNwMTI1MjoxNjg0MjIyODA5MDgwOklUU1M6LTE6LTE6MTkxOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 191
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.GET.CUS.BY.IDENT(R.CUSTOMER, CUS.IDENT, IDENT.TYPE, CUS.ID)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.GET.CUS.BY.IDENT
* Date           : 2018-06-19
* Item ID        : CN008702
*========================================================================
* Brief description :
* -------------------
* Routine that receives the identification of a client and returns the object R.CUSTOMER
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-06-19     Anthony Martinez  Initial Development
*Modification history
*Date                Who               Reference                  Description
*24-04-2023      conversion tool     R22 Auto code conversion     No changes
*24-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*========================================================================

    GOSUB PROCESS

PROCESS:
*-------
*--PARA ABRIR EL ACHIVO CUSTOMER
    FN.CUS    = "FBNK.CUSTOMER"
    F.CUS     = ""
    RS.CUS    = ""
    CUS.ERR   = ""
    SEL.LIST  = ""
    SEL.ERR   = ""
    NO.OF.REC = ""
    Y.FIELD   = ""

    BEGIN CASE
        CASE IDENT.TYPE EQ 'CEDULA'
            Y.FIELD = 'L.CU.CIDENT'
        CASE IDENT.TYPE EQ 'RNC'
            Y.FIELD = 'L.CU.RNC'
        CASE IDENT.TYPE EQ 'PASAPORTE'
            Y.FIELD = 'L.CU.PASS.NAT'
    END CASE

    SEL.CMD = "SELECT ":FN.CUS:" WITH ":Y.FIELD:" EQ ":CUS.IDENT
    CALL OPF(FN.CUS, F.CUS)

*--EJECUTAMOS LA CONSULTA A LA TABLA DE CUSTOMER
    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.REC,SEL.ERR)
    LOOP
        REMOVE Y.CUS.ID FROM SEL.LIST SETTING RTE.POS
    WHILE Y.CUS.ID DO
        CALL F.READ(FN.CUS, Y.CUS.ID, RS.CUS, F.CUS, CUS.ERR)
        R.CUSTOMER = RS.CUS
        CUS.ID     = Y.CUS.ID
    REPEAT

RETURN
*-------
