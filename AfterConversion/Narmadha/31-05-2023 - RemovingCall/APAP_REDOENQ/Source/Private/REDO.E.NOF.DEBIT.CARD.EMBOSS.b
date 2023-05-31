* @ValidationCode : MjotMTM1OTgzMTc3MjpDcDEyNTI6MTY4MjA3ODg3MTk2MzpJVFNTOi0xOi0xOjE3NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:37:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 176
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.DEBIT.CARD.EMBOSS(Y.FINAL.ARRAY)
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.NOF.DEBIT.CARD.EMBOSS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is a template routine
*
*</doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 6 JUN 2010    KAVITHA                 PACS00024249             Initial Creation
*
* 18-APR-2023     Conversion tool   R22 Auto conversion    FM TO @FM, VM to @VM
* 18-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.BRANCH.REQ.STOCK
*********************************************************

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
*-----
    Y.FINAL.ARRAY = ''
    FN.REDO.BRANCH.REQ.STOCK = 'F.REDO.BRANCH.REQ.STOCK'
    F.REDO.BRANCH.REQ.STOCK = ''
    CALL OPF(FN.REDO.BRANCH.REQ.STOCK,F.REDO.BRANCH.REQ.STOCK)

RETURN
PROCESS:
*--------
    LOCATE "DATE" IN D.FIELDS<1> SETTING Y.DATE.POS  THEN
        Y.DATE.VAL         = D.RANGE.AND.VALUE<Y.DATE.POS>
        Y.DATE.VAL.FROM = D.RANGE.AND.VALUE<Y.DATE.POS,1,1>
        Y.DATE.VAL.TO = D.RANGE.AND.VALUE<Y.DATE.POS,1,2>

    END
    IF NOT(NUM(Y.DATE.VAL.FROM)) OR LEN(Y.DATE.VAL.FROM) NE '8' OR NOT(NUM(Y.DATE.VAL.TO)) OR LEN(Y.DATE.VAL.TO) NE '8' THEN
        ENQ.ERROR = 'EB-REDO.DATE.RANGE'
        RETURN
    END

    IF Y.DATE.VAL.FROM[5,2] GT 12 OR Y.DATE.VAL.TO[5,2] GT 12 OR Y.DATE.VAL.FROM[7,2] GT 31 OR Y.DATE.VAL.TO[7,2] GT 31 THEN
        ENQ.ERROR = 'EB-REDO.DATE.RANGE'
        RETURN
    END

    IF Y.DATE.VAL.TO GT TODAY OR Y.DATE.VAL.FROM GT TODAY OR Y.DATE.VAL.FROM GT Y.DATE.VAL.TO THEN
        ENQ.ERROR = 'EB-REDO.GT.TODAY'
        RETURN
    END

    SEL.ACC="SELECT ":FN.REDO.BRANCH.REQ.STOCK:" WITH TXN.DATE GE ":Y.DATE.VAL.FROM:" AND TXN.DATE LE ":Y.DATE.VAL.TO:" BY CARD.TYPE"

    CALL EB.READLIST(SEL.ACC,SEL.LIST,'',NO.OF.REC,Y.ERR)

    LOOP
        REMOVE  RECORD.ID FROM SEL.LIST SETTING Y.AC.POS
    WHILE RECORD.ID : Y.AC.POS

        CALL F.READ(FN.REDO.BRANCH.REQ.STOCK,RECORD.ID,R.REDO.BRANCH.REQ.STOCK,F.REDO.BRANCH.REQ.STOCK,Y.ERR)

        Y.TRANS.DATE         =   R.REDO.BRANCH.REQ.STOCK<BRAN.STK.TXN.DATE>
        INITIAL.STK           =   R.REDO.BRANCH.REQ.STOCK<BRAN.STK.INITIAL.STK>
        IF NOT(INITIAL.STK<1,1>) THEN
            INITIAL.STK<1,1>=0
        END
        CHANGE @VM TO @FM IN INITIAL.STK
        TOT.MV = DCOUNT(INITIAL.STK,@FM)
        LOOP.INT.CNT = 1

        LOOP
        WHILE LOOP.INT.CNT LE TOT.MV
            GOSUB FETCH.ARRAY.VALUES
            LOOP.INT.CNT += 1
        REPEAT

    REPEAT

RETURN
*--------------
FETCH.ARRAY.VALUES:
    GET.INITIAL.STK=''
    REQUEST.ID        = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.REQUEST.ID,LOOP.INT.CNT>
    Y.PREV.PR.CODE    = PRODUCT.CODE
    PRODUCT.CODE      = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.CARD.TYPE>
    PRODUCT.TYPE      = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.CARD.TYPE>
    VIRGIN.LOAD       = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.VIRGIN.LOAD,LOOP.INT.CNT>
    QUANTITY.RECD     = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.QTY.REQUEST,LOOP.INT.CNT>
    DAMAGED.AT.BRANCH = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.DAMAGE,LOOP.INT.CNT>
    LOST              = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.LOST,LOOP.INT.CNT>
    RETURN.VALUE      = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.RETURN,LOOP.INT.CNT>
    DELIVERED         = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.DELIVERED,LOOP.INT.CNT>
    CURRENT.QTY       = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.CURRENT.QTY,LOOP.INT.CNT>
    AGENCY            = R.REDO.BRANCH.REQ.STOCK<BRAN.STK.AGENCY,LOOP.INT.CNT>
    IF Y.PREV.PR.CODE NE PRODUCT.CODE THEN
        GET.INITIAL.STK   = INITIAL.STK<LOOP.INT.CNT>
    END
    GOSUB FORM.ARRAY

RETURN

FORM.ARRAY:
*----------
    Y.FINAL.ARRAY<-1>    =   Y.TRANS.DATE:'*':GET.INITIAL.STK:'*':REQUEST.ID:'*':PRODUCT.CODE:'*':QUANTITY.RECD:"*":DAMAGED.AT.BRANCH:'*':LOST:'*':RETURN.VALUE:'*':DELIVERED:'*':CURRENT.QTY:'*':AGENCY:"*":VIRGIN.LOAD

RETURN

END
