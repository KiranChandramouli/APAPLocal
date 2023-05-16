* @ValidationCode : MjotODgxNzI1MjU5OkNwMTI1MjoxNjg0MTUzMjk5Njg2OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 May 2023 17:51:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.COBROS.SEG.REVERT
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.COBROS.SEG.REVERT
* Date           : 2018-07-03
* Item ID        : --------------
*========================================================================
* Brief description :
* -------------------
* This program allow revers record with pending status in FUNDS.TRANSFER
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-07-03     Richard HC         Initial Development
*Modification history
*Date                Who               Reference                  Description
*21-04-2023      conversion tool     R22 Auto code conversion     No changes
*21-04-2023      Mohanraj R          R22 Manual code conversion   Call Method Format Modified
*========================================================================
* Content summary :
* =================
* Table name     :F.FUNDS.TRANSFER$NAU
* Auto Increment :N/A
* Views/versions :LAPAP.ENQ.COBROS.SEG.REVERT
* EB record      :N/A
* Routine        :LAPAP.COBROS.SEG.REVERT
*========================================================================


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER

    FN.FUND = "F.FUNDS.TRANSFER$NAU"
    F.FUND = ""
    CALL OPF(FN.FUND,F.FUND)

    QUERY = "SELECT FBNK.FUNDS.TRANSFER$NAU WITH ORDERING.BANK EQ 'COBRO SEGUROS'"

    CALL EB.READLIST(QUERY,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID

        APP = "FUNDS.TRANSFER"
        ID = Y.TEMP.ID
        Y.FUNC = "D"
*RSS<FT.CREDIT.AMOUNT> = 1234
        RSS = ""
        CALL APAP.LAPAP.lapapBuildOfsLoad(APP,Y.FUNC,ID,RSS) ;*;*R22 Manual Code Conversion-Call Method Format Modified

    REPEAT

RETURN

END
