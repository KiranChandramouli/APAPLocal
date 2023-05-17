SUBROUTINE REDO.V.ITEM.STOCK.CAL
*-----------------------------------------------------------------------------
* Description:
* This routine will be attached to the versions as
* a validation routine
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.V.ITEM.STOCK.CAL
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 12.04.2010  MARIMUTHU S         ODR-2009-11-0200  INITIAL CREATION
* 03.01.2017  GOPALA KRISHNAN R   PACS00643734      DEFECT
* 19.04.2018  GOPALA KRISHNAN R   PACS00643734      MODIFICATION
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.USER
    $INSERT I_F.REDO.H.ORDER.DETAILS
    $INSERT I_F.REDO.ITEM.STOCK
    $INSERT I_F.REDO.H.DEPOSIT.RECEIPTS
    $INSERT I_F.REDO.H.PASSBOOK.INVENTORY
    $INSERT I_F.REDO.H.ADMIN.CHEQUES
    $INSERT I_F.REDO.H.BANK.DRAFTS
    $INSERT I_F.REDO.H.MAIN.COMPANY
    $INSERT I_F.REDO.L.SERIES.CHANGE.DETS

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PROGRAM.END
RETURN
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    Y.ID.COMPANY.2 = ''
    LOC.REF.APPLICATION="USER"
    LOC.REF.FIELDS='L.US.IDC.BR':@VM:'L.US.IDC.CODE'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.BR.VAL =LOC.REF.POS<1,1>
    POS.DETP.VAL = LOC.REF.POS<1,2>

    Y.CODE.DEPT = ''
    Y.BRANCH.LIST = R.USER<EB.USE.LOCAL.REF,POS.BR.VAL>
    Y.DEPT.LIST = R.USER<EB.USE.LOCAL.REF,POS.DETP.VAL>
    CHANGE @SM TO @FM IN Y.BRANCH.LIST
    CHANGE @VM TO @FM IN Y.BRANCH.LIST
    CHANGE @SM TO @FM IN Y.DEPT.LIST
    CHANGE @VM TO @FM IN Y.DEPT.LIST

    FN.REDO.ITEM.STOCK = 'F.REDO.ITEM.STOCK'
    F.REDO.ITEM.STOCK = ''
    CALL OPF(FN.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK)

    FN.REDO.H.MAIN.COMPANY = 'F.REDO.H.MAIN.COMPANY'
    F.REDO.H.MAIN.COMPANY = ''
    CALL OPF(FN.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY)
    FN.REDO.ITEM.SERIES = 'F.REDO.ITEM.SERIES'
    F.REDO.ITEM.SERIES = ''
    CALL OPF(FN.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES)

    FN.REDO.L.SERIES.CHANGE.DETS = 'F.REDO.L.SERIES.CHANGE.DETS'
    F.REDO.L.SERIES.CHANGE.DETS = ''
    CALL OPF(FN.REDO.L.SERIES.CHANGE.DETS, F.REDO.L.SERIES.CHANGE.DETS)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT, F.AZ.ACCOUNT)

    FN.REDO.H.DEPOSIT.RECEIPTS = 'F.REDO.H.DEPOSIT.RECEIPTS'
    F.REDO.H.DEPOSIT.RECEIPTS = ''
    CALL OPF(FN.REDO.H.DEPOSIT.RECEIPTS, F.REDO.H.DEPOSIT.RECEIPTS)

    Y.INV.MNT.ID = R.NEW(RE.ORD.ITEM.CODE)
    CALL REDO.CHECK.APPLICATION(Y.INV.MNT.ID,APPL.NAME,APPL.PATH)
    DUP.APPL.NAME = APPL.NAME
    DUP.APPL.PATH = APPL.PATH

    Y.DEL.QUL =  R.NEW(RE.ORD.DESTROY.QUANTITY)
    Y.TOTAL.VAL = 0
    Y.DIFF = 0
    IF APPL.NAME THEN
        CALL OPF(APPL.NAME,APPL.PATH)
    END
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL OPF(APPL.NAME,APPL.PATH)

    IF DUP.APPL.NAME EQ 'F.REDO.H.PIGGY.BANKS' THEN
        Y.PIGGY.FLAG = '1'
    END

    IF  PGM.VERSION EQ ",TRANSFER.AMONG.AREAS" THEN
        Y.ID.COMPANY = R.NEW(RE.ORD.TRANSFER.FROM)
        Y.ID.COMPANY.2 = R.NEW(RE.ORD.TRANSFER.TO)

    END ELSE
        Y.ID.COMPANY = ID.COMPANY
    END
    R.REDO.H.MAIN.COMPANY = ''
    CALL F.READ(FN.REDO.H.MAIN.COMPANY,Y.ID.COMPANY.2,R.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY,Y.ERR)

    IF R.REDO.H.MAIN.COMPANY AND NOT(R.NEW(RE.ORD.BRANCH.TRAN.DES)) THEN
        ETEXT = 'AZ-INP.MISS'
        AF = RE.ORD.BRANCH.TRAN.DES
        CALL STORE.END.ERROR
    END ELSE
        Y.GROUP = Y.ID.COMPANY.2
        CALL F.READ(FN.REDO.H.MAIN.COMPANY,Y.GROUP,R.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY,Y.ERR)
        Y.DES.1 = R.NEW(RE.ORD.BRANCH.TRAN.DES)
        LOCATE Y.DES.1 IN R.REDO.H.MAIN.COMPANY<REDO.COM.DESCRIPTION,1> SETTING POS.1.2 THEN
            R.NEW(RE.ORD.BRANCH.TRAN.CODE) = R.REDO.H.MAIN.COMPANY<REDO.COM.CODE,POS.1.2>
        END
    END

    R.REDO.H.MAIN.COMPANY1 = ''
    CALL F.READ(FN.REDO.H.MAIN.COMPANY,Y.ID.COMPANY,R.REDO.H.MAIN.COMPANY1,F.REDO.H.MAIN.COMPANY,Y.ERR)
    IF R.REDO.H.MAIN.COMPANY1 AND NOT(R.NEW(RE.ORD.BRANCH.DES)) THEN
        ETEXT = 'AZ-INP.MISS'
        AF = RE.ORD.BRANCH.DES
        CALL STORE.END.ERROR
    END ELSE
        Y.GROUP = R.NEW(RE.ORD.REQUEST.COMPANY)
        CALL F.READ(FN.REDO.H.MAIN.COMPANY,Y.GROUP,R.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY,Y.ERR)
        Y.DES = R.NEW(RE.ORD.BRANCH.DES)
        LOCATE Y.DES IN R.REDO.H.MAIN.COMPANY<REDO.COM.DESCRIPTION,1> SETTING POS.1.1 THEN
            R.NEW(RE.ORD.BRANCH.CODE) = R.REDO.H.MAIN.COMPANY<REDO.COM.CODE,POS.1.1>
        END
    END

    Y.BRACH.CODE = R.NEW(RE.ORD.BRANCH.CODE)
    IF R.NEW(RE.ORD.BRANCH.CODE) THEN
        Y.ITEM.STOCK.ID = ID.COMPANY:'-':R.NEW(RE.ORD.BRANCH.CODE)
        Y.S.ID = ID.COMPANY:'-':R.NEW(RE.ORD.BRANCH.CODE):'.':R.NEW(RE.ORD.ITEM.CODE)
    END ELSE
        Y.ITEM.STOCK.ID = ID.COMPANY
        Y.S.ID = ID.COMPANY:'-':R.NEW(RE.ORD.BRANCH.CODE):'.':R.NEW(RE.ORD.ITEM.CODE)
    END
    CALL F.READ(FN.REDO.ITEM.SERIES,Y.S.ID,R.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES,Y.ERR.S)
    Y.CNT.TOT = DCOUNT(R.REDO.ITEM.SERIES,@FM)
    Y.SERIES.LIST.DUP = FIELDS(R.REDO.ITEM.SERIES,'*',1,1)
    Y.STATUS.LIST.DUP = FIELDS(R.REDO.ITEM.SERIES,'*',2,1)
    Y.BATCH.LIST.DUP = FIELDS(R.REDO.ITEM.SERIES,'*',3,1)


    GOSUB TRANSFER.AMONG.AREAS.VERSION

    GOSUB DESTRUCTION.VERSION

    GOSUB CANCEL.VERSION
    GOSUB STOCK.CHECK.BAL.VAL


