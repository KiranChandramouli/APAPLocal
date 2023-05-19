SUBROUTINE REDO.E.NOF.BPS.NOT.TYPE(BPS.ARRAY)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.NOF.BPS.NOT.TYPE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a no file enquiry routine which consolidates investment blocked notifications for pledging or seizure
*Linked With  : Enquiry REDO.APAP.BPS.NOT.TYPE
*In Parameter : N/A
*Out Parameter: BPS.ARRAY
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------                -------------            -------------
* 19th Aug 2010    SWAMINATHAN.S.R       ODR-2010-03-0154       Initial Creation
* 15th Nov 2010    Janani                ODR-2010-03-0154       Initial Creation
* 04/03/2014       Vignesh Kumaar R      PACS00309833           REPORT 108 SUPPORT ISSUES
* 02/09/2014       Ajish Ahammed         PACS00309833           few more issues under same ref.
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.RELATION
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.CATEGORY
    $INSERT I_F.APAP.H.GARNISH.DETAILS
    $INSERT I_F.AC.REDO.AC.STATUS2
* Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
* Tus End
*---------------------------------------------------------------------------------------------------------
    GOSUB INIT
    GOSUB GET.LR.FLD.POS

    GOSUB PROCESS
    GOSUB GOEND
RETURN
*----------------------------------------------------------------------------------------------------------
INIT:
******
*
*Intialise the necessary variables and Open the file
*
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT  = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
*
    FN.AZ.ACCOUNT.HIS = 'F.AZ.ACCOUNT$HIS'
    F.AZ.ACCOUNT.HIS  = ''
    CALL OPF(FN.AZ.ACCOUNT.HIS,F.AZ.ACCOUNT.HIS)

*
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
    FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HIS  = ''
    CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
    FN.RELATION = 'F.RELATION'
    F.RELATION  = ''
    CALL OPF(FN.RELATION,F.RELATION)
*
    FN.DEPT.ACCT.OFFICER = 'F.DEPT.ACCT.OFFICER'
    F.DEPT.ACCT.OFFICER  = ''
    CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)
*
    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS  = ''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)
*
    FN.AC.LOCKED.EVENTS.HIS = 'F.AC.LOCKED.EVENTS$HIS'
    F.AC.LOCKED.EVENTS.HIS  = ''
    CALL OPF(FN.AC.LOCKED.EVENTS.HIS,F.AC.LOCKED.EVENTS.HIS)
*
    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)
*
    FN.APAP.H.GARNISH.DETAILS = 'F.APAP.H.GARNISH.DETAILS'
    F.APAP.H.GARNISH.DETAILS = ''
    CALL OPF(FN.APAP.H.GARNISH.DETAILS, F.APAP.H.GARNISH.DETAILS)

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

RETURN
*------------------------------------------------------------------------------------------------------------------
GET.LR.FLD.POS:
*****************

    APPL.ARRAY = "CUSTOMER":@FM:"AZ.ACCOUNT":@FM:"AC.LOCKED.EVENTS":@FM:"ACCOUNT"
    FLD.ARRAY = "L.CU.TIPO.CL":@FM:"L.AZ.ORG.DP.AMT":@VM:"L.AC.NOTIFY.1":@FM:"L.AC.STATUS2":@VM:"L.AC.GAR.REF.NO":@VM:"L.AC.LOCKE.TYPE":@FM:"L.AC.REINVESTED":@VM:"L.AC.NOTIFY.1":@VM:"L.AC.STATUS1":@VM:"L.AC.STATUS2"
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.CU.TIPO.CL.POS = FLD.POS<1,1>
    LOC.ORIG.DEP.AMT.POS = FLD.POS<2,1>

    LOC.L.ALE.STATUS2.POS = FLD.POS<3,1>
    Y.GARNISH.ID.POS = FLD.POS<3,2>
    LOC.L.AC.LOCKE.TYPE.POS = FLD.POS<3,3>

    LOC.L.AC.REINVESTED.POS = FLD.POS<4,1>
    LOC.L.AC.NOTIFY.1.POS = FLD.POS<2,2>
    LOC.L.AC.STATUS1.POS = FLD.POS<4,3>
    LOC.L.AC.STATUS2.POS = FLD.POS<4,4>
