* @ValidationCode : Mjo2NzAwMTI3MTM6Q3AxMjUyOjE2ODQ4MzUyODgxMzg6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:18:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DUE.FEE.LOANS.REPORT(Y.OUT.ARRAY)
******************************************************************************
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : G.Sabari
*  ODR Number        : ODR-2010-03-0112
*  Program   Name    : REDO.DUE.FEE.LOANS.REPORT
*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : Y.OUT.ARRAY
*-----------------------------------------------------------------------------
* DESCRIPTION       : This is a NOFILE enquiry routine to get a report to list
*                     to list due fees loans between dates selected by user
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO           REFERENCE            DESCRIPTION
*  -----           ----          ----------           -----------
*  06-Oct-2010     G.Sabari      ODR-2010-03-0112     INITIAL CREATION
*  25-Oct-2010     Renugadevi B  ODR-2010-03-0112     Changes made as per the requirement
*  04-Dec-2103     Nava V.       PACS00321228       Taking main data source from AA.ARRANGEMENT
*DATE              WHO                REFERENCE                        DESCRIPTION
*23-05-2023      MOHANRAJ R        AUTO R22 CODE CONVERSION           VM TO @VM,FM TO @FM
*23-05-2023      MOHANRAJ R        MANUAL R22 CODE CONVERSION         changed to AA.CUS.CUSTOMER
*-------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.PROPERTY
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.COLLATERAL

    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.OVERDUE

    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB MULTI.LOCAL.REF
    GOSUB LOCATE.PROCESS
RETURN
*-------------------------------------------------------------------------------
INITIALISE:
***********

    FN.CUSTOMER            = 'F.CUSTOMER'
    F.CUSTOMER             = ''
    FN.AA.ACCOUNT.DETAILS  = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS   = ''
    FN.AA.ARR.CUSTOMER     = 'F.AA.ARR.CUSTOMER'
    F.AA.ARR.CUSTOMER      = ''
    FN.AA.ARR.ACCOUNT      = 'F.AA.ARR.ACCOUNT'
    F.AA.ARR.ACCOUNT       = ''
    FN.AA.ARRANGEMENT      = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT       = ''
    FN.AA.ARR.TERM.AMOUNT  = 'F.AA.ARR.TERM.AMOUNT'
    F.AA.ARR.TERM.AMOUNT   = ''
    FN.AA.BILL.DETAILS     = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS      = ''
    FN.AA.PROPERTY         = 'F.AA.PROPERTY'
    F.AA.PROPERTY          = ''
    FN.COLLATERAL          = 'F.COLLATERAL'
    F.COLLATERAL           = ''
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)

* //
    FN.REDO.AA.LOAN.UPD.STATUS = 'F.REDO.AA.LOAN.UPD.STATUS'
    F.REDO.AA.LOAN.UPD.STATUS = ''

    FN.AA.INT.AC = 'F.AA.INTEREST.ACCRUALS'
    F.AA.INT.AC = ''

    FN.AA.ARR.OVR = 'F.AA.ARR.OVERDUE'
    F.AA.ARR.OVR = ''

    Y.ARRANGE.ID = ''
    Y.AA.ID      = ''
    Y.RES.DATE   = ''
* //

    Y.AA.ID.LIST1 = '' ; Y.AA.ID.LIST2 = '' ; Y.AA.ID.LIST3 = '' ; Y.AA.ID.LIST4 = '' ; Y.FROM.DATE   = '' ; Y.TO.DATE     = '' ; Y.AGENCY      = '' ; Y.PRD.TYPE    = '' ; Y.PRD.GRP     = ''
    Y.BILL.DATE   = '' ; Y.TOT.CAP.FEE = '' ; Y.TOT.INT.FEE = '' ; Y.TOT.DUE     = '' ; Y.TOT.COMM    = '' ; Y.TOT.INS     = '' ; Y.TOTAL       = '' ; Y.PRIME.NAME  = '' ; Y.GUARANTEE   = ''
    Y.TOT.CHRG.COMM.FEE = ''

RETURN
*-------------------------------------------------------------------------------
OPENFILES:
**********

    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)
    CALL OPF(FN.AA.ARR.CUSTOMER,F.AA.ARR.CUSTOMER)
    CALL OPF(FN.AA.ARR.ACCOUNT,F.AA.ARR.ACCOUNT)
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)
    CALL OPF(FN.AA.PROPERTY,F.AA.PROPERTY)

