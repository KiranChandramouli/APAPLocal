*-----------------------------------------------------------------------------
* <Rating>30</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.REC.ACCT.LIST(Y.ACCT.ID)

    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_BATCH.FILES
    $INCLUDE T24.BP I_F.STMT.ENTRY
    $INCLUDE T24.BP I_F.FUNDS.TRANSFER
    $INCLUDE T24.BP I_F.TELLER
    $INCLUDE T24.BP I_F.ACCOUNT
    $INCLUDE T24.BP I_F.EB.CONTRACT.BALANCES
    $INCLUDE T24.BP I_F.TELLER
    $INCLUDE T24.BP I_F.FUNDS.TRANSFER
    $INCLUDE T24.BP I_F.DATES
    $INCLUDE T24.BP I_F.FOREX
    $INCLUDE T24.BP I_F.RE.STAT.REP.LINE
    $INCLUDE T24.BP I_ENQUIRY.COMMON
    $INCLUDE USPLATFORM.BP  I_F.T24.FUND.SERVICES
    $INCLUDE TAM.BP    I_REDO.B.REC.ACCT.LIST.COMMON

    CALL REDO.S.REC.ACCT.LIST(Y.ACCT.ID,Y.FIN.ARRAY)
    GOSUB WRITE.DATA
    RETURN

**********
WRITE.DATA:
**********

    IF Y.FIN.ARRAY THEN 
        Y.REC.COUNT = DCOUNT(Y.FIN.ARRAY,FM)
        Y.REC.START = 1
        LOOP
        WHILE Y.REC.START LE Y.REC.COUNT
            Y.REC.LINE = Y.FIN.ARRAY<Y.REC.START>
            Y.COMP.ID  = FIELD(Y.REC.LINE,Y.DLM,2)
            IF NOT(Y.COMP.ID) THEN
                Y.COMP.ID  =FIELD(Y.REC.LINE,Y.DLM,3)
            END
            Y.SORT.VAL = FIELD(Y.REC.LINE,Y.DLM,1):Y.COMP.ID:FIELD(Y.REC.LINE,Y.DLM,6):FIELD(Y.REC.LINE,Y.DLM,5)
            Y.FILE.NAME=FILE.NAME:Y.SORT.VAL:SESSION.NO
            OPENSEQ TEMP.PATH,Y.FILE.NAME TO SEQ.PTR ELSE
                CREATE SEQ.PTR ELSE
                    ERR.MSG  = "Unable to write to file '":FILE.NAME:"'"
                    INT.CODE = 'REP001'
                    INT.TYPE = 'BATCH'
                    MON.TP   = 04
                    REC.CON  = 'RECONRPT':ERR.MSG
                    DESC     = 'RECONRPT':ERR.MSG
                    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
                END
            END
            GOSUB WR.SEQ.FILE
            Y.REC.START += 1
        REPEAT
    END
    RETURN

***********
WR.SEQ.FILE:
***********

    WRITESEQ Y.REC.LINE APPEND TO SEQ.PTR ELSE
        ERR.MSG  = "Unable to write to file '":FILE.NAME:"'"
        INT.CODE = 'REP001'
        INT.TYPE = 'BATCH'
        MON.TP   = 04
        REC.CON  = 'RECONRPT':ERR.MSG
        DESC     = 'RECONRPT':ERR.MSG
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END

    RETURN
END
