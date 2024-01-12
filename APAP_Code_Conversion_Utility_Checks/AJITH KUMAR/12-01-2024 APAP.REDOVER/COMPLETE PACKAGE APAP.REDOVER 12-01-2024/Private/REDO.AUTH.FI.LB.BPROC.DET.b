* @ValidationCode : MjotMTg5NTk0ODI1NDpDcDEyNTI6MTY4MjQxMjMyNzkzNjpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.FI.LB.BPROC.DET

*-------------------------------------------------------------------L-------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.AUTH.FI.LB.BPROC.DET
*--------------------------------------------------------------------------------
* Description: This Authorization routine routine for REDO.FI.LB.BPROC.DET Table
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO                  REFERENCE               DESCRIPTION
*05-04-2023  Conversion Tool      R22 Auto Code conversion       TOT.TXN.REG - 1 TO -=1, TOT.TXN.REG + 1 TO +=1
*05-04-2023  Samaran T            Manual R22 Code Conversion      No Changes
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.PARAMETER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.FI.LB.BPROC
    $INSERT I_F.REDO.FI.LB.BPROC.DET
    GOSUB OPEN.FILE
    GOSUB PROCESS
RETURN

*---------------------------------------------------------------------------------
OPEN.FILE:
*---------------------------------------------------------------------------------

    FN.REDO.FI.LB.BPROC = 'F.REDO.FI.LB.BPROC'
    F.REDO.FI.LB.BPROC  = ''
    CALL OPF(FN.REDO.FI.LB.BPROC,F.REDO.FI.LB.BPROC)

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    Y.OLD.AMOUNT   = R.OLD(REDO.FI.LB.BPROC.DET.MNT.APLICAR)
    Y.OLD.EXCLUDE  = R.OLD(REDO.FI.LB.BPROC.DET.EXCLUYO)
    Y.OLD.STATUS   = R.OLD(REDO.FI.LB.BPROC.DET.ESTADO)
    Y.NEW.AMOUNT   = R.NEW(REDO.FI.LB.BPROC.DET.MNT.APLICAR)
    Y.NEW.EXCLUDE  = R.NEW(REDO.FI.LB.BPROC.DET.EXCLUYO)
    Y.NEW.STATUS   = R.NEW(REDO.FI.LB.BPROC.DET.ESTADO)
    Y.BILL.BALANCE = ABS(R.NEW(REDO.FI.LB.BPROC.DET.BALANCE))

    ID.FILE = FIELD(ID.NEW,'.',1,2)
    CALL F.READ(FN.REDO.FI.LB.BPROC,ID.FILE,R.REDO.FI.LB.BPROC,F.REDO.FI.LB.BPROC,FILE.ERR)
    Y.FILE.ESTADO = R.REDO.FI.LB.BPROC<REDO.FI.LB.BPROC.ESTADO>
    TOT.TXN.REG   = R.REDO.FI.LB.BPROC<REDO.FI.LB.BPROC.TOTAL.REGISTROS>
    Y.FILE.TOTAL  = R.REDO.FI.LB.BPROC<REDO.FI.LB.BPROC.MONTO.TOTAL>
    Y.TOTAL.PROC  = R.REDO.FI.LB.BPROC<REDO.FI.LB.BPROC.MONTO.TOTAL.PROC>

    IF Y.TOTAL.PROC EQ ABS(Y.FILE.TOTAL) THEN
        AF = REDO.FI.LB.BPROC.DET.EXCLUYO
        ETEXT = 'EB-REDO.PLANILLA.COMPLETED'
        CALL STORE.END.ERROR
    END

    IF Y.NEW.STATUS EQ 'PAGO' AND Y.NEW.EXCLUDE EQ 'SI' THEN
        AF = REDO.FI.LB.BPROC.DET.EXCLUYO
        ETEXT = 'EB-REDO.PLANILLA.PAID'
        CALL STORE.END.ERROR
    END
    IF Y.FILE.ESTADO NE 'COMPLETADO' AND Y.NEW.STATUS NE 'PAGO' THEN
        GOSUB EXECLUDE.SET
        GOSUB EXECLUDE.REV
        R.REDO.FI.LB.BPROC<REDO.FI.LB.BPROC.TOTAL.REGISTROS> = TOT.TXN.REG
        R.REDO.FI.LB.BPROC<REDO.FI.LB.BPROC.MONTO.TOTAL> = Y.EXCLUDE.AMT
        CALL F.WRITE(FN.REDO.FI.LB.BPROC,ID.FILE,R.REDO.FI.LB.BPROC)
    END

    Y.ID.PROCESO.BATCH = FIELD(ID.NEW,'.',1,2)
    IF Y.OLD.EXCLUDE NE Y.NEW.EXCLUDE AND NOT(ETEXT) THEN
        NEW.TASK = "QUERY REDO.FI.LB.BPROC.GEN.DET ID.PROCESO.BATCH EQ ":Y.ID.PROCESO.BATCH
        CALL EB.SET.NEW.TASK(NEW.TASK)
    END
RETURN
*------------
EXECLUDE.SET:
*------------
    IF (Y.OLD.EXCLUDE EQ '' OR Y.OLD.EXCLUDE EQ 'NO') AND  Y.NEW.EXCLUDE EQ 'SI' THEN
        IF Y.NEW.AMOUNT THEN
            IF Y.NEW.AMOUNT LT Y.BILL.BALANCE THEN
                Y.EXCLUDE.AMT = Y.FILE.TOTAL + Y.NEW.AMOUNT
            END ELSE
                Y.EXCLUDE.AMT = Y.FILE.TOTAL - Y.NEW.AMOUNT
            END
        END ELSE
            Y.EXCLUDE.AMT = Y.FILE.TOTAL + Y.BILL.BALANCE
        END
        TOT.TXN.REG -= 1  ;*R22 AUTO CODE CONVERSION
    END
RETURN
*------------
EXECLUDE.REV:
*------------
    IF Y.OLD.EXCLUDE EQ 'SI' AND  (Y.NEW.EXCLUDE EQ '' OR Y.NEW.EXCLUDE EQ 'NO') THEN
        IF Y.NEW.AMOUNT THEN
            IF Y.NEW.AMOUNT LT Y.BILL.BALANCE THEN
                Y.EXCLUDE.AMT = Y.FILE.TOTAL - Y.NEW.AMOUNT
            END ELSE
                Y.EXCLUDE.AMT = Y.FILE.TOTAL + Y.NEW.AMOUNT
            END
        END ELSE
            Y.EXCLUDE.AMT = Y.FILE.TOTAL - Y.BILL.BALANCE
        END
        TOT.TXN.REG += 1  ;*R22 AUTO CODE CONVERSION
    END

RETURN
*----------------------
END
