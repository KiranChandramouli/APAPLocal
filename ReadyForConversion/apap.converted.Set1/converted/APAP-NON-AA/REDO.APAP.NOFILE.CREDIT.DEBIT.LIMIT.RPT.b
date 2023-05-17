SUBROUTINE REDO.APAP.NOFILE.CREDIT.DEBIT.LIMIT.RPT(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.APAP.NOFILE.CREDIT.DEBIT.LIMIT.RPT
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOFILE.CREDIT.DEBIT.LIMIT.RPT is a no-file enquiry routine for the enquiry REDO.APAP.NOF.CR.DB.LIMIT.RPT,
*                    the routine based on the selection criteria selects the records from respective files and displays
*                    the processed records
*
*In Parameter      : N/A
*Out Parameter     : Y.OUT.ARRAY
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference                      Description
*   ------         ------               -------------                    -------------
*  03/09/2010      MD.PREETHI          ODR-2010-03-0106 131               Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.LATAM.CARD.CUSTOMER
    $INSERT I_F.REDO.INCR.DECR.ATM.POS.AMT
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.REDO.CARD.REQUEST

    GOSUB INIT
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN

INIT:
*****
    FN.LATAM.CARD.CUSTOMER='F.LATAM.CARD.CUSTOMER'
    F.LATAM.CARD.CUSTOMER=''
    FN.REDO.INCR.DECR.ATM.POS.AMT='F.REDO.INCR.DECR.ATM.POS.AMT'
    F.REDO.INCR.DECR.ATM.POS.AMT=''
    FN.CARD.TYPE='F.CARD.TYPE'
    F.CARD.TYPE=''
    FN.LATAM.CARD.ORDER='F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER=''
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    FN.REDO.CARD.REQUEST='F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST=''

    Y.ACTIVE.DATE.FROM =''
    Y.ACTIVE.DATE.TO=''
    Y.DATE.CARD=''
    SEL.LIST.ACT=''
    Y.DATE.PROCESSED.CARDS=''
    SEL.LIST.AMT=''
    SEL.LIST.CARD.NO=''
    SEL.LIST.CLIENT.NO=''
    Y.ACC.NOS=''
    Y.CLIENT.NAME=''
    Y.BASE.CARD=''
    Y.CARD.TYPE=''
    SEL.LIST.DATE=''
    Y.CLIENT.NO.PROCESSED.CARDS=''
    Y.CARD.DATE=''
    Y.PROCESSED.IDS=''
    Y.ACT.PROCESSED.CARDS=''
    Y.AGENCY=''
    Y.DATE.TIME=''
    Y.ERROR=''
    Y.CARD.CURRENCY=''
    Y.PROD.TYPE = "DEBIT CARD"
RETURN

OPEN.PARA:
**********
    CALL OPF(FN.LATAM.CARD.CUSTOMER,F.LATAM.CARD.CUSTOMER)
    CALL OPF(FN.LATAM.CARD.CUSTOMER,F.LATAM.CARD.CUSTOMER)
    CALL OPF(FN.REDO.INCR.DECR.ATM.POS.AMT,F.REDO.INCR.DECR.ATM.POS.AMT)
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)
RETURN

PROCESS.PARA:
*************

    GOSUB CHECK.SELECTION
    IF ENQ.ERROR THEN
        RETURN
    END

    GOSUB GET.PROCESSED.CARDS
    IF NOT(Y.PROCESSED.CARDS) THEN
        RETURN
    END

    IF Y.ERROR THEN
        RETURN
    END
    GOSUB GET.DETAILS
RETURN

CHECK.SELECTION:
****************
    GOSUB GET.BASE.SELECTION

    GOSUB GET.ACTIVE.DATE.SELECTION

    IF ENQ.ERROR THEN
        RETURN
    END

    GOSUB GET.CARD.DATE.SELECTION

    IF ENQ.ERROR THEN
        RETURN
    END

    GOSUB GET.CARD.AMT.SELECTION

    IF ENQ.ERROR OR Y.ERROR.FLAG THEN
        RETURN
    END

    GOSUB GET.CARD.NO.SELECTION

    IF ENQ.ERROR THEN
        RETURN
    END

    GOSUB GET.CLIENT.SELECTION

RETURN

GET.BASE.SELECTION:
*******************

    SEL.CMD.BASE = 'SELECT ':FN.LATAM.CARD.ORDER
    CALL EB.READLIST(SEL.CMD.BASE,SEL.LIST.BASE,'',NO.OF.REC.BASE,SEL.ERR.BASE)

