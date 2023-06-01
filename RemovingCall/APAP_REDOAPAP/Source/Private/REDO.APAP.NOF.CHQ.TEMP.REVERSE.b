* @ValidationCode : MjotMTQzMjU0MDQxNjpDcDEyNTI6MTY4NDgzNjA0NzgyNTpJVFNTOi0xOi0xOjEyNjY6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1266
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE  REDO.APAP.NOF.CHQ.TEMP.REVERSE(Y.RETURN.ARRAY)
*----------------------------------------------------------------------------
*DESCRIPTIONS:
*-------------
* This is the Nofile Enquiry for the Dev FS-58
*
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who             Reference            Description
* 11-OCT-10    Kishore.SP        ODR-2010-03-0156      Initial Creation
* Date                   who                   Reference
* 06-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION FM TO @FM AND SM TO @SM AND VM TO @VM AND CONVERT TO CHANGE AND ! TO * AND F.READ TO CACHE.READ AND REMOVED F.DEPT.ACCT.OFFICER
* 06-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.PAYMENT.STOP
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.RELATION
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.PAYMENT.STOP.TYPE

*----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB LOCATE.VALUES
    GOSUB FORM.SEL.ARR
RETURN
*----------------------------------------------------------------------------
INITIALISE:
*----------
* Intialise the necessary variables and Open the file
*
    FN.PAYMENT.STOP = 'F.PAYMENT.STOP'
    F.PAYMENT.STOP  = ''
    CALL OPF(FN.PAYMENT.STOP,F.PAYMENT.STOP)
*
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
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
    FN.PAYMENT.STOP.TYPE = 'F.PAYMENT.STOP.TYPE'
    F.PAYMENT.STOP.TYPE  = ''
    CALL OPF(FN.PAYMENT.STOP.TYPE,F.PAYMENT.STOP.TYPE)
*
    APPL.ARRAY = "CUSTOMER":@FM:"PAYMENT.STOP"
    FLD.ARRAY  = "L.CU.TIPO.CL":@FM:"L.PS.ISSUE.DATE":@VM:"L.PS.EXP.DATE":@VM:"L.PS.STP.PMT.ST"
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CU.TIPO.CL.POS      = FLD.POS<1,1>
    LOC.PS.ISSUE.DATE.POS     = FLD.POS<2,1>
    LOC.PS.EXP.DATE.POS       = FLD.POS<2,2>
    LOC.PS.STP.PMT.ST.POS     = FLD.POS<2,3>
*
    Y.RETURN.ARRAY = ''
    Y.CLIENT.CODE  = ''
    Y.AC.NUMBER    = ''
    Y.AMOUNT       = ''
    Y.STATUS       = ''
RETURN
*----------------------------------------------------------------------------
LOCATE.VALUES:
*-------------
* Locate the values
*
    LOCATE "ACCOUNT.NUMBER" IN D.FIELDS<1> SETTING Y.AC.NO.POS THEN
        Y.AC.NO.OPERAND       = D.LOGICAL.OPERANDS<Y.AC.NO.POS>
        Y.AC.NUMBER           = D.RANGE.AND.VALUE<Y.AC.NO.POS>
    END
*
    LOCATE "AMOUNT" IN D.FIELDS<1> SETTING Y.AMT.POS THEN
        Y.AMT.OPERAND        = D.LOGICAL.OPERANDS<Y.AMT.POS>
        Y.AMOUNT             = D.RANGE.AND.VALUE<Y.AMT.POS>
        Y.AMOUNT.FRM         = FIELD(Y.AMOUNT,@SM,1)
        Y.AMOUNT.TO          = FIELD(Y.AMOUNT,@SM,2)
    END
*
    LOCATE "STATUS" IN D.FIELDS<1> SETTING Y.STA.POS THEN
        Y.STA.OPERAND        = D.LOGICAL.OPERANDS<Y.STA.POS>
        Y.STATUS             = D.RANGE.AND.VALUE<Y.STA.POS>
    END
*
    TEMP.RANGE.AND.VALUE = D.RANGE.AND.VALUE
    CHANGE @FM TO ',' IN TEMP.RANGE.AND.VALUE

    Y.CLASSIFICATION = TEMP.RANGE.AND.VALUE
*
RETURN
*----------------------------------------------------------------------------
FORM.SEL.ARR:
*------------
* Form the select Array
*
    SEL.CMD = "SELECT ":FN.PAYMENT.STOP:" WITH @ID"
