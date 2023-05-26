* @ValidationCode : MjoyMDAwNTY2MTEwOkNwMTI1MjoxNjg1MDgzOTY2NDA4OnZpY3RvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 May 2023 12:22:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.TAM
SUBROUTINE REDO.B.TAXPAYER.SERVICES(Y.NCF.ID)
*---------------------------------------------------------------------------------------------
*
* Description           : Batch routine to report information about Sales of Goods and / or Services made by the taxpayer during the fiscal period ended

* Developed By          : Thilak Kumar K
*
* Development Reference : RegN9
*
* Attached To           : Batch - BNK/APAP.B.TAXPAYER.SERVICES
*
* Attached As           : Online Batch Routine to COB
*---------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : Y.NCF.ID -@ID of REDO.NCF.ISSUED application
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*---------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00350484          Ashokkumar.V.P                  18/12/2014           Corrected the field values
* PACS00463470          Ashokkumar.V.P                  23/06/2015           Mapping change to display for RNC and Cedula
*                       Ashokkumar.V.P                  20/01/2015           Seperate report for non REGN9 NCF's.
*17-05-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM
*17-05-2023    VICTORIA S          R22 MANUAL CONVERSION   VARIABLE INITIALIZED IN INSERT FILE
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.CATEGORY
    $INSERT I_REDO.B.TAXPAYER.SERVICES.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_F.REDO.NCF.ISSUED
    $INSERT I_F.REDO.CHARGE.PARAM
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_F.CATEG.ENTRY

*
    GOSUB PROCESS
RETURN

PROCESS:
*-------
    GOSUB VAL.INIT
    Y.NCF='';Y.MODIFIED.NCF='';Y.ID.TYPE='';Y.ID.NUMBER='';Y.CUSTOMER='';Y.DATE='';Y.CHRG='';Y.TAX='';Y.CNT.CNF=''
    Y.NCF.ACT.FLAG='';Y.MNCF.ACT.FLAG='';Y.ACCOUNT.1='';Y.ACCOUNT.2='';Y.ACCOUNT1.LOC='';Y.ACCOUNT2.LOC=''
    Y.DEBIT.ACCT.NO='';Y.CREDIT.ACCT.NO='';Y.DEBIT.AMT='';Y.CREDIT.AMT='';Y.ITBIS.BILLED='';Y.ITBIS.VAL=''
    Y.CHRG.AMT='';Y.TAX.AMT='';Y.TXN.ID='';Y.ACCOUNT='';Y.TOT.AMT='0';Y.AMOUNT='';Y.ITBIS.VALUE=''
    Y.RNC.LEGAL.ID = ''; Y.IDEN.TYPE = ''; Y.BILL.NUM = ''; Y.BILL.NUM.MOD = ''; Y.DATE =''; Y.FLAG = ''
    Y.ITBIS.VAL = ''; Y.BILL.AMOUNT = ''; TXN.LEN = ''; Y.RNC.LEGAL.ID.1 = ''; YGRP.TPFLG = 0
    R.FUNDS.TRANSFER = ''; Y.FT.ERR = ''; FUNDS.TRANSFER.HERR = ''; Y.DEBIT.ACCT.NO = ''
    Y.CREDIT.ACCT.NO = ''; Y.CREDIT.AMT = ''; Y.ITBIS.BILLED = ''; Y.DEBIT.1 = ''; Y.CREDIT.1 = ''
    YAT.UNIQUE.ID = ''; Y.DEBIT.1='';Y.CREDIT.1=''; YFT.CHANEL = ''
*
*    Y.NCF.ID = '4052004.20130614.FT1312208767'
    CALL F.READ(FN.REDO.NCF.ISSUED,Y.NCF.ID,R.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED,Y.NCF.ERR)
    IF R.REDO.NCF.ISSUED NE '' THEN
        Y.TXN.ID  = R.REDO.NCF.ISSUED<ST.IS.TXN.ID>
        GOSUB GET.NCF.ISSUED
        GOSUB GET.CHRG.AMT
        GOSUB GET.TAX.DETAILS
        GOSUB READ.TRANSACTION
        GOSUB DEBIT.FLG.DTLS
        GOSUB FORM.BODY
    END
RETURN

*---------------
READ.TRANSACTION:
*----------------
    BEGIN CASE
        CASE Y.TXN.ID[1,2] EQ 'TT'
            GOSUB READ.TT
            GOSUB GET.PL.DET
        CASE Y.TXN.ID[1,2] EQ 'FT'
            GOSUB READ.FT
            GOSUB GET.PL.DET
        CASE Y.TXN.ID[1,4] EQ 'PEND'
            GOSUB GET.PL.DET
        CASE 1
            GOSUB GET.PL.DET
    END CASE
RETURN

GET.PL.DET:
***********
    yacct.val = ''; YAC.CHG = ''; YCATEG.PRF = ''
    yacct.val = R.REDO.NCF.ISSUED<ST.IS.ACCOUNT>
    Y.NCF.ACCOUNT = R.REDO.NCF.ISSUED<ST.IS.ACCOUNT>
    Y.NCF.AMOUNT.LCY = R.REDO.NCF.ISSUED<ST.IS.CHARGE.AMOUNT>
    Y.NCF.VALUE.DATE = R.REDO.NCF.ISSUED<ST.IS.DATE>
    YCATEG.PRF = 'X'
