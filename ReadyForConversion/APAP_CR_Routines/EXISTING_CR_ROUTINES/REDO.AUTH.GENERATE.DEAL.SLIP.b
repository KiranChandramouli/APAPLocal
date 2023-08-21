*----------------------------------------------------------------------------------------------------------------------
* <Rating>-51</Rating>
*----------------------------------------------------------------------------------------------------------------------
    SUBROUTINE REDO.AUTH.GENERATE.DEAL.SLIP
*----------------------------------------------------------------------------------------------------------------------
* Description: This routine is auth routine for both teller & FT next version
* to produce deal slip for the AA repayments
*----------------------------------------------------------------------------------------------------------------------
* Input Arg : N/A
* Out Arg   : N/A
* Deals With: AA Repayement NV - TELLER, FT
*----------------------------------------------------------------------------------------------------------------------
* Modification Details:
* =====================
* Date         Who                  Reference      Description
* ------       -----                ------------   -------------
* 30-05-2011   Marimuthu                           INITIAL CREATION
* 31-07-2013   Vignesh Kumaar M R   PACS00305984   CASHIER DEAL SLIP PRINT OPTION
*----------------------------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.CUSTOMER
    $INSERT I_TT.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.CURRENCY
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_REDO.NV.AA.DEAL.SLIP.COMMON
    $INSERT I_RC.COMMON
    $INSERT I_F.TRANSACTION
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.REDO.MULTITXN.VERSIONS
    $INSERT I_F.AC.BALANCE.TYPE
    $INSERT I_F.REDO.STORE.SPOOL.ID     ;* Tus S/E

    GOSUB OPEN.FILES
    GOSUB PROCESS

    RETURN

*----------------------------------------------------------------------------------------------------------------------
STORE.DEALSLIP.INFO:
*----------------------------------------------------------------------------------------------------------------------

* Fix for PACS00305984 [CASHIER DEAL SLIP PRINT OPTION]

    IF Y.DEAL.ARRAY NE '' OR Y.DEAL.ARRAY NE 0 THEN

        FN.REDO.CASHIER.DEALSLIP.INFO = 'F.REDO.CASHIER.DEALSLIP.INFO'
        F.REDO.CASHIER.DEALSLIP.INFO = ''
        CALL OPF(FN.REDO.CASHIER.DEALSLIP.INFO,F.REDO.CASHIER.DEALSLIP.INFO)

        R.REDO.CASHIER.DEALSLIP.INFO = Y.DEAL.ARRAY

        IF Y.TRANS.ID EQ '' THEN
            Y.TRANS.ID = ID.NEW
        END

        STORE.TXN.ID = Y.TRANS.ID:'-NV.INFO'

*    READ R.REDO.CASHIER.DEALSLIP.INFO FROM F.REDO.CASHIER.DEALSLIP.INFO, STORE.TXN.ID THEN ;*Tus Start
        CALL F.READ(FN.REDO.CASHIER.DEALSLIP.INFO,STORE.TXN.ID,R.REDO.CASHIER.DEALSLIP.INFO,F.REDO.CASHIER.DEALSLIP.INFO,R.REDO.CASHIER.DEALSLIP.INFO.ERR)
        IF R.REDO.CASHIER.DEALSLIP.INFO THEN      ;* Tus End
            IF R.REDO.CASHIER.DEALSLIP.INFO EQ '' OR R.REDO.CASHIER.DEALSLIP.INFO EQ 0 THEN
                R.REDO.CASHIER.DEALSLIP.INFO = Y.DEAL.ARRAY

*        WRITE R.REDO.CASHIER.DEALSLIP.INFO ON F.REDO.CASHIER.DEALSLIP.INFO, STORE.TXN.ID ;*Tus Start
                CALL F.WRITE(FN.REDO.CASHIER.DEALSLIP.INFO,STORE.TXN.ID,R.REDO.CASHIER.DEALSLIP.INFO)         ;*Tus End
            END ELSE
                IF R.REDO.CASHIER.DEALSLIP.INFO NE Y.DEAL.ARRAY THEN
                    R.REDO.CASHIER.DEALSLIP.INFO = Y.DEAL.ARRAY

*          WRITE R.REDO.CASHIER.DEALSLIP.INFO ON F.REDO.CASHIER.DEALSLIP.INFO, STORE.TXN.ID ;*Tus Start
                    CALL F.WRITE(FN.REDO.CASHIER.DEALSLIP.INFO,STORE.TXN.ID,R.REDO.CASHIER.DEALSLIP.INFO)     ;*Tus End
                END
            END
        END ELSE
            R.REDO.CASHIER.DEALSLIP.INFO = Y.DEAL.ARRAY

*      WRITE R.REDO.CASHIER.DEALSLIP.INFO ON F.REDO.CASHIER.DEALSLIP.INFO, STORE.TXN.ID ;*Tus Start
            CALL F.WRITE(FN.REDO.CASHIER.DEALSLIP.INFO,STORE.TXN.ID,R.REDO.CASHIER.DEALSLIP.INFO)   ;*Tus End
        END

        GET.TXN.ID = System.getVariable("CURRENT.WTM.FIRST.ID")       ;*Tus Start

        IF GET.TXN.ID NE 'CURRENT.WTM.FIRST.ID' THEN
            GET.TXN.ID = GET.TXN.ID:'-NV.INFO'
            R.REDO.CASHIER.DEALSLIP.INFO = Y.DEAL.ARRAY

