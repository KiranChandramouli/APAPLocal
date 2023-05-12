* @ValidationCode : MjotNzM5NjU0NTE6Q3AxMjUyOjE2ODMxMDkyOTI4MDQ6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 May 2023 15:51:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
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

*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - INSERT file folder name removed T24.BP, TAM.BP, LAPAP.BP, FM TO @FM, VM TO @VM, SM TO @SM, SESSION.NO TO AGENT.NUMBER
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON                            ;** R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_TSA.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.ACCT.DET.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON     ;** R22 Auto Conversion - End
    $USING APAP.REDOCHNLS

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
    FN.COMP.APP = 'F.COMPANY'; F.COMP.APP = ''
    CALL OPF(FN.COMP.APP,F.COMP.APP)

    FN.DR.REG.RIEN7.WORKFILE = 'F.DR.REG.RIEN7.WORKFILE'; F.DR.REG.RIEN7.WORKFILE = ''
    CALL OPF(FN.DR.REG.RIEN7.WORKFILE,F.DR.REG.RIEN7.WORKFILE)
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
    R.REDO.H.REPORTS.PARAM = ''; REDO.PARAM.ERR = ''; Y.FIELD.NAME= ''; CATEG.LIST = ''; CUR.LIST = ''; CATEGINT.LIST = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
*
    IF REDO.H.REPORTS.PARAM.ID THEN
        FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        FIELD.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        DISPLAY.TEXT = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
        FILENAME1 = FILE.NAME:'L':AGENT.NUMBER:".":SERVER.NAME                       ;** R22 Auto Conversion - SESSION.NO TO AGENT.NUMBER
        FILENAME2 = FILE.NAME:'E':AGENT.NUMBER:".":SERVER.NAME                       ;** R22 Auto Conversion - SESSION.NO TO AGENT.NUMBER
        PARAM.FIELD.NAME = CHANGE(FIELD.NAME,@VM,@FM)
        Y.FIELD.NAME = CHANGE(FIELD.NAME,@VM,@FM)
    END

    LOCATE 'CA.SEL.CODES' IN Y.FIELD.NAME SETTING CA.POS THEN
        CATEG.LIST = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE><1,CA.POS>
        Y.CATEG.LIST = CHANGE(CATEG.LIST,@SM,' ')
        CATEG.LIST = CHANGE(CATEG.LIST,@SM,@FM)
        YL.CATEG = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT><1,CA.POS>
        YL.CATEG = CHANGE(YL.CATEG,@SM,@FM)
    END

    LOCATE 'CUR.SEL.CODES' IN PARAM.FIELD.NAME SETTING CUR.POS THEN
        CUR.LIST = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE><1,CUR.POS>
        CUR.LIST = CHANGE(CUR.LIST,@SM,@FM)
        YL.CURR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT><1,CUR.POS>
        YL.CURR = CHANGE(YL.CURR,@SM,@FM)
    END

    LOCATE 'TASA.CATEGORY' IN PARAM.FIELD.NAME SETTING TCS.POS THEN
        CATEGINT.LIST = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE><1,TCS.POS>
        CATEGINT.LIST = CHANGE(CATEGINT.LIST,@SM,@FM)
    END
    Y.LAST.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YTODAY.DAT = R.DATES(EB.DAT.TODAY)
    Y.TODAY = YTODAY.DAT
    CALL CDT('',Y.TODAY,'-1C')
    IF Y.LAST.DAY[5,2] NE Y.TODAY[5,2] THEN
        COMI = Y.LAST.DAY[1,6]:'01'
        CALL LAST.DAY.OF.THIS.MONTH
        Y.TODAY = COMI
    END

    Y.LNK.TYPE = "REDO.CONSUMO.LOAN*VINCATION"
    CALL F.READ(FN.EB.LOOKUP,Y.LNK.TYPE,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
    Y.LNK.TYP.NAME = R.EB.LOOKUP<EB.LU.DATA.NAME>
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
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
** R22 Manual conversion
*CALL APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
            CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
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
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
** R22 Manual conversion
* CALL APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
            CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END
    END
RETURN
*-------------------------------------------------------------------------------
GET.MULTI.LOCAL.REF:
*------------------
    Y.APPLICATION = 'CUSTOMER':@FM:'ACCOUNT':@FM:'COMPANY'
    FIELD.NAME = 'L.CU.OVR.SEGM':@VM:'L.CU.SEGMENTO':@VM:'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.PASS.NAT':@VM:'L.CU.TIPO.CL':@VM:'L.APAP.INDUSTRY':@VM:'L.TIP.CLI':@VM:'L.LOCALIDAD':@VM:'L.CU.NOUNICO':@VM:'L.CU.ACTANAC':@FM:'L.AC.STATUS1':@VM:'L.AC.STATUS2':@FM:'L.LOCALIDAD'
    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,FIELD.NAME,Y.POS)
    Y.OVR.SEGM.POS = Y.POS<1,1>
    Y.SEGMENTO.POS = Y.POS<1,2>
    L.CU.CIDENT.POS = Y.POS<1,3>
    L.CU.RNC.POS = Y.POS<1,4>
    L.CU.FOREIGN.POS = Y.POS<1,5>
    L.CU.TIPO.CL.POS = Y.POS<1,6>
    L.APAP.INDUSTRY.POS = Y.POS<1,7>
    L.TIP.CLI.POSN = Y.POS<1,8>
    L.CU.LOCAL.POS = Y.POS<1,9>
    L.CU.NOUNICO.POS = Y.POS<1,10>
    L.CU.ACTANAC.POS = Y.POS<1,11>
    Y.STATUS1.POS = Y.POS<2,1>
    Y.STATUS2.POS = Y.POS<2,2>
    LCOMP.LOCALIDAD.POS = Y.POS<3,1>
RETURN
*---------------------------------------------------------------------------------------------------
END
