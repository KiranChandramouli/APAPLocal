$PACKAGE APAP.TAM
SUBROUTINE REDO.LY.DIS.FIELDS.P3
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RMONDRAGON
* PROGRAM NAME: REDO.LY.DIS.FIELDS.P
* ODR NO      : ODR-2011-06-0243
*----------------------------------------------------------------------
*DESCRIPTION: This subroutine is performed in REDO.LY.MODALITY,EDIT version
* The functionality is to disable some fields according with the modality
* type to apply for point generation

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:  REDO.LY.MODALITY
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*02.06.2014 RMONDRAGON    ODR-2011-06-0243  INITIAL CREATION
** 12-04-2023 R22 Auto Conversion no changes
** 12-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM

    GOSUB OPEN.FILES
    GOSUB READ.PRG
    GOSUB PROCESS1
    GOSUB PROCESS2
    GOSUB PROCESS3

RETURN

*----------
OPEN.FILES:
*----------

    FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM = ''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

    FN.REDO.LY.PROGRAMNAU = 'F.REDO.LY.PROGRAM$NAU'
    F.REDO.LY.PROGRAMNAU = ''
    CALL OPF(FN.REDO.LY.PROGRAMNAU,F.REDO.LY.PROGRAMNAU)

RETURN

*--------
READ.PRG:
*--------

    R.PROGRAM = ''; PRG.ERR = ''
    CALL F.READ(FN.REDO.LY.PROGRAM,COMI,R.PROGRAM,F.REDO.LY.PROGRAM,PRG.ERR)
    IF R.PROGRAM THEN
        GOSUB READ.FIELDS
        RETURN
    END

    CALL F.READ(FN.REDO.LY.PROGRAMNAU,COMI,R.PROGRAM,F.REDO.LY.PROGRAMNAU,PRG.ERR)
    IF R.PROGRAM THEN
        GOSUB READ.FIELDS
    END

RETURN

*-----------
READ.FIELDS:
*-----------

    Y.MODALITY = R.PROGRAM<REDO.PROG.MODALITY>
    Y.AIRL.PROG = R.PROGRAM<REDO.PROG.AIRL.PROG>
    Y.START.DATE = R.PROGRAM<REDO.PROG.START.DATE>
    Y.END.DATE = R.PROGRAM<REDO.PROG.END.DATE>
    Y.STATUS = R.PROGRAM<REDO.PROG.STATUS>
    Y.NEG.POINT.SHIP = R.PROGRAM<REDO.PROG.NEG.POINT.SHIP>
    Y.AVAILABILITY = R.PROGRAM<REDO.PROG.AVAILABILITY>
    Y.AVAIL.DATE = R.PROGRAM<REDO.PROG.AVAIL.DATE>
    Y.POINT.VALUE = R.PROGRAM<REDO.PROG.POINT.VALUE>
    Y.MIN.POINT.USED = R.PROGRAM<REDO.PROG.MIN.POINT.USED>
    Y.MAX.POINT.USED = R.PROGRAM<REDO.PROG.MAX.POINT.USED>
    Y.AVAIL.IF.DELAY = R.PROGRAM<REDO.PROG.AVAIL.IF.DELAY>
    Y.PROD.DELAY = R.PROGRAM<REDO.PROG.PROD.DELAY>

    Y.PER.IF.DELAY = R.PROGRAM<REDO.PROG.PER.IF.DELAY>
    Y.GROUP.CUS = R.PROGRAM<REDO.PROG.GROUP.CUS>
    Y.APP.EXC.COND = R.PROGRAM<REDO.PROG.APP.EXC.COND>
    Y.EXC.COND = R.PROGRAM<REDO.PROG.EXC.COND>
    Y.APP.INC.COND = R.PROGRAM<REDO.PROG.APP.INC.COND>
    Y.INC.COND = R.PROGRAM<REDO.PROG.INC.COND>
    Y.POINT.USE = R.PROGRAM<REDO.PROG.POINT.USE>
    Y.GEN.FREC = R.PROGRAM<REDO.PROG.GEN.FREC>
    Y.DAYS.EXP = R.PROGRAM<REDO.PROG.DAYS.EXP>
    Y.EXP.DATE = R.PROGRAM<REDO.PROG.EXP.DATE>
    Y.TXN.TYPE.F.INT = R.PROGRAM<REDO.PROG.TXN.TYPE.F.INT>
    Y.INT.ACCT = R.PROGRAM<REDO.PROG.INT.ACCT>
    Y.PRODUCT = R.PROGRAM<REDO.PROG.PRODUCT>

    Y.TXN.TYPE.GEN = R.PROGRAM<REDO.PROG.TXN.TYPE.GEN>
    Y.TXN.TYPE.AVA = R.PROGRAM<REDO.PROG.TXN.TYPE.AVA>
    Y.TXN.TYPE.US = R.PROGRAM<REDO.PROG.TXN.TYPE.US>
    Y.TXN.TYPE.DUE = R.PROGRAM<REDO.PROG.TXN.TYPE.DUE>
    Y.TXN.TYPE.MAN = R.PROGRAM<REDO.PROG.TXN.TYPE.MAN>
    Y.COND.TYPE.EXINC = R.PROGRAM<REDO.PROG.COND.TYPE.EXINC>
    Y.EXC.EST.ACCT = R.PROGRAM<REDO.PROG.EXC.EST.ACCT>
    Y.INC.EST.ACCT = R.PROGRAM<REDO.PROG.INC.EST.ACCT>
    Y.EXC.EST.LOAN = R.PROGRAM<REDO.PROG.EXC.EST.LOAN>
    Y.INC.EST.LOAN = R.PROGRAM<REDO.PROG.INC.EST.LOAN>
    Y.EXC.COND.LOAN = R.PROGRAM<REDO.PROG.EXC.COND.LOAN>
    Y.INC.COND.LOAN = R.PROGRAM<REDO.PROG.INC.COND.LOAN>
    Y.EXP.TYPE = R.PROGRAM<REDO.PROG.EXP.TYPE>