*      WRITE R.REDO.CASHIER.DEALSLIP.INFO ON F.REDO.CASHIER.DEALSLIP.INFO, STORE.TXN.ID ;*Tus Start
            CALL F.WRITE(FN.REDO.CASHIER.DEALSLIP.INFO,STORE.TXN.ID,R.REDO.CASHIER.DEALSLIP.INFO)   ;*Tus End
        END
        GOSUB CHECK.UPDATE.DEALSLIP.INFO
    END
    RETURN

CHECK.UPDATE.DEALSLIP.INFO:

    Y.TRN.IDS = R.RTTC<RTC.TRANS.ID>
    Y.TRN.DCT = DCOUNT(Y.TRN.IDS,VM)
    Y.INI.CT = 1
    LOOP
    WHILE Y.INI.CT LE Y.TRN.DCT
        Y.RTC.ID = Y.TRN.IDS<1,Y.INI.CT>
        IF Y.TRANS.ID NE Y.RTC.ID THEN
            Y.STORE.ID = Y.RTC.ID:'-NV.INFO'
            CALL F.READ(FN.REDO.CASHIER.DEALSLIP.INFO,Y.STORE.ID,R.REDO.CASHIER.DEALSLIP.INFO,F.REDO.CASHIER.DEALSLIP.INFO,R.REDO.CASHIER.DEALSLIP.INFO.ERR)
            IF R.REDO.CASHIER.DEALSLIP.INFO THEN
                IF R.REDO.CASHIER.DEALSLIP.INFO NE Y.DEAL.ARRAY THEN
                    R.REDO.CASHIER.DEALSLIP.INFO = Y.DEAL.ARRAY
                    CALL F.WRITE(FN.REDO.CASHIER.DEALSLIP.INFO,Y.STORE.ID,R.REDO.CASHIER.DEALSLIP.INFO)

                END

            END ELSE
                Y.UPD.FLAG = '0'
                IF Y.RTC.ID[1,2] EQ 'TT' AND ID.NEW NE Y.RTC.ID THEN
                    CALL F.READ(FN.TT,Y.RTC.ID,R.TT,F.TT,TT.ERR)
                    IF NOT(R.TT) THEN
                        Y.UPD.FLAG = 1
                    END
                END

                IF Y.RTC.ID[1,2] EQ 'FT' AND ID.NEW NE Y.RTC.ID THEN
                    CALL F.READ(FN.FT,Y.RTC.ID,R.FT,F.FT,FT.ERR)
                    IF NOT(R.FT) THEN
                        Y.UPD.FLAG = 1
                    END
                END
                IF Y.UPD.FLAG EQ '0' THEN

                    R.REDO.CASHIER.DEALSLIP.INFO = Y.DEAL.ARRAY
                    CALL F.WRITE(FN.REDO.CASHIER.DEALSLIP.INFO,Y.STORE.ID,R.REDO.CASHIER.DEALSLIP.INFO)
                END
            END
        END
        Y.INI.CT = Y.INI.CT +1
    REPEAT

* End of Fix

    RETURN
*-------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------
    FN.RTC = 'F.REDO.TRANSACTION.CHAIN'
    F.RTC  = ''
    CALL OPF(FN.RTC,F.RTC)

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT  = ''
    CALL OPF(FN.FT,F.FT)

    FN.FT.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FT.NAU  = ''
    CALL OPF(FN.FT.NAU,F.FT.NAU)

    FN.TT = 'F.TELLER'
    F.TT = ''
    CALL OPF(FN.TT,F.TT)

    FN.TT.NAU = 'F.TELLER$NAU'
    F.TT.NAU = ''
    CALL OPF(FN.TT.NAU,F.TT.NAU)

    FN.CUS = 'F.CUSTOMER'
    F.CUS  = ''
    CALL OPF(FN.CUS,F.CUS)

    FN.CUR = 'F.CURRENCY'
    F.CUR  = ''
    CALL OPF(FN.CUR,F.CUR)

    FN.REDO.STORE.SPOOL.ID = 'F.REDO.STORE.SPOOL.ID'
    F.REDO.STORE.SPOOL.ID = ''
    CALL OPF(FN.REDO.STORE.SPOOL.ID,F.REDO.STORE.SPOOL.ID)

    FN.FTTC = 'F.FT.TXN.TYPE.CONDITION'
    F.FTTC = ''
    CALL OPF(FN.FTTC,F.FTTC)

    FN.TXN = 'F.TRANSACTION'
    F.TXN = ''
    CALL OPF(FN.TXN,F.TXN)

    FN.MTXN.VER = 'F.REDO.MULTITXN.VERSIONS'
    F.MTXN.VER = ''
    CALL OPF(FN.MTXN.VER,F.MTXN.VER)

    FN.AC.BALANCE.TYPE = 'F.AC.BALANCE.TYPE'
    F.AC.BALANCE.TYPE = ''
    CALL OPF(FN.AC.BALANCE.TYPE,F.AC.BALANCE.TYPE)

    RETURN
