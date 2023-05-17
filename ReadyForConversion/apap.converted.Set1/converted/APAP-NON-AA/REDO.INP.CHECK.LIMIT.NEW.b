SUBROUTINE REDO.INP.CHECK.LIMIT.NEW
*----------------------------------------------------------------
*Description: This routine is to check the limit of customer account

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.LIMIT
    $INSERT I_F.USER
    $INSERT I_F.REDO.APAP.CLEARING.INWARD
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.MANAGER.CHQ.PARAM
    $INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS
    $INSERT I_F.REDO.MANAGER.CHQ.DETAILS
    $INSERT I_F.CERTIFIED.CHEQUE.DETAILS
    $INSERT I_F.REDO.REJECT.REASON
*Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*Tus End

    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB UPDATE.STATUS
RETURN
*----------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.LIMIT = 'F.LIMIT'
    F.LIMIT = ''
    CALL OPF(FN.LIMIT,F.LIMIT)

    FN.REDO.REJECT.REASON = 'F.REDO.REJECT.REASON'
    F.REDO.REJECT.REASON = ''
    CALL OPF(FN.REDO.REJECT.REASON,F.REDO.REJECT.REASON)

    FN.REDO.ADMIN.CHQ.PARAM   = 'F.REDO.ADMIN.CHQ.PARAM'
    F.REDO.ADMIN.CHQ.PARAM = ''
    CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)

    FN.REDO.ADMIN.CHQ.DETAILS = 'F.REDO.ADMIN.CHQ.DETAILS'
    F.REDO.ADMIN.CHQ.DETAILS = ''
    CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)

    FN.CERTIFIED.CHEQUE.PARAMETER = 'F.CERTIFIED.CHEQUE.PARAMETER'
    F.CERTIFIED.CHEQUE.PARAMETER = ''
    CALL OPF(FN.CERTIFIED.CHEQUE.PARAMETER,F.CERTIFIED.CHEQUE.PARAMETER)

    FN.CERTIFIED.CHEQUE.DETAILS   = 'F.CERTIFIED.CHEQUE.DETAILS'
    F.CERTIFIED.CHEQUE.DETAILS = ''
    CALL OPF(FN.CERTIFIED.CHEQUE.DETAILS,F.CERTIFIED.CHEQUE.DETAILS)
RETURN
*----------------------------------------------------------------
FIND.MULTI.LOC.REF:
*----------------------------------------------------------------
    APPL.ARRAY = 'ACCOUNT':@FM:'USER'
    FLD.ARRAY = 'L.AC.AV.BAL':@VM:'L.AC.TRAN.AVAIL':@VM:'L.AC.TRANS.LIM':@FM:'L.US.APPROV.LIM'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    Y.L.AC.AV.BAL.POS     = FLD.POS<1,1>
    Y.L.AC.TRAN.AVAIL.POS = FLD.POS<1,2>
    Y.L.AC.TRANS.LIM.POS  = FLD.POS<1,3>
    POS.L.US.APPROV.LIM   = FLD.POS<2,1>

RETURN
*----------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------

    GOSUB FIND.MULTI.LOC.REF
    Y.CHEQUE.AMT      = R.NEW(CLEAR.CHQ.AMOUNT)
    Y.ACCOUNT.NO      = R.NEW(CLEAR.CHQ.ACCOUNT.NO)
    Y.WAIVE.CHARGE    = R.NEW(CLEAR.CHQ.WAIVE.CHARGES)
    Y.CHARGE.AMT      = R.NEW(CLEAR.CHQ.CHG.AMOUNT)
    Y.OLD.STATUS      = R.OLD(CLEAR.CHQ.STATUS)
    Y.STATUS          = R.NEW(CLEAR.CHQ.STATUS)
    Y.REFER.NAME      = R.NEW(CLEAR.CHQ.REFER.NAME)
    Y.USER            = OPERATOR
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT THEN
        Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
        Y.ACCT.OFFICER = R.ACCOUNT<AC.ACCOUNT.OFFICER>
        Y.CATEGORY = R.ACCOUNT<AC.CATEGORY>
        Y.CURRENCY  = R.ACCOUNT<AC.CURRENCY>
    END
    GOSUB AUTO.REFER.PAID.ENTRY
    GOSUB MANUAL.REFER.PAID.ENTRY

    IF Y.OLD.STATUS EQ 'REFERRED' AND Y.STATUS EQ 'REJECTED' THEN
        Y.REASON =  R.NEW(CLEAR.CHQ.REASON)
        CALL F.READ(FN.REDO.REJECT.REASON,Y.REASON,R.REDO.REJECT.REASON,F.REDO.REJECT.REASON,ERR.REJ)
        IF R.REDO.REJECT.REASON<REDO.REJ.RETURN.CODE> ELSE
            ETEXT = 'EB-REDO.MISS.REJ.CODE'
            CALL STORE.END.ERROR
        END
    END

