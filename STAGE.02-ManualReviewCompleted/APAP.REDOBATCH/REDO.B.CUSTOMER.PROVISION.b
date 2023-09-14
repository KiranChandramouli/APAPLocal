* @ValidationCode : MjotMTE1NDE4NzU3MDpDcDEyNTI6MTY4MTE4OTMzNDMxNDpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 10:32:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CUSTOMER.PROVISION(Y.CUS.ID)
******************************************************************************
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : G.Bharath
*  ODR Number        : ODR-2009-11-0159
*  Program   Name    : REDO.B.CUSTOMER.PROVISION
*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : Y.CUS.ID
* Out : --N/A--
*-----------------------------------------------------------------------------
* DESCRIPTION       : This Multi-thread BATCH routine is to calculate CUSTOMER provision
*                     values based on the arrangements with the CUSTOMER during COB
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO         REFERENCE            DESCRIPTION
*------------------------------------------------------------------------------
*  22-Oct-2010     G.Bharath   ODR-2009-11-0159     INITIAL CREATION
* 28-APR-2011      H GANESH           CR009              Change the Vetting value of local field
* 07-JULY-2011     JEEVA T      PACS00064596          changes in claculating overdue days
* 03-Feb-2012      JEEVA T      SP interest removed
* Date                   who                   Reference              
* 11-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND FM TO @FM AND SM TO @SM AND ++ TO += 1 AND T.NO TO C$T24.SESSION.NO
* 11-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.USER
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.LIMIT
    $INSERT I_F.COLLATERAL
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.REDO.H.CUSTOMER.PROVISIONING
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
    $INSERT I_REDO.B.CUSTOMER.PROVISION.COMMON
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    $INSERT I_F.DATES


    CALL OCOMO("Processing started for the customer - ":Y.CUS.ID)

*------------------------------------------------------------------------------

    GOSUB INITIALIZATION

    GOSUB MAIN.PROCESS
    CALL OCOMO("Processing ended for the customer - ":Y.CUS.ID)

RETURN
*------------------------------------------------------------------------------
INITIALIZATION:
*------------------------------------------------------------------------------
    Y.MORTGAGE.ARR = ''       ; Y.CONSUMER.ARR    = '' ; Y.COMMERCIAL.ARR = '' ; Y.PRODUCT.GROUP.LIST = ''
    Y.LIST.ARR = ''           ; Y.PROVISION.ARRAY = '' ; DATES.JD.ARRAY   = '' ; Y.DATES.JD           = ''
    Y.OVERDUE.DAYS.ARRAY = '' ; SEL.LIST.ARR      = '' ; ARR.INFO         = '' ; Y.TOTAL.OVERDUE.DAYS = ''
    Y.LOAN.COND = ''          ; NEW.CALC.CLASS    = '' ; CLASS.ARRAY.NUM  = '' ; Y.LOAN.STATUS.1      = ''
    REQUEST.TYPE = ''         ; END.DATE          = '' ; START.DATE       = '' ; Y.AMT                = 0 ;
    Y.PROV.PRINCIPLE = ''     ; Y.PROV.INETREST   = '' ; Y.CURRENT.CLASS  = '' ; Y.CUR.NUMBER         = ''
    CONS.TYPE.FLAG = ''       ; MORT.TYPE.FLAG    = '' ; COM.TYPE.FLAG    = '' ; LN.CLASS.ARRAY       = ''
    Y.WROST.OVERDUE = ''      ; Y.TOTAL.CUS.PROV.CAL = ''; Y.ACT.DATE  = ' '
    Y.INT.FACTOR = ''
RETURN
*------------------------------------------------------------------------------
MAIN.PROCESS:
*------------------------------------------------------------------------------
    GOSUB GET.REDO.H.PROVISION.PARAMETER.VALUES

    GOSUB READ.REDO.H.CUSTOMER.PROVISIONING

    GOSUB GROUPING.LOANS.BASED.ON.PRODUCT.GROUP

    IF SEL.LIST.ARR EQ '' THEN
        RETURN      ;*>>>>>>>>>>>>>>>>>>>>>>>>> changes done by jeeva<<<<<<<<<<<<<<<<<<<<<<<<<<<
    END

    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------
GROUPING.LOANS.BASED.ON.PRODUCT.GROUP:
*-------------------------------------------------------------------------------

*        CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.CUS.ACC.ID,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,FN.CUSTOMER.ACCOUNT.ERR)
    CALL F.READ(FN.REDO.CUSTOMER.ARRANGEMENT,Y.CUS.ID,R.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT,Y.CUS.ERR)

    SEL.LIST.ARR = R.REDO.CUSTOMER.ARRANGEMENT<CUS.ARR.OWNER>
    CHANGE @VM TO @FM IN SEL.LIST.ARR

*<<<<<<<< To Group Loans based on LOAN.TYPE based on AA.PRODUCT.GROUP >>>>>>>>>>
    IF SEL.LIST.ARR EQ '' THEN
        RETURN
    END

    SEL.LIST.AA = ''
    Y.COMMERCIAL = 0

    SEL.LIST.AA = SEL.LIST.ARR
    LOOP
        REMOVE Y.AA.ID FROM SEL.LIST.AA SETTING AA.POS
    WHILE Y.AA.ID:AA.POS
        CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERRR)
        Y.CURRENCY = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
        Y.LOAN.AA.TYPE = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
        GOSUB GROUP.LOANS
        IF LN.TYPE EQ 'COMMERCIAL' THEN
            GOSUB TO.FIND.TOTAL.COMMERCIAL.AMT
        END
    REPEAT

RETURN
*-------------------------------------------------------------------------------
TO.FIND.TOTAL.COMMERCIAL.AMT:
*-------------------------------------------------------------------------------

    Y.IDS.DETAILS = Y.AA.ID:@FM:'YES'
    CALL REDO.GET.DISBURSEMENT.DETAILS(Y.IDS.DETAILS,R.DISB.DETAILS,Y.COMMITED.AMT,Y.PEND.DISB)     ;* Get the disb amount.
    Y.COMMERCIAL += R.DISB.DETAILS<3>

RETURN
*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    LN.TYPE.FLAG = ''
    Y.LIST.ARR = Y.COMMERCIAL.ARR
    IF Y.LIST.ARR NE '' THEN
        LN.TYPE.FLAG = 'COMMERCIAL'
        GOSUB SUB.PROCESS.CLASSIFICATION
    END

    Y.LIST.ARR = Y.CONSUMER.ARR
    IF Y.LIST.ARR NE '' THEN
        LN.TYPE.FLAG = 'CONSUMER'
        GOSUB SUB.PROCESS.CLASSIFICATION
    END

    Y.LIST.ARR = Y.MORTGAGE.ARR
    IF Y.LIST.ARR NE '' THEN
        LN.TYPE.FLAG = 'MORTGAGE'
        GOSUB SUB.PROCESS.CLASSIFICATION
    END

    GOSUB SUB.PROCESS.PROVISIONING.CLASSIFICATION

    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUST.ERR)
    IF R.CUSTOMER THEN
        Y.CUSTOMER.RATING = R.CUSTOMER<EB.CUS.CUSTOMER.RATING>
    END


    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROCESS.DATE>     = TODAY
    CALL EB.ROUND.AMOUNT(Y.CURRENCY,Y.COMMERCIAL,"","")
    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.TOTAL.COMMERCIAL> = Y.COMMERCIAL
    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PREV.CUST.RATING> = R.REDO.H.CUSTOMER.PROVISIONING.HIS<REDO.CUS.PROV.CURR.CUST.RATING>
    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.CURR.CUST.RATING> = Y.CUSTOMER.RATING

    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME = TEMPTIME[1,5]
    CHANGE ':' TO '' IN TEMPTIME
    CHECK.DATE = DATE()

    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.DATE.TIME>=OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):OCONV(CHECK.DATE,"DD"):TEMPTIME
    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.INPUTTER>=C$T24.SESSION.NO:'_':OPERATOR  ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.AUTHORISER>=C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.CO.CODE>=ID.COMPANY
    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.DEPT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.RECORD.STATUS>=''


    GOSUB WRITE.CUSTOMER.PROVISIONING

