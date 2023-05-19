* @ValidationCode : MjoyMDE5OTc3NTMzOkNwMTI1MjoxNjg0MzI5MDc2NDY1OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 May 2023 18:41:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.B.M.FX.REPORT.PROG(FX.CCY.ID)
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      : Nirmal.P
* Reference         :
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
*--------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*---------------------------------------------------------------------------------------------
* PACS00375391          Ashokkumar.V.P                  16/12/2014           Rewritten the routine based on mapping
* PACS00375391          Ashokkumar.V.P                  26/02/2015           Modified to show the blind  multi currency total, insead of local equivalent
* PACS00375391          Ashokkumar.V.P                  06/03/2015           Changed the CCY orgin and Recd column
* PACS00375391          Ashokkumar.V.P                  12/03/2015           Reversed the CCY orgin and Recd column changes.
** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - CALL RTN FORMAT MODIFIED
*----------------------------------------------------------------------------------------------

    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.FOREX ;* R22 Auto conversion
    $INSERT I_F.CUSTOMER ;* R22 Auto conversion
    $INSERT I_F.TELLER ;* R22 Auto conversion
    $INSERT I_F.FUNDS.TRANSFER ;* R22 Auto conversion
    $INSERT I_F.REDO.FX.CCY.POSN ;* R22 Auto conversion
    $INSERT I_REDO.B.M.FX.REPORT.PROG.COMMON ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_F.ACCOUNT ;* R22 Auto conversion
    $USING APAP.REDOCHNLS
*
    GOSUB PROCESS.PARA
RETURN
*---------------------------------------------------------------------------------------------
PROCESS.PARA:
***************
    R.REDO.FX.CCY.POSN = ''; FX.CCY.ERR = ''; DOC.TYPE.LIST = ''; Y.FIELD.NAME = ''; CUR.LIST = ''
    CALL F.READ(FN.REDO.FX.CCY.POSN,FX.CCY.ID,R.REDO.FX.CCY.POSN,F.REDO.FX.CCY.POSN,FX.CCY.ERR)
    IF NOT(R.REDO.FX.CCY.POSN) THEN
        RETURN
    END

    Y.FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    Y.FIELD.NAME = CHANGE(Y.FIELD.NAME,@VM,@FM)

    LOCATE 'DOC.SEL.CODE' IN Y.FIELD.NAME SETTING DT.POS THEN
        DOC.TYPE.LIST = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,DT.POS>
        DOC.TYPE.LIST = CHANGE(DOC.TYPE.LIST,@SM,@FM)
    END

    LOCATE 'CUR.SEL.CODE' IN Y.FIELD.NAME SETTING CUR.POS THEN
        CUR.LIST = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,CUR.POS>
        CUR.LIST = CHANGE(CUR.LIST,@SM,@FM)
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
*CONTINUE
        END

        IF TXN.ID[1,2] EQ 'FT' THEN
            GOSUB MVMT.FT
        END

        IF TXN.ID[1,2] EQ 'FX' THEN
            GOSUB MVMT.FX
*CONTINUE
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
    ID.TYPE = ''; YVAL.DATE = ''; YDEAL.TYPE = ''; Y.RATE = ''; Y.AMT.BOUGHT = ''
    CALL F.READ(FN.FOREX,TXN.ID,R.FOREX,F.FOREX,ERR.FOREX)
    IF NOT(R.FOREX) THEN
        TXN.ID.HST = TXN.ID
        CALL EB.READ.HISTORY.REC(F.FOREX.HST,TXN.ID.HST,R.FOREX,ERRH.FOREX)
    END
    YREC.STATUS = R.FOREX<FX.RECORD.STATUS>
    Y.CCY.BOUGHT = R.FOREX<FX.CURRENCY.BOUGHT>
    IF NOT(R.FOREX) OR YREC.STATUS EQ 'REVE' OR Y.CCY.BOUGHT EQ LCCY THEN
        RET.FLG = 1
        RETURN
    END
    YVAL.DATE = R.FOREX<FX.VALUE.DATE.BUY>
    YDEAL.TYPE = R.FOREX<FX.DEAL.TYPE>
    CUSTOMER.ID = R.FOREX<FX.COUNTERPARTY>
    GOSUB READ.CUSTOMER
    YLEG.VAL = R.FOREX<FX.LOCAL.REF,L.FX.LEGAL.ID.POS>
    CUST.NAME = FIELD(YLEG.VAL,'.',3)
    GOSUB GET.CUST.ID
    C$SPARE(453) = CUST.NAME
    C$SPARE(454) = YVAL.DATE
    Y.CCY.SOLD = R.FOREX<FX.CURRENCY.SOLD>
    GOSUB EXCH.RECVD.ORIG

    IF YDEAL.TYPE EQ 'SP' THEN
        Y.RATE = R.FOREX<FX.SPOT.RATE>
    END ELSE
        Y.RATE = R.FOREX<FX.FORWARD.RATE>
    END
    C$SPARE(457) = Y.RATE

    Y.AMT.BOUGHT = R.FOREX<FX.AMOUNT.BOUGHT>
    C$SPARE(458) = Y.AMT.BOUGHT
    YAPP = FN.FOREX
    R.YAPP = R.FOREX