*-------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------

    Y.NT.FOUND = ''
    IF OFS$SOURCE.ID EQ 'FASTPATH' THEN
        Y.AA.PAYMENT = ''
        OFS$DEAL.SLIP.PRINTING = ''
        IF APPLICATION EQ 'TELLER' THEN
            GOSUB TT.PROCESS
        END

        IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
            GOSUB FT.PROCESS
        END
    END ELSE
        Y.AA.PAYMENT = ''
        OFS$DEAL.SLIP.PRINTING = ''
        IF APPLICATION EQ 'TELLER' THEN
            GOSUB TT.PROCESS.SUP
        END

        IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
            GOSUB FT.PROCESS.SUP
        END
    END

    RETURN
*-------------------------------------------------------------
TT.PROCESS:
*-------------------------------------------------------------
    GOSUB GET.LOC.REF.POS
    IF R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.L.NEXT.VERSION> EQ '' AND R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.L.INITIAL.ID> NE '' THEN
        Y.TRANS.ID = R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.L.INITIAL.ID>
        GOSUB CHK.TRANS.CHAIN
        IF Y.NT.FOUND EQ '' THEN
            GOSUB CHECK.AA.PAYMENT
            IF Y.AA.PAYMENT = 'YES' THEN
                GOSUB PRODUCE.DEAL.SLIP
            END
        END
    END

    RETURN

TT.PROCESS.SUP:

    GOSUB GET.LOC.REF.POS
    Y.TRANS.ID = R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.L.INITIAL.ID>
    GOSUB CHK.TRANS.CHAIN
    IF Y.NT.FOUND EQ '' THEN
        GOSUB CHECK.AA.PAYMENT
        IF Y.AA.PAYMENT = 'YES' THEN
            GOSUB PRODUCE.DEAL.SLIP
        END
    END

    RETURN
*-------------------------------------------------------------
FT.PROCESS:
*-------------------------------------------------------------
    GOSUB GET.LOC.REF.POS
    IF R.NEW(FT.LOCAL.REF)<1,POS.FT.L.NEXT.VERSION> EQ '' AND R.NEW(FT.LOCAL.REF)<1,POS.FT.L.INITIAL.ID> NE '' THEN
        Y.TRANS.ID = R.NEW(FT.LOCAL.REF)<1,POS.FT.L.INITIAL.ID>
        GOSUB CHK.TRANS.CHAIN
        IF Y.NT.FOUND EQ '' THEN
            GOSUB CHECK.AA.PAYMENT
            IF Y.AA.PAYMENT = 'YES' THEN
                GOSUB PRODUCE.DEAL.SLIP
            END
        END
    END

    RETURN

FT.PROCESS.SUP:

    GOSUB GET.LOC.REF.POS
    Y.TRANS.ID = R.NEW(FT.LOCAL.REF)<1,POS.FT.L.INITIAL.ID>
    GOSUB CHK.TRANS.CHAIN
    IF Y.NT.FOUND EQ '' THEN
        GOSUB CHECK.AA.PAYMENT
        IF Y.AA.PAYMENT = 'YES' THEN
            GOSUB PRODUCE.DEAL.SLIP
        END
    END

    RETURN

CHK.TRANS.CHAIN:

    CALL F.READ(FN.RTC,Y.TRANS.ID,R.RTTC,F.RTC,RTC.ER)
    IF R.RTTC THEN
        Y.RTC.IDS = R.RTTC<RTC.TRANS.ID>
        Y.ID.CNT = DCOUNT(Y.RTC.IDS,VM) ; FLG.RR = ''
        LOOP
        WHILE Y.ID.CNT GT 0 DO
            FLG.RR += 1
            Y.TXN.D = Y.RTC.IDS<1,FLG.RR>
            IF Y.TXN.D[1,2] EQ 'FT' AND Y.TXN.D NE ID.NEW THEN
                CALL F.READ(FN.FT,Y.TXN.D,R.FT,F.FT,FT.ERR)
                IF NOT(R.FT) THEN
                    Y.NT.FOUND = 1
                    Y.ID.CNT = 0
                END
            END
            IF Y.TXN.D[1,2] EQ 'TT' AND Y.TXN.D NE ID.NEW THEN
                CALL F.READ(FN.TT,Y.TXN.D,R.TT,F.TT,TT.ERR)
                IF NOT(R.TT) THEN
                    Y.NT.FOUND = 1
                    Y.ID.CNT = 0
                END
            END
            Y.ID.CNT -= 1
        REPEAT
    END

    RETURN
*-------------------------------------------------------------
CHECK.AA.PAYMENT:
*-------------------------------------------------------------
    Y.VERSION.TYPES = ''
    Y.PROC.TYPE     = ''
    Y.RECEP.METHOD  = ''

    CALL REDO.GET.NV.VERSION.TYPES(Y.TRANS.ID,Y.VERSION.NAMES,Y.VERSION.TYPES,Y.PROC.TYPE,Y.RECEP.METHOD)

    LOCATE 'AA.PAYMENT' IN Y.VERSION.TYPES SETTING POS1 THEN
        Y.AA.PAYMENT = 'YES'
    END ELSE
        LOCATE 'AA.COLLECTION' IN Y.VERSION.TYPES SETTING POS1 THEN
            Y.AA.PAYMENT = 'YES'
        END
    END

    RETURN
*-------------------------------------------------------------
PRODUCE.DEAL.SLIP:
*-------------------------------------------------------------

    CALL F.READ(FN.RTC,Y.TRANS.ID,R.RTC,F.RTC,RTC.ERR)
    IF R.RTC ELSE
        RETURN
    END


    GOSUB GET.TXN.REF
    GOSUB SPLIT.TRANSACTION

    RETURN
