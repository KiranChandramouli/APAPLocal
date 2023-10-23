$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.COL.FF.EXTRACT.LOAD
**-----------------------------------------------------------------------------
* REDO.COL.FF.EXTRACT.LOAD routine to load the variables
*
*-----------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* performance routine creation for collector issue
*
* -------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     TAM.BP is Removed,VM to @VM
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*---------------------------------------------------------------------------------------	-
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.COL.FF.EXTRACT.PRE.COMMON ;*R22 Auto code conversion
    $INSERT I_REDO.COL.EXTRACT.CREDIT.COMMON
    $INSERT I_L.APAP.COL.CUSTOMER.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB GET.LOCAL.FIELDS
    GOSUB PROCESS.SUB
RETURN

*-----------
INITIALISE:
*-----------
    
    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT =''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    Y.RID.ID = "COL001"
    R.REDO.INTERFACE.PARAM = ''
    CALL CACHE.READ('F.REDO.INTERFACE.PARAM', Y.RID.ID, R.REDO.INTERFACE.PARAM, Y.ERR)
    IF Y.ERR THEN
        TEXT = "ERROR READING REDO.INTERFACE.PARAM - " : Y.ERR
        CALL FATAL.ERROR("REDO.COL.EXTRACT.PRE.LOAD")
    END

    Y.OUT.FILE.PATH=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.AUTO.PATH>
    GOSUB CHECK.FILE.PATH
    Y.OUT.FILE.PATH=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.REJECT.PATH>
    GOSUB CHECK.FILE.PATH
    YPAYMENT.REF = ''; YPAYMENT.REF = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PAYMENT.REF>
    GOSUB GET.AA.CRITERIA
    LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)

    Y.TABLE=""
    C.TABLES=""
    C.TABLES<-1>='tmpclientes'
    C.TABLES<-1>='tmptelefonoscliente'
    C.TABLES<-1>='tmpdireccionesclientebase'
    C.TABLES<-1>='tmpmovimientos'
    C.TABLES<-1>='tmpcredito'
    C.TABLES<-1>="gescreditointegracion"
    C.TABLES<-1>="gestipogarantias"
    C.TABLES<-1>="gesgarantias"
    C.TABLES<-1>="gescreditogarantias"
RETURN

*-----------------------------------------------------------------------------
GET.AA.CRITERIA:
*-----------------------------------------------------------------------------
* Criteria Selection
    fieldParamType  = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    fieldParamValue = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>

    paramType = 'AA.PRD.SELECTION'
    GOSUB GET.PARAM.TYPE.VALUE
    C.AA.PRODUCT.GROUP = paramValue
    IF C.AA.PRODUCT.GROUP EQ '' THEN
        CALL OCOMO("Parameter AA.PRD.SELECTION was not def... using default")
        C.AA.PRODUCT.GROUP = "COMERCIAL,HIPOTECARIO,CONSUMO"
    END
    paramType = 'AA.STA.SELECTION'
    GOSUB GET.PARAM.TYPE.VALUE
    C.AA.STATUS = paramValue
    IF C.AA.STATUS EQ '' THEN
        CALL OCOMO("Parameter AA.STA.SELECTION was not def... using default")
        C.AA.STATUS = "CURRENT,AUTH,EXPIRED"
    END

    C.AA.PRODUCT.GROUP = CHANGE(C.AA.PRODUCT.GROUP,",", @VM)
    C.AA.STATUS = CHANGE(C.AA.STATUS,",", @VM)
*need to change
    C.AA.PRD.SELECTION =C.AA.PRODUCT.GROUP
    C.AA.STA.SELECTION =C.AA.STATUS
RETURN

*-----------------------------------------------------------------------------
GET.PARAM.TYPE.VALUE:
*-----------------------------------------------------------------------------

    valueNo = 0
    paramValue = ""
    LOCATE paramType IN fieldParamType<1,1> SETTING valueNo THEN
        paramValue = fieldParamValue<1, valueNo>
    END ELSE
        valueNo = 0
    END