RETURN

**********************
AUTO.REFER.PAID.ENTRY:
**********************

    IF (Y.OLD.STATUS EQ 'REFERRED' AND Y.STATUS EQ 'PAID' AND Y.REFER.NAME EQ 'SYSTEM') THEN

        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
        R.ECB='' ; ECB.ERR= '' ;*Tus Start
        CALL EB.READ.HVT("EB.CONTRACT.BALANCES",Y.ACCOUNT.NO,R.ECB,ECB.ERR);*Tus End
        IF R.ACCOUNT THEN
            Y.LIMIT.REF   = R.ACCOUNT<AC.LIMIT.REF>
            Y.CUSTOMER    = R.ACCOUNT<AC.CUSTOMER>
*     Y.WORKING.BAL = R.ACCOUNT<AC.WORKING.BALANCE>;*Tus Start
            Y.WORKING.BAL = R.ECB<ECB.WORKING.BALANCE>;*Tus End
            Y.LOCKED.AMT  = R.ACCOUNT<AC.LOCKED.AMOUNT>
            Y.TRANS.AVAIL.AMT = R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.TRAN.AVAIL.POS>
            Y.TRANS.LIMIT.AMT = R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.TRANS.LIM.POS>
            Y.AVAILABLE.BAL   = R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.AV.BAL.POS>
        END


        IF Y.LIMIT.REF NE '' THEN
            Y.LIMIT.REF = FMT(Y.LIMIT.REF,'R%10')
            LIMIT.ID = Y.CUSTOMER : '.' : Y.LIMIT.REF
            CALL F.READ(FN.LIMIT,LIMIT.ID,R.LIMIT,F.LIMIT,LIMIT.ERR)

            IF R.LIMIT THEN
                VAR.AVAIL.AMT = R.LIMIT<LI.AVAIL.AMT>
            END

            Y.CAL.BAL = Y.AVAILABLE.BAL + VAR.AVAIL.AMT + Y.TRANSIT.FUND
        END ELSE
            Y.CAL.BAL = Y.AVAILABLE.BAL + Y.TRANSIT.FUND
        END


        Y.CUR.ACC.NO   = Y.ACCOUNT.NO[1,3]
        IF NUM(Y.CUR.ACC.NO) THEN
            IF Y.CAL.BAL LT Y.CHEQUE.AMT THEN
                AF = CLEAR.CHQ.AMOUNT
                ETEXT = "EB-INSUFFICIENT.FUND"
                CALL STORE.END.ERROR
            END
        END ELSE
            GOSUB ADMIN.CHEQUES.DETAILS
        END
    END
RETURN
************************
MANUAL.REFER.PAID.ENTRY:
************************

    IF (Y.OLD.STATUS EQ 'REFERRED' AND Y.STATUS EQ 'PAID') THEN

        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
        R.ECB='' ; ECB.ERR= '' ;*Tus Start
        CALL EB.READ.HVT("EB.CONTRACT.BALANCES",Y.ACCOUNT.NO,R.ECB,ECB.ERR);*Tus End
        IF R.ACCOUNT THEN
            Y.LIMIT.REF   = R.ACCOUNT<AC.LIMIT.REF>
            Y.CUSTOMER    = R.ACCOUNT<AC.CUSTOMER>
*   Y.WORKING.BAL = R.ACCOUNT<AC.WORKING.BALANCE>;*Tus Start
            Y.WORKING.BAL = R.ECB<ECB.WORKING.BALANCE>;*Tus End
            Y.LOCKED.AMT  = R.ACCOUNT<AC.LOCKED.AMOUNT>
            Y.TRANS.AVAIL.AMT = R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.TRAN.AVAIL.POS>
            Y.TRANS.LIMIT.AMT = R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.TRANS.LIM.POS>
            Y.AVAILABLE.BAL   = R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.AV.BAL.POS>
        END

        IF Y.TRANS.AVAIL.AMT GT Y.TRANS.LIMIT.AMT THEN
            Y.TRANSIT.FUND = Y.TRANS.LIMIT.AMT
        END ELSE
            Y.TRANSIT.FUND = Y.TRANS.AVAIL.AMT
        END
        Y.USER.APPROVE.LIMIT = R.USER<EB.USE.LOCAL.REF,POS.L.US.APPROV.LIM>
        IF Y.LIMIT.REF NE '' THEN
            LIMIT.ID = Y.CUSTOMER : '.' : Y.LIMIT.REF
            CALL F.READ(FN.LIMIT,LIMIT.ID,R.LIMIT,F.LIMIT,LIMIT.ERR)
            IF R.LIMIT THEN
                VAR.AVAIL.AMT = R.LIMIT<LI.AVAIL.AMT>
            END

            Y.CAL.BAL = Y.AVAILABLE.BAL + VAR.AVAIL.AMT + Y.TRANSIT.FUND
        END ELSE
            Y.CAL.BAL = Y.AVAILABLE.BAL + Y.TRANSIT.FUND
        END


        Y.CAL.BAL += Y.USER.APPROVE.LIMIT
        Y.CUR.ACC.NO   = Y.ACCOUNT.NO[1,3]
        IF NUM(Y.CUR.ACC.NO) THEN
            IF Y.CAL.BAL LT Y.CHEQUE.AMT THEN
                AF = CLEAR.CHQ.AMOUNT
                ETEXT = "EB-INSUFFICIENT.FUND"
                CALL STORE.END.ERROR
            END
        END ELSE
            GOSUB ADMIN.CHEQUES.DETAILS
        END
    END
