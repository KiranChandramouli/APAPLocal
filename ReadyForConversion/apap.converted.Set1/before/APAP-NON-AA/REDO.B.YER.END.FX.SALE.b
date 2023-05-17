*-----------------------------------------------------------------------------
* <Rating>-95</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.YER.END.FX.SALE(FX.CCY.ID)
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description:
*-------------------------------------------------------------------------------
* Modification History
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00375392          Ashokkumar.V.P                  16/12/2014           Rewritten the routine based on mapping
* PACS00375392          Ashokkumar.V.P                  26/02/2015           Modified to show the blind  multi currency total, insead of local equivalent
* PACS00375392          Ashokkumar.V.P                  06/03/2015           Changed the CCY orgin and Recd column
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    $INSERT I_F.CUSTOMER
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT TAM.BP I_F.REDO.FX.CCY.POSN
    $INSERT TAM.BP I_REDO.B.YER.END.FX.SALE.COMMON
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
*
    GOSUB PROCESS.PARA
    RETURN
*---------------------------------------------------------------------------------------
PROCESS.PARA:
***************
    R.REDO.FX.CCY.POSN = ''; FX.CCY.ERR = ''; DOC.TYPE.LIST = ''; Y.FIELD.NAME = ''; CUR.LIST = ''
    CALL F.READ(FN.REDO.FX.CCY.POSN,FX.CCY.ID,R.REDO.FX.CCY.POSN,F.REDO.FX.CCY.POSN,FX.CCY.ERR)
    IF NOT(R.REDO.FX.CCY.POSN) THEN
        RETURN
    END
    Y.FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    Y.FIELD.NAME = CHANGE(Y.FIELD.NAME,VM,FM)
    LOCATE 'DOC.SEL.CODE' IN Y.FIELD.NAME SETTING DT.POS THEN
        DOC.TYPE.LIST = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,DT.POS>
        DOC.TYPE.LIST = CHANGE(DOC.TYPE.LIST,SM,FM)
    END
    LOCATE 'CUR.SEL.CODE' IN Y.FIELD.NAME SETTING CUR.POS THEN
        CUR.LIST = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,CUR.POS>
        CUR.LIST = CHANGE(CUR.LIST,SM,FM)
    END

    TXN.REFS = R.REDO.FX.CCY.POSN<REDO.FX.CCY.TXN.REF>
    LOOP
        REMOVE TXN.ID FROM TXN.REFS SETTING TXN.POS
    WHILE TXN.ID:TXN.POS
        RET.FLG = 0
        Y.BUY.POS = R.REDO.FX.CCY.POSN<REDO.FX.TXN.BUY.POS,1,TXN.POS>

        C$SPARE(451) = ''; C$SPARE(452) = ''; C$SPARE(453) = ''; C$SPARE(454) = ''
        C$SPARE(455) = ''; C$SPARE(456) = ''; C$SPARE(457) = ''; C$SPARE(458) = ''
        Y.CCY.BOUGHT = ''; Y.CCY.SOLD = ''

        IF TXN.ID[1,2] EQ 'TT' THEN
            GOSUB MVMT.TT
        END
        IF TXN.ID[1,2] EQ 'FT' THEN
            GOSUB MVMT.FT
        END
        IF TXN.ID[1,2] EQ 'FX' THEN
            GOSUB MVMT.FX
        END

        IF RET.FLG EQ 1 THEN
            CONTINUE
        END
        GOSUB MAP.RCL.RECORD
    REPEAT
    RETURN

MVMT.FX:
*-------
    R.FOREX = ''; ERR.FOREX = ''; ERRH.FOREX = ''; YLEG.DEF = ''; YREC.STATUS = ''; YLEG.VAL = ''
    Y.NATION = ''; CUSTOMER.ID = ''; CUST.ID = ''; CUST.IDEN = ''; YLEG.TYPE = ''; YLCY.EQU.AMT = ''
    ID.TYPE = ''; YVAL.DATE = ''; YDEAL.TYPE = ''; Y.RATE = ''; Y.AMT.SOLD = ''
    CALL F.READ(FN.FOREX,TXN.ID,R.FOREX,F.FOREX,ERR.FOREX)
    IF NOT(R.FOREX) THEN
        TXN.ID.HST = TXN.ID
        CALL EB.READ.HISTORY.REC(F.FOREX.HST,TXN.ID.HST,R.FOREX,ERRH.FOREX)
    END
    YREC.STATUS = R.FOREX<FX.RECORD.STATUS>
    Y.CCY.BOUGHT = R.FOREX<FX.CURRENCY.BOUGHT>
    Y.CCY.SOLD = R.FOREX<FX.CURRENCY.SOLD>
    IF NOT(R.FOREX) OR YREC.STATUS EQ 'REVE' OR Y.CCY.SOLD EQ LCCY THEN
        RET.FLG = 1
        RETURN
    END
    YVAL.DATE = R.FOREX<FX.VALUE.DATE.SELL>
    YDEAL.TYPE = R.FOREX<FX.DEAL.TYPE>
    CUSTOMER.ID = R.FOREX<FX.COUNTERPARTY>
    GOSUB READ.CUSTOMER
    YLEG.VAL = R.FOREX<FX.LOCAL.REF,L.FX.LEGAL.ID.POS>
    CUST.NAME = FIELD(YLEG.VAL,'.',3)
    GOSUB GET.CUST.ID
    C$SPARE(453) = CUST.NAME
    C$SPARE(454) = YVAL.DATE

    GOSUB EXCH.RECVD.ORIG
    IF YDEAL.TYPE EQ 'SP' THEN
        Y.RATE = R.FOREX<FX.SPOT.RATE>
    END ELSE
        Y.RATE = R.FOREX<FX.FORWARD.RATE>
    END
    C$SPARE(457) = Y.RATE

    Y.AMT.SOLD = R.FOREX<FX.AMOUNT.SOLD>
    C$SPARE(458) = Y.AMT.SOLD
    YAPP = FN.FOREX
    R.YAPP = R.FOREX