*   YLCY.EQU.AMT = R.FOREX<FX.BUY.LCY.EQUIV>
    YLCY.EQU.AMT = Y.AMT.BOUGHT
RETURN

MVMT.FT:
*********
    YLEG.DEF = ''; YREC.STATUS = ''; YVAL.DATE = ''; YLEG.VAL = ''; CUST.NAME = ''; YLCY.EQU.AMT = ''
    Y.RATE = ''; Y.AMT.BOUGHT = ''; R.FT = ''; FUNDS.TRANSFER.ERR = ''; FUNDS.TRANSFER.HERR = ''
    FT.ID.HST = ''; R.FT_2 = ''

    CALL F.READ(FN.FUNDS.TRANSFER,TXN.ID,R.FT,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ERR)
    IF NOT(R.FT) THEN
        FT.ID.HST = TXN.ID
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HST,FT.ID.HST,R.FT,FUNDS.TRANSFER.HERR)
    END
    YREC.STATUS = R.FT<FT.RECORD.STATUS>
    Y.CCY.SOLD = R.FT<FT.DEBIT.CURRENCY>
    Y.CCY.BOUGHT = R.FT<FT.CREDIT.CURRENCY>

    IF NOT(R.FT) OR YREC.STATUS EQ 'REVE' OR Y.CCY.BOUGHT EQ LCCY OR Y.CCY.SOLD EQ Y.CCY.BOUGHT THEN
        RET.FLG = 1
        RETURN
    END

    YVAL.DATE = R.FT<FT.PROCESSING.DATE>
    CUSTOMER.ID = R.FT<FT.CREDIT.CUSTOMER>

    IF NOT(CUSTOMER.ID) OR CUSTOMER.ID EQ '' THEN
        CALL GET.LOC.REF("FUNDS.TRANSFER", "L.FT.CLIENT.COD",L.FT.CLIENT.COD.POS)
        Y.L.FT.CLIENT.COD = R.FT<FT.LOCAL.REF,L.FT.CLIENT.COD.POS>
        CUSTOMER.ID = Y.L.FT.CLIENT.COD
    END

    GOSUB READ.CUSTOMER

    YLEG.VAL = R.FT<FT.LOCAL.REF,L.FT.LEGAL.ID.POS>

*--TODO
*--Evaluo si L.FT.LEGAL.ID no tiene valor y lo cambio por la transaccion que genero esta  --TODO
    IF NOT(YLEG.VAL) OR YLEG.VAL EQ '' THEN
*--Poner Donde Va
        CALL GET.LOC.REF("FUNDS.TRANSFER", "L.FT.CLIENT.NME",L.FT.CLIENT.NME.POS)
        Y.L.FT.CLIENT.NME = R.FT<FT.LOCAL.REF,L.FT.CLIENT.NME.POS>

        IF NOT(Y.L.FT.CLIENT.NME) OR Y.L.FT.CLIENT.NME EQ '' THEN
*--Todo
            IF R.FT<FT.CREDIT.THEIR.REF> NE '' THEN
                IF NOT(FT.ID.HST) THEN
                    CALL F.READ(FN.FUNDS.TRANSFER,R.FT<FT.CREDIT.THEIR.REF>,R.FT_2,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ERR)
                END ELSE
                    CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HST,R.FT<FT.CREDIT.THEIR.REF>,R.FT_2,FUNDS.TRANSFER.HERR)
                END

*--Evaluar aqui que hacer
                IF NOT(R.FT_2) THEN
*--TODO
                    Y.DEBIT.CUSTOMER = ''

                    Y.DEBIT.CUSTOMER = R.FT<FT.DEBIT.CUSTOMER>
                    GOSUB SET.CUST.NAME.FT

                    IF NOT(CUST.NAME) OR CUST.NAME EQ '' THEN
                        GOSUB SET.NAME.RNC.CUSTOMER
                    END