*    IF yacct.val[1,2] EQ 'PL' THEN
*        yacct.val = yacct.val[3,10]
*        Y.PL.CATEGORY = yacct.val
*    END ELSE
*        YAC.CHG = R.REDO.NCF.ISSUED<ST.IS.TXN.CHARGE>
*        GOSUB READ.COMMISION
*
*        GOSUB GET.CATEG.ENTRY
*
*    END
*IF yacct.val THEN
*    CATEGORY.ERR = ''; R.CATEGORY = ''
* *CALL CACHE.READ(FN.CATEGORY,"SYSTEM",R.CATEGORY,CATEGORY.ERR)
*    *CALL CACHE.READ(FN.CATEGORY,yacct.val,R.CATEGORY,CATEGORY.ERR)
* GOSUB GET.CATEG.ENTRY
* CALL F.READ(FN.CATEGORY,Y.PL.CATEGORY,R.CATEGORY,F.CATEGORY, CATEGORY.ERR)
*    YCATEG.PRF = R.CATEGORY<EB.CAT.LOCAL.REF,L.TYPE.PROFIT.POS>
*END ELSE
*    YCATEG.PRF = 1
*END
    Y.MY.PL.CATEGORY = ''
    IF Y.NCF.ACCOUNT[1,2] EQ "PL" THEN
        Y.MY.PL.CATEGORY = Y.NCF.ACCOUNT[3,8]
        CALL F.READ(FN.CATEGORY,Y.MY.PL.CATEGORY,R.CATEGORY,F.CATEGORY, CATEGORY.ERR)
    END ELSE
        GOSUB GET.CATEG.ENTRY
        CALL F.READ(FN.CATEGORY,Y.PL.CATEGORY,R.CATEGORY,F.CATEGORY, CATEGORY.ERR)
    END


    YCATEG.PRF = R.CATEGORY<EB.CAT.LOCAL.REF,L.TYPE.PROFIT.POS>
    IF YCATEG.PRF EQ '' THEN
        YCATEG.PRF = 1
    END
*SPECIAL CONDITION:
    IF Y.TXN.TYPE EQ 'ACPA' OR Y.TXN.TYPE EQ 'ACPI' OR Y.TXN.TYPE EQ 'ACPO' OR Y.TXN.TYPE EQ 'ACPB' OR Y.TXN.TYPE EQ 'ACPY' THEN
        YCATEG.PRF = 2
    END
    IF Y.TXN.TYPE EQ 'ACQA' OR Y.TXN.TYPE EQ 'ACRP' OR Y.TXN.TYPE EQ 'AC18' OR Y.TXN.TYPE EQ 'ACQP' OR Y.TXN.TYPE EQ 'ACWF' THEN
        YCATEG.PRF = 2
    END
    IF Y.TXN.TYPE EQ 'ACB6' OR Y.TXN.TYPE EQ 'ACPD' OR Y.TXN.TYPE EQ 'ACLP' OR Y.TXN.TYPE EQ 'ACPP' THEN
        YCATEG.PRF = 2
    END
    IF Y.TXN.TYPE EQ 'ACCP' THEN
        YCATEG.PRF = 2
    END
RETURN

*--------------
GET.CATEG.ENTRY:
*--------------
    Y.PL.CATEGORY = ''
    SEL.CMD.CE = "SELECT " : FN.CATEG.ENTRY : " WITH OUR.REFERENCE EQ " : Y.NCF.ACCOUNT : " AND AMOUNT.LCY EQ " : Y.NCF.AMOUNT.LCY : " AND VALUE.DATE EQ " : Y.NCF.VALUE.DATE : " SAMPLE 1"
    CALL EB.READLIST(SEL.CMD.CE,SEL.LIST.CE,"",NO.OF.RECS.CE,SEL.CE.ERR)
    LOOP REMOVE CATEG.ENTRY.ID FROM SEL.LIST.CE SETTING POS.CE
    WHILE CATEG.ENTRY.ID DO
        CALL F.READ(FN.CATEG.ENTRY,CATEG.ENTRY.ID,R.CATEG.ENTRY,F.CATEG.ENTRY,CATEG.ENTRY.ERR)
        Y.PL.CATEGORY = R.CATEG.ENTRY<AC.CAT.PL.CATEGORY>

    REPEAT

RETURN

*--------------
GET.NCF.ISSUED:
*--------------
    Y.NCF =''; Y.MODIFIED.NCF = ''; Y.ID.TYPE = ''; Y.ID.NUMBER = ''
    Y.CUSTOMER = ''; Y.DATE = ''; Y.CHRG = ''; Y.TAX = ''; Y.TXN.TYPE = ''
    Y.TXN.CHARGE = ''
    Y.NCF = R.REDO.NCF.ISSUED<ST.IS.NCF>
    Y.MODIFIED.NCF  = R.REDO.NCF.ISSUED<ST.IS.MODIFIED.NCF>
    Y.ID.TYPE       = R.REDO.NCF.ISSUED<ST.IS.ID.TYPE>
    Y.ID.NUMBER     = R.REDO.NCF.ISSUED<ST.IS.ID.NUMBER>
    Y.CUSTOMER      = R.REDO.NCF.ISSUED<ST.IS.CUSTOMER>
    Y.DATE          = R.REDO.NCF.ISSUED<ST.IS.DATE>
    Y.CHRG          = R.REDO.NCF.ISSUED<ST.IS.CHARGE.AMOUNT>
    Y.TAX           = R.REDO.NCF.ISSUED<ST.IS.TAX.AMOUNT>
    Y.TXN.TYPE    = R.REDO.NCF.ISSUED<ST.IS.TXN.TYPE>
    Y.TXN.CHARGE = R.REDO.NCF.ISSUED<ST.IS.TXN.CHARGE>
    IF NOT(Y.CUSTOMER) AND NOT(Y.ID.NUMBER) THEN
        Y.CUSTOMER = FIELD(Y.NCF.ID,'.',1)
    END
RETURN

*-----------
GET.CHRG.AMT:
*-----------
    IF Y.CHRG EQ '' THEN
        RETURN
    END
    IF NUM(Y.CHRG[1,2]) THEN
        Y.CHRG.AMT = Y.CHRG
    END ELSE
        Y.CHRG.AMT = FIELD(Y.CHRG,' ',2,1)
    END
