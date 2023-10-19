* @ValidationCode : MjotMTA0MzI1MDM4NTpDcDEyNTI6MTY4MjU4MjU1MjMzMjp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Apr 2023 13:32:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.DEPOSIT.CUSTOMER.POSITION1(Y.CUS.ID.PASS,Y.ARRAY.OUT)
*------------------------------------------------------------------------
*Description : This routine is nofile enquiry routine in order to fetch the depodit
* details of the customer. This routine will fetch the details about the account
* AZ account & MM.MONEY.MARKET
*------------------------------------------------------------------------
* Input Argument : NA
* Out Argument   : Y.ARRAY.OUT
* Deals With     : ENQUIRY>REDO.DEPOSIT.CUSTOMER.POSITION
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO         REFERENCE            DESCRIPTION
* 03-MAR-2011     H GANESH  ODR-2010-10-0045 N.107   Initial Draft
* 02-MAY-2011     H GANESH      PACS00055030         Modified as per issue
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM  and ++ to +=
* 13-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.USER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.LMM.ACCOUNT.BALANCES
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.DATES
*Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*Tus End
    $USING APAP.TAM

    GOSUB INIT
    GOSUB GET.LOC.REF
    GOSUB PROCESS
RETURN

*------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------
* Variables and files are opened here

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT=''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.JOINT.CONTRACTS.XREF='F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF=''
    CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT=''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.ACCOUNT.CLOSED='F.ACCOUNT.CLOSED'
    F.ACCOUNT.CLOSED=''
    CALL OPF(FN.ACCOUNT.CLOSED,F.ACCOUNT.CLOSED)

    FN.MM.MONEY.MARKET='F.MM.MONEY.MARKET'
    F.MM.MONEY.MARKET=''
    CALL OPF(FN.MM.MONEY.MARKET,F.MM.MONEY.MARKET)

    FN.LMM.ACCOUNT.BALANCES='F.LMM.ACCOUNT.BALANCES'
    F.LMM.ACCOUNT.BALANCES=''
    CALL OPF(FN.LMM.ACCOUNT.BALANCES,F.LMM.ACCOUNT.BALANCES)

    FN.AZ.PRODUCT.PARAMETER='F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAMETER=''
    CALL OPF(FN.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER)

    FN.EB.LOOKUP='F.EB.LOOKUP'
    F.EB.LOOKUP=''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    Y.AZ.IDS=''
    Y.JOINT.HOLDER=''
    Y.ACC.STR=''
    Y.AZ.STR=''
    Y.ARRAY.OUT=''
    Y.FINAL.STR=''
    Y.MM.STR=''
    SEL.LIST.ACC=''

RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
* Here the main process of selecting the customer, after that select the products of the customer

    Y.TEMP.D.RANGE.AND.VALUE =D.RANGE.AND.VALUE
    IF Y.TEMP.D.RANGE.AND.VALUE EQ '' THEN
        RETURN
    END
    SEL.LIST.CUS = Y.CUS.ID.PASS
    IF SEL.LIST.CUS THEN
        Y.CUSTOMER.ID=SEL.LIST.CUS<1>
    END ELSE
        RETURN
    END
    GOSUB GET.ACCOUNT

    GOSUB GET.MM

RETURN
*------------------------------------------------------------------------
GET.ACCOUNT:
*------------------------------------------------------------------------
* Here Accounts hold by the customer are selected and suppose if the account is a AZ.ACCOUNT
* then details of the deposit is collected

