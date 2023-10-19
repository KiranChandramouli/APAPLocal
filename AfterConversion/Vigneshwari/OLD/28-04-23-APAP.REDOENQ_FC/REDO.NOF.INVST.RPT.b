* @ValidationCode : MjoyMDcxMjkxNzg3OkNwMTI1MjoxNjgyNTgxMjY4MzkzOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Apr 2023 13:11:08
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
SUBROUTINE REDO.NOF.INVST.RPT(Y.OUT.ARRAY)
*----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.NOF.INVST.RPT
*----------------------------------------------------------------------------
*Description : REDO.NOF.INVST.RPT is an No-file enquiry routine,
*This routine will select the REDO.APAP.CLEARING.INWARD and REDO.CLEARING.OUTWARD
*And check for account details and display the values
*Attached to  :Enquiry - REDO.INVST.RPT.ENQ
*In Parameter : N/A
*Out Parameter: Y.OUT.ARRAY
*----------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 08 MAR 2011     MUDASSIR              ODR-2010-03-0097        Initial Creation
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion  - F.READ to CACHE.READ , VM to @VM , FM to @FM  and SM to @SM
* 13-APRIL-2023      Harsha                R22 Manual Conversion -Call rtn modified
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.BALANCE.MOVEMENT
    $INSERT I_F.REDO.APAP.CLEARING.INWARD
    $INSERT I_F.REDO.APAP.CLEARING.OUTWARD
    $INSERT I_F.REDO.OUTWARD.RETURN
    $INSERT I_F.ACCOUNT.CLASS
*Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*Tus End
    $USING APAP.TAM
*********
MAIN.PARA:
*======

    GOSUB INIT
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
    GOSUB SORT.OUT.ARRAY
RETURN

******
INIT:
*=====

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ''

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER  = ''

    FN.BALANCE.MOVEMENT = "F.BALANCE.MOVEMENT"
    F.BALANCE.MOVEMENT = ''

    FN.REDO.APAP.CLEARING.INWARD = "F.REDO.APAP.CLEARING.INWARD"
    F.REDO.APAP.CLEARING.INWARD  = ''

    FN.REDO.OUTWARD.RETURN = "F.REDO.OUTWARD.RETURN"
    F.REDO.OUTWARD.RETURN  = ''

    FN.AZ.ACCOUNT = "F.AZ.ACCOUNT"
    F.AZ.ACCOUNT = ''

    FN.ACCOUNT$HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT$HIS  = ''

    FN.ACCT.CLASS = 'F.ACCOUNT.CLASS'
    F.ACCT.CLASS = ''

    FN.AZ.ACCOUNT$HIS = 'F.AZ.ACCOUNT$HIS'
    F.AZ.ACCOUNT$HIS  = ''

RETURN
***********
OPEN.PARA:
*==========

    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.BALANCE.MOVEMENT,F.BALANCE.MOVEMENT)
    CALL OPF(FN.REDO.APAP.CLEARING.INWARD,F.REDO.APAP.CLEARING.INWARD)
    CALL OPF(FN.REDO.OUTWARD.RETURN,F.REDO.OUTWARD.RETURN)
    CALL OPF(FN.ACCOUNT$HIS,F.ACCOUNT$HIS)
    CALL OPF(FN.ACCT.CLASS,F.ACCT.CLASS)
    CALL OPF(FN.AZ.ACCOUNT$HIS,F.AZ.ACCOUNT$HIS)

RETURN
************
PROCESS.PARA:
*=============

    GOSUB FORM.SEL.CMD
    IF NOT(SEL.LIST) THEN
    END

    GOSUB GET.DETAILS