RETURN
*--------------
GET.TAX.DETAILS:
*--------------
    IF Y.TAX EQ '' THEN
        RETURN
    END
    IF NUM(Y.TAX[1,2]) THEN
        Y.TAX.AMT = Y.TAX
    END ELSE
        Y.TAX.AMT = FIELD(Y.TAX,' ',2,1)
    END
    Y.ACCOUNT = R.REDO.NCF.ISSUED<ST.IS.ACCOUNT>
RETURN
*-------------
DEBIT.FLG.DTLS:
*-------------
    IF Y.DEBIT.1 THEN
        Y.NCF.ACT.FLAG  = 'DB'
    END ELSE
        IF Y.CREDIT.1 THEN
            Y.NCF.ACT.FLAG  = 'CR'
        END
    END
RETURN
*-------
READ.TT:
*-------
    R.TELLER = ''; Y.TL.ERR = ''; TELLER.HERR = ''; Y.CREDIT.AMT = ''; Y.ACCOUNT.2 = ''
    Y.ACCOUNT.1 = ''; Y.CREDIT.AMT = ''; Y.ITBIS.BILLED = ''; Y.DEBIT.1 = ''; Y.CREDIT.1 = ''
    Y.TT.TRANSACTION.CODE = ''
    CALL F.READ(FN.TELLER,Y.TXN.ID,R.TELLER,F.TELLER,Y.TL.ERR)
    IF NOT(R.TELLER) THEN
        TXN.ID.HST = Y.TXN.ID
        CALL EB.READ.HISTORY.REC(F.TELLER.HIS,TXN.ID.HST,R.TELLER,TELLER.HERR)
    END
    Y.ACCOUNT.1   = R.TELLER<TT.TE.ACCOUNT.1>
    Y.ACCOUNT.2   = R.TELLER<TT.TE.ACCOUNT.2>
    Y.ITBIS.BILLED   = R.TELLER<TT.TE.AMOUNT.LOCAL.1>
    Y.CREDIT.AMT     = R.TELLER<TT.TE.AMOUNT.LOCAL.1>
    IF Y.ACCOUNT EQ Y.ACCOUNT.1 AND Y.ACCOUNT AND Y.ACCOUNT.1 THEN
        Y.DEBIT.1 = 'DB':Y.ACCOUNT
    END ELSE
        IF Y.ACCOUNT EQ Y.ACCOUNT.2 AND Y.ACCOUNT AND Y.ACCOUNT.1 THEN
            Y.CREDIT.1 = 'CR':Y.ACCOUNT
        END
    END
    Y.TT.TRANSACTION.CODE = R.TELLER<TT.TE.TRANSACTION.CODE>

RETURN

*------
READ.FT:
*-------
    CALL F.READ(FN.FUNDS.TRANSFER,Y.TXN.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,Y.FT.ERR)
    IF NOT(R.FUNDS.TRANSFER) THEN
        FT.ID.HST = Y.TXN.ID
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,FT.ID.HST,R.FUNDS.TRANSFER,FUNDS.TRANSFER.HERR)
    END
   
    Y.DEBIT.ACCT.NO  = R.FUNDS.TRANSFER<FT.IN.DEBIT.ACCT.NO>
*        Y.DEBIT.AMT     = R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>
    Y.CREDIT.ACCT.NO = R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>
    Y.CREDIT.AMT     = R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>
    Y.ITBIS.BILLED   = R.FUNDS.TRANSFER<FT.LOCAL.REF,Y.ITBIS.POS>
    YAT.UNIQUE.ID = R.FUNDS.TRANSFER<FT.LOCAL.REF,AT.UNIQUE.ID.POS> ;*R22 MANUAL CONVERSION
    YFT.CHANEL = R.FUNDS.TRANSFER<FT.LOCAL.REF,L.FT.CHANNELS.POS> ;*R22 MANUAL CONVERSION
    Y.FT.TAX.CODE = R.FUNDS.TRANSFER<FT.LOCAL.REF,L.TT.TAX.CODE.POS> ;*R22 MANUAL CONVERSION

    IF Y.ACCOUNT EQ Y.DEBIT.ACCT.NO THEN
        Y.DEBIT.1 = 'DB':Y.ACCOUNT
    END ELSE
        IF Y.ACCOUNT EQ Y.CREDIT.ACCT.NO THEN
            Y.CREDIT.1 = 'CR':Y.ACCOUNT
        END
    END
*sometimes the REDO.NCF.ISSUED record doesn't have value for TXN.TYPE hence we will get it from FT
    IF Y.TXN.TYPE EQ '' THEN
        Y.TXN.TYPE = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
    END
RETURN

READ.COMMISION:
***************
    ERR.FT.COMMISSION.TYPE = ''; R.FT.COMMISSION.TYPE = ''
    CALL F.READ(FN.FT.COMMISSION.TYPE,YAC.CHG,R.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE,ERR.FT.COMMISSION.TYPE)
    yacct.val = R.FT.COMMISSION.TYPE<FT4.CATEGORY.ACCOUNT>
    IF LEN(yacct.val) GT 6 THEN
        GOSUB READ.CHRG.PARAM
        yacct.val = Y.CHARGE.PL.CAT
    END
RETURN

READ.CHRG.PARAM:
****************
    CHG.ERR = ''
    CALL CACHE.READ(FN.CHARGE.PARAM,"SYSTEM",R.CHARGE.PARAM,CHG.ERR)
    Y.CHARGE.PL.CAT =  R.CHARGE.PARAM<CHG.PARAM.PL.CATEGORY>
RETURN

READ.CUST:
**********
    R.CUSTOMER = ''; Y.CUS.ERR = ''; Y.CUST.HIST = ''; Y.CUS.ERRH = ''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
    IF NOT(R.CUSTOMER) THEN
        Y.CUST.HIST = Y.CUSTOMER
        CALL EB.READ.HISTORY.REC(F.CUSTOMER.HST,Y.CUST.HIST,R.CUSTOMER,Y.CUS.ERRH)
    END
RETURN

