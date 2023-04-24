SUBROUTINE REDO.UPLOAD.CREDIT.ACCOUNT.CHECK(Y.ACCT.ID,Y.FILE.TYPE,Y.FILE.DET.ID,Y.ACCT.STATUS,Y.BEN.ID)
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
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.AI.REDO.ARCIB.ALIAS.TABLE
    $INSERT I_F.AI.REDO.ACCT.RESTRICT.PARAMETER
    $INSERT I_F.BENEFICIARY
    $INSERT I_F.REDO.SUPPLIER.PAYMENT
    $INSERT I_F.REDO.ACH.PARTICIPANTS

    GOSUB INITIALISE
    GOSUB FORM.ACCT.ARRAY

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    CALL OPF(FN.ACC,F.ACC)

    FN.AZ = 'F.AZ.ACCOUNT'
    F.AZ = ''
    CALL OPF(FN.AZ,F.AZ)

    FN.BENEFICIARY = 'F.BENEFICIARY'
    F.BENEFICIARY  = ''
    CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)

    FN.CUS.BEN.LIST = 'F.CUS.BEN.LIST'
    F.CUS.BEN.LIST  = ''
    CALL OPF(FN.CUS.BEN.LIST,F.CUS.BEN.LIST)

    FN.REDO.ACH.WRK = 'F.REDO.ACH.PARTICIPANTS'
    F.REDO.ACH.WRK = ''
    CALL OPF(FN.REDO.ACH.WRK,F.REDO.ACH.WRK)

    FN.REDO.SUPPLIER.PAYMENT = 'F.REDO.SUPPLIER.PAYMENT'
    F.REDO.SUPPLIER.PAYMENT  = ''
    CALL OPF(FN.REDO.SUPPLIER.PAYMENT,F.REDO.SUPPLIER.PAYMENT)

    FN.BENEFICIARY = 'F.BENEFICIARY'
    F.BENEFICIARY  = ''
    CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)

    Y.VAR.EXT.CUSTOMER = ''
    Y.VAR.EXT.ACCOUNTS=''
    FN.AI.REDO.ARC.PARAM='F.AI.REDO.ARCIB.PARAMETER'
    FN.AI.REDO.ACCT.RESTRICT.PARAMETER = 'F.AI.REDO.ACCT.RESTRICT.PARAMETER'

    Y.FIELD.COUNT = ''
    R.ACCT.REC = ''
    Y.FLAG = ''
    LOAN.FLG = ''
    DEP.FLG = ''
    R.AZ.REC = ''
    R.ACC = ''
    LREF.POS = ''
    LREF.APP='ACCOUNT':@FM:'BENEFICIARY'
    LREF.FIELDS='L.AC.STATUS1':@VM:'L.AC.AV.BAL':@VM:'L.AC.NOTIFY.1':@VM:'L.AC.STATUS2':@FM:'L.BEN.ACH.ARCIB':@VM:'L.BEN.BANK':@VM:'L.BEN.PROD.TYPE':@VM:'L.BEN.CEDULA':@VM:'L.BEN.ACCOUNT'
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    ACCT.STATUS.POS   = LREF.POS<1,1>
    ACCT.OUT.BAL.POS  = LREF.POS<1,2>
    NOTIFY.POS        = LREF.POS<1,3>
    ACCT.STATUS2.POS  = LREF.POS<1,4>
    ACH.BANK.NAME.POS = LREF.POS<2,1>
    ACH.BANK.ID.POS   = LREF.POS<2,2>
    BEN.PROD.TYPE.POS = LREF.POS<2,3>
    BEN.CEDULA.POS    = LREF.POS<2,4>
    BEN.ACCOUNT.POS   = LREF.POS<2,5>