RETURN
*-----------------------------------------------------------------------------
STOCK.CHECK.BAL.VAL:
*-----------------------------------------------------------------------------
    Y.ITEM = R.NEW(RE.ORD.ITEM.CODE)
    CALL F.READ(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK,Y.ERR)
    Y.BAL.LIST = R.REDO.ITEM.STOCK<ITEM.REG.BAL>
    Y.ITEM.LIST = R.REDO.ITEM.STOCK<ITEM.REG.ITEM.CODE>
    LOCATE Y.ITEM IN Y.ITEM.LIST<1,1> SETTING POS THEN
        Y.BAL = Y.BAL.LIST<1,POS>
        IF Y.QNTY GT Y.BAL THEN
            AF = Y.FIELDS
            ETEXT = "EB-QNT.REG.L.QTY.ENTRY"
            CALL STORE.END.ERROR
        END
    END ELSE
        AF = Y.FIELDS
        ETEXT = "EB-QNT.REG.L.QTY.ENTRY"
        CALL STORE.END.ERROR
    END
RETURN
*-----------------------------------------------------------------------------
CANCEL.VERSION:
*-----------------------------------------------------------------------------
    IF  PGM.VERSION EQ ",CANCELLATION" THEN
        Y.QNTY = R.NEW(RE.ORD.CANCEL.QUANTITY)
        Y.DEL.QUL = Y.QNTY
        Y.FIELDS = RE.ORD.CANCEL.QUANTITY
        AF = RE.ORD.CANCEL.QUANTITY
        IF NOT(Y.PIGGY.FLAG) THEN
            GOSUB AVALIABLE.CHECK
        END
    END