RETURN
*-------------------------------------------------------------------------------
SUB.PROCESS.CLASSIFICATION:
*-------------------------------------------------------------------------------

    LOOP
        REMOVE Y.AA.ID FROM Y.LIST.ARR SETTING ARR.POS
    WHILE Y.AA.ID:ARR.POS
        CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERRR)

*<<< If the TOTAL loan amount of all the ARRANGEMENTs of a CUSTOMER doesn't >>>>
*<<<<<< exceeds COMM.MAJOR.AMOUNT defined in the parameter, proceed with >>>>>>>
*<<<<<<<<<<< proceed with classification steps for COMMERCIAL Loans.>>>>>>>>>>>>

        IF LN.TYPE.FLAG EQ 'COMMERCIAL' THEN
            IF Y.COMMERCIAL LT Y.COMM.MAJOR.AMOUNT THEN
                GOSUB CLASSIFICATION.CALCULATION
            END
        END ELSE
            GOSUB CLASSIFICATION.CALCULATION
        END
    REPEAT

RETURN
*-------------------------------------------------------------------------------
SUB.PROCESS.PROVISIONING.CLASSIFICATION:
*-------------------------------------------------------------------------------

    LOOP
        REMOVE Y.PROV.ID FROM Y.PROVISION.ARRAY SETTING PROV.POS
    WHILE Y.PROV.ID:PROV.POS
        CALL OCOMO("Provisioning Calculation Begins -":Y.PROV.ID)
        GOSUB SUB.PROCESS.PROVISIONING.CLASSIFICATION.1
        IF Y.LOAN.STATUS.1 EQ "Write-off" THEN
            CONTINUE
        END
        GOSUB SUB.PROCESS.PROVISIONING.CLASSIFICATION.2
        CALL OCOMO("Provisioning Calculation Ends -":Y.PROV.ID)

    REPEAT

RETURN
*-------------------------------------------------------------------------------
SUB.PROCESS.PROVISIONING.CLASSIFICATION.1:
*-------------------------------------------------------------------------------

    Y.AA.ID       = FIELD(Y.PROV.ID,"*",2)
    LN.TYPE.FLAG  = FIELD(Y.PROV.ID,"*",1)
    Y.OVERDUE.DAY = FIELD(Y.PROV.ID,"*",3)

    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERRR)

    GOSUB LOCATE.LOAN.TYPE.AND.GET.VALUES

    LOCATE Y.WORST.CLASS IN Z.CLASSIFICATION SETTING CLASS.POS THEN
        SECUR.CLASS   = Z.SECUR.CLASSI<CLASS.POS>
        UNSECUR.CLASS = Z.UNSECUR.CLASSI<CLASS.POS>
        Y.FACTOR      = Z.PERCENTAGE<CLASS.POS> * 0.01
    END
    LOCATE UNSECUR.CLASS IN Z.CLASSIFICATION SETTING UN.SEC.CLASS.POS THEN
        Y.UNSECUR.FACTOR  = Z.PERCENTAGE<UN.SEC.CLASS.POS> * 0.01
    END
    LOCATE SECUR.CLASS IN Z.CLASSIFICATION SETTING SEC.CLASS.POS THEN
        Y.SECUR.FACTOR  = Z.PERCENTAGE<SEC.CLASS.POS> * 0.01
    END
    CALL OCOMO("Provisioning Factors:":"[":Y.WORST.CLASS:"] ":"[":Y.FACTOR:"] ":"[":Y.SECUR.FACTOR:"] ":"[":Y.UNSECUR.FACTOR:"]")
    idPropertyClass = "OVERDUE"
    GOSUB GET.ARR.CONDITION
    Y.OVERDUE.CONDITION = R.CONDITION
    Y.AGING.BALANCE.TYPES = R.CONDITION<AA.OD.OVERDUE.STATUS>
    CHANGE @VM TO @FM IN Y.AGING.BALANCE.TYPES
    IF R.CONDITION THEN
        Y.LOAN.STATUS.1 = R.CONDITION<AA.OD.LOCAL.REF><1,Y.LOAN.STATUS.1.POS>
    END
RETURN
*-------------------------------------------------------------------------------
SUB.PROCESS.PROVISIONING.CLASSIFICATION.2:
*-------------------------------------------------------------------------------

    IF Y.OVERDUE.DAY GT Y.DAYS.OVERDUE THEN       ;*   Factor Value is "100"
        Y.INT.FACTOR = 1
    END

    IF NOT(Y.INT.FACTOR) THEN
        Y.INT.FACTOR = Y.FACTOR
    END
    IF LN.TYPE.FLAG EQ 'COMMERCIAL' THEN
        GOSUB COMMERCIAL.PROCESS
    END
    IF LN.TYPE.FLAG NE 'COMMERCIAL' THEN
        GOSUB NON.COMMERCIAL.PROCESS
    END


    CALL EB.ROUND.AMOUNT(Y.CURRENCY,Y.PROV.PRINCIPLE,"","")
    CALL EB.ROUND.AMOUNT(Y.CURRENCY,Y.PROV.INETREST,"","")
    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.PRINC,-1>    = Y.PROV.PRINCIPLE
    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.INTEREST,-1> = Y.PROV.INETREST

    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.DAYS.JC,-1>       = Y.DATES.JD