RETURN


**********************
ADMIN.CHEQUES.DETAILS:
**********************
    Y.CHEQUE.NO = TRIM(R.NEW(CLEAR.CHQ.CHEQUE.NO),'0','L')
    Y.ADMIN.AMT = ''
    Y.ADMIN.FLAG = ''
    Y.CATEG.ACC.NUM = Y.ACCOUNT.NO[4,5]

*  CALL F.READ(FN.REDO.ADMIN.CHQ.PARAM,'SYSTEM',R.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM,REDO.ADMIN.CHQ.PARAM.ERR) ;*Tus Start
    CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,'SYSTEM',R.REDO.ADMIN.CHQ.PARAM,REDO.ADMIN.CHQ.PARAM.ERR) ; * Tus End
    Y.ADMIN.ACCTS = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT>
    CHANGE @VM TO @FM IN Y.ADMIN.ACCTS

    LOCATE Y.ACCOUNT.NO IN Y.ADMIN.ACCTS SETTING ADM.CHQ.POS THEN
        CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NO,R.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,REDO.ADMIN.CHQ.DETAILS.ERR)
        Y.ADMIN.AMT  = R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.AMOUNT>
        Y.ADMIN.FLAG = 1
    END

    Y.ID.COMPANY = ID.COMPANY
*CALL F.READ(FN.CERTIFIED.CHEQUE.PARAMETER,Y.ID.COMPANY,R.CERTIFIED.CHEQUE.PARAMETER,F.CERTIFIED.CHEQUE.PARAMETER,CERTIFIED.CHEQUE.PARAMETER.ERR); *Tus Start
    CALL CACHE.READ(FN.CERTIFIED.CHEQUE.PARAMETER,Y.ID.COMPANY,R.CERTIFIED.CHEQUE.PARAMETER,CERTIFIED.CHEQUE.PARAMETER.ERR) ; * Tus End
    Y.CERT.ACCTS = R.CERTIFIED.CHEQUE.PARAMETER<CERT.CHEQ.ACCOUNT.NO>
    CHANGE @VM TO @FM IN Y.CERT.ACCTS

    LOCATE Y.ACCOUNT.NO IN Y.CERT.ACCTS SETTING CERT.POS THEN
        CALL F.READ(FN.CERTIFIED.CHEQUE.DETAILS,Y.CHEQUE.NO,R.CERTIFIED.CHEQUE.DETAILS,F.CERTIFIED.CHEQUE.DETAILS,CERTIFIED.CHEQUE.DETAILS.ERR)
        Y.ADMIN.AMT = R.CERTIFIED.CHEQUE.DETAILS<CERT.DET.AMOUNT>
    END

    IF Y.ADMIN.AMT NE Y.CHEQUE.AMT THEN
        AF = CLEAR.CHQ.AMOUNT
        ETEXT = "EB-AMOUNT.NOT.MATCH"
        CALL STORE.END.ERROR
    END ELSE
        IF Y.ADMIN.FLAG THEN
            R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS> = 'PAID'
            CALL F.WRITE(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NO,R.REDO.ADMIN.CHQ.DETAILS)
        END ELSE
            R.CERTIFIED.CHEQUE.DETAILS<CERT.DET.STATUS> = 'PAID'
            CALL F.WRITE(FN.CERTIFIED.CHEQUE.DETAILS,Y.CHEQUE.NO,R.CERTIFIED.CHEQUE.DETAILS)
        END
    END
RETURN
UPDATE.STATUS:
    Y.CHEQUE.NO = TRIM(R.NEW(CLEAR.CHQ.CHEQUE.NO),'0','L')
    IF Y.STATUS EQ 'REJECTED' THEN

        CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NO,R.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,REDO.ADMIN.CHQ.DETAILS.ERR)
        R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS> = 'ISSUED'
        CALL F.WRITE(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NO,R.REDO.ADMIN.CHQ.DETAILS)
    END

RETURN
END
