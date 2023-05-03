$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,FM TO @FM
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.UPD.VAL.ITEM.VALUE
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEEVA T
* PROGRAM NAME: REDO.UPD.VAL.ITEM.VALUE
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION: This routine is used as call routine in REDO.VCR.CHEQUE.NUMBER, REDO.V.INP.DEFAULT.ACCT
*IN PARAMETER: NA
*OUT PARAMETER: NA
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*26-12-2011  Jeeva T           B.42             PACS00172267
*09-03-2012  Jeeva T           Reversal Handle
*08-08-2015  Maheswaran J       PACS00457562
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.USER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.ITEM.STOCK.BY.DATE
    $INSERT I_F.REDO.ITEM.STOCK
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.MANAGER.CHQ.PARAM

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB READ.FILE
        GOSUB MAIN.PROCESS
    END
RETURN
*----------------------------------------------------------------------
REVERSAL.PROCESS:
*----------------------------------------------------------------------
    CALL F.READ(FN.REDO.ITEM.SERIES,APPLICATION,R.REDO.ITEM.SERIES.APP1,F.REDO.ITEM.SERIES,Y.ERR.APP)
    Y.APP.LIST = FIELDS(R.REDO.ITEM.SERIES.APP1,"*",1,1)
    Y.INV.LIST = FIELDS(R.REDO.ITEM.SERIES.APP1,"*",2,1)
    LOCATE ID.NEW IN Y.APP.LIST SETTING POS.APP THEN
        DEL R.REDO.ITEM.SERIES.APP1<POS.APP>
        CALL F.WRITE(FN.REDO.ITEM.SERIES,APPLICATION,R.REDO.ITEM.SERIES.APP1)
        Y.ID.SERIES = Y.INV.LIST<POS.APP>
        GOSUB READ.FILE
        Y.LIST.ITM = R.REDO.ITEM.STOCK<ITEM.REG.ITEM.CODE>
        Y.ITEM.CODE = FIELD(Y.ID.SERIES,".",2)
        LOCATE Y.ITEM.CODE IN Y.LIST.ITM<1,1> SETTING POS THEN
            R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> = R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> + 1
        END
        CALL F.WRITE(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK)
        Y.DATE.RPT = TODAY
        IF R.REDO.ITEM.STOCK.BY.DATE THEN
            LOCATE Y.DATE.RPT IN R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,1> SETTING POS.RPT THEN
                R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,POS.RPT>            =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,POS.RPT> - 1
                R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT>           =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT> + 1
            END
            CALL F.WRITE(FN.REDO.ITEM.STOCK.BY.DATE,Y.ID.SERIES,R.REDO.ITEM.STOCK.BY.DATE)
        END
    END
    PROCESS.GOAHEAD = ''
RETURN
*----------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*----------------------------------------------------------------------
    IF V$FUNCTION EQ "D" THEN
        GOSUB REVERSAL.PROCESS
    END
    IF V$FUNCTION EQ "R" THEN
*PACS00457562 added reversed transaction's cheques to cancelled list
        CALL F.READU(FN.REDO.ITEM.STOCK.BY.DATE,Y.ID.SERIES,R.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE,Y.ERR.FLA,'')
        PROCESS.GOAHEAD = ''
        Y.DATE.RPT = TODAY
        IF R.REDO.ITEM.STOCK.BY.DATE THEN
            LOCATE Y.DATE.RPT IN R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,1> SETTING POS.RPT THEN
                R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.CANCELLED,POS.RPT> =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.CANCELLED,POS.RPT> + 1
            END
            CALL F.WRITE(FN.REDO.ITEM.STOCK.BY.DATE,Y.ID.SERIES,R.REDO.ITEM.STOCK.BY.DATE)
        END
    END
RETURN
*----------------------------------------------------------------------
MAIN.PROCESS:
*----------------------------------------------------------------------
    IF Y.OFS.VAL EQ 'PROCESS' THEN
        GOSUB PROCESS
    END

RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    BEGIN CASE

        CASE APPLICATION EQ 'TELLER'
            Y.CHEQUE.VALUE = R.NEW(TT.TE.CHEQUE.NUMBER)

            IF R.NEW(TT.TE.DR.CR.MARKER) EQ "DEBIT" THEN
                W.ACCOUNT1 = R.NEW(TT.TE.ACCOUNT.2)
                W.ACCOUNT2 = R.NEW(TT.TE.ACCOUNT.1)
            END ELSE
                W.ACCOUNT1 = R.NEW(TT.TE.ACCOUNT.1)
                W.ACCOUNT2 = R.NEW(TT.TE.ACCOUNT.2)
            END
            Y.ACCOUNT = W.ACCOUNT1
            Y.CUST    = ""
            IF Y.ACCOUNT THEN
                CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
                IF R.ACCOUNT THEN
                    Y.CUST = R.ACCOUNT<AC.CUSTOMER>
                END
            END

        CASE APPLICATION EQ 'FUNDS.TRANSFER'

            Y.CHEQUE.VALUE = R.NEW(FT.CREDIT.THEIR.REF)

            Y.ACCOUNT = R.NEW(FT.CREDIT.ACCT.NO)

    END CASE

    FN.REDO.ITEM.STOCK.BY.DATE = 'F.REDO.ITEM.STOCK.BY.DATE'
    F.REDO.ITEM.STOCK.BY.DATE = ''

    FN.REDO.ITEM.SERIES = 'F.REDO.ITEM.SERIES'
    F.REDO.ITEM.SERIES = ''

    FN.REDO.ITEM.STOCK = 'F.REDO.ITEM.STOCK'
    F.REDO.ITEM.STOCK = ''

    FN.REDO.ADMIN.CHQ.PARAM = 'F.REDO.ADMIN.CHQ.PARAM'
    F.REDO.ADMIN.CHQ.PARAM = ''

    FN.REDO.MANAGER.CHQ.PARAM = 'F.REDO.MANAGER.CHQ.PARAM'
    F.REDO.MANAGER.CHQ.PARAM = ''

    R.REDO.ITEM.STOCK = ''
    R.REDO.ITEM.SERIES = ''
    R.REDO.ITEM.STOCK.BY.DATE= ''
    R.REDO.ITEM.SERIES.APP   = ''
    Y.ITEM.CODE = ''

    Y.OFS.OVER = ''
    Y.OFS.VAL = OFS$OPERATION
    Y.OFS.OVER = OFS$OVERRIDES
    Y.ACCPT.OVERRIDE = ''
    IF Y.OFS.OVER THEN
        Y.ACCPT.OVERRIDE = Y.OFS.OVER<2,1>
    END
    PROCESS.GOAHEAD = 1

    APP.LIST = 'FUNDS.TRANSFER':@FM:'USER' ;*R22 AUTO CONVERSION
    WCAMPO    = "TRANSACTION.REF":@FM:'L.US.IDC.BR':@VM:'L.US.IDC.CODE' ;*R22 AUTO CONVERSION
    YPOS     = ''
    CALL MULTI.GET.LOC.REF(APP.LIST,WCAMPO,YPOS)
    TR.REF.POS    = YPOS<1,1>
    Y.BRANCH.POS = YPOS<2,1>
    Y.DEPT.POS   = YPOS<2,2>
    Y.PARAM.ID = 'SYSTEM'
*This part to check manager cheque parameter
    CALL CACHE.READ(FN.REDO.MANAGER.CHQ.PARAM,Y.PARAM.ID,R.REDO.MANAGER.CHQ.PARAM,MGR.PARAM.ERR)

    LOCATE Y.ACCOUNT IN R.REDO.MANAGER.CHQ.PARAM<MAN.CHQ.PRM.ACCOUNT,1> SETTING POS1 THEN
        Y.ITEM.CODE = R.REDO.MANAGER.CHQ.PARAM<MAN.CHQ.PRM.ITEM.CODE,POS1>
    END
*This part to check admin cheque parameter
    IF NOT(Y.ITEM.CODE) THEN
        CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,Y.PARAM.ID,R.REDO.ADMIN.CHQ.PARAM,PARAM.ERR)
        IF (Y.CUST OR NOT(Y.ACCOUNT)) AND (APPLICATION EQ 'TELLER') THEN
            Y.ACCOUNT = W.ACCOUNT2
        END

        LOCATE Y.ACCOUNT IN R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT,1> SETTING POS1 THEN
            Y.ITEM.CODE = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ITEM.CODE,POS1>
        END

    END

    Y.BRANCH.LIST = R.USER<EB.USE.LOCAL.REF,Y.BRANCH.POS>
    Y.DEPT.LIST   = R.USER<EB.USE.LOCAL.REF,Y.DEPT.POS>
    LOCATE ID.COMPANY IN Y.BRANCH.LIST<1,1,1> SETTING POS.BR THEN
        Y.CODE.VAL = Y.DEPT.LIST<1,1,POS.BR>
    END ELSE
        Y.CODE.VAL = ''
    END
    IF Y.CODE.VAL THEN
        Y.STOCK.ID = ID.COMPANY:"-":Y.CODE.VAL:".":Y.ITEM.CODE
    END ELSE
        Y.STOCK.ID = ID.COMPANY:".":Y.ITEM.CODE
    END
    Y.ID.SERIES = Y.STOCK.ID
