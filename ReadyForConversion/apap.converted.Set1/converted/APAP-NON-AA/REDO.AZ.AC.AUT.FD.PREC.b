SUBROUTINE REDO.AZ.AC.AUT.FD.PREC
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AZ.AC.AUT.FD.PREC
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a AUTHORIZATION ROUTINE attached to the version AZ.ACCOUNT,FD.PRECLOSE
*                    It is to discount the penalty amount from Net amount of the Deposit which is preclosed
*In Parameter      :
*Out Parameter     :
*Files  Used       : AZ.ACCOUNT               As             I/O          Mode
*                    REDO.AZ.DISCOUNT.RATE
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  20/06/2010       REKHA S            ODR-2009-10-0336 N.18      Initial Creation
*  23/08/2011       Bharath G          PACS00103342               Account Entries modified for Nominated Account
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.USER
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.REDO.CLOSE.ACCT

    GOSUB INIT
    GOSUB MAIN.PROCESS
    GOSUB WROK.FILE.UPD
RETURN

*--------------------------------------------------------------------
WROK.FILE.UPD:
*--------------------------------------------------------------------
    FN.REDO.CLOSE.ACCT = 'F.REDO.CLOSE.ACCT'
    F.REDO.CLOSE.ACCT = ''
    CALL OPF(FN.REDO.CLOSE.ACCT,F.REDO.CLOSE.ACCT)

    R.REDO.CLOSE.ACCT<REDO.ACCT.LIQ.ACCOUNT> = R.NEW(AZ.INTEREST.LIQU.ACCT)
    R.REDO.CLOSE.ACCT<REDO.ACCT.CUST> = R.NEW(AZ.CUSTOMER)
    R.REDO.CLOSE.ACCT<REDO.ACCT.PRODUCT> = R.NEW(AZ.ALL.IN.ONE.PRODUCT)
    CALL F.WRITE(FN.REDO.CLOSE.ACCT,ID.NEW,R.REDO.CLOSE.ACCT)

RETURN
*--------------------------------------------------------------------------------------------------------
INIT:
*****
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AZ.PRODUCT.PARAMETER = 'F.AZ.PRODUCT.PARAMETER'

    R.OFS=''

RETURN

*---------------------------------------------------------------------------------------------------------
MAIN.PROCESS:
*************

    GOSUB GET.LOCAL.FLD.POS

    GOSUB GET.TXN.CODE

    INT.LIQ.ACCT = R.NEW(AZ.INTEREST.LIQU.ACCT)
    CALL F.READ(FN.ACCOUNT,INT.LIQ.ACCT,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR1)
    INT.LIQ.ONL.BAL=R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.AV.BAL>
    DEPOSIT.AC = ID.NEW
    CALL F.READ(FN.ACCOUNT,DEPOSIT.AC,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR2)
    IF R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PENAL.AMT> GT 0 THEN
        PENALTY.AMOUNT = R.NEW(AZ.LOCAL.REF)<1,LOC.L.AZ.PENAL.AMT>
        GOSUB PEN.AMT.ACCOUNTING
    END
    IF INT.LIQ.ACCT NE '' THEN
        GOSUB REMOVE.INT.LIQ.ACC  ;* Removes interest liq account from az base account
        OFSRECORD=OFSRECORD.ACC
        OPTIONS=''
        CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SRC,OPTIONS)
    END
RETURN
*----------------------------------------------------------------------------------------------------------
GET.TXN.CODE:
*************
    Y.CATEGORY = R.NEW(AZ.ALL.IN.ONE.PRODUCT)
    CALL CACHE.READ(FN.AZ.PRODUCT.PARAMETER,Y.CATEGORY,R.AZ.PRODUCT.PARAMETER,Y.AZ.ERR)
    IF R.AZ.PRODUCT.PARAMETER AND Y.AZ.ERR EQ '' THEN
        Y.DR.CODE =  R.AZ.PRODUCT.PARAMETER<AZ.APP.DR.TXN.CODE>
        Y.CR.CODE = R.AZ.PRODUCT.PARAMETER<AZ.APP.CR.TXN.CODE>
    END
