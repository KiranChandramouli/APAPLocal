$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.DEBIT.RPT(Y.FINAL.ARRAY)
*********************************************************************************************************************************************
*-------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.NOF.DEBIT.RPT
*--------------------------------------------------------------------------------
*Description :This subroutine is attached to the ENQUIRY REDO.PAY.ENQ.RPT
*             which displays the Direct payroll details
*--------------------------------------------------------------------------------
* Linked With : ENQUIRY REDO.PAY.ENQ.RPT
* In Parameter : None
* Out Parameter : None
*---------------------------------------------------------------------------------
*Modification History:
*------------------------
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   08-06-2011       DHAMU S            ODR-2010-03-0093         Initial Creation
*   27-08-2014       Egambaram A        REDO.NOF.DEBIT.RPT       changes done
* 13-APRIL-2023      Harsha                R22 Auto Conversion  - F.READ to CACHE.READ , VM to @VM , FM to @FM  and SM to @SM
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AC.INWARD.ENTRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER.PARAMETER
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.AC.ENTRY.PARAM

    GOSUB INIT
    GOSUB OPEN
    GOSUB PROCESS

RETURN
*****
INIT:
*****
    Y.DATE = ''; Y.TXN.OPR = '' ; Y.CODE = '' ; Y.EMP.CODE = ''; Y.COUNT  = ''; Y.TXN.DATE1 = ''; Y.TXN.DATE2 = '';
    Y.AC.DATE = '' ; Y.COMP.CODE = '' ; Y.CUSTOMER.ID = ''; Y.CURRENCY = ''; Y.ACT.NUM = ''; Y.ACT.NAME = '';
    Y.COUNTERPARTY = ''; Y.LOCAL.AMOUNT = ''; Y.ERR.MSG = ''; Y.AUTH = ''; Y.INPUTTER = ''; ACT.CUST = '';
    Y.MTH.PAY = ''; Y.CATEGORY = '' ; Y.TELLER.CATEGORY = '' ; Y.ERR.FLAG = ''; Y.AMOUNT = ''; Y.LOCAL.AMOUNT = '';

RETURN
*****
OPEN:
*****
    FN.AC.INWARD.ENTRY = 'F.AC.INWARD.ENTRY'
    F.AC.INWARD.ENTRY  = ''
    CALL OPF(FN.AC.INWARD.ENTRY,F.AC.INWARD.ENTRY)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    F.TELLER.PARAMETER  = ''
    CALL OPF(FN.TELLER.PARAMETER,F.TELLER.PARAMETER)

    FN.AC.ENTRY.PARAM = 'F.AC.ENTRY.PARAM'
    F.AC.ENTRY.PARAM = ''
    CALL OPF(FN.AC.ENTRY.PARAM,F.AC.ENTRY.PARAM)

RETURN
********
PROCESS:
********
    GOSUB FORM.SELECT.CMD
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,REC.ERR)
    IF NOT(SEL.LIST) THEN
        RETURN
    END
    GOSUB GET.DETAILS
RETURN
****************
FORM.SELECT.CMD:
****************
    LOCATE "DATE" IN D.FIELDS<1> SETTING DATE.POS THEN
        Y.DATE = D.RANGE.AND.VALUE<DATE.POS>
        Y.TXN.OPR = D.LOGICAL.OPERANDS<DATE.POS>
        GOSUB CHECK.DATE.RANGE
    END
    LOCATE "CLIENT.CODE" IN D.FIELDS<1> SETTING Y.CLIENT.POS THEN
        Y.CODE = D.RANGE.AND.VALUE<Y.CLIENT.POS>
    END

    LOCATE "EMP.CODE" IN D.FIELDS<1> SETTING EMP.POS THEN
        Y.EMP.CODE = D.RANGE.AND.VALUE<EMP.POS>
    END
    GOSUB CHECK.SELECTION