*-------------------------------------------------------------
GET.TXN.REF:
*-------------------------------------------------------------

    Y.AA.PAYMENT.TXNS  = ''
    Y.AA.PAYMENT.AMTS  = ''
    Y.CASH             = ''
    Y.ACCOUNT.DEBIT    = ''
    Y.CHEQUE           = ''
    Y.TOT.TXN.IDS = R.RTC<RTC.TRANS.ID>
    Y.TXN.CNTS = DCOUNT(Y.TOT.TXN.IDS,VM)
    Y.VAR1 =  1
    LOOP
    WHILE Y.VAR1 LE Y.TXN.CNTS

        Y.TXN.ID = Y.TOT.TXN.IDS<1,Y.VAR1>
        IF Y.TXN.ID[1,2] EQ 'FT' THEN
            IF Y.VERSION.TYPES<Y.VAR1> EQ 'AA.PAYMENT' OR Y.VERSION.TYPES<Y.VAR1> EQ 'AA.COLLECTION' THEN
                Y.AA.PAYMENT.TXNS<-1> = Y.TOT.TXN.IDS<1,Y.VAR1>
                Y.AA.PAYMENT.AMTS<-1> = ABS(R.RTC<RTC.TRANS.AMOUNT,Y.VAR1>)
            END
        END
        IF Y.TXN.ID[1,2] EQ 'TT' THEN
            IF Y.VERSION.TYPES<Y.VAR1> EQ 'CASH' AND Y.PROC.TYPE<Y.VAR1> EQ 'I' AND Y.RECEP.METHOD<Y.VAR1> EQ 'E'  THEN
                Y.CASH += ABS(R.RTC<RTC.TRANS.AMOUNT,Y.VAR1>)
            END
            IF Y.VERSION.TYPES<Y.VAR1> EQ 'ACCOUNT.DEBIT' AND Y.PROC.TYPE<Y.VAR1> EQ 'I' AND Y.RECEP.METHOD<Y.VAR1> EQ 'E'  THEN
                Y.ACCOUNT.DEBIT += ABS(R.RTC<RTC.TRANS.AMOUNT,Y.VAR1>)
            END
            IF Y.VERSION.TYPES<Y.VAR1> EQ 'CHEQUE' AND Y.PROC.TYPE<Y.VAR1> EQ 'I' AND Y.RECEP.METHOD<Y.VAR1> EQ 'C'  THEN
                Y.CHEQUE    += ABS(R.RTC<RTC.TRANS.AMOUNT,Y.VAR1>)
            END
            IF Y.PROC.TYPE<Y.VAR1> EQ 'E' AND Y.RECEP.METHOD<Y.VAR1> EQ 'E' THEN
                IF Y.CASH THEN
                    Y.CASH -= ABS(R.RTC<RTC.TRANS.AMOUNT,Y.VAR1>)
                END
            END

        END
        Y.VAR1++
    REPEAT

    RETURN
*-------------------------------------------------------------
SPLIT.TRANSACTION:
*-------------------------------------------------------------
    R.DEAL.ARRAY = ''
    Y.DEAL.ARRAY = ''
    Y.CONS = ''

    IF Y.TRANS.ID[1,2] EQ 'FT' THEN
        R.FT = ''
        CALL F.READ(FN.FT,Y.TRANS.ID,R.FT,F.FT,FT.ERR)
        IF R.FT ELSE
            CALL F.READ(FN.FT.NAU,Y.TRANS.ID,R.FT,F.FT.NAU,FT.ERR)
        END

        Y.ADV.CNT = R.FT<FT.LOCAL.REF,POS.ADV.CNT>

        Y.ACT.VER = R.FT<FT.LOCAL.REF,POS.ACT.VER>
        SEL.CMD = 'SELECT ':FN.MTXN.VER:' WITH VERSION.NAME EQ ':Y.ACT.VER
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
        Y.SEL.ID = SEL.LIST<1>

        CALL F.READ(FN.MTXN.VER,Y.SEL.ID,R.MTXN.VER,F.MTXN.VER,MTXN.ERR)

        Y.CONCEPT = R.MTXN.VER<RMV.DESCRIPTION>
        Y.CONS = 'YES'

    END

    Y.NO.OF.TXNS = DCOUNT(Y.AA.PAYMENT.TXNS,FM)
    Y.VAR2 = 1
    LOOP
    WHILE Y.VAR2 LE Y.NO.OF.TXNS
        Y.DEAL.ARRAY<1,Y.VAR2> = Y.AA.PAYMENT.TXNS<Y.VAR2>  ;* Fix for PACS00305984

        GOSUB GET.LOAN.DETAILS
        Y.VAR2++
    REPEAT

    Y.OLD.ID.NEW = ID.NEW
    Y.VAR2 = 1
    LOOP
    WHILE Y.VAR2 LE Y.NO.OF.TXNS
        ID.NEW = Y.AA.PAYMENT.TXNS<Y.VAR2>
        DEAL.SLIP.CALL = 'REDO.NV.AA.PAY'