RETURN

GET.ACTIVE.DATE.SELECTION:
***************************

    LOCATE 'ACTIVE.DATE.FROM' IN D.FIELDS<1> SETTING Y.ACT.FROM.POS THEN
        Y.ACTIVE.DATE.FROM= D.RANGE.AND.VALUE<Y.ACT.FROM.POS>
    END

    LOCATE 'ACTIVE.DATE.TO' IN D.FIELDS<1> SETTING Y.ACT.TO.POS THEN
        Y.ACTIVE.DATE.TO = D.RANGE.AND.VALUE<Y.ACT.TO.POS>
    END

    IF Y.ACTIVE.DATE.FROM AND NOT(Y.ACTIVE.DATE.TO) THEN
        ENQ.ERROR = 'EB-TO.DATE.MAND'
        RETURN
    END
    IF NOT(Y.ACTIVE.DATE.FROM) AND Y.ACTIVE.DATE.TO THEN
        ENQ.ERROR ='EB-FROM.DATE.MAND'
        RETURN
    END
    IF NOT(Y.ACTIVE.DATE.FROM) AND NOT(Y.ACTIVE.DATE.TO) THEN
        RETURN
    END

    SEL.CMD.ACT = 'SELECT ':FN.LATAM.CARD.ORDER:' WITH ACTIVE.DATE GE ':Y.ACTIVE.DATE.FROM:' AND ACTIVE.DATE LE ':Y.ACTIVE.DATE.TO
    CALL EB.READLIST(SEL.CMD.ACT,SEL.LIST.ACT,'',NO.OF.REC.ACT,SEL.ERR.ACT)

RETURN

GET.CARD.DATE.SELECTION:
************************

    LOCATE 'INC.DEC.DATE' IN D.FIELDS<1> SETTING Y.DATE.POS THEN
        Y.CARD.DATE = D.RANGE.AND.VALUE<Y.DATE.POS>
    END ELSE
        RETURN
    END
    IF NOT(Y.CARD.DATE) THEN
        RETURN
    END
    COMI = Y.CARD.DATE
    CALL IN2D('8','D')
    IF  ETEXT  THEN
        ENQ.ERROR ='EB-INVALID.DATE.FMT'
        RETURN
    END
    SEL.CMD.DATE = 'SELECT ':FN.REDO.INCR.DECR.ATM.POS.AMT:' WITH @ID LIKE ':Y.CARD.DATE:'...'
    CALL EB.READLIST(SEL.CMD.DATE,SEL.LIST.DATE,'',NO.OF.REC.DATE,SEL.ERR.DATE)
    IF NOT(SEL.LIST.DATE) THEN
        RETURN
    END
    LOOP
        REMOVE Y.CARD.ORDER.ID FROM SEL.LIST.DATE SETTING Y.CARD.POS
    WHILE Y.CARD.ORDER.ID:Y.CARD.POS
        Y.DATE.CD = FIELD(Y.CARD.ORDER.ID,'-',2)
        LOCATE Y.DATE.CD IN Y.DATE.CARD SETTING Y.DATE.POS THEN
        END ELSE
            Y.DATE.CARD<-1> = FIELD(Y.CARD.ORDER.ID,'-',2)
        END
    REPEAT

    LOOP
        REMOVE CARD.ID FROM Y.DATE.CARD SETTING Y.CD.POS
    WHILE CARD.ID:Y.CD.POS
        SEL.CMD.CD = 'SELECT ':FN.LATAM.CARD.ORDER:' WITH @ID LIKE ':CARD.ID:'...'
        CALL EB.READLIST(SEL.CMD.CD,SEL.LIST.CD,'',NO.OF.REC.CD,SEL.ERR.CD)
        IF SEL.LIST.CD THEN
            SEL.LIST.DATE<-1> = SEL.LIST.CD
        END
    REPEAT
RETURN

