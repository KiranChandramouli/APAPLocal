SUBROUTINE REDO.E.NOF.INVESTMENT.CHANGES.REPORT(Y.ENQ.DATA)
*-------------------------------------------------------------------------------------------------------
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : G.Sabari
*  ODR Number        : ODR-2010-03-0101
*  Program   Name    : REDO.E.NOF.INVESTMENT.CHANGES.REPORT
*-------------------------------------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------------------------------------------------------------------------------
* In  : --N/A--
* Out : Y.ENQ.DATA
*-------------------------------------------------------------------------------------------------------
* DESCRIPTION       : This is a NOFILE routine for the enquiry to show all the
*                     maintenance/changes processed to an investment account
*-------------------------------------------------------------------------------------------------------
* Modification History :
*-------------------------------------------------------------------------------------------------------
*  DATE            WHO                   REFERENCE            DESCRIPTION
*  -----           ----                  ----------           -----------
*  20-Oct-2010     G.Sabari              ODR-2010-03-0101     INITIAL CREATION
*  23-Oct-2010     Sakthi Sellappillai   ODR-2010-03-0101     Changes done for raised issues
*  24-FEB-2012     Shekar    Performance tuning
*                (1) record id of az.account cannot be null, removed from selection criteria
*                (2) hdr.details is called for each entry, moved the code up
*                (3) avoid calling eb.read.history.rec, just reduce the curr.no and read
*                (4) account record is read twice in para CU.DETAILS and FETCH.DETAILS
*                (5) multi.val.check is called after initialising Y.K to null.
*                     commented the gosub to avoid error being displayed/reported
*                (6) changed f.read to read... tuned for online execution
*                (7) cache read RELATION
*  22-JAN-2013   Shekar Performance
*                do not read customer multiple times
*                [print only the changes and not all details]
*-------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.RELATION
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.STANDARD.SELECTION
    GOSUB INITIALIZE
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-------------------------------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------------------------------
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    FN.AZ.ACCOUNT$HIS = 'F.AZ.ACCOUNT$HIS'
    F.AZ.ACCOUNT$HIS = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
    FN.SS='F.STANDARD.SELECTION'
    F.SS=''
    Y.NEW.VAL = ''
    Y.CURR.VAL = ''
    Y.HIS.CURR.NO = ''
    Y.NAME2 = ''
    Y.ACC.REL.DESC = ''
    Y.SEL.DATE = ''
    Y.SEL.AGENCY = ''
    FLD.NUM = ''

    JsCustIds = ''
    JsCustNames = ''

RETURN
*-------------------------------------------------------------------------------------------------------
OPENFILES:
*-------------------------------------------------------------------------------------------------------
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    CALL OPF(FN.AZ.ACCOUNT$HIS,F.AZ.ACCOUNT$HIS)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.RELATION,F.RELATION)
    CALL OPF(FN.SS,F.SS)
RETURN
*-------------------------------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------------------------------
    Y.APPLN='AZ.ACCOUNT'
    CALL CACHE.READ(FN.SS, Y.APPLN, R.SS, SS.ERR)
    IF R.SS NE '' THEN
        TOT.SYS.FLD.NAME=R.SS<SSL.SYS.FIELD.NAME>
        TOT.SYS.FLD.POS=R.SS<SSL.SYS.FIELD.NO>
        TOT.SYS.FLD.TYPE=R.SS<SSL.SYS.SINGLE.MULT>
        TOT.SYS.FLD.NUM=R.SS<SSL.SYS.FIELD.NO>
        TOT.USR.FLD.NAME=R.SS<SSL.USR.FIELD.NAME>
        TOT.USR.FLD.POS=R.SS<SSL.USR.FIELD.NO>
        TOT.USR.FLD.TYPE=R.SS<SSL.USR.SINGLE.MULT>
    END
    GOSUB SEL.STMT
    GOSUB MAIN.PROCESS
RETURN
*-------------------------------------------------------------------------------------------------------
SEL.STMT:
*-------------------------------------------------------------------------------------------------------
    LOCATE "DATE" IN D.FIELDS<1> SETTING Y.DATE THEN
        Y.SEL.DATE = D.RANGE.AND.VALUE<Y.DATE>
    END
    LOCATE "AGENCY" IN D.FIELDS<1> SETTING Y.AGC THEN
        Y.SEL.AGENCY = D.RANGE.AND.VALUE<Y.AGC>
    END

