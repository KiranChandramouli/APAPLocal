SUBROUTINE REDO.APAP.E.CONV.COUPON.BASE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.E.CONV.COUPON.BASE
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.APAP.E.CONV.COUPON.BASE is a conversion routine to calculate the COUPON TENOR and BASE
*Linked With  : Enquiry REDO.APAP.ENQ.EFF.RATE.ACCRUALS
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 30 SEP 2010    Mohammed Anies K      ODR-2010-07-0077        Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.INTEREST.BASIS
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********

    FN.MM.MONEY.MARKET = 'F.MM.MONEY.MARKET'
    F.MM.MONEY.MARKET  = ''
    CALL OPF(FN.MM.MONEY.MARKET,F.MM.MONEY.MARKET)

    FN.INTEREST.BASIS = 'F.INTEREST.BASIS'
    F.INTEREST.BASIS  = ''
    CALL OPF(FN.INTEREST.BASIS,F.INTEREST.BASIS)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

    MM.MONEY.MARKET.ID = O.DATA
    GOSUB READ.MM.MONEY.MARKET

    GOSUB GET.COUPON.TENOR
    GOSUB GET.INTEREST.BASE

    O.DATA = Y.COUPON.TENOR:'*':Y.BASE

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.COUPON.TENOR:
*****************

    Y.START.DATE = R.MM.MONEY.MARKET<MM.INT.PERIOD.START>
    Y.END.DATE   = R.MM.MONEY.MARKET<MM.INT.PERIOD.END>

    IF NOT(Y.START.DATE) OR NOT(Y.END.DATE) THEN
        Y.COUPON.TENOR = ''
        RETURN
    END

    Y.REGION    = ''
    Y.DIFF.DAYS = 'C'
    CALL CDD(Y.REGION,Y.START.DATE,Y.END.DATE,Y.DIFF.DAYS)

    Y.COUPON.TENOR = ABS(Y.DIFF.DAYS)

RETURN
*--------------------------------------------------------------------------------------------------------
******************
GET.INTEREST.BASE:
******************

    INTEREST.BASIS.ID = R.MM.MONEY.MARKET<MM.INTEREST.BASIS>
    IF NOT(INTEREST.BASIS.ID) THEN
        RETURN
    END
    GOSUB READ.INTEREST.BASIS
    IF NOT(R.INTEREST.BASIS) THEN
        RETURN
    END
    Y.BASE = R.INTEREST.BASIS<IB.INT.BASIS>
    Y.BASE = FIELD(Y.BASE,'/',2,1)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
READ.MM.MONEY.MARKET:
*********************

    R.MM.MONEY.MARKET  = ''
    MM.MONEY.MARKET.ER = ''
    CALL F.READ(FN.MM.MONEY.MARKET,MM.MONEY.MARKET.ID,R.MM.MONEY.MARKET,F.MM.MONEY.MARKET,MM.MONEY.MARKET.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
********************
READ.INTEREST.BASIS:
********************

    R.INTEREST.BASIS  = ''
    INTEREST.BASIS.ER = ''
    CALL CACHE.READ(FN.INTEREST.BASIS, INTEREST.BASIS.ID, R.INTEREST.BASIS, INTEREST.BASIS.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
END