RETURN
*-----------------------------------------------------------------------------
DESTRUCTION.VERSION:
*-----------------------------------------------------------------------------
    IF  PGM.VERSION EQ ",DESTRUCTION" THEN

        Y.QNTY = R.NEW(RE.ORD.DESTROY.QUANTITY)
        Y.FIELDS = RE.ORD.DESTROY.QUANTITY
        AF =       RE.ORD.DESTROY.QUANTITY
        IF NOT(Y.PIGGY.FLAG) THEN
            GOSUB AVALIABLE.CHECK
        END
    END
RETURN
*-----------------------------------------------------------------------------
USER.DEPT.CHECK:
*-----------------------------------------------------------------------------
    Y.FRM.TRASN.BR = R.NEW(RE.ORD.TRANSFER.FROM)
    Y.TO.TRASN.BR = R.NEW(RE.ORD.TRANSFER.TO)
    Y.FRM.CODE.BR = R.NEW(RE.ORD.BRANCH.CODE)
    Y.TO.CODE.BR = R.NEW(RE.ORD.BRANCH.TRAN.CODE)
    IF Y.FRM.TRASN.BR EQ Y.TO.TRASN.BR THEN
        IF Y.FRM.CODE.BR EQ Y.TO.CODE.BR THEN
            AF = RE.ORD.BRANCH.DES
            ETEXT = 'AC-INVALID.DEPARTMENT.CODE'
            CALL STORE.END.ERROR
            GOSUB PROGRAM.END

        END
    END
    Y.NO.ERR = ''
    Y.B.CNT = 1
    LOOP
    WHILE Y.B.CNT LE DCOUNT(Y.BRANCH.LIST,@FM)
        IF Y.FRM.TRASN.BR EQ Y.BRANCH.LIST<Y.B.CNT> AND Y.FRM.CODE.BR EQ Y.DEPT.LIST<Y.B.CNT> THEN
            Y.NO.ERR = '1'
            Y.B.CNT = Y.B.CNT + DCOUNT(Y.BRANCH.LIST,@FM)
        END
        Y.B.CNT += 1
    REPEAT
    IF NOT(Y.NO.ERR) THEN
        AF = RE.ORD.BRANCH.DES
        ETEXT = 'AC-INVALID.DEPARTMENT.CODE'
        CALL STORE.END.ERROR
        GOSUB PROGRAM.END
    END

