*-----------------------------------------------------------------------------
* <Rating>-133</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.V.AUTH.CANCELLATION
*----------------------------------------------------------------------------
* Description:
* This routine will be attached to the version REDO.ORDER.DETAIL,CANCELLATION as
* a auth routine
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.V.AUTH.CANCELLATION
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO              REFERENCE         DESCRIPTION
* 12.04.2010  MARIMUTHU S       ODR-2009-11-0200  INITIAL CREATION
* 01.03.2012  JEEVA T           ODR-2009-11-0200  Date updation has been done
* 19.04.2018  GOPALA KRISHNAN R     PACS00643734      MODIFICATION
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.ORDER.DETAILS
    $INSERT I_F.REDO.H.DEPOSIT.RECEIPTS
    $INSERT I_F.REDO.H.ADMIN.CHEQUES
    $INSERT I_F.REDO.H.BANK.DRAFTS
    $INSERT I_F.REDO.H.PASSBOOK.INVENTORY
    $INSERT I_F.REDO.ITEM.STOCK
    $INSERT I_F.REDO.ITEM.STOCK.BY.DATE
    $INSERT I_F.REDO.L.SERIES.CHANGE.DETS
*-----------------------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------------------

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PROGRAM.END
*-----------------------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------------------
    FN.REDO.ITEM.STOCK ='F.REDO.ITEM.STOCK'
    F.REDO.ITEM.STOCK = ''
    FN.REDO.ITEM.SERIES = 'F.REDO.ITEM.SERIES'
    F.REDO.ITEM.SERIES = ''

    FN.REDO.ITEM.STOCK.BY.DATE = 'F.REDO.ITEM.STOCK.BY.DATE'
    F.REDO.ITEM.STOCK.BY.DATE = ''

    Y.BRACH.CODE = R.NEW(RE.ORD.BRANCH.DES)
    IF R.NEW(RE.ORD.BRANCH.CODE) THEN
        Y.ITEM.STOCK.ID = ID.COMPANY:'-':R.NEW(RE.ORD.BRANCH.CODE)
    END ELSE
        Y.ITEM.STOCK.ID = ID.COMPANY
    END
    IF R.NEW(RE.ORD.BRANCH.CODE) THEN
        Y.ITEM.STOCK.RPT.ID = ID.COMPANY:'-':R.NEW(RE.ORD.BRANCH.CODE):".":R.NEW(RE.ORD.ITEM.CODE)
    END ELSE
        Y.ITEM.STOCK.RPT.ID = ID.COMPANY:".":R.NEW(RE.ORD.ITEM.CODE)
    END
    RETURN
*-----------------------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------------------
    INPUTTER = R.NEW(RE.ORD.INPUTTER)
    AUTHORISER = TNO:'_':OPERATOR
    CALL OPF(FN.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK)
    CALL OPF(FN.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE)
    CALL OPF(FN.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES)
    CALL F.READ(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK,Y.ERR)
    CALL F.READ(FN.REDO.ITEM.STOCK.BY.DATE,Y.ITEM.STOCK.RPT.ID,R.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE,Y.ERR.DATE)
    CALL F.READ(FN.REDO.ITEM.SERIES,Y.ITEM.STOCK.RPT.ID,R.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES,Y.ERR.R)
    RETURN
*-----------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------

    Y.BRACH.CODE = R.NEW(RE.ORD.BRANCH.CODE)
    Y.ITEM.CODE = R.NEW(RE.ORD.ITEM.CODE)
    Y.QUANTITY = R.NEW(RE.ORD.CANCEL.QUANTITY)
    Y.REQ.COMP = R.NEW(RE.ORD.REQUEST.COMPANY)
    Y.DESC = R.NEW(RE.ORD.DESCRIPTION)
    SEQ.COUNT = DCOUNT(R.NEW(RE.ORD.SERIES.FROM),VM)
    Y.CNT = 1

    CALL REDO.CHECK.APPLICATION(Y.ITEM.CODE,APPL.NAME,APPL.PATH)
    DUP.APPL.NAME = APPL.NAME
    DUP.APPL.PATH = APPL.PATH

    CALL OPF(APPL.NAME,APPL.PATH)
    GOSUB SUB.PROCESS

    Y.LIST.ITM = R.REDO.ITEM.STOCK<ITEM.REG.ITEM.CODE>
    Y.REJ.VAL = R.NEW(RE.ORD.CANCEL.QUANTITY)
    LOCATE Y.ITEM.CODE IN Y.LIST.ITM<1,1> SETTING POS THEN
        R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> = R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> - Y.REJ.VAL
    END
    CALL F.WRITE(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK)
    GOSUB UPD.ITEM.STOCK.RPT
    RETURN