*CALL PRODUCE.DEAL.SLIP(DEAL.SLIP.CALL)

        Y.HID = C$LAST.HOLD.ID

        WTT.ID = System.getVariable("CURRENT.INDA.ID")

        IF WTT.ID EQ 'CURRENT.INDA.ID' THEN
            WTT.ID = Y.TRANS.ID
            E = ''
        END

        R.REDO.STORE.SPOOL.ID = ''
        CALL F.READ(FN.REDO.STORE.SPOOL.ID,WTT.ID,R.REDO.STORE.SPOOL.ID,F.REDO.STORE.SPOOL.ID,SPL.ERR)
        IF NOT(R.REDO.STORE.SPOOL.ID) THEN
            R.REDO.STORE.SPOOL.ID = Y.HID
            CALL F.WRITE(FN.REDO.STORE.SPOOL.ID,WTT.ID,R.REDO.STORE.SPOOL.ID)
        END ELSE
*      R.REDO.STORE.SPOOL.ID<1,-1> = Y.HID
            R.REDO.STORE.SPOOL.ID<RD.SPL.SPOOL.ID,-1> = Y.HID         ;* Tus S/E
            CALL F.WRITE(FN.REDO.STORE.SPOOL.ID,WTT.ID,R.REDO.STORE.SPOOL.ID)
        END

        Y.VAR2++
    REPEAT

    ID.NEW = Y.OLD.ID.NEW

    RETURN
*-------------------------------------------------------------
GET.LOAN.DETAILS:
*-------------------------------------------------------------

    CALL F.READ(FN.FT,Y.AA.PAYMENT.TXNS<Y.VAR2>,R.FT,F.FT,FT.ERR)
    IF R.FT ELSE
        CALL F.READ(FN.FT.NAU,Y.AA.PAYMENT.TXNS<Y.VAR2>,R.FT,F.FT.NAU,FT.ERR)
    END

* Fix for PACS00305984 [CASHIER DEAL SLIP PRINT OPTION]

    Y.DEAL.ARRAY<2,Y.VAR2> = R.FT<FT.CREDIT.ACCT.NO>        ;* Loan Number
    GOSUB GET.CUST.DETAILS    ;*To get the customer details
    Y.DEAL.ARRAY<3,Y.VAR2>  = Y.NAME.1  ;* Customer Name
    Y.DEAL.ARRAY<4,Y.VAR2>  = Y.CONCEPT ;* Concept
    Y.DEAL.ARRAY<5,Y.VAR2>  = Y.CUR     ;* Currency

* Y.DEAL.ARRAY<6,Y.VAR2>  = FMT(Y.TOT.TXN.AMT,"L2,#15")   ;* Total payment Amount
    Y.DEAL.ARRAY<6,Y.VAR2> = Y.TOT.TXN.AMT

    GOSUB GET.AA.PROP.AMTS


*    Y.DEAL.ARRAY<7,Y.VAR2>    = FMT(FIELD(TOTAL.AMT,'*',1) + FIELD(TOTAL.AMT,'*',5),"L2,#15")       ;* CAPITAL
* Y.DEAL.ARRAY<7,Y.VAR2> = FMT(FIELD(TOTAL.AMT,'*',1),"L2,#15")     ;* Solo capital and not UNC
    Y.DEAL.ARRAY<7,Y.VAR2> = FIELD(TOTAL.AMT,'*',1)

* Y.DEAL.ARRAY<8,Y.VAR2>    = FMT(FIELD(TOTAL.AMT,'*',2),"L2,#15")  ;* INTEREST
    Y.DEAL.ARRAY<8,Y.VAR2>    = FIELD(TOTAL.AMT,'*',2)

* Y.DEAL.ARRAY<9,Y.VAR2>    = FMT(FIELD(TOTAL.AMT,'*',3),"L2,#15")  ;* CHARGE

    Y.DEAL.ARRAY<9,Y.VAR2>    = FIELD(TOTAL.AMT,'*',3)

