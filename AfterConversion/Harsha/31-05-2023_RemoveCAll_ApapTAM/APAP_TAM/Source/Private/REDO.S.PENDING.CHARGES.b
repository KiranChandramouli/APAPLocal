* @ValidationCode : MjotMTkxMTU5MTg1NzpDcDEyNTI6MTY4NDQ5MTAzODc3NjpJVFNTOi0xOi0xOjQwNTE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 4051
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.S.PENDING.CHARGES(APPL.TYPE,OPERATION.TYPE,STMT.ENT.ID,STMT.RECORD,NCF.NT.REQ)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is to update PENDING.CHARGES table and REPAYMENT.CHARGES table
* INPUT/OUTPUT:
*--------------
* IN : APPL.TYPE, OPERATION.TYPE, STMT.ENT.ID, STMT.RECORD
* OUT :
*-------------------------------------------------------------------------
* CALLED BY : REDO.S.ACCOUNT.PARAM
* ------------------------------------------------------------------------
*   Date               who           Reference            Description
* 10-JAN-2010     SHANKAR RAJU     ODR-2009-10-0529     Initial Creation
* 15-MAR-2011     SHANKAR RAJU     PACS00024242         Masking & Removing Partial Payment and Recovery
* 12-MAY-2011     SHANKAR RAJU     PACS00055362         Break the loop if the amount is not available to recover the full first pending charge
*23-AUG-2011      Prabhu N         PACS00055362         Modified from OFS message to write
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION        FM TO @FM, VM TO @VM, SM TO @SM,++ TO +=, -- TO -=, X TO X.VAR
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-------------------------------------------------------------------------
* Prefix IN - value taken from incoming argument "STMT.RECORD"
* Prefix CAL - value are calculated

    $INSERT I_COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.USER
    $INSERT I_F.REDO.CHARGE.PARAM
    $INSERT I_F.REDO.PENDING.CHARGE
    $INSERT I_F.REDO.REPAYMENT.CHARGE
    $INSERT I_F.REDO.AC.PRINT.MASK
    $INSERT I_F.AC.PRINT.MASK
*Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*Tus End


    Y.TEMP.V=V
    IF STMT.RECORD AND APPL.TYPE EQ "STMT" AND STMT.RECORD<AC.STE.SYSTEM.ID> NE "ACPC" THEN
        GOSUB INITIALSE
        GOSUB CHECK.ACCT.CATEG
    END
    IF STMT.RECORD<AC.STE.SYSTEM.ID> EQ "ACPC" THEN
        GOSUB RAISE.PRINT.MASK
    END
    V=Y.TEMP.V
RETURN
*-------------------------------------------------------------------------
RAISE.PRINT.MASK:
*~~~~~~~~~~~~~~~~
    FN.REDO.AC.PRINT.MASK='F.REDO.AC.PRINT.MASK'
    F.REDO.AC.PRINT.MASK=''
    CALL OPF(FN.REDO.AC.PRINT.MASK,F.REDO.AC.PRINT.MASK)

    Y.CORE.ENT.ID = C$SPARE(99)
    Y.CURR.ID     = STMT.ENT.ID
    IN.ACCT.NO    = STMT.RECORD<AC.STE.ACCOUNT.NUMBER>
    R.AC.PRINT.MASK = ''
    IF IN.ACCT.NO NE '' THEN
        IF RUNNING.UNDER.BATCH THEN
            R.REDO.AC.PRINT.MASK<REDO.AC.ACCOUNT.NO> = IN.ACCT.NO
            R.REDO.AC.PRINT.MASK<REDO.AC.MASK.DATE>  = TODAY
            R.REDO.AC.PRINT.MASK<REDO.AC.START.DATE> = TODAY
            R.REDO.AC.PRINT.MASK<REDO.AC.END.DATE> = TODAY
            R.REDO.AC.PRINT.MASK<REDO.AC.MASK> = 'YES'
            R.REDO.AC.PRINT.MASK<REDO.AC.MASK.NARRATIVE> = 'MASKING.FOR.UNPAID.CHARGES'
            R.REDO.AC.PRINT.MASK<REDO.AC.MATCHED.TO>   = Y.CURR.ID
            R.REDO.AC.PRINT.MASK<REDO.AC.MATCHED.FROM> = Y.CORE.ENT.ID
            CALL F.WRITE(FN.REDO.AC.PRINT.MASK,Y.CORE.ENT.ID,R.REDO.AC.PRINT.MASK)
        END
        ELSE
            R.AC.PRINT.MASK<AC.MSK.ACCOUNT.NO> = IN.ACCT.NO
            R.AC.PRINT.MASK<AC.MSK.MASK.DATE>  = TODAY
            R.AC.PRINT.MASK<AC.MSK.ENQ.START.DATE> = TODAY
            R.AC.PRINT.MASK<AC.MSK.ENQ.END.DATE> = TODAY
            R.AC.PRINT.MASK<AC.MSK.MASK> = 'YES'
            R.AC.PRINT.MASK<AC.MSK.MASK.NARRATIVE> = 'MASKING.FOR.UNPAID.CHARGES'
            R.AC.PRINT.MASK<AC.MSK.MATCHED.TO>   = Y.CURR.ID
            R.AC.PRINT.MASK<AC.MSK.MATCHED.FROM> = Y.CORE.ENT.ID
            APP.NAME = 'AC.PRINT.MASK'
            OFSFUNCT = 'I'
            PROCESS  = 'PROCESS'
            OFSVERSION = 'AC.PRINT.MASK,OFS'
            Y.GTSMODE = ''
            NO.OF.AUTH = '0'
            TRANSACTION.ID = ''
            OFSRECORD = ''
            OFS.MSG.ID =''
            OFS.SOURCE.ID = 'REDO.AC.PRINT.MASK'
            OFS.ERR = ''
            CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,Y.GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.AC.PRINT.MASK,OFSRECORD)
            CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
        END
    END
RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~
    R.ACC.ARR = ''
    FN.CHARGE.PARAM = 'F.REDO.CHARGE.PARAM'
    F.CHARGE.PARAM = ''
    CALL OPF(FN.CHARGE.PARAM,F.CHARGE.PARAM)
    FN.PENDING.CHARGE = 'F.REDO.PENDING.CHARGE'
    F.PENDING.CHARGE = ''
    CALL OPF(FN.PENDING.CHARGE,F.PENDING.CHARGE)
    FN.PENDING.CHARGE.HIS = 'F.REDO.PENDING.CHARGE$HIS'
    F.PENDING.CHARGE.HIS  = ''
    CALL OPF(FN.PENDING.CHARGE.HIS,F.PENDING.CHARGE.HIS)
    FN.REPAYMENT.CHARGE = 'F.REDO.REPAYMENT.CHARGE'
    F.REPAYMENT.CHARGE = ''
    CALL OPF(FN.REPAYMENT.CHARGE,F.REPAYMENT.CHARGE)
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.CATEG.ENTRY = 'F.CATEG.ENTRY'
    F.CATEG.ENTRY = ''
    CALL OPF(FN.CATEG.ENTRY,F.CATEG.ENTRY)
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    LREF.APP = 'ACCOUNT'
    LREF.FIELDS = 'L.AC.STATUS1':@VM:'L.AC.STATUS2'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    STATUS1.POS = LREF.POS<1,1>
    STATUS2.POS = LREF.POS<1,2>
    POS.STAT=LREF.POS<1,1>
    SETUP.STATUS.FLAG = ''
    FLAG.FULL.REVERSE = ''
RETURN
*-------------------------------------------------------------------------
CHECK.ACCT.CATEG:
*~~~~~~~~~~~~~~~
* get the incoming statement Entry account catgeory
* check catgeory is in the range specified in START category and END category in CRR.CHARGE.PARAM
    IN.ACCT.CATEG = STMT.RECORD<AC.STE.PRODUCT.CATEGORY>
    R.CHARGE.PARAM = '' ; CHG.ERR = ''
    CALL CACHE.READ(FN.CHARGE.PARAM,"SYSTEM",R.CHARGE.PARAM,CHG.ERR)
    RCP.CATEG.STR = R.CHARGE.PARAM<CHG.PARAM.ACCT.CATEG.STR>
    RCP.CATEG.END = R.CHARGE.PARAM<CHG.PARAM.ACCT.CATEG.END>
    RCP.PL.CATEG =  R.CHARGE.PARAM<CHG.PARAM.PL.CATEGORY>
    NO.OF.STRT.CATEG=DCOUNT(RCP.CATEG.STR,@VM)
    COUNT.CAT = 1
    LOOP
    WHILE COUNT.CAT LE NO.OF.STRT.CATEG
        IF IN.ACCT.CATEG GE RCP.CATEG.STR<1,COUNT.CAT> AND IN.ACCT.CATEG LE RCP.CATEG.END<1,COUNT.CAT> THEN
            GOSUB CHECK.TXN.CDE
        END
        COUNT.CAT += 1
    REPEAT