RETURN
*************
FORM.SEL.CMD:
*=============
    LOCATE 'ACCOUNT' IN D.FIELDS<1> SETTING Y.ACCOUNT.POS THEN
        Y.ACCOUNT = D.RANGE.AND.VALUE<Y.ACCOUNT.POS>
    END

    LOCATE 'ACCOUNT.TYPE' IN D.FIELDS<1> SETTING Y.ACCT.TYPE.POS THEN
        Y.ACCOUNT.TYPE = D.RANGE.AND.VALUE<Y.ACCT.TYPE.POS>
    END

    LOCATE 'TXN.DATE' IN D.FIELDS<1> SETTING Y.TXN.DATE.POS THEN
        Y.TXN.DATES = D.RANGE.AND.VALUE<Y.TXN.DATE.POS>
        Y.TXN.OPR = D.LOGICAL.OPERANDS<Y.TXN.DATE.POS>
        GOSUB CHECK.DATE.RANGE
    END

    LOCATE 'CUSTOMER' IN D.FIELDS<1> SETTING Y.CUST.POS THEN
        Y.CUSTOMER = D.RANGE.AND.VALUE<Y.CUST.POS>
    END

    LOCATE 'COMP.CODE'IN D.FIELDS<1> SETTING Y.COMP.POS THEN
        Y.COMPANY.CODE = D.RANGE.AND.VALUE<Y.COMP.POS>
    END

    GOSUB CHECK.SELECTION

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

RETURN
****************
CHECK.DATE.RANGE:
*******************
    Y.COUNT = DCOUNT(Y.TXN.DATES,@SM)

    Y.TXN.DATE1 = FIELD(Y.TXN.DATES,@SM,1)
    Y.TXN.DATE2 = FIELD(Y.TXN.DATES,@SM,2)

    IF Y.COUNT GT 1 THEN
        IF Y.TXN.OPR EQ '1' THEN
            ENQ.ERROR ="EB-REDO.TWO.DATES WITH ":@ID
        END
    END

    IF Y.TXN.OPR EQ '2' AND Y.COUNT EQ '1' THEN
        ENQ.ERROR = "EB-REDO.ONE.DATE WITH " :@ID
    END

    IF Y.COUNT EQ '2' THEN
        IF Y.TXN.DATE1 GT Y.TXN.DATE2 THEN
            ENQ.ERROR  ="EB-REDO.DATE.ERR"
        END
    END
    IF Y.COUNT EQ '1' THEN
        SEL.CMD =" SELECT ":FN.REDO.APAP.CLEARING.INWARD:" WITH TRANS.DATE EQ ":Y.TXN.DATE1
    END ELSE
        GOSUB CHECK.DATE
    END
RETURN
***********
CHECK.DATE:
***********
    IF NOT(NUM(Y.TXN.DATE1)) OR LEN(Y.TXN.DATE1) NE '8' OR NOT(NUM(Y.TXN.DATE2)) OR LEN(Y.TXN.DATE2) NE '8' THEN
        ENQ.ERROR = 'EB-REDO.DATE.RANGE'
    END ELSE
        IF Y.TXN.DATE1[5,2] GT '12' OR Y.TXN.DATE2[5,2] GT '12' OR Y.TXN.DATE1[7,2] GT '31' OR Y.TXN.DATE2[7,2] GT '31' OR Y.TXN.DATE1 GT Y.TXN.DATE2 THEN
            ENQ.ERROR = 'EB-REDO.DATE.RANGE'
        END ELSE
            SEL.CMD =" SELECT ":FN.REDO.APAP.CLEARING.INWARD:" WITH TRANS.DATE GE ":Y.TXN.DATE1:" AND TRANS.DATE LE ":Y.TXN.DATE2
        END
    END

RETURN
****************
CHECK.SELECTION:
****************
    IF Y.ACCOUNT THEN
        SEL.CMD:=" AND ACCOUNT.NO EQ ":Y.ACCOUNT
    END

    IF Y.CUSTOMER THEN
        SEL.CMD:=" AND CUSTOMER.NO EQ ":Y.CUSTOMER
    END

    IF Y.COMPANY.CODE THEN
        SEL.CMD:=" AND CO.CODE EQ ":Y.COMPANY.CODE
    END

RETURN
*************
GET.DETAILS:
*============

    LOOP
        REMOVE INWARD.ID FROM SEL.LIST SETTING Y.INW.POS
    WHILE INWARD.ID :Y.INW.POS
        GOSUB GET.INW.DETAILS
    REPEAT
