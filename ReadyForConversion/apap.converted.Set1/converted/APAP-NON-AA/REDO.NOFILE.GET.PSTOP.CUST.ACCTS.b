SUBROUTINE REDO.NOFILE.GET.PSTOP.CUST.ACCTS(LIST.ACCT.ID)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name :
*-----------------------------------------------------------------------------
* Description    :  This Nofile routine will get required details of Customer Accts
* Linked with    :
* In Parameter   :
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
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AI.REDO.ACCT.RESTRICT.PARAMETER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.RELATION.CUSTOMER

*---------*
MAIN.PARA:
*---------*

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*----------*
INITIALISE:
*----------*
    Y.FLAG = ''
    Y.NOTIFY = ''
    Y.FIELD.COUNT = ''
    FN.CUSTOMER.ACCOUNT = "F.CUSTOMER.ACCOUNT"
    F.CUSTOMER.ACCOUNT = ''
    FN.AI.STK.DETAILS = 'F.REDO.SAVE.STOCK.DETAILS'
    F.AI.STK.DETAILS = ''
    FN.CATEG = 'F.CATEGORY'
    F.CATEG = ''
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    FN.FTTC = 'F.FT.COMMISSION.TYPE'
    F.FTTC = ''
    CALL OPF(FN.FTTC,F.FTTC)

    FN.RELATION.CUSTOMER = 'F.RELATION.CUSTOMER'
    F.RELATION.CUSTOMER  = ''
    CALL OPF(FN.RELATION.CUSTOMER,F.RELATION.CUSTOMER)

    FN.JOINT.CONTRACTS.XREF = 'F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF  = ''
    CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

    LREF.APP='ACCOUNT'
    LREF.FIELDS='L.AC.STATUS1':@VM:'L.AC.STATUS2':@VM:'L.AC.AV.BAL':@VM:'L.AC.NOTIFY.1'
    LREF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    ACCT.STATUS.POS=LREF.POS<1,1>
    ACCT.STATUS2.POS = LREF.POS<1,2>
    ACCT.OUT.BAL.POS=LREF.POS<1,3>
    NOTIFY.POS = LREF.POS<1,4>


RETURN
*----------*
OPEN.FILES:
*----------*
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    CALL OPF(FN.AI.STK.DETAILS,F.AI.STK.DETAILS)
    CALL OPF(FN.CATEG,F.CATEG)
    CALL OPF(FN.ACC,F.ACC)
    FN.AI.REDO.ACCT.RESTRICT.PARAMETER = 'F.AI.REDO.ACCT.RESTRICT.PARAMETER'
    FN.AI.REDO.ARC.PARAM='F.AI.REDO.ARCIB.PARAMETER'
    FN.AZ = 'F.AZ.ACCOUNT'
    F.AZ = ''
    CALL OPF(FN.AZ,F.AZ)
RETURN

*--------*
PROCESS:
*--------*

    CUST.ID = System.getVariable("EXT.SMS.CUSTOMERS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        CUST.ID = ""
    END

    CALL CACHE.READ(FN.AI.REDO.ARC.PARAM,'SYSTEM',R.AI.REDO.ARC.PARAM,PARAM.ERR)
    LIST.ACCT.TYPE=R.AI.REDO.ARC.PARAM<AI.PARAM.ACCOUNT.TYPE>
    CALL CACHE.READ(FN.AI.REDO.ACCT.RESTRICT.PARAMETER,'SYSTEM',R.AI.REDO.ACCT.RESTRICT.PARAMETER,RES.ERR)
    Y.RESTRICT.ACCT.TYPE = R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.RESTRICT.ACCT.TYPE>
    CHANGE @VM TO @FM IN Y.RESTRICT.ACCT.TYPE
    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUST.ID,R.CUST.ACC,F.CUSTOMER.ACCOUNT,CUST.ACC.ERR)
    GOSUB MINOR.CUST.PARA
    IF R.CUST.ACC THEN

        LOOP
            REMOVE SE.ACCT.ID FROM R.CUST.ACC SETTING R.ACCT.POS
        WHILE SE.ACCT.ID:R.ACCT.POS
            ACC.ERR= ''
            CHECK.CATEG=''
            SAV.FLG=''
            CURR.FLG=''
            Y.FLAG = ''
            CUR.ACCT.STATUS = ''
            AC.NOFITY.STATUS = ''
            Y.POSTING.RESTRICT = ''
            CALL F.READ(FN.AI.STK.DETAILS,SE.ACCT.ID,R.SE.ACCT.REC,F.AI.STK.DETAILS,SE.ID.ERR)
            IF R.SE.ACCT.REC THEN

                CALL F.READ(FN.ACC,SE.ACCT.ID,R.ACC,F.ACC,ACC.ERR)

                GOSUB ACCOUNT.DETAILS.PARA

                IF NOT(Y.FLAG) THEN
                    GOSUB LOCATE.CURR.ACC
                    GOSUB LOCATE.SAV.ACC
                    GOSUB CHECK.STATUS.SUB
                END
            END
        REPEAT

    END

