SUBROUTINE REDO.APAP.B.INVST.PROVISIONING(SEL.LIST)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.B.INVST.PROVISIONING
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.B.INVST.PROVISIONING is the main process routine. This routine is used to
*                    update the required values and also move the live record to history and update the
*                    live record
*Linked With       : Batch BNK/REDO.B.INVST.PROVISIONING
*In  Parameter     : REDO.H.CUSTOMER.PROVISION.ID - Customer ID, which is the id of the local table
*Out Parameter     : NA
*Files  Used       : REDO.H.CUSTOMER.PROVISION      As              I               Mode
*                    SC.TRADING.POSITION            As              I               Mode
*                    SECURITY.MASTER                As              I               Mode
*                    CUSTOMER                       As              I               Mode
*                    EB.RATING                      As              I               Mode
*                    LMM.ACCOUNT.BALANCES           As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date                 Who                    Reference                  Description
*   ------               -----                 -------------               -------------
* 27 Sep 2010        Shiva Prasad Y        ODR-2010-09-0167 B.23B         Initial Creation
* 01.04.2011           Pradeep S                   PACS00055823                    Fix
* 26.05.2011           RIYAS                   PACS00061656                    Fix
* 27-07-2011           JEEVA T                 PACS00093115                   FIX
* 10 FEB 2012          JEEVA T                 PACS00172864                 Making provision value as absolute
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.APAP.B.INVST.PROVISIONING.COMMON
    $INSERT I_F.REDO.H.CUSTOMER.PROVISION
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
    $INSERT I_F.REDO.H.CUST.WRITE.PROV
    $INSERT I_F.SC.TRADING.POSITION
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.EB.RATING
    $INSERT I_F.LMM.ACCOUNT.BALANCES
    $INSERT I_F.MM.MONEY.MARKET
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    IF NOT(SEL.LIST) THEN

        RETURN
    END
    REDO.H.CUSTOMER.PROVISION.ID = SEL.LIST
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    GOSUB GET.PROV.PERC
    GOSUB READ.REDO.H.CUSTOMER.PROVISION
    GOSUB LOOP.PORTFOLIO.NO
    GOSUB LOOP.MM.CONT.ID

RETURN
*--------------------------------------------------------------------------------------------------------
**************
GET.PROV.PERC:
**************
    CUSTOMER.ID = REDO.H.CUSTOMER.PROVISION.ID
    CALL F.READ(FN.REDO.H.CUST.WRITE.PROV,REDO.H.CUSTOMER.PROVISION.ID,R.REDO.H.CUST.WRITE.PROV,F.REDO.H.CUST.WRITE.PROV,WRITE.ERR)
    GOSUB READ.CUSTOMER
    VAR.PRO.RATING = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.PRO.RATING.POS>
    VAR.RATING.TYPE = R.REDO.H.PROVISION.PARAMETER<PROV.RATING.TYPE>
    CHANGE @VM TO @FM IN VAR.RATING.TYPE
    LOCATE VAR.PRO.RATING IN VAR.RATING.TYPE SETTING POS.RAT THEN
        Y.PROV.PERC = R.REDO.H.PROVISION.PARAMETER<PROV.RATING.PERCENTAGE,POS.RAT>
    END

RETURN
*--------------------------------------------------------------------------------------------------------
******************
LOOP.PORTFOLIO.NO:
******************
    Y.CUS.POT.FOLIO.ID = R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.PORTFOLIO.ID>
    Y.PORT.COUNT       = DCOUNT(Y.CUS.POT.FOLIO.ID,@VM)
    Y.P.COUNT          = 1
    LOOP
    WHILE Y.P.COUNT LE Y.PORT.COUNT
        GOSUB LOOP.SECURITY.NO
        Y.P.COUNT += 1
        GOSUB UPDATE.TOT.CAP.INT.PROV

    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
LOOP.SECURITY.NO:
*****************
    Y.PROV.SEC.NO =  R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SECURITY.NO,Y.P.COUNT>
    Y.SEC.COUNT   = DCOUNT(Y.PROV.SEC.NO, @SM)
    Y.S.COUNT     = 1
    LOOP
    WHILE Y.S.COUNT LE Y.SEC.COUNT
        Y.CURR.POS=R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.NOMINAL,Y.P.COUNT,Y.S.COUNT>
        Y.CAP=R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.INTEREST,Y.P.COUNT,Y.S.COUNT>
        Y.CAP.PROV.VAL = ABS(Y.CURR.POS * (Y.PROV.PERC/100))
        Y.CAP.PROV.VAL = FMT(Y.CAP.PROV.VAL,'R2,')
        R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.CAP.PROV,Y.P.COUNT,Y.S.COUNT>=Y.CAP.PROV.VAL
        R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.INT.PROV,Y.P.COUNT,Y.S.COUNT> =FMT(ABS(Y.CAP * (Y.PROV.PERC/100)),'R2,')
        GOSUB WRITE.REDO.H.CUSTOMER.PROVISION.HIS
        Y.S.COUNT += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