RETURN
*****************
GET.INW.DETAILS:
*============
* Get the dates from the variable Y.TXN.DATES and check if the count is 1 or 2
*If the count is 2 then get the dates in DATE.1 and DATE.2 and call the routine REDO.GET.MTH.DETAILS with parameters
    OUT.MONTH = ''
    OUT.DATE = ''
    OUT.COUNT =''
    OUT.MTH.DATE = ''
    Y.INW.AC.MTH = ''
    Y.REJ.CHQ.CNT = ''
    IF Y.COUNT EQ '2' THEN
        CALL APAP.TAM.redoGetMthDetails(Y.TXN.DATE1,Y.TXN.DATE2,OUT.MONTH,OUT.DATE,OUT.COUNT,OUT.MTH.DATE);*R22 Manual Conversion
        Y.INW.AC.MTH = OUT.MONTH
        Y.INW.AZ.MTH = OUT.MONTH
        Y.ARR.MTH = OUT.MTH.DATE
        Y.ARR.DATE = OUT.DATE
        Y.ARR.CNT = OUT.COUNT

    END
    IF Y.COUNT EQ '1' THEN
        Y.TXN.DATE2  = Y.TXN.DATE1
        CALL APAP.TAM.redoGetMthDetails(Y.TXN.DATE1,Y.TXN.DATE2,OUT.MONTH,OUT.DATE,OUT.COUNT,OUT.MTH.DATE);*R22 Manual Conversion
        Y.ARR.MTH    = OUT.MTH.DATE
        Y.INW.AC.MTH = OUT.MONTH
        Y.INW.AZ.MTH = OUT.MONTH
    END
    CHANGE @FM TO @VM IN Y.INW.AC.MTH
    CHANGE @FM TO @VM IN Y.INW.AZ.MTH
    Y.INWARD.ID = INWARD.ID

    CALL F.READ(FN.REDO.APAP.CLEARING.INWARD,Y.INWARD.ID,R.REDO.APAP.CLEARING.INWARD,F.REDO.APAP.CLEARING.INWARD,INWARD.ERR)
    GOSUB GET.LR.POSITION
    GOSUB GET.INWARD.DETAILS
    GOSUB GET.ACC.DETAILS
    IF AC.FLAG NE '1' THEN
        GOSUB GET.AZ.ACCOUNT.DETAILS
    END ELSE
        Y.INW.AZ.ACCT = '' ; Y.INW.AZ.CCY =  '' ; Y.INW.AZ.CATEG = ''; Y.INW.AZ.MTH = '' ;Y.CUS.BEN = ''
    END
    GOSUB READ.CUSTOMER
    Y.INW.CUST.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>
    IF Y.ERR.FLAG NE '1' THEN
        IF AC.FLAG EQ '1' THEN
            LOOP
                REMOVE Y.MTH.ID FROM Y.ARR.MTH SETTING Y.MTH.POS
            WHILE Y.MTH.ID : Y.MTH.POS
                Y.INW.TRANS.DT  = ''
                GOSUB CLEARING.INWARD
                GOSUB OUTWARD.RETURN
            REPEAT
            REFER.AMT      = Y.REF.AMT
            REFER.CHQ.CNT  = Y.REF.CHQ.CNT
            REJECT.AMT     = Y.REJ.AMT
            REJECT.CHQ.CNT = Y.REJ.CHQ.CNT
            RETURN.AMT     = Y.RET.AMT
            RETURN.CHQ.CNT = Y.RET.CHQ.CNT
        END ELSE
            LOOP
                REMOVE Y.MTH.ID FROM Y.ARR.MTH SETTING Y.MTH.POS
            WHILE Y.MTH.ID:Y.MTH.POS
                GOSUB CHECK.BALANCE.MOVEMENT
            REPEAT
            REFER.AMT = '' ; REFER.CHQ.CNT = '' ; REJECT.AMT = '' ; REJECT.CHQ.CNT = '' ;RETURN.AMT = '' ; RETURN.CHQ.CNT = ''
        END
    END
    IF Y.ERR.FLAG NE '1' THEN
        GOSUB OUTPUT.DATA
    END
    Y.ERR.FLAG = ''

