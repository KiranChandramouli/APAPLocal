SUBROUTINE REDO.UPLOAD.DEBIT.ACCOUNT.CHECK(Y.ACCT.ID,Y.ACCT.STATUS)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By :
* Program Name : REDO.UPLOAD.DEBIT.ACCOUNT.CHECK
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.AI.REDO.ARCIB.ALIAS.TABLE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AI.REDO.ACCT.RESTRICT.PARAMETER
    $INSERT I_F.AZ.ACCOUNT
    GOSUB INITIALISE
    GOSUB FORM.ACCT.ARRAY

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------


    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    CALL OPF(FN.ACC,F.ACC)


    Y.VAR.EXT.CUSTOMER = ''
    Y.VAR.EXT.ACCOUNTS=''
    FN.AI.REDO.ARC.PARAM='F.AI.REDO.ARCIB.PARAMETER'
    FN.AI.REDO.ACCT.RESTRICT.PARAMETER = 'F.AI.REDO.ACCT.RESTRICT.PARAMETER'
    Y.FLAG = ''
    Y.NOTIFY = ''
    Y.FIELD.COUNT = ''
    R.ACCT.REC = ''
    LOAN.FLG = ''
    DEP.FLG = ''
    R.AZ.REC = ''
    R.ACC = ''
    LREF.POS = ''
    LREF.APP='ACCOUNT'
    LREF.FIELDS='L.AC.STATUS1':@VM:'L.AC.STATUS2':@VM:'L.AC.AV.BAL':@VM:'L.AC.NOTIFY.1'
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    ACCT.STATUS.POS=LREF.POS<1,1>
    ACCT.STATUS2.POS = LREF.POS<1,2>
    ACCT.OUT.BAL.POS=LREF.POS<1,3>
    NOTIFY.POS = LREF.POS<1,4>

RETURN
******************
FORM.ACCT.ARRAY:
*****************

    CALL CACHE.READ(FN.AI.REDO.ARC.PARAM,'SYSTEM',R.AI.REDO.ARC.PARAM,PARAM.ERR)
    CALL CACHE.READ(FN.AI.REDO.ACCT.RESTRICT.PARAMETER,'SYSTEM',R.AI.REDO.ACCT.RESTRICT.PARAMETER,RES.ERR)
    LIST.ACCT.TYPE=R.AI.REDO.ARC.PARAM<AI.PARAM.ACCOUNT.TYPE>
    Y.DEBIT.ACCT.AMT = System.getVariable('CURRENT.ARC.AMT')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.DEBIT.ACCT.AMT = ""
    END
    Y.RESTRICT.ACCT.TYPE = R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.RESTRICT.ACCT.TYPE>
    CHANGE @VM TO @FM IN Y.RESTRICT.ACCT.TYPE

    ACC.ERR= ''
    CHECK.CATEG=''
    SAV.FLG=''
    CURR.FLG=''
    Y.FLAG = ''
    CUR.ACCT.STATUS = ''
    AC.NOFITY.STATUS = ''
    Y.POSTING.RESTRICT = ''
    Y.RELATION.CODE = ''
    CALL F.READ(FN.ACC,Y.ACCT.ID,R.ACC,F.ACC,ACC.ERR)
    IF NOT(ACC.ERR) THEN
        AC.NOFITY.STATUS = R.ACC<AC.LOCAL.REF><1,NOTIFY.POS>
        CUR.ACCT.STATUS1 = R.ACC<AC.LOCAL.REF><1,ACCT.STATUS.POS>
        CUR.ACCT.STATUS2=R.ACC<AC.LOCAL.REF><1,ACCT.STATUS2.POS>
        ACCT.BAL = R.ACC<AC.LOCAL.REF><1,ACCT.OUT.BAL.POS>
        CHECK.CATEG = R.ACC<AC.CATEGORY>
        Y.POSTING.RESTRICT= R.ACC<AC.POSTING.RESTRICT>

        CHANGE @SM TO @FM IN CUR.ACCT.STATUS2
        CHANGE @SM TO @FM IN AC.NOFITY.STATUS

        LOCATE 'DEBIT' IN Y.RESTRICT.ACCT.TYPE SETTING RES.ACCT.POS THEN

            GOSUB STATUS.RESTRICTION.PARA
            GOSUB NOTIFY.RESTRICTION.PARA
            GOSUB POSTING.RESTRICTION.PARA
            GOSUB CHECK.ACCT.BALANCE.PARA
        END

    END