*SEL.CMD.ACC='SELECT ':FN.ACCOUNT:' WITH CUSTOMER EQ ':Y.CUSTOMER.ID:' OR JOINT.HOLDER EQ ':Y.CUSTOMER.ID
*CALL EB.READLIST(SEL.CMD.ACC,SEL.LIST.ACC,'',NO.OF.REC.ACC,SEL.ERR)

    GOSUB GET.REINV.CATEGORY

    CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.CUSTOMER.ID,R.CUS.ACC,F.CUSTOMER.ACCOUNT,CUS.ACC.ERR)
    CALL F.READ(FN.JOINT.CONTRACTS.XREF,Y.CUSTOMER.ID,R.XREF,F.JOINT.CONTRACTS.XREF,XREF.ERR)
    SEL.LIST.ACC=R.CUS.ACC:@VM:R.XREF
    CHANGE @VM TO @FM IN SEL.LIST.ACC
    NO.OF.REC.ACC=DCOUNT(SEL.LIST.ACC,@FM)

    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE NO.OF.REC.ACC
        Y.ACC.NO=SEL.LIST.ACC<Y.VAR1>
        IF Y.ACC.NO EQ '' THEN
            Y.VAR1 += 1
            CONTINUE
        END
        R.ACC.CLOSED=''
        CALL F.READ(FN.ACCOUNT.CLOSED,Y.ACC.NO,R.ACC.CLOSED,F.ACCOUNT.CLOSED,ACC.CLOSE.ERR)
        CALL F.READ(FN.ACCOUNT,Y.ACC.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        R.ECB= '' ; ECB.ERR= '' ;*Tus Start
        CALL EB.READ.HVT("EB.CONTRACT.BALANCES",Y.ACC.NO,R.ECB,ECB.ERR);*Tus End
        CHECK.CATEG=R.ACCOUNT<AC.CATEGORY>
        LOCATE CHECK.CATEG IN Y.REINV.CATEG<1> SETTING CAT.POS THEN
            Y.VAR1 += 1
            CONTINUE
        END

        IF R.ACC.CLOSED NE '' OR R.ACCOUNT<AC.ARRANGEMENT.ID> NE '' THEN
            Y.VAR1 += 1
            CONTINUE
        END
        R.AZ.ACCOUNT=''
        CALL F.READ(FN.AZ.ACCOUNT,Y.ACC.NO,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
        IF R.AZ.ACCOUNT NE '' THEN
            GOSUB GET.AZ.ACCOUNT
            Y.VAR1 += 1
            CONTINUE
        END
        GOSUB FORM.ACC.ARR
        Y.VAR1 += 1
    REPEAT
    Y.FINAL.STR=Y.ACC.STR:Y.AZ.STR
    GOSUB FINAL.ARRAY

RETURN
*------------------------------------------------------------------------
FORM.ACC.ARR:
*------------------------------------------------------------------------
* Here we form the array of account product

    Y.ACC.STR:=Y.ACC.NO
    Y.ACC.STR:='*':R.ACCOUNT<AC.CATEGORY>
    Y.ACC.STR:='*':R.ACCOUNT<AC.SHORT.TITLE>
    IF R.ACCOUNT<AC.CUSTOMER> EQ Y.CUSTOMER.ID THEN
        Y.ACC.STR:='*'
    END ELSE
        Y.JOINT.HOLDER=R.ACCOUNT<AC.JOINT.HOLDER>
        LOCATE Y.CUSTOMER.ID IN Y.JOINT.HOLDER<1,1> SETTING POS1 THEN
            Y.RELATION.CODE=R.ACCOUNT<AC.RELATION.CODE,POS1>
            IF Y.RELATION.CODE GE 500 AND Y.RELATION.CODE LE 599 THEN
                Y.ACC.STR:='*':Y.RELATION.CODE
            END
        END
    END
* Y.ACC.STR:='*':R.ACCOUNT<AC.ONLINE.ACTUAL.BAL> ;*Tus Start
    Y.ACC.STR:='*':R.ECB<ECB.ONLINE.ACTUAL.BAL> ;*Tus End
    Y.ACC.STR:='*':R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.AV.BAL>
    Y.LOOKUP.ID= Y.VIRTUAL.TABLE:'*':R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.STATUS1>
    GOSUB GET.STATUS
    Y.ACC.STR:='*':Y.STATUS
    Y.ACC.STR:='*':R.ACCOUNT<AC.CURRENCY>
    Y.ACC.STR:='*':R.ACCOUNT<AC.OPENING.DATE>:@FM

RETURN
*------------------------------------------------------------------------
GET.AZ.ACCOUNT:
*------------------------------------------------------------------------
* Here we form the array of deposit product

    Y.AZ.STR:=Y.ACC.NO
    Y.AZ.STR:='*':R.AZ.ACCOUNT<AZ.CATEGORY>
    Y.AZ.STR:='*':R.ACCOUNT<AC.SHORT.TITLE>
    IF R.ACCOUNT<AC.CUSTOMER> EQ Y.CUSTOMER.ID THEN
        Y.AZ.STR:='*'
    END ELSE
        Y.JOINT.HOLDER=R.ACCOUNT<AC.JOINT.HOLDER>
        LOCATE Y.CUSTOMER.ID IN Y.JOINT.HOLDER<1,1> SETTING POS1 THEN
            Y.RELATION.CODE=R.ACCOUNT<AC.RELATION.CODE,POS1>
            IF Y.RELATION.CODE GE 500 AND Y.RELATION.CODE LE 599 THEN
                Y.AZ.STR:='*':Y.RELATION.CODE
            END
        END
    END
    Y.AZ.STR:='*':R.AZ.ACCOUNT<AZ.ORIG.PRINCIPAL>
    Y.INT.PAY.TYPE = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.L.TYPE.INT.PAY>
    Y.TOTAL=0
    IF Y.INT.PAY.TYPE EQ 'Reinvested' THEN
        Y.INT.LIQ.ACC=R.ACCOUNT<AC.INTEREST.LIQU.ACCT>
        CALL F.READ(FN.ACCOUNT,Y.INT.LIQ.ACC,R.INT.ACC,F.ACCOUNT,ACC.ERR)

        IF R.INT.ACC THEN
            Y.TOTAL=R.AZ.ACCOUNT<AZ.PRINCIPAL>+R.INT.ACC<AC.LOCAL.REF,POS.L.AC.AV.BAL>
        END ELSE
            Y.TOTAL=R.AZ.ACCOUNT<AZ.PRINCIPAL>
        END
    END ELSE
        Y.TOTAL=R.AZ.ACCOUNT<AZ.PRINCIPAL>
    END
    Y.AZ.STR:='*':Y.TOTAL
    Y.LOOKUP.ID= Y.VIRTUAL.TABLE:'*':R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.STATUS1>
    GOSUB GET.STATUS
    Y.AZ.STR:='*':Y.STATUS
    Y.AZ.STR:='*':R.ACCOUNT<AC.CURRENCY>
    Y.AZ.STR:='*':R.AZ.ACCOUNT<AZ.CREATE.DATE>:@FM

RETURN
*------------------------------------------------------------------------
GET.MM:
*------------------------------------------------------------------------
* Here we form the array of MM product

    SEL.CMD.MM='SELECT ':FN.MM.MONEY.MARKET:' WITH CUSTOMER.ID EQ ':Y.CUSTOMER.ID
    CALL EB.READLIST(SEL.CMD.MM,SEL.LIST.MM,'',NO.OF.REC.MM,SEL.ERR)
    Y.VAR3=1
    LOOP
    WHILE Y.VAR3 LE NO.OF.REC.MM
        Y.MM.ID=SEL.LIST.MM<Y.VAR3>
        CALL F.READ(FN.MM.MONEY.MARKET,Y.MM.ID,R.MM,F.MM.MONEY.MARKET,MM.ERR)
        Y.MM.STR:=Y.MM.ID
        Y.MM.STR:='*':R.MM<MM.CATEGORY>
        Y.DRAWDOWN.ACC=R.MM<MM.DRAWDOWN.ACCOUNT>
        CALL F.READ(FN.ACCOUNT,Y.DRAWDOWN.ACC,R.DR.ACC,F.ACCOUNT,ACC.ERR)
        Y.MM.STR:='*':R.DR.ACC<AC.SHORT.TITLE>
        Y.REL.MM=''
        IF Y.CUSTOMER.ID NE R.DR.ACC<AC.CUSTOMER> THEN
            LOCATE Y.CUSTOMER.ID IN R.DR.ACC<AC.JOINT.HOLDER,1> SETTING MM.POS THEN
                IF R.DR.ACC<AC.RELATION.CODE,MM.POS> GE 500 AND R.DR.ACC<AC.RELATION.CODE,MM.POS> LE 599 THEN
                    Y.REL.MM=R.DR.ACC<AC.RELATION.CODE,MM.POS>
                END
            END
        END
        Y.MM.STR:='*':Y.REL.MM
        Y.MM.STR:='*':R.MM<MM.PRINCIPAL>
        GOSUB GET.LMM.ACC.BAL.ID
        Y.TRANS.PRIN.AMT=R.LMM.ACCOUNT.BALANCES<LD27.TRANS.PRIN.AMT,DCOUNT(R.LMM.ACCOUNT.BALANCES<LD27.TRANS.PRIN.AMT>,@VM)>
        Y.INT.AMT.TODATE=R.LMM.ACCOUNT.BALANCES<LD27.INT.AMT.TODATE,DCOUNT(R.LMM.ACCOUNT.BALANCES<LD27.INT.AMT.TODATE>,@VM)>
        Y.MM.STR:='*':ABS(Y.TRANS.PRIN.AMT+Y.INT.AMT.TODATE)
        Y.MM.STR:='*':R.MM<MM.STATUS>
        Y.MM.STR:='*':R.MM<MM.CURRENCY>
        Y.MM.STR:='*':R.MM<MM.DEAL.DATE>:@FM
        Y.VAR3 += 1
    REPEAT
    Y.FINAL.STR=Y.MM.STR
    GOSUB FINAL.ARRAY

RETURN
*------------------------------------------------------------------------
GET.LMM.ACC.BAL.ID:
*------------------------------------------------------------------------
* IAS.LMM.ACCRUED.INTEREST & ARC.MM.MONEY.MARKET -> Routine referred

    JUL.PROCESSDATE = R.DATES(EB.DAT.JULIAN.DATE)[3,5]
    LMM.ID = Y.MM.ID

    BEGIN CASE
        CASE LEN(LMM.ID) LE '9'
            LMM.ID = LMM.ID[1,2] : JUL.PROCESSDATE : FMT(LMM.ID[3,LEN(LMM.ID)-2],'5"0"R') : "00"
        CASE LEN(LMM.ID) LE '12'
            LMM.ID = LMM.ID[1,7]:FMT(LMM.ID[8,LEN(LMM.ID)-7],'5"0"R') : "00"
    END CASE

    CALL F.READ(FN.LMM.ACCOUNT.BALANCES,LMM.ID,R.LMM.ACCOUNT.BALANCES,F.LMM.ACCOUNT.BALANCES,LMM.ERR)

RETURN
*------------------------------------------------------------------------
FINAL.ARRAY:
*------------------------------------------------------------------------
    Y.ARRAY.OUT:=Y.FINAL.STR

RETURN
*------------------------------------------------------------------------
GET.REINV.CATEGORY:
*------------------------------------------------------------------------
* Here we gets the reinvested interest accounts category by reading the Az.Product.Parameter
    Y.REINV.CATEG=''

    SEL.APP='SELECT ':FN.AZ.PRODUCT.PARAMETER:' WITH L.AZ.RE.INV.CAT NE ""'
    CALL EB.READLIST(SEL.APP,SEL.LIST.APP,'',SEL.NOR.APP,SEL.RET)
    Y.APP=1
    LOOP
    WHILE Y.APP LE SEL.NOR.APP
        Y.APP.ID=SEL.LIST.APP<Y.APP>
        CALL CACHE.READ(FN.AZ.PRODUCT.PARAMETER,Y.APP.ID,R.APP,ERR.APP)
        Y.REINV.CATEG<-1>=R.APP<AZ.APP.LOCAL.REF,POS.L.AZ.RE.INV.CAT>
        Y.APP += 1
    REPEAT

RETURN
*------------------------------------------------------------------------
GET.STATUS:
*------------------------------------------------------------------------

    CALL F.READ(FN.EB.LOOKUP,Y.LOOKUP.ID,R.LOOKUP,F.EB.LOOKUP,LOOKUP.ERR)
    IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN
        Y.STATUS=R.LOOKUP<EB.LU.DESCRIPTION,1>
        RETURN
    END
    IF R.USER<EB.USE.LANGUAGE> EQ 2 THEN
        IF R.LOOKUP<EB.LU.DESCRIPTION,2> THEN
            Y.STATUS=R.LOOKUP<EB.LU.DESCRIPTION,2>
        END ELSE
            Y.STATUS=R.LOOKUP<EB.LU.DESCRIPTION,1>
        END
    END

RETURN
*------------------------------------------------------------------------
GET.LOC.REF:
*------------------------------------------------------------------------
    LOC.REF.APPLICATION="ACCOUNT":@FM:'AZ.ACCOUNT':@FM:'AZ.PRODUCT.PARAMETER'
    LOC.REF.FIELDS='L.AC.AV.BAL':@VM:'L.AC.STATUS1':@FM:'L.TYPE.INT.PAY':@FM:'L.AZ.RE.INV.CAT'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AC.AV.BAL=LOC.REF.POS<1,1>
    POS.L.AC.STATUS1=LOC.REF.POS<1,2>
    POS.L.TYPE.INT.PAY=LOC.REF.POS<2,1>
    POS.L.AZ.RE.INV.CAT=LOC.REF.POS<3,1>
    APPL='ACCOUNT'

    CALL APAP.TAM.redoGetVirtualTable(APPL,POS.L.AC.STATUS1,Y.VIRTUAL.TABLE,ERR);*R22 Manual Conversion

RETURN
END