GET.CARD.AMT.SELECTION:
************************
    LOCATE 'CARD.CURRENCY' IN D.FIELDS<1> SETTING Y.CURR.POS THEN
        Y.CARD.CURRENCY = D.RANGE.AND.VALUE<Y.CURR.POS>
    END

    LOCATE 'INC.DEC.AMT' IN  D.FIELDS<1> SETTING Y.AMT.POS THEN
        Y.CARD.AMT = D.RANGE.AND.VALUE<Y.AMT.POS>
    END

    IF NOT(Y.CARD.AMT) AND NOT(Y.CARD.CURRENCY) THEN
        RETURN
    END

    IF Y.CARD.AMT AND NOT(Y.CARD.CURRENCY) OR NOT(Y.CARD.AMT) AND Y.CARD.CURRENCY THEN
        ENQ.ERROR = 'EB-CARD.CURRENCY'
        RETURN
    END

    SEL.CMD.ATM ='SELECT ':FN.REDO.INCR.DECR.ATM.POS.AMT:' WITH LIM.CCY EQ ':Y.CARD.CURRENCY:' AND WITH MX.ATM.TRAN.LIM GE ':Y.CARD.AMT:' OR MX.POS.TRAN.LIM GE ':Y.CARD.AMT
    CALL EB.READLIST(SEL.CMD.ATM,SEL.LIST.ATM,'',NO.OF.REC.ATM,SEL.ERR.ATM)

    IF NOT(SEL.LIST.ATM) THEN
        Y.ERROR.FLAG = 1
        RETURN
    END

    SEL.LIST.AMT.CD = SEL.LIST.ATM

    GOSUB GET.AMOUNT.SEL

RETURN

GET.AMOUNT.SEL:
***************
    LOOP
        REMOVE Y.CARD.AMT.ID FROM SEL.LIST.AMT.CD SETTING Y.CARD.AMT.POS
    WHILE Y.CARD.AMT.ID:Y.CARD.AMT.POS
        Y.AMT.CD = FIELD(Y.CARD.AMT.ID,'-',2)
        LOCATE Y.AMT.CD IN Y.AMT.CARD SETTING Y.AMT.POS THEN
        END ELSE
            Y.AMT.CARD<-1> = Y.AMT.CD
        END
    REPEAT

    SEL.LIST.AMT = ''
    LOOP
        REMOVE CARD.AMT.ID FROM Y.AMT.CARD SETTING Y.CD.AMT.POS
    WHILE CARD.AMT.ID:Y.CD.AMT.POS
        SEL.CMD.AMT.CD = 'SELECT ':FN.LATAM.CARD.ORDER:' WITH @ID LIKE ':CARD.AMT.ID:'...'
        CALL EB.READLIST(SEL.CMD.AMT.CD,SEL.LIST.AMT.CD,'',NO.OF.REC.AMT.CD,SEL.ERR.AMT.CD)
        IF SEL.LIST.AMT.CD THEN
            SEL.LIST.AMT<-1> = SEL.LIST.AMT.CD
        END
    REPEAT

RETURN

GET.CARD.NO.SELECTION:
**********************
    LOCATE 'CARD.NO' IN D.FIELDS<1> SETTING Y.CARD.NO.POS THEN
        Y.CARD.NO = D.RANGE.AND.VALUE<Y.CARD.NO.POS>
    END ELSE
        RETURN
    END

    IF NOT(Y.CARD.NO) THEN
        RETURN
    END

    SEL.CMD.CARD.NO = 'SELECT ':FN.LATAM.CARD.ORDER :" WITH @ID EQ ":Y.CARD.NO
    CALL EB.READLIST(SEL.CMD.CARD.NO,SEL.LIST.CARD.NO,'',NO.OF.REC.CARD.NO,SEL.ERR.CARD.NO)

    IF NOT(SEL.LIST.CARD.NO) THEN
        ENQ.ERROR = 'EB-INVALID.CARD.NO'
        RETURN
    END

RETURN

GET.CLIENT.SELECTION:
*********************
    LOCATE 'CLIENT' IN D.FIELDS<1> SETTING Y.CLIENT.POS THEN
        Y.CLIENT.NO =D.RANGE.AND.VALUE<Y.CLIENT.POS>
    END ELSE
        RETURN
    END
    IF NOT(Y.CLIENT.NO) THEN
        RETURN
    END
    SEL.CMD.CLIENT.NO ='SELECT ':FN.LATAM.CARD.CUSTOMER:" WITH @ID EQ ":Y.CLIENT.NO
    CALL EB.READLIST(SEL.CMD.CLIENT.NO,SEL.LIST.CLIENT.NO,'',NO.OF.REC.CLIENT.NO,SEL.ERR.CLIENT.NO)

    IF NOT(SEL.LIST.CLIENT.NO) THEN
        ENQ.ERROR ='EB-INVALID.CLIENT.NO'
        RETURN
    END

    LATAM.CARD.CUSTOMER.ID = SEL.LIST.CLIENT.NO
    CALL F.READ(FN.LATAM.CARD.CUSTOMER,LATAM.CARD.CUSTOMER.ID,R.LATAM.CARD.CUSTOMER,F.LATAM.CARD.CUSTOMER,Y.LATAM.CARD.ERR)
    Y.CARD.NOS = R.LATAM.CARD.CUSTOMER<APAP.DC.CARD.NO>
    CHANGE @VM TO @FM IN Y.CARD.NOS
    SEL.LIST.CLIENT.NO = Y.CARD.NOS