RETURN
*-----------------------------------------------------------------------------
TRANSFER.AMONG.AREAS.VERSION:
*-----------------------------------------------------------------------------
    IF  PGM.VERSION EQ ",TRANSFER.AMONG.AREAS" THEN
        GOSUB USER.DEPT.CHECK
        R.NEW(RE.ORD.ORDER.STATUS)= 'TRANSFERENCIA'
        Y.ID = R.NEW(RE.ORD.TRANSFER.FROM)
        Y.ITEM.STOCK.ID = Y.ID:'-':FIELD(Y.ITEM.STOCK.ID,"-",2)
        Y.S.ID = Y.ID:'-':FIELD(Y.S.ID,"-",2)
        Y.QNTY = R.NEW(RE.ORD.TRANSFER.QUANTITY)
        Y.DEL.QUL = Y.QNTY
        Y.FIELDS = RE.ORD.TRANSFER.QUANTITY
        AF = RE.ORD.TRANSFER.QUANTITY
        IF NOT(Y.PIGGY.FLAG) THEN
            GOSUB AVALIABLE.CHECK
        END

    END
RETURN
*-----------------------------------------------------------------------------
AVALIABLE.CHECK:
*-----------------------------------------------------------------------------
    SEQ.COUNT = DCOUNT(R.NEW(RE.ORD.SERIES.FROM),@VM)

    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE SEQ.COUNT DO

        GOSUB LOOP.PROCESS.RETURN

    REPEAT
    IF Y.DEL.QUL NE Y.TOTAL.VAL THEN
        ETEXT = "EB-DEL.QUANTITY.NOT.EQ"
        CALL STORE.END.ERROR
    END

RETURN
*-----------------------------------------------------------------------------
LOOP.PROCESS.RETURN:
*-----------------------------------------------------------------------------
    Y.SEQ.FROM = R.NEW(RE.ORD.SERIES.FROM)<1,Y.CNT>
    Y.SEQ.TO = R.NEW(RE.ORD.SERIES.TO)<1,Y.CNT>
    Y.DIFF = Y.SEQ.TO - Y.SEQ.FROM
    LEN.SEQ = LEN(Y.SEQ.FROM) ;*PACS00643734
    GOSUB QUANTITY.CHECK

    LOOP
    WHILE Y.SEQ.FROM LE Y.SEQ.TO DO
        SEL.LIST.1 = ''       ;*PACS00643734
        GOSUB CASE.FILE.SEL
        Y.SEQ.FROM += 1
        Y.SEQ.FROM = FMT(Y.SEQ.FROM, 'R%':LEN.SEQ)          ;*PACS00643734
        Y.TOTAL.VAL += 1
    REPEAT
    Y.CNT += 1
RETURN
*-----------------------------------------------------------------------------------------
QUANTITY.CHECK:
*-----------------------------------------------------------------------------------------
    IF Y.SEQ.TO AND Y.SEQ.FROM GT Y.SEQ.TO THEN
        AV = Y.CNT
        AF=RE.ORD.SERIES.FROM
        ETEXT = "EB-SEQ.FROM.GT.TO"
        CALL STORE.END.ERROR
    END
RETURN
*-----------------------------------------------------------------------------
CASE.FILE.SEL:
*-----------------------------------------------------------------------------

    R.REC = ''
    Y.SERIES.LIST.DUP.COUNT = DCOUNT(Y.SERIES.LIST.DUP,@FM)  ;*PACS00643734
    LOOP
    UNTIL R.REC NE '' OR Y.SERIES.LIST.DUP.COUNT EQ '0'     ;*PACS00643734
        LOCATE Y.SEQ.FROM IN Y.SERIES.LIST.DUP SETTING POS.VAL THEN
            SEL.LIST.1 = Y.BATCH.LIST.DUP<POS.VAL>
        END

        IF SEL.LIST.1 THEN
            CALL F.READ(APPL.NAME,SEL.LIST.1,R.REC,APPL.PATH,Y.ERR.A)
        END
        DEL Y.SERIES.LIST.DUP<POS.VAL>
        DEL Y.STATUS.LIST.DUP<POS.VAL>
        DEL Y.BATCH.LIST.DUP<POS.VAL>
        Y.SERIES.LIST.DUP.COUNT -= 1    ;*PACS00643734
    REPEAT

    BEGIN CASE
        CASE DUP.APPL.NAME EQ 'F.REDO.H.DEPOSIT.RECEIPTS'

            GOSUB DEPOSIT.RECEIPTS
            GOSUB CHECK.NOT.AVBL
            IF NOT(R.REC) OR (Y.STATUS NE 'AVAILABLE') THEN     ;*PACS00679784
                GOSUB ERROR.THROW ;*PACS00679784
            END         ;*PACS00679784

        CASE DUP.APPL.NAME EQ 'F.REDO.H.BANK.DRAFTS'

            GOSUB BANK.DRAFTS
            IF NOT(R.REC) OR (Y.STATUS NE 'AVAILABLE') THEN
                GOSUB ERROR.THROW
            END

        CASE DUP.APPL.NAME EQ 'F.REDO.H.ADMIN.CHEQUES'

            GOSUB ADMIN.CHEQUES
            IF NOT(R.REC) OR (Y.STATUS NE 'AVAILABLE') THEN
                GOSUB ERROR.THROW
            END

        CASE DUP.APPL.NAME EQ 'F.REDO.H.PASSBOOK.INVENTORY'

            GOSUB PASSBOOK.INVENTORY

            IF NOT(R.REC) OR (Y.STATUS NE 'AVAILABLE') THEN
                GOSUB ERROR.THROW
            END

    END CASE

