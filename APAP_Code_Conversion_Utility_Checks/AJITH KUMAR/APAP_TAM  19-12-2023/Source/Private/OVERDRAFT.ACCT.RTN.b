* @ValidationCode : MjotMTAzOTE1NzkzNzpDcDEyNTI6MTY4NDg0MTg2MTM4MzpJVFNTOi0xOi0xOjkzMjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:07:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 932
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE OVERDRAFT.ACCT.RTN(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : OVERDRAFT.ACCT.RTN
*--------------------------------------------------------------------------------------------------------
*Description       : This is a nofile routine attached to an enquiry, the routine fetches
*                    all accounts that are overdraft
*Linked With       : Enquiry ENQ.REDO.OVERDRAFT.ACCOUNT
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date           Who               Reference                                 Description
*     ------         -----             -------------                             -------------
* 15 NOV 2010       NATCHIMUTHU.P        ODR-2010-03-0089                         Initial Creation
*-----------------------------------------------------------------------------------
* Modification History:
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*04/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION      VM TO @VM, FM TO @FM, F.READ TO CACHE.READ,F.CATEGORY TO R.CATEGORY
*04/04/2023         SURESH           MANUAL R22 CODE CONVERSION            NOCHANGE
*-----------------------------------------------------------------------------------
* *********************************************************************************************************
*TUS START
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.LIMIT
    $INSERT I_F.EB.CONTRACT.BALANCES
*TUS END
    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB LOCATE.PROCESS
    GOSUB SEL.LIVE
    GOSUB SEL.HISTORY

RETURN
*---------------------------------------------------------------------------------------------------------------
INITIALISE:
***********

    FN.CUSTOMER       = 'F.CUSTOMER'
    F.CUSTOMER        = ''

    FN.ACCOUNT        = 'F.ACCOUNT'
    F.ACCOUNT         =  ''

    FN.CATEGORY       = 'F.CATEGORY'
    F.CATEGORY        = ''

    FN.CARD.ISSUE.ACCOUNT = 'F.CARD.ISSUE.ACCOUNT'
    F.CARD.ISSUE.ACCOUNT   = ''

    FN.LIMIT          =  'F.LIMIT'
    F.LIMIT           =  ''

    FN.ACCOUNT.CLOSED = 'F.ACCOUNT.CLOSED'
    F.ACCOUNT.CLOSED  = ''

    FN.ACCOUNT.HIS='F.ACCOUNT$HIS'
    F.ACCOUNT.HIS=''

    Y.CO.CODE            = ''
    Y.ACCOUNT.OFFICER    = ''
    Y.CUSTOMER=''
    Y.OPENING.DATE       = ''
    Y.CUSTOMER           = ''
    Y.CARD.ISSUE.ID      = ''
    Y.LOCKED.AMOUNT      = ''
    Y.AVAILABLE.BALANCE  = ''
    Y.IN.TRANSIT.BALANCE = ''
    Y.ONLINE.CLEARED.BAL = ''
    Y.LOCKED.AMOUNT      = ''


    LREF.APP    = 'ACCOUNT'
    LREF.POS    = ''
    LREF.FIELDS = 'L.AC.STATUS1':@VM:'L.AC.STATUS2' ;*AUTO R22 CODE CONVERSION
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    L.AC.STATUS1.POS = LREF.POS<1,1>
    L.AC.STATUS2.POS = LREF.POS<1,2>

RETURN

OPENFILES:
**********
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.CATEGORY,F.CATEGORY)
    CALL OPF(FN.CARD.ISSUE.ACCOUNT,F.CARD.ISSUE.ACCOUNT)
    CALL OPF(FN.LIMIT,F.LIMIT)
    CALL OPF(FN.ACCOUNT.CLOSED,F.ACCOUNT.CLOSED)
    CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)

RETURN

LOCATE.PROCESS:
***************

    LOCATE "CO.CODE" IN D.FIELDS<1> SETTING Y.CO.CODE.POS THEN
        Y.CO.CODE = D.RANGE.AND.VALUE<Y.CO.CODE.POS>
    END


    LOCATE "ACCOUNT.OFFICER" IN D.FIELDS<1> SETTING Y.ACC.POS THEN
        Y.ACCOUNT.OFFICER   = D.RANGE.AND.VALUE<Y.ACC.POS>
    END
    LOCATE "CUSTOMER" IN D.FIELDS<1> SETTING Y.CUSTOMER.POS THEN
        Y.CUSTOMER  = D.RANGE.AND.VALUE<Y.CUSTOMER.POS>
    END