*    YLCY.EQU.AMT = R.FOREX<FX.SEL.LCY.EQUIV>
    YLCY.EQU.AMT = Y.AMT.SOLD
    RETURN

MVMT.FT:
*********
    YLEG.DEF = ''; YREC.STATUS = ''; YVAL.DATE = ''; YLEG.VAL = ''; CUST.NAME = ''; YLCY.EQU.AMT = ''
    Y.RATE = ''; Y.AMT.SOLD = ''; R.FT = ''; FUNDS.TRANSFER.ERR = ''; FUNDS.TRANSFER.HERR = ''
    CALL F.READ(FN.FUNDS.TRANSFER,TXN.ID,R.FT,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ERR)
    IF NOT(R.FT) THEN
        FT.ID.HST = TXN.ID
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HST,FT.ID.HST,R.FT,FUNDS.TRANSFER.HERR)
    END
    YREC.STATUS = R.FT<FT.RECORD.STATUS>
    Y.CCY.SOLD = R.FT<FT.DEBIT.CURRENCY>
    Y.CCY.BOUGHT = R.FT<FT.CREDIT.CURRENCY>

    IF NOT(R.FT) OR YREC.STATUS EQ 'REVE' OR Y.CCY.SOLD EQ LCCY OR Y.CCY.SOLD EQ Y.CCY.BOUGHT THEN
        RET.FLG = 1
        RETURN
    END

    YVAL.DATE = R.FT<FT.PROCESSING.DATE>
    CUSTOMER.ID = R.FT<FT.DEBIT.CUSTOMER>
    GOSUB READ.CUSTOMER

    YLEG.VAL = R.FT<FT.LOCAL.REF,L.FT.LEGAL.ID.POS>
    CUST.NAME = FIELD(YLEG.VAL,'.',3)
    C$SPARE(453) = CUST.NAME
    C$SPARE(454) = YVAL.DATE
    GOSUB GET.CUST.ID
    GOSUB EXCH.RECVD.ORIG
    Y.RATE = R.FT<FT.TREASURY.RATE>
    C$SPARE(457) = Y.RATE
    Y.AMT.SOLD = R.FT<FT.AMOUNT.DEBITED>[4,99]
    C$SPARE(458) = Y.AMT.SOLD
    YAPP = FN.FUNDS.TRANSFER
    R.YAPP = R.FT
*    YLCY.EQU.AMT = R.FT<FT.LOC.AMT.DEBITED>
    YLCY.EQU.AMT = Y.AMT.SOLD
    RETURN

MVMT.TT:
*********
    YLEG.DEF = ''; YREC.STATUS = ''; YVAL.DATE = ''; YLEG.VAL = ''; CUST.NAME = ''; Y.CCY.SOLD = ''
    Y.RATE = ''; Y.AMT.SOLD = ''; R.TT = ''; TELLER.ERR = ''; TELLER.HERR = ''; YMARKER = ''; YLCY.EQU.AMT = ''
    CALL F.READ(FN.TELLER,TXN.ID,R.TT,F.TELLER,TELLER.ERR)
    IF NOT(R.TT) THEN
        TXN.ID.HST = TXN.ID
        CALL EB.READ.HISTORY.REC(F.TELLER.HST,TXN.ID.HST,R.TT,TELLER.HERR)
    END

    YREC.STATUS = R.TT<TT.TE.RECORD.STATUS>
    YMARKER = R.TT<TT.TE.DR.CR.MARKER>
    IF YMARKER EQ 'DEBIT' THEN
        Y.CCY.SOLD = R.TT<TT.TE.CURRENCY.1>
        Y.CCY.BOUGHT = R.TT<TT.TE.CURRENCY.2>
        Y.AMT.SOLD = R.TT<TT.TE.AMOUNT.FCY.1>
        CUSTOMER.ID = R.TT<TT.TE.CUSTOMER.1>
        YVAL.DATE = R.TT<TT.TE.VALUE.DATE.1>