*Shek... record id cannot be null... removing condition WITH @ID NE ''
    IF Y.SEL.AGENCY NE '' THEN
        SEL.CMD = "SELECT ":FN.AZ.ACCOUNT :" WITH CO.CODE EQ ": Y.SEL.AGENCY
    END ELSE
        SEL.CMD = "SELECT ":FN.AZ.ACCOUNT
    END
RETURN
*-------------------------------------------------------------------------------------------------------
MAIN.PROCESS:
*-------------------------------------------------------------------------------------------------------
    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB HDR.DETAILS
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',Y.COUNT.LIST,Y.ERR)
    LOOP
        REMOVE Y.AZ.ID FROM SEL.LIST SETTING Y.ID.POS
    WHILE Y.AZ.ID:Y.ID.POS
*    READ R.AZ.ACCOUNT FROM F.AZ.ACCOUNT,Y.AZ.ID ELSE ;*Tus Start
        CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,R.AZ.ACCOUNT.ERR)
        IF R.AZ.ACCOUNT.ERR THEN  ;* Tus Start
            R.AZ.ACCOUNT = ''
        END
*-        CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
        GOSUB MAIN.PROCESS.SUB
    REPEAT
RETURN
*------------------
MAIN.PROCESS.SUB:
*-------------------
    IF R.AZ.ACCOUNT THEN
        Y.CURR.NO = R.AZ.ACCOUNT<AZ.CURR.NO>
        Y.DATE.TIME = R.AZ.ACCOUNT<AZ.DATE.TIME>
        Y.DATE = Y.DATE.TIME[1,6]
        Y.DATE1 = Y.DATE.TIME
        Y.YR1 = TODAY
        Y.YR2 = Y.YR1[1,2]
        Y.D = Y.YR2:Y.DATE
        Y.PREV.VAL = ''
        Y.NEW.VAL = ''
        FLD.NUM = ''
        IF Y.SEL.DATE EQ '' OR  Y.D EQ Y.SEL.DATE THEN
            GOSUB FETCH.DETAILS
        END
    END
RETURN
*-------------------------------------------------------------------------------------------------------
FETCH.DETAILS:
*-------------------------------------------------------------------------------------------------------
    Y.AGENCY = (R.AZ.ACCOUNT<AZ.CO.CODE>):(R.AZ.ACCOUNT<AZ.DEPT.CODE>)
    Y.INV.TYPE = R.AZ.ACCOUNT<AZ.CATEGORY>
    Y.INV.NUMBER = Y.AZ.ID
    Y.INV.CLIENT.CODE = R.AZ.ACCOUNT<AZ.CUSTOMER>
    GOSUB CU.DETAILS
*shek moved to main process    GOSUB HDR.DETAILS
    Y.INPUTTER = FIELD(R.AZ.ACCOUNT<AZ.INPUTTER>,'_',2)
    Y.AUTHORISER = FIELD(R.AZ.ACCOUNT<AZ.AUTHORISER>,'_',2)
    Y.OVERRIDE = R.AZ.ACCOUNT<AZ.OVERRIDE>
*CONVERT FM TO VM IN Y.OVERRIDE
    CHANGE @FM TO @VM IN Y.OVERRIDE
*do not read account multiple times... account is read in para CU.DETAILS
*-    CALL F.READ(FN.ACCOUNT,Y.AZ.ID,R.ACC,F.ACCOUNT,ERR.AC)
    R.ACC = R.ACCOUNT ;* assiging R.ACC... account read in para CU.DETAILS
    Y.ACC.EXE = R.ACC<AC.ACCOUNT.OFFICER>
    Y.AZ.HIS.ID = Y.AZ.ID
    R.AZ.ACCOUNT$HIS = ''
    IF Y.CURR.NO GT 1 THEN
        Y.AZ.HIS.ID = Y.AZ.ID :';':Y.CURR.NO-1
*Read Converted by TUS-Convert
*    READ R.AZ.ACCOUNT$HIS FROM F.AZ.ACCOUNT$HIS, Y.AZ.HIS.ID ELSE ;*Tus Start
        CALL F.READ(FN.AZ.ACCOUNT$HIS,Y.AZ.HIS.ID,R.AZ.ACCOUNT$HIS,F.AZ.ACCOUNT$HIS,R.AZ.ACCOUNT$HIS.ERR)
        IF R.AZ.ACCOUNT$HIS.ERR THEN  ;* Tus Start
            R.AZ.ACCOUNT$HIS = ''
        END
    END
