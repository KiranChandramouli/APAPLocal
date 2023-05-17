SUBROUTINE LATAM.CARD.ORDER.SPLIT.AUTH
*-----------------------------------------------------------------------------
* DESCRIPTION
*-----------
* This is a routine will be called by LATAM.CARD.ORDER during authorization
*
*-------------------------------------------------------------------------------------
* This subroutine caters the following task :-
* This routine will update the CARD.ISSUE application when a changes made is LATAM.CARD.ORDER
* table through OFS
*-----------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN     : -na-
* OUT    : -na-
* Dependencies
* ------------
*
*-------------------------------------------------------------------------------------------
* Revision History
*-------------------------
*    Date             Who                     Reference       Description
* 27-Oct-2008        Mohan.N                 STBP20081027     Initial Creation
* 12-NOV-2008        Kavitha.S               STBP20081212     Stock Maintainence related values
*                                                             are passed into local fields instead of core fields
*                                                             to avoid updation of STOCK.REGISTER twice
* 12-MAR-2010        Gassali.S.K            ODR-2009-12-0264  Updating the value of CARD.ISSUE with the new fields
*                                                             added in LATAM.CARD.ORDER
* 02-08-2010         Manju.G                ODR-2010-06-0322  CURR.NO check was modified
* 20 MAY 2011        KAVITHA                PACS00024249      STOCK REGISTER updation has been removed as new design has been implemented for stock maintainence
* 24 MAY 2011        Prabhu N               PACS00060198      DCARD.RECEIPT is added as new deal slip-Line 336
* 8 AUG 2011         KAVITHA                PACS00093181      PACS00093181  FIX
* 17 OCT 2011        KAVITHA                PACS00142989      ALTERNATE A/C LOGIC INCLUDED
* 05-APR-2018        GOPALA KRISHNAN R      PACS00662965      The customer can owner one principal card and many additional cards,
*                                                             but in the ACCOUNT related register only two can be filled
*                                                             in the fields ALT.ACCT.ID (T.DEBITO.1/T.DEBITO.2).
* 16-NOV-2018        GOPALA KRISHNAN R      PACS00712637      Fix Issue
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DEAL.SLIP.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.STOCK.ENTRY
    $INSERT I_F.STOCK.REGISTER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.LATAM.CARD.REGISTER
*   $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.LATAM.CARD.CUSTOMER
    $INSERT I_F.CARD.ISSUE
    $INSERT I_F.ALTERNATE.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.REDO.CARD.GENERATION
    $INSERT I_F.REDO.CARD.NUMBERS
    $INSERT I_F.REDO.CARD.SERIES.PARAM
    $INSERT I_F.REDO.STOCK.REGISTER
    $INSERT I_F.LATAM.CARD.CHARGES
*-----------------------------------------------------------------------------

    GOSUB INITIALIZE
    GOSUB OPEN.FILE

    GOSUB PROCESS

    GOSUB PRINT.DEAL.SLIP

*PACS00093181-S

    IF R.NEW(CARD.IS.CARD.STATUS) EQ 52 THEN
        GOSUB CANCEL.RENEW.REQUEST
    END
    REN.NOTE = R.NEW(CARD.IS.RENEWAL.NOTES)

    IF R.NEW(CARD.IS.CARD.STATUS) EQ 94 THEN
        IF REN.NOTE EQ "RENEWAL CARD ISSUE" THEN
            R.NEW(CARD.IS.RENEW.STATUS) = ''
            R.NEW(CARD.IS.RENEW.REQ.ID) = ''
            R.NEW(CARD.IS.RENEWAL.NOTES) = ''
        END
    END