RETURN
*----------------*
MINOR.CUST.PARA:
*----------------*
    CALL F.READ(FN.JOINT.CONTRACTS.XREF,CUST.ID,R.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF,JNT.XREF.ERR)
    R.CUST.ACC<-1> = R.JOINT.CONTRACTS.XREF
RETURN
***********************
ACCOUNT.DETAILS.PARA:
**********************
    IF R.ACC THEN
        AC.NOFITY.STATUS = R.ACC<AC.LOCAL.REF><1,NOTIFY.POS>
        CUR.ACCT.STATUS1 = R.ACC<AC.LOCAL.REF><1,ACCT.STATUS.POS>
        CUR.ACCT.STATUS2=R.ACC<AC.LOCAL.REF><1,ACCT.STATUS2.POS>
        CHECK.CATEG = R.ACC<AC.CATEGORY>
        ACCT.BAL = R.ACC<AC.LOCAL.REF><1,ACCT.OUT.BAL.POS>
        CUR.ACCT.CUSTOMER = R.ACC<AC.CUSTOMER>
        Y.POSTING.RESTRICT= R.ACC<AC.POSTING.RESTRICT>
        CHANGE @SM TO @FM IN CUR.ACCT.STATUS2
        CHANGE @SM TO @FM IN AC.NOFITY.STATUS
        LOCATE 'DEBIT' IN Y.RESTRICT.ACCT.TYPE SETTING RES.ACCT.POS THEN
            GOSUB STATUS.RESTRICTION.PARA
            GOSUB NOTIFY.RESTRICTION.PARA
            GOSUB POSTING.RESTRICTION.PARA
            GOSUB RELATION.PARA
        END
    END
RETURN
************************
STATUS.RESTRICTION.PARA:
************************
    IF CUR.ACCT.STATUS1 THEN
        CUR.ACCT.STATUS = CUR.ACCT.STATUS1
    END ELSE
        Y.FLAG = 1
        RETURN
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
                Y.FLAG = 1
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
                Y.FLAG = 1
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
            Y.FLAG = 1
        END
    END
RETURN
******************
RELATION.PARA:
******************

    Y.RELATION.CODE = R.ACC<AC.RELATION.CODE>
    Y.REL.PARAM = R.AI.REDO.ARC.PARAM<AI.PARAM.RELATION.CODE>
    CHANGE @VM TO @FM IN Y.REL.PARAM
    IF CUR.ACCT.CUSTOMER NE CUST.ID THEN
        IF Y.REL.PARAM THEN
            Y.CNT.REL.CODE  = DCOUNT(Y.RELATION.CODE,@VM)
            Y.CNT.REL = 1
            LOOP
            WHILE Y.CNT.REL LE Y.CNT.REL.CODE
                Y.REL.CODE = Y.RELATION.CODE<1,Y.CNT.REL>
                LOCATE Y.REL.CODE IN Y.REL.PARAM SETTING Y.REL.POS THEN
                    RETURN
                END ELSE
                    Y.FLAG = 1
                END
                Y.CNT.REL += 1
            REPEAT
        END ELSE
            Y.FLAG = 1
        END
    END