RETURN
******************
FORM.ACCT.ARRAY:
*****************


    CALL CACHE.READ(FN.AI.REDO.ARC.PARAM,'SYSTEM',R.AI.REDO.ARC.PARAM,PARAM.ERR)
    LIST.ACCT.TYPE = R.AI.REDO.ARC.PARAM<AI.PARAM.ACCOUNT.TYPE>
    LIST.TXN.TYPE  = R.AI.REDO.ARC.PARAM<AI.PARAM.TRANSACTION.TYPE>
    LIST.TXN.CODE  = R.AI.REDO.ARC.PARAM<AI.PARAM.TRANSACTION.CODE>

    LOCATE 'THIRD-TRANSFER' IN LIST.TXN.TYPE<1,1> SETTING ACH.POS THEN
        Y.TXN.CODE  = LIST.TXN.CODE<1,ACH.POS>
    END

    CALL CACHE.READ(FN.AI.REDO.ACCT.RESTRICT.PARAMETER,'SYSTEM',R.AI.REDO.ACCT.RESTRICT.PARAMETER,RES.ERR)
    LIST.ACCT.TYPE=R.AI.REDO.ARC.PARAM<AI.PARAM.ACCOUNT.TYPE>
    Y.RESTRICT.ACCT.TYPE = R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.RESTRICT.ACCT.TYPE>
    CHANGE @VM TO @FM IN Y.RESTRICT.ACCT.TYPE

    ACC.ERR= ''
    CHECK.CATEG=''
    SAV.FLG=''
    Y.FLAG = ''
    CURR.FLG=''
    CUR.ACCT.STATUS = ''
    AC.NOFITY.STATUS = ''
    Y.POSTING.RESTRICT = ''


    IF Y.FILE.TYPE EQ 'PAYROLL' THEN
        CALL F.READ(FN.ACC,Y.ACCT.ID,R.ACC,F.ACC,ACC.ERR)
        IF NOT(R.ACC) THEN
            Y.ACCT.STATUS = "INVALID ACCOUNT"
            RETURN
        END ELSE
            AC.NOFITY.STATUS = R.ACC<AC.LOCAL.REF><1,NOTIFY.POS>
            CUR.ACCT.STATUS1 = R.ACC<AC.LOCAL.REF><1,ACCT.STATUS.POS>
            CUR.ACCT.STATUS2=R.ACC<AC.LOCAL.REF><1,ACCT.STATUS2.POS>
            ACCT.BAL = R.ACC<AC.LOCAL.REF><1,ACCT.OUT.BAL.POS>
            Y.POSTING.RESTRICT= R.ACC<AC.POSTING.RESTRICT>
            CHANGE @SM TO @FM IN CUR.ACCT.STATUS2
            CHANGE @SM TO @FM IN AC.NOFITY.STATUS
            CHECK.CATEG = R.ACC<AC.CATEGORY>
            Y.INT.FILE.TYPE = FIELD(Y.FILE.DET.ID,'.',2)
            IF Y.INT.FILE.TYPE EQ 'NOMINA' THEN
            END ELSE
                GOSUB PAYROLL.RESTRICITON.PARA
            END
        END
    END  ELSE
        GOSUB SUPPLIER.RESTRICITON.PARA
        RETURN
    END


    LOCATE 'CREDIT' IN Y.RESTRICT.ACCT.TYPE SETTING RES.ACCT.POS THEN
        GOSUB STATUS.RESTRICTION.PARA
        GOSUB NOTIFY.RESTRICTION.PARA
        GOSUB POSTING.RESTRICTION.PARA
        GOSUB CHECK.LOAN.ACC
        GOSUB CHECK.AZ.ACC
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

******************
CHECK.LOAN.ACC:
******************

    ARR.ID = R.ACC<AC.ARRANGEMENT.ID>
    IF ARR.ID THEN
        Y.ACCT.STATUS<-1> = "LOAN ACCOUNT"
    END

RETURN

*******************
CHECK.AZ.ACC:
******************

    CALL F.READ(FN.AZ,Y.ACCT.ID,R.AZ.REC,F.AZ,AZ.ERR)

    IF R.AZ.REC THEN
        Y.ACCT.STATUS<-1> = "DEPOSIT ACCOUNT"
    END
RETURN
*************************
PAYROLL.RESTRICITON.PARA:
*************************
    CALL F.READ(FN.REDO.SUPPLIER.PAYMENT,Y.FILE.DET.ID,R.REDO.SUPPLIER.PAYMENT,F.REDO.SUPPLIER.PAYMENT,REDO.SUPPLIER.PAYMENT.ERR)
    Y.FILE.BANK.CODE = R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BANK.CODE>
    Y.SUP.ID.NUM     = R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BEN.ID.NO>
    Y.SRC.ACCT       = R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.SOURCE.ACCOUNT>
    CALL F.READ(FN.ACC,Y.SRC.ACCT,R.SRC.ACC,F.ACC,ACC.ERR)
    Y.CUST.ID = R.SRC.ACC<AC.CUSTOMER>
    Y.CUST.ID = Y.CUST.ID:'-OWN'
    CALL F.READ(FN.CUS.BEN.LIST,Y.CUST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ERR)
    Y.BEN.TOT.CNT = DCOUNT(R.CUS.BEN.LIST,@FM)
    R.CUS.BEN.LIST.REC = R.CUS.BEN.LIST
    CHANGE '*' TO @FM IN R.CUS.BEN.LIST.REC
    LOCATE Y.ACCT.ID IN R.CUS.BEN.LIST.REC SETTING Y.OWN.BEN.COS  THEN
    END ELSE
        Y.ACCT.STATUS = "INVALID BENEFICIARY"
        RETURN
    END

    Y.BEN.INT =1
    LOOP
    WHILE Y.BEN.INT LE Y.BEN.TOT.CNT
        Y.BEN.ID = R.CUS.BEN.LIST<Y.BEN.INT>
        Y.BEN.ID = FIELDS(Y.BEN.ID,'*',2)
        CALL F.READ(FN.BENEFICIARY,Y.BEN.ID,R.BENEFICIARY,F.BENEFICIARY,BENEFICIARY.ERR)
        Y.BEN.ID.NUM    =  R.BENEFICIARY<ARC.BEN.LOCAL.REF,BEN.CEDULA.POS>
        Y.BEN.ACCT.NO   =  R.BENEFICIARY<ARC.BEN.BEN.ACCT.NO>
        IF (Y.BEN.ID.NUM EQ Y.SUP.ID.NUM) AND (Y.ACCT.ID EQ Y.BEN.ACCT.NO) THEN
            RETURN
        END
        Y.BEN.INT += 1
    REPEAT
    Y.ACCT.STATUS = "INVALID BENEFICIARY"

