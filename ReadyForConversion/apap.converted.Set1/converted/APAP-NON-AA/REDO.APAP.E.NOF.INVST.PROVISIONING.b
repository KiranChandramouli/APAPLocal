SUBROUTINE REDO.APAP.E.NOF.INVST.PROVISIONING(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.E.NOF.INVST.PROVISIONING
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.E.NOF.INVST.PROVISIONING is a no-file enquiry routine for the enquiry
*                    REDO.APAP.ENQ.INVST.PROVISIONING, the routine based on the selection criteria
*                    selects the records from REDO.H.CUSTOMER.PROVISION and displays the processed records
*Linked With       : Enquiry - REDO.APAP.ENQ.INVST.PROVISIONING
*In  Parameter     : NA
*Out Parameter     : Y.OUT.ARRAY - Final list of records to be displayed
*Files  Used       : REDO.H.CUSTOMER.PROVISION             As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
* 23 Sep 2010        Mudassir V         ODR-2010-09-0167 B.23B        Initial Creation
* 26.05.2011           RIYAS                   PACS00061656                    Fix
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.CUST.WRITE.PROV
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
    FN.REDO.H.CUST.WRITE.PROV = 'F.REDO.H.CUST.WRITE.PROV'
    F.REDO.H.CUST.WRITE.PROV  = ''
    CALL OPF(FN.REDO.H.CUST.WRITE.PROV,F.REDO.H.CUST.WRITE.PROV)

    FN.REDO.H.CUST.WRITE.PROV.HIS = 'F.REDO.H.CUST.WRITE.PROV$HIS'
    F.REDO.H.CUST.WRITE.PROV.HIS  = ''
    CALL OPF(FN.REDO.H.CUST.WRITE.PROV.HIS,F.REDO.H.CUST.WRITE.PROV.HIS)

    Y.CUSTOMER.ID = ''
    Y.PROV.DATE   = ''

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

    GOSUB GET.PROCESSED.IDS

    Y.PROCESSED.IDS = SEL.LIST.LIVE

    IF NOT(Y.PROCESSED.IDS) THEN
        RETURN
    END

    Y.PROCESSED.IDS = SORT(Y.PROCESSED.IDS)

    GOSUB GET.DETAILS

RETURN
*--------------------------------------------------------------------------------------------------------
******************
GET.PROCESSED.IDS:
******************
    GOSUB GET.LIVE.PROCESSED.IDS

RETURN
*--------------------------------------------------------------------------------------------------------
***********************
GET.LIVE.PROCESSED.IDS:
***********************
    LOCATE 'CUSTOMER.ID' IN D.FIELDS<1> SETTING Y.CUS.POS THEN
        Y.CUSTOMER.ID = D.RANGE.AND.VALUE<Y.CUS.POS>
        LAST.WORK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
        SEL.LIST.CMD = 'SELECT ':FN.REDO.H.CUST.WRITE.PROV:" WITH @ID EQ ":Y.CUSTOMER.ID:"-":LAST.WORK.DATE
        LOCATE 'PROV.DATE' IN D.FIELDS<1> SETTING Y.DATE.POS THEN
            Y.PROV.DATE = D.RANGE.AND.VALUE<Y.DATE.POS>
            SEL.LIST.CMD = 'SELECT ':FN.REDO.H.CUST.WRITE.PROV:" WITH @ID LIKE ...":Y.CUSTOMER.ID:"-":Y.PROV.DATE
        END
    END ELSE
        SEL.LIST.CMD = 'SELECT ':FN.REDO.H.CUST.WRITE.PROV:" WITH @ID LIKE ...":LAST.WORK.DATE:"..."
        LOCATE 'PROV.DATE' IN D.FIELDS<1> SETTING Y.DATE.POS THEN
            SEL.LIST.CMD = 'SELECT ':FN.REDO.H.CUST.WRITE.PROV:" WITH @ID LIKE ...":"-":LAST.WORK.DATE
        END
    END
    CALL EB.READLIST(SEL.LIST.CMD,SEL.LIST.LIVE, '', NO.OF.REC.LIVE, SEL.ERR.LIVE)


RETURN
*--------------------------------------------------------------------------------------------------------
************
GET.DETAILS:
************


    LOOP
        REMOVE Y.SEL.ID FROM Y.PROCESSED.IDS  SETTING Y.PROV.POS
    WHILE Y.SEL.ID:Y.PROV.POS
        CALL F.READ(FN.REDO.H.CUST.WRITE.PROV,Y.SEL.ID,R.REDO.H.CUST.WRITE.PROV,F.REDO.H.CUST.WRITE.PROV,CUSTOMER.PROVISION.ERR)
        GOSUB FETCH.DETAILS
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
**************
FETCH.DETAILS:
**************
    Y.CUS.ID       = Y.SEL.ID
    Y.PORT.NO      = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.PORTFOLIO.ID>
    Y.TOTAL.SEC     = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SECURITY.NO>
    Y.SC.NOMINAL   = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.NOMINAL>
    Y.SC.INTEREST   = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.INTEREST>
    Y.SC.CAP.PROV  = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.CAP.PROV>
    Y.SC.INT.PROV  = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.INT.PROV>
    Y.MM.NOMINAL   = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.MM.PRINCIPAL>
    Y.MM.INTEREST   = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.MM.INTEREST>
    Y.MM.CAP.PROV  = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.MM.CAP.PROV>
    Y.MM.INT.PROV  = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.MM.INT.PROV>
    Y.TOT.CAP.PROV = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.TOT.CAP.PROV>
    Y.TOT.INT.PROV = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.TOT.INT.PROV>

    Y.CUS.POT.FOLIO.ID = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.PORTFOLIO.ID>
    Y.PORT.COUNT       = DCOUNT(Y.CUS.POT.FOLIO.ID,@VM)
    Y.P.COUNT          = 1

    LOOP
    WHILE Y.P.COUNT LE Y.PORT.COUNT
        Y.FOLIO=R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.PORTFOLIO.ID,Y.P.COUNT>
        GOSUB LOOP.SECURITY.NO
        GOSUB GET.VALUES
        GOSUB FINAL.ARRAY
        Y.P.COUNT += 1
    REPEAT

    Y.MM.CONT.ID   = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.MM.CONT.ID>
    Y.MM.COUNT = DCOUNT(Y.MM.CONT.ID,@VM)
    Y.M.COUNT =1
    LOOP
    WHILE Y.M.COUNT LE Y.MM.COUNT
        Y.MMARKET.ID=R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.MM.CONT.ID,Y.M.COUNT>
        Y.MM.NOM = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.MM.PRINCIPAL,Y.M.COUNT>
        Y.MM.INT = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.MM.INTEREST,Y.M.COUNT>
        Y.MM.TOTAL.NOM = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.MM.CAP.PROV,Y.M.COUNT>
        Y.MM.TOTAL.INT = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.MM.INT.PROV,Y.M.COUNT>
        GOSUB FINAL.ARRAY
        Y.M.COUNT += 1
    REPEAT

RETURN

**************************************************************************************
LOOP.SECURITY.NO:
***************************************************************************************
    Y.PROV.SEC.NO = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SECURITY.NO,Y.P.COUNT>
    Y.SEC.COUNT   = DCOUNT(Y.PROV.SEC.NO, @SM)
    Y.S.COUNT     = 1
    Y.LIST=''
    Y.MM.LIST= ''
    Y.TOT=''
    LOOP
    WHILE Y.S.COUNT LE Y.SEC.COUNT
        Y.MAIN=R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SECURITY.NO,Y.P.COUNT,Y.S.COUNT>
        Y.SC.NOM = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.NOMINAL,Y.P.COUNT,Y.S.COUNT>
        Y.SC.INT = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.INTEREST,Y.P.COUNT,Y.S.COUNT>
        Y.CAP.NOM = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.CAP.PROV,Y.P.COUNT,Y.S.COUNT>
        Y.CAP.INT = R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.INT.PROV,Y.P.COUNT,Y.S.COUNT>
        LOCATE Y.MAIN IN Y.LIST<1,1> SETTING PRD.POS THEN
            Y.AMOUNT<1,PRD.POS> += Y.SC.NOM
            Y.INTEREST<1,PRD.POS>+=Y.SC.INT
            T.TOTAL.AMOUNT<1,PRD.POS>+= Y.CAP.NOM
            Y.TOTAL.INTEREST<1,PRD.POS> += Y.CAP.INT
        END ELSE
            Y.LIST<1,-1>    = Y.MAIN
            Y.AMOUNT<1,-1> += Y.SC.NOM
            Y.INTEREST<1,-1> += Y.SC.INT
            T.TOTAL.AMOUNT<1,-1> += Y.CAP.NOM
            Y.TOTAL.INTEREST<1,-1> += Y.CAP.INT
        END

        Y.S.COUNT += 1

    REPEAT
RETURN

***********
GET.VALUES:
***********

    Y.CNT =1
    Y.TAKE.COUNT = DCOUNT(Y.LIST,@VM)
    LOOP
    WHILE Y.CNT LE Y.TAKE.COUNT
        Y.FINAL.LIST<-1> = Y.LIST<1,Y.CNT>
        Y.FINAL.AMOUNT<-1> = Y.AMOUNT<1,Y.CNT>
        Y.FINAL.INTEREST<-1> = Y.INTEREST<1,Y.CNT>
        Y.FINAL.TOTAL.AMOUNT<-1> = T.TOTAL.AMOUNT<1,Y.CNT>
        Y.FINAL.TOTAL.INTEREST<-1> = Y.TOTAL.INTEREST<1,Y.CNT>
        Y.CNT +=1
    REPEAT
RETURN

*************
FINAL.ARRAY:
*************
    CHANGE @FM TO @VM IN Y.FINAL.LIST
    CHANGE @FM TO @VM IN Y.FINAL.AMOUNT
    CHANGE @FM TO @VM IN Y.FINAL.INTEREST
    CHANGE @FM TO @VM IN Y.FINAL.TOTAL.AMOUNT
    CHANGE @FM TO @VM IN Y.FINAL.TOTAL.INTEREST
    CHANGE @SM TO @VM IN Y.FOLIO
    CHANGE @SM TO @VM IN Y.MMARKET.ID
    CHANGE @SM TO @VM IN Y.MM.NOM
    CHANGE @SM TO @VM IN Y.MM.INT
    CHANGE @SM TO @VM IN Y.MM.TOTAL.NOM
    CHANGE @SM TO @VM IN Y.MM.TOTAL.INT
    CHANGE @SM TO @VM IN Y.TOT.CAP.PROV
    CHANGE @SM TO @VM IN  Y.TOT.INT.PROV
    Y.OUT.ARRAY<-1> = Y.CUS.ID :'*': Y.FOLIO:'*':Y.FINAL.LIST:'*': Y.FINAL.AMOUNT:'*': Y.FINAL.INTEREST:'*': Y.FINAL.TOTAL.AMOUNT:'*': Y.FINAL.TOTAL.INTEREST:'*': Y.MMARKET.ID:'*': Y.MM.NOM:'*': Y.MM.INT:'*': Y.MM.TOTAL.NOM:'*': Y.MM.TOTAL.INT:'*':Y.TOT.CAP.PROV:'*': Y.TOT.INT.PROV
    Y.CUS.ID = '' ;Y.PORT.NO = ''; Y.FINAL.LIST = ''; Y.FINAL.AMOUNT = '' ; Y.FINAL.INTEREST = ''; Y.FINAL.TOTAL.AMOUNT =''
    Y.FINAL.TOTAL.INTEREST =''; Y.AMOUNT = ''; Y.INTEREST = ''; T.TOTAL.AMOUNT = ''; Y.TOTAL.INTEREST = ''
    Y.LIST = ''; Y.MAIN = ''; Y.SC.NOM = ''; Y.SC.INT = ''; Y.CAP.NOM = '';Y.CAP.INT = '';Y.FOLIO=''
    Y.MM.TOTAL.NOM = ''; Y.MM.TOTAL.INT= ''; Y.TOT.CAP.PROV=''; Y.TOT.INT.PROV=''
    Y.MMARKET.ID= '' Y.MM.NOM=''; Y.MM.INT=''
RETURN
*--------------------------------------------------------------------------------------------------------
END
