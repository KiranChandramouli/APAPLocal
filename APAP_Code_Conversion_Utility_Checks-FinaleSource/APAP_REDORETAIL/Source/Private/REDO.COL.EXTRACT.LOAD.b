* @ValidationCode : MjozMjc4NDQ0OTQ6VVRGLTg6MTcwMjk5MDk3OTY4NjpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:32:59
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*18-12-2023      Narmadha V        Manual R22 Conversion              AA.ARR.CUSTOMER to AA.PRD.DES.CUSTOMER
SUBROUTINE REDO.COL.EXTRACT.LOAD
* ----------------------------------------------------------------------------
*  REDO COLLECTOR EXTRACT LOAD
*  Service : REDO Collector Extract
*  Allows to initialise variable, files to be used in the extraction process
*
* ----------------------------------------------------------------------------
* Modification Details:
*=====================
* 14/09/2011 - PACS00110378         Leer el registro Bandera de la Cola REDI.MSG.COL.QUEUE
*
* 07/12/2011 - PACS00169639         Use REDO.CUSTOMER.ARRANGEMENT
*
* 05-05-2012 - PACS00195868   Add local field L.CUS.SCO.COB
*
* 15/05/2012   Code Review          Performance review
*                                   hpasquel@temenos.com
* ----------------------------------------------------------------------------

    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.DATES
*
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_REDO.COL.CUSTOMER.COMMON
    $INSERT I_REDO.COL.EXTRACT.CREDIT.COMMON
    $USING APAP.TAM

    GOSUB GET.LOCAL.FIELDS
    GOSUB PROCESS

RETURN

*-------------------------------------------------------------
* Main Process
PROCESS:
*-------------------------------------------------------------
    C.REPORT.PROCESS.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)

    IF NOT(F.LOCKING) THEN
        FN.LOCKING = "F.LOCKING"
        CALL OPF(FN.LOCKING, F.LOCKING)
    END

* Read parameters from definition an kept into COMMON variables
    REDO.INTERFACE.PARAM.ID = "COL001"    ;* Just for COL001 definitions
    R.REDO.INTERFACE.PARAM  = ""
    CALL CACHE.READ('F.REDO.INTERFACE.PARAM',REDO.INTERFACE.PARAM.ID,R.REDO.INTERFACE.PARAM,YERR)
    IF YERR NE "" THEN          ;* It's a critical error, the record was removed SOURCE.INFO<7> = "YES"
        TEXT = yRecordNotFound    ;* "RECORD & WAS NOT DEFINED ON REDO.INTERFACE.PARAM"
        TEXT<2> = REDO.INTERFACE.PARAM.ID : @FM : "F.REDO.INTERFACE.PARAM"
        GOSUB RAISE.ERROR
    END

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.REDO.COL.QUEUE = 'F.REDO.COL.QUEUE'
    F.REDO.COL.QUEUE = ''
    CALL OPF(FN.REDO.COL.QUEUE, F.REDO.COL.QUEUE)

    FN.REDO.COL.EXTRACT.CONTROL = 'F.REDO.COL.EXTRACT.CONTROL'
    F.REDO.COL.EXTRACT.CONTROL = ''
    CALL OPF(FN.REDO.COL.EXTRACT.CONTROL, F.REDO.COL.EXTRACT.CONTROL)

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

*FN.AA.CUSTOMER="F.AA.ARR.CUSTOMER"
    FN.AA.CUSTOMER="F.AA.PRD.DES.CUSTOMER" ;*Manual R22 Conversion
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


* CUSTOMER - from extract init
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

* DE.ADDRESS- from extract init
    Y.CLI.TIPO.DIRECCION.POS = CUS.POS<2,1>
    Y.CLI.APR.POSTAL.POS = CUS.POS<2,2>
    Y.CLI.NO.DIRECCION.POS = CUS.POS<2,3>

    R.REDO.COL.MSG.QUEUE=""
    FN.REDO.COL.MSG.QUEUE='F.REDO.MSG.COL.QUEUE'
    F.REDO.COL.MSG.QUEUE = ''

    CALL OPF(FN.REDO.COL.MSG.QUEUE,F.REDO.COL.MSG.QUEUE)

    GOSUB GET.TABLES.IDS

*<< PACS00169639
* Each time of new process stars, the message on the queue must be erased to avoid duplication
    FILE.NAME = FN.REDO.COL.MSG.QUEUE
    CALL EB.CLEAR.FILE(FILE.NAME, F.REDO.COL.MSG.QUEUE)
*>> PACS00169639