* Y.DEAL.ARRAY<10,Y.VAR2>   = FMT(FIELD(TOTAL.AMT,'*',4),"L2,#15")  ;* MORA
    Y.DEAL.ARRAY<10,Y.VAR2>   = FIELD(TOTAL.AMT,'*',4)

    Y.UNV.AMT = FIELD(TOTAL.AMT,'*',5)
    Y.PRIN.DEC.AT = FIELD(TOTAL.AMT,'*',6)

    BEGIN CASE
    CASE Y.UNV.AMT GT 0 AND Y.PRIN.DEC.AT GT 0
        IF Y.BILL.PAY.DATE THEN
            Y.DEAL.ARRAY<11,Y.VAR2>   = Y.BILL.PAY.DATE
        END

        Y.DEAL.ARRAY<7,Y.VAR2> = FIELD(TOTAL.AMT,'*',1) + Y.PRIN.DEC.AT

    CASE Y.UNV.AMT GT 0 AND (Y.PRIN.DEC.AT EQ 0 OR Y.PRIN.DEC.AT EQ '')
        IF Y.BILL.PAY.DATE THEN
            Y.DEAL.ARRAY<11,Y.VAR2>   = Y.BILL.PAY.DATE:'/ANTICIPADO'
        END ELSE
            Y.DEAL.ARRAY<11,Y.VAR2> = 'ANTICIPADO'
        END

    CASE (Y.UNV.AMT EQ 0 OR Y.UNV.AMT EQ '') AND Y.PRIN.DEC.AT GT 0
        IF Y.ACT.VER EQ 'FUNDS.TRANSFER,REDO.AA.PAY.OFF.A' OR Y.ACT.VER EQ 'FUNDS.TRANSFER,REDO.MULTI.AA.ACPOAP.A' OR Y.ACT.VER EQ 'FUNDS.TRANSFER,REDO.MULTI.AA.ACPOAP.TR.A' THEN
            Y.DEAL.ARRAY<11,Y.VAR2> = Y.BILL.PAY.DATE
        END ELSE
            IF Y.BILL.PAY.DATE THEN
                Y.DEAL.ARRAY<11,Y.VAR2>   = Y.BILL.PAY.DATE:'/EXTRAORDINARIO'
            END ELSE
                Y.DEAL.ARRAY<11,Y.VAR2> = 'EXTRAORDINARIO'
            END
        END
        Y.DEAL.ARRAY<7,Y.VAR2> = FIELD(TOTAL.AMT,'*',1) + Y.PRIN.DEC.AT

    CASE (Y.UNV.AMT EQ 0 OR Y.UNV.AMT EQ '') AND (Y.PRIN.DEC.AT EQ 0 OR Y.PRIN.DEC.AT EQ '')
        Y.DEAL.ARRAY<11,Y.VAR2>   = Y.BILL.PAY.DATE

    END CASE

    Y.TOT.AMT     = Y.DEAL.ARRAY<7,Y.VAR2> + Y.DEAL.ARRAY<8,Y.VAR2> + Y.DEAL.ARRAY<9,Y.VAR2> + Y.DEAL.ARRAY<10,Y.VAR2>

    IF Y.TOT.AMT GT Y.TOT.TXN.AMT THEN
        Y.DEAL.ARRAY<9,Y.VAR2> = Y.TOT.TXN.AMT - (Y.DEAL.ARRAY<7,Y.VAR2>+Y.DEAL.ARRAY<8,Y.VAR2>+Y.DEAL.ARRAY<10,Y.VAR2>)          ;*
    END

*Y.TOT.AMT     = Y.DEAL.ARRAY<7,Y.VAR2> + Y.DEAL.ARRAY<8,Y.VAR2> + Y.DEAL.ARRAY<9,Y.VAR2> + Y.DEAL.ARRAY<10,Y.VAR2>
*IF Y.TOT.AMT GT Y.TOT.TXN.AMT THEN  ;* During payoff, if we have balance in UNC, then payoff charge gets settled with that UNC balance. So we had an issue in deal slip. Ref - PACS00401841.
*Y.DEAL.ARRAY<6,Y.VAR2> = Y.TOT.AMT
*END

    GOSUB GET.CAPITAL.BALANCE
* Y.DEAL.ARRAY<12,Y.VAR2>  = FMT(Y.CAPITAL.BALANCE,"L2,#15")        ;* CAPITAL BALANCE
    Y.DEAL.ARRAY<12,Y.VAR2> = Y.CAPITAL.BALANCE

    Y.DEAL.ARRAY<13,Y.VAR2>  = Y.CUR.TIME         ;* Date and time
    Y.DEAL.ARRAY<14,Y.VAR2>  = Y.COMPANY.DETAILS  ;* Company & Teller id
    GOSUB SPLIT.AMTS
* Y.DEAL.ARRAY<15,Y.VAR2> = FMT(Y.CASH.SPENT,"L2,#15")    ;* Cash
    Y.DEAL.ARRAY<15,Y.VAR2> = Y.CASH.SPENT

* Y.DEAL.ARRAY<16,Y.VAR2> = FMT(Y.ACCOUNT.DEBIT.SPENT,"L2,#15")     ;* Debit Account
    Y.DEAL.ARRAY<16,Y.VAR2> = Y.ACCOUNT.DEBIT.SPENT

* Y.DEAL.ARRAY<17,Y.VAR2> = FMT(Y.CHEQUE.SPENT,"L2,#15")  ;* Cheque
    Y.DEAL.ARRAY<17,Y.VAR2> = Y.CHEQUE.SPENT

    Y.CHEQUE.NOS            = R.FT<FT.LOCAL.REF,POS.CERT.CHEQUE.NO>
    Y.DEAL.ARRAY<18,Y.VAR2> = DCOUNT(Y.CHEQUE.NOS,SM)       ;* No. of cheques
    IF Y.AA.PAYMENT.TXNS<Y.VAR2> EQ ID.NEW THEN
        Y.DEAL.ARRAY<19,Y.VAR2> = R.NEW(FT.LOCAL.REF)<1,POS.L.NCF.NUMBER>       ;* NCF Number
    END ELSE
        Y.DEAL.ARRAY<19,Y.VAR2> = R.FT<FT.LOCAL.REF,POS.L.NCF.NUMBER> ;* NCF Number
    END

* Y.DEAL.ARRAY<20,Y.VAR2> =FMT(FIELD(TOTAL.AMT,'*',2)+ FIELD(TOTAL.AMT,'*',3) ,"L2,#15")          ;* NCF Amount
    Y.DEAL.ARRAY<20,Y.VAR2> = FIELD(TOTAL.AMT,'*',2) + FIELD(TOTAL.AMT,'*',3) + FIELD(TOTAL.AMT,'*',4)

    GOSUB GET.NEXT.PAYMENT.AMT

    IF Y.ACT.VER EQ 'FUNDS.TRANSFER,REDO.MULTI.AA.ACRP.UPD.TR' OR Y.ACT.VER EQ 'FUNDS.TRANSFER,REDO.MULTI.AA.ACRP.UPD' THEN