*---------
FORM.BODY:
*---------
    YGRP.TPFLG = 0
    GOSUB READ.CUST
    IF NOT(R.CUSTOMER) THEN
        GOSUB GET.CUST.DET
        GOSUB READ.CUST
    END
    IF NOT(R.CUSTOMER) THEN
        YGRP.TPFLG = 1
    END

    IF Y.ID.TYPE EQ 'CEDULA' THEN
        Y.IDEN.TYPE = '2'
    END

    IF Y.ID.TYPE EQ 'RNC' THEN
        Y.IDEN.TYPE = '1'
    END

    BEGIN CASE
        CASE Y.ID.TYPE AND Y.ID.NUMBER
            Y.RNC.LEGAL.ID = Y.ID.NUMBER
        CASE NOT(Y.ID.TYPE)
            GOSUB GET.CUS.DTLS
            GOSUB GET.CUS.CHK.FLDS
    END CASE
    IF NOT(Y.RNC.LEGAL.ID) THEN
        GOSUB GET.CUS.CHK.FLDS.NON
    END
    GOSUB GET.CNT.NCF.CHK
RETURN

GET.CUS.CHK.FLDS.NON:
*********************
    YGRP.TPFLG = 1
    IF Y.CUS.FORE NE '' THEN
        Y.RNC.LEGAL.ID = Y.CUS.FORE
        Y.IDEN.TYPE = '3'
    END
    IF Y.L.CU.ACTANAC NE '' THEN
        Y.RNC.LEGAL.ID = Y.L.CU.ACTANAC
        Y.IDEN.TYPE = '3'
    END
    IF Y.L.CU.NOUNICO NE '' THEN
        Y.RNC.LEGAL.ID = Y.L.CU.NOUNICO
        Y.IDEN.TYPE = '3'
    END
    IF NOT(Y.RNC.LEGAL.ID) AND Y.CUS.LEGAL.ID THEN
        Y.RNC.LEGAL.ID = Y.CUS.NAT:Y.CUS.LEGAL.ID
        Y.IDEN.TYPE = '3'
    END
    IF NOT(Y.ID.TYPE) AND Y.CUSTOMER AND NOT(R.CUSTOMER) THEN
        Y.RNC.LEGAL.ID = Y.CUSTOMER
        Y.IDEN.TYPE = '3'
    END
RETURN

GET.CUST.DET:
*************
    ERR.CUSTOMER.L.CU.CIDENT = ''; R.CUSTOMER.L.CU.CIDENT = ''
    CALL F.READ(FN.CUSTOMER.L.CU.CIDENT,Y.ID.NUMBER,R.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT,ERR.CUSTOMER.L.CU.CIDENT)
    IF R.CUSTOMER.L.CU.CIDENT THEN
        Y.CUSTOMER = FIELD(R.CUSTOMER.L.CU.CIDENT,'*',2)
        GOSUB READ.CUST
        RETURN
    END
    ERR.CUSTOMER.L.CU.RNC = ''; R.CUSTOMER.L.CU.RNC = ''
    CALL F.READ(FN.CUSTOMER.L.CU.RNC,Y.ID.NUMBER,R.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC,ERR.CUSTOMER.L.CU.RNC)
    IF R.CUSTOMER.L.CU.RNC THEN
        Y.CUSTOMER = FIELD(R.CUSTOMER.L.CU.RNC,'*',2)
        GOSUB READ.CUST
        RETURN
    END
    ERR.CUSTOMER.L.CU.PASS.NAT = ''; R.CUSTOMER.L.CU.PASS.NAT = ''
    CALL F.READ(FN.CUSTOMER.L.CU.PASS.NAT,Y.ID.NUMBER,R.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT,ERR.CUSTOMER.L.CU.PASS.NAT)
    IF R.CUSTOMER.L.CU.PASS.NAT THEN
        Y.CUSTOMER = FIELD(R.CUSTOMER.L.CU.PASS.NAT,'*',2)
        GOSUB READ.CUST
        RETURN
    END
RETURN

*--------------
GET.CNT.NCF.CHK:
*--------------
    Y.ORG.CHRG.AMT = ''; Y.TOT.AMT = ''; Y.CREDIT.FLAG = ''; Y.ORG.TAX.AMT = ''
    Y.CNT.NCF = DCOUNT(Y.NCF,@VM);*R22 AUTO CONVERSION
    IF Y.CNT.NCF GE '1' THEN
        Y.COUNT = '1'
        GOSUB GET.NCF.AMOUNT.AND.UPDATATION
    END
RETURN
*---------------------------
GET.NCF.AMOUNT.AND.UPDATATION:
*----------------------------
    Y.ORG.CHRG.AMT = Y.CHRG.AMT
    Y.ORG.TAX.AMT = Y.TAX.AMT
    LOOP
        REMOVE Y.NCF.ID FROM Y.NCF SETTING NCF.POS
    WHILE Y.NCF.ID:NCF.POS
        GOSUB GET.ITBIS.VALUE
        IF Y.COUNT EQ '1' THEN
            GOSUB GET.TOT.AMT
        END
        IF Y.CHRG.AMT EQ '' AND Y.TAX.AMT EQ '' AND Y.COUNT EQ 1 THEN
            GOSUB FT.AMOUNT
        END ELSE
            GOSUB UPDATE.RCL.REC.AMT
        END
        Y.COUNT += 1
    REPEAT
RETURN
*------------
GET.CUS.DTLS:
*------------
    Y.CUS.NAT      = R.CUSTOMER<EB.CUS.NATIONALITY>
    Y.CUS.CIDENT   = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CIDENT.POS>
    Y.CUS.RNC      = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.RNC.POS>
    Y.CUS.FORE     = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.FORE.POS>
    Y.CUS.LEGAL.ID = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    Y.CUS.STREET   = R.CUSTOMER<EB.CUS.STREET>
    Y.CUS.TWN.CNT  = R.CUSTOMER<EB.CUS.TOWN.COUNTRY>
    Y.L.CU.ACTANAC = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.ACTANAC.POS> ;*R22 MANUAL CONVERSION
    Y.L.CU.NOUNICO = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.NOUNICO.POS> ;*R22 MANUAL CONVERSION