*Shek    CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT$HIS,Y.AZ.HIS.ID,R.AZ.ACCOUNT$HIS, Y.AZ.ERR)  ;* do not call eb.read.history.rec
    GOSUB SYS.FLD
    GOSUB FORM.FINAL.ARRAY
RETURN
*-------------------------------------------------------------------------------------------------------
FORM.FINAL.ARRAY:
*-------------------------------------------------------------------------------------------------------
    IF Y.PREV.VAL NE '' AND Y.NEW.VAL NE '' THEN

*Shek -s
* print only the changes.
* compare Y.PREV.VAL and Y.NEW.VAL

        NewTtlCnt = DCOUNT(Y.NEW.VAL, @FM)
        PrevTtlCnt = DCOUNT(Y.PREV.VAL, @FM)
        JsTtlCnt = 0
        IF NewTtlCnt LT PrevTtlCnt THEN
            JsTtlCnt = NewTtlCnt
        END ELSE
            JsTtlCnt = PrevTtlCnt
        END

        Js.PREV.VAL = ''
        Js.NEW.VAL = ''
        yCtr = 0
        FOR xCtr = 1 TO JsTtlCnt
            GOSUB CHECK.REPORT.CHANGES
        NEXT xCtr

        Y.PREV.VAL = Js.PREV.VAL
        Y.NEW.VAL = Js.NEW.VAL

*Shek -e

        CHANGE @FM TO @SM IN Y.PREV.VAL
        CHANGE @FM TO @SM IN Y.NEW.VAL
        CHANGE @VM TO @SM IN Y.INV.CUST.NAME
        CHANGE @VM TO @SM IN Y.OVERRIDE


        Y.ENQ.DATA<-1> = Y.DATE1:"*":Y.AGENCY:"*":Y.INV.TYPE:"*":Y.INV.NUMBER:"*":Y.INV.CUST.NAME:"*":Y.INV.CLIENT.CODE:"*":Y.INV.CLIENT.TYPE:"*"
        Y.ENQ.DATA := Y.ACC.EXE:"*":Y.PREV.VAL:"*":Y.NEW.VAL:"*":Y.INPUTTER:"*":Y.AUTHORISER:"*":Y.OVERRIDE:"*":Y.TIME:"*":Y.CLASSIFICATION
    END
RETURN
*-------------------
CHECK.REPORT.CHANGES:
*-------------------
    IF Y.PREV.VAL<xCtr> EQ Y.NEW.VAL<xCtr> THEN
* do not include in the report
    END ELSE
* report only the changes
        yCtr += 1
        jPrevVal = Y.PREV.VAL<xCtr>
        jNewVal = Y.NEW.VAL<xCtr>
        jPrvCnt = DCOUNT(jPrevVal, @VM)
        jNewCnt = DCOUNT(jNewVal, @VM)
        IF jNewCnt LT jPrvCnt THEN
            jTtl = jNewCnt
        END ELSE
            jTtl = jPrvCnt
        END
        pCtr = 0
        GOSUB CHECK.REPORT.CHANGES.SUB
    END
RETURN
*------------------------
CHECK.REPORT.CHANGES.SUB:
*------------------------
    FOR jCtr = 1 TO jTtl
        IF jPrevVal<1,jCtr> NE jNewVal<1,jCtr> THEN
            pCtr += 1
            Js.PREV.VAL<yCtr,pCtr> = jPrevVal<1,jCtr>
            Js.NEW.VAL<yCtr,pCtr> = jNewVal<1,jCtr>
        END
    NEXT jCtr
RETURN
*-------------------------------------------------------------------------------------------------------
SYS.FLD:
*-------------------------------------------------------------------------------------------------------
    TOT.SYS.FLD.NAME.CNT=DCOUNT(TOT.SYS.FLD.NAME,@VM)
    FOR I.VAR=1 TO TOT.SYS.FLD.NAME.CNT
        FLD.NAME=TOT.SYS.FLD.NAME<1,I.VAR>
        Y.AUDIT.FIELD.ARRAY = ''
        Y.AUDIT.FIELD.ARRAY = 'STMT.NO':@FM:'RECORD.STATUS':@FM:'CURR.NO':@FM:'INPUTTER':@FM:'DATE.TIME':@FM:'AUTHORISER':@FM:'CO.CODE':@FM:'DEPT.CODE':@FM:'AUDITOR.CODE':@FM:'AUDIT.DATE.TIME':@FM:'OVERRIDE'

        LOCATE FLD.NAME IN Y.AUDIT.FIELD.ARRAY SETTING Y.AUDI.FIELD.POS ELSE
            GOSUB FIELDS.CHECK.PROCESS
            GOSUB FIELDS.CHANGE.PROCESS
        END
    NEXT I.VAR