RETURN

*--------
PROCESS1:
*--------

    IF Y.MODALITY EQ '' THEN
        T(REDO.PROG.MODALITY)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.MODALITY)<3>=''
    END

    IF Y.AIRL.PROG EQ '' THEN
        T(REDO.PROG.AIRL.PROG)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.AIRL.PROG)<3>=''
    END

    IF Y.START.DATE EQ '' THEN
        T(REDO.PROG.START.DATE)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.START.DATE)<3>=''
    END

    IF Y.END.DATE EQ '' THEN
        T(REDO.PROG.END.DATE)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.END.DATE)<3>=''
    END

    IF Y.STATUS EQ '' THEN
        T(REDO.PROG.STATUS)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.STATUS)<3>=''
    END

    IF Y.NEG.POINT.SHIP EQ '' THEN
        T(REDO.PROG.NEG.POINT.SHIP)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.NEG.POINT.SHIP)<3>=''
    END

    IF Y.AVAILABILITY EQ '' THEN
        T(REDO.PROG.AVAILABILITY)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.AVAILABILITY)<3>=''
    END

    IF Y.AVAIL.DATE EQ '' THEN
        T(REDO.PROG.AVAIL.DATE)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.AVAIL.DATE)<3>=''
    END

    IF Y.POINT.VALUE EQ '' THEN
        T(REDO.PROG.POINT.VALUE)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.POINT.VALUE)<3>=''
    END

    IF Y.MIN.POINT.USED EQ '' THEN
        T(REDO.PROG.MIN.POINT.USED)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.MIN.POINT.USED)<3>=''
    END

    IF Y.MAX.POINT.USED EQ '' THEN
        T(REDO.PROG.MAX.POINT.USED)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.MAX.POINT.USED)<3>=''
    END

    IF Y.AVAIL.IF.DELAY EQ '' THEN
        T(REDO.PROG.AVAIL.IF.DELAY)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.AVAIL.IF.DELAY)<3>=''
    END

    IF Y.PROD.DELAY EQ '' THEN
        T(REDO.PROG.PROD.DELAY)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.PROD.DELAY)<3>=''
    END

RETURN

*--------
PROCESS2:
*--------

    IF Y.PER.IF.DELAY EQ '' THEN
        T(REDO.PROG.PER.IF.DELAY)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.PER.IF.DELAY)<3>=''
    END

    IF Y.GROUP.CUS EQ '' THEN
        T(REDO.PROG.GROUP.CUS)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.GROUP.CUS)<3>=''
    END

    IF Y.APP.EXC.COND EQ '' THEN
        T(REDO.PROG.APP.EXC.COND)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.APP.EXC.COND)<3>=''
    END

    IF Y.EXC.COND EQ '' THEN
        T(REDO.PROG.EXC.COND)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.EXC.COND)<3>=''
    END

    IF Y.APP.INC.COND EQ '' THEN
        T(REDO.PROG.APP.INC.COND)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.APP.INC.COND)<3>=''
    END

    IF Y.INC.COND EQ '' THEN
        T(REDO.PROG.INC.COND)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.INC.COND)<3>=''
    END

    IF Y.POINT.USE EQ '' THEN
        T(REDO.PROG.POINT.USE)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.POINT.USE)<3>=''
    END

    IF Y.GEN.FREC EQ '' THEN
        T(REDO.PROG.GEN.FREC)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.GEN.FREC)<3>=''
    END

    IF Y.DAYS.EXP EQ '' THEN
        T(REDO.PROG.DAYS.EXP)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.DAYS.EXP)<3>=''
    END

    IF Y.EXP.DATE EQ '' THEN
        T(REDO.PROG.EXP.DATE)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.EXP.DATE)<3>=''
    END

    IF Y.TXN.TYPE.F.INT EQ '' THEN
        T(REDO.PROG.TXN.TYPE.F.INT)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.TXN.TYPE.F.INT)<3>=''
    END

    IF Y.INT.ACCT EQ '' THEN
        T(REDO.PROG.INT.ACCT)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.INT.ACCT)<3>=''
    END

    IF Y.PRODUCT EQ '' THEN
        T(REDO.PROG.PRODUCT)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.PRODUCT)<3>=''
    END

