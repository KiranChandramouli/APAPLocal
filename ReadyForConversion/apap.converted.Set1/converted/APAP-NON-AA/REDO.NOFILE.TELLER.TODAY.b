SUBROUTINE REDO.NOFILE.TELLER.TODAY(RET.ARRAY)

*----------------------------------------------------------------------------------------------------------------------
* Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By      : Temenos Application Management
* Program   Name    : REDO.NOFILE.TELLER.TODAY
*----------------------------------------------------------------------------------------------------------------------
* Description       : Routine to display the list of standalone TT records with reversal option
* Linked With       : ENQ REDO.TELLER.TODAY
* In  Parameter     : N/A
* Out Parameter     : N/A
* Files  Used       : TELLER
*----------------------------------------------------------------------------------------------------------------------
* Modification Details:
* =====================
* Date         Who                  Reference      Description
* ------       -----                ------------   -------------
* 14-10-2013   Vignesh Kumaar M R   PACS00321999   LIST THE STAND-ALONE TT RECORDS WITH REVERSAL OPTION
* 21-04-2015   Vignesh Kumaar M R   PACS00452608   TELLER REVERSAL ENQUIRY SELECTION REVAMP
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.REDO.TRANSACTION.CHAIN

    LOCATE '@ID' IN D.FIELDS<1,1> SETTING INP.POS THEN
        Y.TELLER.ID = D.RANGE.AND.VALUE<INP.POS>
    END

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    FN.RTC = 'F.REDO.TRANSACTION.CHAIN'
    F.RTC = ''
    CALL OPF(FN.RTC,F.RTC)

    IF Y.TELLER.ID[1,2] NE 'TT' THEN
        RETURN
    END

    CALL F.READ(FN.TELLER,Y.TELLER.ID,R.TELLER,F.TELLER,TELLER.ERR)

    LOC.FLD.POS = ''
    LOC.FLD.NME = 'L.ACTUAL.VERSIO':@VM:'L.INITIAL.ID':@VM:'L.NEXT.VERSION':@VM:'T24.FS.REF'
    CALL MULTI.GET.LOC.REF('TELLER',LOC.FLD.NME,LOC.FLD.POS)
    ACTUAL.POS = LOC.FLD.POS<1,1>
    INITIAL.POS = LOC.FLD.POS<1,2>
    NEXT.POS = LOC.FLD.POS<1,3>
    POS.T24.FS.REF = LOC.FLD.POS<1,4>

    Y.INITIAL.ID = R.TELLER<TT.TE.LOCAL.REF,INITIAL.POS>
    Y.NEXT.VAL = R.TELLER<TT.TE.LOCAL.REF,NEXT.POS>

    IF (Y.INITIAL.ID EQ '' OR Y.INITIAL.ID EQ Y.TELLER.ID) AND Y.NEXT.VAL EQ '' ELSE
        RETURN
    END
    IF R.TELLER<TT.TE.LOCAL.REF,POS.T24.FS.REF> NE "" THEN    ;* TT Transactions created for TFS transaction should not be listed in REDO.TELLER.TODAY - PACS00458228
        RETURN
    END


    CALL F.READ(FN.RTC,Y.TELLER.ID,R.REDO.TRANSACTION.CHAIN,F.RTC,RTC.ERR)

    IF R.REDO.TRANSACTION.CHAIN THEN
        RETURN
    END

    Y.TT.CODE = R.TELLER<TT.TE.TRANSACTION.CODE>
    CALL CACHE.READ(FN.TELLER.TRANSACTION, Y.TT.CODE, R.TELLER.TRANSACTION, TELLER.TRANSACTION.ERR)
    Y.DESCRIPTION = R.TELLER.TRANSACTION<TT.TR.SHORT.DESC>
    Y.TELLER.ID.1 = R.TELLER<TT.TE.TELLER.ID.1>
    Y.CURRENCY.1 = R.TELLER<TT.TE.CURRENCY.1>
    Y.CUSTOMER.1 = R.TELLER<TT.TE.CUSTOMER.1>
    Y.ACCOUNT.1 = R.TELLER<TT.TE.ACCOUNT.1>
    Y.AMOUNT.LOCAL.1 = R.TELLER<TT.TE.AMOUNT.LOCAL.1>
    Y.AMOUNT.LOCAL.1 = FMT(Y.AMOUNT.LOCAL.1,"19R,2")

    Y.AMOUNT.FCY.1 = R.TELLER<TT.TE.AMOUNT.FCY.1>
    Y.AMOUNT.FCY.1 = FMT(Y.AMOUNT.FCY.1,"19R,2")

    Y.CURRENCY.2 = R.TELLER<TT.TE.CURRENCY.2>
    Y.TELLER.ID.2 = R.TELLER<TT.TE.TELLER.ID.2>
    Y.ACCOUNT.2 = R.TELLER<TT.TE.ACCOUNT.2>
    Y.CUSTOMER.2 = R.TELLER<TT.TE.CUSTOMER.2>
    Y.AMOUNT.LOCAL.2 = R.TELLER<TT.TE.AMOUNT.LOCAL.2>
    Y.AMOUNT.LOCAL.2 = FMT(Y.AMOUNT.LOCAL.2,"19R,2")

    Y.AMOUNT.FCY.2 = R.TELLER<TT.TE.AMOUNT.FCY.2>
    Y.AMOUNT.FCY.2 = FMT(Y.AMOUNT.FCY.2,"19R,2")

    Y.ACTUAL.VERSION = R.TELLER<TT.TE.LOCAL.REF,ACTUAL.POS>
    RET.ARRAY<-1> = Y.TELLER.ID:'*':Y.DESCRIPTION:'*':Y.TELLER.ID.1:'*':Y.CURRENCY.1:'*':Y.CUSTOMER.1:'*':Y.ACCOUNT.1:'*':Y.AMOUNT.LOCAL.1:'*':Y.AMOUNT.FCY.1:'*':Y.CURRENCY.2:'*':Y.TELLER.ID.2:'*':Y.ACCOUNT.2:'*':Y.CUSTOMER.2:'*':Y.AMOUNT.LOCAL.2:'*':Y.AMOUNT.FCY.2:'*':Y.ACTUAL.VERSION

RETURN