RETURN

********************
GET.PROCESSED.CARDS:
********************
    Y.PROCESSED.CARDS = SEL.LIST.BASE
    IF Y.ACTIVE.DATE.FROM AND NOT(SEL.LIST.ACT) THEN
        Y.ERROR = 1
        RETURN
    END
    IF SEL.LIST.ACT THEN
        GOSUB GET.ACT.PROCESSED.CARDS
    END
    IF NOT(Y.PROCESSED.CARDS) THEN
        RETURN
    END
    IF Y.CARD.DATE AND NOT(SEL.LIST.DATE) THEN
        Y.ERROR = 1
        RETURN
    END
    IF SEL.LIST.DATE THEN
        GOSUB GET.DATE.PROCESSED.CARDS
    END
    IF NOT(Y.PROCESSED.CARDS) THEN
        RETURN
    END
    IF Y.CARD.AMT AND NOT(SEL.LIST.AMT) THEN
        Y.ERROR = 1
        RETURN
    END
    IF SEL.LIST.AMT THEN
        GOSUB GET.AMT.PROCESSED.CARDS
    END
    IF NOT(Y.PROCESSED.CARDS) THEN
        RETURN
    END
    IF Y.CARD.NO AND NOT(SEL.LIST.CARD.NO) THEN
        Y.ERROR = 1
        RETURN
    END
    IF SEL.LIST.CARD.NO THEN
        GOSUB GET.CARD.NO.PROCESSED.CARDS
    END
    IF NOT(Y.PROCESSED.CARDS) THEN
        RETURN
    END
    IF Y.CLIENT.NO AND NOT(SEL.LIST.CLIENT.NO) THEN
        Y.ERROR = 1
        RETURN
    END
    IF SEL.LIST.CLIENT.NO THEN
        GOSUB GET.CLIENT.NO.PROCESSED.CARDS
    END

RETURN

GET.ACT.PROCESSED.CARDS:
*************************
    LOOP
        REMOVE Y.ACT.ID FROM SEL.LIST.ACT SETTING Y.ACT.POS
    WHILE Y.ACT.ID:Y.ACT.POS
        LOCATE Y.ACT.ID IN Y.PROCESSED.CARDS SETTING Y.ACT.PRO.POS THEN
            Y.ACT.PROCESSED.CARDS<-1> = Y.ACT.ID
        END
    REPEAT
    Y.PROCESSED.CARDS =Y.ACT.PROCESSED.CARDS
RETURN


GET.DATE.PROCESSED.CARDS:
**************************
    LOOP
        REMOVE Y.DATE.ID FROM SEL.LIST.DATE SETTING Y.DATE.POS
    WHILE Y.DATE.ID:Y.DATE.POS
        LOCATE Y.DATE.ID IN Y.PROCESSED.CARDS SETTING Y.DATE.PRO.POS THEN
            Y.DATE.PROCESSED.CARDS<-1> = Y.DATE.ID
        END
    REPEAT
    Y.PROCESSED.CARDS = Y.DATE.PROCESSED.CARDS
RETURN

GET.AMT.PROCESSED.CARDS:
*************************
    LOOP
        REMOVE Y.AMT.ID FROM SEL.LIST.AMT SETTING Y.AMT.POS
    WHILE Y.AMT.ID:Y.AMT.POS
        LOCATE Y.AMT.ID IN Y.PROCESSED.CARDS SETTING Y.AMT.PRO.POS THEN
            Y.AMT.PROCESSED.CARDS<-1> = Y.AMT.ID
        END
    REPEAT
    Y.PROCESSED.CARDS = Y.AMT.PROCESSED.CARDS
RETURN

GET.CARD.NO.PROCESSED.CARDS:
***************************
    LOOP
        REMOVE Y.CARD.NO.ID FROM SEL.LIST.CARD.NO SETTING Y.CARD.NO.POS
    WHILE Y.CARD.NO.ID:Y.CARD.NO.POS
        LOCATE Y.CARD.NO.ID IN Y.PROCESSED.CARDS SETTING Y.CARD.NO.PRO.POS THEN
            Y.CARD.NO.PROCESSED.CARDS<-1> = Y.CARD.NO.ID
        END
    REPEAT
    Y.PROCESSED.CARDS = Y.CARD.NO.PROCESSED.CARDS
