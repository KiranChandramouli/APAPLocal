SUBROUTINE REDO.V.TEMP.CRD.DEB.VALUE.DATE
*----------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Bharath G
*Program   Name    :REDO.V.VAL.CRD.DEB.VALUE.DATE
*----------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as validation routine in the version
*                   Debit and Credit Value Date Value Date must bring default
*                   today's date and allow modification system (must be able to record
*                   a date prior to the day, but cannot be earlier than the date
*                   of creation of the loan
*
*
*LINKED WITH       :VERSION>REDO.FT.TT.TRANSACTION,REDO.AA.LTCC
* ---------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who             Reference            Description
* 01-JUN-2017          Edwin Charles D R15 upgrade          Intial Draft
*----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FT.TT.TRANSACTION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS

*----------------------------------------------------------------------------------

    GOSUB INIT
    IF APPLICATION EQ 'REDO.FT.TT.TRANSACTION' THEN
        GOSUB PROCESS
    END

RETURN
*----------------------------------------------------------------------------------
INIT:
*----
    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    R.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    R.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*----------------------------------------------------------------------------------
PROCESS:
*-------
*
    Y.ACCT = '' ; Y.ARR.ID = ''
    Y.ARR.ID = COMI
    IF Y.ARR.ID[1,2] EQ 'AA' THEN
        IN.ACC.ID = ''
        IN.ARR.ID = Y.ARR.ID
        OUT.ID = ''
        ERR.TEXT = ''
        CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)
        Y.ACCT = OUT.ID
    END ELSE
        IN.ACC.ID = Y.ARR.ID
        IN.ARR.ID = ''
        OUT.ID = ''
        ERR.TEXT = ''
        Y.ACCT = Y.ARR.ID
        CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)
        Y.ARR.ID = OUT.ID
    END

    CALL F.READ(FN.ACCOUNT,Y.ACCT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    R.NEW(FT.TN.DEBIT.CURRENCY)   = R.ACCOUNT<AC.CURRENCY>
    Y.VERSION.NAME = PGM.VERSION
    IF Y.VERSION.NAME EQ ',REDO.MULTI.AA.ACPOAP.DISB' OR Y.VERSION.NAME EQ ',REDO.MULTI.AA.PART.ACPOAP.DISB' OR Y.VERSION.NAME EQ ',REDO.MULTI.AA.ACCRAP.DISB' OR Y.VERSION.NAME EQ ',REDO.MULTI.AA.ACCRAP.PDISB' THEN
    END ELSE
        R.NEW(FT.TN.L.FT.CUSTOMER)    = R.ACCOUNT<AC.CUSTOMER>
    END
    IF R.ACCOUNT<AC.ARRANGEMENT.ID> EQ '' THEN
        AF = FT.TN.DEBIT.ACCT.NO
        ETEXT = "EB-NOT.ARRANGEMENT.ID"
        CALL STORE.END.ERROR
        RETURN
    END
    R.AA.ACCOUNT.DETAILS = ''; Y.EFF.DATE = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,AA.ARR.ERR)
    IF R.AA.ACCOUNT.DETAILS THEN
        Y.EFF.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.CONTRACT.DATE>
        IF Y.EFF.DATE NE '' AND R.NEW(FT.TN.DEBIT.VALUE.DATE) LT Y.EFF.DATE THEN
            AF = FT.TN.DEBIT.VALUE.DATE
            ETEXT = "EB-VALUE.DATE.LT.ARR.DATE"
            CALL STORE.END.ERROR
            RETURN
        END
        IF Y.EFF.DATE NE '' AND R.NEW(FT.TN.CREDIT.VALUE.DATE) LT Y.EFF.DATE THEN
            AF = FT.TN.CREDIT.VALUE.DATE
            ETEXT = "EB-VALUE.DATE.LT.ARR.DATE"
            CALL STORE.END.ERROR
            RETURN
        END
    END
RETURN
END