*PACS00093181-E

    IF GET.CARD.STATUS EQ "90" AND R.NEW(CARD.IS.APPLY.PERIOD.CHG) EQ "YES" THEN
        R.LATAM.CARD.CHARGE<LATAM.CHG.ISSUE.DATE> = R.NEW(CARD.IS.ISSUE.DATE)
        R.LATAM.CARD.CHARGE<LATAM.CHG.EXPIRY.DATE> = R.NEW(CARD.IS.EXPIRY.DATE)
        R.LATAM.CARD.CHARGE<LATAM.CHG.ACCOUNT> = GET.CARD.ACCT.NO
        R.LATAM.CARD.CHARGE<LATAM.CHG.CUSTOMER> =  ACCT.CUSTOMER
        CALL F.WRITE(FN.LATAM.CARD.CHARGE,ID.NEW,R.LATAM.CARD.CHARGE)
    END

    IF GET.CARD.STATUS EQ "97" THEN
        CALL F.DELETE(FN.LATAM.CARD.CHARGE,ID.NEW)
    END
RETURN
*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
*
    RECORD = ''
    CHANGE.FLAG = ''
    R.LATAM.CARD.CHARGE = ''
    OFS.MSG.ID = ''
    OFS.MSG.IS = ''
    CARD.ISSUE.ID = ID.NEW
    R.CARD.ISSUE = ''

    CARD.CURR = ''
    CARD.NAME = ''
    CARD.LT = ''
    R.REQ.RECORD = ''
    CANCL.DATE = ''
    CANCL.REAS = ''
    CHRG.DATE = ''
    REG.ID = ''
    SER.ID = ''
    ACCT.NO = ''
    CUST.NO = ''
    ACCT.OFF = ''
    PLACE.DELIV = ''
    DELIV.ADDR = ''
    ISSUE.TYPE = ''
    ISS.STAGE = ''
    ISSUE.IND = ''
    ISSUE.NO = ''
    REASON = ''
    CARD.NO = ''
    NAME.PLASTIC = ''
    FLD.POS = ''

    GET.DEB.PRINCIPAL = ''
    ACCOUNT.TYPE = ''
    ACCOUNT.ID = ''
    GET.TYPE.OF.CARD = ''

    GET.CARD.ACCT.NO = ''

    GET.DEB.ADDITIONAL = ''
    GET.DEB.PRINCIPAL = ''

RETURN
*---------------------------------------------------------------------------------------------------------
OPEN.FILE:
*------------------------------------------------------------------------------------------

    FN.CARD.ORDER = "F.LATAM.CARD.ORDER"
    F.CARD.ORDER = ""
    CALL OPF(FN.CARD.ORDER,F.CARD.ORDER)

    FN.CARD.CUSTOMER = "F.LATAM.CARD.CUSTOMER"
    F.CARD.CUSTOMER = ""
    CALL OPF(FN.CARD.CUSTOMER,F.CARD.CUSTOMER)

    FN.ALT.ACCT = 'F.ALTERNATE.ACCOUNT'
    F.ALT.ACCT = ''
    CALL OPF(FN.ALT.ACCT,F.ALT.ACCT)

    FN.STOCK.ENTRY = 'F.STOCK.ENTRY'
    F.STOCK.ENTRY = ''
    CALL OPF(FN.STOCK.ENTRY,F.STOCK.ENTRY)

    FN.STOCK.REGISTER = 'F.STOCK.REGISTER'
    F.STOCK.REGISTER = ''
    CALL OPF(FN.STOCK.REGISTER,F.STOCK.REGISTER)

    R.STOCK.REGISTER = ''
    REG.ID = ''
    NO.DAMAGE.CARD = ''
    NULL.VALUE = " "

    FN.CARD.REGISTER = "F.LATAM.CARD.REGISTER"
    F.CARD.REGISTER = ''
    CALL OPF(FN.CARD.REGISTER,F.CARD.REGISTER)