RETURN
*-----------------------------------------------------------------------------------------
DEPOSIT.RECEIPTS:
*-----------------------------------------------------------------------------------------
    Y.STATUS = R.REC<REDO.DEP.STATUS>
RETURN
*-------------------------------
ADMIN.CHEQUES:
*-------------------------------
    Y.STATUS = R.REC<REDO.ADMIN.STATUS>
RETURN
*-------------------------------
PASSBOOK.INVENTORY:
*-------------------------------
    Y.STATUS = R.REC<REDO.PASS.STATUS>
RETURN
*-------------------------------
BANK.DRAFTS:
*-------------------------------
    Y.STATUS = R.REC<REDO.BANK.STATUS>
RETURN
*-----------------------------------------------------------------------------------------
ERROR.THROW:
*-----------------------------------------------------------------------------------------
    AF =  RE.ORD.SERIES.FROM
    ETEXT = 'EB-INVENTORY.NOT.EXISTS'
    CALL STORE.END.ERROR
    GOSUB PROGRAM.END
RETURN
*-----------------------------------------------------------------------------
CHECK.NOT.AVBL:
*-------------

    IF NOT(R.REC) THEN
        Y.READ.ERR = ''
        Y.FILE.ID = 'AZ':Y.SEQ.FROM
        CALL F.READ(FN.REDO.L.SERIES.CHANGE.DETS, Y.FILE.ID, R.SERIES.CONCAT, F.REDO.L.SERIES.CHANGE.DETS, Y.READ.ERR)

        Y.AZ.ID = R.SERIES.CONCAT<AZ.CH.DETS.AZ.ID,1>
        Y.DEP.REC.ID  = R.SERIES.CONCAT<AZ.CH.DETS.DEP.ID,1>

        Y.READ.ERR = ''
        R.AZ.REC = ''
        CALL F.READ(FN.AZ.ACCOUNT, Y.AZ.ID, R.AZ.REC, F.AZ.ACCOUNT, Y.READ.ERR)

        IF R.AZ.REC THEN
            AF = RE.ORD.SERIES.FROM
            AV = Y.CNT
            ETEXT = 'AZ-CNCL.DEP.FIRST'
            CALL STORE.END.ERROR
        END

        IF Y.DEP.REC.ID AND NOT(R.AZ.REC) THEN
            CALL F.READ(FN.REDO.H.DEPOSIT.RECEIPTS, Y.DEP.REC.ID, R.DEPOSIT.RECEIPTS, F.REDO.H.DEPOSIT.RECEIPTS, Y.READ.ERR)
*            R.DEPOSIT.RECEIPTS<REDO.DEP.ACCOUNT> = ''
            IF PGM.VERSION EQ ",CANCELLATION" THEN
                R.DEPOSIT.RECEIPTS<REDO.DEP.STATUS> = 'Cancelada'
            END
            IF PGM.VERSION EQ ",DESTRUCTION" THEN
                R.DEPOSIT.RECEIPTS<REDO.DEP.STATUS> = 'Destruida'
            END
            CALL F.WRITE(FN.REDO.H.DEPOSIT.RECEIPTS, Y.DEP.REC.ID, R.DEPOSIT.RECEIPTS)
        END

    END

RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
END
