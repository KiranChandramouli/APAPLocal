SUBROUTINE REDO.B.ACCT.DET.LOAD
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      : Nirmal.P
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00361294          Ashokkumar.V.P                  14/11/2014           Changes based on mapping.
* PACS00361294          Ashokkumar.V.P                  20/05/2015           Added new fields to display in the report
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.ACCT.DET.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_TSA.COMMON
    $INSERT I_BATCH.FILES

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN

OPEN.PARA:
*---------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.REDO.AZACC.DESC = 'F.REDO.AZACC.DESC'
    F.REDO.AZACC.DESC = ''
    CALL OPF(FN.REDO.AZACC.DESC,F.REDO.AZACC.DESC)

    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'; F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)

    FN.ACCOUNT.CREDIT.INT = 'F.ACCOUNT.CREDIT.INT'; F.ACCOUNT.CREDIT.INT = ''
    CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)

    FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'; F.GROUP.CREDIT.INT = ''
    CALL OPF(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)

    FN.GROUP.DATE = 'F.GROUP.DATE'; F.GROUP.DATE = ''
    CALL OPF(FN.GROUP.DATE,F.GROUP.DATE)

    FN.BASIC.INTEREST = 'F.BASIC.INTEREST'; F.BASIC.INTEREST = ''
    CALL OPF(FN.BASIC.INTEREST,F.BASIC.INTEREST)
    Y.FLAG = 1

RETURN
*-----------------------------------------------------------------
PROCESS.PARA:
*-------------
    GOSUB GET.PARAM.DETAILS
    GOSUB OPEN.TEMP.PATH
    GOSUB GET.MULTI.LOCAL.REF
    PROCESS.POST.RTN = ''
RETURN
*------------------------------------------------------------------
GET.PARAM.DETAILS:
*-----------------
    REDO.H.REPORTS.PARAM.ID = "REDO.RN07"
*
    R.REDO.H.REPORTS.PARAM = ''; REDO.PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
*
    IF REDO.H.REPORTS.PARAM.ID THEN
        FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        FIELD.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        DISPLAY.TEXT = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
        FILENAME1 = FILE.NAME:'L':AGENT.NUMBER:".":SERVER.NAME
        FILENAME2 = FILE.NAME:'E':AGENT.NUMBER:".":SERVER.NAME
        PARAM.FIELD.NAME = CHANGE(FIELD.NAME,@VM,@FM)
    END
    Y.TODAY = R.DATES(EB.DAT.TODAY)
    Y.LAST.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
RETURN

OPEN.TEMP.PATH:
*--------------
    OPENSEQ TEMP.PATH,FILENAME1 TO SEQ1.PTR ELSE
        CREATE SEQ1.PTR ELSE
            ERR.MSG = "Unable to open ":FILE.NAME
            INT.CODE = "R07"
            INT.TYPE = "ONLINE"
            MON.TP = "01"
            REC.CON = "R07-":ERR.MSG
            DESC = "R07-":ERR.MSG
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END
    END
    OPENSEQ TEMP.PATH,FILENAME2 TO SEQ2.PTR ELSE
        CREATE SEQ2.PTR ELSE
            ERR.MSG = "Unable to open ":FILE.NAME
            INT.CODE = "R07"
            INT.TYPE = "ONLINE"
            MON.TP = "01"
            REC.CON = "R07-":ERR.MSG
            DESC = "R07-":ERR.MSG
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END
    END
RETURN
*-------------------------------------------------------------------------------
GET.MULTI.LOCAL.REF:
*------------------
    Y.APPLICATION = 'CUSTOMER':@FM:'ACCOUNT'
    FIELD.NAME = 'L.CU.OVR.SEGM':@VM:'L.CU.SEGMENTO':@VM:'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.FOREIGN':@VM:'L.CU.TIPO.CL':@VM:'L.APAP.INDUSTRY':@FM:'L.AC.STATUS1':@VM:'L.AC.STATUS2'
    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,FIELD.NAME,Y.POS)
    Y.OVR.SEGM.POS = Y.POS<1,1>
    Y.SEGMENTO.POS = Y.POS<1,2>
    L.CU.CIDENT.POS = Y.POS<1,3>
    L.CU.RNC.POS = Y.POS<1,4>
    L.CU.FOREIGN.POS = Y.POS<1,5>
    L.CU.TIPO.CL.POS = Y.POS<1,6>
    L.APAP.INDUSTRY.POS = Y.POS<1,7>
    Y.STATUS1.POS = Y.POS<2,1>
    Y.STATUS2.POS = Y.POS<2,2>
RETURN
*---------------------------------------------------------------------------------------------------
END