RETURN
*-------------------------------------------------------------------------
CHECK.TXN.CDE:
*~~~~~~~~~~~~~
*TRANSACTION.CODE in STMT.ENTRY is same as the Transaction code available in CHG.TXN.CODES
    C$SPARE(99) = STMT.ENT.ID
    IN.ACCT.NO = STMT.RECORD<AC.STE.ACCOUNT.NUMBER>
    CALL F.READ(FN.ACCOUNT,IN.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    ACCT.STATS = R.ACCOUNT<AC.LOCAL.REF,POS.STAT>
    RCP.ACT.STS = R.CHARGE.PARAM<CHG.PARAM.PEND.ACCT.STATUS>
    IN.TXN.CDE = STMT.RECORD<AC.STE.TRANSACTION.CODE>
    RCP.TXN.CDE = R.CHARGE.PARAM<CHG.PARAM.CHG.TXN.CODES>
    PARAM.ACCT.STATUS = R.CHARGE.PARAM<CHG.PARAM.PEND.ACCT.STATUS>
    LOCATE IN.TXN.CDE IN RCP.TXN.CDE<1,1> SETTING POS THEN
        GOSUB CHECK.ACCOUNT.BAL
    END ELSE
        GOSUB PENDING.CHARGE.RECOVERY
    END
RETURN
*-------------------------------------------------------------------------
CHECK.ACCOUNT.BAL:
*~~~~~~~~~~~~~~~~
    FCY.MARKER = 0
    SET.STMT.ENTRY = ''
    IN.ACCT.NO = STMT.RECORD<AC.STE.ACCOUNT.NUMBER>
    R.ACCOUNT = ''
    ACC.ERR = ''
    CALL F.READ(FN.ACCOUNT,IN.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    R.ECB= '' ; ECB.ERR= '' ;*Tus Start
    CALL EB.READ.HVT("EB.CONTRACT.BALANCES",IN.ACCT.NO,R.ECB,ECB.ERR)
* ACT.CLOSE.BAL = R.ACCOUNT<AC.ONLINE.ACTUAL.BAL>
    ACT.CLOSE.BAL = R.ECB<ECB.ONLINE.ACTUAL.BAL>;*Tus End
    ACCT.STATUS1 = R.ACCOUNT<AC.LOCAL.REF,STATUS1.POS>
    ACCT.STATUS2 = R.ACCOUNT<AC.LOCAL.REF,STATUS2.POS>
    CHANGE @VM TO @FM IN PARAM.ACCT.STATUS
    STATUS.COUNT = DCOUNT(PARAM.ACCT.STATUS,@FM)
    LOOP.CNTR = 1
    LOOP
    WHILE LOOP.CNTR LE STATUS.COUNT
        FETCH.STATUS = PARAM.ACCT.STATUS<LOOP.CNTR>
        IF FETCH.STATUS EQ ACCT.STATUS1 OR FETCH.STATUS EQ ACCT.STATUS2 THEN
            SETUP.STATUS.FLAG = 1
        END
        LOOP.CNTR += 1
    REPEAT
    IF STMT.RECORD<AC.STE.CURRENCY> EQ LCCY THEN
        IN.TRANS.AMT = STMT.RECORD<AC.STE.AMOUNT.LCY>
    END ELSE
        IN.TRANS.AMT = STMT.RECORD<AC.STE.AMOUNT.FCY>
    END
    CALC.CLOSE.BAL = ACT.CLOSE.BAL - IN.TRANS.AMT
*PACS00532228-S
    GOSUB GET.LOCKED.AMOUNT
    ACT.CLOSE.BAL -= Y.LOCK.AMT ;*AUTO R22 CODE CONVERSION
*PACS00532228-E
* CALC.CLOSE.BAL is the opening balance
* ACT.CLOSE.BAL is the Closing balance
* IN.TRANS.AMT is the transaction amount from STMT.ENTRY
* IN.TRANS.AMT should also include in the condition, since debit record is alone consider for pending charge's
*>>>>>>>>>FOR PACS00024242 - Removing Concept of Partial Payment >>>>>>>>>>>>>>>START
*    BEGIN CASE
*    CASE (SETUP.STATUS.FLAG EQ 1) OR (CALC.CLOSE.BAL LE 0 AND ACT.CLOSE.BAL LE 0)
*    IF (SETUP.STATUS.FLAG EQ 1) OR (CALC.CLOSE.BAL LE 0 AND ACT.CLOSE.BAL LE 0) THEN
    IF (SETUP.STATUS.FLAG EQ 1) OR (ACT.CLOSE.BAL LE 0) THEN
        UPDATE.CPC = ''
        R.PENDING.CHARGE = ''
        IN.TXN.AMT = IN.TRANS.AMT * -1
        IF IN.TXN.AMT THEN
            NCF.NT.REQ = 'YES'
        END
        GOSUB RAISE.STMT.ENTRIES
    END
*    CASE (SETUP.STATUS.FLAG EQ 1) OR (CALC.CLOSE.BAL GT 0 AND ACT.CLOSE.BAL LE 0)
*        R.PENDING.CHARGE = ''
*        IN.TXN.AMT = ACT.CLOSE.BAL * -1
*        GOSUB RAISE.STMT.ENTRIES
*    END CASE
*>>>>>>>>>FOR PACS00024242 - Removing Concept of Partial Payment >>>>>>>>>>>>>>>END
RETURN
*-------------------------------------------------------------------------
UPDATE.PENDING.CHARGE:
*~~~~~~~~~~~~~~~~~~~~

    R.PENDING.CHARGE = '' ; PC.ERR = '' ; GET.CHG.TXN.TOT = ''
    CALL F.READ(FN.PENDING.CHARGE,IN.ACCT.NO,R.PENDING.CHARGE,F.PENDING.CHARGE,PC.ERR)
    IF R.PENDING.CHARGE THEN
        GET.CHG.TXN.TOT = DCOUNT(R.PENDING.CHARGE<PEN.CHG.TRANSACTION>,@VM)
        GET.CHG.TXN.TOT += 1 ;*AUTO R22 CODE CONVERSION
    END
    IF UPDATE.CPC THEN
        R.PENDING.CHARGE<PEN.CHG.TRANSACTION,GET.CHG.TXN.TOT> = STMT.RECORD<AC.STE.TRANS.REFERENCE>
        R.PENDING.CHARGE<PEN.CHG.CURRENCY,GET.CHG.TXN.TOT> = STMT.RECORD<AC.STE.CURRENCY>
        R.PENDING.CHARGE<PEN.CHG.AMOUNT,GET.CHG.TXN.TOT> = IN.TXN.AMT
        R.PENDING.CHARGE<PEN.CHG.DATE,GET.CHG.TXN.TOT> = TODAY
*PACS00055362-S
        Y.FIN=PEN.CHG.AUDIT.DATE.TIME
        TIME.STAMP = TIMEDATE()   ;* CI_10005254
        R.PENDING.CHARGE<Y.FIN-8> = ""      ;* STATUS
        R.PENDING.CHARGE<Y.FIN-7> += 1      ;* CURR.NO
        R.PENDING.CHARGE<Y.FIN-6> = C$T24.SESSION.NO:"_":OPERATOR  ;* INPUTTER
        X.VAR = OCONV(DATE(),"D-") ;*AUTO R22 CODE CONVERSION
        R.PENDING.CHARGE<Y.FIN-5> = X.VAR[9,2]:X.VAR[1,2]:X.VAR[4,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]
        R.PENDING.CHARGE<Y.FIN-4> = C$T24.SESSION.NO:"_":OPERATOR  ;* AUTHORISER
        IF R.PENDING.CHARGE<Y.FIN-3> EQ "" THEN        ;* COMPANY ID
*            CALL EB.SET.COMPANY.ID
            R.PENDING.CHARGE<Y.FIN-3> = ID.COMPANY
        END
        R.PENDING.CHARGE<Y.FIN-2> = R.USER<EB.USE.DEPARTMENT.CODE>


*        APP.NAME = 'REDO.PENDING.CHARGE'
*        OFSFUNCT = 'I'
*        PROCESS  = 'PROCESS'
*        OFSVERSION = 'REDO.PENDING.CHARGE,'
*        GTSMODE = ''

*        NO.OF.AUTH = '0'
*        TRANSACTION.ID = IN.ACCT.NO
*        OFSRECORD = ''
*        OFS.MSG.ID =''
*        OFS.SOURCE.ID = 'REDO.OFS.RRC.UPDATE'
*        OFS.ERR = ''
*        CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.PENDING.CHARGE,OFSRECORD)
*        CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
*PACS00055362-E
        CALL F.WRITE(FN.PENDING.CHARGE,IN.ACCT.NO,R.PENDING.CHARGE)
        R.PENDING.CHARGE = ''
    END
RETURN
*-------------------------------------------------------------------------
RAISE.STMT.ENTRIES:
*~~~~~~~~~~~~~~~~~~
    R.ACC.ARR = ''
    UPDATE.CPC = "1"
    Y.COMM.STMT.ARR = ''
    Y.COMM.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = STMT.RECORD<AC.STE.ACCOUNT.NUMBER>
    Y.COMM.STMT.ARR<AC.STE.COMPANY.CODE> = ID.COMPANY

    IF STMT.RECORD<AC.STE.CURRENCY> EQ LCCY THEN
        Y.COMM.STMT.ARR<AC.STE.AMOUNT.LCY> = IN.TXN.AMT
    END ELSE
        Y.AMT.LCY.CREDIT=STMT.RECORD<AC.STE.AMOUNT.LCY>
        Y.COMM.STMT.ARR<AC.STE.AMOUNT.LCY> =  -1 * Y.AMT.LCY.CREDIT
        Y.COMM.STMT.ARR<AC.STE.AMOUNT.FCY> = IN.TXN.AMT
    END
    Y.COMM.STMT.ARR<AC.STE.TRANSACTION.CODE> = R.CHARGE.PARAM<CHG.PARAM.CR.TXN.CODE>
    Y.COMM.STMT.ARR<AC.STE.THEIR.REFERENCE> = STMT.RECORD<AC.STE.THEIR.REFERENCE>
    Y.COMM.STMT.ARR<AC.STE.CUSTOMER.ID> = STMT.RECORD<AC.STE.CUSTOMER.ID>
    Y.COMM.STMT.ARR<AC.STE.ACCOUNT.OFFICER> = STMT.RECORD<AC.STE.ACCOUNT.OFFICER>
    Y.COMM.STMT.ARR<AC.STE.PRODUCT.CATEGORY> = STMT.RECORD<AC.STE.PRODUCT.CATEGORY>
    Y.COMM.STMT.ARR<AC.STE.VALUE.DATE> = STMT.RECORD<AC.STE.VALUE.DATE>
    Y.COMM.STMT.ARR<AC.STE.CURRENCY> = STMT.RECORD<AC.STE.CURRENCY>
    Y.COMM.STMT.ARR<AC.STE.EXCHANGE.RATE> = STMT.RECORD<AC.STE.EXCHANGE.RATE>
    Y.COMM.STMT.ARR<AC.STE.CURRENCY.MARKET> = "1"
    Y.COMM.STMT.ARR<AC.STE.TRANS.REFERENCE> = STMT.RECORD<AC.STE.TRANS.REFERENCE>
    Y.COMM.STMT.ARR<AC.STE.OUR.REFERENCE>   = STMT.RECORD<AC.STE.ACCOUNT.NUMBER>
    Y.COMM.STMT.ARR<AC.STE.SYSTEM.ID> = "ACPC"
    Y.COMM.STMT.ARR<AC.STE.BOOKING.DATE> = TODAY
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        V = FT.AUDIT.DATE.TIME
        Y.STMT.NO =R.NEW(FT.STMT.NOS)
    END
    IF APPLICATION EQ 'TELLER' THEN
        V = TT.TE.AUDIT.DATE.TIME
        Y.STMT.NO = R.NEW(TT.TE.STMT.NO)
    END
    Y.AMT.LCY = STMT.RECORD<AC.STE.AMOUNT.LCY>
    IF Y.AMT.LCY NE "0" AND Y.AMT.LCY NE '' THEN
        Y.COMM.STMT.ARR = CHANGE(Y.COMM.STMT.ARR,@VM,@SM)
        Y.COMM.STMT.ARR = CHANGE(Y.COMM.STMT.ARR,@FM,@VM)
        R.ACC.ARR<-1> = Y.COMM.STMT.ARR
    END

    GOSUB RAISE.CATG.ENTRIES
    GOSUB UPDATE.PENDING.CHARGE

    CALL EB.ACCOUNTING("BM.CRCD.MERCH.UPLOAD","SAO",R.ACC.ARR,'')

    IF APPLICATION EQ 'TELLER' THEN
        Y.STMT.NO.NEW = R.NEW(TT.TE.STMT.NO)
        R.NEW(TT.TE.STMT.NO) = Y.STMT.NO
        R.NEW(TT.TE.STMT.NO)<1,-1> = ID.COMPANY
        R.NEW(TT.TE.STMT.NO)<1,-1> = Y.STMT.NO.NEW
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.STMT.NO.NEW = R.NEW(FT.STMT.NOS)
        R.NEW(FT.STMT.NOS) = Y.STMT.NO
        R.NEW(FT.STMT.NOS)<1,-1> = ID.COMPANY
        R.NEW(FT.STMT.NOS)<1,-1> = Y.STMT.NO.NEW
    END
RETURN
*-------------------------------------------------------------------------
RAISE.CATG.ENTRIES:
*~~~~~~~~~~~~~~~~~~
    R.CATEG.ENT = ''
    R.CATEG.ENT<AC.CAT.ACCOUNT.NUMBER> = ''
    R.CATEG.ENT<AC.CAT.COMPANY.CODE> = ID.COMPANY
    IF STMT.RECORD<AC.STE.CURRENCY> EQ LCCY THEN
        R.CATEG.ENT<AC.CAT.AMOUNT.LCY> = -1 * IN.TXN.AMT
    END ELSE
        R.CATEG.ENT<AC.CAT.AMOUNT.FCY> = -1 * IN.TXN.AMT
        R.CATEG.ENT<AC.CAT.AMOUNT.LCY> = STMT.RECORD<AC.STE.AMOUNT.LCY>
    END
    R.CATEG.ENT<AC.CAT.TRANSACTION.CODE> = R.CHARGE.PARAM<CHG.PARAM.DR.TXN.CODE>
    R.CATEG.ENT<AC.CAT.CUSTOMER.ID> = STMT.RECORD<AC.STE.CUSTOMER.ID>
    R.CATEG.ENT<AC.CAT.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    R.CATEG.ENT<AC.CAT.PL.CATEGORY> = RCP.PL.CATEG
    R.CATEG.ENT<AC.CAT.PRODUCT.CATEGORY> = STMT.RECORD<AC.STE.PRODUCT.CATEGORY>
    R.CATEG.ENT<AC.CAT.VALUE.DATE> = STMT.RECORD<AC.STE.VALUE.DATE>
    R.CATEG.ENT<AC.CAT.CURRENCY> = STMT.RECORD<AC.STE.CURRENCY>
    R.CATEG.ENT<AC.CAT.EXCHANGE.RATE> = STMT.RECORD<AC.STE.EXCHANGE.RATE>
    R.CATEG.ENT<AC.CAT.CURRENCY.MARKET> = "1"
    R.CATEG.ENT<AC.CAT.TRANS.REFERENCE> = STMT.RECORD<AC.STE.TRANS.REFERENCE>
    R.CATEG.ENT<AC.CAT.OUR.REFERENCE> = STMT.RECORD<AC.STE.ACCOUNT.NUMBER>
    R.CATEG.ENT<AC.CAT.SYSTEM.ID> = "ACPC"
    R.CATEG.ENT<AC.CAT.BOOKING.DATE> = TODAY
    R.CATEG.ENT<AC.CAT.NARRATIVE> = "REVERSAL"
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        V = FT.AUDIT.DATE.TIME
        Y.STMT.NO =R.NEW(FT.STMT.NOS)
    END
    IF APPLICATION EQ 'TELLER' THEN
        V = TT.TE.AUDIT.DATE.TIME
        Y.STMT.NO = R.NEW(TT.TE.STMT.NO)
    END
    R.CATEG.ENT = CHANGE(R.CATEG.ENT,@VM,@SM)
    R.CATEG.ENT = CHANGE(R.CATEG.ENT,@FM,@VM)
    R.ACC.ARR<-1> = R.CATEG.ENT
RETURN
*-------------------------------------------------------------------------
PENDING.CHARGE.RECOVERY:
*~~~~~~~~~~~~~~~~~~~~~~
* Read the incoming STMT entries
* get the account number and check whether its an record in CRR.PENDING.CHARGE
    IF APPL.TYPE EQ "STMT" THEN
        IN.ACCT.NO = STMT.RECORD<AC.STE.ACCOUNT.NUMBER> ; R.ACCOUNT = '' ; ACC.ERR = ''
        ACT.CLOSE.BAL = ''
        R.PENDING.CHARGE = '' ; PC.ERR = '' ; GET.CHG.TXN.TOT = ''
        CALL F.READ(FN.PENDING.CHARGE,IN.ACCT.NO,R.PENDING.CHARGE,F.PENDING.CHARGE,PC.ERR)
        IF R.PENDING.CHARGE THEN
            GOSUB CHECK.CREDIT.TXN
        END
    END
RETURN
*-------------------------------------------------------------------------
CHECK.CREDIT.TXN:
*~~~~~~~~~~~~~~~
* check whether the value is present in AMOUNT.LCY field, else take the value from AMOUNT.FCY
* Process only the credit operation i.e AMOUNT.LCY or AMOUNT.FCY must be greater than "0"
    IN.AMT.LCY = STMT.RECORD<AC.STE.AMOUNT.LCY>
    IF NOT(IN.AMT.LCY) THEN
        IN.AMT.LCY = STMT.RECORD<AC.STE.AMOUNT.FCY>
    END
    IF IN.AMT.LCY GT 0 THEN
        CALL F.READ(FN.ACCOUNT,IN.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        R.ECB1= '' ; ECB.ERR1= '' ;*Tus Start
        CALL EB.READ.HVT("EB.CONTRACT.BALANCES",IN.ACCT.NO,R.ECB1,ECB.ERR1)
*  ACT.BALANCE = R.ACCOUNT<AC.ONLINE.ACTUAL.BAL>
        ACT.BALANCE = R.ECB1<ECB.ONLINE.ACTUAL.BAL>;*Tus End
        RPC.CHG.AMOUNT = R.PENDING.CHARGE<PEN.CHG.AMOUNT>
*PACS00553863-S
        GOSUB GET.LOCKED.AMOUNT
        CALC.OPENING.BALANCE = ACT.BALANCE - Y.LOCK.AMT
*PACS00553863-E
        GOSUB CHECK.CLOSE.OPEN.BALANCE
    END
RETURN
*-------------------------------------------------------------------------
CHECK.CLOSE.OPEN.BALANCE:
*-------------------------------------------------------------------------
* If the opening balance is greater than zero, than count the number transaction record for the account
* in REDO.PENDING.CHARGE and  For each record goto RECOVER.ENTRIES

    PARTIAL.RECOVER = "" ; TXN.ID = '' ; TXN.AMOUNT = '' ; FLAG.UPD = ''
    AMT.TO.CPC = 0
    RECORD.TO.DEL = 0
    IF CALC.OPENING.BALANCE GT 0 THEN
        CNT.NO.TXN = DCOUNT(RPC.CHG.AMOUNT,@VM)
        START.CNT.CONT = 1
        LOOP
        WHILE START.CNT.CONT LE CNT.NO.TXN
            TEMP.MV.AMT = FIELD(RPC.CHG.AMOUNT,@VM,START.CNT.CONT)
            RECORD.COUNT = CNT.NO.TXN
            TEMP.CALC.OPENING.BALANCE = ''
            TEMP.CALC.OPENING.BALANCE = CALC.OPENING.BALANCE
            CALC.OPENING.BALANCE -= TEMP.MV.AMT
            IF CALC.OPENING.BALANCE GE 0 THEN
                TXN.ID<-1> = R.PENDING.CHARGE<PEN.CHG.TRANSACTION,START.CNT.CONT>
                TXN.AMOUNT<-1> = R.PENDING.CHARGE<PEN.CHG.AMOUNT,START.CNT.CONT>
                RECORD.TO.DEL += 1
                FLAG.UPD = 1
                START.CNT.CONT += 1 ;*AUTO R22 CODE CONVERSION
*>>>>>>>>>FOR PACS00024242 - Removing Concept of Partial Payment >>>>>>>>>>>>>>>START
* If no sufficient amount to tally the pending charge, proceed to next loop
*            END ELSE
*                TXN.ID<-1> = R.PENDING.CHARGE<PEN.CHG.TRANSACTION,START.CNT.CONT>
*                TXN.AMOUNT<-1> = TEMP.CALC.OPENING.BALANCE
*                AMT.TO.CPC = CALC.OPENING.BALANCE * -1
*                RECORD.COUNT = START.CNT.CONT
*                RECORD.TO.DEL = START.CNT.CONT - 1
*                START.CNT.CONT = CNT.NO.TXN
*>>>>>>>>>FOR PACS00055362 - Break the loop if the amount is not available to recover the full first pending charge>>>>>>START
*            END ELSE
*                CALC.OPENING.BALANCE = TEMP.CALC.OPENING.BALANCE
*>>>>>>>>>FOR PACS00055362 - Break the loop if the amount is not available to recover the full first pending charge>>>>>>END
*>>>>>>>>>FOR PACS00024242 - Removing Concept of Partial Payment >>>>>>>>>>>>>>>END

            END ELSE
                START.CNT.CONT = CNT.NO.TXN + 1
            END
        REPEAT

        IF FLAG.UPD EQ 1 THEN
            GOSUB UPDATE.TABLE
            GOSUB GENERATE.RECOVER.ENTRIES
        END
    END
RETURN
*-------------------------------------------------------------------------
UPDATE.TABLE:
*-------------------------------------------------------------------------
    REPAY.ID = IN.ACCT.NO :"-": TODAY
    CALL F.READ(FN.REPAYMENT.CHARGE,REPAY.ID,R.REPAY.CHARGE,F.REPAYMENT.CHARGE,REP.ERR)
    START.UP.CNT = 1
    LOOP
    WHILE START.UP.CNT LE RECORD.COUNT
        GOSUB FORM.REPAY.CHARGE
    REPEAT
    APP.NAME = 'REDO.REPAYMENT.CHARGE'
    OFSFUNCT = 'I'
    PROCESS  = 'PROCESS'
    OFSVERSION = 'REDO.REPAYMENT.CHARGE,'
    Y.GTSMODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = REPAY.ID
    OFSRECORD = ''
    OFS.MSG.ID =''
    OFS.SOURCE.ID = 'REDO.OFS.RRC.UPDATE'
    OFS.ERR = ''
    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,Y.GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.REPAY.CHARGE,OFSRECORD)
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
    IF CNT.NO.TXN EQ RECORD.TO.DEL THEN
        CALL F.DELETE(FN.PENDING.CHARGE,IN.ACCT.NO)
        HIS.IN.ACCT.NO = IN.ACCT.NO:';':1
        CALL F.DELETE(FN.PENDING.CHARGE.HIS,HIS.IN.ACCT.NO)
    END ELSE
        START.UP.CNT = 1 ; ALL.TXN.ID = '' ;
        ALL.TXN.ID = R.PENDING.CHARGE<PEN.CHG.TRANSACTION>
        LOOP
        WHILE START.UP.CNT LE RECORD.TO.DEL
            TEMP.TXN.ID = FIELD(TXN.ID,@FM,START.UP.CNT)
            LOCATE TEMP.TXN.ID IN ALL.TXN.ID<1,1> SETTING TEMP.POS THEN
                DEL R.PENDING.CHARGE<PEN.CHG.TRANSACTION,TEMP.POS>
                DEL R.PENDING.CHARGE<PEN.CHG.CURRENCY,TEMP.POS>
                DEL R.PENDING.CHARGE<PEN.CHG.AMOUNT,TEMP.POS>
                DEL R.PENDING.CHARGE<PEN.CHG.DATE,TEMP.POS>
                DEL ALL.TXN.ID<1,TEMP.POS>
            END
            START.UP.CNT += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
        IF START.UP.CNT EQ RECORD.COUNT AND AMT.TO.CPC GT 0 THEN
            TEMP.TXN.ID = FIELD(TXN.ID,@FM,START.UP.CNT)
            LOCATE TEMP.TXN.ID IN ALL.TXN.ID<1,1> SETTING TEMP.POS THEN
                R.PENDING.CHARGE<PEN.CHG.AMOUNT,1> = AMT.TO.CPC
            END
        END
        CALL F.WRITE(FN.PENDING.CHARGE,IN.ACCT.NO,R.PENDING.CHARGE)
    END
RETURN
*-----------------
FORM.REPAY.CHARGE:
*-----------------

    TEMP.TXN.ID = FIELD(TXN.ID,@FM,START.UP.CNT)
    IF NOT(R.REPAY.CHARGE) THEN

        R.REPAY.CHARGE<REPAY.CHG.TRANSACTION,1>=TEMP.TXN.ID
        R.REPAY.CHARGE<REPAY.CHG.CURRENCY,1> = STMT.RECORD<AC.STE.CURRENCY>
        IF START.UP.CNT EQ RECORD.COUNT AND AMT.TO.CPC GT 0 THEN
            R.REPAY.CHARGE<REPAY.CHG.AMOUNT,1> = TEMP.CALC.OPENING.BALANCE
        END ELSE
            R.REPAY.CHARGE<REPAY.CHG.AMOUNT,1> = FIELD(TXN.AMOUNT,@FM,START.UP.CNT)
        END
        R.REPAY.CHARGE<REPAY.CHG.DATE,1> = TODAY
    END ELSE
        IF TEMP.TXN.ID NE '' THEN
            R.REPAY.CHARGE<REPAY.CHG.TRANSACTION,-1> = TEMP.TXN.ID
            R.REPAY.CHARGE<REPAY.CHG.CURRENCY,-1> = STMT.RECORD<AC.STE.CURRENCY>
            IF START.UP.CNT EQ RECORD.COUNT AND AMT.TO.CPC GT 0 THEN
                R.REPAY.CHARGE<REPAY.CHG.AMOUNT,-1> = TEMP.CALC.OPENING.BALANCE
            END ELSE
                R.REPAY.CHARGE<REPAY.CHG.AMOUNT,-1> = FIELD(TXN.AMOUNT,@FM,START.UP.CNT)
            END
            R.REPAY.CHARGE<REPAY.CHG.DATE,-1> = TODAY
        END
    END
    START.UP.CNT += 1
RETURN
*-------------------------------------------------------------------------
GENERATE.RECOVER.ENTRIES:
*~~~~~~~~~~~~~~~~~~~~~~
    CALL ALLOCATE.UNIQUE.TIME(CURRTIME)
    ACT.CALC.CHG.AMOUNT = SUM(TXN.AMOUNT)
    ACT.CALC.CHG.AMOUNT = ACT.CALC.CHG.AMOUNT * -1
    Y.COMM.STMT.ARR = ''
    Y.COMM.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = IN.ACCT.NO
    Y.COMM.STMT.ARR<AC.STE.COMPANY.CODE> = ID.COMPANY
    Y.COMM.STMT.ARR<AC.STE.TRANSACTION.CODE> = R.CHARGE.PARAM<CHG.PARAM.DR.TXN.CODE>
    START.UPD.CNT = 1
    LOOP
    WHILE START.UPD.CNT LE RECORD.COUNT
        Y.COMM.STMT.ARR<AC.STE.NARRATIVE,START.UPD.CNT> = FIELD(TXN.ID,@FM,START.UPD.CNT)
        START.UPD.CNT += 1
    REPEAT
    Y.COMM.STMT.ARR<AC.STE.CUSTOMER.ID> = STMT.RECORD<AC.STE.CUSTOMER.ID>
    Y.COMM.STMT.ARR<AC.STE.ACCOUNT.OFFICER> = STMT.RECORD<AC.STE.ACCOUNT.OFFICER>
    Y.COMM.STMT.ARR<AC.STE.PRODUCT.CATEGORY> = R.ACCOUNT<AC.CATEGORY>
    Y.COMM.STMT.ARR<AC.STE.VALUE.DATE> = TODAY
    Y.COMM.STMT.ARR<AC.STE.CURRENCY> =  R.PENDING.CHARGE<PEN.CHG.CURRENCY,1>
    IF R.PENDING.CHARGE<PEN.CHG.CURRENCY,1> EQ LCCY THEN
        Y.COMM.STMT.ARR<AC.STE.AMOUNT.LCY> = ACT.CALC.CHG.AMOUNT
    END ELSE
        Y.COMM.STMT.ARR<AC.STE.AMOUNT.FCY> =ACT.CALC.CHG.AMOUNT
    END
    Y.COMM.STMT.ARR<AC.STE.CURRENCY.MARKET> = "1"
    Y.COMM.STMT.ARR<AC.STE.TRANS.REFERENCE> = "PEND":CURRTIME
    Y.COMM.STMT.ARR<AC.STE.OUR.REFERENCE>   = IN.ACCT.NO
    Y.COMM.STMT.ARR<AC.STE.SYSTEM.ID> = "ACPC"
    Y.COMM.STMT.ARR<AC.STE.BOOKING.DATE> = TODAY
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        V = FT.AUDIT.DATE.TIME
        Y.STMT.NO =R.NEW(FT.STMT.NOS)
    END
    IF APPLICATION EQ 'TELLER' THEN
        V         = TT.TE.AUDIT.DATE.TIME
        Y.STMT.NO = R.NEW(TT.TE.STMT.NO)
    END
    Y.AMT.LCY = STMT.RECORD<AC.STE.AMOUNT.LCY>
    IF Y.AMT.LCY NE "0" AND Y.AMT.LCY NE '' THEN
        Y.COMM.STMT.ARR = CHANGE(Y.COMM.STMT.ARR,@VM,@SM)
        Y.COMM.STMT.ARR = CHANGE(Y.COMM.STMT.ARR,@FM,@VM)
        R.ACC.ARR<-1> = Y.COMM.STMT.ARR
    END
    ACT.CALC.CHG.AMOUNT = ACT.CALC.CHG.AMOUNT * -1
    R.CATEG.ENT = ''
    R.CATEG.ENT<AC.CAT.ACCOUNT.NUMBER> = ''
    R.CATEG.ENT<AC.CAT.COMPANY.CODE> = ID.COMPANY
    R.CATEG.ENT<AC.CAT.TRANSACTION.CODE> = R.CHARGE.PARAM<CHG.PARAM.CR.TXN.CODE>
    R.CATEG.ENT<AC.CAT.CUSTOMER.ID> = STMT.RECORD<AC.STE.CUSTOMER.ID>
    R.CATEG.ENT<AC.CAT.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    R.CATEG.ENT<AC.CAT.PL.CATEGORY> = RCP.PL.CATEG
    R.CATEG.ENT<AC.CAT.PRODUCT.CATEGORY> = R.ACCOUNT<AC.CATEGORY>
    R.CATEG.ENT<AC.CAT.VALUE.DATE> = TODAY
    R.CATEG.ENT<AC.CAT.CURRENCY> =  R.PENDING.CHARGE<PEN.CHG.CURRENCY,1>
    IF R.PENDING.CHARGE<PEN.CHG.CURRENCY,1> EQ LCCY THEN
        R.CATEG.ENT<AC.CAT.AMOUNT.LCY> = ACT.CALC.CHG.AMOUNT
    END ELSE
        R.CATEG.ENT<AC.CAT.AMOUNT.FCY> = ACT.CALC.CHG.AMOUNT
    END
    R.CATEG.ENT<AC.CAT.CURRENCY.MARKET> = "1"
    R.CATEG.ENT<AC.CAT.TRANS.REFERENCE> = "PEND":CURRTIME
    R.CATEG.ENT<AC.CAT.OUR.REFERENCE>   = IN.ACCT.NO
    R.CATEG.ENT<AC.CAT.SYSTEM.ID> = "ACPC"
    R.CATEG.ENT<AC.CAT.BOOKING.DATE> = TODAY
    START.UPD.CNT = 1
    LOOP
    WHILE START.UPD.CNT LE RECORD.COUNT
        R.CATEG.ENT<AC.CAT.NARRATIVE,START.UPD.CNT> = FIELD(TXN.ID,@FM,START.UPD.CNT)
        START.UPD.CNT += 1
    REPEAT
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        V = FT.AUDIT.DATE.TIME
        Y.STMT.NO =R.NEW(FT.STMT.NOS)
    END
    IF APPLICATION EQ 'TELLER' THEN
        V         = TT.TE.AUDIT.DATE.TIME
        Y.STMT.NO = R.NEW(TT.TE.STMT.NO)
    END
    R.CATEG.ENT = CHANGE(R.CATEG.ENT,@VM,@SM)
    R.CATEG.ENT = CHANGE(R.CATEG.ENT,@FM,@VM)
    R.ACC.ARR<-1> = R.CATEG.ENT
    CALL EB.ACCOUNTING("BM.CRCD.MERCH.UPLOAD","SAO",R.ACC.ARR,'')

    IF APPLICATION EQ 'TELLER' THEN
        Y.STMT.NO.NEW = R.NEW(TT.TE.STMT.NO)
        R.NEW(TT.TE.STMT.NO) = Y.STMT.NO
        R.NEW(TT.TE.STMT.NO)<1,-1> = ID.COMPANY
        R.NEW(TT.TE.STMT.NO)<1,-1> = Y.STMT.NO.NEW
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.STMT.NO.NEW = R.NEW(FT.STMT.NOS)
        R.NEW(FT.STMT.NOS) = Y.STMT.NO
        R.NEW(FT.STMT.NOS)<1,-1> = ID.COMPANY
        R.NEW(FT.STMT.NOS)<1,-1> = Y.STMT.NO.NEW
    END
RETURN
*---------------------------------------------------------------------------------------
GET.LOCKED.AMOUNT:
******************
    Y.LOCK.AMT = 0
    IF NOT(R.ACCOUNT<AC.FROM.DATE>) THEN
        Y.LOCK.AMT = 0
        RETURN
    END

    Y.DATE.COUNT = DCOUNT(R.ACCOUNT<AC.FROM.DATE>,@VM)
    Y.DATE.START = 1

    LOOP
    WHILE Y.DATE.START LE Y.DATE.COUNT
        IF R.ACCOUNT<AC.FROM.DATE,Y.DATE.START> LE TODAY THEN
            Y.LOCK.AMT = R.ACCOUNT<AC.LOCKED.AMOUNT,Y.DATE.START>
        END

        Y.DATE.START += 1
    REPEAT

RETURN
END
