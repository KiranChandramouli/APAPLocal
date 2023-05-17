SUBROUTINE REDO.INP.CHECK.LIMIT

***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Arulprakasam P
* PROGRAM NAME: REDO.INP.CHECK.LIMIT
* ODR NO      : ODR-2010-09-0148
*-----------------------------------------------------------------------------
*DESCRIPTION: This is INPUT routine for REDO.CLEARING.INWARD,APPROVE and
*raise the overrides

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.CLEARING.INWARD,APPROVE
*----------------------------------------------------------------------
* Modification History :
* DATE             WHO               REFERENCE           DESCRIPTION
* 03-10-2011       JEEVA T           PACS00131732          sub process
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.LIMIT
    $INSERT I_F.REDO.APAP.CLEARING.INWARD

    IF V$FUNCTION EQ 'I' THEN
        GOSUB INIT
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END
RETURN
*----------------------------------------------------------------------
*****
INIT:
*****

    FN.USER = 'F.USER'
    F.USER  = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''

    FN.LIMIT = 'F.LIMIT'
    F.LIMIT  = ''

RETURN
*----------------------------------------------------------------------
***********
OPEN.FILES:
***********
    CALL OPF(FN.USER,F.USER)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.LIMIT,F.LIMIT)

RETURN

*----------------------------------------------------------------------
********
PROCESS:
********

    GOSUB FIND.GET.LOCAL.REF
    Y.STATUS  = R.NEW(CLEAR.CHQ.STATUS)
    Y.TAX.AMT = R.NEW(CLEAR.CHQ.TAX.AMOUNT)
    Y.CHQ.AMT = R.NEW(CLEAR.CHQ.AMOUNT)
    CURR.NO = 0
    CALL STORE.OVERRIDE(CURR.NO)
    IF Y.STATUS EQ 'PAID' THEN
        GOSUB CHECK.LIMIT
    END
    GOSUB CHECK.REJECT
RETURN

*----------------------------------------------------------------------
************
CHECK.LIMIT:
************

    Y.USER = OPERATOR

    Y.L.US.OD.LIM = R.USER<EB.USE.LOCAL.REF,Y.L.US.OD.LIM.POS>
    IF Y.L.US.OD.LIM THEN
    END ELSE
        Y.L.US.OD.LIM = 0
    END
    Y.L.US.APPROVE.LIM = R.USER<EB.USE.LOCAL.REF,Y.L.US.APPROVE.LIM.POS>

    IF Y.L.US.APPROVE.LIM THEN
    END ELSE
        Y.L.US.APPROVE.LIM = 0
    END

    Y.L.US.TRANSIT.LIM = R.USER<EB.USE.LOCAL.REF,Y.L.US.TRANSIT.LIM.POS>

    IF Y.L.US.TRANSIT.LIM THEN
    END ELSE
        Y.L.US.TRANSIT.LIM = 0
    END

    Y.ACCOUNT.NO = R.NEW(CLEAR.CHQ.ACCOUNT.NO)
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    Y.LOCKED.AMT  = R.ACCOUNT<AC.LOCKED.AMOUNT>
    Y.LIMIT.REF   = R.ACCOUNT<AC.LIMIT.REF>
    Y.CUSTOMER    = R.ACCOUNT<AC.CUSTOMER>

    Y.TRANS.AVAIL.AMT = R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.TRAN.AVAIL.POS>
    Y.TRANS.LIMIT.AMT = R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.TRANS.LIM.POS>
    Y.AVAILABLE.BAL   = R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.AV.BAL.POS>

    Y.LIMIT.REF = FMT(Y.LIMIT.REF,'R%10')

    LIMIT.ID = Y.CUSTOMER : '.' : Y.LIMIT.REF
    CALL F.READ(FN.LIMIT,LIMIT.ID,R.LIMIT,F.LIMIT,LIMIT.ERR)


*--------check limit amount-------------*

    VAR.AVAIL.AMT = R.LIMIT<LI.AVAIL.AMT>

*--------check limit amount-------------*