RETURN

*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
    CALL OPF(FN.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK)
    CALL OPF(FN.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES)
    CALL OPF(FN.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE)
    CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)
    CALL OPF(FN.REDO.MANAGER.CHQ.PARAM,F.REDO.MANAGER.CHQ.PARAM)

RETURN
*----------------------------------------------------------------------
READ.FILE:
*----------------------------------------------------------------------
    Y.ITEM.STOCK.ID = FIELD(Y.ID.SERIES,".",1)
    CALL F.READU(FN.REDO.ITEM.SERIES,Y.ID.SERIES,R.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES,Y.ERR,'')
    CALL F.READU(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK,Y.ERR.ST,'')
    CALL F.READU(FN.REDO.ITEM.STOCK.BY.DATE,Y.ID.SERIES,R.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE,Y.ERR.FLA,'')
    CALL F.READU(FN.REDO.ITEM.SERIES,APPLICATION,R.REDO.ITEM.SERIES.APP,F.REDO.ITEM.SERIES,Y.ERR.APP,'')
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
    IF Y.CHEQUE.VALUE THEN
        Y.SERIES.LIST = FIELDS(R.REDO.ITEM.SERIES,"*",1,1)
        Y.ADMIN.ID = FIELDS(R.REDO.ITEM.SERIES,"*",3,1)
        LOCATE Y.CHEQUE.VALUE IN Y.SERIES.LIST SETTING POS THEN
            DEL R.REDO.ITEM.SERIES<POS>
            CALL F.WRITE(FN.REDO.ITEM.SERIES,Y.ID.SERIES,R.REDO.ITEM.SERIES)
        END
        GOSUB INV.STOCK.UPDT.VAL
        GOSUB INV.STOCK.UPDT
        R.REDO.ITEM.SERIES.APP<-1> = ID.NEW:"*":Y.ID.SERIES:"*":Y.ADMIN.ID<POS>
        CALL F.WRITE(FN.REDO.ITEM.SERIES,APPLICATION,R.REDO.ITEM.SERIES.APP)

    END
RETURN
*-------------------------------------------------------------------------------------
INV.STOCK.UPDT:
*-------------------------------------------------------------------------------------
    IF R.REDO.ITEM.STOCK THEN
        Y.LIST.ITM = R.REDO.ITEM.STOCK<ITEM.REG.ITEM.CODE>

        LOCATE Y.ITEM.CODE IN Y.LIST.ITM<1,1> SETTING POS THEN
            R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> = R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> - 1
            IF R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> GT 0 THEN
                CALL F.WRITE(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK)
            END
        END
    END
RETURN
*----------------------------------------------------------------------
INV.STOCK.UPDT.VAL:
*----------------------------------------------------------------------
    Y.DATE.RPT = TODAY
    IF R.REDO.ITEM.STOCK.BY.DATE THEN
        LOCATE Y.DATE.RPT IN R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,1> SETTING POS.RPT THEN
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,POS.RPT>            =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,POS.RPT> + 1
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT>           =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT> - 1
        END ELSE
            Y.DATE.COUNT1 = DCOUNT(R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE>,@VM) ;*R22 AUTO CONVERSION
            Y.DATE.COUNT = Y.DATE.COUNT1 + 1

            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,Y.DATE.COUNT>                = Y.DATE.RPT
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ITEM.CODE,Y.DATE.COUNT>           = Y.ITEM.CODE
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.INITIAL.STOCK,Y.DATE.COUNT>       = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT1>
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,Y.DATE.COUNT>            = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,Y.DATE.COUNT> + 1
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT>           = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT1> - 1
        END
        CALL F.WRITE(FN.REDO.ITEM.STOCK.BY.DATE,Y.ID.SERIES,R.REDO.ITEM.STOCK.BY.DATE)
    END
RETURN
END