RETURN
*-----------------------------------------------------------------------------
CHECK.FILE.PATH:
*-----------------------------------------------------------------------------
    OPEN Y.OUT.FILE.PATH TO F.EXTRACT.OUT.FILE.PATH ELSE
        RETURN
    END
RETURN

PROCESS.SUB:
************
    C.REPORT.PROCESS.DATE = TODAY

    IF NOT(F.LOCKING) THEN
        FN.LOCKING = "F.LOCKING"
        CALL OPF(FN.LOCKING, F.LOCKING)
    END

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.AA="F.AA.ARRANGEMENT"
    F.AA=''
    CALL OPF(FN.AA,F.AA)

    FN.AA.DETAILS="F.AA.ACCOUNT.DETAILS"
    F.AA.DETAILS=''
    CALL OPF(FN.AA.DETAILS,F.AA.DETAILS)

    FN.AA.TERM="F.AA.ARR.TERM.AMOUNT"
    F.AA.TERM=''
    CALL OPF(FN.AA.TERM,F.AA.TERM)

    FN.AA.BILL="F.AA.BILL.DETAILS"
    F.AA.BILL=''
    CALL OPF(FN.AA.BILL,F.AA.BILL)

    FN.AA.CUSTOMER="F.AA.ARR.CUSTOMER"
    F.AA.CUSTOMER=''
    CALL OPF(FN.AA.CUSTOMER,F.AA.CUSTOMER)

    FN.AA.SCHEDULE="F.AA.ARR.PAYMENT.SCHEDULE"
    F.AA.SCHEDULE=''
    CALL OPF(FN.AA.SCHEDULE,F.AA.SCHEDULE)

    FN.AA.OVERDUE = "F.AA.ARR.OVERDUE"
    F.AA.OVERDUE = ""
    CALL OPF(FN.AA.OVERDUE ,F.AA.OVERDUE )
*<
    FN.DE.ADDRESS = 'F.DE.ADDRESS'
    F.DE.ADDRESS = ''
    CALL OPF(FN.DE.ADDRESS,F.DE.ADDRESS)
*>

*<< PACS00195868
    FN.DE.ADDRESS$HIS = 'F.DE.ADDRESS$HIS'
    F.DE.ADDRESS$HIS = ''
    CALL OPF(FN.DE.ADDRESS$HIS,F.DE.ADDRESS$HIS)

    FN.REDO.COL.TRACE.PHONE = 'F.REDO.COL.TRACE.PHONE'
    F.REDO.COL.TRACE.PHONE = ''
    CALL OPF(FN.REDO.COL.TRACE.PHONE,F.REDO.COL.TRACE.PHONE)
*>>
    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

    GOSUB OPEN.CREDIT.FILES

*<< PACS00169639
    FN.REDO.CUSTOMER.ARRANGEMENT = 'F.REDO.CUSTOMER.ARRANGEMENT'
    F.REDO.CUSTOMER.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CUSTOMER.ARRANGEMENT, F.REDO.CUSTOMER.ARRANGEMENT)
