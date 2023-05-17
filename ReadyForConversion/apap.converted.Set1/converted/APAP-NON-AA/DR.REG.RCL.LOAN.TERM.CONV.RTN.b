*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RCL.LOAN.TERM.CONV.RTN

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.TERM.AMOUNT

    TERM.IN.DAYS = ''
    ArrangementID = COMI
    effectiveDate = ''
    idPropertyClass = 'TERM.AMOUNT'
    idProperty = ''
    returnIds = ''
    returnConditions = ''
    returnError = ''

    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.AA.TERM.AMOUNT = RAISE(returnConditions)
*    ACTIVITY = R.AA.TERM.AMOUNT<1>      ;* Activity id as per file layout
*    IF ACTIVITY EQ 'LENDING-DISBURSE-COMMITMENT' OR ACTIVITY EQ 'LENDING-TAKEOVER-ARRANGEMENT' THEN
    TERM = R.AA.TERM.AMOUNT<AA.AMT.TERM>
    LEN.TERM = LEN(TERM)
    D.PART = LEN.TERM - 1
    IF TERM[D.PART,1] EQ 'D' THEN
        TERM.IN.DAYS = TERM[1,D.PART]
    END ELSE
        MAT.DATE = R.AA.TERM.AMOUNT<AA.AMT.MATURITY.DATE>
        ID.COM3 = FIELD(R.AA.TERM.AMOUNT<AA.AMT.ID.COMP.3>,'.',1)
        IF MAT.DATE AND ID.COM3 THEN
            Y.REGION = ''
            Y.DAYS   = 'C'
            CALL CDD(Y.REGION, MAT.DATE, ID.COM3, Y.DAYS)
            TERM.IN.DAYS = ABS(Y.DAYS)
        END
    END
*    END
*
    IF TERM.IN.DAYS THEN
        BEGIN CASE
            CASE TERM.IN.DAYS LE 365
                LOAN.TERM = '01'
            CASE TERM.IN.DAYS GT 365 AND TERM.IN.DAYS LE 1825
                LOAN.TERM = '02'
            CASE TERM.IN.DAYS GT 1825
                LOAN.TERM = '03'
        END CASE
        COMI = LOAN.TERM
    END ELSE
        COMI = ''
    END
*
RETURN
END
