* @ValidationCode : MjotNDU0OTE2NDM3OkNwMTI1MjoxNjgyMDcwMzM1NDI3OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:15:35
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
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.TWELVE.AVG.RT(Y.ACCOUNT,Y.YEAR,Y.START.BAL,Y.OUT.ARR)
*--------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          = TO EQ , B TO B.VAR, D TO D.VAR
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.ACCT.ACTIVITY

    GOSUB OPEN.FILES
    GOSUB INITIALIZE
    GOSUB PROCESS.1
    Y.OUT.ARR = Y.MONTHLY.BAL.ARR
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
    FIND Y.YEAR IN Y.LEAP.YEARS SETTING V.FLD THEN
        Y.MONTHLY.DAYS = Y.LEAP.YEAR.DAY
    END ELSE
        Y.MONTHLY.DAYS = Y.NORMAL.YEAR.DAY
    END
RETURN

PROCESS.1:
    Y.LAST.BALANCE = Y.START.BAL
    FOR Z = 1 TO 12 STEP 1
        Y.MONTH.NO = ''

        IF Z LT 10 THEN
            Y.MONTH.NO = '0' : Z
        END ELSE
            Y.MONTH.NO = Z
        END

        ACTIVITY.ID = Y.ACCOUNT : '-' : Y.YEAR : Y.MONTH.NO
        GOSUB READ.CURR.ACTIVITY

*        IF Z = '8' THEN

*            PRINT @(17,14) : Y.DAILY.BAL.ARR

*        END

    NEXT Z
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


                IF A EQ 1 THEN   ;*R22 AUTO CODE CONVERSION

                    FOR B.VAR = 1 TO (Y.DAY.NO<1,A> - 1) STEP 1
                        Y.DAILY.BAL.ARR<-1> = Y.LAST.BALANCE
                    NEXT B.VAR

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

    FOR D.VAR = 1 TO Y.CANTIDAD.ELEMENTOS.1 STEP 1
        Y.SUMATORIA.ACTUAL += Y.DAILY.BAL.ARR<D.VAR>
    NEXT D.VAR
    Y.MONTHLY.BAL.ARR<-1> = Y.SUMATORIA.ACTUAL / Y.CANTIDAD.ELEMENTOS.1

RETURN


END
