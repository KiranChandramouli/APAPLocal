*-----------------------------------------------------------------------------
* <Rating>-55</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.AUT.ONLINE.MSG
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.AUT.ONLINE.MSG
*-------------------------------------------------------------------------
* Description: This routine is a Authorisation routine
*
*----------------------------------------------------------
* Linked with:  T24.FUNDS.SERVICES,FCY.COLLECT T24.FUNDS.SERVICES,LCY.COLLECT
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-09-10          ODR-2010-09-0251              Initial Creation
* 19-05-11          PACS00055026                  Concept for clearing added
*                   PACS00055031
*                   PACS00056666
*                   PACS00055020
* 20-8-2011           PACS00071657                       PACS00071657  FIX
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.LOCKING
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
    $INSERT I_F.REDO.CLEARING.PROCESS
    $INSERT I_F.TELLER



    GOSUB OPEN.FILE

    IF APPLICATION EQ 'TELLER' THEN
        GOSUB TT.PROCESS
    END ELSE
        GOSUB PROCESS
    END

*R.ACCOUNT<AC.LOCAL.REF,TRAN.AVAIL.POS> = R.ACCOUNT<AC.LOCAL.REF,TRAN.AVAIL.POS> + VAR.AMOUNT/100
*CALL F.WRITE(FN.ACCOUNT,HOLD.ACCT.ID,R.ACCOUNT)

    RETURN

*----------
OPEN.FILE:
*Opening Files



    LREF.APP = 'T24.FUND.SERVICES':FM:'TELLER':FM:'ACCOUNT'
    LREF.FIELDS = 'L.TT.NO.OF.CHQ':VM:'L.FT.ADD.INFO':FM:'L.TT.NO.OF.CHQ':FM:'L.AC.TRAN.AVAIL'
    LOCAL.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LOCAL.REF.POS)

    TFS.LOC.POS = LOCAL.REF.POS<1,1>
    POS.L.FT.ADD.INFO = LOCAL.REF.POS<1,2>
    TT.LOC.POS = LOCAL.REF.POS<2,1>
    TRAN.AVAIL.POS = LOCAL.REF.POS<3,1>



    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.APAP.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.PARAM = ''
    CALL OPF(FN.REDO.APAP.PARAM,F.REDO.APAP.PARAM)

    FN.APAP.PROCESS = 'F.REDO.CLEARING.PROCESS'
    F.APAP.PROCESS = ''
    CALL OPF(FN.APAP.PROCESS,F.APAP.PROCESS)

    FN.TELLER.USER = 'F.TELLER.USER'
    F.TELLER.USER = ''
    CALL OPF(FN.TELLER.USER,F.TELLER.USER)

    FN.VAR.LOCKING = 'F.LOCKING'
    F.VAR.LOCKING = ''
    CALL OPF(FN.VAR.LOCKING,F.VAR.LOCKING)


    RETURN

PROCESS:
    NO.OF.CHQ.POS = TFS.LOC.POS
*Get the Count of Transaction Field

    VAR.MULTI.TXN = R.NEW(TFS.TRANSACTION)
    VAR.TRANS.COUNT = DCOUNT(VAR.MULTI.TXN,VM)

*Read the REDO.APAP.CLEAR.PARAM table and get the Transaction Types
    CALL CACHE.READ(FN.REDO.APAP.PARAM,'SYSTEM',R.REDO.APAP.PARAM,PARAM.ERR)
    TXN.TYPES = R.REDO.APAP.PARAM<CLEAR.PARAM.TT.FT.TRAN.TYPE>