*>> PACS00169639
    FN.REDO.APAP.PROPERTY.PARAM='F.REDO.APAP.PROPERTY.PARAM'
    F.REDO.APAP.PROPERTY.PARAM =''
    CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)

    FN.AA.REFERENCE.DETAILS='F.AA.REFERENCE.DETAILS'
    F.AA.REFERENCE.DETAILS =''
    CALL OPF(FN.AA.REFERENCE.DETAILS,F.AA.REFERENCE.DETAILS)

    FN.REDO.H.PROVISION.PARAMETER  ='F.REDO.H.PROVISION.PARAMETER'
    F.REDO.H.PROVISION.PARAMETER   =''
    CALL OPF(FN.REDO.H.PROVISION.PARAMETER,F.REDO.H.PROVISION.PARAMETER)

    FN.REDO.H.CUSTOMER.PROVISIONING='F.REDO.H.CUSTOMER.PROVISIONING'
    F.REDO.H.CUSTOMER.PROVISIONING =''
    CALL OPF(FN.REDO.H.CUSTOMER.PROVISIONING,F.REDO.H.CUSTOMER.PROVISIONING)

    FN.REDO.AA.SCHEDULE ='F.REDO.AA.SCHEDULE'
    F.REDO.AA.SCHEDULE  =''
    CALL OPF(FN.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE)

    FN.REDO.CL.LOAN.CUST='F.REDO.CL.LOAN.CUST'
    F.REDO.CL.LOAN.CUST =''
    CALL OPF(FN.REDO.CL.LOAN.CUST,F.REDO.CL.LOAN.CUST)

    FN.COLLATERAL.CODE = 'F.COLLATERAL.CODE'; F.COLLATERAL.CODE = ''
    CALL OPF(FN.COLLATERAL.CODE,F.COLLATERAL.CODE)

    FN.COLLATERAL.TYPE = 'F.COLLATERAL.TYPE'; F.COLLATERAL.TYPE = ''
    CALL OPF(FN.COLLATERAL.TYPE,F.COLLATERAL.TYPE)

    FN.CURRENCY = 'F.CURRENCY'; FV.CURRENCY = ''
    CALL OPF(FN.CURRENCY,FV.CURRENCY)

    FN.CUSTOMER.HST = 'F.CUSTOMER$HIS'
    F.CUSTOMER.HST = ''
    CALL OPF(FN.CUSTOMER.HST, F.CUSTOMER.HST)

    Y.CLI.TIPO.ID.CI.POS = CUS.POS<1,1>
    Y.CLI.TIPO.ID.RCN.POS = CUS.POS<1,2>
    Y.CLI.TIPO.ID.ACTANAC.POS = CUS.POS<1,3>
    Y.CLI.TIPO.ID.NOUNICO.POS = CUS.POS<1,4>
    Y.CLI.CAMPO3.09.POS = CUS.POS<1,5>
    Y.CLI.CAMPO4.09.POS = CUS.POS<1,6>
    Y.CLI.TELF.TYPE.POS = CUS.POS<1,7>
    Y.CLI.TELF.AREA.POS = CUS.POS<1,8>
    Y.CLI.TELF.NO.POS = CUS.POS<1,9>
    Y.CLI.TELF.EXT.POS = CUS.POS<1,10>
    Y.CLI.TIPO.CL.POS = CUS.POS<1,11>
    Y.L.CU.TEL.P.CONT = CUS.POS<1,12>
    Y.L.CU.SCO.COB.POS= CUS.POS<1,13>
    Y.L.CU.TARJ.CR.POS= CUS.POS<1,14>

    Y.CLI.TIPO.DIRECCION.POS = CUS.POS<2,1>
    Y.CLI.APR.POSTAL.POS = CUS.POS<2,2>
    Y.CLI.NO.DIRECCION.POS = CUS.POS<2,3>


    GOSUB GET.TABLES.IDS

*    GOSUB LIST.OF.SEGUROS  SJ ;*R22 interface Unit testing changes

RETURN
*-----------------------------------------------------------------------------
GET.TABLES.IDS:
*-----------------------------------------------------------------------------

    Y.PROCESS.FLAG.TABLE<1>  = "tmpclientes" : @VM : "tmptelefonoscliente" : @VM : "tmpdireccionescliente"
    Y.PROCESS.FLAG.TABLE<1> := @VM : "tmpmovimientos" : @VM : "tmpcredito":@VM:"gescreditointegracion":@VM:"gestipogarantias":@VM:"gesgarantias":@VM:"gescreditogarantias"
RETURN

*-----------------------------------------------------------------------------------------
* Create the list of SEGUROS to report as OTROS
LIST.OF.SEGUROS:
*-----------------------------------------------------------------------------------------
    FN.AA.PRD.DES.CHARGE = 'F.AA.PRD.DES.CHARGE'
    F.AA.PRD.DES.CHARGE = ''
    CALL OPF(FN.AA.PRD.DES.CHARGE,F.AA.PRD.DES.CHARGE)
    Y.SELECT.STATEMENT = ""