*
    IF Y.AC.NUMBER NE '' THEN
        SEL.CMD := "  AND ACCOUNT.NUMBER EQ ":Y.AC.NUMBER
    END ELSE
        IF Y.AC.NUMBER EQ '' THEN
            SEL.CMD := " AND ACCOUNT.NUMBER NE '' "
        END
    END
*
    IF Y.AMOUNT NE '' THEN
        SEL.CMD := " AND AMOUNT.FROM GE ":Y.AMOUNT.FRM:" AND AMOUNT.TO LE ":Y.AMOUNT.TO
    END ELSE
        IF Y.AMOUNT EQ '' THEN
            Y.AMOUNT =''
        END
    END

*
    IF Y.STATUS NE '' THEN
        SEL.CMD :=" AND L.PS.STP.PMT.ST EQ ":Y.STATUS
    END ELSE
        IF Y.STATUS EQ '' THEN
            SEL.CMD :=" AND L.PS.STP.PMT.ST NE '' "
        END
    END
*
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------------
PROCESS:
*-------
*
    Y.SEL.LIST = ''
    CALL EB.READLIST(SEL.CMD,Y.SEL.LIST,'',Y.SEL.CNT,Y.SEL.ERR)
    LOOP
*
        REMOVE Y.PAYMENT.STOP.ID FROM Y.SEL.LIST SETTING Y.PS.POS
    WHILE Y.PAYMENT.STOP.ID:Y.PS.POS
*
        R.PAYMENT.STOP = ''
        CALL F.READ(FN.PAYMENT.STOP,Y.PAYMENT.STOP.ID,R.PAYMENT.STOP,F.PAYMENT.STOP,Y.PS.ERR)
        IF NOT(R.PAYMENT.STOP) THEN
            CONTINUE
        END

        Y.BDY.ACCT.NO    = Y.PAYMENT.STOP.ID
        Y.BDY.AGENCY     = R.PAYMENT.STOP<AC.PAY.CO.CODE>
        Y.BDY.STOP.DATE  = R.PAYMENT.STOP<AC.PAY.STOP.DATE>

        Y.BDY.PAYEE      = R.PAYMENT.STOP<AC.PAY.BENEFICIARY>
        Y.BDY.AMT.FRM    = R.PAYMENT.STOP<AC.PAY.AMOUNT.FROM>
        Y.BDY.AMT.TO     = R.PAYMENT.STOP<AC.PAY.AMOUNT.TO>
*
        GOSUB READ.PAY.STOP.TYPE
*
        Y.INPUTTER       = R.PAYMENT.STOP<AC.PAY.INPUTTER>
        Y.AUTHORISER     = R.PAYMENT.STOP<AC.PAY.AUTHORISER>
        Y.BDY.INPUTTER   = FIELD(Y.INPUTTER,"_",2)
        Y.BDY.AUTHORIZER = FIELD(Y.AUTHORISER,"_",2)
*
* Fetch the lastest status their Exp date and Issuing date
*
        IF Y.STATUS THEN
            GOSUB GET.STATUS.COND
        END ELSE
            Y.BDY.FRM.CHQ = R.PAYMENT.STOP<AC.PAY.FIRST.CHEQUE.NO>
            Y.BDY.TO.CHQ  = R.PAYMENT.STOP<AC.PAY.LAST.CHEQUE.NO>
            Y.BDY.STATUS  = R.PAYMENT.STOP<AC.PAY.LOCAL.REF><1,LOC.PS.STP.PMT.ST.POS>
            Y.BDY.EXP.DATE = R.PAYMENT.STOP<AC.PAY.LOCAL.REF><1,LOC.PS.EXP.DATE.POS>
            Y.BDY.ISSU.DATE = R.PAYMENT.STOP<AC.PAY.LOCAL.REF><1,LOC.PS.ISSUE.DATE.POS>
            Y.REASON.ARR  = R.PAYMENT.STOP<AC.PAY.PAYM.STOP.TYPE>
            GOSUB READ.PAY.STOP.TYPE
        END

        CHANGE @SM TO @VM IN Y.BDY.FRM.CHQ
        CHANGE @SM TO @VM IN Y.BDY.TO.CHQ
        CHANGE @SM TO @VM IN Y.BDY.STATUS
        CHANGE @SM TO @VM IN Y.BDY.ISSU.DATE
        CHANGE @SM TO @VM IN Y.BDY.EXP.DATE

        CHANGE @FM TO @VM IN Y.BDY.FRM.CHQ
        CHANGE @FM TO @VM IN Y.BDY.TO.CHQ
        CHANGE @FM TO @VM IN Y.BDY.STATUS
        CHANGE @FM TO @VM IN Y.BDY.ISSU.DATE
        CHANGE @FM TO @VM IN Y.BDY.EXP.DATE

        GOSUB GET.ACCOUNT.NAME
        GOSUB FORM.ARRAY
