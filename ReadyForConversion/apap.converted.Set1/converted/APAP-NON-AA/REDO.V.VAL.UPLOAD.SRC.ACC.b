SUBROUTINE REDO.V.VAL.UPLOAD.SRC.ACC
*-----------------------------------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.UPLOAD.SRC.ACC
*-----------------------------------------------------------------------------------------------------------
*DESCRIPTION       :It is the input routine to validate the credit and debit accounts
*
*
*LINKED WITH       :

* ----------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who                     Reference            Description
*===========        ====================       ===============     ==================
* 29-12-2010        Sakthi Sellappillai        ODR-2010-08-0031     Initial Creation
* 03-06-2010        Ganesh H                   PACS00072713         Modification
*-----------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.EB.FILE.UPLOAD.TYPE
    $INSERT I_F.EB.FILE.UPLOAD.PARAM
    $INSERT I_F.EB.FILE.UPLOAD
    $INSERT I_F.ACCOUNT
    $INSERT I_System
    GOSUB INITIALISE
    GOSUB PROCESS
    GOSUB WRITE.FILE.PROCESS
    GOSUB GOEND
RETURN
*-----------------------------------------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------------------------------------

    FN.FILE.UP.TYPE='F.EB.FILE.UPLOAD.TYPE'
    F.FILE.UP.TYPE=''
    R.UP.TYPE = ''
    UP.TYPE.ERR = ''
    CALL OPF(FN.FILE.UP.TYPE,F.FILE.UP.TYPE)
    FN.EB.FILE.UPLOAD.PARAM = 'F.EB.FILE.UPLOAD.PARAM'
    F.EB.FILE.UPLOAD.PARAM = ''
    R.EB.FILE.UPLOAD.PARAM = ''
    Y.EB.FILE.UPLOAD.PARMA.ERR = ''
*CALL OPF(FN.EB.FILE.UPLOAD.PARAM,F.EB.FILE.UPLOAD.PARAM) ;*Tus S/E

*  CALL F.READ(FN.EB.FILE.UPLOAD.PARAM,'SYSTEM',R.EB.FILE.UPLOAD.PARAM,F.EB.FILE.UPLOAD.PARAM,Y.EB.FILE.UPLOAD.PARMA.ERR) ;*Tus Start
    CALL CACHE.READ(FN.EB.FILE.UPLOAD.PARAM,'SYSTEM',R.EB.FILE.UPLOAD.PARAM,Y.EB.FILE.UPLOAD.PARMA.ERR) ; * Tus End
    IF NOT(Y.EB.FILE.UPLOAD.PARMA.ERR) THEN
        Y.UPLOAD.PARAM.VAL = R.EB.FILE.UPLOAD.PARAM<EB.UP.TC.UPLOAD.PATH>
    END
    Y.UPLOAD.FILE.TYPE.VAL = R.NEW(EB.UF.UPLOAD.TYPE)
    CALL CACHE.READ(FN.FILE.UP.TYPE, Y.UPLOAD.FILE.TYPE.VAL, R.UP.TYPE, UP.TYPE.ERR)
    IF NOT(UP.TYPE.ERR) THEN
        Y.UPLOAD.DIR.VAL = R.UP.TYPE<EB.UT.UPLOAD.DIR>
    END
    Y.SYMBOL.DIR = Y.UPLOAD.DIR.VAL[1,1]
    IF Y.SYMBOL.DIR NE '/' THEN
        Y.FILE.PATH = Y.UPLOAD.PARAM.VAL:"/":Y.UPLOAD.DIR.VAL
    END ELSE
        Y.FILE.PATH = Y.UPLOAD.PARAM.VAL:Y.UPLOAD.DIR.VAL
    END
    FN.FILE.PATH = Y.FILE.PATH
    F.FILE.PATH  =''
    CALL OPF(FN.FILE.PATH,F.FILE.PATH)
    R.FILE.PATH.REC = ''
    Y.FILE.PATH.ERR = ''
    Y.UPLOAD.FILE.NAME = R.NEW(EB.UF.FILE.NAME)
    Y.UPLOAD.FILE.ID = Y.UPLOAD.FILE.NAME['|',1,1]
    Y.LOC.AC.BAL.VAL.POS = ''
    APPL.ARRAY = "ACCOUNT"
    FIELD.ARRAY = "L.AC.AV.BAL":@VM:"L.AC.STATUS1"
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FIELD.ARRAY,FIELD.POS)
    Y.LOC.AC.BAL.VAL.POS = FIELD.POS<1,1>
    Y.LOC.AC.STAT.VAL.POS = FIELD.POS<1,2>
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    R.ACCOUNT.REC = ''
    Y.ACCT.ERR = ''
    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT=''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    R.CUSTOMER.ACCOUNT = ''
    Y.CUST.ACCT.ERR = ''
    Y.CUSTOMER = ''
    Y.UPLOAD.FILE.USER.ID = ''
    Y.UPLOAD.FILE.SYS.GEN = ''
    Y.UPLOAD.FILE.TYPE.ID = ''
    Y.UPLOAD.FILE.SYM.VAL = ''
    Y.FILE.DEBIT.TOT.AMT=''
    Y.DEBIT.ACCT.ARRAY=''