RETURN
***************
GET.LR.POSITION:
*================

    APL.ARRAY = 'ACCOUNT':@FM:'CUSTOMER'
    APL.FIELD = 'L.AC.STATUS1':@VM:'L.AC.STATUS2':@FM:'L.CU.TIPO.CL'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APL.ARRAY,APL.FIELD,FLD.POS)
    LOC.L.AC.STATUS1.POS = FLD.POS<1,1>
    LOC.L.AC.STATUS2.POS = FLD.POS<1,2>
    LOC.L.CU.TIPO.CL.POS = FLD.POS<2,1>

RETURN
********************
GET.INWARD.DETAILS:
*====================

    Y.INW.ACCT     = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.ACCOUNT.NO>
    Y.BAL.ACCT     = Y.INW.ACCT
    Y.CO.CODE      = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.CO.CODE>
    Y.INW.CUST     = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.CUSTOMER.NO>
    Y.INW.CCY      = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.CURRENCY>
    Y.CHEQUE.NO    = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.CHEQUE.NO>

RETURN
***************
GET.ACC.DETAILS:
*================

    Y.ACCT.OPEN.DATE = ''
    REC.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,Y.INW.ACCT,REC.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    R.ECB='' ;ECB.ERR='' ;*Tus Start
    CALL EB.READ.HVT("EB.CONTRACT.BALANCES",Y.INW.ACCT,R.ECB,ECB.ERR);*Tus End
    IF REC.ACCOUNT EQ '' THEN
        EB.HIS.FLAG=1
        CALL F.READ(FN.ACCOUNT$HIS,Y.INW.ACCT,REC.ACCOUNT,F.ACCOUNT$HIS,ACCT1.ERR)
    END
    Y.CATEG        = REC.ACCOUNT<AC.CATEGORY>
*-------CHECK FOR SAVINGS ACCOUNT --------

    Y.ACCT.CLASS = 'SAVINGS'
    CALL CACHE.READ(FN.ACCT.CLASS, Y.ACCT.CLASS, R.ACCT.CLASS, CLASS.ERR)	;*R22 Auto Conversion  - F.READ to CACHE.READ
    Y.SAVINGS.CATEGORY = R.ACCT.CLASS<AC.CLS.CATEGORY>

    LOCATE Y.CATEG IN Y.SAVINGS.CATEGORY<1,1> SETTING CATEGORY.POS THEN
        Y.CATEGORY = Y.CATEG
    END ELSE
        Y.CATEGORY = ''
    END
    IF Y.CATEGORY NE '' THEN
        AC.FLAG = '1'
    END ELSE
        AC.FLAG = '2'
    END
    Y.INW.ACCT.EXE = REC.ACCOUNT<AC.ACCOUNT.OFFICER>
    IF Y.ACCOUNT.TYPE THEN
        IF Y.CATEG EQ Y.ACCOUNT.TYPE ELSE
            Y.ERR.FLAG = 1
        END
    END
    IF EB.HIS.FLAG EQ '1' THEN
        Y.ONLINE.ACTUAL.BALANCE =  REC.ACCOUNT<AC.ONLINE.ACTUAL.BAL>;*Tus Start
    END ELSE
        Y.ONLINE.ACTUAL.BALANCE =  R.ECB<ECB.ONLINE.ACTUAL.BAL>;*Tus End
    END
    Y.ACCT.STAT1 = REC.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.STATUS1.POS>
    Y.ACCT.STAT2 = REC.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.STATUS2.POS>
    Y.ACCT.OPEN.DATE = REC.ACCOUNT<AC.OPENING.DATE>
    Y.ACCT.NAME = Y.INW.ACCT

