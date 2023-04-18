$PACKAGE APAP.TAM
SUBROUTINE  REDO.LY.UPDATE.USE(CUSTOMER.ID,PROG,USE.ID,POINTS,PT.VALUE)
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to update the records in REDO.LY.POINTS when points are used
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.INPUT.USMOV
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*15.06.2012    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
*15.07.2014    RMONDRAGON         ODR-2011-06-0243     SECOND VERSION
** 13-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 13-04-2023 Skanda R22 Manual Conversion - No changes
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.LY.POINTS

    GOSUB INIT
    GOSUB GET.CUSTOMER.DET
    GOSUB CHECK.PT.RECORD

RETURN

*----
INIT:
*----

    FN.REDO.LY.POINTS = 'F.REDO.LY.POINTS'
    F.REDO.LY.POINTS = ''
    CALL OPF(FN.REDO.LY.POINTS,F.REDO.LY.POINTS)

    G.DATE = ''
    I.DATE = DATE()
    CALL DIETER.DATE(G.DATE,I.DATE,'')

RETURN

*----------------
GET.CUSTOMER.DET:
*----------------

    R.REDO.LY.POINTS = ''; PT.ERR = ''
    CALL F.READ(FN.REDO.LY.POINTS,CUSTOMER.ID,R.REDO.LY.POINTS,F.REDO.LY.POINTS,PT.ERR)
    IF R.REDO.LY.POINTS THEN
        Y.AVAIL.PROD = R.REDO.LY.POINTS<REDO.PT.PRODUCT>
        Y.AVAIL.PRGS = R.REDO.LY.POINTS<REDO.PT.PROGRAM>
        Y.AVAIL.TXN.IDS = R.REDO.LY.POINTS<REDO.PT.TXN.ID>
        Y.AVAIL.PTS = R.REDO.LY.POINTS<REDO.PT.QUANTITY>
        Y.AVAIL.VAL.PTS = R.REDO.LY.POINTS<REDO.PT.QTY.VALUE>
        Y.AVAIL.PTS.STATUS = R.REDO.LY.POINTS<REDO.PT.STATUS>
        Y.AVAIL.GEN.DATES = R.REDO.LY.POINTS<REDO.PT.GEN.DATE>
        Y.AVAIL.DATES = R.REDO.LY.POINTS<REDO.PT.AVAIL.DATE>
        Y.AVAIL.EXP.DATES = R.REDO.LY.POINTS<REDO.PT.EXP.DATE>
    END

RETURN

