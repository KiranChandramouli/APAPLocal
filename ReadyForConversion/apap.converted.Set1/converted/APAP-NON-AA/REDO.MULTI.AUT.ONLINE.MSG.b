SUBROUTINE REDO.MULTI.AUT.ONLINE.MSG
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.AUT.ONLINE.MSG
*-------------------------------------------------------------------------
* Description: This routine is a Authorisation routine is used to store the transaction details
*              in APERTA Area
*-------------------------------------------------------------------------
*----------------------------------------------------------
* Linked with:  T24.FUNDS.SERVICES,FCY.COLLECT T24.FUNDS.SERVICES,LCY.COLLECT
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-09-10          ODR-2010-09-0251              Initial Creation
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CLEARING.PROCESS
    $INSERT I_F.MULTI.TRANSACTION.SERVICE
    $INSERT I_F.LOCKING

    Y.OPERATION = R.NEW(REDO.MTS.OPERATION)
    IF Y.OPERATION EQ 'REPAYMENT' THEN
        GOSUB OPEN.FILE
        GOSUB PROCESS
    END
RETURN
*----------
OPEN.FILE:
*Opening Files

    FN.APAP.PROCESS = 'F.REDO.CLEARING.PROCESS'
    F.APAP.PROCESS = ''
    CALL OPF(FN.APAP.PROCESS,F.APAP.PROCESS)

    FN.TELLER.USER = 'F.TELLER.USER'
    F.TELLER.USER = ''
    CALL OPF(FN.TELLER.USER,F.TELLER.USER)
    FN.MULTI.TRANSACTION.SERVICE = 'F.MULTI.TRANSACTION.SERVICE'
    F.MULTI.TRANSACTION.SERVICE = ''
    CALL OPF(FN.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE)

    FN.LOCKING = 'F.LOCKING'
    F.LOCKING = ''
    CALL OPF(FN.LOCKING,F.LOCKING)
RETURN

*------------
PROCESS:

    Y.PAY.MODE = R.NEW(REDO.MTS.PAYMENT.MODE)
    Y.PAY.MODE = CHANGE(Y.PAY.MODE,@VM,@FM)
    Y.PAY.CNTR = DCOUNT(Y.PAY.MODE,@FM)
    Y.PAY.START = 1
    LOOP
    WHILE Y.PAY.START LE Y.PAY.CNTR
        Y.PAY.VAL = Y.PAY.MODE<Y.PAY.START>
        IF Y.PAY.VAL EQ 'CHEQUE' THEN
            GOSUB MAIN.PROCESS
        END
        Y.PAY.START += 1
    REPEAT

RETURN

*--------------
MAIN.PROCESS:

    CALL F.READ(FN.APAP.PROCESS,'TFS.PROCESS',R.APAP.PROCESS,F.APAP.PROCESS,PROCESS.ERR)
    FILE.NAME = R.APAP.PROCESS<PRE.PROCESS.OUT.PROCESS.NAME>
    FILE.PATH = R.APAP.PROCESS<PRE.PROCESS.OUT.PROCESS.PATH>

    FN.OUTPATH = FILE.PATH
    F.OUTPATH = ''
    CALL OPF(FN.OUTPATH,F.OUTPATH)

    Y.VAR.ID1 = ID.NEW
    Y.VAR.ID = Y.VAR.ID1[4,10]
    Y.ACCT = 0
    Y.ACCT =  FMT(Y.ACCT,"R%11")

    VAR.AMOUNT1 = 0
    VAR.AMOUNT = R.NEW(REDO.MTS.TRANSACTION.AMT)
    VAR.AMOUNT = CHANGE(VAR.AMOUNT,@VM,@FM)
    VAR.CNT = DCOUNT(VAR.AMOUNT,@FM)
    VAR.CNTR = 1
    LOOP
    WHILE VAR.CNTR LE VAR.CNT
        Y.AMT = VAR.AMOUNT<VAR.CNTR>
        VAR.AMOUNT1 += Y.AMT
        VAR.CNTR += 1
    REPEAT

    VAR.AMOUNT1 = FMT(VAR.AMOUNT1,"R%15")
    VAR.TELLER.ID = R.NEW(REDO.MTS.TELLER.ID)
    VAR.CHEQUE = R.NEW(REDO.MTS.NO.OF.CHEQUES)
    VAR.CHEQUE = FMT(VAR.CHEQUE,"R%4")

    OUT.ARRAY = Y.VAR.ID:',':Y.ACCT:VAR.AMOUNT1:VAR.TELLER.ID:VAR.CHEQUE

    CALL F.READ(FN.LOCKING,'REDO.RETURN.FILE',R.LOCKING,F.LOCKING,LOCK.ERR)
    IF R.LOCKING EQ '' THEN
        R.LOCKING<EB.LOK.REMARK> = TODAY
        R.LOCKING<EB.LOK.CONTENT> = 0001
    END
    ELSE
        IF R.LOCKING<EB.LOK.REMARK> EQ TODAY THEN
            R.LOCKING<EB.LOK.CONTENT> = R.LOCKING<EB.LOK.CONTENT> + 1
        END
        ELSE
            R.LOCKING<EB.LOK.REMARK> = TODAY
            R.LOCKING<EB.LOK.CONTENT> = 0001
        END
    END

    CALL F.WRITE(FN.LOCKING,'REDO.RETURN.FILE',R.LOCKING)
    Y.SEQUENCE = R.LOCKING<EB.LOK.CONTENT>
    Y.SEQUENCE = FMT(Y.SEQUENCE,'3"0"R')
    FILE.NAME = FILE.NAME:'.':TODAY:'.':Y.SEQUENCE:".IMP"

    OPENSEQ FILE.PATH,FILE.NAME TO F.PATH ELSE
        CREATE F.PATH ELSE
            OPEN.ERR = 'Unable to Open / Create ':FILE.PATH:" ":FILE.NAME
            CALL EXCEPTION.LOG("S","FT",TRN,"",001,"",Y.PATH,FILE.NAME,"",OPEN.ERR,"")
        END
    END

    CALL F.WRITE(FN.OUTPATH,FILE.NAME,OUT.ARRAY)

    WRITESEQ OUT.ARRAY APPEND TO F.PATH ELSE
        WRI.ERR = 'Unable to write to path ':Y.PATH:" ":FILE.NAME
        CALL EXCEPTION.LOG("S","FT",RTN,"","001","",Y.PATH,FILE.NAME,"",OPEN.ERR,"")
    END

RETURN
END
