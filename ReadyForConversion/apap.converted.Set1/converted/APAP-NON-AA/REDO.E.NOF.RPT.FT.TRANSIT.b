SUBROUTINE REDO.E.NOF.RPT.FT.TRANSIT(Y.RESULT.ARRAY)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.E.NOF.RPT.FT.TRANSIT
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.E.NOF.RPT.FT.TRANSIT is the nofile routine for the enquiry REDO.ENQ.FT.TRANSIT
*                    which fetches required values from REDO.CLEARING.OUTWARD and ACCOUNT files
*In Parameter      : N/A
*Out Parameter     : Y.RESULT.ARRAY
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date             Who                      Reference                 Description
*   ------          ------                     -------------             -------------
*  20 DEC 2010     MOhammed Anies K           ODR-2010-08-0172          Initial Creation
*  03 MAY 2013     Arundev                    PACS00260027              4360 - Cadena 9357 - 72.REPORTE DE FONDOS EN TRANSITO. (Issues Criticos)
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CLEARING.OUTWARD
*Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*Tus End
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*********
OPEN.PARA:
*********

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.CLEARING.OUTWARD = 'F.REDO.CLEARING.OUTWARD'
    F.REDO.CLEARING.OUTWARD = ''
    CALL OPF(FN.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD)

RETURN
*--------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
************

    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB FORM.SELECT.CMD
    GOSUB GET.DETAILS