* //
    CALL OPF(FN.REDO.AA.LOAN.UPD.STATUS,F.REDO.AA.LOAN.UPD.STATUS)
    CALL OPF(FN.AA.INT.AC,F.AA.INT.AC)
    CALL OPF(FN.AA.ARR.OVR,F.AA.ARR.OVR)
* //

RETURN
*-----------------------------------------------------------------------------
LOCATE.PROCESS:
***************

    LOCATE "BILL.DUE.DATE.FROM" IN D.FIELDS<1> SETTING Y.FRM.POS THEN
        Y.FROM.DATE = D.RANGE.AND.VALUE<Y.FRM.POS>
    END
    LOCATE "BILL.DUE.DATE.TO" IN D.FIELDS<1> SETTING Y.TO.POS THEN
        Y.TO.DATE  = D.RANGE.AND.VALUE<Y.TO.POS>
    END
    IF Y.FROM.DATE GT Y.TO.DATE THEN
        ENQ.ERROR = 'FROM.DATE should be Less than TO.DATE'
        RETURN
    END
    LOCATE "LOAN.ORIGIN.AGENCY" IN D.FIELDS<1> SETTING Y.AGENCY.POS THEN
        Y.AGENCY = D.RANGE.AND.VALUE<Y.AGENCY.POS>
    END
    LOCATE "LOAN.PORTFOLIO.TYP" IN D.FIELDS<1> SETTING Y.PRD.GRP.POS THEN
        Y.PRD.GRP = D.RANGE.AND.VALUE<Y.PRD.GRP.POS>
    END
    LOCATE "PRODUCT.TYPE" IN D.FIELDS<1> SETTING Y.PRD.POS THEN
        Y.PRD.TYPE = D.RANGE.AND.VALUE<Y.PRD.POS>
    END
    LOCATE "GUARANTEE.TYPE" IN D.FIELDS<1> SETTING Y.GRNT.POS THEN
        Y.GUARANTEE = D.RANGE.AND.VALUE<Y.GRNT.POS>
    END
* //
    GOSUB SELECT.TMP.AA.ST
* //
RETURN
*-----------------------------------------------------------------------------
SELECT.TMP.AA.ST:
****************

    NO.RECS = '' ; SEL.LIST = '' ; REC.ERR = ''
* PACS00321228 - 2014OCT04 - S
    SELECT.CMD = 'SELECT ':FN.AA.BILL.DETAILS: ' WITH PAYMENT.DATE GE ' :Y.FROM.DATE: ' AND WITH PAYMENT.DATE LE ' :Y.TO.DATE: ' BY ARRANGEMENT.ID BY PAYMENT.DATE '
* PACS00321228 - 2014OCT04 - E
    CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.RECS,REC.ERR)

    FLG = ''
    LOOP
    WHILE NO.RECS GT 0 DO
        FLG += 1
        GOSUB MAIN.PROCESS
        NO.RECS -= 1
    REPEAT

RETURN

*-----------------------------------------------------------------------------
MAIN.PROCESS:
*************
*
    Y.ERROR.FLAG = ''
* PACS00321228 - 2014OCT04 - S
    Y.BILL.ID = SEL.LIST<FLG>
    GOSUB GET.BILL.DETAILS
    Y.ARRANGE.ID = Y.AA.ID
* PACS00321228 - 2014OCT04 - E
    GOSUB FETCH.AA.DETAILS
    GOSUB FETCH.TERM.DETAILS
*
    IF Y.ERROR.FLAG EQ '' THEN
        GOSUB FETCH.MAIN.DETAILS
    END
*
RETURN
*
*-----------------------------------------------------------------------------
FETCH.AA.DETAILS:
*****************

    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
    Y.PRODUCT.GROUP = R.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    Y.PRODUCT       = R.ARRANGEMENT<AA.ARR.PRODUCT>
    Y.CO.CODE       = R.ARRANGEMENT<AA.ARR.CO.CODE>

    IF Y.PRD.GRP AND Y.PRD.GRP NE Y.PRODUCT.GROUP THEN
        Y.ERROR.FLAG = 1
        RETURN
    END

    IF Y.PRD.TYPE AND Y.PRD.TYPE NE Y.PRODUCT THEN
        Y.ERROR.FLAG = 1
        RETURN
    END

    IF Y.AGENCY AND Y.AGENCY NE Y.CO.CODE THEN
        Y.ERROR.FLAG = 1
        RETURN
    END
