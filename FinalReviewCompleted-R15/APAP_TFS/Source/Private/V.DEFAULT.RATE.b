* @ValidationCode : MjoyMTE3MzY2ODQ4OkNwMTI1MjoxNjk4NzUwNjc0Njc5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>556</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE V.DEFAULT.RATE
*
* Subroutine Type : VERSION
* Attached to     : ALL TFS VERSION
* Attached as     : FIELD.VAL.RTN
* Primary Purpose : Default the DEAL.RATE field
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
* ----------------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* 05/29/08 - Geetha Balaji
*            CHNG060608
*            Enhancement to default the DEAL.RATE in TFS transactions.
*            For TT txns involving FCY, the deal rate is to be defaulted with
*            the cust rate. This is done to override the Mid-Reval rate that the
*            Teller utilises and pass on the appropriate Buy/Sell rate.
*
* 10/09/08 - Geetha Balaji
*            NSCU Gap 40
*            When Deal rate is specified in TFS txn then do not default the Buy/Sell Rate.
*
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion           GLOBUS.BP ,USPLATFORM.BP File is Removed
*

    $INCLUDE  I_COMMON ;*R22 Manual Conversion - start
    $INCLUDE  I_EQUATE
    $INCLUDE  I_GTS.COMMON
    $INCLUDE  I_F.TELLER
    $INCLUDE  I_F.TRANSACTION
    $INCLUDE  I_F.TELLER.TRANSACTION
    $INCLUDE  I_F.CURRENCY
    $INCLUDE  I_T24.FS.COMMON
    $INCLUDE  I_F.TFS.PARAMETER ;*R22 Manual Conversion - End

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN          ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:

    IF DR.OR.CR EQ 'CREDIT' THEN
        BUY.CCY = OTHER.CCY ; BUY.AMT = 1 ; SELL.CCY = WTHRU.CCY ; SELL.AMT = ''
    END ELSE
        BUY.CCY = WTHRU.CCY ; BUY.AMT = '' ; SELL.CCY = OTHER.CCY ; SELL.AMT = 1
    END
    TR.RATE = ''; LCY.AMT1 = '' ; LCY.AMT2 = '' ; CUST.SPREAD = '' ; SPREAD.PCT = '' ; CUST.RATE = '' ; RET.CODE = ''

    IF BUY.CCY NE SELL.CCY THEN
        CALL CUSTRATE(CCY.MKT,BUY.CCY,BUY.AMT,SELL.CCY,SELL.AMT,'',TR.RATE,CUST.RATE,CUST.SPREAD,SPREAD.PCT,LCY.AMT1,LCY.AMT2,RET.CODE)

        R.NEW(TT.TE.DEAL.RATE) = CUST.RATE
    END

RETURN          ;* from PROCESS
*-----------------------------------------------------------------------------------
* <New Subroutines>

* </New Subroutines>
*-----------------------------------------------------------------------------------*
*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:

    PROCESS.GOAHEAD = 1

    WTHRU.CCY = '' ; OTHER.CCY = '' ; BUY.AMT = '' ; SELL.AMT = ''
    BUY.CCY = '' ; SELL.CCY = '' ; CCY.MKT = ''

    Y.DEAL.RATE = ''

RETURN          ;* From INITIALISE
*-----------------------------------------------------------------------------------
OPEN.FILES:

    FN.TTXN = 'F.TELLER.TRANSACTION' ; F.TTXN = ''
    CALL OPF(FN.TTXN, F.TTXN)

    FN.TXN = 'F.TRANSACTION' ; F.TXN = ''
    CALL OPF(FN.TXN, F.TXN)

RETURN          ;* From OPEN.FILES
*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
    LOOP.CNT = 1 ; MAX.LOOPS = 5 ; * Gap 40 - 10/09/08 S/E
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO

        BEGIN CASE
            CASE LOOP.CNT EQ 1
                TELLER.TXN.CODE = R.NEW(TT.TE.TRANSACTION.CODE)

* Need not default Deal rate if this is a netting entry, since that will only involve local ccys.
                IF TELLER.TXN.CODE EQ '97' THEN PROCESS.GOAHEAD = 0

* Gap 40 - 10/09/08 S
            CASE LOOP.CNT EQ 2
                Y.DEAL.RATE = R.NEW(TT.TE.DEAL.RATE)
                IF Y.DEAL.RATE THEN PROCESS.GOAHEAD = 0
* Gap 40 - 10/09/08 E

            CASE LOOP.CNT EQ 3

                ACCT.1 = R.NEW(TT.TE.ACCOUNT.1)
                ACCT.CCY.1 = R.NEW(TT.TE.CURRENCY.1)
                ACCT.2 = R.NEW(TT.TE.ACCOUNT.2)
                ACCT.CCY.2 = R.NEW(TT.TE.CURRENCY.2)

* Need not default Deal rate if the transaction involves LCCY alone.
                IF (ACCT.CCY.1 EQ ACCT.CCY.2) AND (ACCT.CCY.1 EQ LCCY) THEN
                    PROCESS.GOAHEAD = 0
                END

            CASE LOOP.CNT EQ 4

                CALL CACHE.READ(FN.TTXN, TELLER.TXN.CODE, R.TTXN, TTXN.ERR)
                IF R.TTXN THEN
* Get the Wash-through side transaction code
                    IF R.TTXN<TT.TR.VALID.ACCOUNTS.1> EQ 'INTERNAL' THEN
                        TTXN.TXN.CODE = R.TTXN<TT.TR.TRANSACTION.CODE.2>
                        CCY.MKT = R.TTXN<TT.TR.CURR.MKT.2>
                        WTHRU.CCY = ACCT.CCY.2
                        OTHER.CCY = ACCT.CCY.1
                    END ELSE
                        TTXN.TXN.CODE = R.TTXN<TT.TR.TRANSACTION.CODE.1>
                        CCY.MKT = R.TTXN<TT.TR.CURR.MKT.1>
                        WTHRU.CCY = ACCT.CCY.1
                        OTHER.CCY = ACCT.CCY.2
                    END
                END

                IF NOT(WTHRU.CCY) OR NOT(OTHER.CCY) THEN PROCESS.GOAHEAD = 0

            CASE LOOP.CNT EQ 5

                CALL CACHE.READ(FN.TXN, TTXN.TXN.CODE, R.TXN, TXN.ERR)
                IF R.TXN THEN
                    DR.OR.CR = R.TXN<AC.TRA.DEBIT.CREDIT.IND>
                END ELSE
                    PROCESS.GOAHEAD = 0
                END

        END CASE
        LOOP.CNT += 1

    REPEAT

RETURN          ;* From CHECK.PRELIM.CONDITIONS
*-----------------------------------------------------------------------------------
END

