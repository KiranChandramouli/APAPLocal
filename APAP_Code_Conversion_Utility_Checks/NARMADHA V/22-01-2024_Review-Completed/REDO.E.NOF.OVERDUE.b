* @ValidationCode : MjotMTM3NDI1MjcyMzpVVEYtODoxNzA1OTE3MzAwOTAwOkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 22 Jan 2024 15:25:00
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
SUBROUTINE REDO.E.NOF.OVERDUE(Y.OUT.ARRAY)
*----------------------------------------------------------------------------------------
*Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By : Temenos Application Management
*Program Name : REDO.E.NOF.LOAN.OVERDUE.REPORT
*----------------------------------------------------------------------------------------
*Description : REDO.E.NOF.LOAN.OVERDUE.REPORT is a no-file enquiry routine for the
* enquiry REDO.APAP.NOF.LOAN.OVERDUE.RPT, the routine based on the
* selection criteria selects the records from respective files and displays the processed records
*Linked With : Enquiry REDO.OVERDUE.LOAN.REPORT.ONLINE
*In Parameter : N/A
*Out Parameter : Y.OUT.DATA
*----------------------------------------------------------------------------------------
* Modification History :
* Date Who Reference Description
*----------------------------------------------------------------------------------------
*16-02-2012 Jeeva T R.168 PACS00153533
*25-01-2013 Shekar performance
* - do not fetch balance multiple times
* - fetch balance only if available in ECB
* - cache read redo.loan.status
* - do not read alternate.account go get account number, it is available in aa.arrangement which is read
*  DATE             WHO                   REFERENCE
* 12-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM , ++ to += , = to EQ and VM to @VM
* 12-APRIL-2023      Harsha                R22 Manual Conversion - call rtn formate modified
* 19-01-2024        Narmadha V    R22 Utility Changes,Manual R22 Conversion - Call routine format modified
*------------------------------------------------------------------------
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*$INSERT I_F.AA.ARRANGEMENT ;*Manual R22 Conversion
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.ALTERNATE.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.PROPERTY
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.REDO.OVERDUE.STATUS
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
    $INSERT I_F.REDO.PRODUCT.GROUP
    $INSERT I_F.REDO.LOAN.STATUS
    $USING APAP.TAM
    $USING APAP.AA
    $USING EB.LocalReferences ;*Manual R22 Conversion
    $USING AA.Framework ;*Manual R22 Conversion
*----------------------------------------------------------------------------------------
MAIN.LOGIC:

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB GET.LOCAL.REF
    GOSUB PROCESS
    GOSUB FORM.FINAL.ARRAY
RETURN
*----------------------------------------------------------------------------------------
INITIALIZE:
*----------------------------------------------------------------------------------------
    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS' ; F.AA.ACCOUNT.DETAILS = ''
    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT" ; F.AA.ARRANGEMENT = ''
    R.AA.ARRANGEMENT = '' ; R.ACCOUNT.DETAILS = ''
    Y.GROUP.LIST = '' ; Y.GROUP.LIST = ''
    FN.REDO.PRODUCT.GROUP = 'F.REDO.PRODUCT.GROUP' ; F.REDO.PRODUCT.GROUP = ''
    R.REDO.PRODUCT.GROUP = '' ; Y.MORA = ''
    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT' ; F.ALTERNATE.ACCOUNT = ''
    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    R.ALTERNATE.ACCOUNT = '' ; Y.DE1.VALUE = ''
    Y.GROUP.LIST.DE1 = '' ; Y.DE1.WRITE.OFF = '' ; Y.DE1.MORA = ''
    Y.DE1.INTEREST = '' ; Y.DE1.PRINCIPAL ='' ; Y.DEL.VALUE = ''
    Y.GROUP.LIST.DEL = '' ; Y.DEL.WRITE.OFF = '' ; Y.DEL.MORA = '' ; Y.DEL.INTEREST = ''
    Y.DEL.PRINCIPAL = '' ; Y.NAB.VALUE ='' ; Y.GROUP.LIST.NAB = '' ; Y.NAB.WRITE.OFF = ''
    Y.NAB.MORA = '' ; Y.NAB.INTEREST = '' ; Y.NAB.PRINCIPAL = '' ; Y.CUR.VALUE = ''
    Y.GROUP.LIST.CUR = '' ; Y.CUR.WRITE.OFF = '' ;Y.CUR.MORA = '' ; Y.CUR.INTEREST =''
    Y.CUR.PRINCIPAL = '' ; REQUEST.TYPE = '' ; END.DATE ='' ; START.DATE = ''
    Y.WR.PRINCIPAL = '' ; Y.WR.INTEREST = '' ; Y.WR.MORA = '' ; Y.WR.WRITE.OFF = ''
    Y.GROUP.LIST.WR = '' ; Y.WR.VALUE = '' ; Y.RES.PRINCIPAL = '' ; Y.RES.INTEREST =''
    Y.RES.MORA = '' ; Y.RES.WRITE.OFF = '' ; Y.GROUP.LIST.RES = '' ; Y.RES.VALUE ='' ; Y.JUD.PRINCIPAL = ''
    Y.JUD.INTEREST = '' ; Y.JUD.MORA = ' ' ; Y.JUD.WRITE.OFF = '' ; Y.GROUP.LIST.JUD ='' ; Y.JUD.VALUE = ''
    LOAN.STATUS.VAL = '' ; FN.REDO.LOAN.STATUS = 'F.REDO.LOAN.STATUS' ; F.REDO.LOAN.STATUS = ''
    Y.FIELDS=D.FIELDS
    Y.OPERANDS=D.LOGICAL.OPERANDS
    Y.VALUE=D.RANGE.AND.VALUE

    LOCATE 'LOAN.STATUS' IN Y.FIELDS<1> SETTING POS2 THEN
        LOAN.STATUS.VAL=Y.VALUE<POS2>
    END