*PACS00093181-S

    FN.REDO.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST = ''
    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

    FN.REDO.CARD.GENERATION = 'F.REDO.CARD.GENERATION'
    F.REDO.CARD.GENERATION = ''
    CALL OPF(FN.REDO.CARD.GENERATION,F.REDO.CARD.GENERATION)

    FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
    F.REDO.CARD.NUMBERS = ''
    CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

    FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
    F.REDO.CARD.SERIES.PARAM = ''
    CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)

    Y.ID.CARD.SERIES = 'SYSTEM'
    CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM',Y.ID.CARD.SERIES,R.REDO.CARD.SERIES.PARAM,PARAM.ERR)
    RECD.DEPT.CODE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.RECEIVE.DEPT.CODE>
    EMBOSS.DEPT = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.EMBOSS.DEPT.CODE>
    TRANSIT.DEPT = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.TRANSIT.DEPT.CODE>
    CARD.TYPE.LIST = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.TYPE>
    CARD.SERIES.LIST = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.SERIES>

    FN.STOCK.REG = 'F.REDO.STOCK.REGISTER'
    F.STOCK.REG = ''
    CALL OPF(FN.STOCK.REG,F.STOCK.REG)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


    OFS.HEADER = ''
    OFS.MSG = ''

*PACS00093181-E

    FN.LATAM.CARD.CHARGE = 'F.LATAM.CARD.CHARGES'
    F.LATAM.CARD.CHARGE = ''
    CALL OPF(FN.LATAM.CARD.CHARGE,F.LATAM.CARD.CHARGE)
