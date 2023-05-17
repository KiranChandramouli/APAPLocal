SUBROUTINE REDO.GET.BILL.DETAILS(Y.BILL.ID,Y.ARRANGE.ID,INS.POLICY.TYPE.POS,Y.BILL.DUE.DATE,Y.TOT.CAPITAL.FEE,Y.TOT.FEE.INTEREST,Y.TOT.DUE.FEE,Y.TOT.CHRG.COMM.FEE,Y.TOT.CHRG.INS.FEE,Y.TOTAL.FEE)
*******************************************************************************
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : G.Sabari
*  ODR Number        : ODR-2010-03-0112
*  Program   Name    : REDO.GET.BILL.DETAILS
*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : Y.OUT.ARRAY
*-----------------------------------------------------------------------------
* DESCRIPTION       : This routine is used to get the Bill details for the
*                     routine REDO.DUE.FEE.LOANS.REPORT
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO         REFERENCE            DESCRIPTION
*  -----           ----        ----------           -----------
*  11-Oct-2010     G.Sabari    ODR-2010-03-0112     INITIAL CREATION
*------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.PROPERTY
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
*
    GOSUB OPENFILES
    GOSUB PROCESS
*
RETURN
*-------------------------------------------------------------------------------------------
OPENFILES:
***********

    FN.AA.BILL.DETAILS   = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS    = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    FN.AA.PROPERTY       = 'F.AA.PROPERTY'
    F.AA.PROPERTY        = ''
    CALL OPF(FN.AA.PROPERTY,F.AA.PROPERTY)

    FN.AA.ARR.CHARGE     = 'F.AA.ARR.CHARGE'
    F.AA.ARR.CHARGE      = ''
    CALL OPF(FN.AA.ARR.CHARGE,F.AA.ARR.CHARGE)

    FN.AA.ARR = 'F.AA.ARRANGEMENT'
    F.AA.ARR = ''
    CALL OPF(FN.AA.ARR,F.AA.ARR)

    FN.PROP.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'
    F.PROP.PARAM = ''
    CALL OPF(FN.PROP.PARAM,F.PROP.PARAM)

    Y.TOT.CAPITAL.FEE  = ''
    Y.TOT.FEE.INTEREST = ''
    Y.TOT.DUE.FEE      = ''
    Y.TOT.CHRG.COMM.FEE = ''
    Y.TOT.CHRG.INS.FEE = ''
    Y.TOTAL.FEE = ''

RETURN
*-------------------------------------------------------------------------------------------
PROCESS:
********

    CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.DET.ERR)
    Y.BILL.DUE.DATE    = R.AA.BILL.DETAILS<AA.BD.PAYMENT.DATE>
    Y.PAY.PROP         = R.AA.BILL.DETAILS<AA.BD.PAY.PROPERTY>
* PACS00321228 - 2014OCT04 - S
    IF Y.ARRANGE.ID EQ "" THEN
        Y.ARRANGE.ID = R.AA.BILL.DETAILS<AA.BD.ARRANGEMENT.ID>
    END
* PACS00321228 - 2014OCT04 - E
    IN.PROPERTY.CLASS = 'ACCOUNT' ; OUT.PROPERTY = '' ; R.OUT.AA.RECORD = '' ; OUT.ERR=''
    CALL REDO.GET.PROPERTY.NAME(Y.ARRANGE.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)

    LOCATE OUT.PROPERTY IN Y.PAY.PROP<1,1,1> SETTING Y.AC.POS THEN
        Y.TOT.CAPITAL.FEE += R.AA.BILL.DETAILS<AA.BD.OS.PR.AMT><1,1,Y.AC.POS>
    END

    PROP.NAME = 'PRINCIPAL' ; OUT.PROP = ''         ;* Interest Property to obtain
    CALL REDO.GET.INTEREST.PROPERTY(Y.ARRANGE.ID,PROP.NAME,OUT.PROP,ERR)
    Y.PRIN.PROP=OUT.PROP        ;* This variable hold the value of principal interest property
    LOCATE Y.PRIN.PROP IN Y.PAY.PROP<1,1,1> SETTING Y.PRIN.POS THEN
        Y.TOT.FEE.INTEREST += R.AA.BILL.DETAILS<AA.BD.OS.PR.AMT><1,1,Y.PRIN.POS>
    END

*----------------   CASE Y.PROP.ID EQ 'APAPB4ARREAR'

    CALL F.READ(FN.AA.ARR,Y.ARRANGE.ID,R.AA.ARR,F.AA.ARR,Y.ARR.ERR)
    Y.PRD.GRP = R.AA.ARR<AA.ARR.PRODUCT.GROUP>
    CALL CACHE.READ(FN.PROP.PARAM,Y.PRD.GRP,R.PROP.PARAM.REC,PROP.PARAM.ERR)
    Y.PEN.ID = R.PROP.PARAM.REC<PROP.PARAM.PENALTY.ARREAR>

    LOCATE Y.PEN.ID IN Y.PAY.PROP<1,1,1> SETTING Y.PAY.PROP.POS THEN
        Y.TOT.DUE.FEE += R.AA.BILL.DETAILS<AA.BD.OS.PR.AMT><1,1,Y.PAY.PROP.POS>
    END

*----------------   CASE Y.PROP.ID EQ 'APAPB4ARREAR'

    Y.CNT              = DCOUNT(Y.PAY.PROP,@SM)
    Y.INIT             = 1
    LOOP
    WHILE Y.INIT LE Y.CNT
        Y.PROP.ID         = R.AA.BILL.DETAILS<AA.BD.PAY.PROPERTY,1,Y.INIT>
        IF Y.PROP.ID NE 'ACCOUNT' AND Y.PROP.ID NE 'PRINCIPALINT' AND Y.PROP.ID NE Y.PEN.ID THEN
            GOSUB GET.AA.CHARGE.DETAILS
        END
        Y.INIT += 1
    REPEAT
    Y.TOTAL.FEE = SUM(Y.TOT.CAPITAL.FEE:@FM:Y.TOT.FEE.INTEREST:@FM:Y.TOT.DUE.FEE:@FM:Y.TOT.CHRG.COMM.FEE:@FM:Y.TOT.CHRG.INS.FEE)
RETURN
*-------------------------------------------------------------------------------------------
GET.AA.CHARGE.DETAILS:
***********************

    CALL CACHE.READ(FN.AA.PROPERTY, Y.PROP.ID, R.AA.PROPERTY, PRO.ERR)
    IF R.AA.PROPERTY<AA.PROP.PROPERTY.CLASS> EQ 'CHARGE' THEN
        Y.TOT.CHRG.COMM.FEE += R.AA.BILL.DETAILS<AA.BD.OS.PR.AMT,1,Y.INIT>
    END
    ArrangementID = Y.ARRANGE.ID ; idPropertyClass = 'CHARGE'; effectiveDate = ''; returnIds = ''; returnConditions ='';returnError = ''; idProperty = Y.PROP.ID
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.CONDITION = RAISE(returnConditions)
    IF R.CONDITION<AA.CHG.LOCAL.REF,INS.POLICY.TYPE.POS> NE '' THEN
        Y.TOT.CHRG.INS.FEE += R.AA.BILL.DETAILS<AA.BD.OS.PR.AMT,1,Y.INIT>
    END

RETURN
END
