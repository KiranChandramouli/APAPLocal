* @ValidationCode : MjozOTI5OTIyNTk6Q3AxMjUyOjE2ODEyODU5NDY1Mjg6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 13:22:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.QTY.CHECK
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------
* Modification History
* DATE            ODR           BY              DESCRIPTION
* 25-08-2011      PACS00194269  GANESH R        For REDO.H.INVENTORY.PARAMETER
*--------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*12-04-2023       Conversion Tool        R22 Auto Code conversion          FM TO @FM
*12-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_EB.TRANS.COMMON
    $INSERT I_F.REDO.H.ORDER.DETAILS
    $INSERT I_F.REDO.H.INVENTORY.PARAMETER

    IF cTxn_CommitRequests EQ '1' THEN
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END

RETURN

OPEN.FILES:
    FN.REDO.H.PARAMETER = 'F.REDO.H.INVENTORY.PARAMETER'
    F.REDO.H.PARAMETER  = ''
    CALL OPF(FN.REDO.H.PARAMETER,F.REDO.H.PARAMETER)
RETURN

PROCESS:

    CALL CACHE.READ(FN.REDO.H.PARAMETER,'SYSTEM',R.REDO.H.PARAMETER,PARAM.ERR)

    Y.GET.ITEM.CODE.LIST = R.REDO.H.PARAMETER<IN.PR.ITEM.CODE>
    Y.GET.MIN.QTY.LIST   = R.REDO.H.PARAMETER<IN.PR.REORDER.LEVEL>

    Y.CUR.ITEM.CODE = R.NEW(RE.ORD.ITEM.CODE)
    Y.CUR.REQ.QTY   = R.NEW(RE.ORD.REQUEST.QUANTITY)

    LOCATE Y.CUR.ITEM.CODE IN Y.GET.ITEM.CODE.LIST<1,1> SETTING Y.ITEM.POS THEN
        Y.CHQ.MIN.QTY = Y.GET.MIN.QTY.LIST<1,Y.ITEM.POS>
        IF Y.CUR.REQ.QTY LT Y.CHQ.MIN.QTY THEN
            AF = RE.ORD.REQUEST.QUANTITY
            AV = Y.ITEM.POS
            ETEXT = "EB-REDO.REQ.QTY.LESS":@FM:Y.CHQ.MIN.QTY
            CALL STORE.END.ERROR
        END
    END
RETURN