RETURN
*----------------------------------------------------------------------------------------
GET.LOCAL.REF:
*----------------------------------------------------------------------------------------
    LREF.APP='AA.PRD.DES.OVERDUE'
    LREF.FIELD='L.LOAN.STATUS.1'
    LREF.POS=''
*CALL GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    EB.LocalReferences.GetLocRef(LREF.APP,LREF.FIELD,LREF.POS);* R22 Utility Changes
    OD.LOAN.STATUS.POS=LREF.POS<1,1>
RETURN
*----------------------------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------------------------
    Y.DES.VAL = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT) ; CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS);
    CALL OPF(FN.REDO.PRODUCT.GROUP,F.REDO.PRODUCT.GROUP)
    CALL OPF(FN.REDO.LOAN.STATUS,F.REDO.LOAN.STATUS)
    CALL OPF(FN.EB.CONTRACT.BALANCES, F.EB.CONTRACT.BALANCES)
    IF LOAN.STATUS.VAL THEN
        CALL CACHE.READ(FN.REDO.LOAN.STATUS, LOAN.STATUS.VAL, R.REDO.LOAN.STATUS, Y.ERR) ;* Cache read redo.loan.status Shek
        Y.DES = R.REDO.LOAN.STATUS<REDO.LN.ST.DESCRIPTION>
        CHANGE '' TO @FM IN Y.DES

        FINDSTR '30' IN Y.DES SETTING POS.DES THEN
            Y.DES.VAL = 'CUR':@FM:'DE1'
        END
        IF NOT(Y.DES.VAL) THEN
            FINDSTR '31' IN Y.DES SETTING POS.DES THEN
                Y.DES.VAL = 'DEL'
            END
        END
        IF NOT(Y.DES.VAL) THEN
            FINDSTR '90' IN Y.DES SETTING POS.DES THEN
                Y.DES.VAL = 'NAB'
            END
        END
        IF NOT(Y.DES.VAL) THEN
            FINDSTR 'Judicial' IN Y.DES SETTING POS.DES THEN
                Y.DES.VAL = 'JudicialCollection'
            END
        END
        IF NOT(Y.DES.VAL) THEN
            FINDSTR 'Restructured' IN Y.DES SETTING POS.DES THEN
                Y.DES.VAL = 'Restructured'
            END
        END
        IF NOT(Y.DES.VAL) THEN
            FINDSTR 'Write-off' IN Y.DES SETTING POS.DES THEN
                Y.DES.VAL = 'Write-off'
            END
        END
    END
RETURN
*----------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------
    GOSUB GET.SELECTION.FIELDS.VALUES
    GOSUB GET.DETAILS
RETURN
*----------------------------------------------------------------------------------------
GET.SELECTION.FIELDS.VALUES:
*----------------------------------------------------------------------------------------
    SEL.CMD.ARR = "SELECT ":FN.AA.ACCOUNT.DETAILS:" WITH ARR.AGE.STATUS NE '' "
    SELECT.GROUP = "SELECT ":FN.REDO.PRODUCT.GROUP
RETURN
*----------------------------------------------------------------------------------------
GET.DETAILS:
*----------------------------------------------------------------------------------------


    CALL EB.READLIST(SEL.CMD.ARR,SEL.LIST.ARR.ID,'',NO.OF.REC.ARR,SEL.RET.ARR)
    CALL EB.READLIST(SELECT.GROUP,SEL.LIST.GROUP,'',NO.OF.REC.GR,SEL.RET.GR)
    IF NOT(SEL.LIST.ARR.ID) THEN
        RETURN
    END
    LOOP
        REMOVE Y.AA.ID FROM SEL.LIST.ARR.ID SETTING Y.AA.ARR.POS
    WHILE Y.AA.ID:Y.AA.ARR.POS
*Shek -s
* reinitialise variables
        Bal.Types = ''
        Bal.Amts = ''
        EcbRec = ''
*Shek -e
        GOSUB ALL.DETAILS
    REPEAT
RETURN
*----------------------------------------------------------------------------------------
ALL.DETAILS:
*----------------------------------------------------------------------------------------
*CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,Y.ERR.AA)
    R.AA.ARRANGEMENT = AA.Framework.Arrangement.Read(Y.AA.ID, Y.ERR.AA) ;*Manual R22 Conversion
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.ERR.AC)
    Y.ACCOUNT.STATUS = R.ACCOUNT.DETAILS<AA.AD.ARR.AGE.STATUS>
*Y.GROUP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    Y.GROUP = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrProductGroup> ;*Manual R22 Conversion
*Y.PRODUT= R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    Y.PRODUT= R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrProduct> ;*Manual R22 Conversion
*Y.CUR = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
    Y.CUR = R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrCurrency> ;*Manual R22 Conversion
*Shek -s
* Get account # from aa.arrangement
    jPos = ''
*LOCATE 'ACCOUNT' IN R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL,1> SETTING jPos THEN
    LOCATE 'ACCOUNT' IN R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrLinkedAppl,1> SETTING jPos THEN ;*Manual R22 Conversion
*Y.ACC.ID = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID,jPos>
        Y.ACC.ID = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrLinkedApplId,jPos> ;*Manual R22 Conversion
    END
*Shek -e

    GOSUB GET.LOAN.STATUS
    GOSUB CASE.SEL.VALUE
RETURN
*----------------------------------------------------------------------------------------
GET.LOAN.STATUS:
*----------------------------------------------------------------------------------------
    LS.LC.FLAG = ''
    PROP.CLASS = 'OVERDUE'
    PROPERTY = ''
    R.Condition = ''
    ERR.MSG = ''
    EFF.DATE = ''
    LS.LC.FLAG.WR = ''
    APAP.AA.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG);*R22 Manual Conversion
    LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
    GOSUB CASE.LOAN.VALUE