*        YLCY.EQU.AMT = R.TT<TT.TE.AMOUNT.LOCAL.1>
        YLCY.EQU.AMT = Y.AMT.SOLD
    END ELSE
        Y.CCY.SOLD = R.TT<TT.TE.CURRENCY.2>
        Y.CCY.BOUGHT = R.TT<TT.TE.CURRENCY.1>
        Y.AMT.SOLD = R.TT<TT.TE.AMOUNT.FCY.2>
        CUSTOMER.ID = R.TT<TT.TE.CUSTOMER.2>
        YVAL.DATE = R.TT<TT.TE.VALUE.DATE.2>
*        YLCY.EQU.AMT = R.TT<TT.TE.AMOUNT.LOCAL.2>
        YLCY.EQU.AMT = Y.AMT.SOLD
    END

    IF NOT(R.TT) OR YREC.STATUS EQ 'REVE' OR Y.CCY.SOLD EQ Y.CCY.BOUGHT OR Y.CCY.SOLD EQ LCCY THEN
        RET.FLG = 1
        RETURN
    END

    GOSUB READ.CUSTOMER
    YLEG.VAL = R.TT<TT.TE.LOCAL.REF,L.TT.LEGAL.ID.POS>
    CUST.NAME = FIELD(YLEG.VAL,'.',3)
    C$SPARE(453) = CUST.NAME
    C$SPARE(454) = YVAL.DATE
    GOSUB GET.CUST.ID
    GOSUB EXCH.RECVD.ORIG

    Y.RATE = R.TT<TT.TE.DEAL.RATE>
    C$SPARE(457) = Y.RATE
    C$SPARE(458) = Y.AMT.SOLD
    YAPP = FN.TELLER
    R.YAPP = R.TT
    RETURN

GET.CUST.ID:
************
    YLEG.TYPE = FIELD(YLEG.VAL,'.',1)
    BEGIN CASE
    CASE YLEG.TYPE EQ 'CEDULA'
        CUST.IDEN = FIELD(YLEG.VAL,'.',2)
    CASE YLEG.TYPE EQ 'RNC'
        CUST.IDEN = FIELD(YLEG.VAL,'.',2)
    CASE YLEG.TYPE EQ 'PASAPORTE'
        IF NOT(Y.NATION) THEN
            Y.NATION = FIELD(YLEG.VAL,".",4)
        END
        CUST.IDEN = Y.NATION:FIELD(YLEG.VAL,'.',2)
    END CASE
    C$SPARE(451) = CUST.IDEN

    LOCATE YLEG.TYPE IN DOC.TYPE.LIST SETTING DT1.POS THEN
        ID.TYPE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,DT.POS,DT1.POS>
    END
    C$SPARE(452) = ID.TYPE
    RETURN

EXCH.RECVD.ORIG:
****************
    FCY.EXCH.ORIG = ''; FCY.EXCH.RECVD = ''
    LOCATE Y.CCY.BOUGHT IN CUR.LIST SETTING CUR1.POS THEN
        FCY.EXCH.ORIG = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT><1,CUR.POS,CUR1.POS>
    END
    LOCATE Y.CCY.SOLD IN CUR.LIST SETTING CUR2.POS THEN
        FCY.EXCH.RECVD = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT><1,CUR.POS,CUR2.POS>
    END
    C$SPARE(455) = FCY.EXCH.ORIG
    C$SPARE(456) = FCY.EXCH.RECVD
    RETURN

READ.CUSTOMER:
**************
    R.CUSTOMER = ''; CUS.ERR = ''; Y.NATION = ''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF NOT(CUS.ERR) THEN
        Y.NATION = R.CUSTOMER<EB.CUS.NATIONALITY>
    END
    RETURN

MAP.RCL.RECORD:
*--------------
    IF YLCY.EQU.AMT[1,1] EQ '-' THEN
        YLCY.EQU.AMT = YLCY.EQU.AMT * (-1)
    END

    MAP.FMT = 'MAP'
    ID.RCON.L = BATCH.DETAILS<3,1,2>
    APP = YAPP
    ID.APP = TXN.ID
    R.APP = R.YAPP
    CALL RAD.CONDUIT.LINEAR.TRANSLATION (MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    OUT.ARRAY = R.RETURN.MSG:"*":YLCY.EQU.AMT
    GOSUB WRITE.TO.FILE
    RETURN

WRITE.TO.FILE:
*--------------
    WRITESEQ OUT.ARRAY APPEND TO SEQ.PTR ELSE
        ERR.MSG = "Unable to write to ":SEQ.PTR
        INT.CODE = "RGN20"
        INT.TYPE = "ONLINE"
        MON.TP = "02"
        REC.CON = "RGN21-":ERR.MSG
        DESC = "RGN21-":ERR.MSG
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END
    RETURN
*--------------------------------------------------------------------------
END