*--TODO

                END ELSE
                    YLEG.VAL = R.FT_2<FT.LOCAL.REF,L.FT.LEGAL.ID.POS>

                    IF NOT(YLEG.VAL) OR YLEG.VAL EQ '' THEN
*--Evaluar aqui que hacer
                        Y.DEBIT.CUSTOMER = ''
                        Y.DEBIT.CUSTOMER = R.FT<FT.DEBIT.CUSTOMER>
                        GOSUB SET.CUST.NAME.FT

                        IF NOT(CUST.NAME) OR CUST.NAME EQ '' THEN
                            GOSUB SET.NAME.RNC.CUSTOMER
                        END
*--TODO
                    END ELSE
                        CUST.NAME = FIELD(YLEG.VAL,'.',3)
                    END
                END
            END ELSE
*--Evaluar aqui que hacer
                Y.DEBIT.CUSTOMER = ''
                Y.DEBIT.CUSTOMER = R.FT<FT.DEBIT.CUSTOMER>
                GOSUB SET.CUST.NAME.FT

                IF NOT(CUST.NAME) OR CUST.NAME EQ '' THEN
                    GOSUB SET.NAME.RNC.CUSTOMER
                END
*--TODO
            END

            IF NOT(CUST.NAME) OR CUST.NAME EQ '' THEN
                GOSUB IS.APAP.ACCOUNT.FT

                IF NOT(CUST.NAME) OR CUST.NAME EQ '' THEN
                    CUST.NAME = TXN.ID : " Error "
                END
            END

*--Todo
        END ELSE
            CUST.NAME =  Y.L.FT.CLIENT.NME
        END
    END ELSE
        CUST.NAME = FIELD(YLEG.VAL,'.',3)
    END
*--TODO

*CUST.NAME = FIELD(YLEG.VAL,'.',3)
    C$SPARE(453) = CUST.NAME
    C$SPARE(454) = YVAL.DATE
    GOSUB GET.CUST.ID

*--TODO
    IF NOT(CUST.IDEN) OR CUST.IDEN EQ '' OR CUST.IDEN EQ 0 THEN
        GOSUB GET.CUST.IDENT.FT

        IF NOT(CUST.IDEN) OR CUST.IDEN EQ '' OR CUST.IDEN EQ 0 THEN
            GOSUB GET.CUST.IDENT
        END
    END
*--TODO

    GOSUB EXCH.RECVD.ORIG
    Y.RATE = R.FT<FT.TREASURY.RATE>
    C$SPARE(457) = Y.RATE
    Y.AMT.BOUGHT = R.FT<FT.AMOUNT.CREDITED>[4,99]
    C$SPARE(458) = Y.AMT.BOUGHT
    YAPP = FN.FUNDS.TRANSFER
    R.YAPP = R.FT
*   YLCY.EQU.AMT = R.FT<FT.LOC.AMT.CREDITED>
    YLCY.EQU.AMT = Y.AMT.BOUGHT
RETURN

*--TODO
******************
SET.CUST.NAME.FT:
******************
    R.CUSTOMER.FT = ''; CUS.ERR = '';

    CALL F.READ(FN.CUSTOMER,Y.DEBIT.CUSTOMER,R.CUSTOMER.FT,F.CUSTOMER,CUS.ERR)
    IF NOT(CUS.ERR) THEN
        CUST.NAME = R.CUSTOMER.FT<EB.CUS.SHORT.NAME>
    END ELSE
        CUST.NAME = ''
    END

RETURN

******************
SET.CUST.IDENT.FT:
******************
*--Todo
*--Poner Donde Va
    L.FT.DOC.NUM.POS = ""; Y.L.FT.DOC.NUM =""
    CALL GET.LOC.REF("FUNDS.TRANSFER", "L.FT.DOC.NUM",L.FT.DOC.NUM.POS)
    Y.L.FT.DOC.NUM = R.FT<FT.LOCAL.REF,L.FT.DOC.NUM.POS>
RETURN

