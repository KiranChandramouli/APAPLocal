*-----------------------------------------------------------------------------
* <Rating>246</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.ACCT.AVG.AMT.RT(ACCOUNT.ID,YEAR.NO,MONTH.NO,OUT.AVG)
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.COMPANY
    $INSERT T24.BP I_F.ACCT.ACTIVITY
    $INSERT T24.BP I_F.ACCOUNT

    GOSUB OPEN.FILES
    GOSUB DO.INITIALIZE
    GOSUB GET.INITIAL.AMT
    GOSUB PROCESS.1

    RETURN

OPEN.FILES:
    FN.ACCT.AC = 'FBNK.ACCT.ACTIVITY'
    FV.ACCT.AC = ''
    CALL OPF(FN.ACCT.AC,FV.ACCT.AC)

    FN.AC = "FBNK.ACCOUNT"
    FV.AC = ""
    CALL OPF(FN.AC,FV.AC)

    RETURN

DO.INITIALIZE:
    Y.YEAR = YEAR.NO

    Y.NORMAL.YEAR.DAY = 31 : @FM : 28 : @FM : 31 : @FM : 30 : @FM : 31 : @FM : 30 : @FM : 31 : @FM : 31 : @FM : 30 : @FM : 31 : @FM : 30 : @FM : 31
    Y.LEAP.YEAR.DAY = 31 : @FM : 29 : @FM : 31 : @FM : 30 : @FM : 31 : @FM : 30 : @FM : 31 : @FM : 31 : @FM : 30 : @FM : 31 : @FM : 30 : @FM : 31
    Y.LEAP.YEARS = 2020 :@FM: 2024 :@FM: 2028 :@FM: 2032 :@FM: 2036 :@FM: 2040 :@FM: 2044 :@FM: 2048 :@FM: 2052
    Y.MONTHLY.DAYS = ''
    FIND Y.YEAR IN Y.LEAP.YEARS SETTING V.FLD THEN
        Y.MONTHLY.DAYS = Y.LEAP.YEAR.DAY
    END ELSE
        Y.MONTHLY.DAYS = Y.NORMAL.YEAR.DAY
    END
    RETURN

GET.INITIAL.AMT:
    ACCT.ID = ACCOUNT.ID
    MONTH.NO.LEAD = MONTH.NO
    IF MONTH.NO LT 10 THEN
        MONTH.NO.LEAD = '0' : MONTH.NO
    END
    P.DATE = YEAR.NO : MONTH.NO.LEAD : '01'
    DB.MVM=""
    OPEN.BAL=""
    R.ACCT=""
    ACCT.BAL=""
    CR.MVT=""
    CALL EB.GET.ACCT.BALANCE(ACCT.ID,R.ACCT,'BOOKING',P.DATE,'',ACCT.BAL,CR.MVM,DB.MVM,ERR.MSG)
    I.BALANCE = TRIM(ACCT.BAL)

    RETURN

READ.CURR.ACTIVITY:
    Y.DAILY.BAL.ARR = ''

    CALL F.READ(FN.ACCT.AC,Y.ACTIVITY.ID,R.ACCT.AC, FV.ACCT.AC, ACCT.AC.ERR)
    Y.MONTH.NO.NUM = MONTH.NO
    Y.CANT.DIAS = Y.MONTHLY.DAYS<Y.MONTH.NO.NUM>

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


                IF A = 1 THEN

                    FOR B = 1 TO (Y.DAY.NO<1,A> - 1) STEP 1
                        Y.DAILY.BAL.ARR<-1> = Y.LAST.BALANCE
                    NEXT B

                END

                Y.BALANCE.ACTUAL = Y.BALANCE<1,A>
                Y.NEXT.DAY = Y.DAY.NO<1,A+1>

                IF Y.NEXT.DAY EQ '' THEN
                    Y.NEXT.DAY = Y.CANT.DIAS + 1
                END

* Y.DAILY.BAL.ARR<-1> = Y.BALANCE.ACTUAL      ;*-->Necesario para agregar el dia inicio diferencial.
* Y.DIFERENCIA.ACTUAL.SIGUIENTE = ABS(Y.CANT.DIAS - Y.DAY.NO<1,A>)

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
*Y.DIFERENCIA.ACTUAL.SIGUIENTE = ABS(Y.CANT.DIAS - Y.DAY.NO<1,A>)

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
    Y.SUMATORIA.ACTUAL = 0
    Y.CANTIDAD.ELEMENTOS.1 = DCOUNT(Y.DAILY.BAL.ARR,@FM)

    FOR D = 1 TO Y.CANTIDAD.ELEMENTOS.1 STEP 1
        Y.SUMATORIA.ACTUAL += Y.DAILY.BAL.ARR<D>
    NEXT D
    Y.MONTHLY.BAL.ARR<-1> = Y.SUMATORIA.ACTUAL / Y.CANTIDAD.ELEMENTOS.1

    OUT.AVG = Y.MONTHLY.BAL.ARR<1>
    RETURN

PROCESS.1:
    Y.LAST.BALANCE = I.BALANCE
    Y.ACTIVITY.ID = ACCT.ID : '-' : Y.YEAR : MONTH.NO.LEAD
    GOSUB READ.CURR.ACTIVITY
    RETURN

END