RETURN
******************
CHECK.STATUS.SUB:
******************
    Y.FTTC.ID = 'CKSUSPPAGO'
    CALL CACHE.READ(FN.FTTC, Y.FTTC.ID, R.FTTC, Y.ERR)
    Y.FLAT.AMOUNT = R.FTTC<FT4.FLAT.AMT>
    IF ENQ.SELECTION<1> EQ 'AI.REDO.BANK.STOP.PAY.ACCT.LIST' THEN
        IF ACCT.BAL GT Y.FLAT.AMOUNT THEN
            GOSUB CHECK.LOAN.ACC
            GOSUB CHECK.AZ.ACC
            IF  (SAV.FLG EQ '1') OR (CURR.FLG EQ '1') THEN
                CALL CACHE.READ(FN.CATEG, CHECK.CATEG, R.CATEG, CATEG.ERR)
                CATEG.DESC = R.CATEG<EB.CAT.DESCRIPTION>
                LIST.ACCT.ID<-1> = SE.ACCT.ID:"@":CATEG.DESC
            END
        END
    END ELSE
        IF ACCT.BAL GT '0' THEN
            GOSUB CHECK.LOAN.ACC
            GOSUB CHECK.AZ.ACC
            IF  (SAV.FLG EQ '1') OR (CURR.FLG EQ '1') THEN
                CALL CACHE.READ(FN.CATEG, CHECK.CATEG, R.CATEG, CATEG.ERR)
                CATEG.DESC = R.CATEG<EB.CAT.DESCRIPTION>
                LIST.ACCT.ID<-1> = SE.ACCT.ID:"@":CATEG.DESC
            END
        END
    END

RETURN
******************
CHECK.LOAN.ACC:
******************
    ARR.ID = R.ACC<AC.ARRANGEMENT.ID>
    IF ARR.ID NE '' THEN
        LOAN.FLG = 1
    END
RETURN
*******************
CHECK.AZ.ACC:
******************
    CALL F.READ(FN.AZ,SE.ACCT.ID,R.AZ.REC,F.AZ,AZ.ERR)
    IF R.AZ.REC THEN
        DEP.FLG = 1
    END
RETURN
*******************
LOCATE.SAV.ACC:
*****************
    SAV.STG.RGE = ''
    SAV.END.RGE = ''
    SAV.FLG = ''

    CHANGE @VM TO @FM IN LIST.ACCT.TYPE
    Y.CNT.CATEG.TYPE  = DCOUNT(LIST.ACCT.TYPE,@FM)
    Y.CNT.CAT = 1
    LOOP
    WHILE  Y.CNT.CAT LE Y.CNT.CATEG.TYPE
        Y.CATEG.ID = LIST.ACCT.TYPE<Y.CNT.CAT>
        IF 'SAVINGS' EQ Y.CATEG.ID THEN
            SAV.STR.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.START,Y.CNT.CAT>
            SAV.END.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.END,Y.CNT.CAT>
            IF CHECK.CATEG GE SAV.STR.RGE AND CHECK.CATEG LE SAV.END.RGE THEN
                SAV.FLG = 1
                RETURN
            END
        END
        Y.CNT.CAT += 1
    REPEAT

RETURN
***************
LOCATE.CURR.ACC:
***************
    CHANGE @VM TO @FM IN LIST.ACCT.TYPE
    LOCATE 'CURRENT' IN LIST.ACCT.TYPE SETTING SAV.ACCT.POS THEN
        SAV.STR.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.START,SAV.ACCT.POS>
        SAV.END.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.END,SAV.ACCT.POS>
        IF CHECK.CATEG GE SAV.STR.RGE AND CHECK.CATEG LE SAV.END.RGE THEN
            CURR.FLG=1
        END
    END
RETURN
*-----------------------------------------------------------------------------
END
