SUBROUTINE  REDO.LY.V.TXNTOSAVC
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the type of accountabilty movement based on the value of
*              type of use.
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.V.TXNTOSAVC
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*16.06.2012    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
*10.07.2012    RMONDRAGON         ODR-2011-06-0243     SECOND VERSION
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.ACCOUNT

    $INSERT I_F.REDO.LY.POINTS.US
    $INSERT I_F.REDO.LY.PROGRAM

    IF VAL.TEXT THEN
        Y.US.MOV = R.NEW(REDO.PT.US.MOV.US)
    END ELSE
        Y.US.MOV = COMI
    END

    GOSUB OPENFILE
    GOSUB PROCESS

RETURN

*--------
OPENFILE:
*--------

    FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM = ''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN

*-------
PROCESS:
*-------

    IF Y.US.MOV EQ '' THEN
        RETURN
    END

    IF Y.US.MOV EQ 'Interno' THEN
        R.NEW(REDO.PT.US.CUS.ACCT.MOV.US) = ''
        T(REDO.PT.US.CUS.ACCT.MOV.US)<3> = 'NOINPUT'
        IF R.NEW(REDO.PT.US.INT.ACCT.MOV.US) EQ '' THEN
            GOSUB GET.INT.ACCT
            R.NEW(REDO.PT.US.INT.ACCT.MOV.US) = Y.CR.ACCT
        END ELSE
            GOSUB VAL.ACCT
        END
        RETURN
    END ELSE
        R.NEW(REDO.PT.US.INT.ACCT.MOV.US) = ''
        T(REDO.PT.US.INT.ACCT.MOV.US)<3> = 'NOINPUT'
    END

    Y.US.TYPE = R.NEW(REDO.PT.US.TYPE.US)

    IF Y.US.TYPE EQ 'Por.TDebito' AND Y.US.MOV EQ 'Cuenta.Ahorro.Cliente' THEN
        AF = REDO.PT.US.MOV.US
        ETEXT = 'EB-REDO.LY.V.TXNTOSAVC'
        CALL STORE.END.ERROR
        RETURN
    END

RETURN

*------------
GET.INT.ACCT:
*------------

    ID.PROG = R.NEW(REDO.PT.US.PROGRAM)
    PROG.ERR = ''
    CALL F.READ(FN.REDO.LY.PROGRAM,ID.PROG,R.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM,PROG.ERR)
    IF R.REDO.LY.PROGRAM THEN
        Y.CR.ACCT.SET = R.REDO.LY.PROGRAM<REDO.PROG.CR.ACCT.US>

        Y.TOT.CR.ACCT.SET = DCOUNT(Y.CR.ACCT.SET,@VM)
        Y.CR.ACCT.CNT = 1
        LOOP
        WHILE Y.CR.ACCT.CNT LE Y.TOT.CR.ACCT.SET
            Y.CR.ACCT = FIELD(Y.CR.ACCT.SET,@VM,Y.CR.ACCT.CNT)
            IF Y.CR.ACCT NE 'CUST.ACCT' THEN
                Y.CR.ACCT.CNT = Y.TOT.CR.ACCT.SET
            END
            Y.CR.ACCT.CNT += 1
        REPEAT
    END

RETURN

*--------
VAL.ACCT:
*--------

    ID.ACCT = R.NEW(REDO.PT.US.INT.ACCT.MOV.US)
    ACCT.ERR = ''
    CALL F.READ(FN.ACCOUNT,ID.ACCT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    IF R.ACCOUNT THEN
        Y.CATEG = R.ACCOUNT<AC.CATEGORY>
        IF Y.CATEG LT 10000 OR Y.CATEG GT 69999 THEN
            AF = REDO.PT.US.INT.ACCT.MOV.US
            ETEXT = 'EB-REDO.LY.V.TXNTOSAVC'
            CALL STORE.END.ERROR
        END
    END

RETURN

*----------------------------------------------------------------------------------
END