*
RETURN
*-------------------------------------------------------------------------------------------------------------------------
PROCESS:
*********
    GOSUB LOCATE.FILE

    CALL EB.READLIST(SEL.CMD.AZ,SEL.LIST.AZ,'',NO.OF.AZ.REC,SEL.ERR.AZ)

    LOOP

        Y.AGENCY = ''
        Y.ACCOUNT.EXEECUTIVE = ''
        Y.BDY.REGION = ''
        Y.INVESTMENT.TYPE.DESC = ''
        Y.CURRENCY = ''
        Y.PREV.INVESTMENT.NUMBER = ''
        Y.INVESTMENT.NUMBER = ''
        Y.INVESTMENT.CUSTOMER.NAME = ''
        Y.CLIENT.CODE = ''
        Y.INVESTMENT.AMOUNT = ''
        Y.CURRENT.AMOUNT = ''
        Y.STATUS = ''
        Y.NOTIFICATION.TYPE = ''
        Y.STARTING.DATE = ''
        Y.LIFTING.DATE = ''
        Y.USER.INPUTS = ''
        Y.USER.AUTHORIZES = ''
        Y.BLOCK.PLEDGE.TYPE = ''
        Y.BLOCK.PLEDGE.STARTING.DATE = ''
        Y.BLOCK.PLEDGE.AMOUNT = ''
        Y.BLOCK.PLEDGE.RELEASE.DATE = ''
        Y.BLOCK.PLEDGE.USER.INPUTS = ''
        Y.BLOCK.PLEDGE.USER.AUTHORIZES = ''
        Y.SEIZURE.TYPE = ''
        Y.SEIZURE.STARTING.DATE = ''
        Y.SEIZURE.AMOUNT = ''
        Y.SEIZURE.RELEASE.DATE = ''
        Y.SEIZURE.USER.INPUTS = ''
        Y.SEIZURE.AUTHORIZES = ''
        Y.GARNISH.BENEF = ''
        REMOVE Y.AZ.ID FROM SEL.LIST.AZ SETTING AZ.POS
    WHILE Y.AZ.ID:AZ.POS

        CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,Y.ERR.AZ)
*
        GOSUB CHECK.ALE
*
    REPEAT

    IF BPS.ARRAY THEN
        DEL BPS.ARRAY<1>
        BPS.ARRAY = CHANGE(BPS.ARRAY, @FM, '#####')
        BPS.ARRAY = CHANGE(BPS.ARRAY, @VM, '$$$$$')
        BPS.ARRAY = CHANGE(BPS.ARRAY, @SM, '~~~~~')
        BPS.ARRAY = SORT(BPS.ARRAY)
        BPS.ARRAY = CHANGE(BPS.ARRAY, '#####', @FM)
        BPS.ARRAY = CHANGE(BPS.ARRAY, '$$$$$', @VM)
        BPS.ARRAY = CHANGE(BPS.ARRAY, '~~~~~', @SM)
    END

RETURN
*-------------------------------------------------------------------------------------------------------------------------------
CHECK.ALE:
*---------

    SEL.CMD.AC.LOC.EVENT = "SELECT ":FN.AC.LOCKED.EVENTS:" WITH (ACCOUNT.NUMBER EQ ":Y.AZ.ID:")"
    IF SEL.CMD.AC.LOCK THEN
        SEL.CMD.AC.LOC.EVENT := SEL.CMD.AC.LOCK
    END

    CALL EB.READLIST(SEL.CMD.AC.LOC.EVENT,SEL.LIST.AC.LOC.EVENT,'',NO.OF.ALE.REC,SEL.ERR.ALE)
    IF SEL.LIST.AC.LOC.EVENT THEN
        GOSUB MAIN.PROC
    END

RETURN
*------------------------------------------------------------------------------------------------------

LOCATE.FILE:
**************
*Locate selection crieteria field values
*

    SEL.CMD.AZ = 'SELECT ':FN.AZ.ACCOUNT

    LOCATE "INVESTMENT.TYPE" IN D.FIELDS<1> SETTING Y.INVESTMENT.TYPE.POS THEN
        Y.INVESTMENT.TYPE.VAL = D.RANGE.AND.VALUE<Y.INVESTMENT.TYPE.POS>
        Y.CLASSIFICATION := 'TIPO DE INVERSION : ':Y.INVESTMENT.TYPE.VAL:'; '
        SEL.CMD.AZ := ' WITH CATEGORY EQ ':Y.INVESTMENT.TYPE.VAL
    END
*
    LOCATE "TYPE.OF.STATUS" IN D.FIELDS<1> SETTING Y.TYPE.OF.STATUS.POS THEN
        Y.TYPE.OF.STATUS.VAL = D.RANGE.AND.VALUE<Y.TYPE.OF.STATUS.POS>

        LOOKUP.ID = 'L.AC.LOCKE.TYPE*':Y.TYPE.OF.STATUS.VAL
        CALL CACHE.READ(FN.EB.LOOKUP,LOOKUP.ID,R.EB.LOOKUP,ERR.EB.LOOKUP)
        Y.STATUS2.DESC = R.EB.LOOKUP<EB.LU.DESCRIPTION,2>

        IF Y.STATUS2.DESC EQ '' THEN
            Y.STATUS2.DESC = R.EB.LOOKUP<EB.LU.DESCRIPTION,1>
        END

        Y.CLASSIFICATION := 'TIPO DE BLOQUEO : ':Y.STATUS2.DESC:'; '
        SEL.CMD.AC.LOCK = ' AND L.AC.LOCKE.TYPE EQ ':Y.TYPE.OF.STATUS.VAL
    END