****************
LOOP.MM.CONT.ID:
****************

    Y.PROV.MM.ID = R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.CONT.ID>
    Y.MM.COUNT   = DCOUNT(Y.PROV.MM.ID,@VM)
    Y.M.COUNT    = 1
    LOOP
    WHILE Y.M.COUNT LE Y.MM.COUNT
        Y.EXP.DATE = ''
        LMM.ACCOUNT.BALANCES.ID = R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.CONT.ID,Y.M.COUNT>
        LM.ACC.BAL.ID = LMM.ACCOUNT.BALANCES.ID:'00'
        GOSUB READ.LMM.ACCOUNT.BALANCES
**************************changes for PACS00093115**************************
        GOSUB READ.MM.TABLE
***************************changes for PACS00093115****************************
        Y.OCP = SUM(R.LMM.ACCOUNT.BALANCES<LD27.OUTS.CURR.PRINC>)
        Y.IAT = SUM(R.LMM.ACCOUNT.BALANCES<LD27.INT.AMT.TODATE>)
        IF TODAY GE Y.EXP.DATE THEN
            R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.CAP.PROV,Y.M.COUNT,1> = 0
        END ELSE
            R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.CAP.PROV,Y.M.COUNT,1> =FMT(ABS(Y.OCP * (Y.PROV.PERC/100)),'R2,')
        END
        R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.INT.PROV,Y.M.COUNT,1> = FMT(ABS(Y.IAT * (Y.PROV.PERC/100)),'R2,')
*        GOSUB WRITE.REDO.H.CUSTOMER.PROVISION.HIS *//// changes for PACS00093115
        Y.M.COUNT += 1
*        GOSUB UPDATE.TOT.CAP.INT.PROV             *//// changes for PACS00093115
    REPEAT
    GOSUB WRITE.REDO.H.CUSTOMER.PROVISION.HIS
    GOSUB UPDATE.TOT.CAP.INT.PROV
RETURN
*--------------------------------------------------------------------------------------------------------
*******************************
READ.MM.TABLE:
*******************************
    Y.MM.ID = R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.CONT.ID,Y.M.COUNT>
    CALL F.READ(FN.MM.MONEY.MARKET,Y.MM.ID,R.MM.MONEY.MARKET,F.MM.MONEY.MARKET,Y.MM.ERR)
    Y.EXP.DATE  = R.MM.MONEY.MARKET<MM.MATURITY.DATE>
RETURN
*--------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
*******************************
READ.REDO.H.CUSTOMER.PROVISION:
*******************************
* In this para of the code, file REDO.H.CUSTOMER.PROVISION is read
    R.REDO.H.CUSTOMER.PROVISION  = ''
    REDO.H.CUSTOMER.PROVISION.ER = ''
    CALL F.READ(FN.REDO.H.CUSTOMER.PROVISION,REDO.H.CUSTOMER.PROVISION.ID,R.REDO.H.CUSTOMER.PROVISION,F.REDO.H.CUSTOMER.PROVISION,REDO.H.CUSTOMER.PROVISION.ER)
RETURN
*--------------------------------------------------------------------------------------------------------
**************
READ.CUSTOMER:
**************
* In this para of the code, file CUSTOMER is read
    R.CUSTOMER  = ''
    CUSTOMER.ER = ''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ER)
RETURN
*--------------------------------------------------------------------------------------------------------
**************************
READ.LMM.ACCOUNT.BALANCES:
**************************
* In this para of the code, file LMM.ACCOUNT.BALANCES is read
    R.LMM.ACCOUNT.BALANCES  = ''
    LMM.ACCOUNT.BALANCES.ER = ''
    CALL F.READ(FN.LMM.ACCOUNT.BALANCES,LM.ACC.BAL.ID,R.LMM.ACCOUNT.BALANCES,F.LMM.ACCOUNT.BALANCES,LMM.ACCOUNT.BALANCES.ER)
RETURN
*--------------------------------------------------------------------------------------------------------
************************************
WRITE.REDO.H.CUSTOMER.PROVISION.LIVE:
************************************
    CALL F.WRITE(FN.REDO.H.CUSTOMER.PROVISION,REDO.H.CUSTOMER.PROVISION.ID,R.REDO.H.CUSTOMER.PROVISION)
