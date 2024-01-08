* @ValidationCode : MjoyMjkyMTExMTE6VVRGLTg6MTcwNDE5ODg5Njk4MDpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Jan 2024 18:04:56
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
*-----------------------------------------------------------------------------
* <Rating>-254</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.E.LOAN.STATUS.COND(Y.OUTPUT.ENQ)
***********************************************************************

* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.E.LOAN.STATUS.COND
* ODR NO      : ODR-2009-10-0331
*----------------------------------------------------------------------
*DESCRIPTION: Its a NOFILE enquiry routine for the ENQUIRY REDO.AA.LOAN.STATUS.COND
* to enquire the Arrangement details


*IN PARAMETER :  NA
*OUT PARAMETER: FINAL.ARR - Contains the details to be displayed in the enquiry output
*LINKED WITH  :   REDO.AA.LOAN.STATUS.COND(ENQUIRY)
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO                REFERENCE                  DESCRIPTION
*13.07.2010  H GANESH            ODR-2009-10-0331              INITIAL CREATION
*24/05/2023  VIGNESHWARI         MANUAL R22 CODE CONVERSION    Call routine modified,CHANGED  F.ECB.E.ECB TO F.ECB,E.ECB
*24/05/2023  CONVERSION TOOL     AUTO R22 CODE CONVERSION      NEWLINE ADD, VM & FM - @VM & @FM
*-----------------------------------------------------------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.OVERDUE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.ACCT.ACTIVITY
* $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.EB.CONTRACT.BALANCES
    $USING AA.Framework


    GOSUB INIT
    GOSUB OPENFILES
    GOSUB MULTI.GET.LOC.REF
    GOSUB GET.ARR.IDS
    GOSUB GET.INTEREST.IDS
    GOSUB GET.TERM.IDS
    GOSUB GET.PRIN.IDS
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
* All variables are intialized here

    Y.INT.ARR.ID=''
    Y.TERM.ARR.ID=''
    Y.PRIN.ARR.ID=''
    Y.COMMON.ARRAY=''
    Y.COMMON.ARR=''
    Y.COMMON.ARRAY.FINAL=''

RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
* All files needed throughtout the routine are opened here

    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    FN.AA.ARR.INTEREST='F.AA.ARR.INTEREST'
    F.AA.ARR.INTEREST=''
    CALL OPF(FN.AA.ARR.INTEREST,F.AA.ARR.INTEREST)
    FN.AA.ARR.TERM.AMOUNT='F.AA.ARR.TERM.AMOUNT'
    F.AA.ARR.TERM.AMOUNT=''
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)
    FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS=''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)
    FN.EB.LOOKUP='F.EB.LOOKUP'
    F.EB.LOOKUP=''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)
    FN.ACCT.ACTIVITY='F.ACCT.ACTIVITY'
    F.ACCT.ACTIVITY=''
    CALL OPF(FN.ACCT.ACTIVITY,F.ACCT.ACTIVITY)
    FN.AA.ARRANGEMENT.ACTIVITY='F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY=''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

*TUS change START
    FN.ECB = 'F.EB.CONTRACT.BALANCES'
    F.ECB = ''
    CALL OPF(FN.ECB,F.ECB)

*TUS change END
RETURN
*----------------------------------------------------------------------
MULTI.GET.LOC.REF:
*----------------------------------------------------------------------
* To get the position of local fields

    LOC.REF.APPLICATION="AA.PRD.DES.OVERDUE"
    LOC.REF.FIELDS='L.LOAN.STATUS.1':@VM:'L.LOAN.COND'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.LOAN.STATUS.1=LOC.REF.POS<1,1>
    POS.L.LOAN.COND=LOC.REF.POS<1,2>

RETURN
*----------------------------------------------------------------------
GET.ARR.IDS:
*----------------------------------------------------------------------
* All selection fields related to AA.ARRANGEMENT application are processed here

    VALUE.BK = D.RANGE.AND.VALUE
    OPERAND.BK = D.LOGICAL.OPERANDS
    FIELDS.BK = D.FIELDS

    D.RANGE.AND.VALUE=''
    D.LOGICAL.OPERANDS=''
    D.FIELDS=''

    ARRANGEMENT.APP.FLDS = '@ID':@FM:'CUSTOMER':@FM:'PRODUCT':@FM:'CURRENCY':@FM:'START.DATE':@FM:'ARR.STATUS'
    LOOP
        REMOVE ARR.FLD FROM ARRANGEMENT.APP.FLDS SETTING ARR.FLD.POS
    WHILE ARR.FLD:ARR.FLD.POS
        LOCATE ARR.FLD IN FIELDS.BK<1> SETTING POS1 THEN
            GOSUB UPDATE.COM.VAR
        END
    REPEAT

    IF D.FIELDS NE '' THEN
        FILE.NAME = FN.AA.ARRANGEMENT

        APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '', SEL.AA.ARR.CMD);*MANUAL R22 CODE CONVERSION
        CALL EB.READLIST(SEL.AA.ARR.CMD,AA.ARR.ID.LST,'',NO.OF.REC.ARR,SEL.ERR)
    END