RETURN
************************
STATUS.RESTRICTION.PARA:
************************
    IF CUR.ACCT.STATUS1 THEN
        CUR.ACCT.STATUS = CUR.ACCT.STATUS1
    END
    IF CUR.ACCT.STATUS2 THEN
        CUR.ACCT.STATUS = CUR.ACCT.STATUS2
    END
    IF CUR.ACCT.STATUS1 AND CUR.ACCT.STATUS2 THEN
        CUR.ACCT.STATUS = CUR.ACCT.STATUS1:@FM:CUR.ACCT.STATUS2
    END

    Y.CNT.STATUS = DCOUNT(CUR.ACCT.STATUS,@FM)
    IF Y.CNT.STATUS GE 1 THEN
        Y.INT.STATUS.CNT = 1
        LOOP
        WHILE Y.INT.STATUS.CNT LE Y.CNT.STATUS
            Y.STATUS2 = CUR.ACCT.STATUS<Y.INT.STATUS.CNT>
            Y.RESTRICT.STATUS = R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.ACCT.STATUS,RES.ACCT.POS>
            CHANGE @SM TO @FM IN Y.RESTRICT.STATUS
            LOCATE Y.STATUS2 IN Y.RESTRICT.STATUS SETTING RES.STATUS.POS THEN
                Y.ACCT.STATUS<-1> = "NOT IN ACTIVE"
                RETURN
            END
            Y.INT.STATUS.CNT += 1
        REPEAT
    END

RETURN

************************
NOTIFY.RESTRICTION.PARA:
************************

    Y.CNT.NOTIFY = DCOUNT(AC.NOFITY.STATUS,@FM)
    IF Y.CNT.NOTIFY GE 1 THEN
        Y.INT.NOTIFY.CNT = 1
        LOOP
        WHILE Y.INT.NOTIFY.CNT LE Y.CNT.NOTIFY
            Y.NOTIFY = AC.NOFITY.STATUS<Y.INT.NOTIFY.CNT>
            Y.RESTRICT.NOTIFY = R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.ACCT.NOTIFY.1,RES.ACCT.POS>
            CHANGE @SM TO @FM IN Y.RESTRICT.NOTIFY
            LOCATE Y.NOTIFY IN Y.RESTRICT.NOTIFY SETTING RES.NOTIFY.POS THEN
                Y.ACCT.STATUS<-1> = "ACCOUNT NOTIFICATION"
                RETURN
            END
            Y.INT.NOTIFY.CNT += 1
        REPEAT
    END
RETURN
*************************
POSTING.RESTRICTION.PARA:
*************************
    Y.RESTRICT.ACCT.POSTING = R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.POSTING.RESTRICT,RES.ACCT.POS>
    CHANGE @SM TO @FM IN Y.RESTRICT.ACCT.POSTING
    IF Y.POSTING.RESTRICT THEN
        LOCATE Y.POSTING.RESTRICT IN Y.RESTRICT.ACCT.POSTING SETTING POSTING.POS THEN
            Y.ACCT.STATUS<-1> = " POSTING RESTRICTION"
        END
    END
RETURN
************************
CHECK.ACCT.BALANCE.PARA:
************************
    IF ACCT.BAL LT '0' THEN
        Y.ACCT.STATUS<-1> = "INSUFFICIENT BALANCE"
    END
RETURN
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
