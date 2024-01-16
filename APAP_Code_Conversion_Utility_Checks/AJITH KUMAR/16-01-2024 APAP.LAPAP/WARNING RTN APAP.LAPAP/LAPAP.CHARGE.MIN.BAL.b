* @ValidationCode : MjozMTQzNjMxODI6Q3AxMjUyOjE2OTAxNjc1NDEwMTA6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>70</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.CHARGE.MIN.BAL(Y.CUSTOMER.ID)

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 20-JULY-2023      Harsha                R22 Auto Conversion  - FM to @FM
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_TSA.COMMON
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.COMPANY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_F.AC.CHARGE.REQUEST
   $USING EB.LocalReferences
   $USING EB.TransactionControl
    $INCLUDE I_F.LAPAP.CHARGE.BAL.MIN.PARAM
    $INSERT I_LAPAP.CHARGE.MIN.BAL.COMMON

    GOSUB MAIN
RETURN

*****
MAIN:
*****
    R.CUSTOMER = ''; CUSTOMER.ERR = ''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    CUS.SEG.POS= '';
*    CALL GET.LOC.REF("CUSTOMER","L.CU.SEGMENTO",CUS.SEG.POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.SEGMENTO",CUS.SEG.POS);* R22 UTILITY AUTO CONVERSION
    Y.SEGMENTO              = R.CUSTOMER<EB.CUS.LOCAL.REF,CUS.SEG.POS>

    GOSUB READ.CUSTOMER.ACCOUNT

RETURN

**********************
READ.CUSTOMER.ACCOUNT:
**********************

    R.CUSTOMER.ACC = ''; CUSTOMER.ACC.ERR = ''
    CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.CUSTOMER.ID,R.CUSTOMER.ACC,F.CUSTOMER.ACCOUNT,CUSTOMER.ACC.ERR)

    Y.ACC.NUM                = R.CUSTOMER.ACC
    Y.ACC.NUM.COUNT          = DCOUNT(Y.ACC.NUM,@FM)

    Y.APLICA        = '';
    i = 0;
    FOR i = 1 TO Y.ACC.NUM.COUNT
        CRT Y.ACC.NUM<i>
        Y.ACCOUNT.NO           = Y.ACC.NUM<i>

        R.ACCOUNT =''; ACCOUNT.ERR = ''
        CALL F.READ(FN.ACCOUNT, Y.ACCOUNT.NO, R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
        Y.ARRANGEMENT.ID    = R.ACCOUNT<AC.ARRANGEMENT.ID>
        Y.CATEGORY          = R.ACCOUNT<AC.CATEGORY>
        Y.START.BAL         = R.ACCOUNT<AC.START.YEAR.BAL>

        ACC.STATUS.POS  =  ""
*        CALL GET.LOC.REF("ACCOUNT","L.AC.STATUS",ACC.STATUS.POS)
EB.LocalReferences.GetLocRef("ACCOUNT","L.AC.STATUS",ACC.STATUS.POS);* R22 UTILITY AUTO CONVERSION
        Y.STATUS              = R.ACCOUNT<AC.LOCAL.REF,ACC.STATUS.POS>

        FINDSTR Y.STATUS IN Y.STATUS.COM SETTING V.FLD, V.VAL THEN
            IF Y.CATEGORY GE "6000" AND Y.CATEGORY LE "6012" OR Y.CATEGORY GE "6020" AND Y.CATEGORY LE "6599" THEN
                IF Y.CATEGORY EQ "6023" OR Y.ARRANGEMENT.ID NE "" THEN
                    Y.APLICA        = 'FALSE'
                    CALL OCOMO("ACCOUNT DOES NOT APPLIES FOR PROCESSING, ACC. NO.: " : Y.ACCOUNT.NO :" FOR CATEGORY 6023")
                END ELSE
                    Y.APLICA            = "TRUE"
                    CALL OCOMO("ACCOUNT APPLIES FOR PROCESSING, ACC. NO.: " : Y.ACCOUNT.NO)
                    GOSUB MIN.PROCESS
                END
            END
        END ELSE
            CALL OCOMO("STATUS NOT FOUND IN ARRAY FOR ACC. NO.:": Y.ACCOUNT.NO)
        END

    NEXT i
RETURN

*************
MIN.PROCESS:
*************

    IF Y.APLICA EQ "TRUE" THEN
        R.CHARGE.PARAM =''; CHARGE.PARAM.ERR = ''
*        CALL F.READ(FN.ST.LAPAP.CHARGE.BAL.MIN.PARAM,Y.SEGMENTO,R.CHARGE.PARAM,F.ST.L.APAP.CHARGE.BAL.MIN.PARAM,CHARGE.PARAM.ERR)
        CALL CACHE.READ(FN.ST.LAPAP.CHARGE.BAL.MIN.PARAM,Y.SEGMENTO,R.CHARGE.PARAM,CHARGE.PARAM.ERR);* R22 UTILITY AUTO CONVERSION
        IF NOT (R.CHARGE.PARAM) THEN
        END

        Y.BALANCES.MIN = R.CHARGE.PARAM<ST.LAP33.BALANCE.PROMEDIO>
        Y.CHARGE.CODE = R.CHARGE.PARAM<ST.LAP33.CODIGO.CARGO>

        Y.AVG.BAL = ''
*       CALL LAPAP.ACCT.AVG.AMT.RT(Y.ACCOUNT.NO,Y.YEAR.ACT,Y.MES.ACT,Y.AVG.BAL)
        APAP.LAPAP.lapapAcctAvgAmtRt(Y.ACCOUNT.NO, Y.YEAR.ACT, Y.MES.ACT, Y.AVG.BAL) ;*R22 Manual Conversion

        IF Y.AVG.BAL LT Y.BALANCES.MIN THEN
            CALL OCOMO("ACCOUNT APPLIES FOR CHARGE, ACC. NO.: " : Y.ACCOUNT.NO)
            Y.VER.NAME                          = 'AC.CHARGE.REQUEST,MIN.BAL';
            Y.APP.NAME                          = 'AC.CHARGE.REQUEST';
            Y.FUNC                              = 'I';
            Y.PRO.VAL                           = "PROCESS";
            Y.GTS.CONTROL                       = "";
            Y.NO.OF.AUTH                        = "";
            FINAL.OFS                           = "";
            Y.TRANS.ID                          = "";

            R.CHARGE<CHG.CHARGE.CODE>           = Y.CHARGE.CODE
            R.CHARGE<CHG.DEBIT.ACCOUNT>         = Y.ACCOUNT.NO

            CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.CHARGE,FINAL.OFS)

            OFS.MSG.ID = ''; OFS.SOURCE.ID = "DM.OFS.SRC.VAL"; OPTIONS = ''
            CALL OFS.POST.MESSAGE(FINAL.OFS,OFS.MSG.ID,OFS.SOURCE.ID,OPTIONS)
*            CALL JOURNAL.UPDATE(Y.CARD.REQUEST.ID)
EB.TransactionControl.JournalUpdate(Y.CARD.REQUEST.ID);* R22 UTILITY AUTO CONVERSION
        END
    END
RETURN
END