******************
GET.CUST.IDENT.FT:
******************
*--Todo
*--Poner Donde Va
    CUST.IDEN = ''; ID.TYPE = ''; YLEG.TYPE = ""

    GOSUB SET.CUST.IDENT.FT

    CUST.IDEN = Y.L.FT.DOC.NUM

    IF LENDP(Y.L.FT.DOC.NUM) EQ 11 THEN
        YLEG.TYPE = 'CEDULA'
    END ELSE ;* R22 Auto conversion
        IF LENDP(Y.L.FT.DOC.NUM) LT 11 THEN
            YLEG.TYPE = 'RNC'
        END ;* R22 Auto conversion
    END

    C$SPARE(451) = CUST.IDEN

    GOSUB SET.ID.TYPE

RETURN

*****************
GET.CUST.IDENT:
*****************
*--Poner Donde Va
    L.L.CU.TIPO.CL.POS = ''
    CALL GET.LOC.REF("CUSTOMER", "L.CU.TIPO.CL",L.L.CU.TIPO.CL.POS)
    Y.L.CU.TIPO.CL = R.CUSTOMER.FT<EB.CUS.LOCAL.REF,L.L.CU.TIPO.CL.POS>

    BEGIN CASE
        CASE Y.L.CU.TIPO.CL EQ 'PERSONA FISICA'
            YLEG.TYPE = "CEDULA"

            L.L.CU.CIDENT.POS = ''
            CALL GET.LOC.REF("CUSTOMER", "L.CU.CIDENT",L.L.CU.CIDENT.POS)
            Y.L.CU.CIDENT = R.CUSTOMER.FT<EB.CUS.LOCAL.REF,L.L.CU.CIDENT.POS>

            CUST.IDEN = Y.L.CU.CIDENT
        CASE Y.L.CU.TIPO.CL EQ 'PERSONA JURIDICA'
            YLEG.TYPE = "RNC"

            L.L.CU.RNC.POS = ''
            CALL GET.LOC.REF("CUSTOMER", "L.CU.RNC",L.L.CU.RNC.POS)
            Y.L.CU.RNC = R.CUSTOMER.FT<EB.CUS.LOCAL.REF,L.L.CU.RNC.POS>

            CUST.IDEN = Y.L.CU.RNC
    END CASE

    C$SPARE(451) = CUST.IDEN

    GOSUB SET.ID.TYPE

RETURN

************
SET.ID.TYPE:
************
    LOCATE YLEG.TYPE IN DOC.TYPE.LIST SETTING DT1.POS THEN
        ID.TYPE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,DT.POS,DT1.POS>
    END

    C$SPARE(452) = ID.TYPE

RETURN

**********************
SET.NAME.RNC.CUSTOMER:
**********************
    YLEG.TYPE = "RNC"

*--Busco la Identificacion en la Transaccion FundTransfer
    GOSUB SET.CUST.IDENT.FT

    IF Y.L.FT.DOC.NUM.2 NE '' AND Y.L.FT.DOC.NUM.2 NE 0 THEN
        Y.L.FT.DOC.NUM = Y.L.FT.DOC.NUM.2
        Y.L.FT.DOC.NUM.2 = ''
    END

    CUS.CCY.ERR = ''; CUS.CCY.ID = ''
    SEL.CMD = "SELECT FBNK.CUSTOMER  WITH L.CU.RNC EQ ": Y.L.FT.DOC.NUM
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,CUS.CCY.ERR)

    LOOP
        REMOVE CUS.CCY.ID FROM SEL.LIST SETTING SEL.LIST.POS
    WHILE CUS.CCY.ID
        Y.DEBIT.CUSTOMER = CUS.CCY.ID
        GOSUB SET.CUST.NAME.FT
    REPEAT

RETURN

*********************
IS.APAP.ACCOUNT.FT:
*********************
    Y.DEBIT.ACCT.NO = R.FT<FT.DEBIT.ACCT.NO>
    Y.CREDIT.ACCT.NO = R.FT<FT.CREDIT.ACCT.NO>

    IF Y.DEBIT.ACCT.NO[1,3] EQ Y.CCY.SOLD AND Y.CREDIT.ACCT.NO[1,3] EQ Y.CCY.BOUGHT THEN
        Y.L.FT.DOC.NUM.2 = '401000131'
        GOSUB SET.NAME.RNC.CUSTOMER
    END ELSE
*--FN.ACCOUNT='F.ACCOUNT'; F.ACCOUNT=''
*--CALL OPF(FN.ACCOUNT,F.ACCOUNT)

        R.ACCOUNT = ''; ERR=''; Y.ACCOUNT=''

        Y.ACCOUNT = Y.DEBIT.ACCT.NO
        CALL F.READ(FN.ACCOUNT, Y.ACCOUNT, R.ACCOUNT, F.ACCOUNT, ERR)

        IF R.ACCOUNT THEN