RETURN

*-------------------------------------------------------------------------------------------------------------------------------
SEL.LIVE:
*********
    SEL.CMD.ACC = "SELECT ":FN.ACCOUNT
    Y.CLASSIFICATION = ''


    IF Y.CO.CODE THEN
        SEL.CMD.ACC := " WITH CO.CODE EQ ":Y.CO.CODE
    END
    IF Y.ACCOUNT.OFFICER THEN
        SEL.CMD.ACC := " AND WITH ACCOUNT.OFFICER EQ ":Y.ACCOUNT.OFFICER
    END
    IF Y.CUSTOMER THEN
        SEL.CMD.ACC := " AND WITH CUSTOMER EQ ":Y.CUSTOMER
    END


    IF Y.CO.CODE AND Y.ACCOUNT.OFFICER AND Y.CUSTOMER THEN
        SEL.CMD.ACC := " WITH CO.CODE EQ ":Y.CO.CODE:" AND WITH ACCOUNT.OFFICER EQ ":Y.ACCOUNT.OFFICER:" AND WITH CUSTOMER EQ ":Y.CUSTOMER
        TEMP.RANGE.AND.VALUE = D.RANGE.AND.VALUE
        CHANGE @FM TO ',' IN TEMP.RANGE.AND.VALUE ;*AUTO R22 CODE CONVERSION
        Y.CLASSIFICATION = TEMP.RANGE.AND.VALUE
    END


    SEL.CMD.ACC := " BY CO.CODE BY ACCOUNT.OFFICER BY CURRENCY"
    CALL EB.READLIST(SEL.CMD.ACC,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.ACCT.ID FROM SEL.LIST SETTING POS1
    WHILE Y.ACCT.ID:POS1

        CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
*TUS START
        ACC.LIVE.FLAG = ''
        CALL EB.READ.HVT('EB.CONTRACT.BALANCES',Y.ACCT.ID,R.ECB,ECB.ERR)
        IF R.ECB THEN
            ACC.LIVE.FLAG = 1
        END
*TUS END

        Y.ACCT.NO = Y.ACCT.ID


        GOSUB GET.ACCT.DETAILS


        IF Y.TOTAL.BALANCE LT 0 AND Y.AGENCY NE '' THEN
            Y.OUT.ARRAY<-1> = Y.AGENCY:"*":Y.ACCOUNT.EXECUTIVE:"*":Y.SHORT.NAME:"*":Y.ACCT.NO:"*":Y.CARD.ISSUE.ID:"*":Y.CLIENT.CODE:"*":Y.CURRENCY:"*":Y.TOTAL.BALANCE:"*":Y.AVAILABLE.BALANCE:"*":Y.IN.TRANSIT.BALANCE:"*":Y.AC.STATUS.1:"*":Y.AC.STATUS.2:"*":Y.LAST.TRANSACTION.DATE:"*":Y.TRANS.DESCRIP:"*":Y.OPENING.DATE:"*":Y.CANCELLATION.DATE:"*":Y.COVERAGE.ACCOUNT.NUM
        END

        GOSUB NULL.VALUE

    REPEAT

RETURN
*----------------------------------------------------------------------------------------------------------------------------
SEL.HISTORY:
************

    SEL.CMD.ACC.CLD = "SELECT ":FN.ACCOUNT.CLOSED

    CALL EB.READLIST(SEL.CMD.ACC.CLD,SEL.CLOSED.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.ACCT.CLOSED.ID FROM SEL.CLOSED.LIST SETTING POS2
    WHILE Y.ACCT.CLOSED.ID:POS2

        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIS,Y.ACCT.CLOSED.ID,R.ACCOUNT,YERROR)

        Y.CLOSED.CO.CODE      = R.ACCOUNT<AC.CO.CODE>
        Y.CLOSED.ACCT.OFFICER = R.ACCOUNT<AC.ACCOUNT.OFFICER>
        Y.CLOSED.CUSTOMER =R.ACCOUNT<AC.CUSTOMER>
        Y.ACCT.NO = Y.ACCT.CLOSED.ID
        IF Y.CO.CODE NE '' AND Y.ACCOUNT.OFFICER EQ '' THEN
            IF Y.CLOSED.CO.CODE EQ Y.CO.CODE THEN
                GOSUB GET.ACCT.DETAILS
                GOSUB HIST.ARRAY
            END
        END

        IF Y.ACCOUNT.OFFICER NE '' AND Y.CO.CODE EQ '' THEN
            IF Y.ACCOUNT.OFFICER EQ Y.CLOSED.ACCT.OFFICER THEN
                GOSUB GET.ACCT.DETAILS
                GOSUB HIST.ARRAY
            END
        END

        IF Y.CO.CODE EQ '' AND Y.ACCOUNT.OFFICER EQ '' AND Y.CUSTOMER EQ '' THEN
            GOSUB GET.ACCT.DETAILS
            GOSUB HIST.ARRAY
        END

        IF Y.CO.CODE AND Y.ACCOUNT.OFFICER AND Y.CUSTOMER THEN
            IF Y.CO.CODE EQ Y.CLOSED.CO.CODE AND Y.ACCOUNT.OFFICER EQ Y.CLOSED.ACCT.OFFICER AND Y.CUSTOMER EQ Y.CLOSED.CUSTOMER THEN
                GOSUB GET.ACCT.DETAILS
                GOSUB HIST.ARRAY
            END
        END

        GOSUB NULL.VALUE


    REPEAT
RETURN

HIST.ARRAY:
***********

    Y.OUT.ARRAY<-1> = Y.AGENCY:"*":Y.ACCOUNT.EXECUTIVE:"*":Y.SHORT.NAME:"*":Y.ACCT.NO:"*":Y.CARD.ISSUE.ID:"*":Y.CLIENT.CODE:"*":Y.CURRENCY:"*":Y.TOTAL.BALANCE:"*":Y.AVAILABLE.BALANCE:"*":Y.IN.TRANSIT.BALANCE:"*":Y.AC.STATUS.1:"*":Y.AC.STATUS.2:"*":Y.LAST.TRANSACTION.DATE:"*":Y.TRANS.DESCRIP:"*":Y.OPENING.DATE:"*":Y.CANCELLATION.DATE:"*":Y.COVERAGE.ACCOUNT.NUM
RETURN

*-----------------------------------------------------------------------------------------------------------------------------------------
GET.ACCT.DETAILS:
******************

    Y.AGENCY    = R.ACCOUNT<AC.CO.CODE>
    Y.ACCOUNT.EXECUTIVE= R.ACCOUNT<AC.ACCOUNT.OFFICER>

    Y.ACCOUNT.TYPE = R.ACCOUNT<AC.CATEGORY>
    CALL CACHE.READ(FN.CATEGORY, Y.ACCOUNT.TYPE, R.CATEGORY, CAT.ERR) ;*AUTO R22 CODE CONVERSION
    Y.SHORT.NAME = R.CATEGORY<EB.CAT.SHORT.NAME>

    CALL F.READ(FN.CARD.ISSUE.ACCOUNT,Y.ACCT.NO,R.CARD.ISSUE.ACCOUNT,F.CARD.ISSUE.ACCOUNT,CARD.ISSUE.ACCOUNT.ERR)
    IF R.CARD.ISSUE.ACCOUNT THEN

        Y.CARD.ISSUE.ID = R.CARD.ISSUE.ACCOUNT
        CHANGE @FM TO @VM IN Y.CARD.ISSUE.ID ;*AUTO R22 CODE CONVERSION
    END

    Y.CLIENT.CODE = R.ACCOUNT<AC.CUSTOMER>
    Y.CURRENCY    = R.ACCOUNT<AC.CURRENCY>
*TUS START
    IF ACC.LIVE.FLAG THEN
        Y.TOTAL.BALANCE= R.ECB<ECB.ONLINE.ACTUAL.BAL>
    END
    ELSE
        Y.TOTAL.BALANCE= R.ACCOUNT<AC.ONLINE.ACTUAL.BAL>
    END
*TUS END
    Y.LOCKED.AMOUNT    = R.ACCOUNT<AC.LOCKED.AMOUNT>

    Y.LIMIT.REF   = R.ACCOUNT<AC.LIMIT.REF>
    Y.CUSTOMER    = R.ACCOUNT<AC.CUSTOMER>
    Y.LIMIT.REF = FMT(Y.LIMIT.REF,'R%10')

    LIMIT.ID = Y.CUSTOMER : '.' : Y.LIMIT.REF
    CALL F.READ(FN.LIMIT,LIMIT.ID,R.LIMIT,F.LIMIT,LIMIT.ERR)

    VAR.AVAIL.AMT = R.LIMIT<LI.AVAIL.AMT>

    Y.AVAILABLE.BALANCE =  Y.TOTAL.BALANCE +  VAR.AVAIL.AMT - Y.LOCKED.AMOUNT
*TUS START
    IF ACC.LIVE.FLAG THEN
        Y.ONLINE.CLEARED.BAL = R.ECB<ECB.ONLINE.CLEARED.BAL>
    END ELSE
        Y.ONLINE.CLEARED.BAL = R.ACCOUNT<AC.ONLINE.CLEARED.BAL>
    END
*TUS END
    Y.IN.TRANSIT.BALANCE= Y.TOTAL.BALANCE-Y.ONLINE.CLEARED.BAL

    Y.CANCELLATION.DATE = R.ACCOUNT<AC.CLOSURE.DATE>

    Y.AC.STATUS.1 = R.ACCOUNT<AC.LOCAL.REF,L.AC.STATUS1.POS>
    Y.AC.STATUS.2 = R.ACCOUNT<AC.LOCAL.REF,L.AC.STATUS2.POS>
    CHANGE @FM TO @VM IN Y.AC.STATUS.2 ;*AUTO R22 CODE CONVERSION
*TUS START
    IF ACC.LIVE.FLAG THEN
        LOCATE 'CUST-CR' IN R.ECB<ECB.INITIATOR.TYPE,1> SETTING CUST.CR.POS THEN
            Y.DATE.LAST.CR.CUST = R.ECB<ECB.DATE.LAST,CUST.CR.POS>
            LOCATE 'CUST-DR' IN R.ECB<ECB.INITIATOR.TYPE,1> SETTING CUST.DR.POS THEN
                Y.DATE.LAST.DR.CUST = R.ECB<ECB.DATE.LAST,CUST.DR.POS>
            END ELSE
                Y.DATE.LAST.CR.CUST = R.ACCOUNT<AC.DATE.LAST.CR.CUST>
                Y.DATE.LAST.DR.CUST = R.ACCOUNT<AC.DATE.LAST.DR.CUST>
            END
        END
    END
*TUS END
    IF Y.DATE.LAST.CR.CUST GT Y.DATE.LAST.DR.CUST THEN
        Y.LAST.TRANSACTION.DATE   = Y.DATE.LAST.CR.CUST
        Y.TRANS.DESCRIP           = "CREDITO"
    END ELSE
        Y.LAST.TRANSACTION.DATE   = Y.DATE.LAST.DR.CUST
        Y.TRANS.DESCRIP           = "DEBITO"
    END

    Y.OPENING.DATE = R.ACCOUNT<AC.OPENING.DATE>
    Y.COVERAGE.ACCOUNT.NUM= R.ACCOUNT<AC.LIMIT.REF>

RETURN

NULL.VALUE:
***********

    Y.AGENCY            = '' ; Y.ACCOUNT.EXECUTIVE = '' ; Y.SHORT.NAME        = '' ; Y.ACCT.NO           = ''
    Y.CARD.ISSUE.ID     = '' ; Y.CLIENT.CODE       = '' ; Y.CURRENCY          = '' ; Y.TOTAL.BALANCE     = ''
    Y.AVAILABLE.BALANCE = '' ; Y.IN.TRANSIT.BALANCE= '' ; Y.AC.STATUS.1       = '' ; Y.AC.STATUS.2       = ''
    Y.LAST.TRANSACTION.DATE = '' ; Y.TRANS.DESCRIP     = '' ; Y.OPENING.DATE      = '' ; Y.CANCELLATION.DATE = ''
    Y.COVERAGE.ACCOUNT.NUM = '' ; Y.CLASSIFICATION    = ''

RETURN
*------------------------------------------------------------------------------------------------------------------------
* PROGRAM END
*------------------------------------------------------------------------------------------------------------------------