RETURN

*---------------
GET.CUS.CHK.FLDS:
*---------------
    BEGIN CASE
        CASE Y.CUS.CIDENT NE ''
            Y.RNC.LEGAL.ID = Y.CUS.CIDENT
            Y.IDEN.TYPE = '2'
        CASE Y.CUS.RNC NE ''
            Y.RNC.LEGAL.ID = Y.CUS.RNC
            Y.IDEN.TYPE = '1'
    END CASE
RETURN

*---------------
GET.ITBIS.VALUE:
*--------------
    IF Y.ITBIS.BILLED NE '' THEN
        IF NUM(Y.ITBIS.BILLED[1,2]) THEN
            Y.ITBIS.VALUE = Y.ITBIS.BILLED
        END ELSE
            Y.ITBIS.VALUE = FIELD(Y.ITBIS.BILLED,' ',2,1)
        END
    END
    Y.BILL.NUM = Y.NCF.ID
    IF Y.MODIFIED.NCF NE '' THEN
        Y.BILL.NUM.MOD = Y.MODIFIED.NCF
        Y.MNCF.ACT.FLAG = 1
    END
RETURN

*---------
FT.AMOUNT:
*---------
    IF Y.ITBIS.VALUE NE '' AND Y.CREDIT.AMT NE '' THEN
        Y.ITBIS.VAL   = Y.ITBIS.VALUE
        Y.BILL.AMOUNT = Y.CREDIT.AMT
        GOSUB MAP.RCL.REC
    END
RETURN

*-----------
GET.TOT.AMT:
*-----------
    Y.AMOUNT = ''
    IF Y.ORG.CHRG.AMT EQ '' AND Y.ORG.TAX.AMT EQ '' AND Y.COUNT EQ 1 AND Y.ITBIS.VALUE THEN
        Y.AMOUNT = Y.CREDIT.AMT
    END ELSE
        IF (Y.ORG.CHRG.AMT EQ '' OR Y.ORG.TAX.AMT EQ '') AND Y.CNT.NCF EQ 2 AND Y.ITBIS.VALUE THEN
            Y.AMOUNT = Y.CREDIT.AMT
        END
    END

    IF Y.MNCF.ACT.FLAG THEN
        IF Y.NCF.ACT.FLAG NE Y.MNCF.ACT.FLAG THEN
            Y.TOT.AMT = Y.AMOUNT+Y.ORG.CHRG.AMT+Y.ORG.TAX.AMT
        END ELSE
            Y.TOT.AMT = Y.AMOUNT+(Y.ORG.CHRG.AMT-Y.ORG.TAX.AMT)
        END
    END ELSE
        Y.TOT.AMT = Y.AMOUNT+Y.ORG.CHRG.AMT+Y.ORG.TAX.AMT
    END
RETURN
*-----------
MAP.RCL.REC:
*-----------
*
    IF NOT(Y.RNC.LEGAL.ID) THEN
        YGRP.TPFLG = 1
    END
    GOSUB GET.REDO.CHAIN
    Y.RNC.LEGAL.ID.1 = TRIM(Y.RNC.LEGAL.ID,'-','A')

    C$SPARE(451) = Y.RNC.LEGAL.ID.1
    C$SPARE(452) = Y.IDEN.TYPE
    C$SPARE(453) = Y.BILL.NUM
    C$SPARE(454) = Y.BILL.NUM.MOD
    C$SPARE(455) = Y.DATE
    C$SPARE(456) = Y.BILL.AMOUNT
*    C$SPARE(457) = Y.BILL.AMOUNT
    C$SPARE(459) = Y.DATE
    C$SPARE(458) = YCATEG.PRF
*PUYACION:
    IF Y.FLAG.60.61 EQ '60' THEN
        C$SPARE(460) = C$SPARE(456)
    END ELSE
        C$SPARE(461) = C$SPARE(456)
    END


    MAP.FMT = "MAP"
    ID.RCON.L = "REDO.RCL.REGN9"
    APP = FN.REDO.NCF.ISSUED
    R.APP = R.REDO.NCF.ISSUED
    R.RETURN.MSG = ''
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
*    Y.ARRAY = Y.TOT.AMT:"*":R.RETURN.MSG
    Y.ARRAY = R.RETURN.MSG
    IF Y.ARRAY AND YGRP.TPFLG NE 1 THEN
        WRK.FILE.ID = Y.NCF.ID:'.':Y.CUSTOMER
        CALL F.WRITE(FN.DR.REG.REGN9.WORKFILE,WRK.FILE.ID,Y.ARRAY)
    END
    IF Y.ARRAY AND YGRP.TPFLG EQ 1 THEN
        WRK.FILE.ID = 'NONV-':Y.NCF.ID:'.':Y.CUSTOMER
        CALL F.WRITE(FN.DR.REG.REGN9.WORKFILE,WRK.FILE.ID,Y.ARRAY)
    END
RETURN

VAL.INIT:
*********
    C$SPARE(451) = ''; C$SPARE(452) = ''; C$SPARE(453) = ''; C$SPARE(454) = ''
    C$SPARE(455) = ''; C$SPARE(456) = ''; C$SPARE(457) = ''; C$SPARE(458) = ''
    C$SPARE(459) = ''; C$SPARE(460) = ''; C$SPARE(461) = ''; C$SPARE(462) = ''
RETURN

*------------------
UPDATE.RCL.REC.AMT:
*-----------------
* send credit amount if NCF count is more than 1 but charge/tax amount is missing
    IF (Y.ORG.CHRG.AMT EQ '' OR Y.ORG.TAX.AMT EQ '') AND Y.COUNT GT 1 THEN
        IF NOT(Y.CREDIT.FLAG) THEN