* Y.DEAL.ARRAY<21,Y.VAR2> = FMT(Y.NEXT.PAY.AMT,"L2,#15")  ;* Next Payment Amount
        Y.DEAL.ARRAY<21,Y.VAR2> = Y.NEXT.PAY.AMT
    END

    R.DEAL.ARRAY = Y.DEAL.ARRAY
    GOSUB STORE.DEALSLIP.INFO

* End of Fix

    RETURN
*-------------------------------------------------------------
GET.CUST.DETAILS:
*-------------------------------------------------------------
*To get the customer details
    Y.CUST.ID = R.FT<FT.CREDIT.CUSTOMER>
    CALL F.READ(FN.CUS,Y.CUST.ID,R.CUST,F.CUS,CUS.ERR)
    Y.CUST.NAME = R.CUST<EB.CUS.SHORT.NAME>

    CALL REDO.CUST.IDENTITY.REF(Y.CUST.ID,Y.ALT.ID,Y.CUS.NAME)
    Y.NAME.1         = Y.CUS.NAME[1,35]
    Y.NAME.2         = Y.CUS.NAME[36,LEN(Y.CUS.NAME)]


    LOCATE Y.AA.PAYMENT.TXNS<Y.VAR2> IN R.RTC<RTC.TRANS.ID,1> SETTING TXN.POS THEN
        IF Y.CONS EQ '' THEN
            Y.CONCEPT      = R.RTC<RTC.TRANS.DESC,TXN.POS>
        END
        Y.CUR     = R.RTC<RTC.TRANS.CCY,TXN.POS>
        CALL CACHE.READ(FN.CUR,Y.CUR,R.CUR,CCY.ERR)
        IF R.CUR<EB.CUR.CCY.NAME,LNGG> THEN
            Y.CUR = R.CUR<EB.CUR.CCY.NAME,LNGG>
        END ELSE
            Y.CUR = R.CUR<EB.CUR.CCY.NAME,1>
        END

        Y.TOT.TXN.AMT  = ABS(R.RTC<RTC.TRANS.AMOUNT,TXN.POS>)
    END

    RETURN
*-------------------------------------------------------------
GET.AA.PROP.AMTS:
*-------------------------------------------------------------
    TOTAL.AMT = ''
    Y.LOAN.ACC = R.FT<FT.CREDIT.ACCT.NO>
    IN.ARR.ID = ''
    OUT.ID = ''
    CALL REDO.CONVERT.ACCOUNT(Y.LOAN.ACC,IN.ARR.ID,ARR.ID,ERR.TEXT)
    CALL REDO.GET.INDV.REPAY.AMT(Y.AA.PAYMENT.TXNS<Y.VAR2>,ARR.ID,TOTAL.AMT,Y.BILL.PAY.DATE)

    IF OFS$SOURCE.ID EQ 'FASTPATH' THEN
        WTT.ID = System.getVariable("CURRENT.TID.ID")
    END ELSE
        WTT.ID = R.RTC<RTC.TELLER.ID>
    END
    Y.COMPANY.DETAILS = ID.COMPANY:'-':WTT.ID
    Y.CUR.TIME = TIMEDATE()
    RETURN
*-------------------------------------------------------------
SPLIT.AMTS:
*-------------------------------------------------------------
    Y.TRANS.AMT = Y.AA.PAYMENT.AMTS<Y.VAR2>
    Y.CASH.SPENT = 0
    Y.ACCOUNT.DEBIT.SPENT = 0
    Y.CHEQUE.SPENT = 0
    IF Y.CASH THEN
        IF Y.TRANS.AMT GT Y.CASH THEN
            Y.TRANS.AMT = Y.TRANS.AMT - Y.CASH
            Y.CASH.SPENT = Y.CASH
            Y.CASH = 0
        END ELSE
            Y.CASH = Y.CASH - Y.TRANS.AMT
            Y.CASH.SPENT = Y.TRANS.AMT
            Y.TRANS.AMT = 0
        END
    END
    IF Y.TRANS.AMT AND Y.ACCOUNT.DEBIT THEN
        IF Y.TRANS.AMT GT Y.ACCOUNT.DEBIT THEN
            Y.TRANS.AMT = Y.TRANS.AMT - Y.ACCOUNT.DEBIT
            Y.ACCOUNT.DEBIT.SPENT = Y.ACCOUNT.DEBIT
            Y.ACCOUNT.DEBIT = 0
        END ELSE
            Y.ACCOUNT.DEBIT = Y.ACCOUNT.DEBIT - Y.TRANS.AMT
            Y.ACCOUNT.DEBIT.SPENT = Y.TRANS.AMT
            Y.TRANS.AMT = 0
        END
    END
    IF Y.TRANS.AMT AND Y.CHEQUE THEN
        IF Y.TRANS.AMT GT Y.CHEQUE THEN
            Y.TRANS.AMT = Y.TRANS.AMT - Y.CHEQUE
            Y.CHEQUE.SPENT = Y.CHEQUE
            Y.ACCOUNT.DEBIT = 0
        END ELSE
            Y.CHEQUE = Y.CHEQUE - Y.TRANS.AMT
            Y.CHEQUE.SPENT = Y.TRANS.AMT
            Y.TRANS.AMT = 0
        END
    END

    RETURN