*<<<<<<<<<<< To Get PROV.RESTRUCT from AA.ARR.ACCOUNT >>>>>>>>>>>>>
    idPropertyClass = "ACCOUNT"
    GOSUB GET.ARR.CONDITION
    IF R.CONDITION THEN
        Y.PROV.RESTRUCT = R.CONDITION<AA.AC.LOCAL.REF><1,Y.PROV.RESTRUCT.POS>
    END
    IF Y.PROV.RESTRUCT EQ '' THEN
        Y.PROV.RESTRUCT = 0
    END
    CALL EB.ROUND.AMOUNT(Y.CURRENCY,Y.PROV.RESTRUCT,"","")
    GOSUB GET.FX.PROVISION
    CALL EB.ROUND.AMOUNT(Y.CURRENCY,Y.PROV.FX,"","")
    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.FX,-1>       = Y.PROV.FX
    Y.TOTAL.PROV.FX = 0
    LOCATE Y.AA.ID IN R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.ARRANGEMENT.ID,1> SETTING ARR.FX.POS THEN
        Y.TOTAL.PROV.FX = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.TOTAL.PROV.FX,ARR.FX.POS> + Y.PROV.FX
        CALL EB.ROUND.AMOUNT(Y.CURRENCY,Y.TOTAL.PROV.FX,"","")
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.TOTAL.PROV.FX,ARR.FX.POS> =  Y.TOTAL.PROV.FX
        Y.TOTAL.CUS.PROV.CAL = Y.PROV.PRINCIPLE + Y.PROV.INETREST + Y.PROV.RESTRUCT + Y.TOTAL.PROV.FX
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.RESTRUCT,ARR.FX.POS> = Y.PROV.RESTRUCT
        CALL EB.ROUND.AMOUNT(Y.CURRENCY,Y.TOTAL.CUS.PROV.CAL,"","")
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.TOTAL.PROV,ARR.FX.POS> = Y.TOTAL.CUS.PROV.CAL
    END

RETURN
*-------------------------------------------------------------------------------
GROUP.LOANS:
*-------------------------------------------------------------------------------

    LN.TYPE = ''
    COUNT.LN.TYPE = DCOUNT(Y.LOAN.TYPE,@VM)

    FOR VM.POS = 1 TO COUNT.LN.TYPE
        Y.PRODUCT.GROUP.LIST = Y.PRODUCT.GROUP<1,VM.POS>
        CHANGE @SM TO @FM IN Y.PRODUCT.GROUP.LIST
        LOCATE Y.LOAN.AA.TYPE IN Y.PRODUCT.GROUP.LIST SETTING SM.POS THEN

            PRD.GROUP = Y.PRODUCT.GROUP<1,VM.POS,SM.POS>
            LN.TYPE   = Y.LOAN.TYPE<1,VM.POS>
*---------------- Changes done by JEEVA need to check with Bharath G------------*

*            LN.TYPE   = Y.LOAN.TYPE<1,SM.POS>

*---------------- Changes done by JEEVA need to check with Bharath G------------*
        END
    NEXT VM.POS
    IF LN.TYPE EQ '' THEN
        RETURN
    END

    BEGIN CASE
        CASE LN.TYPE EQ 'COMMERCIAL'
            Y.COMMERCIAL.ARR<-1> = Y.AA.ID

        CASE LN.TYPE EQ 'CONSUMER'
            Y.CONSUMER.ARR<-1> = Y.AA.ID

        CASE LN.TYPE EQ 'MORTGAGE'
            Y.MORTGAGE.ARR<-1> = Y.AA.ID

    END CASE

RETURN
*-------------------------------------------------------------------------------
GET.REDO.H.PROVISION.PARAMETER.VALUES:
*-------------------------------------------------------------------------------
    IF R.REDO.H.PROVISION.PARAMETER THEN
        Y.COMM.MAJOR.AMOUNT       = R.REDO.H.PROVISION.PARAMETER<PROV.COMM.MAJOR.AMOUNT>
        Y.DAYS.JUDICOLL           = R.REDO.H.PROVISION.PARAMETER<PROV.DAYS.JUDICOLL>
        Y.DAYS.OVERDUE            = R.REDO.H.PROVISION.PARAMETER<PROV.DAYS.OVERDUE>
        Y.LOAN.TYPE               = R.REDO.H.PROVISION.PARAMETER<PROV.LOAN.TYPE>
        Y.PRODUCT.GROUP           = R.REDO.H.PROVISION.PARAMETER<PROV.PRODUCT.GROUP>
        Y.CLASSIFICATION          = R.REDO.H.PROVISION.PARAMETER<PROV.CLASSIFICATION>
        Y.SECUR.CLASSI            = R.REDO.H.PROVISION.PARAMETER<PROV.SECUR.CLASSI>
        Y.UNSECUR.CLASSI          = R.REDO.H.PROVISION.PARAMETER<PROV.UNSECUR.CLASSI>
        Y.MIN.DAYS                = R.REDO.H.PROVISION.PARAMETER<PROV.MIN.DAYS>
        Y.MAX.DAYS                = R.REDO.H.PROVISION.PARAMETER<PROV.MAX.DAYS>
        Y.PERCENTAGE              = R.REDO.H.PROVISION.PARAMETER<PROV.PERCENTAGE>
        Y.JUD.PRINC.PERCT         = R.REDO.H.PROVISION.PARAMETER<PROV.JUD.PRINC.PERCT>
        Y.JUD.INT.PRECT           = R.REDO.H.PROVISION.PARAMETER<PROV.JUD.INT.PERCT>
        Y.JUD.PRINC.FACTOR = Y.JUD.PRINC.PERCT * 0.01
        Y.JUD.INT.FACTOR =    Y.JUD.INT.PRECT * 0.01
    END

RETURN
*-------------------------------------------------------------------------------
READ.REDO.H.CUSTOMER.PROVISIONING:
*-------------------------------------------------------------------------------

    R.REDO.H.CUSTOMER.PROVISIONING = '' ; R.REDO.H.CUSTOMER.PROVISIONING.HIS = ''
    CALL F.READ(FN.REDO.H.CUSTOMER.PROVISIONING,Y.CUS.ID,R.REDO.H.CUSTOMER.PROVISIONING,F.REDO.H.CUSTOMER.PROVISIONING, PROV.ERR)
    IF R.REDO.H.CUSTOMER.PROVISIONING THEN
        Y.PROCESS.DATE   = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROCESS.DATE>
        Y.CURRENT.CLASS  = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.CURRENT.CLASS>
        Y.PREVIOUS.CLASS = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PREVIOUS.CLASS>
        Y.CUR.NUMBER     = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.CURR.NO>
        R.REDO.H.CUSTOMER.PROVISIONING.HIS = R.REDO.H.CUSTOMER.PROVISIONING
        R.REDO.H.CUSTOMER.PROVISIONING     = ''
    END

RETURN
*-------------------------------------------------------------------------------
GET.ARR.CONDITION:
*-------------------------------------------------------------------------------
* ----------------- property class --------------------
    ArrangementID = Y.AA.ID     ; returnError      = ''
    idProperty    = ''          ; effectiveDate    = ''
    returnIds     = ''          ; returnConditions = ''
    R.CONDITION   = ''
*------------------------------------------------------
*-- Call AA.GET.ARRANGEMENT.CONDITIONS to get the arrangement condition record---

    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.CONDITION = RAISE(returnConditions)