*
*
    REPEAT


RETURN
*----------------------------------------------------------------------------
****************
GET.STATUS.COND:
****************
    Y.PS.STATUS     = R.PAYMENT.STOP<AC.PAY.LOCAL.REF><1,LOC.PS.STP.PMT.ST.POS>
    CHANGE @SM TO @FM IN Y.PS.STATUS
    Y.STATUS.CNT    = DCOUNT(Y.PS.STATUS,@FM)
    Y.STATUS.INT = 1
    LOOP
    WHILE Y.STATUS.INT LE Y.STATUS.CNT
        Y.CHK.STATUS = Y.PS.STATUS<Y.STATUS.INT>
        IF Y.CHK.STATUS EQ Y.STATUS THEN
            Y.BDY.FRM.CHQ<-1> = R.PAYMENT.STOP<AC.PAY.FIRST.CHEQUE.NO,Y.STATUS.INT>
            Y.BDY.TO.CHQ<-1>  = R.PAYMENT.STOP<AC.PAY.LAST.CHEQUE.NO,Y.STATUS.INT>
            Y.BDY.STATUS<-1>  = Y.CHK.STATUS
            Y.REASON.ARR<-1>  = R.PAYMENT.STOP<AC.PAY.PAYM.STOP.TYPE,Y.STATUS.INT>
            Y.BDY.EXP.DATE<-1> = R.PAYMENT.STOP<AC.PAY.LOCAL.REF,LOC.PS.EXP.DATE.POS,Y.STATUS.INT>
            Y.BDY.ISSU.DATE<-1> = R.PAYMENT.STOP<AC.PAY.LOCAL.REF,LOC.PS.ISSUE.DATE.POS,Y.STATUS.INT>
        END
        Y.STATUS.INT += 1
    REPEAT

    CHANGE @SM TO @VM IN Y.BDY.FRM.CHQ
    CHANGE @SM TO @VM IN Y.BDY.TO.CHQ
    CHANGE @SM TO @VM IN Y.BDY.STATUS
    CHANGE @SM TO @VM IN Y.BDY.ISSU.DATE
    CHANGE @SM TO @VM IN Y.BDY.EXP.DATE

    CHANGE @FM TO @VM IN Y.BDY.FRM.CHQ
    CHANGE @FM TO @VM IN Y.BDY.TO.CHQ
    CHANGE @FM TO @VM IN Y.BDY.STATUS
    CHANGE @FM TO @VM IN Y.BDY.ISSU.DATE
    CHANGE @FM TO @VM IN Y.BDY.EXP.DATE
    CHANGE @FM TO @VM IN Y.REASON.ARR
    GOSUB READ.PAY.STOP.TYPE

*
*
RETURN
*----------------------------------------------------------------------------
GET.ACCOUNT.NAME:
*----------------
* Get the Account Executive name
*
    Y.ACCOUNT.ID = Y.PAYMENT.STOP.ID
    Y.ACT.ID = NUM(Y.ACCOUNT.ID)
    IF Y.ACT.ID THEN
        GOSUB READ.ACCOUNT
    END ELSE
        R.INT.ACCOUNT = ''
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.INT.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
        Y.BDY.ACCT.NAME = R.INT.ACCOUNT<AC.ACCOUNT.TITLE.1>
        RETURN
    END
*
    CUSTOMER.ID         = R.ACCOUNT<AC.CUSTOMER>
    Y.ACCT.OFFICER.ID   = R.ACCOUNT<AC.ACCOUNT.OFFICER>
*
    GOSUB READ.ACCT.OFF
    Y.BDY.ACCT.OFFICER  = R.DEPT.ACCT.OFFICER<EB.DAO.NAME>
*
    GOSUB READ.CUSTOMER
*
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ 'PERSONA FISICA' OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ 'CLIENTE MENOR' THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ 'PERSONA JURIDICA' THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.NAME.1,1>:' ':R.CUSTOMER<EB.CUS.NAME.2,1>
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
        Y.REL.DESC  = R.RELATION<EB.REL.DESCRIPTION>
        CUSTOMER.ID = R.ACCOUNT<AC.JOINT.HOLDER,Y.COUNT>
        GOSUB READ.CUSTOMER

        IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ 'PERSONA FISICA' OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ 'CLIENTE MENOR' THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
        END

        IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ 'PERSONA JURIDICA' THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>:' ':R.CUSTOMER<EB.CUS.NAME.2,1>
        END

        IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
            Y.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
        END

        Y.CUS.NAMES := @VM:Y.REL.DESC:'-': Y.CUS.NAME
        Y.CLIENT.CODE := @VM:CUSTOMER.ID

        Y.COUNT += 1
    REPEAT

    Y.BDY.ACCT.NAME = Y.CUS.NAMES