* getting the size for each batch to pass Java Application
    fieldParamType = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    fieldParamValue = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
    paramType = 'AA.PRD.SELECTION'
    GOSUB GET.PARAM.TYPE.VALUE
    AA.PRD.SELECTION = paramValue
    IF AA.PRD.SELECTION EQ '' THEN
        AA.PRD.SELECTION = "COMERCIAL,HIPOTECARIO,CONSUMO"
        CALL OCOMO("Parameter AA.PRD.SELECTION was not def... using default: " : AA.PRD.SELECTION)
    END
    paramType = 'AA.STA.SELECTION'
    GOSUB GET.PARAM.TYPE.VALUE
    AA.STA.SELECTION = paramValue
    IF AA.STA.SELECTION EQ '' THEN
        AA.STA.SELECTION = "CURRENT,AUTH,EXPIRED"
        CALL OCOMO("Parameter AA.STA.SELECTION was not def... using default: " : AA.STA.SELECTION)
    END

    GOSUB BUILD.AA.SEL.CRITERIA

    GOSUB LIST.OF.SEGUROS

RETURN

*** <region name= getParamTypeValue>
*** paramType  (in)  to search
*** paramValue (out) value found
*** valueNo    (out) position of the value
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
*** </region name= getParamTypeValue>
*-----------------------------------------------------------------------------
GET.TABLES.IDS:
*-----------------------------------------------------------------------------


*    NO.REC.CLI=0
*    NO.REC.PHON=0
*    NO.REC.DIR=0
*    NO.REC.MOV=0
*    NO.REC.CRE=0
*    Y.TABLE=""
*    C.TABLES=""
*
*    C.TABLES<-1>='TMPCLIENTES'
*    C.TABLES<-1>='TMPTELEFONOSCLIENTE'
*    C.TABLES<-1>='TMPDIRECCIONESCLIENTE'
*    C.TABLES<-1>='TMPMOVIMIENTOS'
*    C.TABLES<-1>='TMPCREDITO'

* PACS00169639
    GOSUB IS.REPROCESS

    IF Y.ALREADY.PROCESSED THEN
*       Y.PROCESS.FLAG.TABLE = ''
*       LOOP
*           REMOVE Y.TABLE FROM C.TABLES SETTING Y.POS
*       WHILE Y.TABLE
*           NO.REC.SEL = 0
*           GOSUB CHECK.PROCESS.CONTINUE
*           IF NO.REC.SEL GT 0 AND Y.TABLE EQ 'TMPCLIENTES' THEN
*               Y.PROCESS.FLAG.TABLE<1,1>=Y.TABLE
*               NO.REC.CLI = NO.REC.SEL
*           END
*
*           IF NO.REC.SEL GT 0 AND Y.TABLE EQ "TMPTELEFONOSCLIENTE" THEN
*               Y.PROCESS.FLAG.TABLE<1,2>=Y.TABLE
*               NO.REC.PHON = NO.REC.SEL
*           END
*
*           IF NO.REC.SEL GT 0 AND Y.TABLE EQ "TMPDIRECCIONESCLIENTE" THEN
*               Y.PROCESS.FLAG.TABLE<1,3>=Y.TABLE
*               NO.REC.DIR = NO.REC.SEL
*           END
*
*           IF NO.REC.SEL GT 0 AND Y.TABLE EQ "TMPMOVIMIENTOS" THEN
*               Y.PROCESS.FLAG.TABLE<1,4>=Y.TABLE
*               NO.REC.MOV = NO.REC.SEL
*           END
*
*           IF NO.REC.SEL GT 0 AND Y.TABLE EQ "TMPCREDITO" THEN
*               Y.PROCESS.FLAG.TABLE<1,5>=Y.TABLE
*               NO.REC.CRE = NO.REC.SEL
*           END
*       REPEAT
*       CALL OCOMO("PROCESS WAS ALREADY EXECUTED FOR TODAY, JUST PROCESSING:")
*       CALL OCOMO(Y.PROCESS.FLAG.TABLE)
        Y.PROCESS.FLAG.TABLE = ''
*       CALL REDO.R.COL.CHECK.TABLES(Y.PROCESS.FLAG.TABLE)
        APAP.TAM.redoRColCheckTables(Y.PROCESS.FLAG.TABLE) ;*R22 Manual Conversion
        
    END ELSE
        Y.PROCESS.FLAG.TABLE<1>  = "TMPCLIENTES" : @VM : "TMPTELEFONOSCLIENTE" : @VM : "TMPDIRECCIONESCLIENTE"
        Y.PROCESS.FLAG.TABLE<1> := @VM : "TMPMOVIMIENTOS" : @VM : "TMPCREDITO"
    END

