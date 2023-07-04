$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ANUAL.AVG.RT(Y.ACCOUNT,Y.YEAR,Y.START.BAL,Y.OUT.ARR,Y.DAY.MENOR.100)
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND FM TO @FM AND VM TO @VM AND SM TO @SM AND B TO B.VAR AND = TO EQ AND D TO D.VAR
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCT.ACTIVITY

*Y.ACCOUNT
*Y.YEAR
*Y.START.BAL
    GOSUB OPEN.FILES
    GOSUB INITIALIZE
    GOSUB PROCESS.1
    Y.OUT.ARR = Y.SUMATORIA.ACTUAL/Y.LEAP.YEAR.C
RETURN
OPEN.FILES:
    FN.ACCT.AC = 'FBNK.ACCT.ACTIVITY'
    FV.ACCT.AC = ''
    CALL OPF(FN.ACCT.AC,FV.ACCT.AC)
RETURN

INITIALIZE:
    Y.SOYB = Y.START.BAL      ;*START OF YEAR BALANCE.
    Y.NORMAL.YEAR.DAY = 31 : @FM : 28 : @FM : 31 : @FM : 30 : @FM : 31 : @FM : 30 : @FM : 31 : @FM : 31 : @FM : 30 : @FM : 31 : @FM : 30 : @FM : 31
    Y.LEAP.YEAR.DAY = 31 : @FM : 29 : @FM : 31 : @FM : 30 : @FM : 31 : @FM : 30 : @FM : 31 : @FM : 31 : @FM : 30 : @FM : 31 : @FM : 30 : @FM : 31
    Y.LEAP.YEARS = 2020 :@FM: 2024 :@FM: 2028 :@FM: 2032 :@FM: 2036 :@FM: 2040 :@FM: 2044 :@FM: 2048 :@FM: 2052
    Y.MONTHLY.DAYS = ''
    Y.SUMATORIA.ACTUAL = 0
    Y.LEAP.YEAR.C = 0
    FIND Y.YEAR IN Y.LEAP.YEARS SETTING V.FLD THEN
        Y.MONTHLY.DAYS = Y.LEAP.YEAR.DAY
        Y.LEAP.YEAR.C = 366
    END ELSE
        Y.MONTHLY.DAYS = Y.NORMAL.YEAR.DAY
        Y.LEAP.YEAR.C = 365
    END
RETURN

PROCESS.1:
    Y.LAST.BALANCE = Y.START.BAL
    GOSUB COUNT.BALANCE.INTERES.MES
    FOR Z = 1 TO 12 STEP 1
        Y.MONTH.NO = ''

        IF Z LT 10 THEN
            Y.MONTH.NO = '0' : Z
        END ELSE
            Y.MONTH.NO = Z
        END
        ACTIVITY.ID = Y.ACCOUNT : '-' : Y.YEAR : Y.MONTH.NO
        IF Y.ARRAY.DAY EQ 12 THEN
            GOSUB READ.CURR.ACTIVITY.SOLO.INTERES
        END ELSE
            GOSUB READ.CURR.ACTIVITY
        END

    NEXT Z

RETURN


COUNT.BALANCE.INTERES.MES:
    Y.ARRAY.DAY = ''; K.VAR = ''; R.ACCT.AC1 = ''; ACCT.AC.ERR1 = '';
    Y.DAY.NO1 = ''; Y.CNT1 ='';
    FOR K.VAR = 1 TO 12 STEP 1
        Y.MONTH.NO = ''

        IF K.VAR LT 10 THEN
            Y.MONTH.NO = '0' : K.VAR
        END ELSE
            Y.MONTH.NO = K.VAR
        END
        ACTIVITY.ID = Y.ACCOUNT : '-' : Y.YEAR : Y.MONTH.NO
        CALL F.READ(FN.ACCT.AC,ACTIVITY.ID,R.ACCT.AC1, FV.ACCT.AC, ACCT.AC.ERR1)
        Y.DAY.NO1 = R.ACCT.AC1<IC.ACT.DAY.NO>
        Y.DAY.NO1 = CHANGE(Y.DAY.NO1,@SM,@FM)
        Y.DAY.NO1 = CHANGE(Y.DAY.NO1,@VM,@FM)
        Y.CNT1 = DCOUNT(Y.DAY.NO1,@FM)
        Y.ARRAY.DAY += Y.CNT1

    NEXT K.VAR

RETURN