RETURN
*--------------------------------------------------------------------------------------------------------
*************************************
WRITE.REDO.H.CUSTOMER.PROVISION.HIS:
*************************************
    Y.SC.CHECK=R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.PORTFOLIO.ID>
    Y.SC.CHECK = Y.SC.CHECK<1,Y.P.COUNT>
    IF Y.SC.CHECK THEN
        R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.PORTFOLIO.ID,Y.P.COUNT> =R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.PORTFOLIO.ID,Y.P.COUNT>
        R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SECURITY.NO,Y.P.COUNT,Y.S.COUNT>=R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SECURITY.NO,Y.P.COUNT,Y.S.COUNT>
        R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.NOMINAL,Y.P.COUNT,Y.S.COUNT>=Y.CURR.POS
        R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.INTEREST,Y.P.COUNT,Y.S.COUNT>=Y.CAP
        R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.CAP.PROV,Y.P.COUNT,Y.S.COUNT>=R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.CAP.PROV,Y.P.COUNT,Y.S.COUNT>
        R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.INT.PROV,Y.P.COUNT,Y.S.COUNT>=R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.INT.PROV,Y.P.COUNT,Y.S.COUNT>
        R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.TOT.CAP.PROV> = Y.TOTAL.CAP
        R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.TOT.INT.PROV> = Y.TOTAL.INT
        GOSUB AUDIT.FIELDS
    END
    IF LMM.ACCOUNT.BALANCES.ID THEN
        IF Y.SC.CHECK EQ ''  THEN
            R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.SC.PORTFOLIO.ID,Y.P.COUNT> = ''
        END
        R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.MM.CONT.ID,Y.M.COUNT>=LMM.ACCOUNT.BALANCES.ID

        R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.MM.PRINCIPAL,Y.M.COUNT,1> = R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.PRINCIPAL,Y.M.COUNT,1>
        R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.MM.INTEREST,Y.M.COUNT,1> = R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.INTEREST,Y.M.COUNT,1>
        R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.MM.CAP.PROV,Y.M.COUNT,1>=R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.CAP.PROV,Y.M.COUNT,1>
        R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.MM.INT.PROV,Y.M.COUNT,1>=R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.INT.PROV,Y.M.COUNT,1>
        R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.TOT.CAP.PROV> = Y.TOTAL.CAP
        R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.TOT.INT.PROV> = Y.TOTAL.INT
        GOSUB AUDIT.FIELDS
    END

RETURN
**************
AUDIT.FIELDS:

***************
    SYS.TIME.NOW = OCONV(DATE(),"D-")
    SYS.TIME.NOW = SYS.TIME.NOW[9,2]:SYS.TIME.NOW[1,2]:SYS.TIME.NOW[4,2]
    SYS.TIME.NOW := TIMEDATE()[1,2]:TIMEDATE()[4,2]
    R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.TOT.CAP.PROV>= R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.TOT.CAP.PROV>
    R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.TOT.INT.PROV>=R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.TOT.INT.PROV>
    R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.REC.DATE>=R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.REC.DATE>
    R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.INPUTTER> = OPERATOR
    R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.DATE.TIME> = SYS.TIME.NOW
    R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.AUTHORISER> = OPERATOR
    R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.CO.CODE> = ID.COMPANY
    PROVISION.ID = REDO.H.CUSTOMER.PROVISION.ID:'-':TODAY
    R.REDO.H.CUST.WRITE.PROV<CUS.WRITE.CURR.NO> = 1
    CALL F.WRITE(FN.REDO.H.CUST.WRITE.PROV,PROVISION.ID,R.REDO.H.CUST.WRITE.PROV)
RETURN
*--------------------------------------------------------------------------------------------------------
************************
UPDATE.TOT.CAP.INT.PROV:
************************
    Y.SC.TOT.CAP=SUM(R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.CAP.PROV>)
    Y.MM.TOT.CAP=SUM(R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.CAP.PROV>)
    Y.SC.TOT.INT=SUM(R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.INT.PROV>)
    Y.MM.TOT.INT=SUM(R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.INT.PROV>)
    GOSUB CHECK.TOTAL
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.TOT.CAP.PROV> = Y.TOTAL.CAP
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.TOT.INT.PROV> = Y.TOTAL.INT
    GOSUB WRITE.REDO.H.CUSTOMER.PROVISION.LIVE

RETURN
*--------------------------------------------------------------------------------------------------------
************
CHECK.TOTAL:
************

    Y.VM.COUNT = DCOUNT(Y.SC.TOT.CAP,@VM)
    Y.INT.CNT = 1
    LOOP
    WHILE Y.INT.CNT LE Y.VM.COUNT
        IF Y.SC.TOT.CAP THEN
            Y.TOTAL.CAP += Y.SC.TOT.CAP<1,Y.INT.CNT>
        END
        IF Y.MM.TOT.CAP THEN
            Y.TOTAL.CAP += Y.MM.TOT.CAP<1,Y.INT.CNT>
        END
        IF Y.SC.TOT.INT THEN
            Y.TOTAL.INT += Y.SC.TOT.INT<1,Y.INT.CNT>
        END
        IF Y.MM.TOT.INT THEN
            Y.TOTAL.INT +=Y.MM.TOT.INT<1,Y.INT.CNT>
        END
        Y.INT.CNT +=1
    REPEAT
RETURN
*******************************************************************************************************************
END       ;* End of Program