RETURN
GET.AZ.ACCOUNT.DETAILS:
*========================
    CALL F.READ(FN.AZ.ACCOUNT,Y.INW.ACCT,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
    IF R.AZ.ACCOUNT EQ ''  THEN
        CALL F.READ(FN.AZ.ACCOUNT$HIS,Y.INW.ACCT,R.AZ.ACCOUNT,F.AZ.ACCOUNT$HIS,HIS.ERR)
    END
    IF R.AZ.ACCOUNT NE '' THEN
        Y.INW.AZ.ACCT = Y.INW.ACCT
        Y.INW.AZ.CCY = R.AZ.ACCOUNT<AZ.CURRENCY>
        Y.INW.AZ.CATEG = R.AZ.ACCOUNT<AZ.CATEGORY>
        Y.CUS.BEN = Y.INW.ACCT
        Y.ACCT.STAT1 = '' ; Y.ACCT.STAT2 = ''; Y.CATEGORY = '' ; Y.INW.ACCT.EXE = ''
        Y.ACCT.OPEN.DATE = '' ;  Y.ACCT.NAME = '';
        Y.INW.AC.MTH  = '' ; Y.INW.CCY = '' ; Y.MTH.AC.AVG.BAL = '' ; Y.MTH.AVAIL.BAL  = '' ; Y.INW.ACCT = ''
    END ELSE
        Y.INW.AZ.ACCT = '' ;Y.INW.AZ.CCY = '' ;Y.INW.AZ.CATEG = '' ;Y.ACCT.STAT1 = '' ; Y.ACCT.STAT2 = ''
        Y.CATEGORY = '' ;Y.INW.ACCT.EXE = '' ;Y.ACCT.OPEN.DATE = '' ;  Y.ACCT.NAME = ''; Y.CO.CODE = '';
    END

RETURN
*************
READ.CUSTOMER:
*=============
    R.CUSTOMER = ''
    CUSTOMER.ERR = ''
    CALL F.READ(FN.CUSTOMER,Y.INW.CUST,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)

RETURN
****************
CLEARING.INWARD:
*================
    Y.CHECK = ''
    Y.AVAIL.BAL = ''
    Y.AVG.BAL = ''
    Y.INW.TRANS = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.TRANS.DATE>
    Y.INW.AMT = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.AMOUNT>
    Y.INW.TRANS.DT = Y.INW.TRANS[1,6]
    VAR.REJ.TYPE = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.REJECT.TYPE>
    VAR.REASON   = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.REASON>
    Y.STATUS     = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.STATUS>
    GOSUB REFER.TYPE
    GOSUB STATUS.REJECTED
    GOSUB CHECK.BALANCE.MOVEMENT

RETURN
***********************
CHECK.BALANCE.MOVEMENT:
***********************
    Y.BAL.ID = Y.BAL.ACCT:"*":Y.MTH.ID
    CALL F.READ(FN.BALANCE.MOVEMENT,Y.BAL.ID,R.BALANCE.MOVEMENT,F.BALANCE.MOVEMENT,BAL.ERR)
    IF R.BALANCE.MOVEMENT THEN
        Y.CHECK = R.BALANCE.MOVEMENT<BL.MV.AVG.BALANCE>
        COMI = Y.MTH.ID:"01"
        CALL LAST.DAY.OF.THIS.MONTH
        Y.DAYS = COMI
        NO.OF.DAYS = Y.DAYS[7,8]
        Y.ONLINE.BAL.DAYS =  Y.ONLINE.ACTUAL.BALANCE/NO.OF.DAYS
        GOSUB GET.VALUES.BALANCE
    END ELSE
        LOCATE Y.MTH.ID IN Y.BAL.MTH<1,1> SETTING MTH.BAL.POS THEN
            Y.BAL.AMT<1,MTH.BAL.POS> = ''
            Y.BAL.ONLINE.AMT<1,MTH.BAL.POS> = ''
            Y.BAL.MTH<1,MTH.BAL.POS> = Y.MTH.ID
        END ELSE
            Y.BAL.MTH<1,-1> = Y.MTH.ID
            Y.BAL.AMT<1,-1> = ' '
            Y.BAL.ONLINE.AMT<1,-1> = ' '
        END
    END
    Y.MTH.AC.AVG.BAL = Y.BAL.AMT
    Y.MTH.AVAIL.BAL  = Y.BAL.ONLINE.AMT
    Y.MTH.AZ.AVG.BAL = Y.BAL.AMT
    IF AC.FLAG NE '1' THEN
        Y.MTH.AZ.AVG.BAL = Y.BAL.AMT
        Y.MTH.AC.AVG.BAL = ''
        Y.MTH.AVAIL.BAL = ''
    END ELSE
        Y.MTH.AC.AVG.BAL = Y.BAL.AMT
        Y.MTH.AVAIL.BAL  = Y.BAL.ONLINE.AMT
        Y.MTH.AZ.AVG.BAL = ''
    END

RETURN
*******************
GET.VALUES.BALANCE:
*******************
    LOCATE Y.MTH.ID IN Y.BAL.MTH<1,1> SETTING MTH.BAL.POS THEN
        Y.BAL.AMT<1,MTH.BAL.POS>        += Y.CHECK
        Y.BAL.ONLINE.AMT<1,MTH.BAL.POS> += Y.ONLINE.BAL.DAYS
    END ELSE
        Y.BAL.MTH<1,-1>        = Y.MTH.ID
        Y.BAL.AMT<1,-1>        = Y.CHECK
        Y.BAL.ONLINE.AMT<1,-1> = Y.ONLINE.BAL.DAYS
    END
RETURN
***************
OUTWARD.RETURN:
*===============
    SEL.OUT.CMD =" SELECT ":FN.REDO.OUTWARD.RETURN:" WITH @ID LIKE ...":Y.INW.ACCT:"..."
    CALL EB.READLIST(SEL.OUT.CMD,SEL.LIST2,'',NO.OF.REC2,REC2.ERR)
    LOOP
        REMOVE Y.OUTWARD.ID FROM SEL.LIST2 SETTING OUTWARD.POS
    WHILE Y.OUTWARD.ID:OUTWARD.POS
        CALL F.READ(FN.REDO.OUTWARD.RETURN,Y.OUTWARD.ID,R.REDO.OUTWARD.RETURN,F.REDO.OUTWARD.RETURN,OUTWARD.ERR)
        Y.RET.TRANS = R.REDO.OUTWARD.RETURN<CLEAR.RETURN.DATE>
        Y.OWD.AMT = R.REDO.OUTWARD.RETURN<CLEAR.RETURN.AMOUNT>
        Y.RET.TRANS.DT  = Y.RET.TRANS[1,6]
        IF Y.MTH.ID EQ Y.RET.TRANS.DT THEN
            LOCATE Y.MTH.ID IN Y.RETURN.MTH<1,1> SETTING MTH.RET.POS THEN
                Y.RET.CHQ.CNT<1,MTH.RET.POS> += 1
                Y.RET.AMT<1,MTH.RET.POS>     += Y.OWD.AMT
            END ELSE
                Y.RETURN.MTH<1,-1> = Y.MTH.ID
                Y.RET.CHQ    += 1
                Y.RET.CHQ.CNT<1,-1> = Y.RET.CHQ
                Y.RET.AMT<1,-1>    = Y.OWD.AMT
            END
        END ELSE
            LOCATE Y.MTH.ID IN Y.RETURN.MTH<1,1> SETTING MTH.RET.POS THEN
                Y.RETURN.MTH<1,MTH.RET.POS> = Y.MTH.ID
                Y.RET.CHQ.CNT    = ''
                Y.RET.AMT<1,MTH.RET.POS> = ''
            END ELSE
                Y.RETURN.MTH<1,-1>       = Y.MTH.ID
                Y.RET.CHQ.CNT<1,-1>      = ' '
                Y.RET.AMT<1,-1>          = ' '
            END
        END

    REPEAT
RETURN
************
OUTPUT.DATA:
*=============
    CHANGE '%' TO '' IN Y.MTH.AC.AVG.BAL
    CHANGE '%' TO '' IN Y.MTH.AVAIL.BAL
    CHANGE '%' TO '' IN Y.MTH.AZ.AVG.BAL
    Y.RPT.NAME = " REPORTE DE SALDOS PROMEDIOS CUENTAS E INVERSIONES"
    IF Y.CO.CODE NE '' THEN
        Y.OUT.ARRAY<-1> = Y.INW.CUST :"*": Y.INW.CUST.TYPE :"*": Y.INW.ACCT.EXE :"*"
        Y.OUT.ARRAY : = Y.CO.CODE :"*": Y.CATEGORY :"*": Y.INW.ACCT :"*":Y.ACCT.NAME:"*"
        Y.OUT.ARRAY : = Y.ACCT.OPEN.DATE :"*": Y.INW.CCY :"*": Y.INW.AC.MTH :"*": Y.MTH.AC.AVG.BAL :"*"
        Y.OUT.ARRAY : = Y.MTH.AVAIL.BAL :"*": REFER.CHQ.CNT :"*": REFER.AMT :"*": REJECT.CHQ.CNT :"*"
        Y.OUT.ARRAY : = REJECT.AMT :"*": RETURN.CHQ.CNT :"*": RETURN.AMT :"*": Y.ACCT.STAT1 :"*" :Y.ACCT.STAT2:"*"
        Y.OUT.ARRAY : = Y.INW.AZ.CATEG :"*": Y.INW.AZ.ACCT :"*": Y.CUS.BEN :"*"
        Y.OUT.ARRAY : = Y.INW.AZ.CCY :"*": Y.INW.AZ.MTH :"*": Y.MTH.AZ.AVG.BAL:"*":Y.RPT.NAME
    END
    GOSUB VALUE.NUL
RETURN
**************
REFER.TYPE:
*===============
    IF Y.MTH.ID EQ Y.INW.TRANS.DT THEN
        IF VAR.REJ.TYPE NE '' THEN
            LOCATE 17 IN VAR.REASON<1,1> SETTING VAR.REAS.POS THEN
                GOSUB GET.VALUES.REFER
            END ELSE
                GOSUB REFER.NULL
            END
        END ELSE
            GOSUB REFER.NULL
        END
    END ELSE
        GOSUB REFER.NULL
    END

RETURN
******************
GET.VALUES.REFER:
******************
    LOCATE Y.MTH.ID IN Y.REFER.MTH<1,1> SETTING MTH.REFER.POS THEN
        Y.REF.CHQ.CNT<1,MTH.REFER.POS> += 1
        Y.REF.AMT<1,MTH.REFER.POS>     += Y.INW.AMT
    END ELSE
        Y.REFER.MTH <1,-1>  = Y.MTH.ID
        Y.REF.CHQ           += 1
        Y.REF.CHQ.CNT<1,-1> = Y.REF.CHQ
        Y.REF.AMT<1,-1>     += Y.INW.AMT
    END

RETURN
************
REFER.NULL:
************
    LOCATE Y.MTH.ID IN Y.REFER.MTH SETTING MTH.REFER.POS THEN
        Y.REFER.MTH<1,MTH.REFER.POS> = Y.MTH.ID
        Y.REF.CHQ.CNT                = ''
        Y.REF.AMT<1,MTH.REFER.POS>   = ''
    END ELSE
        Y.REFER.MTH<1,-1>   = Y.MTH.ID
        Y.REF.CHQ.CNT<1,-1> = ' '
        Y.REF.AMT<1,-1>     = ' '
    END
RETURN
****************
STATUS.REJECTED:
****************
    IF Y.MTH.ID EQ Y.INW.TRANS.DT THEN
        IF Y.STATUS EQ 'REJECTED' THEN
            LOCATE 17 IN VAR.REASON<1,1> SETTING VAR.REAS.POS THEN
                GOSUB GET.VALUES.REJECTED
            END ELSE
                GOSUB REJECT.NULL
            END
        END ELSE
            GOSUB REJECT.NULL
        END
    END ELSE
        GOSUB REJECT.NULL
    END

RETURN
*******************
GET.VALUES.REJECTED:
********************
    LOCATE Y.MTH.ID IN Y.REJECT.MTH SETTING MTH.REJ.POS THEN
        Y.REJ.CHQ.CNT<1,MTH.REJ.POS> += 1
        Y.REJ.AMT<1,MTH.REJ.POS>     += Y.INW.AMT
    END ELSE
        Y.REJECT.MTH<1,-1>  = Y.MTH.ID
        Y.REJ.CHQ           += 1
        Y.REJ.CHQ.CNT<1,-1> = Y.REJ.CHQ
        Y.REJ.AMT<1,-1>     += Y.INW.AMT
    END
RETURN

************
REJECT.NULL:
************
    LOCATE Y.MTH.ID IN Y.REJECT.MTH SETTING MTH.RET.POS THEN
        Y.REJECT.MTH<1,MTH.RET.POS>  = Y.MTH.ID
        Y.REJ.CHQ.CNT                = ''
        Y.REJ.AMT<1,MTH.RET.POS>     = ''
    END ELSE
        Y.REJECT.MTH<1,-1>       = Y.MTH.ID
        Y.REJ.CHQ.CNT<1,-1>      = ' '
        Y.REJ.AMT<1,-1>          = ' '
    END

RETURN
***********
VALUE.NUL:
*=========

    Y.INW.AZ.MTH = ''        ; Y.REF.AMT = ''
    REFER.AMT = ''           ; Y.MTH.RET = ''
    Y.INW.ACCT = ''          ; Y.REJ.AMT = ''
    Y.INW.CATEG = ''         ; REJECT.AMT = ''
    Y.INW.ACCT.EXE = ''      ; RETURN.AMT = ''
    Y.CO.CODE = ''           ; Y.RET.AMT = ''
    Y.INW.CUST = ''          ; RETURN.CHQ.CNT = ''
    Y.INW.CCY = ''           ; Y.INW.AC.MTH = ''
    Y.ACCT.STAT1 =''         ; Y.MTH.AC.AVG.BAL = ''
    Y.ACCT.STAT2 = ''        ; Y.MTH.AVAIL.BAL = ''
    Y.INW.CUST.TYPE = ''     ; REFER.CHQ.CNT = ''
    Y.ARR.MTH = ''           ; REJECT.CHQ.CNT = ''
    Y.INW.AZ.CATEG = ''      ; Y.INW.AZ.ACCT = ''
    Y.INW.BEN.NAME = ''      ; Y.INW.AZ.CCY = ''
    Y.MTH.AZ.AVG.BAL = ''    ; Y.STAT = ' '
    LOC.L.AC.STATUS1.POS = ''; LOC.L.AC.STATUS2.POS = ''
    Y.MTH.ID = ''            ; Y.REJECT.MTH = ''
    Y.REFER.MTH = ''         ; Y.REJ.CHQ = ''
    Y.REJ.CHQ.CNT = ''       ; Y.REF.CHQ.CNT = ''
    Y.REF.CHQ = ''           ; Y.RETURN.MTH = ''
    Y.RET.CHQ.CNT = ''       ; Y.RET.CHQ = ''
    Y.BAL.MTH = ''           ; Y.BAL.AMT = ''
    Y.BAL.ONLINE.AMT = ''    ; Y.ONLINE.BAL.DAYS = ''
    Y.ONLINE.ACTUAL.BALANCE = '' ; NO.OF.DAYS = ''
    Y.DAYS = ''

RETURN

***************
SORT.OUT.ARRAY:
***************

    Y.REC.COUNT = DCOUNT(Y.OUT.ARRAY,@FM)
    Y.REC.START = 1
    LOOP
    WHILE Y.REC.START LE Y.REC.COUNT
        Y.REC =  Y.OUT.ARRAY<Y.REC.START>
        Y.CUST = FIELD(Y.REC,'*',1)
        Y.SORT.VAL = Y.CUST

        Y.AZ.SORT.VAL<-1> = Y.REC:@FM:Y.SORT.VAL

        Y.SORT.ARR<-1>= Y.SORT.VAL
        Y.REC.START += 1
    REPEAT

    Y.SORT.ARR = SORT(Y.SORT.ARR)

    LOOP
        REMOVE Y.ARR.ID FROM Y.SORT.ARR SETTING Y.ARR.POS
    WHILE Y.ARR.ID : Y.ARR.POS
        LOCATE Y.ARR.ID IN Y.AZ.SORT.VAL SETTING Y.FM.POS THEN
            Y.ARRAY<-1> = Y.AZ.SORT.VAL<Y.FM.POS-1>
            DEL Y.AZ.SORT.VAL<Y.FM.POS>
            DEL Y.AZ.SORT.VAL<Y.FM.POS-1>
        END
    REPEAT
    Y.OUT.ARRAY = Y.ARRAY

RETURN

END
*------------End of Program-------------------------------------------------------