RETURN
*-------------------------------------------------------------------------------
GET.BILL.DATE.OVERDUE:
*-------------------------------------------------------------------------------
    Y.BILL.DATE = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ERR.ACC.DET)
    Y.BILL.TYPE=R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE>
    Y.BILL.ID=R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.SET.STATUS=R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
    Y.BILL.DATE.LIST = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.DATE>

    CHANGE @SM TO @FM IN Y.BILL.TYPE
    CHANGE @VM TO @FM IN Y.BILL.TYPE
    CHANGE @SM TO @FM IN Y.BILL.ID
    CHANGE @SM TO @FM IN Y.BILL.DATE.LIST
    CHANGE @VM TO @FM IN Y.BILL.DATE.LIST
    CHANGE @VM TO @FM IN Y.BILL.ID
    CHANGE @SM TO @FM IN Y.SET.STATUS
    CHANGE @VM TO @FM IN Y.SET.STATUS
    Y.BILL.COUNT=DCOUNT(Y.BILL.TYPE,@FM)
    VAR2=1
    LOOP
    WHILE VAR2 LE Y.BILL.COUNT
        IF Y.BILL.TYPE<VAR2> EQ "PAYMENT" AND Y.SET.STATUS<VAR2> EQ 'UNPAID' THEN
            Y.BILL.DATE = Y.BILL.DATE.LIST<VAR2>
            VAR2 = Y.BILL.COUNT + 1
        END
        VAR2 += 1
    REPEAT
    idPropertyClass = "OVERDUE"
    GOSUB GET.ARR.CONDITION

RETURN
*-------------------------------------------------------------------------------
CLASSIFICATION.CALCULATION:
*-------------------------------------------------------------------------------
* Modificaiton done on fetching unpaid bill date
*-------------------------------------------------------------------------------

*CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.AA.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,AA.HIS.ERR)
*IF R.AA.ACTIVITY.HISTORY THEN
*Y.ACTIVITY.HIS    = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY>
*Y.SYSTEM.DATE.HIS = R.AA.ACTIVITY.HISTORY<AA.AH.SYSTEM.DATE>
*CHANGE VM TO FM IN Y.ACTIVITY.HIS
*CHANGE SM TO FM IN Y.ACTIVITY.HIS
*CHANGE VM TO FM IN Y.SYSTEM.DATE.HIS
*CHANGE SM TO FM IN Y.SYSTEM.DATE.HIS
*END
*GOSUB GET.ACTIVITY.ID.FOR.OVERDUE
    GOSUB GET.BILL.DATE.OVERDUE
*TOTAL.REC.ACTIVITY = DCOUNT(Y.ACTIVITY.HIS,FM)
*OVERDUE.POS = ''
*START.POS = ''
*Y.ACT.DATE = ''
*NO.OVERDUE.FOR.THREE.MTHS = '0'
*-------------------------------------------------------------------------------
* Modification starts
*-------------------------------------------------------------------------------
*LOOP
*WHILE TOTAL.REC.ACTIVITY GT OVERDUE.POS
*START.POS = OVERDUE.POS + 1
*LOCATE Y.OVERDUE.ACTIVITY IN Y.ACTIVITY.HIS,START.POS SETTING OVERDUE.POS THEN
*Y.ACT.DATE = Y.SYSTEM.DATE.HIS<OVERDUE.POS>
*END
*REPEAT
*-------------------------------------------------------------------------------
* Modification ends
*-------------------------------------------------------------------------------

    Y.ACT.DATE = ''
    Y.ACT.DATE = Y.BILL.DATE

    IF Y.ACT.DATE EQ '' THEN
        Y.ACT.DATE = R.DATES(EB.DAT.NEXT.WORKING.DAY)       ;* PACS00560874
    END

    Y.LOAN.STATUS = ''
    IF R.CONDITION THEN
        Y.LOAN.STATUS = R.CONDITION<AA.OD.LOCAL.REF><1,Y.LOAN.STATUS.1.POS>
    END
    IF Y.LOAN.STATUS EQ "Write-off" THEN
        Y.ACT.DATE = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    END   ;* PACS00560874 -E

    IF Y.ACT.DATE NE '' THEN
        REGION = ""
        GET.DAYS = "C"
        DATE.VAR = R.DATES(EB.DAT.NEXT.WORKING.DAY)         ;* PACS00560874
        CALL CDD(REGION,Y.ACT.DATE,DATE.VAR,GET.DAYS)
        Y.OVERDUE.DAYS = GET.DAYS
        Y.TOTAL.OVERDUE.DAYS += Y.OVERDUE.DAYS
    END

    GOSUB LOCATE.LOAN.TYPE.AND.GET.VALUES

*<<<<< Determine CLASSIFICATION based on Delinquency >>>>>>>>>>>

    COUNT.CLASSIFICATION = DCOUNT(Z.CLASSIFICATION,@FM)
    FOR Y.I = 1 TO COUNT.CLASSIFICATION
        IF Y.OVERDUE.DAYS GE Z.MIN.DAYS<COUNT.CLASSIFICATION> THEN
            CLASS.1  =  Z.CLASSIFICATION<COUNT.CLASSIFICATION>
            BREAK
        END
        IF Y.OVERDUE.DAYS GE Z.MIN.DAYS<Y.I> AND Y.OVERDUE.DAYS LE Z.MAX.DAYS<Y.I> THEN
            CLASS.1 =  Z.CLASSIFICATION<Y.I>
        END
    NEXT Y.I

*<<<<< Check the local field EQ "Restructured" or not >>>>>>

    IF R.CONDITION THEN
        Y.LOAN.COND        = R.CONDITION<AA.OD.LOCAL.REF><1,Y.LOAN.COND.POS>
        Y.LOAN.STATUS.1    = R.CONDITION<AA.OD.LOCAL.REF><1,Y.LOAN.STATUS.1.POS>
        Y.LOAN.STATUS.DATE = R.CONDITION<AA.OD.LOCAL.REF><1,Y.STATUS.CHG.DT.POS>
    END



    NEW.CALC.CLASS = ''
    LOCATE "Restructured" IN Y.LOAN.COND<1,1,1> SETTING POS1 THEN
        GOSUB CLASSIFICATION.CALCULATION.SUB.PROCESS
    END

    IF CLASS.1 GT NEW.CALC.CLASS THEN
        Y.FINAL.CLASS = CLASS.1
    END ELSE
        Y.FINAL.CLASS = NEW.CALC.CLASS
    END
*<<<<<<<<<< Calculate Worst Class from all the arrangements >>>>>>>>

    Y.WORST.CLASS = ''
    LOCATE Y.FINAL.CLASS IN CLASS.ARRAY.POS SETTING POS.CLASS THEN
        CLASS.ARRAY.NUM<-1> = POS.CLASS
    END
    Y.WROST.CLASS.POS = MINIMUM(CLASS.ARRAY.NUM)
    Y.WORST.CLASS = CLASS.ARRAY.POS<Y.WROST.CLASS.POS>

    Y.OVERDUE.DAYS.ARRAY<-1> = Y.OVERDUE.DAYS


    BEGIN CASE
        CASE LN.TYPE.FLAG EQ 'COMMERCIAL'
            GOSUB COMMERCIAL.LOAN.TYPE
        CASE LN.TYPE.FLAG EQ 'CONSUMER'
            GOSUB CONSUMER.LOAN.TYPE

        CASE LN.TYPE.FLAG EQ 'MORTGAGE'
            GOSUB MORTGAGE.LOAN.TYPE
    END CASE

    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.ARRANGEMENT.ID,-1>    = Y.AA.ID
    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.ARR.LOAN.TYPE,-1>     = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.CURRENCY,-1>          = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.DAYS.OD,-1>           = Y.OVERDUE.DAYS