*---------------
CHECK.PT.RECORD:
*---------------

    Y.TOT.AVAIL.PROD = DCOUNT(Y.AVAIL.PROD,@VM)
    Y.CNT.AVAIL.PROD = 1
    LOOP
    WHILE Y.CNT.AVAIL.PROD LE Y.TOT.AVAIL.PROD
        Y.SET.AVAIL.PRGS = FIELD(Y.AVAIL.PRGS,@VM,Y.CNT.AVAIL.PROD)
        Y.SET.AVAIL.TXN.IDS = FIELD(Y.AVAIL.TXN.IDS,@VM,Y.CNT.AVAIL.PROD)
        Y.SET.AVAIL.PTS = FIELD(Y.AVAIL.PTS,@VM,Y.CNT.AVAIL.PROD)
        Y.SET.AVAIL.VAL.PTS = FIELD(Y.AVAIL.VAL.PTS,@VM,Y.CNT.AVAIL.PROD)
        Y.SET.AVAIL.PTS.STATUS = FIELD(Y.AVAIL.PTS.STATUS,@VM,Y.CNT.AVAIL.PROD)
        Y.SET.AVAIL.GEN.DATES = FIELD(Y.AVAIL.GEN.DATES,@VM,Y.CNT.AVAIL.PROD)
        Y.SET.AVAIL.DATES = FIELD(Y.AVAIL.DATES,@VM,Y.CNT.AVAIL.PROD)
        Y.SET.AVAIL.EXP.DATES =FIELD(Y.AVAIL.EXP.DATES,@VM,Y.CNT.AVAIL.PROD)

        Y.TOT.SET.AVAIL.PRGS = DCOUNT(Y.SET.AVAIL.PRGS,@SM)
        Y.CNT.SET.AVAIL.PRGS = 1
        LOOP
        WHILE Y.CNT.SET.AVAIL.PRGS LE Y.TOT.SET.AVAIL.PRGS
            Y.AVAIL.PRG = FIELD(Y.SET.AVAIL.PRGS,@SM,Y.CNT.SET.AVAIL.PRGS)
            Y.AVAIL.TXN.ID = FIELD(Y.SET.AVAIL.TXN.IDS,@SM,Y.CNT.SET.AVAIL.PRGS)
            Y.AVAIL.PT = FIELD(Y.SET.AVAIL.PTS,@SM,Y.CNT.SET.AVAIL.PRGS)
            Y.AVAIL.VAL.PT = FIELD(Y.SET.AVAIL.VAL.PTS,@SM,Y.CNT.SET.AVAIL.PRGS)
            Y.AVAIL.PT.STATUS = FIELD(Y.SET.AVAIL.PTS.STATUS,@SM,Y.CNT.SET.AVAIL.PRGS)
            Y.AVAIL.GEN.DATE = FIELD(Y.SET.AVAIL.GEN.DATES,@SM,Y.CNT.SET.AVAIL.PRGS)
            Y.AVAIL.DATE = FIELD(Y.SET.AVAIL.DATES,@SM,Y.CNT.SET.AVAIL.PRGS)
            Y.AVAIL.EXP.DATE = FIELD(Y.SET.AVAIL.EXP.DATES,@SM,Y.CNT.SET.AVAIL.PRGS)

            IF Y.AVAIL.PRG EQ PROG THEN
                IF Y.AVAIL.DATE LE TODAY AND Y.AVAIL.PT.STATUS EQ 'Liberada' THEN

                    GOSUB CHECK.PT.RECORD.2

                END
            END
            Y.CNT.SET.AVAIL.PRGS += 1 ;* R22 Auto conversion
        REPEAT
        Y.CNT.AVAIL.PROD += 1 ;* R22 Auto conversion
    REPEAT

RETURN

*-----------------
CHECK.PT.RECORD.2:
*-----------------

    IF POINTS EQ Y.AVAIL.PT THEN
        GOSUB UPDATE.NEW.REC
        Y.CNT.AVAIL.PROD = Y.TOT.AVAIL.PROD
        Y.CNT.SET.AVAIL.PRGS = Y.TOT.SET.AVAIL.PRGS
        RETURN
    END

    IF POINTS LT Y.AVAIL.PT THEN
        Y.NEW.PTS = Y.AVAIL.PT - POINTS
        Y.NEW.PTS.VAL = Y.AVAIL.VAL.PT - PT.VALUE
        GOSUB UPDATE.NEW.REC2
        Y.CNT.AVAIL.PROD = Y.TOT.AVAIL.PROD
        Y.CNT.SET.AVAIL.PRGS = Y.TOT.SET.AVAIL.PRGS
        RETURN
    END

    IF POINTS GT Y.AVAIL.PT THEN
        GOSUB UPDATE.NEW.REC
        POINTS -= Y.AVAIL.PT ;* R22 Auto conversion
        PT.VALUE -= Y.AVAIL.VAL.PT ;* R22 Auto conversion
    END

RETURN

*--------------
UPDATE.NEW.REC:
*--------------

    R.REDO.LY.POINTS<REDO.PT.STATUS,Y.CNT.AVAIL.PROD,Y.CNT.SET.AVAIL.PRGS> = 'Utilizada.':TODAY
    R.REDO.LY.POINTS<REDO.PT.MAN.DESC,Y.CNT.AVAIL.PROD,Y.CNT.SET.AVAIL.PRGS> := ' / Uso:':USE.ID
    GOSUB ASSIGN.AUDIT
    CALL F.WRITE(FN.REDO.LY.POINTS,CUSTOMER.ID,R.REDO.LY.POINTS)

