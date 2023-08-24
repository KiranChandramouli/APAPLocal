* @ValidationCode : MjoxNjU0MjM0MzUwOkNwMTI1MjoxNjgyMDc4ODcxOTI5OklUU1M6LTE6LTE6MTUzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:37:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 153
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.CARD.NO.LIST(TX.ARRAY)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.NOF.REQUEST.REGOFF
*--------------------------------------------------------------------------------------------------------
*Description  : This is a no file enquiry routine for the enquiry REDO.CARD.REGOFF
*Linked With  : Enquiry REDO.LIST.NUMBERS
*In Parameter : N/A
*Out Parameter: TX.ARRAY
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------                -------------            -------------
* 4th Aug 2010    SWAMINATHAN.S.R        ODR-2010-03-0400        Initial Creation
*
* 18-APR-2023     Conversion tool   R22 Auto conversion    FM TO @FM, VM to @VM, ++ to +=, = to EQ
* 18-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.CARD.NUMBERS
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********


    GOSUB OPEN.PARA
    GOSUB SEL.PROC
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********

    FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
    F.REDO.CARD.NUMBERS = ''
    R.REDO.CARD.NUMBERS = ''
    REDO.CARD.NUMBERS.ERR = ''
    CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

    SELECTION.FLAG = ''
    Y.CARD.VAL = ''
    Y.CARD.REQ.VAL = ''
    Y.ID.VAL = ''

RETURN
*--------------------------------------------------------------------------------------------------------
SEL.PROC:
***********

    GOSUB LOCATE.PROC

    SEL.CMD = 'SELECT ':FN.REDO.CARD.NUMBERS


    IF Y.ID.VAL NE '' THEN

        BEGIN CASE
            CASE Y.OPERAND EQ '1'
                SEL.CMD :=" WITH @ID EQ ":Y.ID.VAL

            CASE Y.OPERAND EQ '6'
                SEL.CMD :=" WITH @ID LIKE ...":Y.ID.VAL:"..."

            CASE Y.OPERAND EQ '7'
                SEL.CMD :=" WITH @ID UNLIKE ...":Y.ID.VAL:"..."

        END CASE

    END

    IF Y.CARD.VAL NE '' THEN
        SEL.CMD :=" WITH CARD.NUMBER EQ ":Y.CARD.VAL
    END

    IF Y.CARD.REQ.VAL NE '' THEN

        SEL.CMD :=" WITH CRD.REQ.ID EQ ":Y.CARD.REQ.VAL
    END

RETURN
*--------------------------------------------------------------------------------------------------------
LOCATE.PROC:
**************

    LOCATE "@ID" IN D.FIELDS<1> SETTING ID.POS THEN
        Y.OPERAND=D.LOGICAL.OPERANDS<ID.POS>
        Y.ID.VAL = D.RANGE.AND.VALUE<ID.POS>
        SELECTION.FLAG = 1
    END

    LOCATE "CARD.NUMBER" IN D.FIELDS<1> SETTING Y.CARD.POS  THEN
        Y.CARD.VAL  = D.RANGE.AND.VALUE<Y.CARD.POS>
        SELECTION.FLAG = 1

    END

    LOCATE "CRD.REQ.ID" IN D.FIELDS<1> SETTING Y.CARD.REQ.POS THEN
        Y.CARD.REQ.VAL  = D.RANGE.AND.VALUE<Y.CARD.REQ.POS>
        SELECTION.FLAG = 1
    END

RETURN
*---------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
************

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',COUNT.LIST,ERR)
    LOOP
        REMOVE Y.CARD.REQ.ID FROM SEL.LIST SETTING POS
    WHILE Y.CARD.REQ.ID : POS

        FETCH.CARD.NUMBER = ''
        FETCH.STATUS = ''
        FETCH.EMBOSS.TYPE = ''
        FETCH.PERSONAL.TYPE = ''
        FETCH.TYPE.OF.CARD = ''
        FETCH.CRD.REQ.ID =  ''
        FETCH.EXPIRY.DATE = ''

        CALL F.READ(FN.REDO.CARD.NUMBERS,Y.CARD.REQ.ID,R.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS,REDO.CARD.NUMBERS.ERR)
        IF R.REDO.CARD.NUMBERS THEN

            NUM.CARD.NUMBER = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER>
            NUM.STATUS = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS>
            NUM.EMBOSS.TYPE = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.EMBOSS.TYPE>
            NUM.PERSONAL.TYPE = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.PERSONAL.TYPE>
            NUM.TYPE.OF.CARD = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.TYPE.OF.CARD>
            NUM.CRD.REQ.ID = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CRD.REQ.ID>
            NUM.EXPIRY.DATE = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.EXPIRY.DATE>

            CHANGE @VM TO @FM IN NUM.CARD.NUMBER
            CHANGE @VM TO @FM IN NUM.STATUS
            CHANGE @VM TO @FM IN NUM.EMBOSS.TYPE
            CHANGE @VM TO @FM IN NUM.PERSONAL.TYPE
            CHANGE @VM TO @FM IN NUM.TYPE.OF.CARD
            CHANGE @VM TO @FM IN NUM.CRD.REQ.ID
            CHANGE @VM TO @FM IN NUM.EXPIRY.DATE

            GOSUB NEXT.PROCESS.STEP
        END

    REPEAT

RETURN
*-------------------------------------
NEXT.PROCESS.STEP:

    TOTL.CARD.CNTR = DCOUNT(NUM.CARD.NUMBER,@FM)
    CARD.CNTR = 1

    LOOP
    WHILE CARD.CNTR LE TOTL.CARD.CNTR

        FETCH.CARD.NUMBER = NUM.CARD.NUMBER<CARD.CNTR>
        FETCH.STATUS = NUM.STATUS<CARD.CNTR>
        FETCH.EMBOSS.TYPE = NUM.EMBOSS.TYPE<CARD.CNTR>
        FETCH.PERSONAL.TYPE = NUM.PERSONAL.TYPE<CARD.CNTR>
        FETCH.TYPE.OF.CARD = NUM.TYPE.OF.CARD<CARD.CNTR>
        FETCH.CRD.REQ.ID =  NUM.CRD.REQ.ID<CARD.CNTR>
        FETCH.EXPIRY.DATE = NUM.EXPIRY.DATE<CARD.CNTR>

        IF SELECTION.FLAG EQ 1 THEN
            IF Y.ID.VAL THEN
                GOSUB FINAL.ARRAY
            END

            IF FETCH.CARD.NUMBER EQ Y.CARD.VAL THEN
                GOSUB FINAL.ARRAY
            END

            IF FETCH.CRD.REQ.ID EQ Y.CARD.REQ.VAL THEN
                GOSUB FINAL.ARRAY
            END

        END ELSE
            GOSUB FINAL.ARRAY
        END

        CARD.CNTR += 1

    REPEAT


RETURN
*--------------------------------------------------------------------------------------------------------
FINAL.ARRAY:

    TX.ARRAY<-1> = Y.CARD.REQ.ID:"*":FETCH.CARD.NUMBER:'*':FETCH.STATUS:'*':FETCH.EMBOSS.TYPE:'*':FETCH.PERSONAL.TYPE:'*':FETCH.TYPE.OF.CARD:'*':FETCH.CRD.REQ.ID:'*':FETCH.EXPIRY.DATE


RETURN
END