READ.CURR.ACTIVITY:
    Y.DAILY.BAL.ARR = ''
    CALL F.READ(FN.ACCT.AC,ACTIVITY.ID,R.ACCT.AC, FV.ACCT.AC, ACCT.AC.ERR)
    Y.CANT.DIAS = Y.MONTHLY.DAYS<Z>

    IF NOT(R.ACCT.AC) THEN
        FOR A = 1 TO Y.CANT.DIAS STEP 1
            Y.DAILY.BAL.ARR<-1> = Y.LAST.BALANCE
        NEXT A
    END ELSE
        Y.DAY.NO = R.ACCT.AC<IC.ACT.DAY.NO>
        Y.BALANCE = R.ACCT.AC<IC.ACT.BALANCE>
        Y.QNT.DAYS = DCOUNT(Y.DAY.NO,@VM)
        IF Y.QNT.DAYS EQ 0 THEN
            FOR A = 1 TO Y.CANT.DIAS STEP 1
                Y.DAILY.BAL.ARR<-1> = Y.LAST.BALANCE
            NEXT A
        END
        FOR A = 1 TO Y.QNT.DAYS STEP 1

            IF Y.DAY.NO<1,A> NE '01' THEN


                IF A EQ 1 THEN

                    FOR B.VAR = 1 TO (Y.DAY.NO<1,A> - 1) STEP 1
                        Y.DAILY.BAL.ARR<-1> = Y.LAST.BALANCE
                    NEXT B.VAR

                END

                Y.BALANCE.ACTUAL = Y.BALANCE<1,A>
                Y.NEXT.DAY = Y.DAY.NO<1,A+1>

                IF Y.NEXT.DAY EQ '' THEN
                    Y.NEXT.DAY = Y.CANT.DIAS + 1
                END
                Y.DIFERENCIA.ACTUAL.SIGUIENTE = ABS(Y.NEXT.DAY - Y.DAY.NO<1,A>)
                FOR C = 1 TO Y.DIFERENCIA.ACTUAL.SIGUIENTE STEP 1
                    Y.DAILY.BAL.ARR<-1> = Y.BALANCE.ACTUAL
                NEXT C

            END ELSE

                Y.BALANCE.ACTUAL = Y.BALANCE<1,A>
                Y.NEXT.DAY = Y.DAY.NO<1,A+1>
                IF Y.NEXT.DAY EQ '' THEN
                    Y.NEXT.DAY = Y.CANT.DIAS
                END

                Y.DIFERENCIA.ACTUAL.SIGUIENTE = ABS(Y.NEXT.DAY - Y.DAY.NO<1,A>)
                FOR C = 1 TO Y.DIFERENCIA.ACTUAL.SIGUIENTE STEP 1
                    Y.DAILY.BAL.ARR<-1> = Y.BALANCE.ACTUAL
                NEXT C
            END

            IF Y.BALANCE.ACTUAL NE '' THEN
                Y.LAST.BALANCE = Y.BALANCE.ACTUAL
            END

        NEXT A
    END
*Y.SUMATORIA.ACTUAL = 0
    Y.CANTIDAD.ELEMENTOS.1 = DCOUNT(Y.DAILY.BAL.ARR,@FM)

    FOR D.VAR = 1 TO Y.CANTIDAD.ELEMENTOS.1 STEP 1
        Y.SUMATORIA.ACTUAL += Y.DAILY.BAL.ARR<D.VAR>
    NEXT D.VAR

RETURN

READ.CURR.ACTIVITY.SOLO.INTERES:
    Y.DAILY.BAL.ARR = ''
    CALL F.READ(FN.ACCT.AC,ACTIVITY.ID,R.ACCT.AC, FV.ACCT.AC, ACCT.AC.ERR)
    Y.CANT.DIAS = Y.MONTHLY.DAYS<Z>

    IF NOT(R.ACCT.AC) THEN
        FOR A = 1 TO Y.CANT.DIAS STEP 1
            Y.DAILY.BAL.ARR<-1> = Y.LAST.BALANCE
        NEXT A
    END ELSE
        Y.DAY.NO = R.ACCT.AC<IC.ACT.DAY.NO>
        Y.BALANCE = R.ACCT.AC<IC.ACT.BALANCE>
        Y.QNT.DAYS = DCOUNT(Y.DAY.NO,@VM)
        IF Y.QNT.DAYS EQ 0 THEN
            FOR A = 1 TO Y.CANT.DIAS STEP 1
                Y.DAILY.BAL.ARR<-1> = Y.LAST.BALANCE
            NEXT A
        END
        FOR A = 1 TO Y.QNT.DAYS STEP 1

            IF Y.DAY.NO<1,A> NE '01' THEN


                IF A EQ 1 THEN

                    FOR B.VAR = 1 TO (Y.DAY.NO<1,A> - 1) STEP 1
                        Y.DAILY.BAL.ARR<-1> = Y.LAST.BALANCE
                    NEXT B.VAR

                END

                Y.BALANCE.ACTUAL = Y.BALANCE<1,A>
                Y.NEXT.DAY = Y.DAY.NO<1,A+1>

                IF Y.NEXT.DAY EQ '' THEN
                    Y.NEXT.DAY = Y.CANT.DIAS + 1
                END

                Y.DIFERENCIA.ACTUAL.SIGUIENTE = Y.NEXT.DAY

                FOR C = 1 TO Y.DIFERENCIA.ACTUAL.SIGUIENTE STEP 1
                    Y.DAILY.BAL.ARR<-1> = Y.BALANCE.ACTUAL
                NEXT C

            END ELSE

                Y.BALANCE.ACTUAL = Y.BALANCE<1,A>
                Y.NEXT.DAY = Y.DAY.NO<1,A+1>
                IF Y.NEXT.DAY EQ '' THEN
                    Y.NEXT.DAY = Y.CANT.DIAS
                END

                Y.DIFERENCIA.ACTUAL.SIGUIENTE = Y.NEXT.DAY

                FOR C = 1 TO Y.DIFERENCIA.ACTUAL.SIGUIENTE STEP 1
                    Y.DAILY.BAL.ARR<-1> = Y.BALANCE.ACTUAL
                NEXT C
            END

            IF Y.BALANCE.ACTUAL NE '' THEN
                Y.LAST.BALANCE = Y.BALANCE.ACTUAL
            END

        NEXT A
    END
*Y.SUMATORIA.ACTUAL = 0
    Y.CANTIDAD.ELEMENTOS.1 = DCOUNT(Y.DAILY.BAL.ARR,@FM)

    FOR D.VAR = 1 TO Y.CANTIDAD.ELEMENTOS.1 STEP 1
        Y.SUMATORIA.ACTUAL += Y.DAILY.BAL.ARR<D.VAR>
    NEXT D.VAR

RETURN



END
