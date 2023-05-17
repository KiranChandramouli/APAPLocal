SUBROUTINE REDO.COMPUTE.SEC.PERCENT
*------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This routine is used as input routine to the versions SEC.TRADE,APAP.BUY.OWN.BOOK
*               and SEC.TRADE,APAP.SELL.OWN.BOOK
*------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.COMPUTE.SEC.PERCENT
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 03-Aug-2010      Naveenkumar N    ODR-2010-07-0080            Initial creation
* 28-Mar-2011      Pradeep S        PACS00051213                Mapping changed for Clean & Dirty price
* 01-Apr-2011      Pradeep S        PACS00052348                Mapping changed for Clean & Dirty price
*                                                               Removed the section RESTRICT.LENGTH
* 08-Jul-2011      Pradeep S        PACS00056285                Clean/Dirty price format changed for DBOND
* 15-Jul-2011      Pradeep S        PACS00056285(KB)            Clean/Dirty price calc logic changed for dicounted BOND
* 15-Jul-2011      Pradeep S        PACS00090196                Below routine logic not considered for SHARES
* 01-Feb-2013      Pradeep S        PACS00247574                Clean & Dirty price multiplied by 100 for PRICE calculation method
*----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.PRICE.TYPE
*

    IF V$FUNCTION EQ 'I' THEN
        GOSUB INIT
        GOSUB PROCESS
    END
RETURN
*****
INIT:
*****
*Gosub to Initialise the necessary Variables
*
    FN.SECURITY.MASTER  = "F.SECURITY.MASTER"
    F.SECURITY.MASTER   = ""
    R.SECURITY.MASTER   = ""
    E.SECURITY.MASTER   = ""
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)
*PACS00052348 - S
    FN.PRICE.TYPE = 'F.PRICE.TYPE'
    F.PRICE.TYPE = ''
    CALL OPF(FN.PRICE.TYPE,F.PRICE.TYPE)
*PACS00052348 - E
    Y.ZERO = "0000"
    Y.TWO.ZERO = "00"
RETURN
********
PROCESS:
********
*Gosub for the main process
*
    Y.SEC.CODE          = R.NEW(SC.SBS.SECURITY.CODE)
    GOSUB READ.SECURITY.MASTER
    GOSUB PROCESS.CALCULATION
    GOSUB MULTI.LOCAL
    GOSUB UPDATE.FIELDS
RETURN
*********************
READ.SECURITY.MASTER:
*********************
*Read to Security.Master inorder to get the Redem Price
*
    CALL F.READ(FN.SECURITY.MASTER,Y.SEC.CODE,R.SECURITY.MASTER,F.SECURITY.MASTER,E.SECURITY.MASTER)
    Y.REDEM.PRICE       = R.SECURITY.MASTER<SC.SCM.REDEM.PRICE>
*PACS00052348 - S
*PACS00090196 - S
    Y.BOND.OR.SHARE     = R.SECURITY.MASTER<SC.SCM.BOND.OR.SHARE>
    IF Y.BOND.OR.SHARE NE 'B' THEN
        GOSUB PGM.END
    END
*PACS00090196 - S
    Y.PRICE.TYPE        = R.SECURITY.MASTER<SC.SCM.PRICE.TYPE>
    R.PRICE.TYPE = ''
    CALL CACHE.READ(FN.PRICE.TYPE, Y.PRICE.TYPE, R.PRICE.TYPE, PT.ERR)
    Y.PRICE.PREC = R.PRICE.TYPE<SC.PRT.PERCENTAGE>
    Y.CALC.MTD = R.PRICE.TYPE<SC.PRT.CALCULATION.METHOD>      ;*PACS00056285 - S/E
*PACS00052348 - E
RETURN
*******************
PROCESS.CALCULATION:
*******************
*Calculation for updating the Local fields
*
    Y.CL.PR.PERCENT = ''
    Y.DR.PR.PERCENT = ''
    Y.DIFF = ''
    Y.CU.GROSS.AM.TRD   = R.NEW(SC.SBS.CU.GROSS.AM.TRD)
    Y.CUST.NO.NOM       = R.NEW(SC.SBS.CUST.NO.NOM)
    Y.CU.GROSS.ACCR     = R.NEW(SC.SBS.CU.GROSS.ACCR)

*PACS00051213 - S
    Y.CU.PRICE          = R.NEW(SC.SBS.CUST.PRICE)
    Y.CU.INT.AMT        = R.NEW(SC.SBS.CUST.INTR.AMT)
*PACS00051213 - E