RETURN
*----------------------------------------------------------------------------------------
JUD.ASSIGN:
*----------------------------------------------------------------------------------------
    Y.JUD.PRINCIPAL += Y.PRINCIPAL
    Y.JUD.INTEREST += Y.INTEREST
    Y.JUD.MORA += Y.MORA
    Y.JUD.WRITE.OFF += Y.WRITE.OFF
    LOCATE Y.GROUP IN Y.GROUP.LIST.JUD SETTING POS.J THEN
        Y.PRIN = FIELD(Y.JUD.VALUE<POS.J>,"*",1) + Y.JUD.PRINCIPAL
        Y.INT = FIELD(Y.JUD.VALUE<POS.J>,"*",2) + Y.JUD.INTEREST
        Y.WRT = FIELD(Y.JUD.VALUE<POS.J>,"*",4) + Y.JUD.WRITE.OFF
        Y.MR = FIELD(Y.JUD.VALUE<POS.J>,"*",3) + Y.JUD.MORA
        Y.JUD.VALUE<POS.J> = Y.PRIN:"*":Y.INT:"*":Y.MR:"*":Y.WRT:"*":Y.GROUP
    END ELSE
        Y.PRIN = Y.JUD.PRINCIPAL
        Y.INT = Y.JUD.INTEREST
        Y.WRT = Y.JUD.WRITE.OFF
        Y.MR = Y.JUD.MORA
        Y.JUD.VALUE<-1> = Y.PRIN:"*":Y.INT:"*":Y.MR:"*":Y.WRT:"*":Y.GROUP
        Y.GROUP.LIST.JUD<-1> = Y.GROUP
    END
RETURN
*----------------------------------------------------------------------------------------
RESTR.ASSIGN:
*----------------------------------------------------------------------------------------
    Y.RES.PRINCIPAL += Y.PRINCIPAL
    Y.RES.INTEREST += Y.INTEREST
    Y.RES.MORA += Y.MORA
    Y.RES.WRITE.OFF += Y.WRITE.OFF
    LOCATE Y.GROUP IN Y.GROUP.LIST.RES SETTING POS.R THEN
        Y.PRIN = FIELD(Y.RES.VALUE<POS.R>,"*",1) + Y.RES.PRINCIPAL
        Y.INT = FIELD(Y.RES.VALUE<POS.R>,"*",2) + Y.RES.INTEREST
        Y.WRT = FIELD(Y.RES.VALUE<POS.R>,"*",4) + Y.RES.WRITE.OFF
        Y.MR = FIELD(Y.RES.VALUE<POS.R>,"*",3) + Y.RES.MORA
        Y.RES.VALUE<POS.R> = Y.PRIN:"*":Y.INT:"*":Y.MR:"*":Y.WRT:"*":Y.GROUP
    END ELSE
        Y.PRIN = Y.RES.PRINCIPAL
        Y.INT = Y.RES.INTEREST
        Y.WRT = Y.RES.WRITE.OFF
        Y.MR = Y.RES.MORA
        Y.RES.VALUE<-1> = Y.PRIN:"*":Y.INT:"*":Y.MR:"*":Y.WRT:"*":Y.GROUP
        Y.GROUP.LIST.RES<-1> = Y.GROUP
    END
RETURN
*----------------------------------------------------------------------------------------
WRITE.ASSIGNE:
*----------------------------------------------------------------------------------------
    Y.WR.PRINCIPAL += Y.PRINCIPAL
    Y.WR.INTEREST += Y.INTEREST
    Y.WR.MORA += Y.MORA
    Y.WR.WRITE.OFF += Y.WRITE.OFF
    LOCATE Y.GROUP IN Y.GROUP.LIST.WR SETTING POS.W THEN
        Y.PRIN = FIELD(Y.WR.VALUE<POS.W>,"*",1) + Y.WR.PRINCIPAL
        Y.INT = FIELD(Y.WR.VALUE<POS.W>,"*",2) + Y.WR.INTEREST
        Y.WRT = FIELD(Y.WR.VALUE<POS.W>,"*",4) + Y.WR.WRITE.OFF
        Y.MR = FIELD(Y.WR.VALUE<POS.W>,"*",3) + Y.WR.MORA
        Y.WR.VALUE<POS.W> = Y.PRIN:"*":Y.INT:"*":Y.MR:"*":Y.WRT:"*":Y.GROUP
    END ELSE
        Y.PRIN = Y.WR.PRINCIPAL
        Y.INT = Y.WR.INTEREST
        Y.WRT = Y.WR.WRITE.OFF
        Y.MR = Y.WR.MORA
        Y.WR.VALUE<-1> = Y.PRIN:"*":Y.INT:"*":Y.MR:"*":Y.WRT:"*":Y.GROUP
        Y.GROUP.LIST.WR<-1> = Y.GROUP
    END
RETURN
*----------------------------------------------------------------------------------------
CASE.LOAN.VALUE:
*----------------------------------------------------------------------------------------
    BEGIN CASE
        CASE LOAN.STATUS EQ 'JudicialCollection'
            IF Y.DES.VAL THEN
                IF Y.DES.VAL EQ LOAN.STATUS THEN
                    GOSUB TOTAL.AMT.VAL
                    GOSUB JUD.ASSIGN
                END
            END ELSE
                GOSUB TOTAL.AMT.VAL
                GOSUB JUD.ASSIGN
            END
        CASE LOAN.STATUS EQ 'Restructured'
            IF Y.DES.VAL THEN
                IF Y.DES.VAL EQ LOAN.STATUS THEN
                    GOSUB TOTAL.AMT.VAL
                    GOSUB RESTR.ASSIGN
                END
            END ELSE
                GOSUB TOTAL.AMT.VAL
                GOSUB RESTR.ASSIGN
            END
        CASE LOAN.STATUS EQ 'Write-off'

            IF Y.DES.VAL THEN
                IF Y.DES.VAL EQ LOAN.STATUS THEN
                    GOSUB TOTAL.AMT.VAL
                    GOSUB WRITE.ASSIGNE
                END
            END ELSE
                GOSUB TOTAL.AMT.VAL
                GOSUB WRITE.ASSIGNE
            END
    END CASE