RETURN
*----------------------------------------------------------------------------------------------------------
GET.LOCAL.FLD.POS:
******************

    APPL.ARRAY = 'AZ.ACCOUNT':@FM:'ACCOUNT'
    FLD.ARRAY  = 'L.AZ.PENAL.PER':@VM:'L.AZ.PENAL.AMT':@VM:'L.TYPE.INT.PAY':@FM:'L.AC.REINVESTED':@VM:'L.AC.AV.BAL'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.AZ.PENAL.PER = FLD.POS<1,1>
    LOC.L.AZ.PENAL.AMT = FLD.POS<1,2>
    POS.L.TYPE.INT.PAY=  FLD.POS<1,3>
    LOC.L.AC.REINVESTED = FLD.POS<2,1>
    POS.L.AC.AV.BAL     = FLD.POS<2,2>

RETURN
*----------------------------------------------------------------------------------------------------------
PEN.AMT.ACCOUNTING:
*******************
* To raise accounting entries

    YENTRY.REC = ''

    Y.ACCT.OFF = R.ACCOUNT<AC.ACCOUNT.OFFICER>

    IF R.ACCOUNT<AC.LOCAL.REF><1,LOC.L.AC.REINVESTED> EQ 'YES' OR R.NEW(AZ.LOCAL.REF)<1,POS.L.TYPE.INT.PAY> EQ 'Reinvested' THEN
        Y.AMOUNT = -1 * PENALTY.AMOUNT
        Y.DR.ACCT = INT.LIQ.ACCT

        GOSUB BUILD.DR1.ENTRY

        Y.AMOUNT = PENALTY.AMOUNT
        GOSUB BUILD.CR.ENTRY
    END ELSE          ;* Debits the az.acc and credit PL categ
        Y.AMOUNT = -1 * PENALTY.AMOUNT
        VAR.NOM.ACC = R.NEW(AZ.NOMINATED.ACCOUNT)     ;* PACS00103342
        IF VAR.NOM.ACC THEN
            Y.DR.ACCT = VAR.NOM.ACC
        END ELSE
            Y.DR.ACCT = ID.NEW
        END

        GOSUB BUILD.DR2.ENTRY

        Y.AMOUNT = PENALTY.AMOUNT
        GOSUB BUILD.CR.ENTRY
    END
    Y.TYPE='SAO'
    Y.PREV.STMT.NO = R.NEW(AZ.STMT.NO)
*    CALL EB.ACCOUNTING.WRAPPER('AZ',Y.TYPE,YENTRY.REC,'',EB.ACCT.ERR.MSG)
    CALL EB.ACCOUNTING('AZ',Y.TYPE,YENTRY.REC,'')
    Y.ST.NO.POS = DCOUNT(R.NEW(AZ.STMT.NO),@VM) + 1
    R.NEW(AZ.STMT.NO)<1,Y.ST.NO.POS> = Y.PREV.STMT.NO