*            Y.AMOUNT = Y.CREDIT.AMT
            GOSUB FT.AMOUNT
            Y.CREDIT.FLAG = 'Y'
        END
    END

    IF Y.CHRG.AMT NE '' THEN
        Y.BILL.AMOUNT = Y.CHRG.AMT
        GOSUB MAP.RCL.REC
        Y.CHRG.AMT = ''
    END ELSE
        IF Y.TAX.AMT NE '' THEN
            Y.BILL.AMOUNT = Y.TAX.AMT
            Y.TAX.AMT = ''
            GOSUB MAP.RCL.REC
        END
    END
RETURN


GET.REDO.CHAIN:
***************
    Y.FLAG.60.61 = ''
    IF YFT.CHANEL EQ 'BM' OR YFT.CHANEL EQ 'ARC' THEN
        C$SPARE(462) = 0
        C$SPARE(460) = 0
        C$SPARE(461) = 0      ;*Y.BILL.AMOUNT
        Y.FLAG.60.61 = '61'
        RETURN
    END

    IF YAT.UNIQUE.ID THEN
        C$SPARE(462) = Y.BILL.AMOUNT
        C$SPARE(460) = 0
        C$SPARE(461) = 0      ;*Y.BILL.AMOUNT    ;*0 ;*this one fall into transaction, cheque and deposit, hence let's set bill.amount value...
        Y.FLAG.60.61 = '61'
        RETURN
    END

    IF Y.FT.TAX.CODE EQ "IMP015%" THEN
        C$SPARE(461) = 0      ;*Y.BILL.AMOUNT
        C$SPARE(460) = 0
        Y.FLAG.60.61 = '61'
    END
*
    IF Y.FT.TAX.CODE EQ "IMP015%" AND Y.TXN.CHARGE EQ "CKADMIN" THEN
        C$SPARE(461) = 0      ;*Y.TAX
        C$SPARE(460) = 0
        Y.FLAG.60.61 = '61'
    END

    IF (C$SPARE(461) EQ '') OR (C$SPARE(461) EQ 0) THEN
        IF Y.TXN.TYPE EQ '320' OR Y.TXN.TYPE EQ '356' OR Y.TXN.TYPE EQ '358' OR Y.TXN.TYPE EQ '364' THEN
            C$SPARE(461) = 0  ;*Y.CHRG       ;*Y.BILL.AMOUNT
            C$SPARE(460) = 0
            Y.FLAG.60.61 = '61'
        END
        IF Y.TXN.TYPE EQ 'OT30' THEN
            C$SPARE(461) = 0  ;*Y.CHRG
            C$SPARE(460) = 0
            Y.FLAG.60.61 = '61'
        END
        IF Y.TXN.TYPE EQ 'ACL3' OR Y.TXN.TYPE EQ 'ACB6' OR Y.TXN.TYPE EQ 'AC42' THEN
            C$SPARE(461) = 0  ;*Y.CHRG
            C$SPARE(460) = 0
            Y.FLAG.60.61 = '61'
        END
*RETURNED CHECK COMMISION
        IF Y.TXN.TYPE EQ 'ACIW' THEN
            C$SPARE(461) = 0  ;*Y.CHRG
            C$SPARE(460) = 0
            Y.FLAG.60.61 = '61'
        END

        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACQA' OR Y.TXN.TYPE EQ 'ACRP') THEN
            C$SPARE(461) = 0  ;*Y.CHRG       ;*Y.BILL.AMOUNT
            C$SPARE(460) = 0
            Y.FLAG.60.61 = '61'
        END
        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'AC18' OR Y.TXN.TYPE EQ 'ACQP') THEN
            C$SPARE(461) = 0  ;*Y.CHRG       ;*Y.BILL.AMOUNT
            C$SPARE(460) = 0
            Y.FLAG.60.61 = '61'
        END
        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACCA' OR Y.TXN.TYPE EQ 'ACWF') THEN
            C$SPARE(461) = 0  ;*Y.CHRG       ;*Y.BILL.AMOUNT
            C$SPARE(460) = 0
            Y.FLAG.60.61 = '61'
        END
        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACB6' OR Y.TXN.TYPE EQ 'ACPD') THEN
            C$SPARE(461) = 0  ;*Y.CHRG       ;*Y.BILL.AMOUNT
            C$SPARE(460) = 0
            Y.FLAG.60.61 = '61'
        END
        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPA' OR Y.TXN.TYPE EQ 'ACPY') THEN
            C$SPARE(461) = 0  ;*Y.CHRG       ;*Y.BILL.AMOUNT
            C$SPARE(460) = 0
            Y.FLAG.60.61 = '61'
        END
        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACLP') THEN
            C$SPARE(461) = 0  ;*Y.CHRG
            C$SPARE(460) = 0
            Y.FLAG.60.61 = '61'
        END
    END


    IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPA' OR Y.TXN.TYPE EQ 'ACPY') THEN
        C$SPARE(461) = 0      ;*Y.CHRG ;*Y.BILL.AMOUNT
        C$SPARE(460) = 0
        Y.FLAG.60.61 = '61'
    END
    IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACLP') THEN
        C$SPARE(461) = 0      ;*Y.CHRG
        C$SPARE(460) = 0
        Y.FLAG.60.61 = '61'
    END




    R.REDO.TRANSACTION.CHAIN = ''; ERR.REDO.TRANSACTION.CHAIN = ''; YTOTAL.CASH = 0; YTOTAL.CHECK = 0
    YTRANS.TYPE = ''
    CALL F.READ(FN.REDO.TRANSACTION.CHAIN,Y.TXN.ID,R.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN,ERR.REDO.TRANSACTION.CHAIN)
    IF R.REDO.TRANSACTION.CHAIN THEN
        YTOTAL.CASH = R.REDO.TRANSACTION.CHAIN<RTC.TOTAL.CASH>
        YTOTAL.CHECK = R.REDO.TRANSACTION.CHAIN<RTC.TOTAL.CHECK>
        YTRANS.TYPE = R.REDO.TRANSACTION.CHAIN<RTC.TRANS.TYPE>
        C$SPARE(460) = 0      ;*YTOTAL.CASH
        C$SPARE(461) = 0      ;*YTOTAL.CHECK

        IF YTOTAL.CASH GT 0 AND YTOTAL.CHECK GT 0 THEN
            C$SPARE(460) = 0.00
            C$SPARE(461) = 0  ;*Y.CHRG
            Y.FLAG.60.61 = '61'
        END
        IF YTOTAL.CASH GT 0 AND (YTOTAL.CHECK LE 0 OR YTOTAL.CHECK EQ '') THEN
            C$SPARE(460) = 0.00
            C$SPARE(461) = 0  ;*Y.CHRG
            Y.FLAG.60.61 = '61'
        END
        IF YTOTAL.CHECK GT 0 AND (YTOTAL.CASH LE 0 OR YTOTAL.CASH EQ '') THEN
            C$SPARE(461) = 0.00
            C$SPARE(460) = 0  ;*Y.CHRG
            Y.FLAG.60.61 = '61'
        END