RETURN
*-------------------------------------------------------------------------------
WORTS.CLASS.CAL:
*-------------------------------------------------------------------------------
    Y.WORST.CLASS.LN = '' ; Y.LN.OVERDUE = ''
    LOCATE Y.LN.TYPE.CLASS IN CLASS.ARRAY.POS SETTING POS.LN.CLASS THEN
        LN.CLASS.ARRAY<-1> = POS.LN.CLASS
    END
    Y.WROST.CLASS.LN.POS = MINIMUM(LN.CLASS.ARRAY)
    Y.WORST.CLASS.LN     = CLASS.ARRAY.POS<Y.WROST.CLASS.LN.POS>

    Y.WROST.OVERDUE<-1>  = Y.OVERDUE.DAYS
    Y.LN.OVERDUE         = MAXIMUM(Y.WROST.OVERDUE)
RETURN
*-------------------------------------------------------------------------------
COMMERCIAL.LOAN.TYPE:
*-------------------------------------------------------------------------------
    Y.PROVISION.ARRAY<-1>  = 'COMMERCIAL':"*":Y.AA.ID:"*":Y.OVERDUE.DAYS
    Y.LN.TYPE.CLASS        = Y.FINAL.CLASS
    GOSUB WORTS.CLASS.CAL
    IF COM.TYPE.FLAG NE '1' THEN
        Y.LN.TYPE     = LN.TYPE.FLAG
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.LOAN.TYPE,-1>                 = Y.LN.TYPE
        COM.TYPE.FLAG = 1
    END
    LOCATE 'COMMERCIAL' IN R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.LOAN.TYPE,1> SETTING LN.COM.POS THEN
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PREVIOUS.CLASS,LN.COM.POS>    = R.REDO.H.CUSTOMER.PROVISIONING.HIS<REDO.CUS.PROV.CURRENT.CLASS,LN.COM.POS>
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.CURRENT.CLASS,LN.COM.POS>     = Y.WORST.CLASS.LN
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.WORST.DAYS.OD,LN.COM.POS>     = Y.LN.OVERDUE
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.WORST.DAYS.JC,LN.COM.POS>     = MAXIMUM(DATES.JD.ARRAY)
    END
RETURN
*-------------------------------------------------------------------------------
CONSUMER.LOAN.TYPE:
*-------------------------------------------------------------------------------
    Y.PROVISION.ARRAY<-1>   = 'CONSUMER':"*":Y.AA.ID:"*":Y.OVERDUE.DAYS
    Y.LN.TYPE.CLASS         = Y.FINAL.CLASS
    GOSUB WORTS.CLASS.CAL
    IF CONS.TYPE.FLAG NE '1' THEN
        Y.LN.TYPE      = LN.TYPE.FLAG
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.LOAN.TYPE,-1>                  = Y.LN.TYPE
        CONS.TYPE.FLAG = 1
    END
    LOCATE 'CONSUMER' IN R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.LOAN.TYPE,1> SETTING LN.CONS.POS THEN
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PREVIOUS.CLASS,LN.CONS.POS>    = R.REDO.H.CUSTOMER.PROVISIONING.HIS<REDO.CUS.PROV.CURRENT.CLASS,LN.CONS.POS>
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.CURRENT.CLASS,LN.CONS.POS>     = Y.WORST.CLASS.LN
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.WORST.DAYS.OD,LN.CONS.POS>     = Y.LN.OVERDUE
    END
RETURN
*-------------------------------------------------------------------------------
MORTGAGE.LOAN.TYPE:
*-------------------------------------------------------------------------------
    Y.PROVISION.ARRAY<-1>    = 'MORTGAGE':"*":Y.AA.ID:"*":Y.OVERDUE.DAYS
    Y.LN.TYPE.CLASS          = Y.FINAL.CLASS
    GOSUB WORTS.CLASS.CAL
    IF MORT.TYPE.FLAG NE '1' THEN
        Y.LN.TYPE      = LN.TYPE.FLAG
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.LOAN.TYPE,-1>                  = Y.LN.TYPE
        MORT.TYPE.FLAG = '1'
    END
    LOCATE 'MORTGAGE' IN R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.LOAN.TYPE,1> SETTING LN.MORT.POS THEN
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.WORST.DAYS.OD,LN.MORT.POS>     = Y.LN.OVERDUE
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PREVIOUS.CLASS,LN.MORT.POS>    = R.REDO.H.CUSTOMER.PROVISIONING.HIS<REDO.CUS.PROV.CURRENT.CLASS,LN.MORT.POS>
        R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.CURRENT.CLASS,LN.MORT.POS>     = Y.WORST.CLASS.LN
    END
RETURN
*-------------------------------------------------------------------------------
CLASSIFICATION.CALCULATION.SUB.PROCESS:
*-------------------------------------------------------------------------------
    CALL OCOMO("Restructed check begins - ":Y.AA.ID)
    CALL F.READ(FN.REDO.AA.LOAN.UPD.STATUS,Y.AA.ID,R.REDO.AA.LOAN.UPD.STATUS,F.REDO.AA.LOAN.UPD.STATUS,ST.ERR)
    STATUS.DATE = R.REDO.AA.LOAN.UPD.STATUS<1>

    IF STATUS.DATE ELSE       ;* If that concat table is not updated then it may be a migrated contract with restruct status.
        CALL OCOMO("Restructed date not found in REDO.AA.LOAN.UPD.STATUS- ":Y.AA.ID)
        STATUS.DATE = R.CONDITION<AA.OD.LOCAL.REF><1,Y.STATUS.CHG.DT.POS>       ;* Get the loan status change date from overdue.
        IF STATUS.DATE ELSE
            CALL OCOMO("Restructed date not found in OVERDUE as well -":Y.AA.ID)
            STATUS.DATE =  TODAY        ;* In case both the fields doesnt have value, assume that is Today.
        END
    END
    IF STATUS.DATE GT Y.PROCESS.DATE THEN

*<<<<<<<<<<<<<< Restructured Since last Classification Process >>>>>>>>>>>

        NEW.CALC.CLASS = 'D'
    END ELSE
*NO.OVERDUE.FOR.THREE.MTHS = 'TRUE'
*LOOP
*REMOVE Y.OVERDUE.ACT FROM Y.ACTIVITY.HIS SETTING OVER.ACT.POS
*WHILE Y.OVERDUE.ACT:OVER.ACT.POS
*IF Y.OVERDUE.ACT EQ Y.OVERDUE.ACTIVITY THEN
*DATE.OVERDUE = Y.SYSTEM.DATE.HIS<OVER.ACT.POS>
*FREQ = "3M"
*DISP = "+"
*CALL CALENDAR.DAY(DATE.OVERDUE, DISP, FREQ)
*CALL CALENDAR.DAY(Y.BILL.DATE,DISP,FREQ)
*IF FREQ GT TODAY THEN
*NO.OVERDUE.FOR.THREE.MTHS = 'FALSE'
*END
*END
*REPEAT
*IF NO.OVERDUE.FOR.THREE.MTHS EQ 'TRUE' AND Y.PREVIOUS.CLASS NE 'B' THEN
        GOSUB GET.PAID.BILL.DETAILS
        IF Y.BILL.FLAG GE 3 THEN
            BEGIN CASE
                CASE Y.CURRENT.CLASS EQ 'B'
                    NEW.CALC.CLASS = 'B'
                CASE Y.CURRENT.CLASS EQ 'C'
                    NEW.CALC.CLASS = 'B'
                CASE Y.CURRENT.CLASS EQ 'D'
                    NEW.CALC.CLASS = 'C'
                CASE Y.CURRENT.CLASS EQ 'E'
                    NEW.CALC.CLASS = 'D'
            END CASE
        END ELSE
            NEW.CALC.CLASS = 'D'
        END
    END