RETURN
*----------------------------------------------------------------------------------------
CUR.ASSIGN:
*----------------------------------------------------------------------------------------
    Y.CUR.PRINCIPAL += Y.PRINCIPAL
    Y.CUR.INTEREST += Y.INTEREST
    Y.CUR.MORA += Y.MORA
    Y.CUR.WRITE.OFF += Y.WRITE.OFF
    LOCATE Y.GROUP IN Y.GROUP.LIST.CUR SETTING POS.S THEN
        Y.PRIN = FIELD(Y.CUR.VALUE<POS.S>,"*",1) + Y.CUR.PRINCIPAL
        Y.INT = FIELD(Y.CUR.VALUE<POS.S>,"*",2) + Y.CUR.INTEREST
        Y.WRT = FIELD(Y.CUR.VALUE<POS.S>,"*",4) + Y.CUR.WRITE.OFF
        Y.MR = FIELD(Y.CUR.VALUE<POS.S>,"*",3) + Y.CUR.MORA
        Y.CUR.VALUE<POS.S> = Y.PRIN:"*":Y.INT:"*":Y.MR:"*":Y.WRT:"*":Y.GROUP
    END ELSE
        Y.PRIN = Y.CUR.PRINCIPAL
        Y.INT = Y.CUR.INTEREST
        Y.WRT = Y.CUR.WRITE.OFF
        Y.MR = Y.CUR.MORA
        Y.CUR.VALUE<-1> = Y.PRIN:"*":Y.INT:"*":Y.MR:"*":Y.WRT:"*":Y.GROUP
        Y.GROUP.LIST.CUR<-1> = Y.GROUP
    END
RETURN
*----------------------------------------------------------------------------------------
DE1.ASSIGN:
*----------------------------------------------------------------------------------------
    Y.CUR.PRINCIPAL += Y.PRINCIPAL
    Y.CUR.INTEREST += Y.INTEREST
    Y.CUR.MORA += Y.MORA
    Y.CUR.WRITE.OFF += Y.WRITE.OFF
    LOCATE Y.GROUP IN Y.GROUP.LIST.CUR SETTING POS.S THEN
        Y.PRIN = FIELD(Y.CUR.VALUE<POS.S>,"*",1) + Y.CUR.PRINCIPAL
        Y.INT = FIELD(Y.CUR.VALUE<POS.S>,"*",2) + Y.CUR.INTEREST
        Y.WRT = FIELD(Y.CUR.VALUE<POS.S>,"*",4) + Y.CUR.WRITE.OFF
        Y.MR = FIELD(Y.CUR.VALUE<POS.S>,"*",3) + Y.CUR.MORA
        Y.CUR.VALUE<POS.S> = Y.PRIN:"*":Y.INT:"*":Y.MR:"*":Y.WRT:"*":Y.GROUP
    END ELSE
        Y.PRIN = Y.CUR.PRINCIPAL
        Y.INT = Y.CUR.INTEREST
        Y.WRT = Y.CUR.WRITE.OFF
        Y.MR = Y.CUR.MORA
        Y.CUR.VALUE<-1> = Y.PRIN:"*":Y.INT:"*":Y.MR:"*":Y.WRT:"*":Y.GROUP
        Y.GROUP.LIST.CUR<-1> = Y.GROUP
    END
RETURN
*----------------------------------------------------------------------------------------
DEL.ASSIGN:
*----------------------------------------------------------------------------------------
    Y.DEL.PRINCIPAL += Y.PRINCIPAL
    Y.DEL.INTEREST += Y.INTEREST
    Y.DEL.MORA += Y.MORA
    Y.DEL.WRITE.OFF += Y.WRITE.OFF
    LOCATE Y.GROUP IN Y.GROUP.LIST.DEL SETTING POS.S THEN

        Y.PRIN = FIELD(Y.DEL.VALUE<POS.S>,"*",1) + Y.DEL.PRINCIPAL
        Y.INT = FIELD(Y.DEL.VALUE<POS.S>,"*",2) + Y.DEL.INTEREST
        Y.WRT = FIELD(Y.DEL.VALUE<POS.S>,"*",4) + Y.DEL.WRITE.OFF
        Y.MR = FIELD(Y.DEL.VALUE<POS.S>,"*",3) + Y.DEL.MORA
        Y.DEL.VALUE<POS.S> = Y.PRIN:"*":Y.INT:"*":Y.MR:"*":Y.WRT:"*":Y.GROUP
    END ELSE
        Y.PRIN = Y.DEL.PRINCIPAL
        Y.INT = Y.DEL.INTEREST
        Y.WRT = Y.DEL.WRITE.OFF
        Y.MR = Y.DEL.MORA
        Y.DEL.VALUE<-1> = Y.PRIN:"*":Y.INT:"*":Y.MR:"*":Y.WRT:"*":Y.GROUP
        Y.GROUP.LIST.DEL<-1> = Y.GROUP
    END
