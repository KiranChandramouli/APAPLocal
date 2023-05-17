SUBROUTINE REDO.AZ.ACCT.AMT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.AZ.ACCT.AMT
*--------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* DATE          WHO                  REFERENCE          DESCRIPTION
* 29-12-2011    Sudharsanan S        PACS00167691       Populate the total due amount
* 13-03-2013    Vignesh Kumaar M R   PACS00253698       Account not populated in the TT>ACCOUNT.1 field
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.DEFAULT

    GOSUB INIT
    GOSUB PROCESS
    GOSUB PGM.END
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.AZ.ACCOUNT.HIS = 'F.AZ.ACCOUNT$HIS'
    F.AZ.ACCOUNT.HIS = ''
    CALL OPF(FN.AZ.ACCOUNT.HIS,F.AZ.ACCOUNT.HIS)

    FN.TELLER.DEFAULT = 'F.TELLER.DEFAULT'
    F.TELLER.DEFAULT = ''
    CALL OPF(FN.TELLER.DEFAULT,F.TELLER.DEFAULT)

    FN.REDO.DEP.CASHPAYOUT = 'F.REDO.DEP.CASHPAYOUT'
    F.REDO.DEP.CASHPAYOUT = ''
    CALL OPF(FN.REDO.DEP.CASHPAYOUT,F.REDO.DEP.CASHPAYOUT)

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    IF APPLICATION EQ 'TELLER' THEN
        GOSUB TT.CHECK
    END

RETURN
*---------------------------------------------------------------------------------
TT.CHECK:
*---------------------------------------------------------------------------------

*Fix for PACS00253697

    L.APP = 'TELLER':@FM:'AZ.ACCOUNT'
    L.FLD = 'L.TT.AZ.ACC.REF':@VM:'L.TT.CLIENT.COD':@VM:'L.CREDIT.AMOUNT':@FM:'L.TYPE.INT.PAY'
    LRF.POS = ''
    CALL MULTI.GET.LOC.REF(L.APP,L.FLD,LRF.POS)
    L.POS      = LRF.POS<1,1>
    L.CUS.POS  = LRF.POS<1,2>
    L.CRD.AMT.POS = LRF.POS<1,3>
    L.TYPE.POS = LRF.POS<2,1>

*Y.AZ.ID = R.NEW(TT.TE.LOCAL.REF)<1,L.POS>

    Y.AZ.ID = COMI

    Y.AZ.ACCT.ID = COMI

* End of Fix

    R.AZ.ACCOUNT = ''

    CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)

    IF NOT(R.AZ.ACCOUNT) THEN
        CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT.HIS,Y.AZ.ID,R.AZ.ACCOUNT,AZ.ERR.HIS)
    END ELSE
        ETEXT = 'EB-NOT.VALID.DEP'
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END

    VAR.CURRENCY = R.AZ.ACCOUNT<AZ.CURRENCY>
    GOSUB CHECK.CURRENCY

    VAR.TYPE = R.AZ.ACCOUNT<AZ.LOCAL.REF,L.TYPE.POS>
    GOSUB CHECK.TYPE

    VAR.CUSTOMER = R.AZ.ACCOUNT<AZ.CUSTOMER>
    GOSUB CHECK.CASHPAYOUT

    VAR.OVERRIDE = R.AZ.ACCOUNT<AZ.OVERRIDE>
    GOSUB GET.TOTAL.DUE

    GOSUB UPDATE.VALUES


RETURN
*----------------------------------------------------------------------------------
CHECK.CURRENCY:
*---------------
    BEGIN CASE

        CASE PGM.VERSION EQ ",REDO.AZ.FD.PRECLOSE.ML"

            IF VAR.CURRENCY NE LCCY THEN
                ETEXT = 'EB-NOT.VALID.DEP'
                CALL STORE.END.ERROR
                GOSUB PGM.END
            END

        CASE PGM.VERSION EQ ",REDO.AZ.FD.PRECLOSE.ME"
            IF VAR.CURRENCY EQ LCCY THEN
                ETEXT = 'EB-NOT.VALID.DEP'
                CALL STORE.END.ERROR
                GOSUB PGM.END
            END

    END CASE

RETURN
*----------------------------------------------------------------------------------
CHECK.TYPE:
*-----------
    IF VAR.TYPE EQ 'Reinvested' THEN
        ETEXT = 'EB-NOT.VALID.DEP'
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
RETURN
*----------------------------------------------------------------------------------
CHECK.CASHPAYOUT:
*----------------
*This part is used to check the cashpayout already done for this deposit number
    R.REDO.DEP.CASHPAYOUT = ''
    CALL F.READ(FN.REDO.DEP.CASHPAYOUT,VAR.CUSTOMER,R.REDO.DEP.CASHPAYOUT,F.REDO.DEP.CASHPAYOUT,CASH.ERR)

    IF R.REDO.DEP.CASHPAYOUT THEN
        LOCATE Y.AZ.ACCT.ID IN R.REDO.DEP.CASHPAYOUT SETTING POS THEN
            ETEXT = 'EB-NOT.VALID.DEP'
            CALL STORE.END.ERROR
            GOSUB PGM.END
        END
    END

RETURN
*---------------------------------------------------------------------------------
GET.TOTAL.DUE:
*-------------
    CHANGE @VM TO @FM IN VAR.OVERRIDE
    FINDSTR 'REDO.AZ.TOTAL.DUE' IN VAR.OVERRIDE SETTING POS.DUE THEN
        Y.TOTAL.DUE = VAR.OVERRIDE<POS.DUE>
        VAR.TOTAL.DUE   = FIELD(Y.TOTAL.DUE,'{',2)
    END
    IF NOT(VAR.TOTAL.DUE) THEN
        VAR.TOTAL.DUE = R.AZ.ACCOUNT<AZ.PRINCIPAL>
    END

    CHANGE "," TO "" IN VAR.TOTAL.DUE

RETURN
*----------------------------------------------------------------------------------
UPDATE.VALUES:
*--------------

    R.NEW(TT.TE.ACCOUNT.1) = R.AZ.ACCOUNT<AZ.NOMINATED.ACCOUNT>

    IF VAR.CURRENCY EQ LCCY THEN
        R.NEW(TT.TE.AMOUNT.LOCAL.1) = VAR.TOTAL.DUE
    END ELSE
        R.NEW(TT.TE.AMOUNT.FCY.1) = VAR.TOTAL.DUE
    END

    R.NEW(TT.TE.CURRENCY.1) = VAR.CURRENCY
    R.NEW(TT.TE.LOCAL.REF)<1,L.CUS.POS> = VAR.CUSTOMER
    R.NEW(TT.TE.LOCAL.REF)<1,L.CRD.AMT.POS> = VAR.TOTAL.DUE
    CALL TT.PERFORM.DEF.PROCESSING        ;* Fix for PACS00294719

RETURN
*----------------------------------------------------------------------------------
PGM.END:
*--------
END