RETURN

GET.CLIENT.NO.PROCESSED.CARDS:
******************************
    LOOP
        REMOVE Y.CLIENT.NO.ID FROM SEL.LIST.CLIENT.NO SETTING Y.CLIENT.NO.POS
    WHILE Y.CLIENT.NO.ID:Y.CLIENT.NO.POS
        LOCATE Y.CLIENT.NO.ID IN Y.PROCESSED.CARDS SETTING Y.CLIENT.NO.PRO.POS THEN
            Y.CLIENT.NO.PROCESSED.CARDS<-1> =Y.CLIENT.NO.ID
        END
    REPEAT
    Y.PROCESSED.CARDS = Y.CLIENT.NO.PROCESSED.CARDS
RETURN

GET.DETAILS:
***********
    LOOP
        REMOVE LATAM.CARD.ORDER.ID FROM Y.PROCESSED.CARDS SETTING Y.ORDER.POS
    WHILE LATAM.CARD.ORDER.ID : Y.ORDER.POS
        GOSUB GET.DATE.TIME.PRD.TYPE
        IF NOT(Y.DATE.TIME) THEN
            CONTINUE
        END
        GOSUB GET.ACCOUNT.CARD.CLIENT.NUMBERS
        GOSUB GET.AGENCYS
        Y.OUT.ARRAY<-1> = Y.DATE.TIME:'*': CARD.TYPE.ID:'*':Y.PROD.TYPE:'*':Y.ACC.NOS:'*':Y.CARD.NOS:'*':Y.INC.AMT:'*':Y.AGENCY:'*':Y.CLIENT.NAME:'*':Y.CARD.CUR
        Y.DATE.TIME = ''; CARD.TYPE.ID = '' ; Y.ACC.NOS ='' ; Y.CARD.NOS = '' ; Y.INC.AMT ='' ; Y.AGENCY = '' ; Y.CLIENT.NAME = '' ;Y.CARD.CUR = ''
    REPEAT
RETURN

GET.DATE.TIME.PRD.TYPE:
***********************
    Y.CARD.TYPE = FIELD(LATAM.CARD.ORDER.ID,'.',1)
    SEL.CMD.DT = 'SSELECT ':FN.REDO.INCR.DECR.ATM.POS.AMT:' WITH @ID LIKE ...':Y.CARD.TYPE
    CALL EB.READLIST(SEL.CMD.DT,SEL.LIST.DT,'',NO.OF.REC.DT,SEL.ERR.DT)
    IF NOT(SEL.LIST.DT) THEN
        RETURN
    END
    REDO.INCR.DECR.ATM.POS.AMT.ID = SEL.LIST.DT<NO.OF.REC.DT>
    IF Y.CARD.DATE THEN
        REDO.INCR.DECR.ATM.POS.AMT.ID = Y.CARD.DATE:'-':Y.CARD.TYPE
    END
    CALL F.READ(FN.REDO.INCR.DECR.ATM.POS.AMT,REDO.INCR.DECR.ATM.POS.AMT.ID,R.REDO.INCR.DECR.ATM.POS.AMT,F.REDO.INCR.DECR.ATM.POS.AMT,Y.POS.AMT.ERR)
    IF R.REDO.INCR.DECR.ATM.POS.AMT<ATM.POS.MX.ATM.TRAN.LIM> GE Y.CARD.AMT OR R.REDO.INCR.DECR.ATM.POS.AMT<ATM.POS.MX.POS.TRAN.LIM> GE Y.CARD.AMT THEN
    END ELSE
        RETURN
    END
    Y.DATE.TIME =R.REDO.INCR.DECR.ATM.POS.AMT<ATM.POS.REC.DATE.TIME>
    CARD.TYPE.ID = FIELD(REDO.INCR.DECR.ATM.POS.AMT.ID,'-',2)

    GOSUB GET.INCREASE.AMOUNT

RETURN