*PACS00072713-s
    CRLF = CHARX(013):CHARX(254)
*PACS00072713-e

RETURN
*-----------------------------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.FILE.PATH,Y.UPLOAD.FILE.ID,R.FILE.PATH.REC,F.FILE.PATH,Y.FILE.PATH.ERR)
*PACS00072713-s
    IF NOT(Y.FILE.PATH.ERR) THEN
        CHANGE CRLF TO @FM IN R.FILE.PATH.REC
    END
*PACS00072713-e
    Y.TOT.FILE.RECS = R.FILE.PATH.REC
    Y.TOT.CNT.VAL = DCOUNT(Y.TOT.FILE.RECS,@FM)
    Y.SRC.ACCT.INIT = 1
    IF Y.TOT.CNT.VAL GT 1 THEN
        LOOP
            REMOVE Y.UPLOAD.FILE FROM Y.TOT.FILE.RECS SETTING Y.SRC.ACCT.POS
        WHILE Y.SRC.ACCT.INIT LE Y.TOT.CNT.VAL
            Y.FILE.SRC.ACCT = Y.UPLOAD.FILE[',',1,1]
            IF Y.FILE.SRC.ACCT NE ',' AND Y.FILE.SRC.ACCT THEN
                Y.FILE.SRC.PREV.ACCT = Y.FILE.SRC.ACCT
                Y.TEMP.LAST=FIELD(Y.UPLOAD.FILE,',',12)
                Y.TEMP.LAST.LEN=LEN(Y.TEMP.LAST)
                Y.TEMP.LAST1=Y.TEMP.LAST[1,Y.TEMP.LAST.LEN-1]
                Y.FILE.DEBIT.AMOUNT=Y.TEMP.LAST1
                GOSUB ACCOUNT.DATE.CHECK
                GOSUB ACCOUNT.VAL.CHECK
                GOSUB ACCOUNT.ACT.CHECK
                Y.DEBIT.ACCT.ARRAY<-1> = Y.FILE.SRC.ACCT
            END
            Y.SRC.ACCT.INIT += 1
        REPEAT
    END ELSE
        IF NOT(Y.FILE.PATH.ERR) THEN
            Y.FILE.SRC.ACCT = Y.UPLOAD.FILE[',',1,1]
            Y.FILE.DEBIT.TOT.AMT.ADD.VAL = Y.UPLOAD.FILE[',',11,1]
            Y.TEMP.LAST=FIELD(Y.UPLOAD.FILE,',',12)
            CHANGE CHARX(13) TO '' IN Y.TEMP.LAST
*Y.TEMP.LAST.LEN=LEN(Y.TEMP.LAST)
*Y.TEMP.LAST1=Y.TEMP.LAST[1,Y.TEMP.LAST.LEN-1]
            Y.FILE.DEBIT.AMOUNT=Y.TEMP.LAST
            Y.FILE.DEBIT.TOT.AMT = Y.FILE.DEBIT.AMOUNT
        END
        IF Y.FILE.SRC.ACCT NE ',' AND Y.FILE.SRC.ACCT THEN
            Y.FILE.SRC.PREV.ACCT = Y.FILE.SRC.ACCT
            GOSUB ACCOUNT.DATE.CHECK
            GOSUB ACCOUNT.VAL.CHECK
            GOSUB ACCOUNT.ACT.CHECK
        END
    END
    Y.FILE.DEBIT.AMOUNT.VAL = Y.FILE.DEBIT.TOT.AMT
    GOSUB AMOUNT.VAL.CHECK
    GOSUB CUST.ACC.CHECK
RETURN
*-----------------------------------------------------------------------------------------------------------
ACCOUNT.DATE.CHECK:
*-----------------------------------------------------------------------------------------------------------
    IF Y.FILE.SRC.PREV.ACCT THEN
        Y.DEBIT.ACCT.DATE = Y.UPLOAD.FILE[',',2,1]
        Y.THIRD.DAY.VAL =TODAY
        Y.FREQ.DAY = '+':'3':'W'
        CALL CDT('',Y.THIRD.DAY.VAL,Y.FREQ.DAY)
        IF Y.DEBIT.ACCT.DATE NE Y.THIRD.DAY.VAL THEN
            ETEXT ='EB-THIRD.WORK.DAY'
            CALL STORE.END.ERROR
        END
    END