*Read Clearing Process Table with ID as TFS.PROCESS
    CALL F.READ(FN.APAP.PROCESS,'TFS.PROCESS',R.APAP.PROCESS,F.APAP.PROCESS,PROCESS.ERR)
    FILE.NAME = R.APAP.PROCESS<PRE.PROCESS.OUT.PROCESS.NAME>
    FILE.PATH = R.APAP.PROCESS<PRE.PROCESS.OUT.PROCESS.PATH>

    FN.OUTPATH = FILE.PATH
    F.OUTPATH = ''
    CALL OPF(FN.OUTPATH,F.OUTPATH)

    TEMP.ID = ID.NEW
    VAR.ID = TEMP.ID[6,10]
    IF R.NEW(TFS.LOCAL.REF)<1,POS.L.FT.ADD.INFO> THEN
        VAR.ACCT = R.NEW(TFS.LOCAL.REF)<1,POS.L.FT.ADD.INFO>
    END ELSE
        VAR.ACCT = R.NEW(TFS.PRIMARY.ACCOUNT)
    END
    HOLD.ACCT.ID  = VAR.ACCT

    GOSUB READ.INT.ACCOUNT
    VAR.AMOUNT = 0
    VAR.USER = R.NEW(TFS.INPUTTER)
    VAR.USER = FIELD(VAR.USER,'_',2)
    CALL F.READ(FN.TELLER.USER,VAR.USER,R.TELLER.USER,F.TELLER.USER,USER.ERR)
    VAR.TELLER.USER = R.TELLER.USER<1>

    CHQ.POS = R.NEW(TFS.LOCAL.REF)<1,NO.OF.CHQ.POS>

*Get the values of Amount field
    VAR.COUNT = 1
    LOOP
        REMOVE TXN FROM VAR.MULTI.TXN SETTING TXN.POS
    WHILE VAR.COUNT LE VAR.TRANS.COUNT
        CHANGE VM TO FM IN TXN.TYPES
        LOCATE TXN IN TXN.TYPES SETTING TRAN.POS THEN
            LOCATED.FLAG = "Y"
            TEMP.AMT = R.NEW(TFS.AMOUNT)<1,VAR.COUNT>
            VAR.AMOUNT = VAR.AMOUNT + TEMP.AMT
        END
        VAR.COUNT++
    REPEAT
    CALL EB.ROUND.AMOUNT('',VAR.AMOUNT,'2','')    ;* PACS00609648
    IF LOCATED.FLAG = "Y" THEN
        VAR.AMT1    = FIELD(VAR.AMOUNT,'.',1)
        VAR.AMT2    = FIELD(VAR.AMOUNT,'.',2)
        IF NOT(VAR.AMT2) THEN
            VAR.AMT2 = '00'
        END
        VAR.TOT.AMT = VAR.AMT1:VAR.AMT2
        VAR.AMOUNT = FMT(VAR.TOT.AMT,'R%15')
        VAR.ACCT   = FMT(VAR.ACCT,'R%11')
        CHQ.POS    = FMT(CHQ.POS,'R%4')
        Y.VAL.DATE = R.NEW(TFS.BOOKING.DATE)
*Writing the Values to a Concat File
        OUT.ARRAY     = 'UPDATEMATCH,DATE=':Y.VAL.DATE:',TABLE=Depositos,Worksource=10'
        OUT.ARRAY<-1> = VAR.ID:',':VAR.ACCT:VAR.AMOUNT:VAR.TELLER.USER:CHQ.POS
        CALL F.READ(FN.VAR.LOCKING,'REDO.RETURN.FILE',R.LOCKING,F.VAR.LOCKING,LOCK.ERR)
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
        CALL F.WRITE(FN.VAR.LOCKING,'REDO.RETURN.FILE',R.LOCKING)
        Y.SEQUENCE = R.LOCKING<EB.LOK.CONTENT>
        Y.SEQUENCE = FMT(Y.SEQUENCE,'3"0"R')
        FILE.NAME = FILE.NAME:'.':TODAY:'.':Y.SEQUENCE:".IMP"

        CALL F.WRITE(FN.OUTPATH,FILE.NAME,OUT.ARRAY)
    END

    RETURN
*>>>>>>>>>>>>>>>>>>>>>>>PACS00055026 - Start
TT.PROCESS:
*~~~~~~~~~~
*Concept for clearing added

    NO.OF.CHQ.POS = TT.LOC.POS

*Get the Count of Transaction Field