*--CONDITION.GROUP ES IGUAL A NOSTRO ACCOUNTS
            IF R.ACCOUNT<AC.CONDITION.GROUP> EQ 25 THEN
                Y.L.FT.DOC.NUM.2 = '401000131'
                GOSUB SET.NAME.RNC.CUSTOMER
            END ELSE
                R.ACCOUNT = ''; ERR=''; Y.ACCOUNT=''
                Y.ACCOUNT = Y.CREDIT.ACCT.NO

                CALL F.READ(FN.ACCOUNT, Y.ACCOUNT, R.ACCOUNT, F.ACCOUNT, ERR)

                IF R.ACCOUNT THEN
                    IF R.ACCOUNT<AC.CONDITION.GROUP> EQ 25 THEN
                        Y.L.FT.DOC.NUM.2 = '401000131'
                        GOSUB SET.NAME.RNC.CUSTOMER
                    END
                END
            END
        END
    END

RETURN
*--TODO

MVMT.TT:
*********
    YLEG.DEF = ''; YREC.STATUS = ''; YVAL.DATE = ''; YLEG.VAL = ''; CUST.NAME = ''; Y.CCY.SOLD = ''
    Y.RATE = ''; Y.AMT.BOUGHT = ''; R.TT = ''; TELLER.ERR = ''; TELLER.HERR = ''; YMARKER = ''; YLCY.EQU.AMT = ''
    CALL F.READ(FN.TELLER,TXN.ID,R.TT,F.TELLER,TELLER.ERR)
    IF NOT(R.TT) THEN
        TXN.ID.HST = TXN.ID
        CALL EB.READ.HISTORY.REC(F.TELLER.HST,TXN.ID.HST,R.TT,TELLER.HERR)
    END
    YREC.STATUS = R.TT<TT.TE.RECORD.STATUS>
    YMARKER = R.TT<TT.TE.DR.CR.MARKER>
    IF YMARKER EQ 'CREDIT' THEN
        Y.CCY.SOLD = R.TT<TT.TE.CURRENCY.2>
        Y.CCY.BOUGHT = R.TT<TT.TE.CURRENCY.1>
        Y.AMT.BOUGHT = R.TT<TT.TE.AMOUNT.FCY.1>
        CUSTOMER.ID = R.TT<TT.TE.CUSTOMER.1>
        YVAL.DATE = R.TT<TT.TE.VALUE.DATE.1>
*       YLCY.EQU.AMT = R.TT<TT.TE.AMOUNT.LOCAL.1>
        YLCY.EQU.AMT = Y.AMT.BOUGHT
    END ELSE
        Y.CCY.SOLD = R.TT<TT.TE.CURRENCY.1>
        Y.CCY.BOUGHT = R.TT<TT.TE.CURRENCY.2>
        Y.AMT.BOUGHT = R.TT<TT.TE.AMOUNT.FCY.2>
        CUSTOMER.ID = R.TT<TT.TE.CUSTOMER.2>
        YVAL.DATE = R.TT<TT.TE.VALUE.DATE.2>
*       YLCY.EQU.AMT = R.TT<TT.TE.AMOUNT.LOCAL.2>
        YLCY.EQU.AMT = Y.AMT.BOUGHT
    END

    IF NOT(R.TT) OR YREC.STATUS EQ 'REVE' OR Y.CCY.SOLD EQ Y.CCY.BOUGHT OR Y.CCY.BOUGHT EQ LCCY THEN
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
    C$SPARE(458) = Y.AMT.BOUGHT
    YAPP = FN.TELLER
    R.YAPP = R.TT
RETURN

GET.CUST.ID:
************
    YLEG.TYPE = FIELD(YLEG.VAL,'.',1)
    CUST.IDEN = ''; ID.TYPE = ''

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

    GOSUB SET.ID.TYPE

RETURN

****************
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
*--------------------------------------------------------------------------
    WRITESEQ OUT.ARRAY APPEND TO SEQ.PTR ELSE
        ERR.MSG = "Unable to write to ":SEQ.PTR
        INT.CODE = "RGN20"
        INT.TYPE = "ONLINE"
        MON.TP = "02"
        REC.CON = "RGN20-":ERR.MSG
        DESC = "RGN20-":ERR.MSG
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)  ;*R22 MANUAL CODE CONVERSION
        CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 MANUAL CODE CONVERSION
    END
RETURN
*--------------------------------------------------------------------------
END