RETURN
*-------------------------------------------------------------------------------------------------------
FIELDS.CHECK.PROCESS:
*-------------------------------------------------------------------------------------------------------
    LOCATE FLD.NAME IN TOT.SYS.FLD.NAME<1,1> SETTING FLD.EXTST ELSE
        FLD.EXTST=''
    END
    IF FLD.NAME EQ 'LOCAL.REF' THEN
        GOSUB LOCAL.FIELD.PROCESS
        FLD.EXTST = ''
    END
    IF FLD.EXTST THEN
        FLD.POS=TOT.SYS.FLD.TYPE<1,FLD.EXTST>
        FLD.NUM=TOT.SYS.FLD.NUM<1,FLD.EXTST,1>
    END
RETURN
*-------------------------------------------------------------------------------------------------------
FIELDS.CHANGE.PROCESS:
*-------------------------------------------------------------------------------------------------------
    IF FLD.NUM NE '' THEN
        IF FLD.POS EQ 'S' THEN
            Y.LAST.REC.VAL = ''
            Y.CURRENT.REC.VAL = ''
            GOSUB FIELDS.CHANGE.PROCESS.SUB
        END ELSE
            Y.K = ''
*Shek  commenting below gosub to avoid error... value of Y.K is initialised to NULL
*--         GOSUB MULTI.VAL.CHECK
        END
    END
RETURN
*----------------------
FIELDS.CHANGE.PROCESS.SUB:
*------------------------
    IF NUM(FLD.NUM) THEN
        Y.LAST.REC.VAL = R.AZ.ACCOUNT$HIS<FLD.NUM>
        Y.CURRENT.REC.VAL =  R.AZ.ACCOUNT<FLD.NUM>
    END ELSE
        Y.LAST.REC.VAL = R.AZ.ACCOUNT$HIS<AZ.LOCAL.REF,Y.K>
        Y.CURRENT.REC.VAL =  R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.K>
    END
    IF Y.LAST.REC.VAL NE Y.CURRENT.REC.VAL THEN
        GOSUB PREV.NEW.SVAL.PROCESS
    END
RETURN
*-------------------------------------------------------------------------------------------------------
PREV.NEW.SVAL.PROCESS:
*-------------------------------------------------------------------------------------------------------
    Y.DATE.FORM.ARRAY = 'VALUE.DATE':@FM:'MATURITY.DATE':@FM:'ORIG.MAT.DATE':@FM:'AMOUNT.V.DATE':@FM:'CREATE.DATE':@FM:'PRIN.EFF.DATE':@FM:'MIN.MAT.DATE':@FM:'ROLLOVER.DATE':@FM:'FINAL.MATURITY'
    LOCATE FLD.NAME IN Y.DATE.FORM.ARRAY SETTING Y.DATE.FORM.POS THEN
        Y.LAST.REC.VAL = ICONV(Y.LAST.REC.VAL, "DI")
        Y.CURRENT.REC.VAL = ICONV(Y.CURRENT.REC.VAL, "DI")
        Y.LAST.REC.VAL = OCONV(Y.LAST.REC.VAL, "D4")
        Y.CURRENT.REC.VAL = OCONV(Y.CURRENT.REC.VAL, "D4")
    END
    IF Y.PREV.VAL NE '' AND Y.NEW.VAL NE '' THEN
        Y.PREV.VAL<-1>= Y.LAST.REC.VAL
        Y.NEW.VAL<-1>= Y.CURRENT.REC.VAL
    END ELSE
        Y.PREV.VAL = Y.LAST.REC.VAL
        Y.NEW.VAL = Y.CURRENT.REC.VAL
    END
