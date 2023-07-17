* @ValidationCode : MjotNjY3MjYzNTk4OkNwMTI1MjoxNjgxNzI2NzYwODcwOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Apr 2023 15:49:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.EMP.ACCT.RPT(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.APAP.NOF.EMP.ACCT.RPT
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.EMP.ACCT.RPT is a no-file enquiry routine for the enquiries REDO.APAP.ENQ.EMP.ACCT.RPT
*                    and REDO.APAP.ER.EMP.ACCT.RPT, the routine based on the selection criteria
*                    selects the records from ACCOUNT and displays the processed records
*
*In Parameter      : N/A
*Out Parameter     : Y.OUT.ARRAY
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date             Who                      Reference                 Description
*   ------          ------                     -------------             -------------
*  16 Nov 2010      Shiva Prasad Y                                      Initial Creation
*  08 Jan 2014      Vignesh Kumaar R           PACS00312026             Agencia should display company nameU
*  23 Nov 2016      Saran U                                             Changes done for performance tuning
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM ,SM to @SM, = to EQ ,++ to +=
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CATEGORY
    $INSERT I_F.COMPANY ;*
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.RELATION
    $INSERT I_F.AC.ACCOUNT.LINK
    $INSERT I_F.USER
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.LATAM.CARD.CUSTOMER
    $INSERT I_F.REDO.EMPLOYEE.ACCOUNTS
    $INSERT I_F.LIMIT
*TUS Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*TUS End
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
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT$HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT$HIS  = ''
    CALL OPF(FN.ACCOUNT$HIS,F.ACCOUNT$HIS)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY  = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

* Fix for PACS00312026 [Agencia should display company name]

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

* End of Fix

    FN.LATAM.CARD.CUSTOMER = 'F.LATAM.CARD.CUSTOMER'
    F.LATAM.CARD.CUSTOMER  = ''
    CALL OPF(FN.LATAM.CARD.CUSTOMER,F.LATAM.CARD.CUSTOMER)

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT  = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT  = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.RELATION = 'F.RELATION'
    F.RELATION  = ''
    CALL OPF(FN.RELATION,F.RELATION)

    FN.AC.ACCOUNT.LINK.CONCAT = 'F.AC.ACCOUNT.LINK.CONCAT'
    F.AC.ACCOUNT.LINK.CONCAT  = ''
    CALL OPF(FN.AC.ACCOUNT.LINK.CONCAT,F.AC.ACCOUNT.LINK.CONCAT)

    FN.AC.ACCOUNT.LINK = 'F.AC.ACCOUNT.LINK'
    F.AC.ACCOUNT.LINK  = ''
    CALL OPF(FN.AC.ACCOUNT.LINK,F.AC.ACCOUNT.LINK)

    FN.REDO.EMPLOYEE.ACCOUNTS = 'F.REDO.EMPLOYEE.ACCOUNTS'
    F.REDO.EMPLOYEE.ACCOUNTS = ''
    CALL OPF(FN.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS)

    FN.ACCOUNT.CLOSED = 'F.ACCOUNT.CLOSED'
    F.ACCOUNT.CLOSED = ''
    CALL OPF(FN.ACCOUNT.CLOSED,F.ACCOUNT.CLOSED)

    FN.LIMIT = 'F.LIMIT'
    F.LIMIT = ''
    CALL OPF(FN.LIMIT,F.LIMIT)

*  Fix for PACS00312026
    FN.AC.REDO.ACCT.STATUS = 'F.AC.REDO.ACCT.STATUS'
    F.AC.REDO.ACCT.STATUS = ''
    CALL OPF(FN.AC.REDO.ACCT.STATUS,F.AC.REDO.ACCT.STATUS)

    FN.AC.REDO.AC.STATUS2 = 'F.AC.REDO.AC.STATUS2'
    F.AC.REDO.AC.STATUS2 = ''
    CALL OPF(FN.AC.REDO.AC.STATUS2,F.AC.REDO.AC.STATUS2)
*  End of Fix

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    Y.CUS.LIST = '*'
    Y.AZ.LIST  = '*'
    Y.COVE.LIST= '*'
    Y.HIS = ''

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
    GOSUB FORM.SELECT.CMD

    IF ENQ.ERROR THEN
        RETURN
    END

    GOSUB GET.DETAILS


RETURN
*--------------------------------------------------------------------------------------------------------
****************
FORM.SELECT.CMD:
****************

    Y.ACCOUNT.LIST = ''
    SEL.CMD = 'SELECT ':FN.REDO.EMPLOYEE.ACCOUNTS

    Y.ACC.TYPE      = ''
    Y.CLOSED.STATUS = ''
    Y.ESTATUS.1     = ''
    Y.ESTATUS.2     = ''
    Y.ESTATUS.SEL.2 = ''
    Y.ESTATUS.SEL.1 = ''
    Y.ACC.SEL.TYPE  = ''

    LOCATE 'TIPO.DE.CUENTA' IN D.FIELDS<1> SETTING Y.ACC.TYP.POS THEN
        Y.ACC.SEL.TYPE = D.RANGE.AND.VALUE<Y.ACC.TYP.POS>
    END

    LOCATE 'ESTATUS.CIERRE' IN D.FIELDS<1> SETTING Y.CLD.POS THEN
        Y.CLOSED.STATUS = D.RANGE.AND.VALUE<Y.CLD.POS>
        IF Y.CLOSED.STATUS AND Y.CLOSED.STATUS NE 'CIERRE' THEN
            ENQ.ERROR = 'ESTATUS.CIERRE should be CIERRE'
            RETURN
        END
    END

    LOCATE 'ESTATUS.1' IN D.FIELDS<1> SETTING Y.ESTAT1.POS THEN
        Y.ESTATUS.SEL.1 = D.RANGE.AND.VALUE<Y.ESTAT1.POS>
        CHANGE @SM TO ' ' IN Y.ESTATUS.SEL.1

    END

    LOCATE 'ESTATUS.2' IN D.FIELDS<1> SETTING Y.ESTAT2.POS THEN
        Y.ESTATUS.SEL.2 = D.RANGE.AND.VALUE<Y.ESTAT2.POS>
        CHANGE @SM TO ' ' IN Y.ESTATUS.SEL.2
    END


    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.CUS.ID.NEW FROM SEL.LIST SETTING POS.CU
    WHILE Y.CUS.ID.NEW:POS.CU
        CALL F.READ(FN.REDO.EMPLOYEE.ACCOUNTS,Y.CUS.ID.NEW,R.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS,Y.ERR)
        Y.ACCOUNT.LIST<-1> = R.REDO.EMPLOYEE.ACCOUNTS<REDO.EMP.ACCOUNT>
    REPEAT

*IF Y.CLOSED.STATUS AND NOT(RUNNING.UNDER.BATCH) THEN
*SEL.CMD.AC = 'SELECT ':FN.ACCOUNT.CLOSED: ' WITH @ID LIKE 1N...'
*Y.ACCOUNT.LIST = ''
*END ELSE
*SEL.CMD.AC = 'SELECT ':FN.ACCOUNT.CLOSED: ' WITH @ID LIKE 1N... '
*END
*IF RUNNING.UNDER.BATCH THEN
*SEL.CMD.AC = 'SELECT ':FN.ACCOUNT.CLOSED:' WITH @ID LIKE 1N...':' AND WITH ACCT.CLOSE.DATE EQ ':TODAY
*END
*GOSUB GET.ACCOUNT.CLOSED

*Y.ACCOUNT.LIST<-1> = SEL.LIST.AC

    CHANGE @VM TO @FM IN Y.ACCOUNT.LIST

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
GET.ACCOUNT.CLOSED:
*******************
    CALL EB.READLIST(SEL.CMD.AC,SEL.LIST.AC,'',NO.OF.REC.AC,SEL.ERR.AC)
RETURN
*--------------------------------------------------------------------------------------------------------
************
GET.DETAILS:
************

    GOSUB FIND.MULTI.LOCAL.REF
    LOOP
        REMOVE Y.ACCT.ID FROM Y.ACCOUNT.LIST SETTING Y.ACC.POS
    WHILE Y.ACCT.ID : Y.ACC.POS


        R.ACCOUNT = ''
        GOSUB GET.ACCOUNT.DETAILS

        IF CLOSED.FLAG THEN
            CONTINUE
        END

        IF Y.ERR.FLAG THEN
            CONTINUE
        END

        GOSUB VALIDATE.CATEG

        IF CATEG.FLAG THEN
            CONTINUE
        END


        GOSUB GET.DEBIT.CARD.NUMBER
        GOSUB GET.INVST.CUS.NAME
        GOSUB GET.LAST.TRANS.DATE
        GOSUB GET.INVST.ACCT.NUMBER

        Y.ERR.FALG = ''
        GOSUB FINAL.CHECK
        LOOKUP.ID = 'L.AC.STATUS1'
        Y.VALUE = Y.ESTATUS.1
        GOSUB RETRIEVE.SPANISH.DESC
        Y.ESTATUS.1=Y.VALUE

        Y.VALUE = ''
        LOOKUP.ID = 'L.AC.STATUS2'
        Y.VALUE = Y.ESTATUS.2
        GOSUB RETRIEVE.SPANISH.DESC
        Y.ESTATUS.2 = Y.VALUE

        Y.VALUE = ''
        LOOKUP.ID = 'L.AC.NOTIFY.1'
        Y.VALUE = Y.NOTIFY
        GOSUB RETRIEVE.SPANISH.DESC
        Y.NOTIFY = Y.VALUE

        IF NOT(Y.ERR.FALG) THEN
            Y.OUT.ARRAY<-1> = Y.CLIENT.CODE:"*":Y.CURRENCY:"*":Y.ACCT.TYPE:"*":Y.PREV.AC.NO:"*":Y.ACCT.ID:"*":Y.DB.CARD.NO:"*":Y.ACCT.NAME:"*":Y.CLIENT.CODE:"*":Y.ACCT.EXEC:"*":Y.CURRENCY:"*":Y.TOT.BAL:"*":Y.AVAIL.BAL:"*":Y.TRANS.BAL:"*":Y.BLKD.AMT:"*":Y.CLOSED.STATUS:"*":Y.ESTATUS.1:"*":Y.ESTATUS.2:"*":Y.LT.TXN.DATE:"*":Y.NOTIFY:"*":Y.OPEN.DATE:"*":Y.CANCL.DATE:"*":Y.INVST.ACCT:"*":Y.COVR.ACCT:"*":Y.AGENCY
        END
        Y.ACCT.TYPE = '' ; Y.PREV.AC.NO = '' ; Y.DB.CARD.NO = '';Y.ACCT.NAME='';Y.CLIENT.CODE='';Y.ACCT.EXEC='';Y.CURRENCY='';Y.TOT.BAL='';Y.AVAIL.BAL='';Y.TRANS.BAL='';Y.BLKD.AMT='';Y.ESTATUS.1='';Y.ESTATUS.2='';Y.LT.TXN.DATE='';Y.NOTIFY='';Y.OPEN.DATE='';Y.CANCL.DATE='';Y.INVST.ACCT='';Y.COVR.ACCT='';Y.AGENCY=''
        Y.ERR.FALG = ''

    REPEAT

    Y.OUT.ARRAY = CHANGE(Y.OUT.ARRAY, @VM, '(VM*VM)')
    Y.OUT.ARRAY = CHANGE(Y.OUT.ARRAY, @SM, '(SM*SM)')
    Y.OUT.ARRAY = SORT(Y.OUT.ARRAY)
    Y.OUT.ARRAY = CHANGE(Y.OUT.ARRAY, '(VM*VM)', @VM)
    Y.OUT.ARRAY = CHANGE(Y.OUT.ARRAY, '(SM*SM)', @SM)

RETURN
*--------------------------------------------------------------------------------------------------------
FINAL.CHECK:
*--------------------------------------------------------------------------------------------------------

    IF Y.ESTATUS.SEL.1 THEN
        Y.ESTATUS.1.LIST = Y.ESTATUS.1
        CHANGE @SM TO @FM IN Y.ESTATUS.1.LIST
        CHANGE @VM TO @FM IN Y.ESTATUS.1.LIST
        LOCATE Y.ESTATUS.SEL.1 IN Y.ESTATUS.1.LIST SETTING POS ELSE
            Y.ERR.FALG = '1'
        END
    END
    IF Y.ESTATUS.SEL.2 THEN
        Y.ESTATUS.2.LIST = Y.ESTATUS.2
        CHANGE @SM TO @FM IN Y.ESTATUS.2.LIST
        CHANGE @VM TO @FM IN Y.ESTATUS.2.LIST
        LOCATE Y.ESTATUS.SEL.2 IN Y.ESTATUS.2.LIST SETTING POS ELSE
            Y.ERR.FALG = '1'
        END
    END
    IF Y.ACC.SEL.TYPE AND CATEGORY.ID NE Y.ACC.SEL.TYPE THEN
        Y.ERR.FALG = '1'
    END

RETURN

*--------------------------------------------------------------------------------------------------------
********************
GET.ACCOUNT.DETAILS:
********************

    Y.ERR.FLAG = ''
    ACCOUNT.ID = Y.ACCT.ID
    CLOSED.FLAG = ''

    GOSUB READ.ACCOUNT
    IF NOT(R.ACCOUNT) THEN
        GOSUB READ.ACCOUNT$HIS
        REC.STATUS = R.ACCOUNT<AC.RECORD.STATUS>
        IF REC.STATUS EQ 'CLOSED' THEN
            CLOSED.FLAG = 1
            RETURN
        END
    END

    CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
    GOSUB READ.CUSTOMER
    IF NOT(R.CUSTOMER<EB.CUS.FAX.1>) THEN
        Y.ERR.FLAG = 1
        RETURN
    END

    CATEGORY.ID = R.ACCOUNT<AC.CATEGORY>

    GOSUB READ.CATEGORY

    Y.ACCT.TYPE = R.CATEGORY<EB.CAT.DESCRIPTION>
    CHANGE '*' TO '' IN Y.ACCT.TYPE

    Y.PREV.AC.NO = R.ACCOUNT<AC.ALT.ACCT.ID,1>
    Y.ACCT.EXEC  = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    Y.CURRENCY   = R.ACCOUNT<AC.CURRENCY>
*TUS Start
    IF ACC.LIVE.FLAG THEN
        Y.TOT.BAL = R.ECB<ECB.ONLINE.ACTUAL.BAL>
    END ELSE
*  Y.TOT.BAL    = R.ACCOUNT<AC.ONLINE.ACTUAL.BAL>
    END
*TUS End
    AZ.ACCOUNT.ID = ACCOUNT.ID
    GOSUB READ.AZ.ACCOUNT
    IF R.AZ.ACCOUNT THEN
        Y.AVAIL.BAL = R.AZ.ACCOUNT<AZ.PRINCIPAL> + R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.BAL.POS>
    END
    ELSE
        Y.AVAIL.BAL  = R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS>
    END
*Y.TRANS.BAL  = ABS(R.ACCOUNT<AC.ONLINE.ACTUAL.BAL> - R.ACCOUNT<AC.ONLINE.CLEARED.BAL>)
    Y.TRANS.BAL = R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.TRAN.BAL.POS>
*  GOSUB READ.AC.LCKEVENTS

    Y.BLKD.AMT   = R.ACCOUNT<AC.LOCKED.AMOUNT>
    Y.ESTATUS.1  = R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.STATUS1.POS>

    Y.ESTATUS.2  = R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.STATUS2.POS>
    CHANGE @SM TO @VM IN Y.ESTATUS.2
    Y.NOTIFY     = R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.NOTIFY.1.POS>
    CHANGE @SM TO @VM IN Y.NOTIFY
    Y.OPEN.DATE  = R.ACCOUNT<AC.OPENING.DATE>
    Y.CANCL.DATE = R.ACCOUNT<AC.CLOSURE.DATE>
    Y.AGENCY     = R.ACCOUNT<AC.CO.CODE>
    Y.LIMIT.REF = R.ACCOUNT<AC.LIMIT.REF>

* Fix for PACS00312026 [Agencia should display company name]

    CALL CACHE.READ(FN.COMPANY,Y.AGENCY,Y.GET.COMPANY,COMPANY.ERR)
    Y.AGENCY = Y.GET.COMPANY<EB.COM.COMPANY.NAME>

* End of Fix

    IF NOT(Y.TOT.BAL) THEN
        Y.TOT.BAL = 0
    END
    IF NOT(Y.AVAIL.BAL) THEN
        Y.AVAIL.BAL = 0
    END
    IF NOT(Y.TRANS.BAL) THEN
        Y.TRANS.BAL = 0
    END
    IF NOT(Y.BLKD.AMT) THEN
        Y.BLKD.AMT = 0
    END

    Y.LIMIT.ACCT = CUSTOMER.ID:'.000':Y.LIMIT.REF

    CALL F.READ(FN.LIMIT,Y.LIMIT.ACCT,R.LIMIT.REC,F.LIMIT,LIM.ERR)
    Y.COVR.ACCT = R.LIMIT.REC<LI.ACCOUNT>

RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.COMPANY.NAME:
*----------------------------------------------------------------------------------------------------------------------
* Fix for PACS00312026 [Agencia should display company name]

    CALL F.REA

* End of Fix

RETURN

*--------------------------------------------------------------------------------------------------------
**********************
GET.DEBIT.CARD.NUMBER:
**********************

    Y.ACCT.ID = FIELD(Y.ACCT.ID,';',1)
    Y.CUR.ID = Y.ACCT.ID
    LATAM.CARD.CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
    GOSUB READ.LATAM.CARD.CUSTOMER

    Y.ACCT.DETS = R.LATAM.CARD.CUSTOMER<APAP.DC.ACCOUNT.NO>
    Y.CARD.NOS  = R.LATAM.CARD.CUSTOMER<APAP.DC.CARD.NO>

    Y.ACC.COUNT = DCOUNT(Y.ACCT.DETS,@VM)
    Y.ACC.START = 1
    Y.CARD.IDS  = ''
    LOOP
    WHILE Y.ACC.START LE Y.ACC.COUNT
        Y.CHK.ACCT = Y.ACCT.DETS<1,Y.ACC.START>
        IF Y.CHK.ACCT NE Y.CUR.ID THEN
            Y.ACC.START += 1
            CONTINUE
        END
        Y.CARD.IDS<-1> = Y.CARD.NOS<1,Y.ACC.START>[6,99]
        Y.ACC.START += 1
    REPEAT

    CHANGE @FM TO @VM IN Y.CARD.IDS
    Y.DB.CARD.NO = Y.CARD.IDS

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
GET.INVST.CUS.NAME:
*******************
    CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
    Y.CLIENT.CODE = CUSTOMER.ID

    GOSUB READ.CUSTOMER

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
    END

    IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.SHORT.NAME>
    END

    Y.RELATION.COUNT = DCOUNT(R.ACCOUNT<AC.RELATION.CODE>,@VM)

    Y.COUNT = 1

    LOOP
    WHILE Y.COUNT LE Y.RELATION.COUNT
        RELATION.ID = R.ACCOUNT<AC.RELATION.CODE,Y.COUNT>

        IF RELATION.ID LT 500 AND RELATION.ID GT 529 THEN
            CONTINUE
        END

        GOSUB READ.RELATION

        Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>

        CUSTOMER.ID = R.ACCOUNT<AC.JOINT.HOLDER,Y.COUNT>

        GOSUB READ.CUSTOMER

        IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
        END

        IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END

        IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
        END

        Y.CUS.NAMES := @VM:Y.REL.DESC:'-':Y.CUS.NAME
        Y.CLIENT.CODE := @VM:CUSTOMER.ID
        Y.CUS.NAMES = CHANGE(Y.CUS.NAMES, @VM, '; ')
        Y.CLIENT.CODE = CHANGE(Y.CLIENT.CODE, @VM, '; ')
        Y.COUNT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT

    Y.ACCT.NAME = Y.CUS.NAMES

RETURN
*--------------------------------------------------------------------------------------------------------
********************
GET.LAST.TRANS.DATE:
********************
*TUS Start
    IF ACC.LIVE.FLAG THEN
        LOCATE 'CUST-CR' IN R.ECB<ECB.INITIATOR.TYPE,1> SETTING CUST.CR.POS THEN
            YR.DATE.LAST.CR.CUST = R.ECB<ECB.DATE.LAST,CUST.CR.POS>
        END
        LOCATE 'CUST-DR' IN R.ECB<ECB.INITIATOR.TYPE,1> SETTING CUST.DR.POS THEN
            YR.DATE.LAST.DR.CUST = R.ECB<ECB.DATE.LAST,CUST.DR.POS>
        END
        IF YR.DATE.LAST.CR.CUST AND NOT(YR.DATE.LAST.DR.CUST) THEN
            Y.LT.TXN.DATE = YR.DATE.LAST.CR.CUST
        END

        IF NOT(YR.DATE.LAST.CR.CUST) AND YR.DATE.LAST.DR.CUST THEN
            Y.LT.TXN.DATE = YR.DATE.LAST.DR.CUST
        END

        IF YR.DATE.LAST.CR.CUST AND YR.DATE.LAST.DR.CUST THEN
            IF YR.DATE.LAST.CR.CUST GE YR.DATE.LAST.DR.CUST THEN
                Y.LT.TXN.DATE = YR.DATE.LAST.CR.CUST
            END ELSE
                Y.LT.TXN.DATE = YR.DATE.LAST.DR.CUST
            END
        END
    END ELSE
* IF R.ACCOUNT<AC.DATE.LAST.CR.CUST> AND NOT(R.ACCOUNT<AC.DATE.LAST.DR.CUST>) THEN
*  Y.LT.TXN.DATE = R.ACCOUNT<AC.DATE.LAST.CR.CUST>
* END

*IF NOT(R.ACCOUNT<AC.DATE.LAST.CR.CUST>) AND R.ACCOUNT<AC.DATE.LAST.DR.CUST> THEN
* Y.LT.TXN.DATE = R.ACCOUNT<AC.DATE.LAST.DR.CUST>
*END

*IF R.ACCOUNT<AC.DATE.LAST.CR.CUST> AND R.ACCOUNT<AC.DATE.LAST.DR.CUST> THEN
* IF R.ACCOUNT<AC.DATE.LAST.CR.CUST> GE R.ACCOUNT<AC.DATE.LAST.DR.CUST> THEN
*  Y.LT.TXN.DATE = R.ACCOUNT<AC.DATE.LAST.CR.CUST>
* END ELSE
*  Y.LT.TXN.DATE = R.ACCOUNT<AC.DATE.LAST.DR.CUST>
*   END
* END
    END
*TUS End
RETURN
*--------------------------------------------------------------------------------------------------------
**********************
GET.INVST.ACCT.NUMBER:
**********************
    Y.ACCT.ID = FIELD(Y.ACCT.ID,';',1)
    AC.ACCOUNT.LINK.CONCAT.ID = Y.ACCT.ID
    GOSUB READ.AC.ACCOUNT.LINK.CONCAT
    AC.ACCOUNT.LINK.ID = R.AC.ACCOUNT.LINK.CONCAT
    GOSUB READ.AC.ACCOUNT.LINK
    IF R.AC.ACCOUNT.LINK<AC.LINK.SWEEP.TYPE> EQ 'SURPLUS' THEN
        Y.INVST.ACCT = Y.ACCT.ID
    END ELSE
        Y.INVST.ACCT = ''
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
    R.ACCOUNT  = ''
    ACCOUNT.ER = ''
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)
*TUS Start
    ACC.LIVE.FLAG = ''
    R.ECB = ''
    ECB.ERR = ''
    CALL EB.READ.HVT('EB.CONTRACT.BALANCES', ACCOUNT.ID, R.ECB, ECB.ERR)
    IF R.ECB THEN
        ACC.LIVE.FLAG = 1
    END