RETURN
*-------------------------------------------------------------------------------
GET.PAID.BILL.DETAILS:
*-------------------------------------------------------------------------------
    Y.ACC.PROPERTY = ''
    OUT.ERR = ''
    CALL REDO.GET.PROPERTY.NAME(Y.AA.ID,'ACCOUNT','',Y.ACC.PROPERTY,OUT.ERR)

    Y.BILL.FLAG          = 0
    Y.BILL.IDS           = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.BILL.PAY.DATES     = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE>
    Y.BILL.PAY.DATES.CNT = DCOUNT(Y.BILL.PAY.DATES,@VM)

    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.BILL.PAY.DATES.CNT
        IF Y.BILL.PAY.DATES<1,Y.VAR1> GT STATUS.DATE THEN
            Y.BILL.REF = Y.BILL.IDS<1,Y.VAR1>
            GOSUB CHECK.ACCOUNT.PROP.DET          ;* Check whether bill has account property.
        END
        Y.VAR1 += 1
    REPEAT


RETURN
*------------------------------------------------------------------------
CHECK.ACCOUNT.PROP.DET:
*------------------------------------------------------------------------
    Y.BILL.REF.CNT = DCOUNT(Y.BILL.REF,@SM)
    Y.VAR2 = 1
    LOOP
    WHILE Y.VAR2 LE Y.BILL.REF.CNT
        Y.BILL.ID = Y.BILL.REF<1,1,Y.VAR2>
        CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
        LOCATE Y.ACC.PROPERTY IN R.AA.BILL.DETAILS<AA.BD.PROPERTY,1> SETTING PROP.POS THEN
            Y.OS.PROP.AMT = R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT,PROP.POS>
            IF Y.OS.PROP.AMT ELSE       ;* If the amount is repaid
                Y.BILL.FLAG += 1
            END
        END

        Y.VAR2 += 1
    REPEAT

RETURN
*-------------------------------------------------------------------------------
LOCATE.LOAN.TYPE.AND.GET.VALUES:
*-------------------------------------------------------------------------------
    LOCATE LN.TYPE.FLAG IN Y.LOAN.TYPE<1,1> SETTING LN.TYPE.POS THEN
        Z.LOAN.TYPE      = Y.LOAN.TYPE<1,LN.TYPE.POS>
        Z.CLASSIFICATION = Y.CLASSIFICATION<1,LN.TYPE.POS>
        Z.SECUR.CLASSI   = Y.SECUR.CLASSI<1,LN.TYPE.POS>
        Z.UNSECUR.CLASSI = Y.UNSECUR.CLASSI<1,LN.TYPE.POS>
        Z.MIN.DAYS       = Y.MIN.DAYS<1,LN.TYPE.POS>
        Z.MAX.DAYS       = Y.MAX.DAYS<1,LN.TYPE.POS>
        Z.PERCENTAGE     = Y.PERCENTAGE<1,LN.TYPE.POS>
        CHANGE @SM TO @FM IN Z.LOAN.TYPE
        CHANGE @SM TO @FM IN Z.CLASSIFICATION
        CHANGE @SM TO @FM IN Z.SECUR.CLASSI
        CHANGE @SM TO @FM IN Z.UNSECUR.CLASSI
        CHANGE @SM TO @FM IN Z.MIN.DAYS
        CHANGE @SM TO @FM IN Z.MAX.DAYS
        CHANGE @SM TO @FM IN Z.PERCENTAGE
    END

RETURN
*-------------------------------------------------------------------------------
NON.COMMERCIAL.PROCESS:
*-------------------------------------------------------------------------------
    Y.PROV.INETREST.SP = ''
*BALANCE.TO.CHECK = 'CURACCOUNT':VM:'DUEACCOUNT':VM:'DELACCOUNT':VM:'DE1ACCOUNT':VM:'GRCACCOUNT':VM:'NABACCOUNT'
*GOSUB GET.PERIOD.BALANCES

    IN.PROPERTY.CLASS = 'ACCOUNT'
    CALL REDO.GET.PROPERTY.NAME(Y.AA.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,Y.ACC.PROPERTY,OUT.ERR)
    Y.BALANCE.TYPE = 'CUR':@FM:'DUE':@FM:Y.AGING.BALANCE.TYPES
    CALL REDO.GET.TOTAL.OUTSTANDING.BYPROP(Y.AA.ID,Y.ACC.PROPERTY,Y.BALANCE.TYPE,Y.AMT)
    CALL OCOMO("Balance NON-Commercial- ":Y.AA.ID:" - Principal - ":Y.AMT)
    Y.PROV.PRINCIPLE = Y.AMT * Y.FACTOR

*BALANCE.TO.CHECK = 'ACCPRINCIPALINT':VM:'DUEPRINCIPALINT':VM:'ACCPENALTYINT':VM:'GRCPRINCIPALINT':VM:'DELPRINCIPALINT':VM:'NABPRINCIPALINT':VM:'DE1PRINCIPALINT'
*GOSUB GET.PERIOD.BALANCES
*Y.PROV.INETREST = Y.AMT * Y.FACTOR
    CALL REDO.GET.PROPERTY.NAME(Y.AA.ID,'INTEREST',R.OUT.AA.RECORD,Y.INT.PROPERTY,OUT.ERR)
    Y.BALANCE.TYPE  = 'ACC':@FM:'DUE':@FM:Y.AGING.BALANCE.TYPES
    CALL REDO.GET.TOTAL.OUTSTANDING.BYPROP(Y.AA.ID,Y.INT.PROPERTY,Y.BALANCE.TYPE,Y.AMT)
    CALL OCOMO("Balance NON-Commercial- ":Y.AA.ID:" - Interest - ":Y.AMT)

    Y.PROV.INETREST = Y.AMT * Y.INT.FACTOR

*BALANCE.TO.CHECK = 'ACCPRINCIPALINTSP':VM:'DUEPRINCIPALINTSP':VM:'ACCPENALTYINTSP':VM:'GRCPRINCIPALINTSP':VM:'DELPRINCIPALINTSP':VM:'NABPRINCIPALINTSP':VM:'DE1PRINCIPALINTSP'
*GOSUB GET.PERIOD.BALANCES
*Y.PROV.INETREST.SP = Y.AMT * Y.FACTOR
*Y.PROV.INETREST.SP = Y.AMT * Y.INT.FACTOR
*IF Y.PROV.INETREST.SP THEN
*Y.PROV.INETREST = Y.PROV.INETREST - Y.PROV.INETREST.SP
*END