RETURN
*----------------------------------------------------------------------------------------
NAB.ASSIGNE:
*----------------------------------------------------------------------------------------
    Y.NAB.PRINCIPAL += Y.PRINCIPAL
    Y.NAB.INTEREST += Y.INTEREST
    Y.NAB.MORA += Y.MORA
    Y.NAB.WRITE.OFF += Y.WRITE.OFF
    LOCATE Y.GROUP IN Y.GROUP.LIST.NAB SETTING POS.S THEN
        Y.PRIN = FIELD(Y.NAB.VALUE<POS.S>,"*",1) + Y.NAB.PRINCIPAL
        Y.INT = FIELD(Y.NAB.VALUE<POS.S>,"*",2) + Y.NAB.INTEREST
        Y.WRT = FIELD(Y.NAB.VALUE<POS.S>,"*",4) + Y.NAB.WRITE.OFF
        Y.MR = FIELD(Y.NAB.VALUE<POS.S>,"*",3) + Y.NAB.MORA
        Y.NAB.VALUE<POS.S> = Y.PRIN:"*":Y.INT:"*":Y.MR:"*":Y.WRT:"*":Y.GROUP
    END ELSE
        Y.PRIN = Y.NAB.PRINCIPAL
        Y.INT = Y.NAB.INTEREST
        Y.WRT = Y.NAB.WRITE.OFF
        Y.MR = Y.NAB.MORA
        Y.NAB.VALUE<-1> = Y.PRIN:"*":Y.INT:"*":Y.MR:"*":Y.WRT:"*":Y.GROUP
        Y.GROUP.LIST.NAB<-1> = Y.GROUP
    END
RETURN
*----------------------------------------------------------------------------------------
CASE.SEL.VALUE:
*----------------------------------------------------------------------------------------
    BEGIN CASE
        CASE Y.ACCOUNT.STATUS EQ 'CUR'
            IF Y.DES.VAL THEN
                LOCATE Y.ACCOUNT.STATUS IN Y.DES.VAL SETTING POS.DE THEN
                    GOSUB TOTAL.AMT.VAL
                    GOSUB CUR.ASSIGN
                END
            END ELSE
                GOSUB TOTAL.AMT.VAL
                GOSUB CUR.ASSIGN
            END
        CASE Y.ACCOUNT.STATUS EQ 'DE1'
            IF Y.DES.VAL THEN
                LOCATE Y.ACCOUNT.STATUS IN Y.DES.VAL SETTING POS.DE THEN
                    GOSUB TOTAL.AMT.VAL
                    GOSUB DE1.ASSIGN
                END
            END ELSE
                GOSUB TOTAL.AMT.VAL
                GOSUB DE1.ASSIGN
            END
        CASE Y.ACCOUNT.STATUS EQ 'DEL'
            IF Y.DES.VAL THEN
                IF Y.DES.VAL EQ Y.ACCOUNT.STATUS THEN
                    GOSUB TOTAL.AMT.VAL
                    GOSUB DEL.ASSIGN
                END
            END ELSE
                GOSUB TOTAL.AMT.VAL
                GOSUB DEL.ASSIGN
            END

        CASE Y.ACCOUNT.STATUS EQ 'NAB'
            IF Y.DES.VAL THEN
                IF Y.DES.VAL EQ Y.ACCOUNT.STATUS THEN
                    GOSUB TOTAL.AMT.VAL
                    GOSUB NAB.ASSIGNE
                END
            END ELSE
                GOSUB TOTAL.AMT.VAL
                GOSUB NAB.ASSIGNE
            END
    END CASE
RETURN
*-------------------------------------------------------------------------------
GET.PERIOD.BALANCES:
*-------------------------------------------------------------------------------
*Shek -s
* do not read alternate.account to get account id. this is available in AA.ARRANGEMENT
* commenting below 2 lines
*- CALL F.READ(FN.ALTERNATE.ACCOUNT,Y.AA.ID,R.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT,ALT.ERR)
*- Y.ACC.ID = R.ALTERNATE.ACCOUNT

*Shek -e

    Y.AMT = 0
    LOOP REMOVE Y.BAL FROM BALANCE.TO.CHECK SETTING BAL.POS
    WHILE Y.BAL:BAL.POS
*Shek -s
* DO NOT Get balance multiple times. save the details after 1st execution and reuse
        sPos = ''
        LOCATE Y.BAL IN Bal.Types<1> SETTING sPos THEN
            Y.AMT += Bal.Amts<sPos>
        END ELSE

* check if ECB has balance type, else do not execute aa.get.period.balances
            IF EcbRec EQ '' THEN
                Err = ''
                CALL F.READ(FN.EB.CONTRACT.BALANCES, Y.ACC.ID, EcbRec, F.EB.CONTRACT.BALANCES, Err)
            END
            aPos = ''
            LOCATE Y.BAL IN EcbRec<ECB.CURR.ASSET.TYPE,1> SETTING aPos THEN
*Shek -e
                REQUEST.TYPE<4>='ECB'
*CALL AA.GET.PERIOD.BALANCES (Y.ACC.ID, Y.BAL, REQUEST.TYPE, START.DATE, END.DATE, SYSTEM.DATE, BAL.DETAILS, ERR.MSG)
                AA.Framework.GetPeriodBalances (Y.ACC.ID, Y.BAL, REQUEST.TYPE, START.DATE, END.DATE, SYSTEM.DATE, BAL.DETAILS, ERR.MSG);* R22 Utility Changes
                Y.AMT += ABS(BAL.DETAILS<4>)
            END ELSE
                BAL.DETAILS<4> = 0
            END
*Shek -s
* update the array
            Bal.Types<-1> = Y.BAL
            Bal.Amts<-1> = ABS(BAL.DETAILS<4>)
        END
*Shek -e
    REPEAT