* Use @ID criteria instead of fields, performance issue reported
    Y.SELECT.STATEMENT := 'SELECT ':FN.AA.PRD.DES.CHARGE
    Y.SELECT.STATEMENT := " WITH @ID LIKE 'SEG...'"
    Y.SELECT.STATEMENT := " AND EVAL'@ID["
* TUS AA Changes 20161021
*  Y.SELECT.STATEMENT := "'-',3,1]"
    Y.SELECT.STATEMENT := "'-',4,1]"
*TUS END
    Y.SELECT.STATEMENT := "' LE " : C.REPORT.PROCESS.DATE
    Y.F.AA.PRD.DES.CHARGE.LIST = ''
    Y.LIST.NAME = ''
    Y.SELECTED = ''
    Y.SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(Y.SELECT.STATEMENT,Y.F.AA.PRD.DES.CHARGE.LIST,Y.LIST.NAME,Y.SELECTED,Y.SYSTEM.RETURN.CODE)

    C.AA.SEGUROS.CHARGES.LIST = ""
    LOOP
        REMOVE Y.AA.PRD.DES.CHARGE.ID FROM Y.F.AA.PRD.DES.CHARGE.LIST SETTING Y.1.MARK
    WHILE Y.1.MARK : Y.AA.PRD.DES.CHARGE.ID
        IF NOT(Y.AA.PRD.DES.CHARGE.ID["-",1,1] MATCHES "SEGPROPIEDADPR" : @VM : "SEGVIDAPR") THEN
            C.AA.SEGUROS.CHARGES.LIST<-1> = Y.AA.PRD.DES.CHARGE.ID["-",1,1]
        END
    REPEAT

RETURN

*----------------------------------------------------------------------------
* Get Local Fields
GET.LOCAL.FIELDS:
*----------------------------------------------------------------------------
*Customer
    LOC.REF.APPL=""
    LOC.REF.FIELDS = ""
    LOC.REF.APPL<1>="CUSTOMER"
    LOC.REF.FIELDS<1> = "L.CU.CIDENT" : @VM : "L.CU.RNC" : @VM : "L.CU.ACTANAC" : @VM : "L.CU.NOUNICO" : @VM
    LOC.REF.FIELDS<1> := "L.CU.URB.ENS.RE" : @VM : "L.CU.RES.SECTOR" : @VM : "L.CU.TEL.TYPE" : @VM : "L.CU.TEL.AREA" : @VM
    LOC.REF.FIELDS<1> := "L.CU.TEL.NO" : @VM : "L.CU.TEL.EXT" : @VM : "L.CU.TIPO.CL" : @VM : "L.CU.TEL.P.CONT":@VM:"L.CU.SCO.COB":@VM:"L.CU.TARJ.CR"
    LOC.REF.APPL<2>="DE.ADDRESS"
    LOC.REF.FIELDS<2> = "L.DA.TIPO.RES" : @VM : "L.DA.APT.POSTAL" : @VM : "L.DA.NO.DIR"

    LOC.REF.APPL<3>   = "AA.PRD.DES.CUSTOMER"
    LOC.REF.FIELDS<3> = "L.AA.AFF.COM":@VM:"L.AA.CAMP.TY"

    LOC.REF.APPL<4>   = "AA.PRD.DES.TERM.AMOUNT"
    LOC.REF.FIELDS<4> = "L.AA.COL"

    LOC.REF.APPL<5>   = "TRANSACTION"
    LOC.REF.FIELDS<5> = "COL.TXN.CODE"

    LOC.REF.APPL<6>="AA.PRD.DES.PAYMENT.SCHEDULE"
    LOC.REF.FIELDS<6> = "L.PAID.BILL.CNT"

    LOC.REF.APPL<7>="COLLATERAL"
    LOC.REF.FIELDS<7> = "L.COL.GUAR.TYPE":@VM:"L.COL.VAL.DATE":@VM:"L.COL.TOT.VALUA":@VM:"L.COL.PRO.DESC2"

    CUS.POS = ""
    LOC.REF.POS = ""

    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    CUS.POS<1>=LOC.REF.POS<1>
    CUS.POS<2>=LOC.REF.POS<2>
    POS.L.PAID.BILL.CNT = LOC.REF.POS<6,1>