*-------------------------------------------------------------
GET.CAPITAL.BALANCE:
*-------------------------------------------------------------

    IN.PROPERTY.CLASS = 'ACCOUNT'
    CALL REDO.GET.PROPERTY.NAME(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)

    BALANCE.AMOUNT=''

    Y.SEL.COMAND  = 'SELECT ' : FN.AC.BALANCE.TYPE
    Y.SEL.COMAND := ' WITH @ID LIKE ...ACCOUNT AND @ID UNLIKE UNC... AND @ID UNLIKE UND...'
    Y.SEL.COMAND := ' AND REPORTING.TYPE EQ "NON-CONTINGENT"'

    CALL EB.READLIST(Y.SEL.COMAND,Y.BALANCE.TYPE,'',NO.OF.RECO,Y.ERR3)

    Y.CAPITAL.BALANCE = ''
*For each balance type get the value
    LOOP
        REMOVE Y.BALANCE.TYPE.ID FROM Y.BALANCE.TYPE SETTING Y.POS
    WHILE  Y.POS:Y.BALANCE.TYPE.ID
        Y.BALANCE.TO.CHECK = Y.BALANCE.TYPE.ID
*Get the balance value
        Y.TODAY = TODAY
        CALL AA.GET.ECB.BALANCE.AMOUNT(Y.LOAN.ACC,Y.BALANCE.TO.CHECK,Y.TODAY,BALANCE.AMOUNT,RET.ERROR)
        Y.CAPITAL.BALANCE += ABS(BALANCE.AMOUNT)
    REPEAT

    IF Y.AA.PAYMENT.TXNS<Y.VAR2> EQ ID.NEW THEN
        Y.FTTC.ID =  R.NEW(FT.TRANSACTION.TYPE)
    END ELSE
        Y.FTTC.ID = R.FT<FT.TRANSACTION.TYPE>
    END
    IF Y.FTTC.ID MATCHES 'ACPO':VM:'ACQP' THEN
        Y.CAPITAL.BALANCE = 0 ;* Here we are passing the amount as 0 in case of payoff activity. cos in case if the loan has advance payment
*                                  then we will have balances in UNCACCOUNT so we will post OFS to dr UNC and cr to loan during payoff repayment activity via REDO.POST.CHEQUE.UPDATE
*                                  So dealslip field value will have some balances. To avoid that we presume that after payoff loan's outstanding amount will be ZERO!!!
    END


    RETURN
*-------------------------------------------------------------
GET.NEXT.PAYMENT.AMT:
*-------------------------------------------------------------
    Y.NEXT.PAY.AMT = ''

    SIMULATION.REF = ''
    NO.RESET = '1'
    YREGION = ''
    YDATE = TODAY
    Y.YEAR = YDATE[1,4] + 2
    YDAYS.ORIG = Y.YEAR:TODAY[5,4]
    DATE.RANGE = TODAY:FM:YDAYS.ORIG    ;* Date range is passed for 2 years to avoid building schedule for whole loan term
    CALL AA.SCHEDULE.PROJECTOR(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS, DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)

    GOSUB GET.NEXT.AMOUNT

    RETURN
*----------------------------------------------------------------------------------
GET.NEXT.AMOUNT:
*----------------------------------------------------------------------------------
    Y.DATES.CNT = DCOUNT(PAYMENT.DATES,FM)
    Y.VAR3=1
    LOOP
    WHILE Y.VAR3 LE Y.DATES.CNT
        Y.PAY.DATE = PAYMENT.DATES<Y.VAR3>
        IF Y.PAY.DATE GT TODAY THEN
            Y.NEXT.PAY.AMT = TOT.PAYMENT<Y.VAR3>
            Y.VAR3 = Y.DATES.CNT+1
        END
        Y.VAR3++
    REPEAT

    RETURN
*-------------------------------------------------------------
GET.LOC.REF.POS:
*-------------------------------------------------------------

    LOC.REF.APPLICATION = "TELLER":FM:"FUNDS.TRANSFER"
    LOC.REF.FIELDS      = 'L.NEXT.VERSION':VM:'L.INITIAL.ID':FM:'L.NEXT.VERSION':VM:'L.INITIAL.ID':VM:'CERT.CHEQUE.NO':VM:'L.NCF.NUMBER':VM:'L.ACTUAL.VERSIO':VM:'L.NO.OF.INSTAL':VM:'L.ADV.INS.CNT'
    LOC.REF.POS         = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.TT.L.NEXT.VERSION = LOC.REF.POS<1,1>
    POS.TT.L.INITIAL.ID   = LOC.REF.POS<1,2>
    POS.FT.L.NEXT.VERSION = LOC.REF.POS<2,1>
    POS.FT.L.INITIAL.ID   = LOC.REF.POS<2,2>
    POS.CERT.CHEQUE.NO    = LOC.REF.POS<2,3>
    POS.L.NCF.NUMBER      = LOC.REF.POS<2,4>
    POS.ACT.VER = LOC.REF.POS<2,5>
    POS.INS.CNT = LOC.REF.POS<2,6>
    POS.ADV.CNT = LOC.REF.POS<2,7>

    RETURN
END
