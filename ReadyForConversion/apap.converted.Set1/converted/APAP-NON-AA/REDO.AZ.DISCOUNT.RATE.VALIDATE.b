SUBROUTINE REDO.AZ.DISCOUNT.RATE.VALIDATE

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.AZ.DISCOUNT.RATE.VALIDATE
*--------------------------------------------------------------------------------
* Description: This is a validate routine for the application REDO.AZ.DISCOUNT.RATE
*
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 06-May-2011   H GANESH     PACS00032973  - N.18 INITIAL CREATION
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AZ.DISCOUNT.RATE


    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
* This part has validation for entering the days in param table

    Y.DATE.RANGE=R.NEW(REDO.DIS.RATE.DATE.RANGE)
    Y.PENAL.PERCENT=R.NEW(REDO.DIS.RATE.PENAL.PERCENT)

    Y.COUNT=DCOUNT(Y.DATE.RANGE,@VM)
    IF Y.COUNT EQ 1 THEN
        IF Y.DATE.RANGE<1,1>[1,1] NE '>' THEN
            AF=REDO.DIS.RATE.DATE.RANGE
            AV=1
            ETEXT='EB-REDO.DISCOUNT.RATE'
            CALL STORE.END.ERROR
        END
        Y.NUM=NUM(Y.DATE.RANGE<1,1>[2,10])
        IF Y.DATE.RANGE<1,1>[2,10] EQ '' OR NUM(Y.DATE.RANGE<1,1>[2,10]) EQ 0 THEN
            AF=REDO.DIS.RATE.DATE.RANGE
            AV=1
            ETEXT='EB-REDO.DAYS.ERROR'
            CALL STORE.END.ERROR
        END
    END
    Y.VAR=2
    LOOP
    WHILE Y.VAR LE Y.COUNT
        IF Y.VAR EQ Y.COUNT THEN
            Y.PREV.VAL=FIELD(Y.DATE.RANGE<1,Y.VAR-1>,'-',2)
            Y.NEXT.VAL=FIELD(Y.DATE.RANGE<1,Y.VAR>,'>',2)
            IF Y.DATE.RANGE<1,Y.VAR>[1,1] NE '>' THEN
                AF=REDO.DIS.RATE.DATE.RANGE
                AV=Y.VAR
                ETEXT='EB-REDO.DISCOUNT.RATE'
                CALL STORE.END.ERROR
            END
        END ELSE

            Y.PREV.VAL=FIELD(Y.DATE.RANGE<1,Y.VAR-1>,'-',2)
            Y.NEXT.VAL=FIELD(Y.DATE.RANGE<1,Y.VAR>,'-',1)
        END
        IF Y.PREV.VAL EQ '' OR Y.NEXT.VAL EQ '' OR NUM(Y.PREV.VAL) EQ 0 OR NUM(Y.NEXT.VAL) EQ 0 THEN
            AF=REDO.DIS.RATE.DATE.RANGE
            AV=1
            ETEXT='EB-REDO.DAYS.ERROR'
            CALL STORE.END.ERROR
        END
        IF Y.PREV.VAL+1 NE Y.NEXT.VAL THEN
            AF=REDO.DIS.RATE.DATE.RANGE
            AV=Y.VAR
            ETEXT='EB-REDO.DISCOUNT.NEXT':@FM:Y.PREV.VAL
            CALL STORE.END.ERROR
        END

        Y.VAR += 1
    REPEAT

RETURN
END