RETURN
*----------------------------------------------------------------------------------------
TOTAL.AMT.VAL:
*----------------------------------------------------------------------------------------
    Y.PROV.INETREST.SP = ''
    BALANCE.TO.CHECK = 'CURACCOUNT':@VM:'DUEACCOUNT':@VM:'DELACCOUNT':@VM:'DE1ACCOUNT':@VM:'GRCACCOUNT':@VM:'NABACCOUNT'
    GOSUB GET.PERIOD.BALANCES
    Y.PRINCIPAL = Y.AMT
    BALANCE.TO.CHECK = 'ACCPRINCIPALINT':@VM:'DUEPRINCIPALINT':@VM:'ACCPENALTYINT':@VM:'GRCPRINCIPALINT':@VM:'DELPRINCIPALINT':@VM:'NABPRINCIPALINT':@VM:'DE1PRINCIPALINT'
    GOSUB GET.PERIOD.BALANCES
    Y.INTEREST = Y.AMT
    BALANCE.TO.CHECK = 'ACCPRINCIPALINTSP':@VM:'DUEPRINCIPALINTSP':@VM:'ACCPENALTYINTSP':@VM:'GRCPRINCIPALINTSP':@VM:'DELPRINCIPALINTSP':@VM:'NABPRINCIPALINTSP'
    GOSUB GET.PERIOD.BALANCES
    Y.WRITE.OFF = Y.AMT
    GOSUB GET.CHARGE
    GOSUB GET.PERIOD.BALANCES
    Y.MORA = Y.AMT
RETURN
*----------------------------------------------------------------------------------------
GET.CHARGE:
*----------------------------------------------------------------------------------------
    BALANCE.TO.CHECK = ''
    PROPERTY.CLASS = 'CHARGE'
    PRODUCT.ID = Y.PRODUT
    ARR.CURRENCY = Y.CUR
    EFFECTIVE.DATE = TODAY
    PROD.PROP.LIST = ''
    PROD.PROP.CLASS.LIST = ''
    PROD.PROP.LINK.TYPE = ''
    PROD.PROP.CONDITION.LIST = ''
    ARR.LINK = ''
    RET.ERR = ''
    Y.CNT.PR = 1
    CALL AA.GET.PRODUCT.CONDITION.RECORDS(PRODUCT.ID, ARR.CURRENCY, EFFECTIVE.DATE, PROD.PROP.LIST, PROD.PROP.CLASS.LIST, PROD.PROP.LINK.TYPE,PROD.PROP.CONDITION.LIST, RET.ERR)
    LOOP
    WHILE Y.CNT.PR LE DCOUNT(PROD.PROP.LIST,@FM)
        IF PROD.PROP.CLASS.LIST<Y.CNT.PR> EQ 'CHARGE' THEN
            BALANCE.TO.CHECK<-1> = 'DUE':PROD.PROP.LIST<Y.CNT.PR>
        END
        Y.CNT.PR += 1
    REPEAT
RETURN
*----------------------------------------------------------------------------------------
FORM.FINAL.ARRAY:
*----------------------------------------------------------------------------------------


    Y.OUT.ARRAY = ''
    Y.TOT.PRIC = 0
    Y.TOT.INT = 0
    IF Y.CUR.VALUE THEN
        Y.CUR.VALUE.CNT = 1
        Y.OUT.ARRAY<-1> = "*****":'VIGENTE 0 - 30'

        Y.OUT.ARRAY<-1> = "******Capital *Interest*Mora*Suspendido"
        Y.OUT.ARRAY<-1> = "*Capital *Interest*Mora*Suspendido"
        LOOP
        WHILE Y.CUR.VALUE.CNT LE DCOUNT(Y.CUR.VALUE,@FM)
            Y.CUR.LIST = Y.CUR.VALUE
* 1 2 3 4
            Y.OUT.ARRAY<-1> = FIELD(Y.CUR.LIST<Y.CUR.VALUE.CNT>,"*",5):"*":FMT(FIELD(Y.CUR.LIST<Y.CUR.VALUE.CNT>,"*",1),'R2,'):"*":FMT(FIELD(Y.CUR.LIST<Y.CUR.VALUE.CNT>,"*",2),'R2,'):"*":FMT(FIELD(Y.CUR.LIST<Y.CUR.VALUE.CNT>,"*",3),'R2,'):"*":FMT(FIELD(Y.CUR.LIST<Y.CUR.VALUE.CNT>,"*",4),'R2,')
            Y.CUR.VALUE.CNT += 1
            Y.CUR = ''
        REPEAT
        Y.SUM.PRINC = FMT(SUM(FIELDS(Y.CUR.LIST,"*",1,1)),'R2,')
        Y.SUM.INT = FMT(SUM(FIELDS(Y.CUR.LIST,"*",2,1)),'R2,')
        Y.SUM.MORA = FMT(SUM(FIELDS(Y.CUR.LIST,"*",3,1)),'R2,')
        Y.SUM.WR = FMT(SUM(FIELDS(Y.CUR.LIST,"*",4,1)),'R2,')
        Y.OUT.ARRAY<-1> = "*":Y.SUM.PRINC:"*":Y.SUM.INT:"*":Y.SUM.MORA:"*":Y.SUM.WR:"*":"Sub Total :"
        Y.SUM.PRINC = 0 ; Y.SUM.INT = 0 ; Y.SUM.MORA = 0 ; Y.SUM.WR = 0
        Y.TOT.PRIC = Y.TOT.PRIC + SUM(FIELDS(Y.CUR.LIST,"*",1,1))
        Y.TOT.INT = Y.TOT.INT + SUM(FIELDS(Y.CUR.LIST,"*",2,1))
    END
    IF Y.DEL.VALUE THEN
        Y.DEL = 'DEL'
        Y.DEL.VALUE.CNT = 1
        Y.OUT.ARRAY<-1>= "*****":'VENCIDO 31 - 90'
        Y.OUT.ARRAY<-1> = "*Capital *Interest*Mora*Suspendido"
        LOOP
        WHILE Y.DEL.VALUE.CNT LE DCOUNT(Y.DEL.VALUE,@FM)
            Y.DEL.LIST = Y.DEL.VALUE