*SEL.CMD := " AND @ID LIKE NOMINA... BY VALUE.DATE BY COMPANY.CODE BY CURRENCY BY ERROR.MESSAGE"
*CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,REC.ERR)
RETURN
*****************
CHECK.DATE.RANGE:
*****************
    Y.COUNT =DCOUNT(Y.DATE,@SM)
    Y.TXN.DATE1 = FIELD(Y.DATE,@SM,1)
    Y.TXN.DATE2 = FIELD(Y.DATE,@SM,2)
    IF Y.COUNT GT 1 THEN
        IF Y.TXN.OPR EQ '1' THEN
            ENQ.ERROR = "EB-REDO.TWO.DATES WITH ":@ID
        END
    END

    IF Y.TXN.OPR EQ '2' AND Y.COUNT EQ '1' THEN
        ENQ.ERROR = "EB-REDO.ONE.DATE WITH " :@ID
    END
    IF Y.COUNT EQ '2' THEN
        IF Y.TXN.DATE1 GT Y.TXN.DATE2 THEN
            ENQ.ERRO = "EB-REDO.DATE.ERR"
        END
    END
    IF Y.COUNT EQ "1" THEN
        SEL.CMD =" SELECT ":FN.AC.INWARD.ENTRY:" WITH VALUE.DATE EQ ":Y.TXN.DATE1
    END ELSE
        GOSUB CHECK.DATE
    END
RETURN
***********
CHECK.DATE:
***********
    IF NOT(NUM(Y.TXN.DATE1)) OR LEN(Y.TXN.DATE1) NE '8' OR NOT(NUM(Y.TXN.DATE2)) OR LEN(Y.TXN.DATE2) NE '8' THEN
        ENQ.ERROR = "EB-REDO.DATE.RANGE"
    END ELSE
        IF Y.TXN.DATE1[5,2] GT '12' OR Y.TXN.DATE2[5,2] GT '12' OR Y.TXN.DATE1[7,2] GT '31' OR Y.TXN.DATE2[7,2] GT '31' OR Y.TXN.DATE1 GT Y.TXN.DATE2 THEN
            ENQ.ERROR = "EB-REDO.DATE.RANGE"
        END ELSE
            SEL.CMD =" SELECT ":FN.AC.INWARD.ENTRY:" WITH VALUE.DATE GE ":Y.TXN.DATE1:' AND VALUE.DATE LE ':Y.TXN.DATE2
        END
    END
RETURN
****************
CHECK.SELECTION:
****************
    IF Y.CODE THEN
        SEL.CMD :=" AND CUSTOMER.ID EQ ":Y.CODE
    END
    IF Y.EMP.CODE THEN
        SEL.CMD :=" AND COMPANY.CODE EQ ":Y.EMP.CODE
    END
RETURN
************
GET.DETAILS:
************
    LOOP
        REMOVE Y.SEL.ID FROM SEL.LIST SETTING SEL.POS
    WHILE Y.SEL.ID:SEL.POS
        GOSUB GET.INWARD.ENTRY
    REPEAT
RETURN
*****************
GET.INWARD.ENTRY:
*****************
    CALL F.READ(FN.AC.INWARD.ENTRY,Y.SEL.ID,R.AC.INWARD.ENTRY,F.AC.INWARD.ENTRY,ENTRY.ERR)
    Y.PARAM.ID = FIELD(Y.SEL.ID,'.',1)
    CALL CACHE.READ(FN.AC.ENTRY.PARAM, Y.PARAM.ID, R.AC.ENTRY.PARAM, AC.ENT.PAR)	;*R22 Auto Conversion  - F.READ to CACHE.READ
    Y.CONTRA.ACC = R.AC.ENTRY.PARAM<ACEP.CONTRA.ACCT>

    Y.AC.DATE                        = R.AC.INWARD.ENTRY<ACIE.VALUE.DATE>
    Y.COMP.CODE                      = R.AC.INWARD.ENTRY<ACIE.COMPANY.CODE>
    Y.CUSTOMER.ID                    = R.AC.INWARD.ENTRY<ACIE.CUSTOMER.ID>
    Y.CURRENCY                       = R.AC.INWARD.ENTRY<ACIE.CURRENCY>
    Y.ACT.NUM                        = R.AC.INWARD.ENTRY<ACIE.ACCOUNT.NUMBER>
    Y.ACT.NAME                       = Y.CONTRA.ACC
    GOSUB GET.METHOD.PAYMENT
    Y.COUNTERPARTY                   = R.AC.INWARD.ENTRY<ACIE.COUNTERPARTY>
    GOSUB CHECK.CURRENCY
    Y.LOCAL.AMOUNT                   = R.AC.INWARD.ENTRY<ACIE.AMOUNT.LCY>
    Y.ERR.MSG                        = R.AC.INWARD.ENTRY<ACIE.ERROR.MESSAGE>
    Y.AUTH                           = R.AC.INWARD.ENTRY<ACIE.AUTHORISER>
    Y.AUTH = FIELD(Y.AUTH,'_',2)
    Y.INPUTTER                       = R.AC.INWARD.ENTRY<ACIE.INPUTTER>
    Y.INPUTTER = FIELD(Y.INPUTTER,'_',2)
    GOSUB FINAL.ARRAY