*
        C$SPARE(462) = 0
*
        IF C$SPARE(461) EQ '' THEN
            IF Y.TT.TRANSACTION.CODE EQ 12 THEN
                C$SPARE(461) = 0        ;*Y.CHRG
                C$SPARE(460) = 0
                Y.FLAG.60.61 = '61'
            END
        END

        IF C$SPARE(460) EQ '' THEN
            IF Y.TT.TRANSACTION.CODE EQ 180 THEN
                C$SPARE(460) = 0        ;*Y.BILL.AMOUNT
                C$SPARE(461) = 0
                Y.FLAG.60.61 = '60'
            END
        END

        IF YTRANS.TYPE EQ 'CASH' THEN
*-------------
*--POPULATE C$SPARE(460)
*--for this section we rather use the value REDO.NCF.ISSSUED>CHARGE.AMOUNT
*--because in REDO.TRANSACTION.CHAIN the system is storing the totoal payment for the loan
*--instead of the interest proportion which is the one that generate the NCF
            Y.NCF.QNT = DCOUNT(Y.NCF,@VM)
            Y.PROPORTION.AMOUNT = ''
            Y.PROPORTION.AMOUNT = Y.CHRG
            IF Y.TAX GT 0 THEN
                Y.PROPORTION.AMOUNT = Y.TAX
            END
            srt1 = '00DOP '
            str2 = ''
            Y.PROPORTION.AMOUNT =  EREPLACE(Y.PROPORTION.AMOUNT,srt1,str2)

*IF Y.PROPORTION.AMOUNT EQ '' THEN
*    Y.PROPORTION.AMOUNT = Y.BILL.AMOUNT
*END

            IF C$SPARE(460) EQ '' OR C$SPARE(460) EQ 0 THEN
                IF Y.TXN.ID[1,2] EQ 'AA' AND Y.TXN.TYPE EQ 'N/A' THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END
                IF Y.TXN.ID[1,2] EQ 'AA' AND Y.TXN.TYPE EQ 'ACPA' THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPO') THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPA') THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT      ;*Y.BILL.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPY') THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT      ;*Y.BILL.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END
                IF Y.TXN.TYPE EQ 'OT30' THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END
                IF Y.TXN.TYPE EQ 'ACL3' OR Y.TXN.TYPE EQ 'ACB6' OR Y.TXN.TYPE EQ 'AC42' THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END
*RETURNED CHECK COMMISION
                IF Y.TXN.TYPE EQ 'ACIW' THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END

                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACQA' OR Y.TXN.TYPE EQ 'ACRP') THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT      ;*Y.BILL.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'AC18' OR Y.TXN.TYPE EQ 'ACQP') THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT      ;*Y.BILL.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACCA' OR Y.TXN.TYPE EQ 'ACWF') THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT      ;*Y.BILL.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACB6' OR Y.TXN.TYPE EQ 'ACPD') THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT      ;*Y.BILL.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPA' OR Y.TXN.TYPE EQ 'ACPY') THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT      ;*Y.BILL.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACLP') THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPP') THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACCP') THEN
                    C$SPARE(460) = 0    ;*Y.PROPORTION.AMOUNT
                    C$SPARE(461) = 0    ;*Fill with zero cause is only allowed one type
                    Y.FLAG.60.61 = '60'
                END
            END

        END ELSE
*-------------
*--POPULATE C$SPARE(461)
            IF C$SPARE(461) EQ '' OR C$SPARE(461) EQ 0 THEN
                IF Y.TXN.ID[1,2] EQ 'AA' AND Y.TXN.TYPE EQ 'N/A' THEN
                    C$SPARE(461) = 0    ;*C$SPARE(456) ;*Y.CHRG
                    C$SPARE(460) = 0
                    Y.FLAG.60.61 = '61'
                END
                IF Y.TXN.ID[1,2] EQ 'AA' AND Y.TXN.TYPE EQ 'ACPA' THEN
                    C$SPARE(461) = 0    ;*C$SPARE(456) ;*Y.CHRG
                    C$SPARE(460) = 0
                    Y.FLAG.60.61 = '61'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPO') THEN
                    C$SPARE(461) = 0    ;*C$SPARE(456) ;*Y.CHRG
                    C$SPARE(460) = 0
                    Y.FLAG.60.61 = '61'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPA') THEN
                    C$SPARE(461) = 0    ;*C$SPARE(456) ;*Y.CHRG         ;*Y.BILL.AMOUNT
                    C$SPARE(460) = 0
                    Y.FLAG.60.61 = '61'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPY') THEN
                    C$SPARE(461) = 0    ;*C$SPARE(456) ;*Y.CHRG         ;*Y.BILL.AMOUNT
                    C$SPARE(460) = 0
                    Y.FLAG.60.61 = '61'
                END
                IF Y.TXN.TYPE EQ 'OT30' THEN
                    C$SPARE(461) = 0    ;*C$SPARE(456) ;*Y.CHRG
                    C$SPARE(460) = 0
                    Y.FLAG.60.61 = '61'
                END
                IF Y.TXN.TYPE EQ 'ACL3' OR Y.TXN.TYPE EQ 'ACB6' OR Y.TXN.TYPE EQ 'AC42' THEN
                    C$SPARE(461) = 0    ;*C$SPARE(456) ;*Y.CHRG
                    C$SPARE(460) = 0
                    Y.FLAG.60.61 = '61'
                END