*TUS End
RETURN
*--------------------------------------------------------------------------------------------------------
*****************
READ.ACCOUNT$HIS:
*****************
*   R.ACCOUNT$HIS  = ''
*  ACCOUNT$HIS.ER = ''
*    CALL F.READ(FN.ACCOUNT$HIS,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT$HIS,ACCOUNT$HIS.ER)
    CALL EB.READ.HISTORY.REC (F.ACCOUNT$HIS,ACCOUNT.ID,R.ACCOUNT,Y.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.CUSTOMER:
*************
    R.CUSTOMER  = ''
    CUSTOMER.ER = ''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.CATEGORY:
*************
    R.CATEGORY  = ''
    CATEGORY.ER = ''
    CALL CACHE.READ(FN.CATEGORY, CATEGORY.ID, R.CATEGORY, CATEGORY.ER) ;*R22 AUTO CODE CONVERSION

RETURN
*--------------------------------------------------------------------------------------------------------
*************************
READ.LATAM.CARD.CUSTOMER:
*************************
    R.LATAM.CARD.CUSTOMER  = ''
    LATAM.CARD.CUSTOMER.ER = ''
    CALL F.READ(FN.LATAM.CARD.CUSTOMER,LATAM.CARD.CUSTOMER.ID,R.LATAM.CARD.CUSTOMER,F.LATAM.CARD.CUSTOMER,LATAM.CARD.CUSTOMER.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
READ.CUSTOMER.ACCOUNT:
**********************
    R.CUSTOMER.ACCOUNT  = ''
    CUSTOMER.ACCOUNT.ER = ''
    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUSTOMER.ACCOUNT.ID,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,CUSTOMER.ACCOUNT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
****************
READ.AZ.ACCOUNT:
****************
    R.AZ.ACCOUNT  = ''
    AZ.ACCOUNT.ER = ''
    CALL F.READ(FN.AZ.ACCOUNT,AZ.ACCOUNT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
**************
READ.RELATION:
**************
    R.RELATION  = ''
    RELATION.ER = ''
    CALL F.READ(FN.RELATION,RELATION.ID,R.RELATION,F.RELATION,RELATION.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
****************************
READ.AC.ACCOUNT.LINK.CONCAT:
****************************
    R.AC.ACCOUNT.LINK.CONCAT  = ''
    AC.ACCOUNT.LINK.CONCAT.ER = ''
    CALL F.READ(FN.AC.ACCOUNT.LINK.CONCAT,AC.ACCOUNT.LINK.CONCAT.ID,R.AC.ACCOUNT.LINK.CONCAT,F.AC.ACCOUNT.LINK.CONCAT,AC.ACCOUNT.LINK.CONCAT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
READ.AC.ACCOUNT.LINK:
*********************
    R.AC.ACCOUNT.LINK  = ''
    AC.ACCOUNT.LINK.ER = ''
    CALL F.READ(FN.AC.ACCOUNT.LINK,AC.ACCOUNT.LINK.ID,R.AC.ACCOUNT.LINK,F.AC.ACCOUNT.LINK,AC.ACCOUNT.LINK.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'CUSTOMER':@FM:'ACCOUNT':@FM:'AZ.ACCOUNT'
    FLD.ARRAY = 'L.CU.TIPO.CL':@FM:'L.AC.STATUS1':@VM:'L.AC.STATUS2':@VM:'L.AC.NOTIFY.1':@VM:'L.AC.AV.BAL':@VM:'L.AC.TRAN.AVAIL':@FM:'L.AZ.REIVSD.INT'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CU.TIPO.CL.POS  = FLD.POS<1,1>
    LOC.L.AC.STATUS1.POS  = FLD.POS<2,1>
    LOC.L.AC.STATUS2.POS  = FLD.POS<2,2>
    LOC.L.AC.NOTIFY.1.POS = FLD.POS<2,3>
    LOC.L.AC.AV.BAL.POS   = FLD.POS<2,4>
    LOC.L.AC.TRAN.BAL.POS = FLD.POS<2,5>
    LOC.L.AZ.BAL.POS = FLD.POS<3,1>

RETURN
*--------------------------------------------------------------------------------------------------------
RETRIEVE.SPANISH.DESC:
* Fix for PACS00312026

    VIRTUAL.TAB.ID=LOOKUP.ID
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
    Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
    Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC
    Y.VAL.SEQ = 1
    Y.VAL.CNT = DCOUNT(Y.VALUE,@VM)
    LOOP
    WHILE Y.VAL.SEQ LE Y.VAL.CNT
        LOCATE Y.VALUE<1,Y.VAL.SEQ> IN Y.LOOKUP.LIST SETTING POS1 THEN
            IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN        ;* This is for english user
                Y.VALUE<1,Y.VAL.SEQ>=Y.LOOKUP.DESC<POS1,1>
            END
            IF R.USER<EB.USE.LANGUAGE> EQ 2 AND Y.LOOKUP.DESC<POS1,2> NE '' THEN
                Y.VALUE<1,Y.VAL.SEQ>=Y.LOOKUP.DESC<POS1,2>          ;* This is for spanish user
            END ELSE
                Y.VALUE<1,Y.VAL.SEQ>=Y.LOOKUP.DESC<POS1,1>
            END
        END
        Y.VAL.SEQ += 1

    REPEAT
* End of Fix
RETURN
*-------------------------------------------------------------------------------------------------------------
VALIDATE.CATEG:
    CATEG.FLAG = ''

    IF CATEGORY.ID GE '1000' AND CATEGORY.ID LE '1999' ELSE
        IF CATEGORY.ID GE '6001' AND CATEGORY.ID LE '6099' ELSE
            IF CATEGORY.ID GE '6501' AND CATEGORY.ID LE '6699' ELSE
                CATEG.FLAG = 1
                RETURN
            END
        END
    END
    IF CATEGORY.ID GE '6001' AND CATEGORY.ID LE '6099' THEN
        IF CATEGORY.ID GE '6013' AND CATEGORY.ID LE '6020' THEN
            CATEG.FLAG = 1
        END
    END



RETURN
*-------------------------------------------------------------------------------------------------------------
*READ.AC.LCKEVENTS:

* Y.LOCKED.AMT = ''
* SEL.CMD.ALE = "SELECT ":FN.AC.LOCKED.EVENTS:" WITH ACCOUNT.NUMBER EQ ":Y.ACCT.ID
* CALL EB.READLIST(SEL.CMD.ALE,SEL.LIST.ALE,'',NO.OF.REC.ALE,RET.CODE.ALE)

*  LOOP
*    REMOVE Y.AC.LOCK.ID FROM SEL.LIST.ALE SETTING AC.LOCK.POS
*  WHILE Y.AC.LOCK.ID:AC.LOCK.POS

*    CALL F.READ(FN.AC.LOCKED.EVENTS,Y.AC.LOCK.ID,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,AC.LOCK.ERR)
*    Y.LOCKED.AMT += R.AC.LOCKED.EVENTS<AC.LCK.LOCKED.AMOUNT>

*  REPEAT
*  Y.BLKD.AMT = Y.LOCKED.AMT

*  RETURN

END
