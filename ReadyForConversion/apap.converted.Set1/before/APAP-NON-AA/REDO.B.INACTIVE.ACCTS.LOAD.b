*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.INACTIVE.ACCTS.LOAD
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine is used to initialize the variables and open files
*
*
* Developed By          : Nowful Rahman M
*
* Development Reference : 199_CA02
*
* Attached To           : BATCH>BNK/REDO.B.INACTIVE.ACCTS
*
* Attached As           : Batch Routine
*-----------------------------------------------------------------------------------------------------------------
*------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*-----------------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00353060          Ashokkumar.V.P                  07/11/2014           Changes based on mapping.
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT TAM.BP I_REDO.B.INACTIVE.ACCTS.COMMON
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT TAM.BP I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_TSA.COMMON

    GOSUB INITIALIZE
    RETURN
*-----------------------------------------------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------------------------------------------
*Intialise the variables
*Open the neccessary files
*-----------------------------------------------------------------------------------------------------------------
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.EB.CONTRACT.BALANCES = "F.EB.CONTRACT.BALANCES"
    F.EB.CONTRACT.BALANCES =""
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.REDO.AZACC.DESC = "F.REDO.AZACC.DESC"
    F.REDO.AZACC.DESC = ""
    CALL OPF(FN.REDO.AZACC.DESC,F.REDO.AZACC.DESC)

    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'
    F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)

    FN.DR.REG.CA02.WORKFILE = 'F.DR.REG.CA02.WORKFILE'; F.DR.REG.CA02.WORKFILE =''
    CALL OPF(FN.DR.REG.CA02.WORKFILE,F.DR.REG.CA02.WORKFILE)

    L.APAP.INDUSTRY.POS = ''

    Y.APP = "CUSTOMER":FM:"ACCOUNT":FM:"INDUSTRY"
    Y.FIELDS = "L.CU.TIPO.CL":VM:"L.CU.CIDENT":VM:"L.CU.RNC":VM:"L.CU.NOUNICO":VM:"L.CU.ACTANAC":VM:'L.APAP.INDUSTRY':FM:"L.AC.STATUS1":VM:"L.AC.STATUS2":FM:"L.AA.CATEG"
    Y.FIELD.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FIELDS,Y.FIELD.POS)
    L.CU.TIPO.CL.POS = Y.FIELD.POS<1,1>
    L.CU.CIDENT.POS = Y.FIELD.POS<1,2>
    L.CU.RNC.POS = Y.FIELD.POS<1,3>
    Y.NONICO.POS = Y.FIELD.POS<1,4>
    Y.ACTANAC.POS = Y.FIELD.POS<1,5>
    L.APAP.INDUSTRY.POS = Y.FIELD.POS<1,6>
    Y.AC.STATUS.POS1 = Y.FIELD.POS<2,1>
    Y.AC.STATUS.POS2 = Y.FIELD.POS<2,2>
    L.AA.CATEG.POS = Y.FIELD.POS<3,1>
    YLAST.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)

    Y.REPORT.PARAM.ID = "REDO.CA02"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.REPORT.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
        Y.FILE.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
    END ELSE
        GOSUB RAISE.ERR.C.22
    END

    NME.POS = ''
    LOCATE "CATEGORY" IN Y.FIELD.NME.ARR<1,1> SETTING NME.POS THEN
        Y.CAT.VAL.ARR = Y.FIELD.VAL.ARR<1,NME.POS>
        Y.CAT.DIS.ARR = Y.DISP.TEXT.ARR<1,NME.POS>
    END

    Y.CAT.VAL.ARR.GRP = Y.CAT.VAL.ARR
    CHANGE SM TO ' ' IN Y.CAT.VAL.ARR.GRP
    Y.CAT.VAL.ARR = CHANGE(Y.CAT.VAL.ARR,SM,VM)
    Y.CAT.DIS.ARR = CHANGE(Y.CAT.DIS.ARR,SM,VM)

    LOCATE "REM.STATUS" IN Y.FIELD.NME.ARR<1,1> SETTING REM.POS THEN
        Y.RMS.VAL.ARR = Y.FIELD.VAL.ARR<1,REM.POS>
    END
    Y.RMS.VAL.ARR = CHANGE(Y.RMS.VAL.ARR,SM,VM)
    RETURN
*-----------------------------------------------------------------------------------------------------------------
RAISE.ERR.C.22:
*-----------------------------------------------------------------------------------------------------------------
*Handling error process
*-----------------------------------------------------------------------------------------------------------------
    MON.TP = "04"
    Y.ERR.MSG = "Record not found in REDO.H.REPORTS.PARAM"
    REC.CON = "CA02.":Y.REPORT.PARAM.ID:Y.ERR.MSG
    DESC = "CA02.":Y.REPORT.PARAM.ID:Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    RETURN
*------------------------------------------------------------------Final End---------------------------------------------------------------------------
END