*
    CHANGE @VM TO '*' IN Y.CU.GROSS.AM.TRD
    CHANGE @VM TO '*' IN Y.CUST.NO.NOM
    CHANGE @VM TO '*' IN Y.CU.GROSS.ACCR
    CHANGE @VM TO '*' IN Y.CU.INT.AMT      ;*PACS00051213 - S/E

    Y.COUNT = DCOUNT(Y.CU.GROSS.AM.TRD,'*')
    INIT.1 = 1
    LOOP
    WHILE INIT.1 LE Y.COUNT
        Y.FIRST.AM.TD = FIELD(Y.CU.GROSS.AM.TRD,'*',INIT.1)
        Y.FIRST.NOM = FIELD(Y.CUST.NO.NOM,'*',INIT.1)
        Y.FIRST.CU.CROSS = FIELD(Y.CU.GROSS.ACCR,'*',INIT.1)

*PACS00051213 - S
*  Y.FIRST.CU.INT.AMT = FIELD(Y.CU.INT.AMT,'*',INIT.1)
        Y.CUST.PRICE = Y.CU.PRICE<1,INIT.1,1>

*  Y.CL.PR.PERCENT<-1>  := (Y.CUST.PRICE*100)/Y.FIRST.NOM

*  Y.DP.1 = Y.CUST.PRICE + (Y.FIRST.CU.INT.AMT/Y.FIRST.NOM)
*  Y.DR.PR.PERCENT<-1>  := (Y.DP.1*100)/Y.FIRST.NOM

*PACS00052348 - S
        IF Y.PRICE.PREC EQ "Y" THEN
            Y.CL.PR.PERCENT<-1>  := (Y.FIRST.AM.TD)/Y.FIRST.NOM
            Y.DR.PR.PERCENT<-1>  := (Y.FIRST.CU.CROSS)/Y.FIRST.NOM
        END ELSE
            Y.CL.PR.PERCENT<-1>  := (Y.FIRST.AM.TD*100)/Y.FIRST.NOM
            Y.DR.PR.PERCENT<-1>  := (Y.FIRST.CU.CROSS*100)/Y.FIRST.NOM
        END
*PACS00052348 - E


* Y.DIFF<-1> := (((Y.CL.PR.PERCENT<1,INIT.1>-Y.REDEM.PRICE)/100)*Y.FIRST.NOM)

* Y.DIFF<-1> := (((Y.CUST.PRICE-Y.REDEM.PRICE)/100)*Y.FIRST.NOM)
        Y.DIFF<-1> := FMT((Y.FIRST.AM.TD - Y.FIRST.NOM),"18L2")
*PACS00051213 - E


        INIT.1 += 1
    REPEAT
RETURN

************
MULTI.LOCAL:
************
*Extracting the Local Field Positions
*
    APPLICATION.ID = 'SEC.TRADE'
    FIELD.NAME = 'L.CLEAN.PERCENT':@VM:'L.DIRTY.PERCENT':@VM:'L.DISC.AMOUNT'
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(APPLICATION.ID,FIELD.NAME,FIELD.POS)
    L.CLEAN.PERCENT.POS = FIELD.POS<1,1>
    L.DIRTY.PERCENT.POS = FIELD.POS<1,2>
    L.DISC.AMOUNT.POS   = FIELD.POS<1,3>
RETURN

**************
UPDATE.FIELDS:
**************
*Updating the local fields with calculated values
*
    Y.ASS.COUNT = DCOUNT(Y.CL.PR.PERCENT,@FM)
    INIT.3 = 1
    LOOP
    WHILE INIT.3 LE Y.ASS.COUNT
*PACS00056285 - S
        Y.TEMP.CL.PR = TRIM(Y.CL.PR.PERCENT<INIT.3>,'',"B")
        Y.TEMP.DR.PR = TRIM(Y.DR.PR.PERCENT<INIT.3>,'',"B")
*PACS00056285 - KB - S
        IF Y.CALC.MTD EQ 'DPRICE' THEN
            R.NEW(SC.SBS.LOCAL.REF)<1,L.CLEAN.PERCENT.POS,INIT.3> = TRIM( (FMT( (Y.TEMP.CL.PR * 100),"18L4")), '',"B")
            R.NEW(SC.SBS.LOCAL.REF)<1,L.DIRTY.PERCENT.POS,INIT.3> = TRIM( (FMT( (Y.TEMP.DR.PR * 100),"18L4")), '',"B")
        END ELSE
            R.NEW(SC.SBS.LOCAL.REF)<1,L.CLEAN.PERCENT.POS,INIT.3> = TRIM( (FMT( (Y.TEMP.CL.PR * 100),"18L4")), '',"B")        ;* PACS00247574 - S
            R.NEW(SC.SBS.LOCAL.REF)<1,L.DIRTY.PERCENT.POS,INIT.3> = TRIM( (FMT( (Y.TEMP.DR.PR * 100),"18L4")), '',"B")        ;* PACS00247574 - E
        END
*PACS00056285 - KB - E
*PACS00056285 - E
        R.NEW(SC.SBS.LOCAL.REF)<1,L.DISC.AMOUNT.POS,INIT.3>   = TRIM(Y.DIFF<INIT.3>,'',"B")
        INIT.3 += 1
    REPEAT
RETURN

********
PGM.END:
********

END