*-------------------------------
SUB.PROCESS:
*-------------------------------
    Y.CNT.TOT = DCOUNT(R.REDO.ITEM.SERIES,FM)
    Y.SERIES.LIST.DUP = FIELDS(R.REDO.ITEM.SERIES,'*',1,1)
    Y.STATUS.LIST.DUP = FIELDS(R.REDO.ITEM.SERIES,'*',2,1)
    Y.BATCH.LIST.DUP = FIELDS(R.REDO.ITEM.SERIES,'*',3,1)
    LOOP
    WHILE Y.CNT LE SEQ.COUNT DO
        Y.SEQ.FROM = R.NEW(RE.ORD.SERIES.FROM)<1,Y.CNT>
        Y.SEQ.TO = R.NEW(RE.ORD.SERIES.TO)<1,Y.CNT>
        LEN.SEQ = LEN(Y.SEQ.FROM)       ;*PACS00643734
        LOOP
        WHILE Y.SEQ.FROM LE Y.SEQ.TO DO
		    Y.BATCH = ''   				;*PACS00643734
            GOSUB CASE.SEL.VALUE
            Y.SEQ.FROM += 1
            Y.SEQ.FROM = FMT(Y.SEQ.FROM, 'R%':LEN.SEQ)      ;*PACS00643734
        REPEAT
        Y.CNT += 1
    REPEAT
    CALL F.WRITE(FN.REDO.ITEM.SERIES,Y.ITEM.STOCK.RPT.ID,R.REDO.ITEM.SERIES)
    RETURN
*-------------------------------
DEPOSIT.RECEIPTS:
*-------------------------------
    
    LOCATE 'Asignada' IN R.REC<REDO.DEP.STATUS.CHG, 1> SETTING Y.DEP.REC.POS ELSE
        R.REC<REDO.DEP.STATUS.CHG,1> = 'Asignada'
        R.REC<REDO.DEP.STATUS.DATE,1> = R.REC<REDO.DEP.DATE.UPDATED>
    END
    R.REC<REDO.DEP.STATUS.CHG, -1> = 'Cancelada'
    R.REC<REDO.DEP.STATUS.DATE, -1> = TODAY

    R.REC<REDO.DEP.STATUS> = 'Cancelada'
    R.REC<REDO.DEP.INPUTTER> = INPUTTER
    R.REC<REDO.DEP.AUTHORISER> = AUTHORISER
    R.REC<REDO.DEP.DATE.UPDATED> = TODAY
    CALL F.WRITE(APPL.NAME,Y.BATCH,R.REC)

*    GOSUB UPDATE.RECEIPT.DETAILS

    RETURN
*-------------------------------
ADMIN.CHEQUES:
*-------------------------------
    
    R.REC<REDO.ADMIN.STATUS> = 'Cancelada'
    R.REC<REDO.ADMIN.INPUTTER> = INPUTTER
    R.REC<REDO.ADMIN.AUTHORISER> = AUTHORISER
    R.REC<REDO.ADMIN.DATE.UPDATED> = TODAY
    CALL F.WRITE(APPL.NAME,Y.BATCH,R.REC)
    RETURN
*-------------------------------
PASSBOOK.INVENTORY:
*-------------------------------
    
    LOCATE 'Asignada' IN R.REC<REDO.PASS.STATUS.CHG, 1> SETTING Y.DEP.REC.POS ELSE
        R.REC<REDO.PASS.STATUS.CHG,1> = 'Asignada'
        R.REC<REDO.PASS.STATUS.DATE,1> = R.REC<REDO.PASS.DATE.UPDATED>
    END

    R.REC<REDO.PASS.STATUS.CHG, -1> = 'Cancelada'
    R.REC<REDO.PASS.STATUS.DATE, -1> = TODAY

    R.REC<REDO.PASS.STATUS> = 'Cancelada'
    R.REC<REDO.PASS.INPUTTER> = INPUTTER
    R.REC<REDO.PASS.AUTHORISER> = AUTHORISER
    R.REC<REDO.PASS.DATE.UPDATED> = TODAY
    CALL F.WRITE(APPL.NAME,Y.BATCH,R.REC)

    RETURN
*-------------------------------
BANK.DRAFTS:
*-------------------------------
    
    R.REC<REDO.BANK.STATUS> = 'Cancelada'
    R.REC<REDO.BANK.INPUTTER> = INPUTTER
    R.REC<REDO.BANK.AUTHORISER> = AUTHORISER
    R.REC<REDO.BANK.DATE.UPDATED> = TODAY
    CALL F.WRITE(APPL.NAME,Y.BATCH,R.REC)
    RETURN
