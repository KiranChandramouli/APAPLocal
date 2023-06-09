$PACKAGE APAP.ATM
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM,VM TO @VM
*-----------------------------------------------------------------------------
SUBROUTINE V.FT.UPD.ATM.KEY.ID

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.ATM.REVERSAL ;*R22 AUTO CONVERSION START
    $INSERT I_AT.ISO.COMMON
    $INSERT I_ATM.BAL.ENQ.COMMON ;*R22 AUTO CONVERSION END
    $INSERT I_F.ACCOUNT
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.APAP.H.PARAMETER ;*R22 AUTO CONVERSION
    $INSERT I_F.CURRENCY
*
    GOSUB INITIALISE
    GOSUB UPDATE.REC
RETURN
*
INITIALISE:
*----------*
*
    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

    Y.MERCHANT = AT$INCOMING.ISO.REQ(42)
*
    REC.AT.REV =''
    LRF.POSN=''

    FIELD.NAM='AT.UNIQUE.ID':@FM:'L.AC.AV.BAL' ;*R22 AUTO CONVERSION
    IF APPLICATION EQ 'AC.LOCKED.EVENTS' THEN     ;* ADDED TO APPEND FTTC WHEN APP IS AC.LOCKED EVENTS

        FIELD.NAM<1,-1> = 'L.FTTC.ID'
        FIELD.NAM<1,-1>='L.TXN.AMT'
        FIELD.NAM<1,-1>='L.CHARGE.AMT'
    END
    L.APP=APPLICATION:@FM:'ACCOUNT' ;*R22 AUTO CONVERSION
    CALL MULTI.GET.LOC.REF(L.APP,FIELD.NAM,LRF.POSN)
    LRF.POS1=LRF.POSN<1,1>
    LRF.POS2=LRF.POSN<2,1>
    FLD1=FIELD.NAM<1>
    FLD.CNT=DCOUNT(FLD1,@VM) ;*R22 AUTO CONVERSION
    LRF.POS3=LRF.POSN<1,FLD.CNT-2>      ;* ADDED TO APPEND FTTC WHEN APP IS AC.LOCKED EVENTS
    LRF.POS4=LRF.POSN<1,FLD.CNT-1>
    LRF.POS5=LRF.POSN<1,FLD.CNT>

    BEGIN CASE

        CASE APPLICATION EQ 'FUNDS.TRANSFER'

            LRF.FIELD=FT.LOCAL.REF

* Fix for 2795720 [BRD001 - FAST FUNDS SERVICES]

            IF AT$INCOMING.ISO.REQ(3)[1,2] EQ '26' THEN
                REC.AT.REV<AT.REV.ACCOUNT.NUMBER>=R.NEW(FT.CREDIT.ACCT.NO)
                GET.SENDER.INFO = AT$INCOMING.ISO.REQ(104)[10,255]
                REC.AT.REV<AT.REV.OCT.SENDER.INFO,1> = GET.SENDER.INFO[1,16]
                REC.AT.REV<AT.REV.OCT.SENDER.INFO,2> = GET.SENDER.INFO[17,34]
                REC.AT.REV<AT.REV.OCT.SENDER.INFO,3> = GET.SENDER.INFO[51,30]
                REC.AT.REV<AT.REV.OCT.SENDER.INFO,4> = GET.SENDER.INFO[81,35]
                REC.AT.REV<AT.REV.OCT.SENDER.INFO,5> = GET.SENDER.INFO[116,25]
                REC.AT.REV<AT.REV.OCT.SENDER.INFO,6> = GET.SENDER.INFO[141,2]
                REC.AT.REV<AT.REV.OCT.SENDER.INFO,7> = GET.SENDER.INFO[143,3]
                REC.AT.REV<AT.REV.OCT.SENDER.INFO,8> = GET.SENDER.INFO[146,2]
            END ELSE

* End of Fix

                REC.AT.REV<AT.REV.ACCOUNT.NUMBER>=R.NEW(FT.DEBIT.ACCT.NO)
            END
            Y.TXN.AMT=R.NEW(FT.CREDIT.AMOUNT)