* 1 2 3 4
            Y.OUT.ARRAY<-1> = FIELD(Y.DEL.LIST<Y.DEL.VALUE.CNT>,"*",5):"*":FMT(FIELD(Y.DEL.LIST<Y.DEL.VALUE.CNT>,"*",1),'R2,'):"*":FMT(FIELD(Y.DEL.LIST<Y.DEL.VALUE.CNT>,"*",2),'R2,'):"*":FMT(FIELD(Y.DEL.LIST<Y.DEL.VALUE.CNT>,"*",3),'R2,'):"*":FMT(FIELD(Y.DEL.LIST<Y.DEL.VALUE.CNT>,"*",4),'R2,')
            Y.DEL.VALUE.CNT += 1
        REPEAT
        Y.SUM.PRINC = FMT(SUM(FIELDS(Y.DEL.LIST,"*",1,1)),'R2,')
        Y.SUM.INT = FMT(SUM(FIELDS(Y.DEL.LIST,"*",2,1)),'R2,')
        Y.SUM.MORA = FMT(SUM(FIELDS(Y.DEL.LIST,"*",3,1)),'R2,')
        Y.SUM.WR = FMT(SUM(FIELDS(Y.DEL.LIST,"*",4,1)),'R2,')
        Y.OUT.ARRAY<-1> = "*":Y.SUM.PRINC:"*":Y.SUM.INT:"*":Y.SUM.MORA:"*":Y.SUM.WR:"*":"Sub Total :"
        Y.SUM.PRINC = 0 ; Y.SUM.INT = 0 ; Y.SUM.MORA = 0 ; Y.SUM.WR = 0
        Y.TOT.PRIC = Y.TOT.PRIC + SUM(FIELDS(Y.DEL.LIST,"*",1,1))
        Y.TOT.INT = Y.TOT.INT + SUM(FIELDS(Y.DEL.LIST,"*",2,1))
    END
    IF Y.NAB.VALUE THEN
        Y.NAB.VALUE.CNT = 1
        Y.OUT.ARRAY<-1> = "*****":'VENCIDO MAS DE 90'
        Y.OUT.ARRAY<-1> = "*Capital *Interest*Mora*Suspendido"
        LOOP
        WHILE Y.NAB.VALUE.CNT LE DCOUNT(Y.NAB.VALUE,@FM)
            Y.NAB.LIST = Y.NAB.VALUE

            Y.OUT.ARRAY<-1> = FIELD(Y.NAB.LIST<Y.NAB.VALUE.CNT>,"*",5):"*":FMT(FIELD(Y.NAB.LIST<Y.NAB.VALUE.CNT>,"*",1),'R2,'):"*":FMT(FIELD(Y.NAB.LIST<Y.NAB.VALUE.CNT>,"*",2),'R2,'):"*":FMT(FIELD(Y.NAB.LIST<Y.NAB.VALUE.CNT>,"*",3),'R2,'):"*":FMT(FIELD(Y.NAB.LIST<Y.NAB.VALUE.CNT>,"*",4),'R2,')
            Y.NAB.VALUE.CNT += 1

        REPEAT

        Y.SUM.PRINC = FMT(SUM(FIELDS(Y.NAB.LIST,"*",1,1)),'R2,')
        Y.SUM.INT = FMT(SUM(FIELDS(Y.NAB.LIST,"*",2,1)),'R2,')
        Y.SUM.MORA = FMT(SUM(FIELDS(Y.NAB.LIST,"*",3,1)),'R2,')
        Y.SUM.WR = FMT(SUM(FIELDS(Y.NAB.LIST,"*",4,1)),'R2,')
        Y.OUT.ARRAY<-1> = "*":Y.SUM.PRINC:"*":Y.SUM.INT:"*":Y.SUM.MORA:"*":Y.SUM.WR:"*":"Sub Total :"
        Y.SUM.PRINC = 0 ; Y.SUM.INT = 0 ; Y.SUM.MORA = 0 ; Y.SUM.WR = 0
        Y.TOT.PRIC = Y.TOT.PRIC + SUM(FIELDS(Y.NAB.LIST,"*",1,1))
        Y.TOT.INT = Y.TOT.INT + SUM(FIELDS(Y.NAB.LIST,"*",2,1))
    END

    IF Y.WR.VALUE THEN
        Y.WR.VALUE.CNT = 1
        Y.OUT.ARRAY<-1> = "*****":'CASTIGADO'
        Y.OUT.ARRAY<-1> = "*Capital *Interest*Mora*Suspendido"
        LOOP
        WHILE Y.WR.VALUE.CNT LE DCOUNT(Y.WR.VALUE,@FM)
            Y.OUT.ARRAY<-1> = FIELD(Y.WR.VALUE<Y.WR.VALUE.CNT>,"*",5):"*":FMT(FIELD(Y.WR.VALUE<Y.WR.VALUE.CNT>,"*",1),'R2,'):"*":FMT(FIELD(Y.WR.VALUE<Y.WR.VALUE.CNT>,"*",2),'R2,'):"*":FMT(FIELD(Y.WR.VALUE<Y.WR.VALUE.CNT>,"*",3),'R2,'):"*":FMT(FIELD(Y.WR.VALUE<Y.WR.VALUE.CNT>,"*",4),'R2,')
            Y.WR.VALUE.CNT += 1
        REPEAT

        Y.SUM.PRINC = FMT(SUM(FIELDS(Y.WR.VALUE,"*",1,1)),'R2,')
        Y.SUM.INT = FMT(SUM(FIELDS(Y.WR.VALUE,"*",2,1)),'R2,')
        Y.SUM.MORA = FMT(SUM(FIELDS(Y.WR.VALUE,"*",3,1)),'R2,')
        Y.SUM.WR = FMT(SUM(FIELDS(Y.WR.VALUE,"*",4,1)),'R2,')
        Y.OUT.ARRAY<-1> = "*":Y.SUM.PRINC:"*":Y.SUM.INT:"*":Y.SUM.MORA:"*":Y.SUM.WR:"*":"Sub Total :"
        Y.SUM.PRINC = 0 ; Y.SUM.INT = 0 ; Y.SUM.MORA = 0 ; Y.SUM.WR = 0
        Y.TOT.PRIC = Y.TOT.PRIC + SUM(FIELDS(Y.WR.VALUE,"*",1,1))
        Y.TOT.INT = Y.TOT.INT + SUM(FIELDS(Y.WR.VALUE,"*",2,1))
    END
    IF Y.RES.VALUE THEN
        Y.RES.VALUE.CNT = 1
        Y.OUT.ARRAY<-1> = "*****":'REESTRUCTURADO'
        Y.OUT.ARRAY<-1> = "*Capital *Interest*Mora*Suspendido"
        LOOP
        WHILE Y.RES.VALUE.CNT LE DCOUNT(Y.RES.VALUE,@FM)
            Y.OUT.ARRAY<-1> = FIELD(Y.RES.VALUE<Y.RES.VALUE.CNT>,"*",5):"*":FMT(FIELD(Y.RES.VALUE<Y.RES.VALUE.CNT>,"*",1),'R2,'):"*":FMT(FIELD(Y.RES.VALUE<Y.RES.VALUE.CNT>,"*",2),'R2,'):"*":FMT(FIELD(Y.RES.VALUE<Y.RES.VALUE.CNT>,"*",3),'R2,'):"*":FMT(FIELD(Y.RES.VALUE<Y.RES.VALUE.CNT>,"*",4),'R2,')
            Y.RES.VALUE.CNT += 1
        REPEAT

        Y.SUM.PRINC = FMT(SUM(FIELDS(Y.RES.VALUE,"*",1,1)),'R2,')
        Y.SUM.INT = FMT(SUM(FIELDS(Y.RES.VALUE,"*",2,1)),'R2,')
        Y.SUM.MORA = FMT(SUM(FIELDS(Y.RES.VALUE,"*",3,1)),'R2,')
        Y.SUM.WR = FMT(SUM(FIELDS(Y.RES.VALUE,"*",4,1)),'R2,')
        Y.OUT.ARRAY<-1> = "*":Y.SUM.PRINC:"*":Y.SUM.INT:"*":Y.SUM.MORA:"*":Y.SUM.WR:"*":"Sub Total :"
        Y.SUM.PRINC = 0 ; Y.SUM.INT = 0 ; Y.SUM.MORA = 0 ; Y.SUM.WR = 0
        Y.TOT.PRIC = Y.TOT.PRIC + SUM(FIELDS(Y.RES.VALUE,"*",1,1))
        Y.TOT.INT = Y.TOT.INT + SUM(FIELDS(Y.RES.VALUE,"*",2,1))
    END
    IF Y.JUD.VALUE THEN
        Y.JUD.VALUE.CNT = 1
        Y.OUT.ARRAY<-1> = "*****":'COBRO JUDICIAL'
        Y.OUT.ARRAY<-1> = "*Capital *Interest*Mora*Suspendido"
        LOOP
        WHILE Y.JUD.VALUE.CNT LE DCOUNT(Y.JUD.VALUE,@FM)
            Y.OUT.ARRAY<-1> = FIELD(Y.JUD.VALUE<Y.JUD.VALUE.CNT>,"*",5):"*":FMT(FIELD(Y.JUD.VALUE<Y.JUD.VALUE.CNT>,"*",1),'R2,'):"*":FMT(FIELD(Y.JUD.VALUE<Y.JUD.VALUE.CNT>,"*",2),'R2,'):"*":FMT(FIELD(Y.JUD.VALUE<Y.JUD.VALUE.CNT>,"*",3),'R2,'):"*":FMT(FIELD(Y.JUD.VALUE<Y.JUD.VALUE.CNT>,"*",4),'R2,')
            Y.JUD.VALUE.CNT += 1
        REPEAT

        Y.SUM.PRINC = FMT(SUM(FIELDS(Y.JUD.VALUE,"*",1,1)),'R2,')
        Y.SUM.INT = FMT(SUM(FIELDS(Y.JUD.VALUE,"*",2,1)),'R2,')
        Y.SUM.MORA = FMT(SUM(FIELDS(Y.JUD.VALUE,"*",3,1)),'R2,')
        Y.SUM.WR = FMT(SUM(FIELDS(Y.JUD.VALUE,"*",4,1)),'R2,')
        Y.OUT.ARRAY<-1> = "*":Y.SUM.PRINC:"*":Y.SUM.INT:"*":Y.SUM.MORA:"*":Y.SUM.WR:"*":"Sub Total :"
        Y.SUM.PRINC = 0 ; Y.SUM.INT = 0 ; Y.SUM.MORA = 0 ; Y.SUM.WR = 0
        Y.TOT.PRIC = Y.TOT.PRIC + SUM(FIELDS(Y.JUD.VALUE,"*",1,1))
        Y.TOT.INT = Y.TOT.INT + SUM(FIELDS(Y.JUD.VALUE,"*",2,1))
    END
    Y.OUT.ARRAY<-1> = "*":FMT(Y.TOT.PRIC,'R2,'):"*":FMT(Y.TOT.INT,'R2,'):"***":"Total General:"
RETURN
END