RETURN
**************************
SUPPLIER.RESTRICITON.PARA:
**************************

    CALL F.READ(FN.REDO.SUPPLIER.PAYMENT,Y.FILE.DET.ID,R.REDO.SUPPLIER.PAYMENT,F.REDO.SUPPLIER.PAYMENT,REDO.SUPPLIER.PAYMENT.ERR)
    Y.FILE.BANK.CODE = R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BANK.CODE>
    Y.SUP.ID.NUM     = R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BEN.ID.NO>
    Y.SRC.ACCT       = R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.SOURCE.ACCOUNT>
    CALL F.READ(FN.ACC,Y.SRC.ACCT,R.SRC.ACC,F.ACC,ACC.ERR)
    Y.CUST.ID = R.SRC.ACC<AC.CUSTOMER>
    CALL F.READ(FN.REDO.ACH.WRK,Y.FILE.BANK.CODE,R.REDO.ACH.WRK,F.REDO.ACH.WRK,REDO.ACH.WRK.ERR)
    IF R.REDO.ACH.WRK THEN
        Y.FILE.BANK.NAME = R.REDO.ACH.WRK<REDO.ACH.PARTI.INSTITUTION>
    END ELSE
        Y.ACCT.STATUS = "INVALID BENEFICIARY"
        RETURN
    END

    Y.CUST.ID = Y.CUST.ID:'-OTHER'
    CALL F.READ(FN.CUS.BEN.LIST,Y.CUST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ERR)

    Y.BEN.TOT.CNT = DCOUNT(R.CUS.BEN.LIST,@FM)

    Y.BEN.INT =1
    LOOP
    WHILE Y.BEN.INT LE Y.BEN.TOT.CNT
        Y.BEN.ID = R.CUS.BEN.LIST<Y.BEN.INT>
        Y.BEN.ID = FIELDS(Y.BEN.ID,'*',2)
        CALL F.READ(FN.BENEFICIARY,Y.BEN.ID,R.BENEFICIARY,F.BENEFICIARY,BENEFICIARY.ERR)
        Y.ACH.BANK.ID =  R.BENEFICIARY<ARC.BEN.LOCAL.REF,ACH.BANK.ID.POS>
        Y.ACH.BANK.NAME =   R.BENEFICIARY<ARC.BEN.LOCAL.REF,ACH.BANK.NAME.POS>
        Y.BEN.ID.NUM    =  R.BENEFICIARY<ARC.BEN.LOCAL.REF,BEN.CEDULA.POS>
        Y.BEN.TXN.CODE  =  R.BENEFICIARY<ARC.BEN.TRANSACTION.TYPE>
        Y.OTHER.BEN.ACCT=  R.BENEFICIARY<ARC.BEN.LOCAL.REF,BEN.ACCOUNT.POS>


        IF (Y.BEN.ID.NUM EQ Y.SUP.ID.NUM) AND (Y.ACH.BANK.NAME EQ Y.FILE.BANK.NAME) AND (Y.ACH.BANK.ID EQ Y.FILE.BANK.CODE) AND (Y.OTHER.BEN.ACCT EQ Y.ACCT.ID) AND (Y.BEN.TXN.CODE EQ Y.TXN.CODE) THEN
            RETURN
        END
        Y.BEN.INT += 1
    REPEAT
    Y.ACCT.STATUS = "INVALID BENEFICIARY"

RETURN
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------