* TFR REPORT 89
            REC.AT.REV<AT.REV.TXN.CHRG>=R.NEW(FT.TOT.SND.CHG.CRCCY)
* TFR REPORT 89

        CASE APPLICATION EQ 'AC.LOCKED.EVENTS'

            LRF.FIELD=AC.LCK.LOCAL.REF
            LCK.AMT=R.NEW(AC.LCK.LOCKED.AMOUNT)
            REC.AT.REV<AT.REV.ACCOUNT.NUMBER>=R.NEW(AC.LCK.ACCOUNT.NUMBER)
            REC.AT.REV<AT.REV.BILLING.AMT> =LCK.AMT
            REC.AT.REV<AT.REV.FTTC.ID>=R.NEW(AC.LCK.LOCAL.REF)<1,LRF.POS3>
            Y.TXN.AMT=R.NEW(AC.LCK.LOCAL.REF)<1,LRF.POS4>
            REC.AT.REV<AT.REV.TXN.CHRG>=R.NEW(AC.LCK.LOCAL.REF)<1,LRF.POS5>

    END CASE

    IF Y.MERCHANT[15,1] EQ 'P' THEN

        REC.AT.REV<AT.REV.ACCOUNT.NUMBER>=Y.CERITO.ACCT

        REC.AT.REV<AT.REV.LY.PTS.US.REF>=Y.ID.CERITOS
        REC.AT.REV<AT.REV.PTS.USED>=Y.TXN.PTS
        TXN.SOURCE="Ceritos Txn"

    END

    Y.TXN.AMT1=FIELD(Y.TXN.AMT,'.',2)
    Y.TXN.AMT2=FIELD(Y.TXN.AMT,'.',1)
    Y.TXN.AMT1=FMT(Y.TXN.AMT1,'L%2')
    Y.TXN.AMT=Y.TXN.AMT2:'.':Y.TXN.AMT1
    REC.AT.REV<AT.REV.TRANSACTION.AMOUNT>=Y.TXN.AMT
    REC.AT.REV<AT.REV.TXN.AMOUNT> = Y.TXN.AMT
    ACCT.NUM=REC.AT.REV<AT.REV.ACCOUNT.NUMBER>

    IF R.ACCOUNT NE '' AND R.ACCOUNT NE '0' THEN