* Local Fields for AA.CUSTOMER
    Y.AA.CUS.L.AA.AFF.COM = LOC.REF.POS<3,1>
    Y.AA.CUS.L.AA.CAMP.TY = LOC.REF.POS<3,2>
    I.VAR = 1
    LOOP WHILE I.VAR LE 2
        IF NOT(LOC.REF.POS<3,I.VAR>) THEN
            TEXT    = yLocalRefFieldNotDef
            TEXT<2> = LOC.REF.FIELDS<3,I.VAR> : @VM : LOC.REF.APPL<3>
            GOSUB RAISE.ERROR
        END
        I.VAR+=1
    REPEAT

* Local Fields for AA.TERM

    Y.AA.TERM.L.AA.COL = LOC.REF.POS<4,1>
    IF NOT(Y.AA.TERM.L.AA.COL) THEN
        TEXT    = yLocalRefFieldNotDef
        TEXT<2> = "L.AA.COL" : @VM : LOC.REF.APPL<4>
        GOSUB RAISE.ERROR
    END

* Local Fields for TRANSACTION

    Y.COL.TXN.CODE.ID = LOC.REF.POS<5,1>
    IF NOT(Y.COL.TXN.CODE.ID) THEN
        TEXT    = yLocalRefFieldNotDef
        TEXT<2> = "COL.TXN.CODE" : @VM : LOC.REF.APPL<5>
        GOSUB RAISE.ERROR
    END

    L.COL.GUAR.TYPE.POSN = LOC.REF.POS<7,1>
    L.COL.VAL.DATE.POSN = LOC.REF.POS<7,2>
    L.COL.TOT.VALUA.POSN = LOC.REF.POS<7,3>
    L.COL.PROP.DESC.POSN = LOC.REF.POS<7,4>

RETURN
*----------------------------------------------------------------------------
OPEN.CREDIT.FILES:
*----------------------------------------------------------------------------
* Open files for I_REDO.COL.EXTRACT.CREDIT.COMMON variables
    F.AA.ACTIVITY.HISTORY = ''
    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    CALL OPF(FN.AA.ACTIVITY.HISTORY, F.AA.ACTIVITY.HISTORY)
*
    F.AA.INTEREST.ACCRUALS = ''
    FN.AA.INTEREST.ACCRUALS = 'F.AA.INTEREST.ACCRUALS'
    CALL OPF(FN.AA.INTEREST.ACCRUALS, F.AA.INTEREST.ACCRUALS)
*
    F.ACCOUNT = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    CALL OPF(FN.ACCOUNT, F.ACCOUNT )
*
    F.EB.CONTRACT.BALANCES = ''
    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    CALL OPF(FN.EB.CONTRACT.BALANCES, F.EB.CONTRACT.BALANCES)
*
    F.COLLATERAL = ''
    FN.COLLATERAL = 'F.COLLATERAL'
    CALL OPF(FN.COLLATERAL, F.COLLATERAL)

    F.ACCOUNT.HST = ''
    FN.ACCOUNT.HST = 'F.ACCOUNT$HIS'
    CALL OPF(FN.ACCOUNT.HST, F.ACCOUNT.HST)

RETURN
*----------------------------------------------------------------------------
RAISE.ERROR:
*----------------------------------------------------------------------------
    SOURCE.INFO = "REDO.COL.EXTRACT.LOAD"
    CALL FATAL.ERROR(SOURCE.INFO)
RETURN
END