RETURN
*-----------------------------------------------------------------------------------------------------------
ACCOUNT.VAL.CHECK:
*-----------------------------------------------------------------------------------------------------------
    IF Y.FILE.SRC.PREV.ACCT THEN
        Y.FILE.SRC.ACCT = Y.FILE.SRC.PREV.ACCT
        IF Y.FILE.DEBIT.AMOUNT THEN
            IF NUM(Y.FILE.DEBIT.AMOUNT) THEN
                IF Y.FILE.DEBIT.TOT.AMT EQ '' THEN
                    Y.FILE.DEBIT.TOT.AMT = Y.FILE.DEBIT.AMOUNT
                END ELSE
                    Y.FILE.DEBIT.TOT.AMT+=Y.FILE.DEBIT.AMOUNT
                END
            END ELSE
                ETEXT ='EB-AMT.SHOUL.NOT.ALPHA'
                CALL STORE.END.ERROR
            END
        END
        IF Y.SRC.ACCT.INIT GT 1 THEN
            LOCATE Y.FILE.SRC.ACCT IN Y.DEBIT.ACCT.ARRAY<1> SETTING Y.DEBT.ACCT.POS THEN
                ETEXT ='EB-VALID.SRC.ACCOUNT'
                CALL STORE.END.ERROR
            END ELSE
                Y.ACCT.INIT.VAL = 1
                GOSUB ACCOUNT.ACT.CHECK
            END
        END
    END

RETURN
*-----------------------------------------------------------------------------------------------------------
ACCOUNT.ACT.CHECK:
*-----------------------------------------------------------------------------------------------------------
    IF Y.FILE.SRC.PREV.ACCT THEN
        Y.FILE.SRC.ACCT = Y.FILE.SRC.PREV.ACCT
        CALL F.READ(FN.ACCOUNT,Y.FILE.SRC.ACCT,R.ACCOUNT.REC,F.ACCOUNT,Y.ACCT.ERR)
        IF NOT(Y.ACCT.ERR) THEN
            Y.AVAIL.AMT.VAL = R.ACCOUNT.REC<AC.LOCAL.REF,Y.LOC.AC.BAL.VAL.POS>
            Y.AC.STATUS.VAL = R.ACCOUNT.REC<AC.LOCAL.REF,Y.LOC.AC.STAT.VAL.POS>
        END ELSE
            ETEXT = 'EB-VALID.ACCOUNT'
            CALL STORE.END.ERROR
        END
        IF Y.AC.STATUS.VAL NE 'ACTIVE' THEN
            ETEXT = 'EB-INACT.ACCOUNT'
            CALL STORE.END.ERROR
        END
    END
RETURN
*-----------------------------------------------------------------------------------------------------------
AMOUNT.VAL.CHECK:
*-----------------------------------------------------------------------------------------------------------
    IF Y.FILE.SRC.PREV.ACCT THEN
        IF Y.FILE.DEBIT.AMOUNT.VAL GT Y.AVAIL.AMT.VAL THEN
            ETEXT ='EB-AMOUNT.NOT.SUFFICIENT.FUND'
            CALL STORE.END.ERROR
        END
    END
RETURN
*-----------------------------------------------------------------------------------------------------------
CUST.ACC.CHECK:
*-----------------------------------------------------------------------------------------------------------
    IF Y.FILE.SRC.PREV.ACCT THEN
        Y.FILE.SRC.ACCT = Y.FILE.SRC.PREV.ACCT
        Y.CUSTOMER =System.getVariable('EXT.SMS.CUSTOMERS')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            Y.CUSTOMER = ""
        END
        CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.CUSTOMER,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,Y.CUST.ACCT.ERR)
        LOCATE Y.FILE.SRC.ACCT IN R.CUSTOMER.ACCOUNT SETTING POS ELSE
            ETEXT ='EB-NOT.USER.ACCT'
            CALL STORE.END.ERROR
        END
    END
RETURN
*-----------------------------------------------------------------------------------------------------------
WRITE.FILE.PROCESS:
*-----------------------------------------------------------------------------------------------------------

    IF ETEXT EQ '' THEN
        Y.UPLOAD.FILE.USER.ID = Y.UPLOAD.FILE.ID['.',1,1]
        Y.UPLOAD.FILE.SYS.GEN = Y.UPLOAD.FILE.ID['.',2,1]
        Y.UPLOAD.FILE.TYPE.ID = Y.UPLOAD.FILE.ID['.',3,1]
        Y.UPLOAD.FILE.SYM.VAL = 'T24'
        Y.UPLOAD.FILE.NEW.ID = Y.UPLOAD.FILE.USER.ID:'.':Y.UPLOAD.FILE.SYM.VAL:'.':Y.UPLOAD.FILE.SYS.GEN:'.':Y.UPLOAD.FILE.TYPE.ID
        Y.CPY.CMD = 'COPY FROM ':Y.FILE.PATH:' TO ':Y.FILE.PATH:' ': Y.UPLOAD.FILE.ID:',':Y.UPLOAD.FILE.NEW.ID
        EXECUTE Y.CPY.CMD
    END
RETURN
*-----------------------------------------------------------------------------------------------------------
GOEND:
*-----------------------------------------------------------------------------------------------------------
END
*---------------------------------------------*END OF SUBROUTINE*-------------------------------------------
