* @ValidationCode : Mjo5OTMxNTQ5OTI6Q3AxMjUyOjE2ODIzMzE1NjUxMTI6SVRTUzotMTotMTo4NzE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 871
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
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

*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM, SESSION.NO TO AGENT.NUMBER, $INCLUDE TAM.BP TO $INSERT, INSERT file folder name removed T24.BP, TAM.BP, LAPAP.BP
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON                              ;** R22 Auto conversion - T24.BP REMOVED
    $INSERT I_EQUATE                              ;** R22 Auto conversion - T24.BP REMOVED
    $INSERT I_F.REDO.H.REPORTS.PARAM              ;** R22 Auto conversion - TAM.BP REMOVED
    $INSERT I_REDO.B.ABANDONADAS.COMMON           ;** R22 Auto conversion - LAPAP.BP REMOVED
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON       ;** R22 Auto conversion - $INCLUDE TAM.BP TO $INSERT
    $INSERT I_TSA.COMMON                          ;** R22 Auto conversion - T24.BP REMOVED
    $INSERT I_BATCH.FILES                         ;** R22 Auto conversion - T24.BP REMOVED

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

    FN.DR.REG.ABANDON.WORKFILE = 'F.DR.REG.ABANDON.WORKFILE'
    F.DR.REG.ABANDON.WORKFILE = ''
    CALL OPF(FN.DR.REG.ABANDON.WORKFILE,F.DR.REG.ABANDON.WORKFILE)
RETURN

PROCESS.PARA:
*------------
    GOSUB GET.PARAM.DETAILS
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
        FILENAME = FILE.NAME:".TEMP.":AGENT.NUMBER:".":SERVER.NAME                   ;** R22 Auto conversion - SESSION.NO TO AGENT.NUMBER
    END

    Y.FIELD.NAME = CHANGE(FIELD.NAME,@VM,@FM)
    LOCATE 'CUTOFF.DATE' IN Y.FIELD.NAME SETTING DATE.POS THEN
        Y.PR.DATE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE><1,DATE.POS>
    END

    LOCATE 'DATA.FREQUENCY' IN Y.FIELD.NAME SETTING DATEFQ.POS THEN
        Y.MONTHS = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE><1,DATEFQ.POS>
    END

    LOCATE "CUENTA.CAPITAL" IN Y.FIELD.NAME SETTING CCAP.POS THEN
        Y.CCAP.VAL.ARR = FIELD.VALUE<1,CCAP.POS>
    END

    LOCATE "CUENTA.INTEREST" IN Y.FIELD.NAME SETTING CINT.POS THEN
        Y.CINT.VAL.ARR = FIELD.VALUE<1,CINT.POS>
    END

    SIGN = '-'
    IF NOT(Y.MONTHS) THEN
        Y.MONTHS = '6M'
    END
    YMNTH = Y.MONTHS
    CALL CALENDAR.DAY(Y.PR.DATE,SIGN,YMNTH)
    YSTART.DATE = YMNTH
RETURN
*--------------------------------------------------------------------------
GET.MULTI.LOCAL.REF:
*-------------------
    Y.POS = ''
    Y.APPLICATION = 'CUSTOMER':@FM:'EB.LOOKUP':@FM:'ACCOUNT'
    Y.FIELDS = 'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.PASS.NAT':@VM
    Y.FIELDS := 'L.CU.TIPO.CL':@VM:'L.CU.TEL.TYPE':@VM:'L.CU.TEL.AREA':@VM
    Y.FIELDS := 'L.CU.TEL.NO':@VM:'L.CU.TEL.EXT':@VM:'L.CU.NOUNICO':@VM:'L.CU.ACTANAC':@FM:'L.AC.MONTHS':@FM:'L.AC.STATUS1':@VM:'L.AC.STATUS2':@VM:'L.INV.FACILITY'
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
    L.INV.FACILITY.POS = Y.POS<3,3>
RETURN
END
