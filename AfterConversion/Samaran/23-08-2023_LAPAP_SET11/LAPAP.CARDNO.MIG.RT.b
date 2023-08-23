$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-54</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.CARDNO.MIG.RT(Y.KEY.ID)
*----------------------------------------------------------------------------------------------------
*MODIFICATION HISTORY
* Date                  Who                    Reference                        Description
* ----                  ----                     ----                              ----
* 09-08-2023           Samaran T         R22 Manual Code Conversion     BP is removed from insert file
*-------------------------------------------------------------------------------------------------------------
    $INSERT  I_EQUATE  ;*R22 MANUAL CODE CONVERSION.START
    $INSERT  I_F.COMPANY
    $INSERT  I_F.LAPAP.BIN.SEQ.CTRL
    $INSERT  I_F.LAPAP.CARD.GEN.CARDS
    $INSERT  I_F.REDO.CARD.NUMBERS
    $INSERT  I_LAPAP.CARDNO.MIG.COMMON
    $INSERT  I_F.LAPAP.BIN.CTRL.TEMP ;*R22 MANUAL CODE CONVERSION.END

    GOSUB DO.PROCESS
    GOSUB DO.WRITE.BIN.CTRL
RETURN

DO.PROCESS:
    CALL OCOMO('Processing ': Y.KEY.ID)
    Y.BIN.CTRL.ARR.INT = ''
    CALL F.READ(FN.REDO.CARD.NUMBERS, Y.KEY.ID, R.CARDNUM, F.REDO.CARD.NUMBERS, CARDNUM.ERR)
    Y.CNOS = R.CARDNUM<REDO.CARD.NUM.CARD.NUMBER>
    Y.QTY = DCOUNT(Y.CNOS,@VM)
    FOR A = 1 TO Y.QTY STEP 1
        Y.CURR.CARD = Y.CNOS<1,A>

        GOSUB DO.FORM.REC
        GOSUB DO.WRITE.REC
        Y.QTY.TOTAL += 1;

    NEXT A

*GOSUB DO.WRITE.BIN.CTRL

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
    IF Y.CURR.CARD[1,6] NE '' THEN
        Y.CURR.BIN = Y.CURR.CARD[1,6] : '00'
        LOCATE Y.CURR.BIN IN Y.BIN.CTRL.ARR SETTING Pos THEN
            Y.INCREMENT = Y.BIN.CTRL.ARR<Pos,2> + 1
            Y.BIN.CTRL.ARR<Pos,2> = Y.INCREMENT
        END ELSE
            Y.BIN.CTRL.ARR<-1> = Y.CURR.BIN : @VM : 1
        END

        LOCATE Y.CURR.BIN IN Y.BIN.CTRL.ARR.INT SETTING Pos THEN
            Y.INCREMENT = Y.BIN.CTRL.ARR.INT<Pos,2> + 1
            Y.BIN.CTRL.ARR.INT<Pos,2> = Y.INCREMENT
        END ELSE
            Y.BIN.CTRL.ARR.INT<-1> = Y.CURR.BIN : @VM : 1
        END
    END

RETURN

DO.WRITE.BIN.CTRL:
    Y.B.CTRL.QTY = DCOUNT(Y.BIN.CTRL.ARR.INT,@FM)
*CALL OCOMO('Calling DO.WRITE.BIN.CTRL')
*CALL OCOMO('@FM QTY = ' : Y.B.CTRL.QTY)
*CALL OCOMO('VM QTY=': DCOUNT(Y.BIN.CTRL.ARR.INT,@VM))
    FOR B = 1 TO Y.B.CTRL.QTY STEP 1
        Y.CURRENT.BIN = Y.BIN.CTRL.ARR.INT<B,1>
        Y.CURRENT.QTY = Y.BIN.CTRL.ARR.INT<B,2>
        Y.UNIQUE.KEY = ''     ;*UNIQUEKEY()
        FOR I=1 TO 4
            Y.UNIQUE.KEY := RND(100)
        NEXT I

        R.CONTROL<ST.LAP95.BIN.NUMBER> = Y.CURRENT.BIN
        R.CONTROL<ST.LAP95.INUSE.COUNT> = Y.CURRENT.QTY
*CALL F.WRITE(FN.ST.LAPAP.BIN.CTRL.TEMP, Y.UNIQUE.KEY , R.CONTROL)
*CALL OCOMO('Using BIN =': Y.CURRENT.BIN : ', Cards wrote =' :Y.CURRENT.QTY)
    NEXT B


RETURN

END