* Fix for 2795720 [BRD001 - FAST FUNDS SERVICES #2]

        IF AT$INCOMING.ISO.REQ(3)[1,2] EQ '26' THEN
            Y.OCT.ACCT = R.NEW(FT.CREDIT.ACCT.NO)
            FN.ACCOUNT = 'F.ACCOUNT'
            F.ACCOUNT = ''
            CALL OPF(FN.ACCOUNT,F.ACCOUNT)
            CALL F.READ(FN.ACCOUNT,Y.OCT.ACCT,R.OCT.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
            ALT.ACCT = R.OCT.ACCOUNT<AC.ALT.ACCT.ID,1>
            AVL.BAL  = R.OCT.ACCOUNT<AC.LOCAL.REF><1,LRF.POS2>
        END ELSE

* End of Fix

            ALT.ACCT = R.ACCOUNT<AC.ALT.ACCT.ID,1>
            AVL.BAL  = R.ACCOUNT<AC.LOCAL.REF><1,LRF.POS2>
        END

        LCK.AMT=AVL.BAL
        LCK.AMT.DEC=FIELDS(LCK.AMT,".",2)
        LCK.AMT.VAL=FIELDS(LCK.AMT,".",1)
        LCK.AMT.DEC=FMT(LCK.AMT.DEC,"L%2")
        LCK.AMT=LCK.AMT.VAL:".":LCK.AMT.DEC
        AVL.BAL=LCK.AMT

        REC.AT.REV<AT.REV.ACCOUNT.NUMBER.OLD>=ALT.ACCT
        REC.AT.REV<AT.REV.AVAILABLE.BALANCE>= AVL.BAL
    END
    FN.REDO.APAP.H.PARAMETER='F.REDO.APAP.H.PARAMETER'
    F.REDO.APAP.H.PARAMETER=''
    CALL OPF(FN.REDO.APAP.H.PARAMETER,F.REDO.APAP.H.PARAMETER)

    CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,'SYSTEM',R.REDO.APAP.H.PARAMETER,ERR.PARAM)
    Y.AFFL.PRESENTAGE=R.REDO.APAP.H.PARAMETER<PARAM.ACQUIRER.PER>

    FN.REDO.ATM.ACQUIRER='F.REDO.ATM.ACQUIRER'
    F.REDO.ATM.ACQUIRER=''
    CALL OPF(FN.REDO.ATM.ACQUIRER,F.REDO.ATM.ACQUIRER)

* Fix for 2795723 [BRD003 UNARED #1]

    FN.REDO.ATM.WAIVE.CHARGE = 'F.REDO.ATM.WAIVE.CHARGE'
    F.REDO.ATM.WAIVE.CHARGE  = ''
    CALL OPF(FN.REDO.ATM.WAIVE.CHARGE,F.REDO.ATM.WAIVE.CHARGE)

* End of Fix

RETURN          ;*From initialise
*

*------------------------------------------------------------------------*
UPDATE.REC:
*---------*
*Commented by liril

    MSG.TYPE=AT$INCOMING.ISO.REQ(1)
    RET.MSG.TYPE=MSG.TYPE+10
    RET.MSG.TYPE=FMT(RET.MSG.TYPE,"R%4")
    REC.AT.REV<AT.REV.MTI.RESP>=RET.MSG.TYPE

    AT.REV.ID  = R.NEW(LRF.FIELD)<1,LRF.POS1>

    REC.AT.REV<AT.REV.TRANSACTION.ID>=ID.NEW
    REC.AT.REV<AT.REV.TXN.DATE> =TODAY
    REC.AT.REV<AT.REV.PROCESS.CODE>=AT$INCOMING.ISO.REQ(3)
    REC.AT.REV<AT.REV.CARD.NUMBER>=AT$INCOMING.ISO.REQ(2)

    REC.AT.REV<AT.REV.MESSAGE.TYPE>=AT$INCOMING.ISO.REQ(1)
    REC.AT.REV<AT.REV.TRACE>=AT$INCOMING.ISO.REQ(11)
    REC.AT.REV<AT.REV.RESPONSE.CODE>='00'

    Y.AUTH.CODE=FIELD(AT.REV.ID,'.',2)

    IF LEN(Y.AUTH.CODE) GT 6 THEN
        Y.AUTH.CODE=AT$INCOMING.ISO.REQ(38)
    END

    REC.AT.REV<AT.REV.AUTH.CODE>=Y.AUTH.CODE

    REC.AT.REV<AT.REV.REFERENCE.NO>=AT$INCOMING.ISO.REQ(37)
    REC.AT.REV<AT.REV.LOCAL.DATE>=AT$INCOMING.ISO.REQ(13)
    REC.AT.REV<AT.REV.LOCAL.TIME>=AT$INCOMING.ISO.REQ(12)
    SYS.DATE=OCONV(DATE(),'D4')
    REC.AT.REV<AT.REV.CAPTURE.DATE>=SYS.DATE
    REC.AT.REV<AT.REV.TERM.ID>=AT$INCOMING.ISO.REQ(41)
    REC.AT.REV<AT.REV.MERCHANT.ID>=AT$INCOMING.ISO.REQ(42)
    REC.AT.REV<AT.REV.ACCEPTOR.NAME>=AT$INCOMING.ISO.REQ(43)
    REC.AT.REV<AT.REV.EXCH.RATE>=EXH.RATE
    REC.AT.REV<AT.REV.ISSUER>=AT$INCOMING.ISO.REQ(2)[1,6]
    REC.AT.REV<AT.REV.TRANS.DATE.TIME>=AT$INCOMING.ISO.REQ(7)
    REC.AT.REV<AT.REV.T24.DATE>=TODAY
    REC.AT.REV<AT.REV.TXN.REF>=ID.NEW
    REC.AT.REV<AT.REV.VISA.STLMT.REF>=''
    REC.AT.REV<AT.REV.VISA.CHGBCK.REF>=''
    REC.AT.REV<AT.REV.POS.COND>=AT$INCOMING.ISO.REQ(25)
    REC.AT.REV<AT.REV.DEST.CCY>=  AT$INCOMING.ISO.REQ(51)
    REC.AT.REV<AT.REV.CURRENCY.CODE>=AT$INCOMING.ISO.REQ(49)
    REC.AT.REV<AT.REV.CPS.AUT.CHR.IND>=AT$INCOMING.ISO.REQ(62)[1,1]
    REC.AT.REV<AT.REV.CPS.TXN.IDEN>   =AT$INCOMING.ISO.REQ(62)[2,15]
    REC.AT.REV<AT.REV.CPS.VAL.CODE>   =AT$INCOMING.ISO.REQ(62)[17,4]

* Fix for 2795723 [BRD003 UNARED #2]

    GET.TERMINAL.ID  = TRIM(AT$INCOMING.ISO.REQ(41))
    GET.TRANS.SOURCE = AT$INCOMING.ISO.REQ(32)
    ATM.WAIVE = GET.TERMINAL.ID:'-':GET.TRANS.SOURCE
    CALL F.READ(FN.REDO.ATM.WAIVE.CHARGE,ATM.WAIVE,R.REDO.ATM.WAIVE.CHARGE,F.REDO.ATM.WAIVE.CHARGE,ERR.REDO.ATM.WAIVE.CHARGE)

    IF NOT(R.REDO.ATM.WAIVE.CHARGE) THEN
        ERR.REDO.ATM.WAIVE.CHARGE = ''
        ATM.WAIVE = GET.TERMINAL.ID[1,4]:'*-':GET.TRANS.SOURCE
        CALL F.READ(FN.REDO.ATM.WAIVE.CHARGE,ATM.WAIVE,R.REDO.ATM.WAIVE.CHARGE,F.REDO.ATM.WAIVE.CHARGE,ERR.REDO.ATM.WAIVE.CHARGE)
    END

    IF R.REDO.ATM.WAIVE.CHARGE THEN
        REC.AT.REV<AT.REV.WAIVE.FLAG> = 'Y'
    END

* End of Fix

    ISO.CONV.RATE=AT$INCOMING.ISO.REQ(10)
    DEC.POS=ISO.CONV.RATE[1,1]
    CONV.AMT=ISO.CONV.RATE[2,7]
    CONV.AMT= STR("0",(9-LEN(CONV.AMT))):CONV.AMT
    DEC.PRE=9-DEC.POS
    DEC.VAL=9-DEC.PRE
    IF DEC.VAL EQ 0 THEN
        Y.DEC.VAL=''
    END ELSE
        Y.DEC.VAL= ".":CONV.AMT[DEC.PRE+1,DEC.VAL]
    END

    IF DEC.PRE EQ 0 THEN
        Y.CONV.RATE ="0.":CONV.AMT
    END ELSE


        Y.CONV.RATE=CONV.AMT[1,DEC.PRE] * 1:Y.DEC.VAL

    END

    REC.AT.REV<AT.REV.CONVERSION.RATE>=Y.CONV.RATE
    REC.AT.REV<AT.REV.FRAUD.REF.NO>=''
    REC.AT.REV<AT.REV.DEST.AMT>=AT$INCOMING.ISO.REQ(6)
    REC.AT.REV<AT.REV.MRCHT.CATEG>=AT$INCOMING.ISO.REQ(18)
    REC.AT.REV<AT.REV.POS.ENTRY.MOD>=AT$INCOMING.ISO.REQ(22)[1,2]
    REC.AT.REV<AT.REV.TRANSACTION.FEE>=AT$INCOMING.ISO.REQ(28)
    REC.AT.REV<AT.REV.CARD.EXPIRY>=AT$INCOMING.ISO.REQ(14)
    REC.AT.REV<AT.REV.ACQ.COUNTRY.CDE>=AT$INCOMING.ISO.REQ(19)
    REC.AT.REV<AT.REV.ACQ.INST.CDE>=AT$INCOMING.ISO.REQ(32)
    REC.AT.REV<AT.REV.FWD.INST.CDE>=AT$INCOMING.ISO.REQ(33)
    REC.AT.REV<AT.REV.ADD.AMT>=AT$INCOMING.ISO.REQ(54)

    IF TXN.SOURCE EQ 0 OR TXN.SOURCE EQ '' THEN

        BEGIN CASE

            CASE AT$INCOMING.ISO.REQ(3)[1,2] EQ '01' AND (AT$INCOMING.ISO.REQ(32) EQ '1' OR AT$INCOMING.ISO.REQ(32) EQ '01')
                TXN.SOURCE='APAP ATM'
            CASE (AT$INCOMING.ISO.REQ(3)[1,2] EQ '00' OR AT$INCOMING.ISO.REQ(3)[1,2] EQ '15' OR AT$INCOMING.ISO.REQ(3)[1,2] EQ '09' OR AT$INCOMING.ISO.REQ(3)[1,2] EQ '14') AND (AT$INCOMING.ISO.REQ(32) EQ '1' OR AT$INCOMING.ISO.REQ(32) EQ '01')
                TXN.SOURCE='APAP POS'

        END CASE
    END

    REC.AT.REV<AT.REV.TXN.SOURCE>=TXN.SOURCE
    Y.CHG=REC.AT.REV<AT.REV.TXN.CHRG>
    IF TXN.SOURCE EQ 'AFFL POS' AND (Y.AFFL.PRESENTAGE GT 0 OR Y.AFFL.PRESENTAGE NE '') AND Y.CHG GT 0 THEN
        DEC.PTS=C$R.LCCY<EB.CUR.NO.OF.DECIMALS>
        Y.AFFL.CHG =Y.CHG * (Y.AFFL.PRESENTAGE/100)
        Y.AFFL.CHG.DEC=FIELD(Y.AFFL.CHG,".",2)
        Y.AFFL.CHG.VAL=FIELD(Y.AFFL.CHG,".",1)
        Y.AFFL.CHG.DEC=FMT(Y.AFFL.CHG.DEC,"L%":DEC.PTS)
        Y.AFFL.CHG=Y.AFFL.CHG.VAL:".":Y.AFFL.CHG.DEC
        REC.AT.REV<AT.REV.AFL.CHRG>=Y.AFFL.CHG
    END

    IF AT.REV.ID THEN
        CALL F.READ(FN.ATM.REVERSAL,AT.REV.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ER.ATM.REVERSAL)
        IF R.ATM.REVERSAL THEN
            REC.AT.REV<AT.REV.TRANSACTION.ID> =ID.NEW
            IF NOT(TXN.SOURCE) THEN
                TXN.SOURCE=R.ATM.REVERSAL<AT.REV.TXN.SOURCE>
                REC.AT.REV<AT.REV.TXN.SOURCE>=TXN.SOURCE
            END
        END

        CALL F.WRITE(FN.ATM.REVERSAL,AT.REV.ID,REC.AT.REV)

    END

    R.REDO.ATM.ACQUIRER=''
    AT.REF.ID=''
    AT.REF.ID=AT$INCOMING.ISO.REQ(2):".":AT$INCOMING.ISO.REQ(38)

    CALL F.READ(FN.REDO.ATM.ACQUIRER,AT.REF.ID,R.REDO.ATM.ACQUIRER,F.REDO.ATM.ACQUIRER,ERR.ACQ)

    LOCATE AT.REV.ID IN R.REDO.ATM.ACQUIRER<1> SETTING POS.REV ELSE
        INS AT.REV.ID BEFORE R.REDO.ATM.ACQUIRER<1>
        CALL F.WRITE(FN.REDO.ATM.ACQUIRER,AT.REF.ID,R.REDO.ATM.ACQUIRER)        ;*Tus End
    END

RETURN          ;*From update.rec

END
*----------------------------------------------------------------------*