RETURN
*******************
GET.METHOD.PAYMENT:
*******************
    Y.ERR.FLAG = '' ; Y.MTH.PAY = ''; Y.CATEGORY = '' ; Y.TELLER.CATEGORY = ''

    CALL F.READ(FN.ACCOUNT,Y.CONTRA.ACC,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    ACT.CUST = R.ACCOUNT<AC.CUSTOMER>
    IF ACT.CUST NE '' THEN
        Y.MTH.PAY = 'TRANSFER'
    END ELSE
        IF ACT.CUST EQ '' THEN
            Y.CATEGORY = R.ACCOUNT<AC.CATEGORY>
        END
        IF Y.COMP.CODE NE '' THEN
            CALL CACHE.READ(FN.TELLER.PARAMETER, Y.COMP.CODE, R.TELLER.PARAMETER, PARAMETER.ERR)	;*R22 Auto Conversion  - F.READ to CACHE.READ
            Y.TELLER.CATEGORY = R.TELLER.PARAMETER<TT.PAR.TRAN.CATEGORY>
        END
        IF Y.CATEGORY THEN
            LOCATE Y.CATEGORY IN Y.TELLER.CATEGORY<1,1> SETTING CATEG.POS ELSE
                Y.ERR.FLAG  = '1'
            END
        END
        IF Y.ERR.FLAG EQ '1' THEN
            Y.MTH.PAY = 'CHEQUE'
        END ELSE
            Y.MTH.PAY = 'CASH'
        END
    END
RETURN
***************
CHECK.CURRENCY:
***************
    IF Y.CURRENCY EQ LCCY THEN
        Y.AMOUNT  = R.AC.INWARD.ENTRY<ACIE.AMOUNT.LCY>
    END ELSE
        Y.AMOUNT  = R.AC.INWARD.ENTRY<ACIE.AMOUNT.FCY>
    END
RETURN
************
FINAL.ARRAY:
************
    IF Y.ERR.MSG EQ '' THEN
***********                      1            2               3              4                5                6             7                8                9             10        11       12              13
        Y.FINAL.ARRAY<-1> = Y.AC.DATE:"*":Y.COMP.CODE:"*":Y.MTH.PAY:"*":Y.CUSTOMER.ID:"*":Y.CONTRA.ACC:"*":Y.ACT.NAME:"*":Y.ACT.NUM:"*":Y.COUNTERPARTY:"*":Y.CURRENCY:"*":Y.AMOUNT:"*":'':"*":Y.INPUTTER:"*":Y.AUTH
    END ELSE
***********                      1            2              3               4                5               6           7                   8                 9             10          11            12            13
        Y.FINAL.ARRAY<-1> = Y.AC.DATE:"*":Y.COMP.CODE:"*":Y.MTH.PAY:"*":Y.CUSTOMER.ID:"*":Y.CONTRA.ACC:"*":Y.ACT.NAME:"*":Y.ACT.NUM:"*":Y.COUNTERPARTY:"*":Y.CURRENCY:"*":Y.AMOUNT:"*":Y.ERR.MSG:"*":Y.INPUTTER:"*":Y.AUTH
    END
RETURN
*******************************************************************
END
*----------------------------End of programs------------------------------------------------