RETURN
*-----------------------------------------------------------------------------
* Build Selection criteria to execute the selection over AA.ARRANGEMENT
BUILD.AA.SEL.CRITERIA:
*-----------------------------------------------------------------------------
    C.AA.SELECTION.CRITERIA  = ""
    C.AA.SELECTION.CRITERIA := " PRODUCT.GROUP EQ '" : CHANGE(AA.PRD.SELECTION,",","' '") : "'"
    C.AA.SELECTION.CRITERIA := " AND ARR.STATUS EQ '" : CHANGE(AA.STA.SELECTION,",","' '") : "'"
*<< PACS00169639
    C.AA.PRD.SELECTION = CHANGE(AA.PRD.SELECTION,",",@VM)
    C.AA.STA.SELECTION = CHANGE(AA.STA.SELECTION,",",@VM)
*>> PACS00169639

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
*TUS AA Changes 20161021
*  Y.SELECT.STATEMENT := "'-',3,1]"
    Y.SELECT.STATEMENT := "'-',4,1]"
*TUS END
    Y.SELECT.STATEMENT := "' LE " : C.REPORT.PROCESS.DATE
*    Y.SELECT.STATEMENT := " WITH ID.COMP.1 LIKE 'SEG...'"
*    Y.SELECT.STATEMENT := "  AND ID.COMP.3 LE " : C.REPORT.PROCESS.DATE
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
    LOC.REF.FIELDS<1> := "L.CU.TEL.NO" : @VM : "L.CU.TEL.EXT" : @VM : "L.CU.TIPO.CL" : @VM : "L.CU.TEL.P.CONT"
    LOC.REF.APPL<2>="DE.ADDRESS"
    LOC.REF.FIELDS<2> = "L.DA.TIPO.RES" : @VM : "L.DA.APT.POSTAL" : @VM : "L.DA.NO.DIR"

    LOC.REF.APPL<3>   = "AA.PRD.DES.CUSTOMER"
    LOC.REF.FIELDS<3> = "L.AA.AFF.COM":@VM:"L.AA.CAMP.TY"

    LOC.REF.APPL<4>   = "AA.PRD.DES.TERM.AMOUNT"
    LOC.REF.FIELDS<4> = "L.AA.COL"

    LOC.REF.APPL<5>   = "TRANSACTION"
    LOC.REF.FIELDS<5> = "COL.TXN.CODE"

    CUS.POS = ""
    LOC.REF.POS = ""


    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    CUS.POS<1>=LOC.REF.POS<1>
    CUS.POS<2>=LOC.REF.POS<2>

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
*    CALL OCOMO(TEXT)
    CALL FATAL.ERROR(SOURCE.INFO)
RETURN

**======================
*CHECK.PROCESS.CONTINUE:
**======================
*
*    Y.SELECT.TABLES=""
*    Y.SELECT.TABLES := 'SELECT ':FN.REDO.COL.MSG.QUEUE
*    Y.SELECT.TABLES := ' WITH @ID LIKE ':Y.TABLE:'.':TODAY:'.':ID.COMPANY:"... SAMPLE 1"
*    Y.ERR=''
*    Y.F.REDO.MSG.QUEUE=''
*    Y.LIST.MSG=''
*
*    CALL EB.READLIST(Y.SELECT.TABLES,Y.F.REDO.MSG.QUEUE,Y.LIST.MSG,NO.REC.SEL,Y.ERR)
*
*    RETURN

*-----------------------------------------------------------------------------------------
IS.REPROCESS:
*-----------------------------------------------------------------------------------------

    Y.ALREADY.PROCESSED = @FALSE

* Check if The process was already done
    R.LOCKING = ''
    Y.LOCKING.ID = "REDO.COL.EXTRACT.TRACE." : TODAY
* This entry must exist only if previouly the process was already done successfully
    CALL F.READ(FN.LOCKING, Y.LOCKING.ID, R.LOCKING, F.LOCKING, YERR)

*      READ R.LOCKING FROM F.LOCKING, Y.LOCKING.ID THEN
    IF R.LOCKING THEN
        Y.ALREADY.PROCESSED = @TRUE
        RETURN
    END

* Check if we are re-processing
    R.LOCKING = ''
    Y.LOCKING.ID = "REDO.COL.EXTRACT.ERROR.":TODAY
* This entry must exist only if previouly something was wrong
    CALL F.READ(FN.LOCKING, Y.LOCKING.ID, R.LOCKING, F.LOCKING, YERR)
*      READ R.LOCKING FROM F.LOCKING, Y.LOCKING.ID THEN
    IF R.LOCKING THEN
        Y.ALREADY.PROCESSED = @TRUE
    END
RETURN
*-----------------------------------------------------------------------------------------
END