RETURN

*----------------------------------------------------------------------
GET.INTEREST.IDS:
*----------------------------------------------------------------------
* All selection fields related to AA.ARR.INTEREST application are processed here

    D.RANGE.AND.VALUE=''
    D.LOGICAL.OPERANDS=''
    D.FIELDS=''

    INTEREST.APP.FLDS='EFFECTIVE.RATE'
    LOOP
        REMOVE INT.FLD FROM INTEREST.APP.FLDS SETTING INT.FLD.POS
    WHILE INT.FLD:INT.FLD.POS
        LOCATE INT.FLD IN FIELDS.BK<1> SETTING POS1 THEN
            GOSUB UPDATE.COM.VAR
        END
    REPEAT
    IF D.FIELDS NE '' THEN
        FILE.NAME = FN.AA.ARR.INTEREST
        APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '', SEL.AA.INT.CMD)
        CALL EB.READLIST(SEL.AA.INT.CMD,AA.INT.ID.LST,'',NO.OF.REC.INT,SEL.ERR)
    END
RETURN
*----------------------------------------------------------------------
GET.TERM.IDS:
*----------------------------------------------------------------------
* All selection fields related to AA.ARR.TERM.AMOUNT application are processed here

    D.RANGE.AND.VALUE=''
    D.LOGICAL.OPERANDS=''
    D.FIELDS=''

    TERM.APP.FLDS='MATURITY.DATE':@FM:'AMOUNT'
    LOOP
        REMOVE TERM.FLD FROM TERM.APP.FLDS SETTING TERM.FLD.POS
    WHILE TERM.FLD:TERM.FLD.POS
        LOCATE TERM.FLD IN FIELDS.BK<1> SETTING POS1 THEN
            GOSUB UPDATE.COM.VAR
        END
    REPEAT
    IF D.FIELDS NE '' THEN
        FILE.NAME = FN.AA.ARR.TERM.AMOUNT
        APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '', SEL.AA.TERM.CMD);*MANUAL R22 CODE CONVERSION
        CALL EB.READLIST(SEL.AA.TERM.CMD,AA.TERM.ID.LST,'',NO.OF.REC.TERM,SEL.ERR)
    END
RETURN

*----------------------------------------------------------------------
GET.PRIN.IDS:
*----------------------------------------------------------------------
* All selection fields related to AA.ARRANGEMENT.ACTIVITY application are processed here


    D.RANGE.AND.VALUE=''
    D.LOGICAL.OPERANDS=''
    D.FIELDS=''
    PRIN.TERM.FLDS='TXN.AMOUNT'
    LOCATE PRIN.TERM.FLDS IN FIELDS.BK<1> SETTING POS1 THEN
        GOSUB UPDATE.COM.VAR
        IF D.FIELDS NE '' THEN
            FILE.NAME = FN.AA.ARRANGEMENT.ACTIVITY
            APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '', SEL.AA.PRIN.CMD);*MANUAL R22 CODE CONVERSION
            SEL.AA.PRIN.CMD:=" AND ACTIVITY.CLASS EQ LENDING-DISBURSE-TERM.AMOUNT"
            CALL EB.READLIST(SEL.AA.PRIN.CMD,AA.PRIN.ID.LST,'',NO.OF.REC.PRIN,SEL.ERR)
        END
    END
RETURN
*----------------------------------------------------------------------
UPDATE.COM.VAR:
*----------------------------------------------------------------------

    D.RANGE.AND.VALUE<-1>=VALUE.BK<POS1>
    D.LOGICAL.OPERANDS<-1>=OPERAND.BK<POS1>
    D.FIELDS<-1>=FIELDS.BK<POS1>

RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
* Final List of arrangement's ID are sorted out here

    GOSUB INTEREST.ID.SORT
    GOSUB TERM.ID.SORT
    GOSUB PRIN.ID.SORT

    IF Y.INT.ARR.ID NE '' AND Y.TERM.ARR.ID NE '' THEN
        Y.INT.ARR.ID.CNT=DCOUNT(Y.INT.ARR.ID,@FM)
        VAR1=1
        LOOP
        WHILE VAR1 LE Y.INT.ARR.ID.CNT
            LOCATE Y.INT.ARR.ID<VAR1> IN Y.TERM.ARR.ID SETTING POS2 THEN
                Y.COMMON.ARRAY<-1>=Y.INT.ARR.ID<VAR1>
            END
            VAR1++
        REPEAT
    END ELSE
        Y.COMMON.ARRAY=Y.INT.ARR.ID:Y.TERM.ARR.ID
    END
    IF Y.PRIN.ARR.ID NE '' AND Y.COMMON.ARRAY NE '' THEN
        Y.PRIN.ARR.ID.CNT=DCOUNT(Y.PRIN.ARR.ID,@FM)
        VAR1=1
        LOOP
        WHILE VAR1 LE Y.PRIN.ARR.ID.CNT
            LOCATE Y.PRIN.ARR.ID<VAR1> IN Y.COMMON.ARRAY SETTING POS2 THEN
                Y.COMMON.ARR<-1>=Y.PRIN.ARR.ID<VAR1>
            END
            VAR1++
        REPEAT
    END ELSE
        Y.COMMON.ARR=Y.COMMON.ARRAY:Y.PRIN.ARR.ID
    END
    IF Y.COMMON.ARR NE '' AND AA.ARR.ID.LST NE '' THEN
        Y.COMMON.ARR.COUNT=DCOUNT(Y.COMMON.ARR,@FM)
        VAR1=1
        LOOP
        WHILE VAR1 LE Y.COMMON.ARR.COUNT
            LOCATE Y.COMMON.ARR<VAR1> IN AA.ARR.ID.LST SETTING POS2 THEN
                Y.COMMON.ARRAY.FINAL<-1>=Y.COMMON.ARR<VAR1>
            END
            VAR1++
        REPEAT
    END ELSE
        Y.COMMON.ARRAY.FINAL=Y.COMMON.ARR:AA.ARR.ID.LST
    END
    GOSUB FORM.ARRAY
RETURN
*----------------------------------------------------------------------
INTEREST.ID.SORT:
*----------------------------------------------------------------------
    VAR1=1
    LOOP
    WHILE VAR1 LE NO.OF.REC.INT
        Y.TEMP.ID=FIELD(AA.INT.ID.LST<VAR1>,'-',1)
        LOCATE Y.TEMP.ID IN Y.INT.ARR.ID<1> SETTING POS ELSE
            Y.INT.ARR.ID<-1>=Y.TEMP.ID
        END
        VAR1++
    REPEAT
RETURN
*----------------------------------------------------------------------
TERM.ID.SORT:
*----------------------------------------------------------------------
    VAR1=1
    LOOP
    WHILE VAR1 LE NO.OF.REC.TERM
        Y.TEMP.ID=FIELD(AA.TERM.ID.LST<VAR1>,'-',1)
        LOCATE Y.TEMP.ID IN Y.TERM.ARR.ID<1> SETTING POS ELSE
            Y.TERM.ARR.ID<-1>=Y.TEMP.ID
        END
        VAR1++
    REPEAT
RETURN
*----------------------------------------------------------------------
PRIN.ID.SORT:
*----------------------------------------------------------------------
    VAR1=1
    LOOP
    WHILE VAR1 LE NO.OF.REC.PRIN
        Y.AAA.ID=AA.PRIN.ID.LST<VAR1>
*CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.AAA.ID,R.AAA,F.AA.ARRANGEMENT.ACTIVITY,AAA.ERR)
        R.AAA = AA.Framework.ArrangementActivity.Read(Y.AAA.ID, AAA.ERR)
*Y.PRIN.ARR.ID<-1>=R.AAA<AA.ARR.ACT.ARRANGEMENT>
        Y.PRIN.ARR.ID<-1>=R.AAA<AA.Framework.ArrangementActivity.ArrActArrangement>
        VAR1++
    REPEAT
