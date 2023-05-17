* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.BCR.REPORT.GEN.LOAD
*-----------------------------------------------------------------------------
* Load routine to setup the common area for the multi-threaded Close of Business
* job TEMPLATE.EOD
* ----------------------------------------------------------------------------
* 2011-08-28 : PACS00060197  - C.22 Integration
*              hpasquel@temenos.com
* 2012-04-17 : PACS00191153  - C.21 Improvementes
*              hpasquel@temenos.com
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.COUNTRY
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.TSA.SERVICE
*

*
    $INSERT I_F.REDO.BCR.REPORT.DATA
    $INSERT I_REDO.B.BCR.REPORT.GEN.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
*-----------------------------------------------------------------------------

* Open Files
    GOSUB OPEN.FILES

* Check preconditions
    GOSUB CHECK.PRE.CONDITIONS
    IF K_PROCESS_FLAG EQ 0 THEN
        RETURN
    END

    GOSUB INITIALISE

RETURN


*-----------------------------------------------------------------------------
CHECK.PRE.CONDITIONS:
*-----------------------------------------------------------------------------

* Check if we have something to process
    K_PROCESS_FLAG = 0
    K.INT.CODE = 'BCR000'     ;* PACS00060197 In COB processing we have to use a generic code for register C.22 log info
    K.INT.TYPE = 'BATCH'      ;* PACS00060197


* verify if the process has to be run for TODAY, just in case of COB process
    Y.BATCH.SERVICE.NAME = 'REDO.BCR.REPORT'
    Y.LEN.D = LEN(Y.BATCH.SERVICE.NAME)
    IF RIGHT(PROCESS.NAME,Y.LEN.D) EQ Y.BATCH.SERVICE.NAME THEN
* << Check if there are record to be process TODAY
        K_PROCESS_FLAG = 0    ;* Common Variable
        Y.LIST = ""
        CALL REDO.R.BCR.REPORT.GEN.LIST.BUILD
        CALL REDO.R.BCR.REPORT.GEN.LIST.GET(Y.LIST)
        IF Y.LIST EQ "" THEN
            RETURN  ;* Process must not continue
        END
* >>
    END ELSE
* << PACS00060197
        K.INT.TYPE = 'ONLINE' ;* PACS00060197
*
        R.TSA.SERVICE = ''
        CALL F.READ(FN.TSA.SERVICE, PROCESS.NAME, R.TSA.SERVICE, F.TSA.SERVICE, Y.ERR)
        IF R.TSA.SERVICE NE '' THEN
            LOCATE "REDO.PARAM.ID" IN R.TSA.SERVICE<TS.TSM.ATTRIBUTE.TYPE,1> SETTING pos THEN
                K.INT.CODE = R.TSA.SERVICE<TS.TSM.ATTRIBUTE.VALUE,pos>
            END ELSE
                K.INT.CODE = 'BCR001'
                CALL OCOMO("Error, REDO.PARAM.ID attribute in TSA>" : PROCESS.NAME : " blank, using " : K.INT.CODE)
            END
        END ELSE
            TEXT = 'Record ' : PROCESS.NAME : " did not found in TSA.SERVICE"
            CALL FATAL.ERROR('REDO.BCR.REPORT.GEN.LOAD')
        END
*
* >>
    END

    K_PROCESS_FLAG=1

RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    LOC.REF.APPL = ''
    LOC.REF.APPL<1>="CUSTOMER"
    LOC.REF.APPL<2>="AA.ARR.OVERDUE"
    LOC.REF.APPL<3>="AA.PRD.DES.PAYMENT.SCHEDULE"
    LOC.REF.FIELDS = ''
    LOC.REF.FIELDS := "L.CU.TIPO.CL":@VM:"L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.TEL.AREA":@VM:"L.CU.TEL.NO":
    LOC.REF.FIELDS := @VM:"L.CU.TEL.TYPE":@VM:"L.CU.TEL.EXT":@VM:"L.CU.URB.ENS.RE":@VM:"L.CU.RES.SECTOR"
    LOC.REF.FIELDS<2> = "L.LOAN.COND":@VM:"L.LOAN.STATUS.1"
    LOC.REF.FIELDS<3> = "L.PAID.BILL.CNT"
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)

    Y.L.CU.TIPO.CL.POS = LOC.REF.POS<1,1>
    Y.L.CU.CIDENT.POS = LOC.REF.POS<1,2>
    Y.L.CU.RNC.POS = LOC.REF.POS<1,3>
    Y.L.CU.TEL.AREA.POS = LOC.REF.POS<1,4>
    Y.L.CU.TEL.NO.POS = LOC.REF.POS<1,5>
    Y.L.CU.TEL.TYPE.POS = LOC.REF.POS<1,6>
    Y.L.CU.TEL.EXT.POS = LOC.REF.POS<1,7>
    Y.L.CU.URB.ENS.RE.POS = LOC.REF.POS<1,8>
    Y.L.CU.RES.SECTOR.POS = LOC.REF.POS<1,9>

*    LOC.REF.APPL="AA.ARR.OVERDUE"
*    LOC.REF.FIELDS="L.LOAN.COND"
*    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.L.LOAN.COND = LOC.REF.POS<2,1>
    POS.L.LOAN.STATUS.1 = LOC.REF.POS<2,2>
    POS.L.PAID.BILL.CNT = LOC.REF.POS<3,1>


RETURN

*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------

    FN.CUSTOMER="F.CUSTOMER"
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.DATA="F.REDO.BCR.REPORT.DATA"
    F.DATA=''
    CALL OPF(FN.DATA,F.DATA)
*CALL EB.CLEAR.FILE(FN.DATA,F.DATA) ;* This line has been commented since the file gets cleared in multi threaded.
* Moved to .SELECT routine.

    FN.TSA.SERVICE = "F.TSA.SERVICE"
    F.TSA.SERVICE  = ''
    CALL OPF(FN.TSA.SERVICE,F.TSA.SERVICE)

    FN.AA="F.AA.ARRANGEMENT"
    F.AA=''
    CALL OPF(FN.AA,F.AA)

    FN.COUNTRY='F.COUNTRY'
    F.COUNTRY=''
    CALL OPF(FN.COUNTRY,F.COUNTRY)

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

    FN.AA.ACTIVITY="F.ACCT.ACTIVITY"
    F.AA.ACTIVITY=''
    CALL OPF(FN.AA.ACTIVITY,F.AA.ACTIVITY)

*      PACS00191153
    FN.AA.ACTIVITY.HISTORY = "F.AA.ACTIVITY.HISTORY"
    F.AA.ACTIVITY.HISTORY  = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.REDO.AA.SCHEDULE = 'F.REDO.AA.SCHEDULE'
    F.REDO.AA.SCHEDULE  = ''
    CALL OPF(FN.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE)

    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY  = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

    FN.AA.REFERENCE.DETAILS = 'F.AA.REFERENCE.DETAILS'
    F.AA.REFERENCE.DETAILS  = ''
    CALL OPF(FN.AA.REFERENCE.DETAILS,F.AA.REFERENCE.DETAILS)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS  = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.ACCOUNT.CLOSED = 'F.ACCOUNT.CLOSED'
    F.ACCOUNT.CLOSED  = ''
    CALL OPF(FN.ACCOUNT.CLOSED,F.ACCOUNT.CLOSED)

    INDATE = TODAY
    SIGN   = '-'
    DISPLACEMENT = '1M'
    CALL CALENDAR.DAY(INDATE,SIGN,DISPLACEMENT)
    Y.LAST.MONTH = DISPLACEMENT[1,6]
RETURN
*-----------------------------------------------------------------------------
END