RETURN

*---------------
UPDATE.NEW.REC2:
*---------------

    R.REDO.LY.POINTS<REDO.PT.QUANTITY,Y.CNT.AVAIL.PROD,Y.CNT.SET.AVAIL.PRGS> = POINTS
    R.REDO.LY.POINTS<REDO.PT.QTY.VALUE,Y.CNT.AVAIL.PROD,Y.CNT.SET.AVAIL.PRGS> = PT.VALUE
    R.REDO.LY.POINTS<REDO.PT.STATUS,Y.CNT.AVAIL.PROD,Y.CNT.SET.AVAIL.PRGS> = 'Utilizada.':TODAY
    R.REDO.LY.POINTS<REDO.PT.MAN.DESC,Y.CNT.AVAIL.PROD,Y.CNT.SET.AVAIL.PRGS> := ' / Uso:':USE.ID

    Y.INDEX1 = Y.CNT.AVAIL.PROD
    Y.INDEX2 = Y.TOT.SET.AVAIL.PRGS + 1

    R.REDO.LY.POINTS<REDO.PT.PROGRAM,Y.INDEX1,Y.INDEX2> = PROG
    R.REDO.LY.POINTS<REDO.PT.TXN.ID,Y.INDEX1,Y.INDEX2> = Y.AVAIL.TXN.ID
    R.REDO.LY.POINTS<REDO.PT.QUANTITY,Y.INDEX1,Y.INDEX2> = Y.NEW.PTS
    R.REDO.LY.POINTS<REDO.PT.QTY.VALUE,Y.INDEX1,Y.INDEX2> = Y.NEW.PTS.VAL
    R.REDO.LY.POINTS<REDO.PT.STATUS,Y.INDEX1,Y.INDEX2> = 'Liberada'
    R.REDO.LY.POINTS<REDO.PT.GEN.DATE,Y.INDEX1,Y.INDEX2> = Y.AVAIL.GEN.DATE
    R.REDO.LY.POINTS<REDO.PT.AVAIL.DATE,Y.INDEX1,Y.INDEX2> = Y.AVAIL.DATE
    R.REDO.LY.POINTS<REDO.PT.EXP.DATE,Y.INDEX1,Y.INDEX2> = Y.AVAIL.EXP.DATE
    R.REDO.LY.POINTS<REDO.PT.MAN.DESC,Y.INDEX1,Y.INDEX2> = 'Ajuste Uso Puntos ':USE.ID
    GOSUB ASSIGN.AUDIT
    CALL F.WRITE(FN.REDO.LY.POINTS,CUSTOMER.ID,R.REDO.LY.POINTS)

RETURN

*------------
ASSIGN.AUDIT:
*------------

    CURR.NO = ''
    CUR.TIME = OCONV(TIME(), "MT")

    CHANGE ':' TO '' IN CUR.TIME
    CURR.NO = R.REDO.LY.POINTS<REDO.PT.CURR.NO>
    IF CURR.NO EQ '' THEN
        CURR.NO = 1
    END ELSE
        CURR.NO += 1 ;* R22 Auto conversion
    END
    R.REDO.LY.POINTS<REDO.PT.RECORD.STATUS> = ''
    R.REDO.LY.POINTS<REDO.PT.CURR.NO> = CURR.NO
    R.REDO.LY.POINTS<REDO.PT.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR ;* R22 Auto conversion
    R.REDO.LY.POINTS<REDO.PT.DATE.TIME> = G.DATE[3,6]:CUR.TIME
    R.REDO.LY.POINTS<REDO.PT.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR ;* R22 Auto conversion
    R.REDO.LY.POINTS<REDO.PT.CO.CODE> = ID.COMPANY
    R.REDO.LY.POINTS<REDO.PT.DEPT.CODE> = 1

RETURN

END