*Read the REDO.APAP.CLEAR.PARAM table and get the Transaction Types
    CALL CACHE.READ(FN.REDO.APAP.PARAM,'SYSTEM',R.REDO.APAP.PARAM,PARAM.ERR)
    TXN.TYPES = R.REDO.APAP.PARAM<CLEAR.PARAM.TT.FT.TRAN.TYPE>

*Read Clearing Process Table with ID as TFS.PROCESS
    CALL F.READ(FN.APAP.PROCESS,'TFS.PROCESS',R.APAP.PROCESS,F.APAP.PROCESS,PROCESS.ERR)
    FILE.NAME = R.APAP.PROCESS<PRE.PROCESS.OUT.PROCESS.NAME>
    FILE.PATH = R.APAP.PROCESS<PRE.PROCESS.OUT.PROCESS.PATH>

    FN.OUTPATH = FILE.PATH
    F.OUTPATH = ''
    CALL OPF(FN.OUTPATH,F.OUTPATH)

    TEMP.ID = ID.NEW
    VAR.ID = TEMP.ID[3,10]
    VAR.ACCT = R.NEW(TT.TE.ACCOUNT.2)
    GOSUB READ.INT.ACCOUNT
    VAR.AMOUNT = 0
    VAR.USER = R.NEW(TT.TE.INPUTTER)
    VAR.USER = FIELD(VAR.USER,'_',2)
    CALL F.READ(FN.TELLER.USER,VAR.USER,R.TELLER.USER,F.TELLER.USER,USER.ERR)
    VAR.TELLER.USER = R.TELLER.USER<1>

    CHQ.POS = R.NEW(TT.TE.LOCAL.REF)<1,NO.OF.CHQ.POS>

*Get the values of Amount field
    VAR.AMOUNT = R.NEW(TT.TE.AMOUNT.LOCAL.1)

    VAR.AMOUNT = FMT(VAR.AMOUNT,'R%15')
    VAR.ACCT   = FMT(VAR.ACCT,'R%11')
    CHQ.POS    = FMT(CHQ.POS,'R%4')

*Writing the Values to a Concat File
    OUT.ARRAY = VAR.ID:',':VAR.ACCT:VAR.AMOUNT:VAR.TELLER.USER:CHQ.POS
    CALL F.READ(FN.VAR.LOCKING,'REDO.RETURN.FILE',R.LOCKING,F.VAR.LOCKING,LOCK.ERR)
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
    CALL F.WRITE(FN.VAR.LOCKING,'REDO.RETURN.FILE',R.LOCKING)
    Y.SEQUENCE = R.LOCKING<EB.LOK.CONTENT>
    Y.SEQUENCE = FMT(Y.SEQUENCE,'3"0"R')
    FILE.NAME = FILE.NAME:'.':TODAY:'.':Y.SEQUENCE:".IMP"

    CALL F.WRITE(FN.OUTPATH,FILE.NAME,OUT.ARRAY)


    RETURN
*>>>>>>>>>>>>>>>>>>>>>>>PACS00055026 - End

*----------------
READ.INT.ACCOUNT:
*----------------
    CALL F.READ(FN.ACCOUNT,VAR.ACCT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    IF R.ACCOUNT THEN
        VAR.CUST = R.ACCOUNT<AC.CUSTOMER>
        IF NOT(VAR.CUST) THEN
            VAR.ACCT = R.ACCOUNT<AC.ALT.ACCT.ID>
        END
    END ELSE
        VAR.ACCT = R.NEW(TFS.PRIMARY.ACCOUNT)
        CALL F.READ(FN.ACCOUNT,VAR.ACCT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
        IF R.ACCOUNT THEN
            HOLD.ACCT.ID  = VAR.ACCT
            VAR.CUST = R.ACCOUNT<AC.CUSTOMER>
            IF NOT(VAR.CUST) THEN
                VAR.ACCT = R.ACCOUNT<AC.ALT.ACCT.ID>
            END
        END
    END
    RETURN

END