RETURN
*----------------------------------------------------------------------
FORM.ARRAY:
*----------------------------------------------------------------------
* From final list of arrangement ID's, final process will be happened here

    Y.COMMON.ARRAY.FINAL.COUNT=DCOUNT(Y.COMMON.ARRAY.FINAL,@FM)
    SEL.CMD1='SELECT ':FN.EB.LOOKUP:' WITH @ID LIKE AA.OVERDUE.STATUS...'
    CALL EB.READLIST(SEL.CMD1,SEL.LOOKUP,'',SEL.NO.LOOKUP,SEL.RET)
    VAR3=1
    LOOP
    WHILE VAR3 LE Y.COMMON.ARRAY.FINAL.COUNT
        Y.FINAL.DEL.TOTAL=0
        Y.FINAL.DUE.TOTAL=0
        Y.OUT.ARRAY=''
        Y.ARRANGEMENT.ID=Y.COMMON.ARRAY.FINAL<VAR3>
        CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.ARRANGEMENT.ID,R.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACT.DET.ERR)
        PROP.CLASS="OVERDUE"
        EFF.DATE=''
        PROPERTY=''
        R.Condition=''
        ERR.MSG=''
        CALL CRR.GET.CONDITIONS(Y.ARRANGEMENT.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
*TUS change START
        GOSUB GET.ECB
        CONVERT @FM TO @VM IN SEL.LOOKUP

*TUS change END
        GOSUB TOTAL.DEL.BAL
        Y.OUT.ARRAY=''
        GOSUB TOTAL.DUE.BAL
        Y.OUTPUT.ENQ:=R.ACCOUNT.DETAILS<AA.AD.ARR.AGE.STATUS>:'*':R.Condition<AA.OD.LOCAL.REF,POS.L.LOAN.STATUS.1>:'*':R.Condition<AA.OD.LOCAL.REF,POS.L.LOAN.COND>:'*':ABS(Y.FINAL.DEL.TOTAL):'*':ABS(Y.FINAL.DUE.TOTAL):@FM
        VAR3++
    REPEAT
RETURN
*----------------------------------------------------------------------
TOTAL.DEL.BAL:
*----------------------------------------------------------------------
* Here Deliquent Balance of the arrangement are calculated here
*TUS change START
*IN.ARR.ID=Y.ARRANGEMENT.ID
*IN.ACC.ID=''
*OUT.ID=''
*CALL REDO.CHANGE.ACCOUNT(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)
*    SEL.CMD.ACCT='SSELECT ':FN.ACCT.ACTIVITY:' WITH @ID LIKE '
*    VAR1=1
*    LOOP
*    WHILE VAR1 LE SEL.NO.LOOKUP
*        IF VAR1 EQ SEL.NO.LOOKUP THEN
*            SEL.CMD.ACCT:=OUT.ID:'.':FIELD(SEL.LOOKUP<VAR1>,'*',2):'...'
*        END ELSE
*            SEL.CMD.ACCT:=OUT.ID:'.':FIELD(SEL.LOOKUP<VAR1>,'*',2):'... OR @ID LIKE '
*        END
*        VAR1++
*    REPEAT
*    CALL EB.READLIST(SEL.CMD.ACCT,SEL.LIST.ACCT,'',SEL.NOR.ACCT,SEL.RET)
*    Y.EXST.ID=''
*    VAR1=1
*    LOOP
*    WHILE VAR1 LE SEL.NOR.ACCT
*        Y.ACCT.ID = SEL.LIST.ACCT<VAR1>
*        Y.MID.VAL = FIELD(Y.ACCT.ID,'.',2)
*        Y.MID.VAL = FIELD(Y.MID.VAL,'-',1)
*        LOCATE Y.MID.VAL IN Y.EXST.ID SETTING POS1 THEN
*            Y.OUT.ARRAY<POS1>=Y.ACCT.ID
*        END ELSE
*            Y.OUT.ARRAY<-1>=Y.ACCT.ID
*            Y.EXST.ID<-1>=Y.MID.VAL
*        END
*        VAR1 += 1
*    REPEAT
    Y.FINAL.TOTAL=0
*    GOSUB AMT.CALC.FINAL
    TOT.BAL = COUNT(R.ECB<ECB.CURR.ASSET.TYPE>,@VM) + 1
    FOR BAL.TYPE.POS = 1 TO TOT.BAL
        Y.BAL.TYPE = ''
        Y.BAL.TYPE = R.ECB<ECB.TYPE.SYSDATE,BAL.TYPE.POS>

        IF Y.BAL.TYPE THEN
            BAL.PREFIX = Y.BAL.TYPE[1,3]
            IF BAL.PREFIX MATCHES SEL.LOOKUP AND BAL.PREFIX NE 'CUR' THEN
                GOSUB GET.BAL
                IF Y.AMT THEN
                    Y.FINAL.TOTAL=Y.FINAL.TOTAL+Y.AMT
                END
            END
        END
    NEXT BAL.TYPE.POS

*TUS change END
    Y.FINAL.DEL.TOTAL=Y.FINAL.TOTAL
RETURN
*----------------------------------------------------------------------
TOTAL.DUE.BAL:
*----------------------------------------------------------------------
* Here Due Balance of the arrangement are calculated here
*TUS change START
*    SEL.CMD.DUE='SSELECT ':FN.ACCT.ACTIVITY:' WITH @ID LIKE ':OUT.ID:'.DUE...'
*    CALL EB.READLIST(SEL.CMD.DUE,SEL.LIST.DUE,'',SEL.NOR.DUE,SEL.RET)
*    Y.EXST.ID=''
*    VAR1=1
*    LOOP
*    WHILE VAR1 LE SEL.NOR.DUE
*        Y.ACCT.ID = SEL.LIST.DUE<VAR1>
*        Y.MID.VAL = FIELD(Y.ACCT.ID,'.',2)
*        Y.MID.VAL = FIELD(Y.MID.VAL,'-',1)
*        LOCATE Y.MID.VAL IN Y.EXST.ID SETTING POS1 THEN
*            Y.OUT.ARRAY<POS1>=Y.ACCT.ID
*        END ELSE
*            Y.OUT.ARRAY<-1>=Y.ACCT.ID
*            Y.EXST.ID<-1>=Y.MID.VAL
*        END
*        VAR1 += 1
*    REPEAT
    Y.FINAL.TOTAL=0
*    GOSUB AMT.CALC.FINAL
    TOT.BAL = COUNT(R.ECB<ECB.CURR.ASSET.TYPE>,@VM) + 1
    FOR BAL.TYPE.POS = 1 TO TOT.BAL
        Y.BAL.TYPE = ''
        Y.BAL.TYPE = R.ECB<ECB.TYPE.SYSDATE,BAL.TYPE.POS>

        IF Y.BAL.TYPE THEN
            BAL.PREFIX = Y.BAL.TYPE[1,3]
            IF BAL.PREFIX MATCHES 'DUE' THEN
                GOSUB GET.BAL
                IF Y.AMT THEN
                    Y.FINAL.TOTAL=Y.FINAL.TOTAL+Y.AMT
                END
            END
        END
    NEXT BAL.TYPE.POS

*TUS change END
    Y.FINAL.DUE.TOTAL=Y.FINAL.TOTAL

RETURN

*----------------------------------------------------------------------
GET.ECB:
*----------------------------------------------------------------------
    IN.ARR.ID=Y.ARRANGEMENT.ID
    IN.ACC.ID=''
    OUT.ID=''
    CALL REDO.CHANGE.ACCOUNT(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)

    R.ECB = ''
    CALL F.READ(FN.ECB,OUT.ID,R.ECB,F.ECB,E.ECB);*;* R22 Manual conversion
    CALL AA.CONSOLIDATE.ECB.AMOUNTS(R.ECB)

RETURN

*----------------------------------------------------------------------
GET.BAL:
*----------------------------------------------------------------------

    DATE.OPTIONS = ''
    EFFECTIVE.DATE = TODAY
    DATE.OPTIONS<4>  = 'ECB'
    BAL.DETAILS = ''
    Y.AMT = ""
*CALL AA.GET.PERIOD.BALANCES(OUT.ID, Y.BAL.TYPE, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "")
    AA.Framework.GetPeriodBalances(OUT.ID, Y.BAL.TYPE, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "");* R22 AUTO CONVERSION
    Y.AMT=BAL.DETAILS<IC.ACT.BALANCE>

RETURN
*----------------------------------------------------------------------
AMT.CALC.FINAL:
*----------------------------------------------------------------------
    Y.OUT.ARRAY.COUNT= DCOUNT(Y.OUT.ARRAY,@FM)
    VAR2=1
    LOOP
    WHILE VAR2 LE Y.OUT.ARRAY.COUNT
        Y.ACCT.REC.ID=Y.OUT.ARRAY<VAR2>
        CALL F.READ(FN.ACCT.ACTIVITY,Y.ACCT.REC.ID,R.ACCT.ACTIVITY,F.ACCT.ACTIVITY,ACCT.ERR)
        Y.BAL.CNT=DCOUNT(R.ACCT.ACTIVITY<IC.ACT.BK.BALANCE>,@VM)
        Y.FINAL.TOTAL+=R.ACCT.ACTIVITY<IC.ACT.BK.BALANCE,Y.BAL.CNT>
        VAR2++
    REPEAT
RETURN
END