RETURN
*------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------

    FETCH.CARD.NO = FIELD(ID.NEW,".",2)
    GET.CARD.ACCT.NO = R.NEW(CARD.IS.ACCOUNT)
    GET.CARD.STATUS =  R.NEW(CARD.IS.CARD.STATUS)
    GET.TYPE.OF.CARD = R.NEW(CARD.IS.TYPE.OF.CARD)
    CALL F.READ(FN.ACCOUNT,GET.CARD.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT THEN
        ACCT.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
        ACCOUNT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
        ACCOUNT.ID = R.ACCOUNT<AC.ALT.ACCT.ID>
    END

    CHANGE @VM TO @FM IN ACCOUNT.TYPE
    CHANGE @VM TO @FM IN ACCOUNT.ID

    IF GET.CARD.STATUS EQ "90" OR GET.CARD.STATUS EQ "94" THEN
        IF GET.TYPE.OF.CARD EQ "PRINCIPAL" THEN
            GOSUB ASSIGN.PRINC.CARD
        END

        IF GET.TYPE.OF.CARD EQ "ADICIONAL" THEN
            GOSUB ASSIGN.ADD.CARD
        END

    END


    IF GET.CARD.STATUS EQ 52 OR  GET.CARD.STATUS EQ 92 OR  GET.CARD.STATUS EQ 93 OR  GET.CARD.STATUS EQ 95 OR  GET.CARD.STATUS EQ 97 OR  GET.CARD.STATUS EQ 60 THEN       ;*PACS00712637

        IF GET.TYPE.OF.CARD EQ "PRINCIPAL" THEN
            P.TYPE.POS = ''
            LOCATE "T.DEBITO.1" IN ACCOUNT.TYPE SETTING P.TYPE.POS THEN
                R.ACCOUNT<AC.ALT.ACCT.ID,P.TYPE.POS> = ''
                CALL F.DELETE(FN.ALT.ACCT,FETCH.CARD.NO)
            END
        END

        IF GET.TYPE.OF.CARD EQ "ADICIONAL" THEN
            A.TYPE.POS = ''
            LOCATE "T.DEBITO.2" IN ACCOUNT.TYPE SETTING A.TYPE.POS THEN
                R.ACCOUNT<AC.ALT.ACCT.ID,A.TYPE.POS> = ''
                CALL F.DELETE(FN.ALT.ACCT,FETCH.CARD.NO)
            END
        END

    END


    CALL F.WRITE(FN.ACCOUNT,GET.CARD.ACCT.NO,R.ACCOUNT)


RETURN
*-------------------------------------------------------------------------
ASSIGN.PRINC.CARD:

    P.TYPE.POS = ''
    LOCATE "T.DEBITO.1" IN ACCOUNT.TYPE SETTING P.TYPE.POS THEN
        GET.DEB.PRINCIPAL = ACCOUNT.ID<P.TYPE.POS>
        IF NOT(GET.DEB.PRINCIPAL) THEN
            R.ACCOUNT<AC.ALT.ACCT.ID,P.TYPE.POS> = FETCH.CARD.NO
            R.ALT.ACCT = GET.CARD.ACCT.NO
            CALL F.WRITE(FN.ALT.ACCT,FETCH.CARD.NO,R.ALT.ACCT)
        END
    END

RETURN
*-----------------------------------------------------------------------------
ASSIGN.ADD.CARD:

    A.TYPE.POS = ''
    LOCATE "T.DEBITO.2" IN ACCOUNT.TYPE SETTING A.TYPE.POS THEN
        GET.DEB.ADDITIONAL = ACCOUNT.ID<A.TYPE.POS>
*    IF NOT(GET.DEB.ADDITIONAL) THEN                                 ;*PACS00662965
        R.ACCOUNT<AC.ALT.ACCT.ID,A.TYPE.POS> = FETCH.CARD.NO
        R.ALT.ACCT = GET.CARD.ACCT.NO
        CALL F.WRITE(FN.ALT.ACCT,FETCH.CARD.NO,R.ALT.ACCT)
    END

RETURN
*-------------------------------------------------------------------------
PRINT.DEAL.SLIP:
*-------------------------------------------------------------------------
* Produce deal slip for card, when it is issued and blocked
*PACS00060198-start of modificaton------------------------------------------
    CARD.STATUS = R.NEW(CARD.IS.CARD.STATUS)
    BEGIN CASE
        CASE CARD.STATUS EQ '90' OR CARD.STATUS EQ '74'
            DEAL.SLIP.FORMAT = 'DCARD.RECEIPT'
            OFS$DEAL.SLIP.PRINTING = 1
            CALL PRODUCE.DEAL.SLIP(DEAL.SLIP.FORMAT)

    END CASE
*----end of modification-PACS00060198--------------------------------------

RETURN
*---------------------------------------End-------------------------------
CANCEL.RENEW.REQUEST:

    GET.RENEW.ID = R.NEW(CARD.IS.RENEW.REQ.ID)
    R.REDO.CARD.REQUEST = ''

    CALL F.READU(FN.REDO.CARD.REQUEST,GET.RENEW.ID,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,REQ.ERR,"")
    IF R.REDO.CARD.REQUEST THEN
        GET.CURR.STATUS = R.REDO.CARD.REQUEST<REDO.CARD.REQ.STATUS>
        R.REQ.RECORD<REDO.CARD.REQ.STATUS> = 8
        R.REQ.RECORD<REDO.CARD.REQ.COMMENTS> = "ACTIVE CARD LOST"
        AGENCY = R.REDO.CARD.REQUEST<REDO.CARD.REQ.AGENCY>
    END

    Y.OFSVERSION = "REDO.CARD.REQUEST,OFS"
    Y.APP.NAME =  "REDO.CARD.REQUEST"
    Y.OFSFUNCT = 'I'
    Y.PROCESS = "PROCESS"
    Y.GTSMODE = ""
    Y.NO.OF.AUTH = "0"
    Y.TRANSACTION.ID = GET.RENEW.ID
    Y.OFSRECORD = ""

    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.OFSFUNCT,Y.PROCESS,Y.OFSVERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.TRANSACTION.ID,R.REQ.RECORD,Y.OFSRECORD)

    Y.MSG = Y.OFSRECORD
    Y.MSG.KEY = ""
    Y.OFS.SOURCE.ID = "DEBIT.CARD"
    Y.OPTIONS = ""

    CALL OFS.POST.MESSAGE(Y.MSG,Y.MSG.KEY,Y.OFS.SOURCE.ID,Y.OPTIONS)


    R.REDO.CARD.GENERATION = ''
    CALL F.READU(FN.REDO.CARD.GENERATION,GET.RENEW.ID,R.REDO.CARD.GENERATION,F.REDO.CARD.GENERATION,GEN.ERR,"")

    IF R.REDO.CARD.GENERATION THEN
        GET.CARD.NO = R.REDO.CARD.GENERATION<REDO.CARD.GEN.CARD.NUMBERS,1,1>
    END

    GET.ID.CARD.TYPE = FIELD(ID.NEW,'.',1)
    Y.REDO.CARD.NUMBERS.ID = GET.ID.CARD.TYPE:'.':AGENCY

    R.REDO.CARD.NUMBERS = ''
    CALL F.READU(FN.REDO.CARD.NUMBERS,Y.REDO.CARD.NUMBERS.ID,R.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS,REDO.CARD.NUMBERS.ERR,'P')
    IF R.REDO.CARD.NUMBERS THEN
        FLAG.LOST=0
        LOCATE GET.CARD.NO IN R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER,1> SETTING POS.CARD THEN
            IF R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,POS.CARD> EQ 'LOST' THEN
                FLAG.LOST=1
            END
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,POS.CARD> = "LOST"
        END
        CALL F.WRITE(FN.REDO.CARD.NUMBERS,Y.REDO.CARD.NUMBERS.ID,R.REDO.CARD.NUMBERS)
    END

    HEAD.OFFICE = R.COMPANY(EB.COM.FINANCIAL.COM)

    BEGIN CASE

        CASE GET.CURR.STATUS EQ 4
            Y.STOCK.REGISTER.ID =  'CARD.':HEAD.OFFICE:"-":EMBOSS.DEPT

        CASE GET.CURR.STATUS EQ 5
            Y.STOCK.REGISTER.ID =  'CARD.':HEAD.OFFICE:"-":TRANSIT.DEPT

        CASE GET.CURR.STATUS EQ 6
            Y.STOCK.REGISTER.ID =  'CARD.':ID.COMPANY:"-":RECD.DEPT.CODE

    END CASE

    CHANGE @VM TO @FM IN CARD.TYPE.LIST
    CHANGE @VM TO @FM IN CARD.SERIES.LIST

    LOCATE GET.ID.CARD.TYPE IN CARD.TYPE.LIST SETTING PARAM.POS THEN
        Y.SERIES.ID = CARD.SERIES.LIST<PARAM.POS>
    END
    IF FLAG.LOST NE 1 THEN
        R.STOCK.REGISTER   =''
        STOCK.REGISTER.ERR = ''
        CALL F.READU(FN.STOCK.REG,Y.STOCK.REGISTER.ID,R.STOCK.REGISTER,F.STOCK.REG,STOCK.REGISTER.ERR,'')

        IF R.STOCK.REGISTER THEN
            STOCK.SERIES.ID = R.STOCK.REGISTER<STK.REG.SERIES.ID>
            CHANGE @VM TO @FM IN STOCK.SERIES.ID
        END

        LOCATE Y.SERIES.ID IN STOCK.SERIES.ID SETTING Y.SERIES.ID.POS THEN

            R.STOCK.REGISTER<STK.REG.SERIES.BAL,Y.SERIES.ID.POS> = R.STOCK.REGISTER<STK.REG.SERIES.BAL,Y.SERIES.ID.POS> - 1
            R.STOCK.REGISTER<STK.REG.STO.REG.BAL> = R.STOCK.REGISTER<STK.REG.STO.REG.BAL> - 1

        END
* PACS00755208 - S
        IF R.STOCK.REGISTER<STK.REG.SERIES.BAL,Y.SERIES.ID.POS> LT '0' THEN
            R.STOCK.REGISTER<STK.REG.SERIES.BAL,Y.SERIES.ID.POS> = '0'
        END
* PACS00755208 - E
        CALL F.WRITE(FN.STOCK.REG,Y.STOCK.REGISTER.ID,R.STOCK.REGISTER)
    END
RETURN
*---------------------------------------End-------------------------------
END
