SUBROUTINE  REDO.LY.V.SAVC
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the savings account for Customer in
*              Usage Txn.
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.V.SAVC
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*10.07.2012    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_GTS.COMMON

    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.REDO.LY.POINTS.US

    Y.SAV.ACCT = COMI

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB GET.CATEGORIES
    GOSUB PROCESS

RETURN

*----
INIT:
*----

    LREF.APP = 'ACCOUNT'
    LREF.FIELDS = 'L.AC.STATUS1':@VM:'L.AC.STATUS2':@VM:'L.AC.NOTIFY.1'
    LREF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    L.AC.STATUS1.POS = LREF.POS<1,1>
    L.AC.STATUS2.POS = LREF.POS<1,2>
    L.AC.NOTIFY.POS = LREF.POS<1,3>

RETURN

*----------
OPEN.FILES:
*----------

    FN.AI.REDO.ARCIB.PARAMETER = 'F.AI.REDO.ARCIB.PARAMETER'
    F.AI.REDO.ARCIB.PARAMETER = ''
    CALL OPF(FN.AI.REDO.ARCIB.PARAMETER,F.AI.REDO.ARCIB.PARAMETER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN

*--------------
GET.CATEGORIES:
*--------------

    R.ARCIB.PARAM = ''; ARCIB.ERR = ''
    CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.ARCIB.PARAM,ARCIB.ERR)
    Y.ALL.ACCOUNT.TYPE = R.ARCIB.PARAM<AI.PARAM.ACCOUNT.TYPE>
    Y.ALL.CATEG.START = R.ARCIB.PARAM<AI.PARAM.CATEG.START>
    Y.ALL.CATEG.END = R.ARCIB.PARAM<AI.PARAM.CATEG.END>

    Y.TOT.ACCOUNT.TYPE = DCOUNT(Y.ALL.ACCOUNT.TYPE,@VM)
    Y.ACCT.TYPE.CNT = 1
    LOOP
    WHILE Y.ACCT.TYPE.CNT LE Y.TOT.ACCOUNT.TYPE
        Y.ACCONT.TYPE = FIELD(Y.ALL.ACCOUNT.TYPE,@VM,Y.ACCT.TYPE.CNT)
        IF Y.ACCONT.TYPE EQ 'SAVINGS' THEN
            Y.CATEG.START := FIELD(Y.ALL.CATEG.START,@VM,Y.ACCT.TYPE.CNT):'*'
            Y.CATEG.END := FIELD(Y.ALL.CATEG.END,@VM,Y.ACCT.TYPE.CNT):'*'
        END
        Y.ACCT.TYPE.CNT += 1
    REPEAT

    Y.TOT.RANGES = DCOUNT(Y.CATEG.START,'*') - 1

RETURN

*-------
PROCESS:
*-------

    Y.CUSTOMER = R.NEW(REDO.PT.US.CUSTOMER.NO)
    Y.US.MOV = R.NEW(REDO.PT.US.MOV.US)

    IF Y.SAV.ACCT EQ '' AND Y.US.MOV EQ 'Cuenta.Ahorro.Cliente' THEN
        AF = REDO.PT.US.CUS.ACCT.MOV.US
        ETEXT = 'EB-REDO.LY.V.SAVC2'
        CALL STORE.END.ERROR
        RETURN
    END

    Y.AV.ACCT = 'N' ; R.ACCOUNT = '' ; ACC.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.SAV.ACCT,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT THEN
        GOSUB CHECK.CUST.ACCT
        GOSUB GET.ERROR
    END ELSE
        IF Y.US.MOV EQ 'Cuenta.Ahorro.Cliente' THEN
            Y.AV.ACCT = 'N'
            GOSUB GET.ERROR
        END
    END

RETURN

*---------------
CHECK.CUST.ACCT:
*---------------

    Y.ACCT.CUS = R.ACCOUNT<AC.CUSTOMER>
    Y.ACCT.CAT = R.ACCOUNT<AC.CATEGORY>
*IF Y.ACCT.CUS NE Y.CUSTOMER THEN
*Y.AV.ACCT = 'N'
*GOSUB GET.ERROR
*END

    Y.CHECK.CNT = 1
    LOOP
    WHILE Y.CHECK.CNT LE Y.TOT.RANGES
        Y.LIMIT.1 = FIELD(Y.CATEG.START,'*',Y.CHECK.CNT)
        Y.LIMIT.2 = FIELD(Y.CATEG.END,'*',Y.CHECK.CNT)
        IF Y.ACCT.CAT GE Y.LIMIT.1 AND Y.ACCT.CAT LE Y.LIMIT.2 THEN
            Y.AV.ACCT = 'Y'
            GOSUB CHECK.ACCT.STATUS
            RETURN
        END
        Y.CHECK.CNT += 1
    REPEAT

RETURN

*---------
GET.ERROR:
*---------

    IF Y.AV.ACCT EQ 'N' THEN
        AF = REDO.PT.US.CUS.ACCT.MOV.US
        ETEXT = 'EB-REDO.LY.V.SAVC'
        CALL STORE.END.ERROR
        RETURN
    END

RETURN

*-----------------
CHECK.ACCT.STATUS:
*-----------------

    Y.ACC.STATUS1 = R.ACCOUNT<AC.LOCAL.REF><1,L.AC.STATUS1.POS>

    IF Y.ACC.STATUS1 NE 'ACTIVE' THEN
        Y.AV.ACCT = 'N'
        RETURN
    END

    Y.ACC.STATUS2 = R.ACCOUNT<AC.LOCAL.REF><1,L.AC.STATUS2.POS>

    IF Y.ACC.STATUS2 EQ 'DECEASED' THEN
        Y.AV.ACCT = 'N'
        RETURN
    END

    Y.PR.ID = R.ACCOUNT<AC.POSTING.RESTRICT>

    IF Y.PR.ID EQ '2' OR Y.PR.ID EQ '3' THEN
        Y.AV.ACCT = 'N'
        RETURN
    END

    Y.ACC.NOTIF = R.ACCOUNT<AC.LOCAL.REF><1,L.AC.NOTIFY.POS>

    IF Y.ACC.NOTIF EQ 'NOTIFY.MGMT.MONEY.LAUNDRY.PREV' OR Y.ACC.NOTIF EQ 'NOTIFY.OFFICER' THEN
        Y.AV.ACCT = 'N'
        RETURN
    END

RETURN

*----------------------------------------------------------------------------------
END
