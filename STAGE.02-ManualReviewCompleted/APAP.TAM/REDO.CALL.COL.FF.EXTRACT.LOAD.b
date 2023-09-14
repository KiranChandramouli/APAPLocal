* @ValidationCode : Mjo2OTE0NzgxNTU6Q3AxMjUyOjE2ODEzNzYwOTc2MDY6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 14:24:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE REDO.CALL.COL.FF.EXTRACT.LOAD
** ----------------------------------------------------------------------------
*  REDO COLLECTOR EXTRACT LOAD
*  Service : REDO Collector Extract
*  Allows to initialise variable, files to be used in the extraction process
*
* ----------------------------------------------------------------------------
* Modification Details:
*=====================
* 14/09/2011 - PACS00110378         Leer el registro Bandera de la Cola REDI.MSG.C
*
* Date             Who                   Reference      Description
* 13.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM,  TO I.VAR
* 13.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
*
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_REDO.COL.CUSTOMER.COMMON
    $INSERT I_REDO.COL.EXTRACT.CREDIT.COMMON

    GOSUB GET.LOCAL.FIELDS
    GOSUB PROCESS

RETURN

*-------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------

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

    GOSUB LIST.OF.SEGUROS

RETURN
*-----------------------------------------------------------------------------
GET.TABLES.IDS:
*-----------------------------------------------------------------------------


    Y.PROCESS.FLAG.TABLE<1>  = "tmpclientes" : @VM : "tmptelefonoscliente" : @VM : "tmpdireccionescliente"
    Y.PROCESS.FLAG.TABLE<1> := @VM : "tmpmovimientos" : @VM : "tmpcredito"


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

    CUS.POS = ""
    LOC.REF.POS = ""

    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    CUS.POS<1>=LOC.REF.POS<1>
    CUS.POS<2>=LOC.REF.POS<2>
    POS.L.PAID.BILL.CNT = LOC.REF.POS<6,1>

* Local Fields for AA.CUSTOMER
    Y.AA.CUS.L.AA.AFF.COM = LOC.REF.POS<3,1>
    Y.AA.CUS.L.AA.CAMP.TY = LOC.REF.POS<3,2>
    I.VAR = 1                                        ;** R22 Auto conversion - I TO I.VAR
    LOOP WHILE I.VAR LE 2                            ;** R22 Auto conversion - I TO I.VAR
        IF NOT(LOC.REF.POS<3,I.VAR>) THEN            ;** R22 Auto conversion - I TO I.VAR
            TEXT    = yLocalRefFieldNotDef
            TEXT<2> = LOC.REF.FIELDS<3,I.VAR> : @VM : LOC.REF.APPL<3>        ;** R22 Auto conversion - I TO I.VAR
            GOSUB RAISE.ERROR
        END
        I.VAR+=1               ;** R22 Auto conversion - I TO I.VAR
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

RETURN
*----------------------------------------------------------------------------
RAISE.ERROR:
*----------------------------------------------------------------------------
    SOURCE.INFO = "REDO.COL.EXTRACT.LOAD"
    CALL FATAL.ERROR(SOURCE.INFO)
RETURN

*-----------------------------------------------------------------------------------------
END