RETURN

*--------
PROCESS3:
*--------

    IF Y.TXN.TYPE.GEN EQ '' THEN
        T(REDO.PROG.TXN.TYPE.GEN)<3>='NOINPUT'
        T(REDO.PROG.DR.ACCT.GEN)<3>='NOINPUT'
        T(REDO.PROG.CR.ACCT.GEN)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.TXN.TYPE.GEN)<3>=''
        T(REDO.PROG.DR.ACCT.GEN)<3>=''
        T(REDO.PROG.CR.ACCT.GEN)<3>=''
    END

    IF Y.TXN.TYPE.AVA EQ '' THEN
        T(REDO.PROG.TXN.TYPE.AVA)<3>='NOINPUT'
        T(REDO.PROG.DR.ACCT.AVA)<3>='NOINPUT'
        T(REDO.PROG.CR.ACCT.AVA)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.TXN.TYPE.AVA)<3>=''
        T(REDO.PROG.DR.ACCT.AVA)<3>=''
        T(REDO.PROG.CR.ACCT.AVA)<3>=''
    END

    IF Y.TXN.TYPE.US EQ '' THEN
        T(REDO.PROG.TXN.TYPE.US)<3>='NOINPUT'
        T(REDO.PROG.DR.ACCT.US)<3>='NOINPUT'
        T(REDO.PROG.CR.ACCT.US)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.TXN.TYPE.US)<3>=''
        T(REDO.PROG.DR.ACCT.US)<3>=''
        T(REDO.PROG.CR.ACCT.US)<3>=''
    END

    IF Y.TXN.TYPE.DUE EQ '' THEN
        T(REDO.PROG.TXN.TYPE.DUE)<3>='NOINPUT'
        T(REDO.PROG.DR.ACCT.DUE)<3>='NOINPUT'
        T(REDO.PROG.CR.ACCT.DUE)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.TXN.TYPE.DUE)<3>=''
        T(REDO.PROG.DR.ACCT.DUE)<3>=''
        T(REDO.PROG.CR.ACCT.DUE)<3>=''
    END

    IF Y.TXN.TYPE.MAN EQ '' THEN
        T(REDO.PROG.TXN.TYPE.MAN)<3>='NOINPUT'
        T(REDO.PROG.DR.ACCT.MAN)<3>='NOINPUT'
        T(REDO.PROG.CR.ACCT.MAN)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.TXN.TYPE.MAN)<3>=''
        T(REDO.PROG.DR.ACCT.MAN)<3>=''
        T(REDO.PROG.CR.ACCT.MAN)<3>=''
    END

    IF Y.COND.TYPE.EXINC EQ '' THEN
        T(REDO.PROG.COND.TYPE.EXINC)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.COND.TYPE.EXINC)<3>=''
    END

    IF Y.EXC.EST.ACCT EQ '' THEN
        T(REDO.PROG.EXC.EST.ACCT)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.EXC.EST.ACCT)<3>=''
    END

    IF Y.INC.EST.ACCT EQ '' THEN
        T(REDO.PROG.INC.EST.ACCT)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.INC.EST.ACCT)<3>=''
    END

    IF Y.EXC.EST.LOAN EQ '' THEN
        T(REDO.PROG.EXC.EST.LOAN)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.EXC.EST.LOAN)<3>=''
    END

    IF Y.INC.EST.LOAN EQ '' THEN
        T(REDO.PROG.INC.EST.LOAN)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.INC.EST.LOAN)<3>=''
    END

    IF Y.EXC.COND.LOAN EQ '' THEN
        T(REDO.PROG.EXC.COND.LOAN)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.EXC.COND.LOAN)<3>=''
    END

    IF Y.INC.COND.LOAN EQ '' THEN
        T(REDO.PROG.INC.COND.LOAN)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.INC.COND.LOAN)<3>=''
    END

    IF Y.EXP.TYPE EQ '' THEN
        T(REDO.PROG.EXP.TYPE)<3>='NOINPUT'
    END ELSE
        T(REDO.PROG.EXP.TYPE)<3>=''
    END

RETURN

END