*

    LOCATE "TYPE.OF.NOTIFY" IN D.FIELDS<1> SETTING Y.TYPE.OF.AD.POS THEN

        Y.TYPE.OF.AD.VAL = D.RANGE.AND.VALUE<Y.TYPE.OF.AD.POS>

        LOOKUP.ID = 'L.AC.NOTIFY.1*':Y.TYPE.OF.AD.VAL
        CALL CACHE.READ(FN.EB.LOOKUP,LOOKUP.ID,R.EB.LOOKUP,ERR.EB.LOOKUP)
        Y.AD.DESC = R.EB.LOOKUP<EB.LU.DESCRIPTION,2>

        IF Y.AD.DESC EQ '' THEN
            Y.AD.DESC = R.EB.LOOKUP<EB.LU.DESCRIPTION,1>
        END

        Y.CLASSIFICATION := 'TIPO DE AVISO : ':Y.AD.DESC:'; '
    END

    LOCATE "DATE" IN D.FIELDS<1> SETTING Y.DATE.POS THEN
        Y.DATE.VAL= D.RANGE.AND.VALUE<Y.DATE.POS>
        Y.DATE.VAL.FROM = D.RANGE.AND.VALUE<Y.DATE.POS,1,1>
        Y.DATE.VAL.TO = D.RANGE.AND.VALUE<Y.DATE.POS,1,2>
        IF NOT(NUM(Y.DATE.VAL.FROM)) OR LEN(Y.DATE.VAL.FROM) NE '8' OR NOT(NUM(Y.DATE.VAL.TO)) OR LEN(Y.DATE.VAL.TO) NE '8' THEN
            ENQ.ERROR = 'EB-REDO.DATE.RANGE'
            CALL STORE.END.ERROR
            GOSUB GOEND
        END

        IF Y.DATE.VAL.FROM[5,2] GT 12 OR Y.DATE.VAL.TO[5,2] GT 12 OR Y.DATE.VAL.FROM[7,2] GT 31 OR Y.DATE.VAL.TO[7,2] GT 31 OR Y.DATE.VAL.TO GT TODAY OR Y.DATE.VAL.FROM GT TODAY OR Y.DATE.VAL.FROM GT Y.DATE.VAL.TO THEN
            ENQ.ERROR = 'EB-REDO.DATE.RANGE'
            CALL STORE.END.ERROR
            GOSUB GOEND
        END

        CALL EB.DATE.FORMAT.DISPLAY(Y.DATE.VAL.FROM, Y.CLASS.DATE1, '', '')
        CALL EB.DATE.FORMAT.DISPLAY(Y.DATE.VAL.TO, Y.CLASS.DATE2, '', '')
        Y.CLASSIFICATION := 'FECHA : ':Y.CLASS.DATE1:' A ':Y.CLASS.DATE2:'; '

    END
    IF NOT(D.FIELDS) OR D.FIELDS EQ 'BPS.ARRAY' THEN
        Y.CLASSIFICATION = 'TODOS'
    END

