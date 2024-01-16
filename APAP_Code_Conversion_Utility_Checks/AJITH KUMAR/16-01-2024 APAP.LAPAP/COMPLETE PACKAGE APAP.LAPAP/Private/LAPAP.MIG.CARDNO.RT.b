* @ValidationCode : MjoxMDc4ODI2MTEzOkNwMTI1MjoxNjkyOTQ2NjQ1MDM2OklUU1M6LTE6LTE6OTUwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Aug 2023 12:27:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 950
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

*-----------------------------------------------------------------------------
* <Rating>-93</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.MIG.CARDNO.RT
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*09/08/2023          Suresh              R22 Manual Conversion    T24.BP, BP is removed
*----------------------------------------------------------------------------------------
    $INSERT  I_EQUATE ;*R22 Manual Conversion -Start
    $INSERT  I_F.COMPANY
    $INSERT  I_F.LAPAP.BIN.SEQ.CTRL
    $INSERT  I_F.LAPAP.CARD.GEN.CARDS
    $INSERT  I_F.REDO.CARD.NUMBERS ;*R22 Manual Conversion -End
   $USING EB.TransactionControl

    GOSUB OPEN.PARA
    GOSUB DO.MIG

RETURN

OPEN.PARA:
    FN.BIN.CTRL = "F.ST.LAPAP.BIN.SEQ.CTRL"
    F.BIN.CTRL = ""
    CALL OPF(FN.BIN.CTRL , F.BIN.CTRL)

    FN.GEN.CARDS = 'F.ST.LAPAP.CARD.GEN.CARDS'
    F.GEN.CARDS = ''
    CALL OPF(FN.GEN.CARDS,F.GEN.CARDS)

    FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
    F.REDO.CARD.NUMBERS = ''
    CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

    Y.BIN.CTRL.ARR = ''

    Y.LINE1 = @(5,1)
    Y.LINE2 = @(7,1)

RETURN

DO.MIG:
    CRT @(-1):@(30):@(-132):"Migracion Numeros de TD":@(-128):
    Y.QTY.TOTAL = 0;
    GOSUB DO.SELECT
    LOOP

        REMOVE Y.RCN.ID FROM KEY.LIST SETTING TAG

    WHILE Y.RCN.ID:TAG

        GOSUB DO.PROCESS

    REPEAT

RETURN

DO.SELECT:
    SEL.CMD = 'SELECT ' : FN.REDO.CARD.NUMBERS
    CALL EB.READLIST(SEL.CMD,KEY.LIST,'',SELECTED,SYSTEM.RET.CODE)

RETURN

DO.PROCESS:
    CALL F.READ(FN.REDO.CARD.NUMBERS, Y.RCN.ID, R.CARDNUM, F.REDO.CARD.NUMBERS, CARDNUM.ERR)
    Y.CNOS = R.CARDNUM<REDO.CARD.NUM.CARD.NUMBER>
    Y.QTY = DCOUNT(Y.CNOS,@VM)
    DEBUG
    FOR A = 1 TO Y.QTY STEP 1
        Y.CURR.CARD = Y.CNOS<1,A>

        GOSUB DO.FORM.REC
        GOSUB DO.WRITE.REC
        Y.QTY.TOTAL += 1;
*CRT @(-1) : Y.LINE1 : "Processed: " : Y.QTY.TOTAL
        CRT @(-1): Y.LINE2 : 'Record: ': Y.CURR.CARD : ' wrote to CACHE, Processed = ' : Y.QTY.TOTAL : @(-5)
    NEXT A
*    CALL JOURNAL.UPDATE('');
EB.TransactionControl.JournalUpdate('');;* R22 UTILITY AUTO CONVERSION
*CRT 'JOURNAL UPDATE CALLED.'
    GOSUB DO.UPDATE.BIN.CTRL
RETURN

DO.FORM.REC:
    R.CARD<ST.LAP21.CARD.GEN.ID> = Y.CURR.CARD
    R.CARD<ST.LAP21.BIN> = Y.CURR.CARD[1,6]
    R.CARD<ST.LAP21.SEQ.NO> = Y.CURR.CARD[7,9]
    R.CARD<ST.LAP21.LOOPS.PERFORMED> = 0

RETURN

DO.WRITE.REC:
    Y.RECORD.ID = Y.CURR.CARD
    CALL F.WRITE(FN.GEN.CARDS, Y.RECORD.ID, R.CARD)
    GOSUB DO.MANAGE.CTRL
RETURN

DO.MANAGE.CTRL:
    Y.CURR.BIN = Y.CURR.CARD[1,6] : '00'
    LOCATE Y.CURR.BIN IN Y.BIN.CTRL.ARR SETTING Pos THEN
        Y.INCREMENT = Y.BIN.CTRL.ARR<Pos,2> + 1
        Y.BIN.CTRL.ARR<Pos,2> = Y.INCREMENT
    END ELSE
        Y.BIN.CTRL.ARR<-1> = Y.CURR.BIN : @VM : 1
    END
RETURN

DO.UPDATE.BIN.CTRL:
    Y.BIN.QTY = DCOUNT(Y.BIN.CTRL.ARR,@FM)
*CRT 'BIN..... INUSE.. AVL....'
    FOR B = 1 TO Y.BIN.QTY STEP 1
        Y.CURR.BIN = Y.BIN.CTRL.ARR<B,1>
*        CALL F.READ(FN.BIN.CTRL, Y.RCN.ID, R.BIN.CTRL, F.BIN.CTRL, BIN.CTRL.ERR)
        CALL F.READU(FN.BIN.CTRL, Y.RCN.ID, R.BIN.CTRL, F.BIN.CTRL, BIN.CTRL.ERR,'');* R22 UTILITY AUTO CONVERSION
        IF R.BIN.CTRL EQ '' THEN
            R.BIN.CTRL<ST.LAP73.CAP.NUMBER> = 9999999
        END

        Y.INUSE.COUNT = R.BIN.CTRL<ST.LAP73.INUSE.COUNT> + Y.BIN.CTRL.ARR<B,2>
        Y.AVL.VAL = 9999999 - Y.INUSE.COUNT
        R.BIN.CTRL<ST.LAP73.AVL.COUNT> = Y.AVL.VAL
        R.BIN.CTRL<ST.LAP73.INUSE.COUNT> = Y.INUSE.COUNT

        CALL F.WRITE(FN.BIN.CTRL, Y.CURR.BIN, R.BIN.CTRL)
*CRT Y.CURR.BIN : ' ' : 'Y.INUSE.COUNT' : ' ' : Y.AVL.VAL

    NEXT B
*    CALL JOURNAL.UPDATE('');
EB.TransactionControl.JournalUpdate('');;* R22 UTILITY AUTO CONVERSION
*CRT 'JOURNAL UPDATE CALLED.'
RETURN
END