GET.ACCOUNT.CARD.CLIENT.NUMBERS:
********************************
    CALL F.READ(FN.LATAM.CARD.ORDER,LATAM.CARD.ORDER.ID,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,Y.LATAM.ORDER.ERR)
    Y.ACC.NOS = R.LATAM.CARD.ORDER<CARD.IS.ACCOUNT>
    CUSTOMER.ID = R.LATAM.CARD.ORDER<CARD.IS.CUSTOMER.NO>
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    Y.CLIENT.NAME = CUSTOMER.ID:'-':R.CUSTOMER<EB.CUS.NAME.1>
    Y.CARD.NOS = LATAM.CARD.ORDER.ID

RETURN

GET.INCREASE.AMOUNT:
*********************
    IF Y.CARD.CURRENCY THEN
        Y.CARD.CCY=R.REDO.INCR.DECR.ATM.POS.AMT<ATM.POS.LIM.CCY>
        LOCATE Y.CARD.CURRENCY IN Y.CARD.CCY<1,1> SETTING Y.CCY.POS ELSE
            RETURN
        END
        Y.ATM.AMT = R.REDO.INCR.DECR.ATM.POS.AMT<ATM.POS.MX.ATM.TRAN.LIM,Y.CCY.POS>
        COMI = Y.ATM.AMT
        CALL IN2AMT('19','AMT')
        Y.ATM.AMT=V$DISPLAY
        Y.POS.AMT = R.REDO.INCR.DECR.ATM.POS.AMT<ATM.POS.MX.POS.TRAN.LIM,Y.CCY.POS>
        COMI = Y.POS.AMT
        CALL IN2AMT('19','AMT')
        Y.POS.AMT = V$DISPLAY
        Y.INC.AMT = 'ATM - ':Y.ATM.AMT:@VM:'POS - ':Y.POS.AMT
        Y.CARD.CUR = Y.CARD.CURRENCY
    END ELSE
        Y.CARD.CCY=R.REDO.INCR.DECR.ATM.POS.AMT<ATM.POS.LIM.CCY>
        Y.CCY.COUNT=DCOUNT(Y.CARD.CCY,@VM)
        Y.CNTR=1
        LOOP
        WHILE Y.CNTR LE Y.CCY.COUNT
            Y.CARD.CCY=R.REDO.INCR.DECR.ATM.POS.AMT<ATM.POS.LIM.CCY,Y.CNTR>
            Y.ATM.AMT = R.REDO.INCR.DECR.ATM.POS.AMT<ATM.POS.MX.ATM.TRAN.LIM,Y.CNTR>
            COMI = Y.ATM.AMT
            CALL IN2AMT('19','AMT')
            Y.ATM.AMT=V$DISPLAY
            Y.POS.AMT = R.REDO.INCR.DECR.ATM.POS.AMT<ATM.POS.MX.POS.TRAN.LIM,Y.CNTR>
            COMI = Y.POS.AMT
            CALL IN2AMT('19','AMT')
            Y.POS.AMT = V$DISPLAY
            Y.INC.AMT <-1>= 'ATM - ':Y.ATM.AMT:@VM:'POS - ':Y.POS.AMT
            Y.CARD.CUR <-1>= Y.CARD.CCY:@VM:''
            Y.CNTR += 1
        REPEAT
        CHANGE @FM TO @VM IN Y.INC.AMT
        CHANGE @FM TO @VM IN Y.CARD.CUR
    END
RETURN

GET.AGENCYS:
************
    CARD.TYPE.ID = FIELD(LATAM.CARD.ORDER.ID,'.',1)
    SEL.CMD.AGY = 'SELECT ':FN.REDO.CARD.REQUEST:" WITH CARD.TYPE EQ ":CARD.TYPE.ID
    CALL EB.READLIST(SEL.CMD.AGY,SEL.LIST.AGY,'',NO.OF.REC.AGY,SEL.ERR.AGY)
    LOOP
        REMOVE REDO.CARD.REQUEST.ID FROM SEL.LIST.AGY SETTING Y.AGY.POS
    WHILE REDO.CARD.REQUEST.ID:Y.AGY.POS
        CALL F.READ(FN.REDO.CARD.REQUEST,REDO.CARD.REQUEST.ID,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,Y.CARD.REQ.ERR)
        IF R.REDO.CARD.REQUEST<REDO.CARD.REQ.AGENCY> THEN
            LOCATE R.REDO.CARD.REQUEST<REDO.CARD.REQ.AGENCY> IN Y.AGENCY SETTING Y.AGE.POS THEN
            END ELSE
                Y.AGENCY<-1> =R.REDO.CARD.REQUEST<REDO.CARD.REQ.AGENCY>
            END
        END
    REPEAT
    CHANGE @FM TO @VM IN Y.AGENCY
RETURN
END