RETURN
*-----------------------------------------------------------------------------
FETCH.TERM.DETAILS:
*******************

    IF NOT(Y.GUARANTEE) THEN
        RETURN
    END
    ArrangementID = Y.AA.ID ; idPropertyClass = 'TERM.AMOUNT'; effectiveDate = ''; returnIds = ''; returnConditions =''; returnError = ''; idProperty = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.CONDITION   = RAISE(returnConditions)
    Y.COL.REF     = R.CONDITION<AA.AMT.LOCAL.REF,L.AA.COL.POS>
    R.COLLATERAL = ''
    CALL F.READ(FN.COLLATERAL,Y.COL.REF,R.COLLATERAL,F.COLLATERAL,COLL.ERR)
    Y.GUAR.TYPE   = R.COLLATERAL<COLL.COLLATERAL.CODE>
    IF Y.GUARANTEE NE Y.GUAR.TYPE THEN
        Y.ERROR.FLAG = 1
        RETURN
    END
RETURN

*-----------------------------------------------------------------------------
FETCH.MAIN.DETAILS:
*******************
* PACS00321228 - 2014OCT04 - S
    GOSUB GET.AA.DETAILS
    GOSUB GET.ARR.ACC.DETAILS
    GOSUB GET.ARR.CUS.DETAILS
    GOSUB GET.ARR.CO.DETAILS
    Y.OUT.ARRAY<-1> = Y.LOAN.ORIGIN.AGENCY:"*":Y.PORTFOLIO.TYPE:"*":Y.PRODUCT:"*":Y.LOAN.NUM:"*":Y.PREV.LOAN.NUM:"*":Y.PRIME.NAME:"*":Y.AA.CURR:"*":Y.GUAR.TYPE:"*":Y.BILL.DATE:"*":Y.TOT.CAP.FEE:"*":Y.TOT.INT.FEE:"*":Y.TOT.DUE:"*":Y.TOT.COMM:"*":Y.TOT.INS:"*":Y.TOTAL
* PACS00321228 - 2014OCT04 - E
    Y.PRIME.NAME = ''
    Y.LOAN.ORIGIN.AGENCY = '' ; Y.PORTFOLIO.TYPE = '' ; Y.PRODUCT = '' ; Y.LOAN.NUM = '' ; Y.PREV.LOAN.NUM = '' ; Y.PRIME.NAME  = ''
    Y.AA.CURR  = '' ; Y.GUAR.TYPE = '' ; Y.BILL.DATE  = '' ; Y.TOT.CAP.FEE = '' ; Y.TOT.INT.FEE = '' ; Y.TOT.DUE  = '' ; Y.TOT.COMM = ''
    Y.TOT.INS = '' ; Y.TOTAL = ''
*
RETURN
*-----------------------------------------------------------------------------
GET.BILL.DETAILS:
******************

    Y.BILL.DUE.DATE    = '' ; Y.TOT.CAPITAL.FEE = '' ; Y.TOT.FEE.INTEREST = '' ; Y.TOT.DUE.FEE = '' ; Y.TOT.CHRG.COMM.FEE = ''
    Y.TOT.CHRG.INS.FEE = '' ; Y.TOTAL.FEE = '' ; Y.AA.ID = '' ;* PACS00321228 - VNL - 20150817 - S/E
*
    CALL REDO.GET.BILL.DETAILS(Y.BILL.ID,Y.AA.ID,INS.POLICY.TYPE.POS,Y.BILL.DUE.DATE,Y.TOT.CAPITAL.FEE,Y.TOT.FEE.INTEREST,Y.TOT.DUE.FEE,Y.TOT.CHRG.COMM.FEE,Y.TOT.CHRG.INS.FEE,Y.TOTAL.FEE)
* PACS00321228 - 2014OCT04 - S
    Y.BILL.DATE   = Y.BILL.DUE.DATE
    Y.TOT.CAP.FEE = Y.TOT.CAPITAL.FEE
    Y.TOT.INT.FEE = Y.TOT.FEE.INTEREST
    Y.TOT.DUE     = Y.TOT.DUE.FEE
    Y.TOT.COMM    = Y.TOT.CHRG.COMM.FEE
    Y.TOT.INS     = Y.TOT.CHRG.INS.FEE
    Y.TOTAL       = Y.TOTAL.FEE