RETURN
*----------------------------------------------------------------------------------------------------------
BUILD.DR1.ENTRY:
***************
* For stmt entry
    CALL F.READ(FN.ACCOUNT,Y.DR.ACCT,R.ACCT,F.ACCOUNT,ACCT.ERR)
    VAR.CUST  =R.ACCT<AC.CUSTOMER>
    ENTRY1.REC=""
    Y.VAR.CUR =R.ACCT<AC.CURRENCY>
    Y.POS.TYPE=R.ACCT<AC.POSITION.TYPE>
    ENTRY1.REC<AC.STE.ACCOUNT.NUMBER> = Y.DR.ACCT
    IF Y.VAR.CUR EQ LCCY THEN
        ENTRY1.REC<AC.STE.AMOUNT.LCY> = Y.AMOUNT
    END
    ELSE
        ENTRY1.REC<AC.STE.AMOUNT.FCY>= Y.AMOUNT
        Y.CCY.MARK.EX=1
        Y.AMOUNT.FCY.EX =PENALTY.AMOUNT
        CALL MIDDLE.RATE.CONV.CHECK(Y.AMOUNT.FCY.EX, Y.VAR.CUR, Y.EX.RATE, Y.CCY.MARK.EX, Y.LAMT, Y.DIF.AMT, Y.DIF.RATE)
        ENTRY1.REC<AC.STE.AMOUNT.LCY>= -1 * Y.LAMT
    END
    ENTRY1.REC<AC.STE.TRANSACTION.CODE> = Y.DR.CODE
    ENTRY1.REC<AC.STE.THEIR.REFERENCE> = ID.NEW
    ENTRY1.REC<AC.STE.CUSTOMER.ID> = VAR.CUST
    ENTRY1.REC<AC.STE.ACCOUNT.OFFICER> = Y.ACCT.OFF
    ENTRY1.REC<AC.STE.PRODUCT.CATEGORY> = R.NEW(AZ.CATEGORY)
    ENTRY1.REC<AC.STE.VALUE.DATE> = TODAY
    ENTRY1.REC<AC.STE.CURRENCY> = R.NEW(AZ.CURRENCY)
    ENTRY1.REC<AC.STE.OUR.REFERENCE> = ID.NEW
    ENTRY1.REC<AC.STE.EXPOSURE.DATE> = TODAY
    ENTRY1.REC<AC.STE.TRANS.REFERENCE> = ID.NEW
    ENTRY1.REC<AC.STE.SYSTEM.ID> = 'AC'
    ENTRY1.REC<AC.STE.BOOKING.DATE> = TODAY
    ENTRY1.REC<AC.STE.COMPANY.CODE> = ID.COMPANY
    ENTRY1.REC<AC.STE.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    ENTRY1.REC<AC.STE.CURRENCY.MARKET> = "1"

    YENTRY.REC<-1> = LOWER(ENTRY1.REC)

RETURN
*------------------------------------------------------------------------------------------------------
BUILD.DR2.ENTRY:
***************
* For stmt entry
    CALL F.READ(FN.ACCOUNT,ID.NEW,R.ACCT,F.ACCOUNT,ACCT.ERR)
    VAR.CUST=R.NEW(AZ.CUSTOMER)
    ENTRY2.REC=""
    Y.VAR.CUR=R.NEW(AZ.CURRENCY)
    Y.POS.TYPE=R.ACCT<AC.POSITION.TYPE>
    ENTRY2.REC<AC.STE.ACCOUNT.NUMBER> = Y.DR.ACCT
    IF Y.VAR.CUR EQ LCCY THEN
        ENTRY2.REC<AC.STE.AMOUNT.LCY> = Y.AMOUNT
    END
    ELSE
        ENTRY2.REC<AC.STE.AMOUNT.FCY> = Y.AMOUNT
        Y.CCY.MARK.EX=1
        Y.AMOUNT.FCY.EX =PENALTY.AMOUNT
        CALL MIDDLE.RATE.CONV.CHECK(Y.AMOUNT.FCY.EX, Y.VAR.CUR, Y.EX.RATE, Y.CCY.MARK.EX, Y.LAMT, Y.DIF.AMT, Y.DIF.RATE)
        ENTRY2.REC<AC.STE.AMOUNT.LCY>= -1 * Y.LAMT
    END
    ENTRY2.REC<AC.STE.TRANSACTION.CODE> = Y.DR.CODE
    ENTRY2.REC<AC.STE.THEIR.REFERENCE> = ID.NEW
    ENTRY2.REC<AC.STE.CUSTOMER.ID> = VAR.CUST
    ENTRY2.REC<AC.STE.ACCOUNT.OFFICER> = Y.ACCT.OFF
    ENTRY2.REC<AC.STE.PRODUCT.CATEGORY> = R.NEW(AZ.CATEGORY)
    ENTRY2.REC<AC.STE.VALUE.DATE> = TODAY
    ENTRY2.REC<AC.STE.CURRENCY> = R.NEW(AZ.CURRENCY)
    ENTRY2.REC<AC.STE.OUR.REFERENCE> = ID.NEW
    ENTRY2.REC<AC.STE.EXPOSURE.DATE> = TODAY
    ENTRY2.REC<AC.STE.TRANS.REFERENCE> = ID.NEW
    ENTRY2.REC<AC.STE.SYSTEM.ID> = 'AC'
    ENTRY2.REC<AC.STE.BOOKING.DATE> = TODAY
    ENTRY2.REC<AC.STE.COMPANY.CODE> = ID.COMPANY
    ENTRY2.REC<AC.STE.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    ENTRY2.REC<AC.STE.CURRENCY.MARKET> = "1"

    YENTRY.REC<-1> = LOWER(ENTRY2.REC)

