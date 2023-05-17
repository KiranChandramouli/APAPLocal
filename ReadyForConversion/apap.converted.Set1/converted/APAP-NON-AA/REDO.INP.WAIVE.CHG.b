SUBROUTINE REDO.INP.WAIVE.CHG
*------------------------------------------------
*Description: This routine is to nullify the commission based when
* comm code is made null.
*------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.REDO.APAP.CLEAR.PARAM

    IF AF EQ FT.COMMISSION.CODE THEN
        Y.COMM.CODE = COMI
    END ELSE
        Y.COMM.CODE = R.NEW(FT.COMMISSION.CODE)
    END


    GOSUB PROCESS
RETURN
*------------------------------------------------
PROCESS:
*------------------------------------------------

    IF Y.COMM.CODE EQ 'WAIVE' OR Y.COMM.CODE EQ '' THEN
        GOSUB REMOVE.CHARGE
    END ELSE
        GOSUB UPDATE.CHARGE
    END


RETURN
*------------------------------------------------
REMOVE.CHARGE:
*------------------------------------------------

    R.NEW(FT.CHARGES.ACCT.NO) = ''
    R.NEW(FT.COMMISSION.TYPE) = ''
    R.NEW(FT.COMMISSION.AMT)  = ''

RETURN
*------------------------------------------------
UPDATE.CHARGE:
*------------------------------------------------
    GOSUB OPEN.FILES
    WCHG.CODE = ''
    GOSUB GET.COMM.ON.CUST
    IF WCHG.CODE ELSE
        RETURN
    END
    R.NEW(FT.COMMISSION.TYPE) = WCHG.CODE
    R.NEW(FT.CHARGES.ACCT.NO) = R.NEW(FT.DEBIT.ACCT.NO)

RETURN

*----------------------------------------------------------------------------
GET.COMM.ON.CUST:
*----------------------------------------------------------------------------

    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,'SYSTEM',R.REDO.APAP.CLEAR.PARAM,PARAM.ERR)

    Y.DR.ACC = R.NEW(FT.DEBIT.ACCT.NO)
    CALL F.READ(FN.ACCOUNT,Y.DR.ACC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.CUS.ID = R.ACCOUNT<AC.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUST,F.CUSTOMER,CUS.ERR)
    Y.CUST.TYPE = R.CUST<EB.CUS.LOCAL.REF,POS.L.CU.SEGMENTO>
    IF Y.CUST.TYPE THEN
        LOCATE Y.CUST.TYPE IN R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CUSTOMER.TYPE,1> SETTING SEG.POS THEN
            WCHG.CODE = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.FT.REF.CHG,SEG.POS>
        END
    END

RETURN
*----------------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------------
    WAPP.LST  = "CUSTOMER"
    WFLD.LST = 'L.CU.SEGMENTO'
    YPOS=''
    CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
    POS.L.CU.SEGMENTO = YPOS<1,1>

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.CLEAR.PARAM  = ''
    CALL OPF(FN.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)

RETURN
END