* PACS00321228 - 2014OCT04 - E
RETURN
*-----------------------------------------------------------------------------
GET.AA.DETAILS:
***************

    CALL F.READ(FN.AA.ARRANGEMENT,Y.ARRANGE.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARRNG.ERR)
    Y.LOAN.NUM           = Y.ARRANGE.ID
    Y.PORTFOLIO.TYPE     = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    Y.PRODUCT            = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    Y.ARR.CUST           = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    Y.AA.CURR            = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
    Y.LOAN.ORIGIN.AGENCY = R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
RETURN
*-----------------------------------------------------------------------------
GET.ARR.ACC.DETAILS:
********************

    ArrangementID        = Y.ARRANGE.ID ; idPropertyClass = 'ACCOUNT'; effectiveDate = ''; returnIds = ''; returnConditions =''; returnError = ''; idProperty = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.CONDITION          = RAISE(returnConditions)
    Y.PREV.LOAN.NUM      = R.CONDITION<AA.AC.ALT.ID>
RETURN
*-----------------------------------------------------------------------------
GET.ARR.CUS.DETAILS:
********************

    ArrangementID   = Y.ARRANGE.ID ; idPropertyClass = 'CUSTOMER'; effectiveDate = ''; returnIds = ''; returnConditions = ''; returnError = '' ; idProperty = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.CONDITION     = RAISE(returnConditions)
    Y.PRIM.CUST     = R.CONDITION<AA.CUS.CUSTOMER>  ;*R22 Manual Conversion - changed to AA.CUS.CUSTOMER
    Y.OWNER.CUST    = R.CONDITION<AA.CUS.CUSTOMER>  ;*R22 Manual Conversion - changed to AA.CUS.CUSTOMER
    GOSUB SAMPLE.CUS.DETAILS
RETURN
*-----------------------------------------------------------------------------
SAMPLE.CUS.DETAILS:
*******************
    Y.PRIM = ''
    LOOP
        REMOVE Y.CUS.ID FROM Y.OWNER.CUST SETTING CUS1.POS
    WHILE Y.CUS.ID:CUS1.POS
        IF Y.PRIM.CUST EQ Y.CUS.ID THEN
        END ELSE
            Y.PRIM<-1> = Y.CUS.ID
        END
    REPEAT
    Y.PRIM.CUST<-1> = Y.PRIM
    LOOP
        REMOVE Y.PRIM.ID FROM Y.PRIM.CUST SETTING CUS2.POS
    WHILE Y.PRIM.ID:CUS2.POS
        CALL F.READ(FN.CUSTOMER,Y.PRIM.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
        Y.PRIME.NAME<-1> = R.CUSTOMER<EB.CUS.SHORT.NAME>
    REPEAT
    CHANGE @FM TO @VM IN Y.PRIME.NAME
RETURN

*-----------------------------------------------------------------------------
GET.ARR.CO.DETAILS:
*******************
    R.COLLATERAL = ''
    ArrangementID = Y.ARRANGE.ID ; idPropertyClass = 'TERM.AMOUNT'; effectiveDate = ''; returnIds = ''; returnConditions = ''; returnError = '' ; idProperty = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.CONDITION   = RAISE(returnConditions)
    Y.COL.REF     = R.CONDITION<AA.AMT.LOCAL.REF,L.AA.COL.POS>
    CALL F.READ(FN.COLLATERAL,Y.COL.REF,R.COLLATERAL,F.COLLATERAL,COLL.ERR)
    Y.GUAR.TYPE   = R.COLLATERAL<COLL.COLLATERAL.CODE>
    IF Y.GUAR.TYPE EQ "" THEN
        Y.GUAR.TYPE = "Sin garantia"
    END
RETURN
*-----------------------------------------------------------------------------
MULTI.LOCAL.REF:
****************
    APPL.ARRAY           = 'AA.ARR.ACCOUNT':@FM:'AA.ARR.TERM.AMOUNT':@FM:'AA.ARR.CHARGE' :@FM: 'AA.PRD.DES.OVERDUE'
    FLD.ARRAY            = 'L.AA.AGNCY.CODE':@FM:'L.AA.COL':@FM:'INS.POLICY.TYPE' :@FM: 'L.LOAN.STATUS.1'
    FLD.POS              = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    L.AA.AGNCY.CODE.POS  = FLD.POS<1,1>
    L.AA.COL.POS         = FLD.POS<2,1>
    INS.POLICY.TYPE.POS  = FLD.POS<3,1>
RETURN
END
