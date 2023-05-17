SUBROUTINE REDO.B.M.FX.REPORT.PROG.LOAD
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
* PACS00375391          Ashokkumar.V.P                  16/12/2014           Rewritten the routine based on mapping
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.M.FX.REPORT.PROG.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_TSA.COMMON
    $INSERT I_BATCH.FILES

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN
*-------------------------------------------------------------------------------
OPEN.PARA:
*---------

    FN.FOREX = 'F.FOREX'; F.FOREX = ''
    CALL OPF(FN.FOREX,F.FOREX)

    FN.FOREX.HST = 'F.FOREX$HIS'; F.FOREX.HST = ''
    CALL OPF(FN.FOREX.HST,F.FOREX.HST)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'; F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER.HST = 'F.FUNDS.TRANSFER$HIS';  F.FUNDS.TRANSFER.HST = ''
    CALL OPF(FN.FUNDS.TRANSFER.HST,F.FUNDS.TRANSFER.HST)

    FN.TELLER = 'F.TELLER'; F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TELLER.HST = 'F.TELLER$HIS'; F.TELLER.HST = ''
    CALL OPF(FN.TELLER.HST,F.TELLER.HST)

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'; F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.REDO.FX.CCY.POSN = 'F.REDO.FX.CCY.POSN'; F.REDO.FX.CCY.POSN = ''
    CALL OPF(FN.REDO.FX.CCY.POSN,F.REDO.FX.CCY.POSN)

    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    INT.TYPE = ""
    BAT.NO   = ""
    BAT.TOT  = ""
    INFO.OR  = ""
    INFO.DE  = ""
    ID.PROC  = ""
    EX.USER  = ""
    EX.PC    = ""
    Y.FLAG = 1
RETURN
*--------------------------------------------------------------------------------
PROCESS.PARA:
*------------
    GOSUB GET.PARAM.DETAILS
    GOSUB OPEN.TEMP.PATH
    GOSUB GET.MULTI.LOCAL.REF
RETURN
*-------------------------------------------------------------------------------
GET.PARAM.DETAILS:
*-----------------
    REDO.H.REPORTS.PARAM.ID = BATCH.DETAILS<3,1,1>
*
    R.REDO.H.REPORTS.PARAM = ''; REDO.PARAM.ERR = ''
    CALL CACHE.READ('F.REDO.H.REPORTS.PARAM',REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
*
    IF REDO.H.REPORTS.PARAM.ID THEN
        FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        FIELD.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        DISPLAY.TEXT = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
        FILENAME.DATA = FILE.NAME:".TEMP.":AGENT.NUMBER:".":SERVER.NAME
    END
RETURN
*---------------------------------------------------------------------------------
OPEN.TEMP.PATH:
*--------------
    OPENSEQ TEMP.PATH,FILENAME.DATA TO SEQ.PTR ELSE
        CREATE SEQ.PTR ELSE
            ERR.MSG = "Unable to open ":FILE.NAME
            INT.CODE = "RGN20"
            INT.TYPE = "ONLINE"
            MON.TP = "04"
            REC.CON = "RGN20-":ERR.MSG
            DESC = "RGN20-":ERR.MSG
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END
    END
RETURN
*------------------------------------------------------------------------
GET.MULTI.LOCAL.REF:
*-------------------
    Y.FIELDS = ''; FLD.POS = ''; Y.APPLICATION = ''
    Y.APPLICATION = 'FOREX':@FM:'FUNDS.TRANSFER':@FM:'TELLER'
    Y.FIELDS = 'L.FX.LEGAL.ID':@FM:'L.FT.LEGAL.ID':@FM:'L.TT.LEGAL.ID':@VM:'L.TT.DOC.NUM'
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,Y.FIELDS,FLD.POS)
    L.FX.LEGAL.ID.POS = FLD.POS<1,1>
    L.FT.LEGAL.ID.POS = FLD.POS<2,1>
    L.TT.LEGAL.ID.POS = FLD.POS<3,1>
    L.TT.DOC.NUM.POS = FLD.POS<3,2>
RETURN
*----------------------------------------------------------------------
END
