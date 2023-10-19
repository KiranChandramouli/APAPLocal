* @ValidationCode : MjotMTgzODMzNzI1OTpDcDEyNTI6MTY4NTUzNjAwMDg5MDp2aWN0bzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 17:56:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.UPDATE.NV.CHEQUES
*-----------------------------------------------------------
*Description: This routine is to update the REDO.LOAN.FT.TT.TXN table
*              with the Cheque details for processing.
*-----------------------------------------------------------
*Modification History
*DATE                     WHO                        REFERENCE                      DESCRIPITION
*05-04-2023           Conversion Tool          R22 Auto Code conversion      FM TO @FM,VM TO @VM , SM TO @SM , TNO TO C$T24.SESSION.NO, ++ TO +=1
*05-04-2023               Samaran T         Manual R22 Code Conversion         Call Routine format modified
*-----------------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_F.REDO.LOAN.FT.TT.TXN
    $USING APAP.TAM

    GOSUB PROCESS
RETURN
*-----------------------------------------------------------
PROCESS:
*-----------------------------------------------------------
    R.REDO.LOAN.FT.TT.TXN = ''

    GOSUB GET.LOC.REF.POS
    IF APPLICATION EQ 'TELLER' THEN
        GOSUB TT.PROCESS
    END

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB FT.PROCESS
    END
RETURN

*-------------------------------------------------------------
TT.PROCESS:
*-------------------------------------------------------------
    IF R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.L.NEXT.VERSION> EQ '' AND R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.L.INITIAL.ID> NE '' THEN
        Y.TRANS.ID = R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.L.INITIAL.ID>
        GOSUB PROCESS.CHEQUE.UPDATE
    END

RETURN
*-------------------------------------------------------------
FT.PROCESS:
*-------------------------------------------------------------
    IF R.NEW(FT.LOCAL.REF)<1,POS.FT.L.NEXT.VERSION> EQ '' AND R.NEW(FT.LOCAL.REF)<1,POS.FT.L.INITIAL.ID> NE '' THEN
        Y.TRANS.ID = R.NEW(FT.LOCAL.REF)<1,POS.FT.L.INITIAL.ID>
        GOSUB PROCESS.CHEQUE.UPDATE
    END
RETURN
*-------------------------------------------------------------
PROCESS.CHEQUE.UPDATE:
*-------------------------------------------------------------
    Y.VERSION.TYPES = ''
    Y.PROC.TYPE     = ''
    Y.RECEP.METHOD  = ''

    APAP.TAM.redoGetNvVersionTypes(Y.TRANS.ID,Y.VERSION.NAMES,Y.VERSION.TYPES,Y.PROC.TYPE,Y.RECEP.METHOD) ;*R22 MANUAL CODE CONVERSION
    Y.TIPO.DE.VERSIONS = Y.VERSION.TYPES
    CHANGE @FM TO @VM IN Y.TIPO.DE.VERSIONS
*LOCATE 'AA.PAYMENT' IN Y.VERSION.TYPES SETTING POS1 THEN
    IF ('AA.COLLECTION' MATCHES Y.TIPO.DE.VERSIONS) OR ('AA.PAYMENT' MATCHES Y.TIPO.DE.VERSIONS) THEN
        GOSUB UPDATE.DETAILS
        IF R.REDO.LOAN.FT.TT.TXN THEN
            CON.DATE = OCONV(DATE(),"D-")
            DATE.TIME = CON.DATE[9,2]:CON.DATE[1,2]:CON.DATE[4,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]
            R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.DATE.TIME>= DATE.TIME
            R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR  ;*R22 AUTO CODE CONVERSION
            R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR    ;*R22 AUTO CODE CONVERSION
            R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CURR.NO> = 1
            R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CO.CODE>=ID.COMPANY
            CALL F.WRITE(FN.REDO.LOAN.FT.TT.TXN,Y.TT.FT.ID,R.REDO.LOAN.FT.TT.TXN)
        END
    END