RETURN
*-------------------------------------------------------------------------------------------------------------------------------
MAIN.PROC:
************
**AZ.ACCOUNT
**ACCOUNT

    CALL F.READ(FN.ACCOUNT,Y.AZ.ID,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
    Y.ACCOUNT.EXECUTIVE = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    Y.PREV.INVESTMENT.NUMBER = R.ACCOUNT<AC.ALT.ACCT.ID,1>
    Y.CLOSURE.DATE = R.ACCOUNT<AC.CLOSURE.DATE>
    Y.REINVESTED.DEPOSIT = R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.REINVESTED.POS>
*Y.NOTIFICATION.TYPE =  R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.NOTIFY.1.POS>
    Y.NOTIFICATION.TYPE =  R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AC.NOTIFY.1.POS>
    Y.NOTIFICATION.TYPE = CHANGE(Y.NOTIFICATION.TYPE,@SM,';')  ;* Fix for PACS00309833 [NOTIFY SHOULD DISPLAY MULTI VALUES]

    Y.L.AC.STATUS1 =  R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.STATUS1.POS>
    Y.L.AC.STATUS2 =  R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.STATUS2.POS>
    Y.L.AC.STATUS2 = CHANGE(Y.L.AC.STATUS2,@VM,';')  ;* Fix for PACS00309833 [#7 ESTATUS 2 SHOULD DISPLAY MULTI VALUES]

    Y.REL.CODE = R.ACCOUNT<AC.RELATION.CODE>

* Fix for PACS00309833 [# NOFITY CHECK IN THE ACCOUNT]

    IF Y.TYPE.OF.AD.VAL THEN
        Y.NOTIFY.LIST = R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AC.NOTIFY.1.POS>
        LOCATE Y.TYPE.OF.AD.VAL IN Y.NOTIFY.LIST<1,1,1> SETTING NOT.POS ELSE
            RETURN
        END
    END

* End of Fix

    IF NOT(Y.L.AC.STATUS2) AND NOT(Y.NOTIFICATION.TYPE) THEN
        RETURN
    END

    Y.INVESTMENT.NUMBER = Y.AZ.ID
    Y.AGENCY = R.AZ.ACCOUNT<AZ.CO.CODE>
    Y.CURRENCY = R.AZ.ACCOUNT<AZ.CURRENCY>
    Y.CLIENT.CODE = R.AZ.ACCOUNT<AZ.CUSTOMER>
    Y.INVESTMENT.AMOUNT = R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.ORIG.DEP.AMT.POS>
    Y.PRINCIPAL = R.AZ.ACCOUNT<AZ.PRINCIPAL>

    IF Y.INVESTMENT.AMOUNT EQ '' THEN
        Y.INVESTMENT.AMOUNT = Y.PRINCIPAL
    END

    Y.INTEREST.LIQU.ACCT = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>

* Fix for PACS00309833 [#5 TIPO DE INVERSION - CATEGORY DESCRIPTION]

    Y.INVESTMENT.TYPE.VAL = R.AZ.ACCOUNT<AZ.CATEGORY>

    Y.CATEGORY = R.AZ.ACCOUNT<AZ.CATEGORY>
    CALL CACHE.READ(FN.CATEGORY, Y.CATEGORY, R.CATEGORY, Y.ERR.CATEG)
    Y.INVESTMENT.TYPE.DESC = R.CATEGORY<EB.CAT.DESCRIPTION>

* End of Fix

    IF Y.REINVESTED.DEPOSIT EQ 'YES' THEN
        CALL F.READ(FN.ACCOUNT,Y.INTEREST.LIQU.ACCT,R.LIQ.ACCOUNT,F.ACCOUNT,Y.AC.LIQ.ERR)
*   Tus Start
        R.ECB=''
        ECB.ERR=''
        CALL EB.READ.HVT('EB.CONTRACT.BALANCES',Y.INTEREST.LIQU.ACCT,R.ECB,ECB.ERR)
        IF R.LIQ.ACCOUNT NE '' THEN
*     Y.INTEREST.LIQU.ACCT.BAL = R.LIQ.ACCOUNT<AC.WORKING.BALANCE>
            Y.INTEREST.LIQU.ACCT.BAL = R.ECB<ECB.WORKING.BALANCE>
*      Tus End
        END
        Y.CURRENT.AMOUNT = Y.PRINCIPAL + Y.INTEREST.LIQU.ACCT.BAL
    END ELSE
        Y.CURRENT.AMOUNT = Y.PRINCIPAL
    END
    IF Y.CLOSURE.DATE NE '' THEN
        Y.STATUS = 'CLOSED'
    END ELSE
        Y.STATUS = Y.L.AC.STATUS1:'|':Y.L.AC.STATUS2
    END
    GOSUB GET.CUST.NAME
    GOSUB GET.BPS

RETURN
*---------------------------------------------------------------------------------------------------------------------------------
GET.CUST.NAME:
****************

    CALL F.READ(FN.CUSTOMER,Y.CLIENT.CODE,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
    Y.JOINT.CUST.IDS = Y.CLIENT.CODE
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
    END
    IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.SHORT.NAME,LNGG>
        IF Y.CUS.NAMES EQ '' THEN
            Y.CUS.NAMES = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
        END
    END
    Y.RELATION.COUNT = DCOUNT(Y.REL.CODE,@VM)
    Y.COUNT = 1
    LOOP
    WHILE Y.COUNT LE Y.RELATION.COUNT
        RELATION.ID = R.ACCOUNT<AC.RELATION.CODE,Y.COUNT>
        IF RELATION.ID LT 500 OR RELATION.ID GT 529 THEN
            Y.COUNT += 1
            CONTINUE
        END
        CALL F.READ(FN.RELATION,RELATION.ID,R.RELATION,F.RELATION,Y.REL.ERR)
        Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>
        CUSTOMER.ID = R.ACCOUNT<AC.JOINT.HOLDER,Y.COUNT>
        Y.JOINT.CUST.IDS<-1> = CUSTOMER.ID
        CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
        END
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END
        IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME,LNGG>
            IF Y.CUS.NAME EQ '' THEN
                Y.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
            END
        END
        Y.CUS.NAMES := @VM:Y.CUS.NAME
        Y.COUNT += 1

    REPEAT

    Y.ACC.OFF=R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
    Y.CNT = LEN(Y.ACC.OFF)

    IF Y.CNT GT '8' THEN
        Y.CNT1 = Y.CNT-8
        Y.CNT2 = Y.CNT1+1
        Y.BDY.REGION = Y.ACC.OFF[Y.CNT2,2]
    END

    IF Y.CNT LE 8 THEN
        Y.BDY.REGION = Y.ACC.OFF
    END
    Y.INVESTMENT.CUSTOMER.NAME = Y.CUS.NAMES
RETURN

*---------------------------------------------------------------------------------------------------------------------------------
GET.BPS:
**********

    GOSUB NOTIFY.PROC

    LOOP
        REMOVE Y.ALE.ID FROM SEL.LIST.AC.LOC.EVENT SETTING ALE.POS
    WHILE Y.ALE.ID:ALE.POS


        CALL F.READ(FN.AC.LOCKED.EVENTS,Y.ALE.ID,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,Y.ALE.ERR)
*        Y.BLOCK.PLEDGE.TYPE = R.AC.LOCKED.EVENTS<AC.LCK.LOCAL.REF,LOC.L.ALE.STATUS2.POS>
        Y.BLOCK.PLEDGE.TYPE = R.AC.LOCKED.EVENTS<AC.LCK.LOCAL.REF,LOC.L.AC.LOCKE.TYPE.POS>

        Y.ALE.CURR.NO = R.AC.LOCKED.EVENTS<AC.LCK.CURR.NO>

        GOSUB GOSEL

    REPEAT

    IF Y.DATE.VAL AND (NOT(Y.BLOCK.PLEDGE.STARTING.DATE) AND NOT(Y.BLOCK.PLEDGE.RELEASE.DATE) AND NOT(Y.SEIZURE.STARTING.DATE) AND NOT(Y.SEIZURE.RELEASE.DATE) AND NOT(Y.STARTING.DATE) AND NOT(Y.LIFTING.DATE)) ELSE
        GOSUB FINAL.ARRAY
    END


RETURN
*---------------------------------------------------------------------------------------------------------------------------------
NOTIFY.PROC:
*************

*IF Y.AZ.ID EQ "1012021556" THEN DEBUG
    Y.AC.CURR.NO = R.AZ.ACCOUNT<AZ.CURR.NO>
    IF Y.NOTIFICATION.TYPE NE '' THEN
        GOSUB NOTIFY.PROC.START
    END ELSE
        GOSUB NOTIFY.PROC.LIFT
    END
RETURN
*---------------------------------------------------------------------------------------------------------------------------------
NOTIFY.PROC.START:
*******************

    IF Y.AC.CURR.NO EQ '1' THEN
        Y.DATE.TIME = R.ACCOUNT<AC.DATE.TIME>
        Y.INPUTTER = R.ACCOUNT<AC.INPUTTER>
        Y.AUTHORISER = R.ACCOUNT<AC.AUTHORISER>
*
        Y.STARTING.DATE = TODAY[1,2]:Y.DATE.TIME[1,6]
        Y.USER.INPUTS = FIELD(Y.INPUTTER,"_",2)
        Y.USER.AUTHORIZES = FIELD(Y.AUTHORISER,"_",2)
    END ELSE
        Y.CNT = Y.AC.CURR.NO
        LOOP
        WHILE Y.CNT GE '1'
            Y.HIS.ID = Y.AZ.ID:';':Y.CNT
            CALL F.READ(FN.ACCOUNT.HIS,Y.HIS.ID,R.ACCOUNT.HIS,F.ACCOUNT.HIS,Y.ERR.ACHIS)
            CALL F.READ(FN.AZ.ACCOUNT.HIS,Y.HIS.ID,R.AZ.ACCOUNT.HIS,F.AZ.ACCOUNT.HIS,Y.ERR.ACHIS)
            Y.NOTIF =  R.AZ.ACCOUNT.HIS<AZ.LOCAL.REF,LOC.L.AC.NOTIFY.1.POS,1>
            IF Y.NOTIF EQ '' THEN
                Y.CNT.NEW = Y.CNT + 1
                Y.NEW.HIS.ID = Y.AZ.ID:';':Y.CNT.NEW
                CALL F.READ(FN.ACCOUNT.HIS,Y.NEW.HIS.ID,R.ACCOUNT.HIS,F.ACCOUNT.HIS,Y.ERR.ACHIS)
                CALL F.READ(FN.AZ.ACCOUNT.HIS,Y.HIS.ID,R.AZ.ACCOUNT.HIS,F.AZ.ACCOUNT.HIS,Y.ERR.ACHIS)
                GOSUB AC.DET
                Y.STARTING.DATE = Y.S.DATE
            END
            Y.CNT -= 1
        REPEAT
    END
RETURN
*----------------------------------------------------------------------------------------------------------------------------------
NOTIFY.PROC.LIFT:
********************

    IF Y.AC.CURR.NO EQ '1' THEN
        Y.DATE.TIME = R.ACCOUNT<AC.DATE.TIME>
        Y.INPUTTER = R.ACCOUNT<AC.INPUTTER>
        Y.AUTHORISER = R.ACCOUNT<AC.AUTHORISER>
*
*  Y.LIFTING.DATE = TODAY[1,2]:Y.DATE.TIME[1,6]
*  Y.USER.INPUTS = FIELD(Y.INPUTTER,"_",2)
*  Y.USER.AUTHORIZES =  FIELD(Y.AUTHORISER,"_",2)
    END ELSE
        Y.CNT = Y.AC.CURR.NO
        LOOP
        WHILE Y.CNT GE 1
            Y.HIS.ID = Y.AZ.ID:';':Y.CNT
            CALL F.READ(FN.ACCOUNT.HIS,Y.HIS.ID,R.ACCOUNT.HIS,F.ACCOUNT.HIS,Y.ERR.ACHIS)
            CALL F.READ(FN.AZ.ACCOUNT.HIS,Y.HIS.ID,R.AZ.ACCOUNT.HIS,F.AZ.ACCOUNT.HIS,Y.ERR.ACHIS)
            Y.NOTIF = R.AZ.ACCOUNT.HIS<AZ.LOCAL.REF,LOC.L.AC.NOTIFY.1.POS,1>
            IF Y.NOTIF NE '' THEN
                Y.CNT.NEW = Y.CNT + 1
                Y.NEW.HIS.ID = Y.AZ.ID:';':Y.CNT.NEW
                CALL F.READ(FN.ACCOUNT.HIS,Y.NEW.HIS.ID,R.ACCOUNT.HIS,F.ACCOUNT.HIS,Y.ERR.ACHIS)
                CALL F.READ(FN.AZ.ACCOUNT.HIS,Y.HIS.ID,R.AZ.ACCOUNT.HIS,F.AZ.ACCOUNT.HIS,Y.ERR.ACHIS)
                GOSUB AC.DET
                Y.LIFTING.DATE = Y.S.DATE
            END

            Y.CNT -= 1
        REPEAT
    END
RETURN
*----------------------------------------------------------------------------------------------------------------------------------
BLOCK.PLEDGE.PROC:
********************

    IF NOT(Y.BLOCK.PLEDGE.TYPE) THEN
        Y.BLOCK.PLEDGE.STARTING.DATE = ''
        LOOP
        WHILE Y.ALE.CURR.NO GE 1
            ALE.HIS.ID = Y.ALE.ID:';':Y.ALE.CURR.NO
            CALL F.READ(FN.AC.LOCKED.EVENTS.HIS,ALE.HIS.ID,R.AC.LOCKED.EVENTS.HIS,F.AC.LOCKED.EVENTS.HIS,READ.ERR)
            Y.STATUS.TYPE = R.AC.LOCKED.EVENTS.HIS<AC.LCK.LOCAL.REF,LOC.L.ALE.STATUS2.POS>
            IF Y.STATUS.TYPE NE '' THEN
                Y.ALE.CURR.NUM = Y.ALE.CURR.NO + 1
                ALE.HIS.ID = Y.ALE.ID:';':Y.ALE.CURR.NUM
                CALL F.READ(FN.AC.LOCKED.EVENTS.HIS,ALE.HIS.ID,R.AC.LOCKED.EVENTS.HIS,F.AC.LOCKED.EVENTS.HIS,READ.ERR)
                GOSUB SDATE
                Y.BP.RELEASE.DATE = S.DATE
                IF ((Y.DATE.VAL.FROM AND Y.DATE.VAL.TO) AND (Y.BP.RELEASE.DATE GE Y.DATE.VAL.FROM) AND (Y.BP.RELEASE.DATE LE Y.DATE.VAL.TO)) OR NOT(Y.DATE.VAL.FROM) THEN
                    Y.BLOCK.PLEDGE.RELEASE.DATE<1,-1> = Y.BP.RELEASE.DATE
                    Y.BLOCK.PLEDGE.TYPE.ARRAY<1,-1> = Y.BLOCK.PLEDGE.TYPE
                    BREAK
                END
            END
            Y.ALE.CURR.NO -= 1
        REPEAT
    END ELSE

        LOOP
        WHILE Y.ALE.CURR.NO GE 1
            ALE.HIS.ID = Y.ALE.ID:';':Y.ALE.CURR.NO
            CALL F.READ(FN.AC.LOCKED.EVENTS.HIS,ALE.HIS.ID,R.AC.LOCKED.EVENTS.HIS,F.AC.LOCKED.EVENTS.HIS,READ.ERR)
            Y.STATUS.TYPE = R.AC.LOCKED.EVENTS.HIS<AC.LCK.LOCAL.REF,LOC.L.ALE.STATUS2.POS>
            IF Y.STATUS.TYPE NE Y.BLOCK.PLEDGE.TYPE THEN
                Y.ALE.CURR.NUM = Y.ALE.CURR.NO + 1
                ALE.HIS.ID = Y.ALE.ID:';':Y.ALE.CURR.NUM
                CALL F.READ(FN.AC.LOCKED.EVENTS.HIS,ALE.HIS.ID,R.AC.LOCKED.EVENTS.HIS,F.AC.LOCKED.EVENTS.HIS,READ.ERR)
                GOSUB SDATE
                Y.BP.STARTING.DATE = S.DATE
                IF ((Y.DATE.VAL.FROM AND Y.DATE.VAL.TO) AND (Y.BP.STARTING.DATE GE Y.DATE.VAL.FROM) AND (Y.BP.STARTING.DATE LE Y.DATE.VAL.TO)) OR NOT(Y.DATE.VAL.FROM) THEN
                    Y.BLOCK.PLEDGE.STARTING.DATE<1,-1> = Y.BP.STARTING.DATE
                    Y.BLOCK.PLEDGE.TYPE.ARRAY<1,-1> = Y.BLOCK.PLEDGE.TYPE
                    BREAK
                END
            END
            Y.ALE.CURR.NO -= 1
        REPEAT
        Y.BLOCK.PLEDGE.RELEASE.DATE = ''
    END
    IF Y.STATUS.TYPE EQ 'GARNISHMENT' THEN
        Y.SEIZURE.RELEASE.DATE<1,-1> = Y.BLOCK.PLEDGE.RELEASE.DATE
        Y.SEIZURE.STARTING.DATE = ''
        Y.BLOCK.PLEDGE.RELEASE.DATE = ''
    END
    IF Y.BLOCK.PLEDGE.RELEASE.DATE OR Y.BLOCK.PLEDGE.STARTING.DATE AND Y.STATUS.TYPE NE 'GARNISHMENT' THEN
        Y.BLOCK.PLEDGE.AMOUNT<1,-1> = S.AMT
        Y.BLOCK.PLEDGE.USER.INPUTS<1,-1> = S.INPUT
        Y.BLOCK.PLEDGE.USER.AUTHORIZES<1,-1> = S.AUTH
    END
    IF Y.SEIZURE.RELEASE.DATE OR Y.SEIZURE.STARTING.DATE THEN
        Y.SEIZURE.USER.INPUTS<1,-1> = S.INPUT
        Y.SEIZURE.AUTHORIZES<1,-1> = S.AUTH
    END
RETURN
*----------------------------------------------------------------------------------------------------------------------------------
SEIZURE.PROC:
***************

    LOOP
    WHILE Y.ALE.CURR.NO GE 1

        ALE.HIS.ID = Y.ALE.ID:';':Y.ALE.CURR.NO
        CALL F.READ(FN.AC.LOCKED.EVENTS.HIS,ALE.HIS.ID,R.AC.LOCKED.EVENTS.HIS,F.AC.LOCKED.EVENTS.HIS,READ.ERR)
        Y.STATUS.TYPE = R.AC.LOCKED.EVENTS.HIS<AC.LCK.LOCAL.REF,LOC.L.ALE.STATUS2.POS>
        Y.GARNISH.ID = R.AC.LOCKED.EVENTS<AC.LCK.LOCAL.REF, Y.GARNISH.ID.POS>


        IF Y.STATUS.TYPE NE 'GARNISHMENT' THEN
            Y.ALE.CURR.NUM = Y.ALE.CURR.NO + 1
            ALE.HIS.ID = Y.ALE.ID:';':Y.ALE.CURR.NUM

            Y.READ.ERR = ''
            R.GARNISH.REC = ''
            CALL F.READ(FN.APAP.H.GARNISH.DETAILS, Y.GARNISH.ID, R.GARNISH.DETAILS, F.APAP.H.GARNISH.DETAILS, Y.READ.ERR)

            Y.GARNISH.BENEF<1,-1> = R.GARNISH.DETAILS<APAP.GAR.NAME.CREDITOR>

            CALL F.READ(FN.AC.LOCKED.EVENTS.HIS,ALE.HIS.ID,R.AC.LOCKED.EVENTS.HIS,F.AC.LOCKED.EVENTS.HIS,READ.ERR)
            GOSUB SDATE
            Y.S.STARTING.DATE = S.DATE
            IF ((Y.DATE.VAL.FROM AND Y.DATE.VAL.TO) AND (Y.S.STARTING.DATE GE Y.DATE.VAL.FROM) AND (Y.S.STARTING.DATE LE Y.DATE.VAL.TO)) OR NOT(Y.DATE.VAL.FROM) THEN
                Y.SEIZURE.STARTING.DATE<1,-1> = Y.S.STARTING.DATE
                Y.SEIZURE.TYPE.ARRAY<1,-1> = Y.SEIZURE.TYPE
                BREAK
            END
        END
        Y.ALE.CURR.NO -= 1
    REPEAT
    Y.SEIZURE.RELEASE.DATE = ''

    IF Y.SEIZURE.STARTING.DATE THEN
        Y.SEIZURE.AMOUNT<1,-1> = S.AMT
    END
    IF Y.SEIZURE.RELEASE.DATE OR Y.SEIZURE.STARTING.DATE THEN
        Y.SEIZURE.USER.INPUTS<1,-1> = S.INPUT
        Y.SEIZURE.AUTHORIZES<1,-1> = S.AUTH
    END
RETURN
*----------------------------------------------------------------------------------------------------------------------------------
FINAL.ARRAY:
***************

    CHANGE @VM TO '; ' IN Y.INVESTMENT.CUSTOMER.NAME
    Y.JOINT.CUST.IDS = CHANGE(Y.JOINT.CUST.IDS, @FM, '; ')

*   Y.VM.COUNT.CUS.NAME = DCOUNT(Y.INVESTMENT.CUSTOMER.NAME,VM)
*   Y.TEMP.CLIENT.CODE = Y.CLIENT.CODE
*   Y.CLIENT.CODE = ''
*   Z = '1'
*   LOOP
*   WHILE Z LE Y.VM.COUNT.CUS.NAME
*       Y.CLIENT.CODE<-1> = Y.TEMP.CLIENT.CODE
*       Z++
*   REPEAT
*   CHANGE FM TO VM IN Y.CLIENT.CODE


    BPS.ARRAY := @FM:Y.INVESTMENT.TYPE.VAL:'*':Y.CURRENCY:'*':Y.AGENCY:'*':Y.ACCOUNT.EXECUTIVE:'*':Y.BDY.REGION:'*':Y.INVESTMENT.TYPE.DESC:'*':Y.CURRENCY:'*':Y.PREV.INVESTMENT.NUMBER:'*':Y.INVESTMENT.NUMBER
    BPS.ARRAY := '*':Y.INVESTMENT.CUSTOMER.NAME:'*':Y.JOINT.CUST.IDS:'*':Y.INVESTMENT.AMOUNT:'*':Y.CURRENT.AMOUNT:'*':Y.STATUS:'*':Y.NOTIFICATION.TYPE
    BPS.ARRAY := '*':Y.STARTING.DATE:'*':Y.LIFTING.DATE:'*':Y.USER.INPUTS:'*':Y.USER.AUTHORIZES:'*':Y.BLOCK.PLEDGE.TYPE:'*':Y.BLOCK.PLEDGE.STARTING.DATE
    BPS.ARRAY := '*':Y.BLOCK.PLEDGE.AMOUNT:'*':Y.BLOCK.PLEDGE.RELEASE.DATE:'*':Y.BLOCK.PLEDGE.USER.INPUTS:'*':Y.BLOCK.PLEDGE.USER.AUTHORIZES
    BPS.ARRAY := '*':Y.SEIZURE.TYPE:'*':Y.SEIZURE.STARTING.DATE:'*':Y.SEIZURE.AMOUNT:'*':Y.SEIZURE.RELEASE.DATE:'*':Y.SEIZURE.USER.INPUTS:'*':Y.SEIZURE.AUTHORIZES:'*':Y.GARNISH.BENEF:'*':Y.CLASSIFICATION

RETURN
*---------------------------------------------------------------------------------------------------------------------------------
GOSEL:
*-------------

    IF Y.TYPE.OF.STATUS.VAL NE '' AND Y.TYPE.OF.STATUS.VAL EQ Y.BLOCK.PLEDGE.TYPE THEN
        IF Y.TYPE.OF.STATUS.VAL NE 'GARNISHMENT' THEN
            GOSUB BLOCK.PLEDGE.PROC
        END ELSE
            Y.SEIZURE.TYPE = Y.BLOCK.PLEDGE.TYPE
            GOSUB SEIZURE.PROC
            Y.BLOCK.PLEDGE.TYPE = ''
        END
    END
    IF Y.TYPE.OF.STATUS.VAL EQ '' THEN
        IF Y.BLOCK.PLEDGE.TYPE NE 'GARNISHMENT' THEN
            GOSUB BLOCK.PLEDGE.PROC
        END ELSE
            Y.SEIZURE.TYPE = Y.BLOCK.PLEDGE.TYPE
            GOSUB SEIZURE.PROC
            Y.BLOCK.PLEDGE.TYPE = ''
        END
    END
RETURN
*--------
SDATE:
*--------
    IF R.AC.LOCKED.EVENTS.HIS THEN
        S.AMT = R.AC.LOCKED.EVENTS.HIS<AC.LCK.LOCKED.AMOUNT>
*        S.DATE = TODAY[1,2]:R.AC.LOCKED.EVENTS.HIS<AC.LCK.DATE.TIME>[1,6]
        S.DATE = R.AC.LOCKED.EVENTS.HIS<AC.LCK.FROM.DATE>
        S.INPUT = FIELD(R.AC.LOCKED.EVENTS.HIS<AC.LCK.INPUTTER>,'_',2)
        S.AUTH = FIELD(R.AC.LOCKED.EVENTS.HIS<AC.LCK.AUTHORISER>,'_',2)
    END ELSE
        S.AMT = R.AC.LOCKED.EVENTS<AC.LCK.LOCKED.AMOUNT>
*        S.DATE = TODAY[1,2]:R.AC.LOCKED.EVENTS<AC.LCK.DATE.TIME>[1,6]
        S.DATE = R.AC.LOCKED.EVENTS<AC.LCK.FROM.DATE>
        S.INPUT = FIELD(R.AC.LOCKED.EVENTS<AC.LCK.INPUTTER>,'_',2)
        S.AUTH = FIELD(R.AC.LOCKED.EVENTS<AC.LCK.AUTHORISER>,'_',2)
    END
RETURN
*-----------
AC.DET:
*-------------
    IF R.AZ.ACCOUNT.HIS THEN
        Y.DATE.TIME = R.AZ.ACCOUNT.HIS<AZ.DATE.TIME>
        Y.INPUTTER = R.AZ.ACCOUNT.HIS<AZ.INPUTTER>
        Y.AUTHORISER = R.AZ.ACCOUNT.HIS<AZ.AUTHORISER>

        Y.S.DATE = TODAY[1,2]:Y.DATE.TIME[1,6]
        Y.USER.INPUTS = FIELD(Y.INPUTTER,"_",2)
        Y.USER.AUTHORIZES =  FIELD(Y.AUTHORISER,"_",2)
        Y.CNT = 0
    END ELSE
        Y.DATE.TIME = R.AZ.ACCOUNT<AZ.DATE.TIME>
        Y.INPUTTER = R.AZ.ACCOUNT<AZ.INPUTTER>
        Y.AUTHORISER = R.AZ.ACCOUNT<AZ.AUTHORISER>

        Y.S.DATE = TODAY[1,2]:Y.DATE.TIME[1,6]
        Y.USER.INPUTS = FIELD(Y.INPUTTER,"_",2)
        Y.USER.AUTHORIZES =  FIELD(Y.AUTHORISER,"_",2)
        Y.CNT = 0
    END
RETURN
*----------------------
GOEND:
***********
END