RETURN
*----------------------------------------------------------------------------
READ.ACCOUNT:
*-------------
* In this para of the code, file ACCOUNT is read
*
    R.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
    CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
RETURN
*----------------------------------------------------------------------------
READ.CUSTOMER:
*-------------
* In this para of the code, file CUSTOMER is read
*
    R.CUSTOMER  = ''
    CUSTOMER.ER = ''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ER)
RETURN
*----------------------------------------------------------------------------
READ.RELATION:
*-------------
* In this para of the code, file RELATION is read
*
    R.RELATION  = ''
    RELATION.ER = ''
    CALL F.READ(FN.RELATION,RELATION.ID,R.RELATION,F.RELATION,RELATION.ER)
RETURN
*----------------------------------------------------------------------------
READ.ACCT.OFF:
*-------------
* In this para of the code, file DEPT.ACCT.OFFICER is read
*
    ACTOFFICER.ERR      = ''
    R.DEPT.ACCT.OFFICER = ''
    CALL CACHE.READ(FN.DEPT.ACCT.OFFICER, Y.ACCT.OFFICER.ID, R.DEPT.ACCT.OFFICER, ACTOFFICER.ERR) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.DEPT.ACCT.OFFICER
RETURN
*----------------------------------------------------------------------------
READ.PAY.STOP.TYPE:
*------------------
* To get the reason
*
    Y.REASON.DES  = ''
*
    Y.CNT.REASON = DCOUNT(Y.REASON.ARR,@VM)
*
    Y.CNTR = 1

    LOOP
    WHILE Y.CNTR LE Y.CNT.REASON
        Y.REASON.ID = Y.REASON.ARR<1,Y.CNTR>
*
        R.PAYMENT.STOP.TYPE = ''
        Y.REASON = ''
        CALL F.READ(FN.PAYMENT.STOP.TYPE,Y.REASON.ID,R.PAYMENT.STOP.TYPE,F.PAYMENT.STOP.TYPE,PAYSP.TY.ERR)
        Y.REASON         = R.PAYMENT.STOP.TYPE<AC.PAT.DESCRIPTION,1>
        Y.REASON.DES<-1> =  Y.REASON
        Y.CNTR += 1
    REPEAT
*
    Y.BDY.REASON = Y.REASON.DES
    CHANGE @FM TO @VM IN Y.BDY.REASON  ;*R22 AUTO CONVERSTION CONVERT TO CHANGE

RETURN
*----------------------------------------------------------------------------
FORM.ARRAY:
*-----------
* Final Array
*

    Y.RETURN.ARRAY<-1> = Y.BDY.AGENCY:"*":Y.BDY.ACCT.NO:"*":Y.BDY.ACCT.NAME:"*":Y.BDY.ACCT.OFFICER:"*":Y.BDY.STOP.DATE:"*":Y.BDY.ISSU.DATE::"*":Y.BDY.FRM.CHQ:"*":Y.BDY.TO.CHQ:"*":Y.BDY.PAYEE:"*":Y.BDY.AMT.FRM:"*":Y.BDY.AMT.TO:"*":Y.BDY.REASON:"*":Y.BDY.EXP.DATE:"*":Y.BDY.STATUS:"*":Y.BDY.INPUTTER:"*":Y.BDY.AUTHORIZER:"*":Y.CLASSIFICATION

    Y.BDY.AGENCY='';Y.BDY.ACCT.NO='';Y.BDY.ACCT.NAME='';Y.BDY.ACCT.OFFICER='';Y.BDY.STOP.DATE='';Y.BDY.ISSU.DATE:='';Y.BDY.FRM.CHQ='';Y.BDY.TO.CHQ='';Y.BDY.PAYEE='';Y.BDY.AMT.FRM='';Y.BDY.AMT.TO='';Y.BDY.REASON='';Y.BDY.EXP.DATE='';Y.BDY.STATUS='';Y.BDY.INPUTTER='';Y.BDY.AUTHORIZER='';Y.CLASSIFICATION=''
*
    Y.BDY.REASON = ''
RETURN
*----------------------------------------------------------------------------
END