RETURN
*-------------------------------------------------------------
UPDATE.DETAILS:
*-------------------------------------------------------------
    Y.TOTAL.AMOUNT = 0
    Y.CASH             = 0
    Y.ACCOUNT.DEBIT    = 0
    Y.CHEQUE           = 0

    CALL F.READ(FN.RTC,Y.TRANS.ID,R.RTC,F.RTC,RTC.ERR)
    Y.RTC.CHQ.REF = R.RTC<RTC.CHEQUE.NO>
    CHANGE @VM TO @SM IN Y.RTC.CHQ.REF
    IF R.RTC ELSE
        RETURN
    END
    Y.TOT.TXN.IDS = R.RTC<RTC.TRANS.ID>
    Y.TXN.CNTS = DCOUNT(Y.TOT.TXN.IDS,@VM)
    Y.VAR1 =  1
    LOOP
    WHILE Y.VAR1 LE Y.TXN.CNTS
        Y.TXN.ID = Y.TOT.TXN.IDS<1,Y.VAR1>
        IF Y.TXN.ID[1,2] EQ 'FT' THEN
            IF Y.VERSION.TYPES<Y.VAR1> MATCHES 'AA.PAYMENT':@VM:'AA.COLLECTION' THEN
                GOSUB GET.TXN.DETAILS
                IF Y.FT.CHQ.NOS THEN
                    R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.FT.TRANSACTION.ID,-1> = Y.TXN.ID
                    R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.LOAN.ID,-1>           = Y.LOAN.NO
                    R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CURRENCY,-1>          = Y.PAYMENT.CUR
                    R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.AMOUNT,-1>            = ABS(R.RTC<RTC.TRANS.AMOUNT,Y.VAR1>)
                    R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.RETURNED.CHQ,-1>      = Y.RTC.CHQ.REF
                    Y.TOTAL.AMOUNT += ABS(R.RTC<RTC.TRANS.AMOUNT,Y.VAR1>)
                END
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

        Y.VAR1 += 1  ;*R22 AUTO CODE CONVERSION
    REPEAT
    Y.TT.FT.ID = Y.TRANS.ID
    IF R.REDO.LOAN.FT.TT.TXN THEN
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.DATE>         = TODAY
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.TOTAL.AMOUNT> = TRIMB(FMT(Y.TOTAL.AMOUNT,'L2#19'))
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CHEQUE.REF>   = R.RTC<RTC.CHEQUE.NO>
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CHQ.AMOUNT>   = TRIMB(FMT(Y.CHEQUE,'L2#19'))
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CASH.AMOUNT>  = TRIMB(FMT(Y.CASH,'L2#19'))
        R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.TRANS.AMOUNT> = TRIMB(FMT(Y.ACCOUNT.DEBIT,'L2#19'))
    END
RETURN
*-------------------------------------------
GET.TXN.DETAILS:
*-------------------------------------------
    R.FT = ''
    IF Y.TXN.ID EQ ID.NEW THEN
        Y.LOAN.NO     = R.NEW(FT.CREDIT.ACCT.NO)
        Y.PAYMENT.CUR = R.NEW(FT.CREDIT.CURRENCY)

    END ELSE
        CALL F.READ(FN.FT,Y.TXN.ID,R.FT,F.FT,FT.ERR)
        IF R.FT ELSE
            CALL F.READ(FN.FT.NAU,Y.TXN.ID,R.FT,F.FT.NAU,FT.ERR)
        END
        Y.LOAN.NO     = R.FT<FT.CREDIT.ACCT.NO>
        Y.PAYMENT.CUR = R.FT<FT.CREDIT.CURRENCY>
        Y.FT.CHQ.NOS  = R.FT<FT.LOCAL.REF,POS.CERT.CHEQUE.NO>

    END
RETURN
*-------------------------------------------
GET.LOC.REF.POS:
*-------------------------------------------

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT  = ''
    CALL OPF(FN.FT,F.FT)

    FN.FT.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FT.NAU  = ''
    CALL OPF(FN.FT.NAU,F.FT.NAU)

    FN.REDO.LOAN.FT.TT.TXN = 'F.REDO.LOAN.FT.TT.TXN'
    F.REDO.LOAN.FT.TT.TXN  = ''
    CALL OPF(FN.REDO.LOAN.FT.TT.TXN,F.REDO.LOAN.FT.TT.TXN)

    FN.RTC = 'F.REDO.TRANSACTION.CHAIN'
    F.RTC  = ''
    CALL OPF(FN.RTC,F.RTC)


    LOC.REF.APPLICATION = "TELLER":@FM:"FUNDS.TRANSFER"
    LOC.REF.FIELDS      = 'L.NEXT.VERSION':@VM:'L.INITIAL.ID':@FM:'L.NEXT.VERSION':@VM:'L.INITIAL.ID':@VM:'CERT.CHEQUE.NO'
    LOC.REF.POS         = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.TT.L.NEXT.VERSION = LOC.REF.POS<1,1>
    POS.TT.L.INITIAL.ID   = LOC.REF.POS<1,2>
    POS.FT.L.NEXT.VERSION = LOC.REF.POS<2,1>
    POS.FT.L.INITIAL.ID   = LOC.REF.POS<2,2>
    POS.CERT.CHEQUE.NO    = LOC.REF.POS<2,3>
RETURN
END
