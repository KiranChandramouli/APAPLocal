* @ValidationCode : MjotNTU4NDA3MDAxOkNwMTI1MjoxNjgwNzYwMzM2MDU2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 11:22:16
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.REJECT.REASON(Y.REGULATORY,Y.REDO.REJECT.REASON)
*-----------------------------------------------------------------------------
*Description: This routine is to get the Reject Reason code
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.REDO.REJECT.REASON = ''
    IF Y.REGULATORY ELSE
        RETURN
    END

    FN.REDO.REJECT.REASON = 'F.REDO.REJECT.REASON'
    F.REDO.REJECT.REASON  = ''
    CALL OPF(FN.REDO.REJECT.REASON,F.REDO.REJECT.REASON)

    SEL.CMD = 'SELECT ':FN.REDO.REJECT.REASON:' WITH RETURN.CODE EQ "':Y.REGULATORY:'"'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)

    Y.REDO.REJECT.REASON = SEL.LIST<1>

RETURN
END