*------------If Transit Avail amount greater then Trans limit amount then use Trans limit amt else use  Avail amt-------------*

    IF Y.TRANS.AVAIL.AMT GT Y.TRANS.LIMIT.AMT THEN
        Y.TRANSIT.FUND = Y.TRANS.LIMIT.AMT
    END ELSE
        Y.TRANSIT.FUND = Y.TRANS.AVAIL.AMT
    END

*------------If Transit Avail amount greater then Trans limit amount then use Trans limit amt else use  Avail amt-------------*


*------------If limit amount exists calculate Risk Amt with that Limit Amt else without limit Amt------------*

    IF VAR.AVAIL.AMT NE '' THEN
        Y.RISK.AMT = Y.AVAILABLE.BAL + VAR.AVAIL.AMT - Y.CHQ.AMT - Y.TAX.AMT
    END ELSE
        Y.RISK.AMT = Y.AVAILABLE.BAL  - Y.CHQ.AMT - Y.TAX.AMT
    END

*------------If limit amount exists calculate Risk Amt with that Limit Amt else without limit Amt------------*


*---------------calculate Overdraft Risk Amount---------------*

    IF Y.RISK.AMT LE Y.TRANSIT.FUND THEN
        Y.TRANSIT.LIMIT = '-':Y.L.US.TRANSIT.LIM
        IF Y.RISK.AMT LT Y.TRANSIT.LIMIT THEN
            TRANSIT.FLAG = 1
        END
    END ELSE
        Y.OD.RISK.AMT = Y.RISK.AMT - Y.TRANSIT.FUND
    END

*---------------calculate Overdraft Risk Amount-----------------*

*-----------Check user limit with User Overdraft Limit-----------*

    Y.OD.LIMIT  = '-':Y.L.US.OD.LIM
    IF Y.OD.RISK.AMT LT Y.OD.LIMIT THEN
        OD.FLAG = 1
    END

*--------------Check user limit with Overdraft Amount---------------*


*-----------check Transit Fund with User Approve Limit--------------*

    Y.TOT.TRANSIT = Y.TRANSIT.FUND + Y.OD.RISK.AMT
    Y.APPROVE.LIMIT = '-':Y.L.US.APPROVE.LIM
    IF Y.TOT.TRANSIT LT Y.APPROVE.LIMIT THEN
        OVER.FLAG = 1
    END

*-----------check Transit Fund with User Approve Limit--------------*
    Y.CUR.ACC.NO   = Y.ACCOUNT.NO[1,3]
    IF NUM(Y.CUR.ACC.NO) THEN
        IF TRANSIT.FLAG EQ 1 OR OD.FLAG EQ 1 OR OVER.FLAG EQ 1 THEN
            CURR.NO = DCOUNT(R.NEW(CLEAR.CHQ.OVERRIDE),@VM) + 1
            TEXT = "NOT.AUTHORISED.OFF"
            CALL STORE.OVERRIDE(CURR.NO)

        END
    END
RETURN

*----------------------------------------------------------------------
*************
CHECK.REJECT:
*************

    IF Y.STATUS EQ 'REJECTED' THEN
        CURR.NO = DCOUNT(R.NEW(CLEAR.CHQ.OVERRIDE),@VM) + 1
        TEXT = "CHECK.REJECTED"
        CALL STORE.OVERRIDE(CURR.NO)
    END
RETURN

*----------------------------------------------------------------------
*******************
FIND.GET.LOCAL.REF:
*******************

    APPL.ARRAY = 'USER':@FM:'ACCOUNT'
    FLD.ARRAY  = 'L.US.APPROV.LIM':@VM:'L.US.TRANSIT.LI':@VM:'L.US.OD.LIM':@FM:'L.AC.AV.BAL':@VM:'L.AC.TRAN.AVAIL':@VM:'L.AC.TRANS.LIM'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    Y.L.US.APPROVE.LIM.POS = FLD.POS<1,1>
    Y.L.US.TRANSIT.LIM.POS = FLD.POS<1,2>
    Y.L.US.OD.LIM.POS = FLD.POS<1,3>
    Y.L.AC.AV.BAL.POS = FLD.POS<2,1>
    Y.L.AC.TRAN.AVAIL.POS = FLD.POS<2,2>
    Y.L.AC.TRANS.LIM.POS = FLD.POS<2,3>

RETURN
END