RETURN
*-------------------------------------------------------------------------------
*GET.PERIOD.BALANCES:
*-------------------------------------------------------------------------------
*CALL F.READ(FN.ALTERNATE.ACCOUNT,Y.AA.ID,R.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT,ALT.ERR)
*Y.ACC.ID = R.ALTERNATE.ACCOUNT
*Y.AMT = 0
*LOOP REMOVE Y.BAL FROM BALANCE.TO.CHECK SETTING BAL.POS
*WHILE Y.BAL:BAL.POS
*REQUEST.TYPE<4>='ECB'
*CALL AA.GET.PERIOD.BALANCES (Y.ACC.ID, Y.BAL, REQUEST.TYPE, START.DATE, END.DATE, SYSTEM.DATE, BAL.DETAILS, ERR.MSG)
*Y.AMT += ABS(BAL.DETAILS<4>)
*REPEAT
*RETURN
*-------------------------------------------------------------------------------
COMMERCIAL.PROCESS:
*-------------------------------------------------------------------------------
    idPropertyClass = "LIMIT"
    GOSUB GET.ARR.CONDITION
*BALANCE.TO.CHECK = 'CURACCOUNT':VM:'DUEACCOUNT':VM:'DELACCOUNT':VM:'DE1ACCOUNT':VM:'GRCACCOUNT':VM:'NABACCOUNT'
*GOSUB GET.PERIOD.BALANCES

    IN.PROPERTY.CLASS = 'ACCOUNT'
    CALL REDO.GET.PROPERTY.NAME(Y.AA.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,Y.ACC.PROPERTY,OUT.ERR)
    Y.BALANCE.TYPE = 'CUR':@FM:'DUE':@FM:Y.AGING.BALANCE.TYPES
    CALL REDO.GET.TOTAL.OUTSTANDING.BYPROP(Y.AA.ID,Y.ACC.PROPERTY,Y.BALANCE.TYPE,Y.AMT)
    CALL OCOMO("Balance Commercial- ":Y.AA.ID:" - Principal - ":Y.AMT)
    Y.OUT.PRINCIPLE = Y.AMT

*BALANCE.TO.CHECK = 'ACCPRINCIPALINT':VM:'DUEPRINCIPALINT':VM:'ACCPENALTYINT':VM:'GRCPRINCIPALINT':VM:'DELPRINCIPALINT':VM:'NABPRINCIPALINT':VM:'DE1PRINCIPALINT'
*GOSUB GET.PERIOD.BALANCES
    CALL REDO.GET.PROPERTY.NAME(Y.AA.ID,'INTEREST',R.OUT.AA.RECORD,Y.INT.PROPERTY,OUT.ERR)
    Y.BALANCE.TYPE  = 'ACC':@FM:'DUE':@FM:Y.AGING.BALANCE.TYPES
    CALL REDO.GET.TOTAL.OUTSTANDING.BYPROP(Y.AA.ID,Y.INT.PROPERTY,Y.BALANCE.TYPE,Y.AMT)
    CALL OCOMO("Balance Commercial- ":Y.AA.ID:" - Interest - ":Y.AMT)
    Y.OUT.INETREST = Y.AMT

*BALANCE.TO.CHECK = 'ACCPRINCIPALINTSP':VM:'DUEPRINCIPALINTSP':VM:'ACCPENALTYINTSP':VM:'GRCPRINCIPALINTSP':VM:'DELPRINCIPALINTSP':VM:'NABPRINCIPALINTSP':VM:'DE1PRINCIPALINTSP'
*GOSUB GET.PERIOD.BALANCES
*Y.OUT.INETREST.SP = Y.AMT

*IF Y.OUT.INETREST.SP THEN
*Y.OUT.INETREST = Y.OUT.INETREST - Y.OUT.INETREST.SP
*END

    idPropertyClass = "TERM.AMOUNT"
    GOSUB GET.ARR.CONDITION
    IF R.CONDITION THEN
        Y.COLLATERAL.ID = R.CONDITION<AA.AMT.LOCAL.REF><1,Y.AA.COL.POS,1>
    END

    IF Y.COLLATERAL.ID EQ '' THEN
* ------- If COLLATERAL = "NULL" it is Unsecured Loan the provisioning is -------
* ------- calculated for the total outstanding principle.-----------------------

        Y.PROV.PRINCIPLE = Y.OUT.PRINCIPLE * Y.FACTOR
*        Y.PROV.INETREST = Y.OUT.INETREST * Y.FACTOR
        Y.PROV.INETREST = Y.OUT.INETREST * Y.INT.FACTOR
    END
    IF Y.COLLATERAL.ID NE '' THEN
*--------------- Else COLLATERL NE "NULL" it is a secured loan ----------------
        GOSUB PROCESS.FOR.LIMIT.REF.NOT.EQUAL.NULL
    END

RETURN
*-------------------------------------------------------------------------------
PROCESS.FOR.LIMIT.REF.NOT.EQUAL.NULL:
*-------------------------------------------------------------------------------

    IF Y.WORST.CLASS EQ 'A' OR Y.WORST.CLASS EQ 'B' OR Y.WORST.CLASS EQ 'C' THEN

        Y.CENTRAL.BANK.VALUE = 0
        CALL F.READ(FN.COLLATERAL,Y.COLLATERAL.ID,R.COLLATERAL,F.COLLATERAL,COLLATERAL.ERR)
        IF R.COLLATERAL THEN
            Y.CENTRAL.BANK.VALUE = R.COLLATERAL<COLL.CENTRAL.BANK.VALUE>
        END
        IF (Y.OUT.PRINCIPLE + Y.OUT.INETREST) LE Y.CENTRAL.BANK.VALUE THEN
            Y.PROV.PRINCIPLE = Y.OUT.PRINCIPLE * Y.SECUR.FACTOR
            Y.PROV.INETREST = Y.OUT.INETREST * Y.SECUR.FACTOR
        END
        IF Y.OUT.PRINCIPLE LE Y.CENTRAL.BANK.VALUE AND (Y.CENTRAL.BANK.VALUE - Y.OUT.PRINCIPLE) LE Y.OUT.INETREST THEN
            Y.PROV.PRINCIPLE = Y.OUT.PRINCIPLE * Y.SECUR.FACTOR
            Y.PROV.INETREST.1  = (Y.CENTRAL.BANK.VALUE - Y.OUT.PRINCIPLE) * Y.SECUR.FACTOR
            Y.PROV.INETREST.2 = (Y.OUT.INETREST - (Y.CENTRAL.BANK.VALUE - Y.OUT.PRINCIPLE))* Y.UNSECUR.FACTOR
            Y.PROV.INETREST = Y.PROV.INETREST.1 + Y.PROV.INETREST.2
        END
        IF Y.OUT.PRINCIPLE GT Y.CENTRAL.BANK.VALUE THEN
            Y.PROV.PRINCIPLE.1 = Y.CENTRAL.BANK.VALUE * Y.SECUR.FACTOR
            Y.PROV.PRINCIPLE.2 = (Y.OUT.PRINCIPLE - Y.CENTRAL.BANK.VALUE)*Y.UNSECUR.FACTOR
            Y.PROV.PRINCIPLE = Y.PROV.PRINCIPLE.1 + Y.PROV.PRINCIPLE.2
            Y.PROV.INETREST =  Y.OUT.INETREST * Y.UNSECUR.FACTOR
        END
    END
    IF Y.WORST.CLASS EQ 'D' OR Y.WORST.CLASS EQ 'E' THEN
        IF Y.LOAN.STATUS.1 EQ "JudicialCollection" THEN
            GOSUB DAYS.CAL.VAL
        END ELSE
            Y.PROV.PRINCIPLE = Y.OUT.PRINCIPLE * Y.SECUR.FACTOR
            Y.PROV.INETREST  = Y.OUT.INETREST  * Y.SECUR.FACTOR
        END
