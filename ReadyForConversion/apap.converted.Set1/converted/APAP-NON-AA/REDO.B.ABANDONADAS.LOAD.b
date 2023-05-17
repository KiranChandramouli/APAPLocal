SUBROUTINE REDO.B.ABANDONADAS.LOAD
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
* Description: This is a .LOAD Subroutine
*
*-------------------------------------------------------------------------------
* Modification History
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00392015          Ashokkumar.V.P                  19/11/2014           Changes based on mapping.
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.ABANDONADAS.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_TSA.COMMON
    $INSERT I_BATCH.FILES

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*-------------------------------------------------------------------------------
OPEN.PARA:
*---------
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.REDO.AZACC.DESC = 'F.REDO.AZACC.DESC'
    F.REDO.AZACC.DESC = ''
    CALL OPF(FN.REDO.AZACC.DESC,F.REDO.AZACC.DESC)

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'
    F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)
RETURN

PROCESS.PARA:
*------------
    GOSUB GET.PARAM.DETAILS
    GOSUB OPEN.TEMP.PATH
    GOSUB GET.MULTI.LOCAL.REF
    PROCESS.POST.RTN = ''
RETURN

GET.PARAM.DETAILS:
*-----------------
    REDO.H.REPORTS.PARAM.ID = "REDO.ABAN"
*
    R.REDO.H.REPORTS.PARAM = ''; REDO.PARAM.ERR = ''; DATEFQ.POS = ''; DATE.POS = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
*
    IF REDO.H.REPORTS.PARAM.ID THEN
        FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        FIELD.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        DISPLAY.TEXT = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
        FILENAME = FILE.NAME:".TEMP.":AGENT.NUMBER:".":SERVER.NAME
    END

    Y.FIELD.NAME = CHANGE(FIELD.NAME,@VM,@FM)
    LOCATE 'CUTOFF.DATE' IN Y.FIELD.NAME SETTING DATE.POS THEN
        Y.PR.DATE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE><1,DATE.POS>
    END

    LOCATE 'DATA.FREQUENCY' IN Y.FIELD.NAME SETTING DATEFQ.POS THEN
        Y.MONTHS = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE><1,DATEFQ.POS>
    END

    SIGN = '-'
    Y.MONTHS = '6M'
    YMTH.LEN = LEN(Y.MONTHS)
    YMTH.LEN -= 1
    YTEMP.MTH = Y.MONTHS[1,YMTH.LEN] - 1
    YTEMP.MTH = FMT(YTEMP.MTH,"R%2")
    YMTH = Y.PR.DATE[5,2] - YTEMP.MTH
    YMTH = FMT(YMTH,"R%2")
    YSTART.DATE = Y.PR.DATE[1,4]:YMTH:'01'
RETURN

OPEN.TEMP.PATH:
*--------------
    OPENSEQ TEMP.PATH,FILENAME TO SEQ.PTR ELSE
        CREATE Y.FILE.NAME ELSE
            ERR.MSG = "Unable to open ":FILE.NAME
            INT.CODE = "ABAN"
            INT.TYPE = "ONLINE"
            MON.TP = "03"
            REC.CON = "ABAN-":ERR.MSG
            DESC = "ABAN-":ERR.MSG
            ORIGIN.TYPE = ""; DEST.TYPE = ""; RECORD.ID = ""
            USER = ""; MACHINE = ""
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END
    END
RETURN
*--------------------------------------------------------------------------
GET.MULTI.LOCAL.REF:
*-------------------
    Y.POS = ''
    Y.APPLICATION = 'CUSTOMER':@FM:'EB.LOOKUP':@FM:'ACCOUNT'
    Y.FIELDS = 'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.FOREIGN':@VM
    Y.FIELDS := 'L.CU.TIPO.CL':@VM:'L.CU.TEL.TYPE':@VM:'L.CU.TEL.AREA':@VM
    Y.FIELDS := 'L.CU.TEL.NO':@VM:'L.CU.TEL.EXT':@VM:'L.CU.NOUNICO':@VM:'L.CU.ACTANAC':@FM:'L.AC.MONTHS':@FM:'L.AC.STATUS1':@FM:'L.AC.STATUS2'
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELDS,Y.POS)
    L.CU.CIDENT.POS = Y.POS<1,1>
    L.CU.RNC.POS = Y.POS<1,2>
    L.CU.FOREIGN.POS = Y.POS<1,3>
    L.CU.TIPO.CL.POS = Y.POS<1,4>
    Y.TEL.TYPE.POS = Y.POS<1,5>
    Y.TEL.AREA.POS = Y.POS<1,6>
    Y.TEL.NO.POS = Y.POS<1,7>
    Y.TEL.EXT.POS = Y.POS<1,8>
    L.CU.NOUNICO.POS = Y.POS<1,9>
    L.CU.ACTANAC.POS = Y.POS<1,10>
    Y.AC.MONTHS.POS = Y.POS<2,1>
    Y.AC.STATUS.POS = Y.POS<3,1>
    Y.AC.STATUS2.POS = Y.POS<3,2>
RETURN
END