RETURN
*-------------------------------------------------------------------------------------------------------
LOCAL.FIELD.PROCESS:
*-------------------------------------------------------------------------------------------------------
    TOT.USR.FLD.NAME.CNT=DCOUNT(TOT.USR.FLD.NAME,@VM)
    FOR Y.K=1 TO TOT.USR.FLD.NAME.CNT
        FLD.NAME=TOT.USR.FLD.NAME<1,Y.K>
        LOCATE FLD.NAME IN TOT.USR.FLD.NAME<1,1> SETTING FLD.EXTST ELSE
            FLD.EXTST=''
        END
        IF FLD.EXTST THEN
            FLD.POS = ''
            FLD.POS=TOT.USR.FLD.TYPE<1,FLD.EXTST>
        END
        IF FLD.POS EQ 'S' THEN
            Y.LAST.REC.VAL = ''
            Y.CURRENT.REC.VAL = ''
            Y.LAST.REC.VAL = R.AZ.ACCOUNT$HIS<AZ.LOCAL.REF,Y.K>
            Y.CURRENT.REC.VAL =  R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.K>
            IF Y.LAST.REC.VAL NE Y.CURRENT.REC.VAL THEN
                GOSUB PREV.NEW.SVAL.PROCESS
            END
        END ELSE
            GOSUB MULTI.VAL.CHECK
        END
    NEXT Y.K
RETURN
*-------------------------------------------------------------------------------------------------------
MULTI.VAL.CHECK:
*-------------------------------------------------------------------------------------------------------
    IF Y.K THEN
        FLD.NUM ='AZ.LOCAL.REF':',':Y.K
    END

    LIVE.AZ.REC=R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.K>
    HIS.AZ.REC=R.AZ.ACCOUNT$HIS<AZ.LOCAL.REF,Y.K>
    MULT.VAL.COUNT=DCOUNT(HIS.AZ.REC,@VM)
    IF FLD.NUM THEN
        Y.LAST.MUL.REC.VAL = ''
        Y.CURRENT.MUL.REC.VAL = ''
        Y.LAST.MUL.REC.VAL = R.AZ.ACCOUNT$HIS<AZ.LOCAL.REF,Y.K>
        Y.CURRENT.MUL.REC.VAL = R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.K>
        IF MULT.VAL.COUNT EQ '1' THEN
            GOSUB MULTI.VAL.CHECK.FIR
        END ELSE
            Y.J=1
            LOOP
            WHILE Y.J LE MULT.VAL.COUNT
                GOSUB MULTI.VAL.CHECK.SEC
            REPEAT
        END
    END
RETURN
*--------------------
MULTI.VAL.CHECK.FIR:
*---------------------
    IF Y.LAST.MUL.REC.VAL NE Y.CURRENT.MUL.REC.VAL THEN
        IF Y.PREV.VAL NE '' AND Y.NEW.VAL NE '' THEN
            Y.PREV.VAL<-1>= Y.LAST.MUL.REC.VAL
            Y.NEW.VAL<-1>= Y.CURRENT.MUL.REC.VAL
        END ELSE
            Y.PREV.VAL = Y.LAST.MUL.REC.VAL
            Y.NEW.VAL = Y.CURRENT.MUL.REC.VAL
        END
    END
RETURN
*------------------
MULTI.VAL.CHECK.SEC:
*------------------
    IF Y.LAST.MUL.REC.VAL NE Y.CURRENT.MUL.REC.VAL THEN
        IF Y.PREV.VAL NE '' AND Y.NEW.VAL NE '' THEN
            Y.PREV.VAL<-1>= Y.LAST.MUL.REC.VAL<Y.J>
            Y.NEW.VAL<-1>= Y.CURRENT.MUL.REC.VAL<Y.J>
        END ELSE
            Y.PREV.VAL = Y.LAST.MUL.REC.VAL<Y.J>
            Y.NEW.VAL = Y.CURRENT.MUL.REC.VAL<Y.J>
        END
    END
    Y.J += 1
RETURN

GET.CUSTOMER.NAME:
*-----------------
* Get customer name
    CusName = ''
    jPos = ''
    LOCATE CUSTOMER.ID IN JsCustIds<1> SETTING jPos THEN      ;* locate customer id in the array
        CusName = JsCustNames<jPos>         ;* found, return the name
    END ELSE          ;* else read customer

*Read Converted by TUS-Convert
*    READ R.CUSTOMER FROM F.CUSTOMER, CUSTOMER.ID ELSE ;*Tus Start
        CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,R.CUSTOMER.ERR)
        IF R.CUSTOMER.ERR THEN  ;* Tus Start
            R.CUSTOMER = ''
        END
        Y.INV.CLIENT.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>
        BEGIN CASE

            CASE R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR"
                CusName = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>

            CASE R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA"
                CusName = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>

            CASE NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>)
                CusName = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
        END CASE