*IF MAXIMUM(Y.OVERDUE.DAYS.ARRAY) GT Y.DAYS.OVERDUE THEN
*Y.PROV.PRINCIPLE = Y.OUT.PRINCIPLE * Y.JUD.PRINC.FACTOR   ;* <<<<<<<<<  20 Percentage >>>>>>>>>>>>>>>>>>>>>
*Y.PROV.INETREST = Y.OUT.INETREST * Y.JUD.INT.FACTOR       ;*<<<<<<<<<<<<<<<<<< 100 percentage >>>>>>>>>>>>>>>>
*END
    END

RETURN
*-------------------------------------------------------------------------------
DAYS.CAL.VAL:
*-------------------------------------------------------------------------------
    GET.DAYS = "C"
    Y.DATES.JD = 0
    IF Y.LOAN.STATUS.DATE NE '' THEN
        CALL CDD(REGION,Y.LOAN.STATUS.DATE,TODAY,Y.DATES.JD)
*Y.DATES.JD = STATUS.DATE
    END
    DATES.JD.ARRAY<-1> = Y.DATES.JD
    IF Y.DATES.JD GT Y.DAYS.JUDICOLL THEN
        Y.PROV.PRINCIPLE = Y.OUT.PRINCIPLE * Y.FACTOR
*Y.PROV.INETREST = Y.OUT.INETREST * Y.FACTOR
        Y.PROV.INETREST = Y.OUT.INETREST *  Y.INT.FACTOR
    END ELSE
        IF MAXIMUM(Y.OVERDUE.DAYS.ARRAY) GT Y.DAYS.OVERDUE THEN
            Y.PROV.PRINCIPLE = Y.OUT.PRINCIPLE * Y.JUD.PRINC.FACTOR
            Y.PROV.INETREST  = Y.OUT.INETREST  * Y.JUD.INT.FACTOR
        END ELSE
            Y.PROV.PRINCIPLE = Y.OUT.PRINCIPLE * Y.SECUR.FACTOR
            Y.PROV.INETREST  = Y.OUT.INETREST  * Y.SECUR.FACTOR
        END
    END
*    IF MAXIMUM(Y.OVERDUE.DAYS.ARRAY) GT Y.DAYS.OVERDUE THEN
*        Y.PROV.PRINCIPLE = Y.OUT.PRINCIPLE * 0.20 ;* <<<<<<<<<  20 Percentage >>>>>>>>>>>>>>>>>>>>>
*       Y.PROV.INETREST = Y.OUT.INETREST * 1      ;*<<<<<<<<<<<<<<<<<< 100 percentage >>>>>>>>>>>>>>>>
*  END
RETURN
*-------------------------------------------------------------------------------
GET.FX.PROVISION:
*-------------------------------------------------------------------------------
    Y.PROV.FX = 0
    IF R.AA.ARRANGEMENT<AA.ARR.CURRENCY> EQ 'DOP' OR R.AA.ARRANGEMENT<AA.ARR.CURRENCY> EQ '' THEN
        RETURN
    END ELSE
        Y.CURRENCY = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
        GOSUB OPEN.FILE.FX
        GOSUB READ.FILE.FX
        GOSUB DELETE.FILE.FX
    END

RETURN
*-------------------------------------------------------------------------------
OPEN.FILE.FX:
*-------------------------------------------------------------------------------
    FILE.NAME = Y.CUS.ID:".":Y.AA.ID:".":Y.CURRENCY
    OUT.FILE.PATH = '../bnk.data'
    RTN = "REDO.B.CUSTOMER.PROVISION"
    OPENSEQ OUT.FILE.PATH, FILE.NAME TO F.FILE.VAR ELSE
        OPEN.ERR = 'Unable to Open ':OUT.FILE.PATH:" ":FILE.NAME
        CALL EXCEPTION.LOG("S","BNK/REDO.B.PROV.CALC",RTN,"",001,"",OUT.FILE.PATH,FILE.NAME,"",OPEN.ERR,"")
    END

RETURN
*-------------------------------------------------------------------------------
READ.FILE.FX:
*-------------------------------------------------------------------------------
    LAST.UPD.LINE = ''
    LOOP
        READSEQ Y.FILE.CONTENT FROM F.FILE.VAR THEN
            LAST.UPD.LINE = Y.FILE.CONTENT
        END ELSE
            Y.PROV.FX = FIELD(LAST.UPD.LINE,"*",4)
            BREAK
        END
    REPEAT

RETURN
*-------------------------------------------------------------------------------
DELETE.FILE.FX:
*-------------------------------------------------------------------------------
    DELETESEQ OUT.FILE.PATH, FILE.NAME ELSE
        OPEN.ERR = 'Unable to delete ':OUT.FILE.PATH:" ":FILE.NAME
        CALL EXCEPTION.LOG("S","BNK/REDO.B.PROV.CALC",RTN,"","001","",OUT.FILE.PATH,FILE.NAME,"",OPEN.ERR,"")
    END

RETURN
*-------------------------------------------------------------------------------
WRITE.CUSTOMER.PROVISIONING:
*-------------------------------------------------------------------------------
    GOSUB WRITE.TO.HISTORY
    GOSUB WRITE.TO.LIVE
RETURN
*-------------------------------------------------------------------------------
WRITE.TO.HISTORY:
*-------------------------------------------------------------------------------
    IF Y.CUR.NUMBER THEN
        CUST.HIS.ID = Y.CUS.ID:';':Y.CUR.NUMBER
        GOSUB WRITE.REDO.H.CUSTOMER.PROVISION.HIS
    END
RETURN
*-------------------------------------------------------------------------------
WRITE.TO.LIVE:
*-------------------------------------------------------------------------------
    R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.CURR.NO>  = Y.CUR.NUMBER + 1
    GOSUB WRITE.REDO.H.CUSTOMER.PROVISION.LIVE
RETURN
*-------------------------------------------------------------------------------
WRITE.REDO.H.CUSTOMER.PROVISION.HIS:
*-------------------------------------------------------------------------------
    CALL F.WRITE(FN.REDO.H.CUSTOMER.PROVISIONING.HIS,CUST.HIS.ID,R.REDO.H.CUSTOMER.PROVISIONING.HIS)
RETURN
*-------------------------------------------------------------------------------
WRITE.REDO.H.CUSTOMER.PROVISION.LIVE:
*-------------------------------------------------------------------------------

    CALL F.WRITE(FN.REDO.H.CUSTOMER.PROVISIONING,Y.CUS.ID,R.REDO.H.CUSTOMER.PROVISIONING)
RETURN
*-------------------------------------------------------------------------------
END       ;* End of Program