RETURN

*---------------------------------------------------------------------------------------------------------
BUILD.CR.ENTRY:
***************
* For categ entry

    AENTRY.REC=""
    IF Y.VAR.CUR EQ LCCY THEN
        AENTRY.REC<AC.CAT.AMOUNT.LCY> = Y.AMOUNT
    END
    ELSE
        AENTRY.REC<AC.CAT.AMOUNT.FCY>=Y.AMOUNT
        AENTRY.REC<AC.CAT.AMOUNT.LCY>=Y.LAMT
    END
    AENTRY.REC<AC.CAT.POSITION.TYPE> = Y.POS.TYPE
    AENTRY.REC<AC.CAT.TRANSACTION.CODE> = Y.CR.CODE
    AENTRY.REC<AC.CAT.PL.CATEGORY> = '50000'
    AENTRY.REC<AC.CAT.CUSTOMER.ID> = VAR.CUST
    AENTRY.REC<AC.CAT.ACCOUNT.OFFICER> = Y.ACCT.OFF
    AENTRY.REC<AC.CAT.PRODUCT.CATEGORY> = R.NEW(AZ.CATEGORY)
    AENTRY.REC<AC.CAT.VALUE.DATE> = TODAY
    AENTRY.REC<AC.CAT.CURRENCY> = R.NEW(AZ.CURRENCY)
    AENTRY.REC<AC.CAT.OUR.REFERENCE> = ID.NEW
    AENTRY.REC<AC.CAT.EXPOSURE.DATE> = TODAY
    AENTRY.REC<AC.CAT.TRANS.REFERENCE> = ID.NEW
    AENTRY.REC<AC.CAT.SYSTEM.ID>= 'AC'
    AENTRY.REC<AC.CAT.BOOKING.DATE> = TODAY
    AENTRY.REC<AC.CAT.COMPANY.CODE> = ID.COMPANY
    AENTRY.REC<AC.CAT.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    AENTRY.REC<AC.CAT.CURRENCY.MARKET> = "1"

    YENTRY.REC<-1> = LOWER(AENTRY.REC)
RETURN
*----------------------------------------------------------------------------
REMOVE.INT.LIQ.ACC:
*----------------------------------------------------------------------------
* This part posts an OFS message to remove the interest liq account from AZ base account

    R.ACCOUNT<AC.INTEREST.LIQU.ACCT>='NULL'
    APP.NAME = 'ACCOUNT'
    OFSFUNCT='I'
    PROCESS  = ''
    OFSVERSION = 'ACCOUNT,REDO.LIQ.ACC'
    GTSMODE = ''
    TRANSACTION.ID=DEPOSIT.AC
    OFSRECORD = ''
    OFS.MSG.ID =''
    OFS.ERR = ''
    OFS.SRC='REDO.OFS.AZ.UPDATE'
    NO.OF.AUTH=0
    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.ACCOUNT,OFSRECORD.ACC)
RETURN

END