RETURN
*--------------------------------------------------------------------------------------------------------
***************
FORM.SELECT.CMD:
***************

    SEL.CMD.RCO = "SELECT ":FN.REDO.CLEARING.OUTWARD:" WITH BATCH.RELEASED EQ 'N'"

    LOCATE "Y.TRANSIT.DATE" IN D.FIELDS<1> SETTING Y.TRANSIT.DATE.POS THEN
        SEL.CMD.RCO := " AND EXPOSURE.DATE EQ ":D.RANGE.AND.VALUE<Y.TRANSIT.DATE.POS>
    END ELSE
        SEL.CMD.RCO := " AND EXPOSURE.DATE GE ":TODAY
    END

    LOCATE "Y.ACCOUNT.NO" IN D.FIELDS<1> SETTING Y.ACCOUNT.NO.POS THEN
        SEL.CMD.RCO := " AND ACCOUNT EQ ":D.RANGE.AND.VALUE<Y.ACCOUNT.NO.POS>
    END

    SEL.CMD.RCO := " BY ACCOUNT"

    CALL EB.READLIST(SEL.CMD.RCO,SEL.LIST,'',NO.OF.REC,SEL.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------
***********
GET.DETAILS:
***********
    Y.PREV.ACCOUNT.NO = ''
    Y.FIRST.TIME.FLAG = ''
    Y.TOT.COUNT = DCOUNT(SEL.LIST,@FM)
    Y.INT.COUNT = 1

    LOOP
    WHILE Y.INT.COUNT LE Y.TOT.COUNT
        Y.REDO.CLEARING.OUTWARD.ID = SEL.LIST<Y.INT.COUNT>
        R.REDO.CLEARING.OUTWARD = ''
        CALL F.READ(FN.REDO.CLEARING.OUTWARD,Y.REDO.CLEARING.OUTWARD.ID,R.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD,REDO.CLEARING.OUTWARD.ERR)
        Y.RCO.ACCOUNT.NO = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.ACCOUNT>
        IF Y.RCO.ACCOUNT.NO AND Y.RCO.ACCOUNT.NO EQ Y.PREV.ACCOUNT.NO THEN
            GOSUB GET.RCO.DETAILS
            IF Y.INT.COUNT EQ Y.TOT.COUNT THEN
                GOSUB FORM.RESULT.ARRAY
            END
        END ELSE
            IF Y.RCO.ACCOUNT.NO THEN
                Y.FIRST.TIME.FLAG = 1
                GOSUB FORM.RESULT.ARRAY
                Y.PREV.ACCOUNT.NO = Y.RCO.ACCOUNT.NO
                GOSUB GET.ACCOUNT.DETAILS
                GOSUB GET.RCO.DETAILS
                Y.FIRST.TIME.FLAG = ''
                IF Y.INT.COUNT EQ Y.TOT.COUNT THEN
                    GOSUB FORM.RESULT.ARRAY
                END
            END
        END
        Y.INT.COUNT +=1
    REPEAT
RETURN
*--------------------------------------------------------------------------------------------------------
*******************
GET.ACCOUNT.DETAILS:
*******************
    CALL F.READ(FN.ACCOUNT,Y.RCO.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    R.ECB='' ; ECB.ERR='' ;*Tus Start
    CALL EB.READ.HVT("EB.CONTRACT.BALANCES",Y.RCO.ACCOUNT.NO,R.ECB,ECB.ERR);*Tus End
    Y.ACCOUNT.TYPE    = R.ACCOUNT<AC.CATEGORY>
    Y.ACCOUNT.OFFICER = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    Y.AGENCY          = R.ACCOUNT<AC.CO.CODE>
    Y.CURRENCY        = R.ACCOUNT<AC.CURRENCY>
* Y.TOT.BALANCE     = R.ACCOUNT<AC.ONLINE.ACTUAL.BAL>;*Tus Start
    Y.TOT.BALANCE     = R.ECB<ECB.ONLINE.ACTUAL.BAL>;*Tus End
    IF Y.TOT.BALANCE EQ '' THEN
        Y.TOT.BALANCE = 0
    END
    Y.BAL.AVAILABLE   = R.ACCOUNT<AC.LOCAL.REF,L.AC.AV.BAL.POS>
    IF Y.BAL.AVAILABLE EQ '' THEN
        Y.BAL.AVAILABLE = 0
    END
    Y.BAL.IN.TRANSIT  = R.ACCOUNT<AC.LOCAL.REF,L.AC.TRAN.AVAIL.POS>
    IF Y.BAL.IN.TRANSIT EQ '' THEN
        Y.BAL.IN.TRANSIT = 0
    END

RETURN
*--------------------------------------------------------------------------------------------------------
***************
GET.RCO.DETAILS:
***************

    Y.EXPOSURE.DATE = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.EXPOSURE.DATE>

*PACS00260027-start
***Y.NO.OF.CHEQUES = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.NO.OF.CHEQUE>
    Y.NO.OF.CHEQUES = 1         ;*field no.of cheque is update no more , instead we are counting the number of txns for the account
*PACS00260027-end

    Y.AMOUNT        = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.AMOUNT>

    IF Y.FIRST.TIME.FLAG THEN
        Y.EXPOSURE.DATE.LIST = Y.EXPOSURE.DATE
        Y.TOTAL.NO.OF.CHEQUES = Y.NO.OF.CHEQUES
        Y.TOTAL.AMOUNT = Y.AMOUNT
    END ELSE
        LOCATE Y.EXPOSURE.DATE IN Y.EXPOSURE.DATE.LIST SETTING Y.EXPOSURE.DATE.POS THEN
            Y.TOTAL.NO.OF.CHEQUES<Y.EXPOSURE.DATE.POS> = Y.TOTAL.NO.OF.CHEQUES<Y.EXPOSURE.DATE.POS> + Y.NO.OF.CHEQUES
            Y.TOTAL.AMOUNT<Y.EXPOSURE.DATE.POS> = Y.TOTAL.AMOUNT<Y.EXPOSURE.DATE.POS> + Y.AMOUNT
        END ELSE
            Y.EXPOSURE.DATE.LIST<-1> = Y.EXPOSURE.DATE
            Y.TOTAL.NO.OF.CHEQUES<-1> = Y.NO.OF.CHEQUES
            Y.TOTAL.AMOUNT<-1> = Y.AMOUNT
        END
    END
RETURN
*--------------------------------------------------------------------------------------------------------
*****************
FORM.RESULT.ARRAY:
*****************
    IF Y.PREV.ACCOUNT.NO THEN
        CHANGE @FM TO @VM IN Y.EXPOSURE.DATE.LIST
        CHANGE @FM TO @VM IN Y.TOTAL.NO.OF.CHEQUES
        CHANGE @FM TO @VM IN Y.TOTAL.AMOUNT

        Y.RESULT.ARRAY<-1> = Y.PREV.ACCOUNT.NO :'*': Y.ACCOUNT.TYPE :'*': Y.ACCOUNT.OFFICER :'*': Y.AGENCY :'*': Y.CURRENCY :'*': Y.TOT.BALANCE:'*'
        Y.RESULT.ARRAY := Y.BAL.AVAILABLE :'*': Y.BAL.IN.TRANSIT :'*': Y.EXPOSURE.DATE.LIST :'*': Y.TOTAL.NO.OF.CHEQUES :'*': Y.TOTAL.AMOUNT
    END

RETURN
*--------------------------------------------------------------------------------------------------------
********************
FIND.MULTI.LOCAL.REF:
********************

    APPL.ARRAY = 'ACCOUNT'
    FLD.ARRAY = 'L.AC.AV.BAL':@VM:'L.AC.TRAN.AVAIL'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    L.AC.AV.BAL.POS     = FLD.POS<1,1>
    L.AC.TRAN.AVAIL.POS = FLD.POS<1,2>

RETURN
*--------------------------------------------------------------------------------------------------------
END
