*-----------------------------------------------------------------------------
* <Rating>-14</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.RTE.EXCESS.TELLER(Y.TELLER.ID,Y.CCY,Y.AMT,TXN.CNT)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_ENQUIRY.COMMON

    COM/CASHIER.DENOM.ENQ.COMMON/Y.TEMP.DATA

*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.RTE.DENOM.EXCESS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.RTE.DENOM.EXCESS is a call routine to return the transaction count and total amount
*                    exceeded in enquiry REDO.RTE.REPORT
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DENOM

*In  Parameter     : NA
*Out Parameter     : Y.OUT.ARRAY - Output array for display
*Files  Used       : REDO.H.TELLER.TXN.CODES          As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 11 Mar 2011       Shiva Prasad Y              ODR-2011-03-0150 35         Initial Creation
* 01 Jan 2018       Gopala Krishnan R           PACS00641500                Fixing the Issue
*********************************************************************************************************
    Y.TEMP.D.FIELDS           = D.FIELDS
    Y.TEMP.D.LOGICAL.OPERANDS = D.LOGICAL.OPERANDS
    Y.TEMP.D.RANGE.AND.VALUE  = D.RANGE.AND.VALUE

    D.FIELDS           = 'TXN.DATE'
    D.LOGICAL.OPERANDS = '1'
    D.RANGE.AND.VALUE  = TODAY
    Y.DATA = ''

    FN.TELLER = 'F.TELLER'
    F.TELLER  = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    SAVE.CACHE.OFF = CACHE.OFF
    CACHE.OFF = 1
    IF Y.TEMP.DATA EQ '' THEN
        CALL REDO.E.NOF.RTE.RTN(Y.DATA)
        Y.TEMP.DATA = Y.DATA
    END ELSE
        Y.DATA = Y.TEMP.DATA
    END
    CACHE.OFF = SAVE.CACHE.OFF
    Y.DATA.CNT = DCOUNT(Y.DATA,FM)
    Y.DATA.INT = 1
    TXN.CNT    = 0
    Y.AMT      = 0

    LOOP
        REMOVE Y.DATA.ID FROM Y.DATA SETTING Y.DATA.POS
    WHILE Y.DATA.INT LE Y.DATA.CNT
        TXN.ID = FIELD(Y.DATA.ID,'*',1)
        R.TELLER = ''         ;* ; Y.TELLER.1 = '' ; Y.CCY.1 = '' ; Y.TELLER.2 = '' ; Y.CCY.2 = ''
        IF TXN.ID[1,2] EQ 'TT' THEN
            LOCATE TXN.ID IN TELLER.TXN.IDS SETTING TT.POS THEN
                R.TELLER<TT.TE.TELLER.ID.1> = TELLER.1.ID<TT.POS>
                R.TELLER<TT.TE.CURRENCY.1> = CCY.1.ID<TT.POS>
                R.TELLER<TT.TE.TELLER.ID.2> = TELLER.2.ID<TT.POS>
                R.TELLER<TT.TE.CURRENCY.2> = CCY.2.ID<TT.POS>
            END ELSE
                CALL F.READ(FN.TELLER,TXN.ID,R.TELLER,F.TELLER,TELLER.ERR)
                TELLER.TXN.IDS<-1> = TXN.ID
                TELLER.1.ID<-1> = R.TELLER<TT.TE.TELLER.ID.1>
                CCY.1.ID<-1> = R.TELLER<TT.TE.CURRENCY.1>
                TELLER.2.ID<-1> = R.TELLER<TT.TE.TELLER.ID.2>
                CCY.2.ID<-1> = R.TELLER<TT.TE.CURRENCY.2>
            END
        END
        IF R.TELLER THEN
            Y.TELLER.1 = R.TELLER<TT.TE.TELLER.ID.1>
            Y.CCY.1    = R.TELLER<TT.TE.CURRENCY.1>
            Y.TELLER.2 = R.TELLER<TT.TE.TELLER.ID.2>
            Y.CCY.2    = R.TELLER<TT.TE.CURRENCY.2>
        END
        IF Y.TELLER.ID EQ Y.TELLER.1 OR Y.TELLER.ID EQ Y.TELLER.2 THEN
            TXN.CNT++
            Y.AMT += FIELD(Y.DATA.ID,'*',2)
        END
        Y.DATA.INT++
    REPEAT
    RETURN
END