*-------------------------------
CASE.SEL.VALUE:
*-------------------------------
    
    R.REC = ''
    Y.SERIES.LIST.DUP.COUNT = DCOUNT(Y.SERIES.LIST.DUP,FM)  ;*PACS00643734
    LOOP
    UNTIL R.REC NE '' OR Y.SERIES.LIST.DUP.COUNT EQ '0'     ;*PACS00643734
        LOCATE Y.SEQ.FROM IN Y.SERIES.LIST.DUP SETTING POS.SER THEN
            Y.BATCH = Y.BATCH.LIST.DUP<POS.SER>
        END
        IF Y.BATCH THEN
            CALL F.READ(APPL.NAME,Y.BATCH,R.REC,APPL.PATH,Y.ERR)
            R.REDO.ITEM.SERIES<POS.SER> = ''
        END
        DEL Y.SERIES.LIST.DUP<POS.VAL>
        DEL Y.STATUS.LIST.DUP<POS.VAL>
        DEL Y.BATCH.LIST.DUP<POS.VAL>
        Y.SERIES.LIST.DUP.COUNT -= 1    ;*PACS00643734
    REPEAT


    BEGIN CASE
    CASE DUP.APPL.NAME EQ 'F.REDO.H.DEPOSIT.RECEIPTS'

        GOSUB DEPOSIT.RECEIPTS

    CASE DUP.APPL.NAME EQ 'F.REDO.H.BANK.DRAFTS'

        GOSUB BANK.DRAFTS

    CASE DUP.APPL.NAME EQ 'F.REDO.H.ADMIN.CHEQUES'

        GOSUB ADMIN.CHEQUES

    CASE DUP.APPL.NAME EQ 'F.REDO.H.PASSBOOK.INVENTORY'

        GOSUB PASSBOOK.INVENTORY

    END CASE
    RETURN
*-------------------------------
UPD.ITEM.STOCK.RPT:
*-------------------------------

    Y.DATE.RPT = R.NEW(RE.ORD.DATE)
    IF R.REDO.ITEM.STOCK.BY.DATE THEN
        LOCATE Y.DATE.RPT IN R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,1> SETTING POS.RPT THEN
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.CANCELLED,POS.RPT>            =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.CANCELLED,POS.RPT> +  R.NEW(RE.ORD.CANCEL.QUANTITY)
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT>           =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT> - R.NEW(RE.ORD.CANCEL.QUANTITY)

        END ELSE
            Y.DATE.COUNT1 = DCOUNT(R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE>,VM)
            Y.DATE.COUNT = Y.DATE.COUNT1 + 1

            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,Y.DATE.COUNT>                =   Y.DATE.RPT
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ITEM.CODE,Y.DATE.COUNT>           =   R.NEW(RE.ORD.ITEM.CODE)
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.INITIAL.STOCK,Y.DATE.COUNT>       =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT1>
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.CANCELLED,Y.DATE.COUNT>           =   R.NEW(RE.ORD.CANCEL.QUANTITY)
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT>           =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT1> - R.NEW(RE.ORD.CANCEL.QUANTITY)

        END
    END
    CALL F.WRITE(FN.REDO.ITEM.STOCK.BY.DATE,Y.ITEM.STOCK.RPT.ID,R.REDO.ITEM.STOCK.BY.DATE)

    RETURN
*-----------------------------------------------------------------------------------------
UPDATE.RECEIPT.DETAILS:
*----------------------

    IF R.REC<AZ.CH.DETS.CATEGORY> THEN  ;* UPdate the live table only for series record that are assigned to Deposits
        FN.REDO.L.SERIES.CHANGE.DETS = 'F.REDO.L.SERIES.CHANGE.DETS'
        F.REDO.L.SERIES.CHANGE.DETS = ''
        CALL OPF(FN.REDO.L.SERIES.CHANGE.DETS, F.REDO.L.SERIES.CHANGE.DETS)

        Y.SERIES.DET.ID = TODAY:'.':Y.BATCH
        R.SERIES.DETAILS = ''
        CALL F.READ(FN.REDO.L.SERIES.CHANGE.DETS, Y.SERIES.DET.ID, R.SERIES.DETAILS, F.REDO.L.SERIES.CHANGE.DETS, Y.READ.ERR)

        R.SERIES.DETAILS<AZ.CH.DETS.STATUS, -1> = 'Cancelada'

        CALL F.WRITE(FN.REDO.L.SERIES.CHANGE.DETS, Y.SERIES.DET.ID, R.SERIES.DETAILS)

* Update concat file for cancelled receipts

        FN.REDO.T.CANC.DEP.RECEIPTS = 'F.REDO.T.CANC.DEP.RECEIPTS'
        F.REDO.T.CANC.DEP.RECEIPTS = ''
        CALL OPF(FN.REDO.T.CANC.DEP.RECEIPTS, F.REDO.T.CANC.DEP.RECEIPTS)

        Y.TODAY = TODAY
        CALL CONCAT.FILE.UPDATE(FN.REDO.T.CANC.DEP.RECEIPTS, Y.TODAY, ID.NEW, 'I', 'AR' )
    END

    RETURN
*-----------------------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------------------
END