*RETURNED CHECK COMMISION
                IF Y.TXN.TYPE EQ 'ACIW' THEN
                    C$SPARE(461) = 0    ;*C$SPARE(456) ;*Y.CHRG
                    C$SPARE(460) = 0
                    Y.FLAG.60.61 = '61'
                END

                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACQA' OR Y.TXN.TYPE EQ 'ACRP') THEN
                    C$SPARE(461) = 0    ;*C$SPARE(456) ;*Y.CHRG         ;*Y.BILL.AMOUNT
                    C$SPARE(460) = 0
                    Y.FLAG.60.61 = '61'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'AC18' OR Y.TXN.TYPE EQ 'ACQP') THEN
                    C$SPARE(461) = 0    ;*C$SPARE(456) ;*Y.CHRG         ;*Y.BILL.AMOUNT
                    C$SPARE(460) = 0
                    Y.FLAG.60.61 = '61'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACCA' OR Y.TXN.TYPE EQ 'ACWF') THEN
                    C$SPARE(461) = 0    ;*C$SPARE(456) ;*Y.CHRG         ;*Y.BILL.AMOUNT
                    C$SPARE(460) = 0
                    Y.FLAG.60.61 = '61'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACB6' OR Y.TXN.TYPE EQ 'ACPD') THEN
                    C$SPARE(461) = 0    ;*C$SPARE(456) ;*Y.CHRG         ;*Y.BILL.AMOUNT
                    C$SPARE(460) = 0
                    Y.FLAG.60.61 = '61'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPA' OR Y.TXN.TYPE EQ 'ACPY') THEN
                    C$SPARE(461) = 0    ;*C$SPARE(456) ;*Y.CHRG         ;*Y.BILL.AMOUNT
                    C$SPARE(460) = 0
                    Y.FLAG.60.61 = '61'
                END
                IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACLP') THEN
                    C$SPARE(461) = 0    ;*C$SPARE(456) ;*Y.CHRG
                    C$SPARE(460) = 0
                    Y.FLAG.60.61 = '61'
                END


            END
        END
    END
    IF (R.TELLER) THEN
        IF NOT(R.REDO.TRANSACTION.CHAIN) THEN
            C$SPARE(460) = 0  ;*Y.CREDIT.AMT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
    END

    IF NOT(R.REDO.TRANSACTION.CHAIN) THEN
        IF Y.TXN.ID[1,2] EQ 'AA' AND Y.TXN.TYPE EQ 'N/A' THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
        IF Y.TXN.ID[1,2] EQ 'AA' AND Y.TXN.TYPE EQ 'ACPA' THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPO') THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPA') THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT          ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPY') THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT          ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
        IF Y.TXN.TYPE EQ 'OT30' THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
        IF Y.TXN.TYPE EQ 'ACL3' OR Y.TXN.TYPE EQ 'ACB6' OR Y.TXN.TYPE EQ 'AC42' THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
*RETURNED CHECK COMMISION
        IF Y.TXN.TYPE EQ 'ACIW' THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END

        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACQA' OR Y.TXN.TYPE EQ 'ACRP') THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT          ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'AC18' OR Y.TXN.TYPE EQ 'ACQP') THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT          ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACCA' OR Y.TXN.TYPE EQ 'ACWF') THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT          ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACB6' OR Y.TXN.TYPE EQ 'ACPD') THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT          ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPA' OR Y.TXN.TYPE EQ 'ACPY') THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT          ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACLP') THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACPP') THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
        IF Y.TXN.ID[1,2] EQ 'FT' AND (Y.TXN.TYPE EQ 'ACCP') THEN
            C$SPARE(460) = 0  ;*Y.BILL.AMOUNT
            C$SPARE(461) = 0
            Y.FLAG.60.61 = '60'
        END
    END


*DEFAULT:
    IF Y.TXN.TYPE EQ '' THEN
        IF Y.CHRG EQ '' OR Y.CHRG EQ 0 THEN
            C$SPARE(461) = 0  ;*Y.BILL.AMOUNT
            C$SPARE(460) = 0
            Y.FLAG.60.61 = '61'
        END ELSE
            C$SPARE(461) = 0  ;*Y.CHRG
            C$SPARE(460) = 0
            Y.FLAG.60.61 = '61'
        END
    END
    IF C$SPARE(461) NE '' THEN
        C$SPARE(461) = 0      ;*EREPLACE(C$SPARE(461),"00DOP","")
*C$SPARE(461) = EREPLACE(C$SPARE(461),"0DOP","")
*C$SPARE(461) = EREPLACE(C$SPARE(461),"DOP","")
        Y.FLAG.60.61 = '61'
    END
    IF C$SPARE(460) NE '' THEN
        C$SPARE(460) = 0      ;*EREPLACE(C$SPARE(460),"00DOP","")
*C$SPARE(460) = EREPLACE(C$SPARE(460),"0DOP","")
*C$SPARE(460) = EREPLACE(C$SPARE(460),"DOP","")
        Y.FLAG.60.61 = '60'
    END

RETURN

END