* save the details in array, for reuse
        JsCustIds<-1> = CUSTOMER.ID
        JsCustNames<-1> = CusName
    END
RETURN
*-------------------------------------------------------------------------------------------------------
CU.DETAILS:
*-------------------------------------------------------------------------------------------------------
    LOC.L.CU.TIPO.CL.POS = L.CU.TIPO.CL.POS
    Y.ACCOUNT.ID = Y.AZ.ID
    Y.ACC.NAMES = ''
    Y.CUS.NAMES = ''
*  READ R.ACCOUNT FROM F.ACCOUNT, Y.ACCOUNT.ID ELSE ;*Tus Start
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,R.ACCOUNT.ERR)
    IF R.ACCOUNT.ERR THEN  ;* Tus Start
        R.ACCOUNT = ''
    END
*-    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,Y.ACCOUNT.ERR)
    CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>

    GOSUB GET.CUSTOMER.NAME     ;*Shek
    Y.CUS.NAMES = CusName       ;*Shek

    GOSUB CUS.REL.DET.PROCESS
RETURN
*-------------------------------------------------------------------------------------------------------
CUS.REL.DET.PROCESS:
*-------------------------------------------------------------------------------------------------------
    Y.RELATION.COUNT = DCOUNT(R.ACCOUNT<AC.RELATION.CODE>,@VM)
    Y.COUNT = 1
    IF Y.RELATION.COUNT THEN
        LOOP
        WHILE Y.COUNT LE Y.RELATION.COUNT
            RELATION.ID = R.ACCOUNT<AC.RELATION.CODE,Y.COUNT>
            IF RELATION.ID LT 500 OR RELATION.ID GT 529 THEN
                Y.COUNT += 1
                CONTINUE
            END

            GOSUB CUS.REL.DET.PROCESS.SUB
            Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>
            CUSTOMER.ID = R.ACCOUNT<AC.JOINT.HOLDER,Y.COUNT>
*      READ R.CUSTOMER FROM F.CUSTOMER, CUSTOMER.ID ELSE ;*Tus Start
            CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,R.CUSTOMER.ERR)
            IF R.CUSTOMER.ERR THEN  ;* Tus Start
                R.CUSTOMER=''
            END
*-            CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ER)
            GOSUB GET.CUSTOMER.NAME ;* Shek
            Y.CUS.NAME = CusName    ;*Shek
            Y.ACC.NAMES<-1>= Y.CUS.NAMES:'-':Y.REL.DESC:'-':Y.CUS.NAME
            Y.COUNT += 1
        REPEAT
    END
    GOSUB FORM.REL.DESC.PROCESS
RETURN
*----------------------
CUS.REL.DET.PROCESS.SUB:
*-----------------------
    CALL CACHE.READ(FN.RELATION,RELATION.ID,R.RELATION,RELATION.ER)
RETURN
*-------------------------------------------------------------------------------------------------------
FORM.REL.DESC.PROCESS:
*-------------------------------------------------------------------------------------------------------
    IF Y.ACC.NAMES THEN
        CHANGE @FM TO @VM IN Y.ACC.NAMES
        Y.INV.CUST.NAME = Y.ACC.NAMES
        RETURN
    END
    IF NOT(Y.ACC.NAMES) THEN
        CHANGE @FM TO @VM IN Y.CUS.NAMES
        Y.INV.CUST.NAME = Y.CUS.NAMES
        RETURN
    END
RETURN
*-------------------------------------------------------------------------------------------------------
HDR.DETAILS:
*-------------------------------------------------------------------------------------------------------
    Y.TIME = OCONV(TIME(), "MTS")
    TEMP.RANGE.AND.VALUE = D.RANGE.AND.VALUE
    CHANGE @FM TO ',' IN TEMP.RANGE.AND.VALUE
    Y.CLASSIFICATION = TEMP.RANGE.AND.VALUE
    IF TEMP.RANGE.AND.VALUE  EQ '' THEN
        Y.CLASSIFICATION = 'ALL'
    END
RETURN
*-------------------------------------------------------------------------------------------------------
FIND.MULTI.LOCAL.REF:
*-------------------------------------------------------------------------------------------------------
    APPL.ARRAY = 'CUSTOMER'
    FLD.ARRAY = 'L.CU.TIPO.CL'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    L.CU.TIPO.CL.POS = FLD.POS<1,1>
RETURN
*-----
END
*---------------------------------------------*END OF SUBROUTINE*---------------------------------------
