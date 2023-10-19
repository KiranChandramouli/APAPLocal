* @ValidationCode : MjoyMDE3NzQxNjE0OkNwMTI1MjoxNjgxMzc2MDk3Nzk4OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
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


SUBROUTINE REDO.GL.W.EXTRACT.ONLINE.RUN
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.GL.W.EXTRACT.ONLINE.RUN
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.GL.W.EXTRACT.ONLINE.RUN is an .RUN routine of the template,
*                    this routine inturn calls the GIT routines to create extracts/reports
*Linked With       : Template REDO.GL.W.EXTRACT.ONLINE
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.GL.H.EXTRACT.PARAMETER      As              I               Mode
*                    RE.STAT.REP.LINE                 As              I               Mode
*                    REDO.INTRF.REP.LINE              As              I               Mode
*                    ENQUIRY.REPORT                   As              I               Mode
*                    REDO.GL.L.RERUN.EXTN             As              I-O             Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------

* 22 Oct 2010       Shiva Prasad Y       ODR-2009-12-0294 C.12         Initial Creation
* 03 Jun 2011       Pradeep S            PACS00072689                  Changes in creating Enquiry report for both GL & PL
*                                                                      R.NEW saved in tem var, before calling enquiry report run
* 26 JUN 2011       Prabhu N             PACS00071961                  Back Up written process added and C22 added
* 20-12-2011        SHANKAR RAJU         PACS00169428 & PACS00169423   Deletion of Detail record
* 13.04.2023       Conversion Tool       R22                           Auto Conversion     - FM TO @FM, VM TO @VM, F TO CACHE
* 13.04.2023       Shanmugapriya M       R22                           Manual Conversion   - Add call routine prefix
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_F.GIT.TRANSPORT.FILE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
    $INSERT I_F.REDO.GL.W.EXTRACT.ONLINE
    $INSERT I_F.REDO.CAPL.L.RE.STAT.LINE.CONT
    $INSERT I_GIT.COMMON
    $INSERT I_F.ENQUIRY.REPORT
    $INSERT I_F.CURRENCY
    $INSERT I_F.COMPANY
    $INSERT I_F.RE.TXN.CODE
    $INSERT I_F.MNEMONIC.COMPANY
    $INSERT I_F.REDO.GL.L.RERUN.EXTN
    $INSERT I_GIT.ONLINE.VAR
    $INSERT I_REDO.B.SAP.VAL.COMMON
    $USING APAP.REDOCHNLS
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB OPEN.PARA
    GOSUB GET.MULTI.LOCAL.REF
    GOSUB GET.COMPANY.DETAILS
    GOSUB GET.RE.TXN
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

    FN.GIT.TRANSPORT.FILE = 'F.GIT.TRANSPORT.FILE'
    F.GIT.TRANSPORT.FILE  = ''
    CALL OPF(FN.GIT.TRANSPORT.FILE,F.GIT.TRANSPORT.FILE)

    FN.REDO.GL.H.EXTRACT.PARAMETER = 'F.REDO.GL.H.EXTRACT.PARAMETER'
    F.REDO.GL.H.EXTRACT.PARAMETER  = ''
    CALL OPF(FN.REDO.GL.H.EXTRACT.PARAMETER,F.REDO.GL.H.EXTRACT.PARAMETER)

    FN.REDO.CAPL.L.RE.STAT.LINE.CONT = 'F.REDO.CAPL.L.RE.STAT.LINE.CONT'
    F.REDO.CAPL.L.RE.STAT.LINE.CONT = ''
    CALL OPF(FN.REDO.CAPL.L.RE.STAT.LINE.CONT,F.REDO.CAPL.L.RE.STAT.LINE.CONT)

    FN.ENQUIRY.REPORT = 'F.ENQUIRY.REPORT'
    F.ENQUIRY.REPORT = ''
    CALL OPF(FN.ENQUIRY.REPORT,F.ENQUIRY.REPORT)

    FN.REDO.GL.L.RERUN.EXTN = 'F.REDO.GL.L.RERUN.EXTN'
    F.REDO.GL.L.RERUN.EXTN = ''
    CALL OPF(FN.REDO.GL.L.RERUN.EXTN,F.REDO.GL.L.RERUN.EXTN)

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

    FN.REDO.CCY.DAILY.RATES = 'F.REDO.CCY.DAILY.RATES'
    F.REDO.CCY.DAILY.RATES = ''
    CALL OPF(FN.REDO.CCY.DAILY.RATES,F.REDO.CCY.DAILY.RATES)

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)


    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CATEG.ENTRY = 'F.CATEG.ENTRY'
    F.CATEG.ENTRY = ''
    CALL OPF(FN.CATEG.ENTRY,F.CATEG.ENTRY)

    FN.RE.CONSOL.SPEC.ENTRY = 'F.RE.CONSOL.SPEC.ENTRY'
    F.RE.CONSOL.SPEC.ENTRY = ''
    CALL OPF(FN.RE.CONSOL.SPEC.ENTRY,F.RE.CONSOL.SPEC.ENTRY)

    FN.MNEMONIC.COMPANY = 'F.MNEMONIC.COMPANY'
    F.MNEMONIC.COMPANY = ''
    CALL OPF(FN.MNEMONIC.COMPANY,F.MNEMONIC.COMPANY)

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FN.RE.TXN.CODE = 'F.RE.TXN.CODE'
    F.RE.TXN.CODE = ''
    CALL OPF(FN.RE.TXN.CODE,F.RE.TXN.CODE)

    FN.STMT.ENTRY.DETAIL.XREF = 'F.STMT.ENTRY.DETAIL.XREF'
    F.STMT.ENTRY.DETAIL.XREF = ''
    CALL OPF(FN.STMT.ENTRY.DETAIL.XREF,F.STMT.ENTRY.DETAIL.XREF)

    FN.CATEG.ENTRY.DETAIL.XREF = 'F.CATEG.ENTRY.DETAIL.XREF'
    F.CATEG.ENTRY.DETAIL.XREF = ''
    CALL OPF(FN.CATEG.ENTRY.DETAIL.XREF,F.CATEG.ENTRY.DETAIL.XREF)

    FN.RE.SPEC.ENTRY.XREF = 'F.RE.SPEC.ENTRY.XREF'
    F.RE.SPEC.ENTRY.XREF = ''
    CALL OPF(FN.RE.SPEC.ENTRY.XREF,F.RE.SPEC.ENTRY.XREF)


    FN.STMT.ENTRY.DETAIL = 'F.STMT.ENTRY.DETAIL'
    F.STMT.ENTRY.DETAIL = ''
    CALL OPF(FN.STMT.ENTRY.DETAIL,F.STMT.ENTRY.DETAIL)

    FN.CATEG.ENTRY.DETAIL = 'F.CATEG.ENTRY.DETAIL'
    F.CATEG.ENTRY.DETAIL = ''
    CALL OPF(FN.CATEG.ENTRY.DETAIL,F.CATEG.ENTRY.DETAIL)

    FN.RE.SPEC.ENTRY.DETAIL = 'F.RE.SPEC.ENTRY.DETAIL'
    F.RE.SPEC.ENTRY.DETAIL = ''
    CALL OPF(FN.RE.SPEC.ENTRY.DETAIL,F.RE.SPEC.ENTRY.DETAIL)


    FN.REDO.GL.H.EXTRACT.PARAMETER = 'F.REDO.GL.H.EXTRACT.PARAMETER'
    F.REDO.GL.H.EXTRACT.PARAMETER = ''
    CALL OPF(FN.REDO.GL.H.EXTRACT.PARAMETER,F.REDO.GL.H.EXTRACT.PARAMETER)

    FN.REDO.GL.W.EXTRACT.ONLINE = 'F.REDO.GL.W.EXTRACT.ONLINE'
    F.REDO.GL.W.EXTRACT.ONLINE = ''
    CALL OPF(FN.REDO.GL.W.EXTRACT.ONLINE,F.REDO.GL.W.EXTRACT.ONLINE)

    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'
    F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)

    FN.RE.CONSOL.STMT.ENT.KEY = 'F.RE.CONSOL.STMT.ENT.KEY'
    F.RE.CONSOL.STMT.ENT.KEY = ''
    CALL OPF(FN.RE.CONSOL.STMT.ENT.KEY,F.RE.CONSOL.STMT.ENT.KEY)

    FN.RE.CONSOL.SPEC.ENT.KEY = 'F.RE.CONSOL.SPEC.ENT.KEY'
    F.RE.CONSOL.SPEC.ENT.KEY = ''
    CALL OPF(FN.RE.CONSOL.SPEC.ENT.KEY,F.RE.CONSOL.SPEC.ENT.KEY)

    FN.RE.CONSOL.PROFIT = 'F.RE.CONSOL.PROFIT'
    F.RE.CONSOL.PROFIT = ''
    CALL OPF(FN.RE.CONSOL.PROFIT,F.RE.CONSOL.PROFIT)

    FN.RE.STAT.LINE.CONT = 'F.REDO.CAPL.L.RE.STAT.LINE.CONT'
    F.RE.STAT.LINE.CONT  = ''
    CALL OPF(FN.RE.STAT.LINE.CONT,F.RE.STAT.LINE.CONT)

    FN.REDO.INTRF.REP.LINE = 'F.REDO.INTRF.REP.LINE'
    F.REDO.INTRF.REP.LINE = ''
    CALL OPF(FN.REDO.INTRF.REP.LINE,F.REDO.INTRF.REP.LINE)

    FN.RE.STAT.LINE.BAL = 'F.RE.STAT.LINE.BAL'
    F.RE.STAT.LINE.BAL = ''
    CALL OPF(FN.RE.STAT.LINE.BAL,F.RE.STAT.LINE.BAL)

    FN.REDO.CCY.DAILY.RATES='F.REDO.CCY.DAILY.RATES'
    F.REDO.CCY.DAILY.RATES=''
    CALL OPF(FN.REDO.CCY.DAILY.RATES,F.REDO.CCY.DAILY.RATES)

    Y.SAP.COST.CENTER.LIST=''
    Y.SPEC.TXN.DESC.LIST=''
    Y.COMPANY.LIST=''
RETURN
*********************
GET.MULTI.LOCAL.REF:
*********************
    LF.APP = 'COMPANY':@FM:'CUSTOMER'
    LF.FLD = 'L.CO.EXT.GL.CC':@FM:'L.CU.TIPO.CL':@VM:'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.ACTANAC':@VM:'L.CU.NOUNICO'
    LF.POS = ''
    CALL MULTI.GET.LOC.REF(LF.APP,LF.FLD,LF.POS)
    LOC.EXT.GL.CC.POS = LF.POS<1,1>
    LOC.CU.TIPO.CL = LF.POS<2,1>
    LOC.CU.CIDENT = LF.POS<2,2>
    LOC.CU.RNC = LF.POS<2,3>
    LOC.CU.ACTANAC = LF.POS<2,4>
    LOC.CU.NOUNICO = LF.POS<2,5>
RETURN
********************
GET.COMPANY.DETAILS:
********************

    SEL.CMD.MNE = 'SELECT ': FN.MNEMONIC.COMPANY
    CALL EB.READLIST(SEL.CMD.MNE,Y.COMPANY.MNE.LIST,'',NO.OF.REC.MNE,SEL.ERR)

    LOOP
        REMOVE Y.COMPANY.MNE.ID FROM Y.COMPANY.MNE.LIST SETTING Y.COMPANY.MNE.POS
    WHILE Y.COMPANY.MNE.ID:Y.COMPANY.MNE.POS
        CALL CACHE.READ(FN.MNEMONIC.COMPANY, Y.COMPANY.MNE.ID, R.MNEMONIC.COMPANY, ERR)       ;** R22 Auto conversion - F TO CACHE
        Y.COMPANY.ID=R.MNEMONIC.COMPANY<AC.MCO.COMPANY>
        CALL CACHE.READ(FN.COMPANY, Y.COMPANY.ID, R.COMPANY.REC, ERR.COMP)                    ;** R22 Auto conversion - F TO CACHE
        Y.COMPANY.LIST<-1> = Y.COMPANY.ID
        Y.SAP.COST.CENTER.LIST<-1>=R.COMPANY.REC<EB.COM.LOCAL.REF,LOC.EXT.GL.CC.POS>

    REPEAT


RETURN
*************
GET.RE.TXN:
************

    SEL.CMD.RE = 'SELECT ': FN.RE.TXN.CODE
    CALL EB.READLIST(SEL.CMD.RE,Y.SPEC.TXN.CODE.LIST,'',NO.OF.REC.RE,SEL.ERR)

    LOOP
        REMOVE Y.SPEC.TXN.CODE.ID FROM Y.SPEC.TXN.CODE.LIST SETTING Y.SPEC.TXN.CODE.POS
    WHILE Y.SPEC.TXN.CODE.ID:Y.SPEC.TXN.CODE.POS
        CALL CACHE.READ(FN.RE.TXN.CODE, Y.SPEC.TXN.CODE.ID, R.RE.TXN.CODE, ERR.COMP)              ;** R22 Auto conversion - F TO CACHE
        Y.SPEC.TXN.DESC.LIST<-1>=R.RE.TXN.CODE<RE.TXN.DESCRIPTION>

    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    IF R.NEW(SAP.GL.EO.ACTION.DATE) GE TODAY THEN
        RETURN
    END

    REDO.GL.H.EXTRACT.PARAMETER.ID = 'SYSTEM'
    GOSUB READ.REDO.GL.H.EXTRACT.PARAMETER

    IF R.NEW(SAP.GL.EO.ACTION) EQ 'EXTRACT' THEN
        GOSUB PROCESS.EXTRACT
    END

    IF R.NEW(SAP.GL.EO.ACTION) EQ 'CLEAR' THEN
        GOSUB PROCESS.CLEAR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
****************
PROCESS.EXTRACT:
****************

    Y.GIT.COUNT = DCOUNT(R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.GIT.ROUTINE>,@VM)
    Y.GIT.START = 1

    LOOP
    WHILE Y.GIT.START LE Y.GIT.COUNT
        GIT.INTERFACE.OUT.ID  = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.GIT.ROUTINE,Y.GIT.START>
        IF GIT.INTERFACE.OUT.ID MATCHES 'SAP.DETAIL.REPORT':@VM:'SAP.DETAIL.REPORT.PL' THEN
            RETURN
        END
        GOSUB UPDATE.TRANSPORT.FILE
        CALL System.setVariable("CURRENT.COUNT",Y.GIT.START)
        GOSUB CALL.TO.INTERFACE
        GOSUB WRITE.BACKUP
        IF GIT.INTERFACE.OUT.ID MATCHES 'SAP.DETAIL.REPORT':@VM:'SAP.DETAIL.REPORT.PL' THEN    ;*PACS00072689 - S/E
            GOSUB GENERATE.ENQUIRY.REPORT
        END
        Y.GIT.START += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
UPDATE.TRANSPORT.FILE:
**********************
    Y.OUT.PATH = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXTRACT.OUT.PATH,Y.GIT.START>
    IF DCOUNT(R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXT.FILE.EXTN>,'.') THEN
        Y.FILE.EXTN = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXT.FILE.EXTN>
    END ELSE
        Y.FILE.EXTN = '.':R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXT.FILE.EXTN>
    END

    IF RUNNING.UNDER.BATCH THEN
        Y.FILE.FMT.DATE=TODAY
        Y.FILE.FMT.DATE=Y.FILE.FMT.DATE[7,2]:Y.FILE.FMT.DATE[5,2]:Y.FILE.FMT.DATE[1,4]
        Y.EXT.FILE.NAME = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXTRACT.NAME,Y.GIT.START>:Y.FILE.FMT.DATE:Y.FILE.EXTN
    END ELSE

        Y.SYSTEM.DATE = R.NEW(SAP.GL.EO.ACTION.DATE)
        IF NOT(Y.SYSTEM.DATE) THEN
            Y.SYSTEM.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
        END
*       GOSUB GET.RERUN.EXTENSION
        Y.FILE.FMT.DATE=Y.SYSTEM.DATE
        Y.FILE.FMT.DATE=Y.FILE.FMT.DATE[7,2]:Y.FILE.FMT.DATE[5,2]:Y.FILE.FMT.DATE[1,4]
*        Y.EXT.FILE.NAME = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXTRACT.NAME,Y.GIT.START>:Y.FILE.FMT.DATE:'.R':Y.RERUN:Y.FILE.EXTN
        Y.EXT.FILE.NAME = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXTRACT.NAME,Y.GIT.START>:Y.FILE.FMT.DATE:Y.FILE.EXTN
    END

    GIT.TRANSPORT.FILE.ID = GIT.INTERFACE.OUT.ID:'-1'
    GOSUB READ.GIT.TRANSPORT.FILE

    R.GIT.TRANSPORT.FILE<GIT.TRA.FIL.OUT.PATH>      = Y.OUT.PATH
    R.GIT.TRANSPORT.FILE<GIT.TRA.FIL.OUT.FILE.NAME> = Y.EXT.FILE.NAME

    GOSUB WRITE.GIT.TRANSPORT.FILE

    LOG.MSG = "TAM-LOG-SAP-DEBUG:APAP-ALERT-INFO:1023: SAP File Extract Start Processing by  ":OPERATOR:"!"
    CALL RAD.LOG.MSG("SAP","DEBUG",LOG.MSG)

RETURN
*--------------------------------------------------------------------------------------------------------
********************
GET.RERUN.EXTENSION:
********************
    REDO.GL.L.RERUN.EXTN.ID = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.GIT.ROUTINE,Y.GIT.START>
    GOSUB READ.REDO.GL.L.RERUN.EXTN

    LOCATE Y.SYSTEM.DATE IN R.REDO.GL.L.RERUN.EXTN<GL.RERUN.RUN.DATE,1> SETTING Y.RERUN.POS THEN
        Y.RERUN = R.REDO.GL.L.RERUN.EXTN<GL.RERUN.RUN.EXTN,Y.RERUN.POS> + 1
        R.REDO.GL.L.RERUN.EXTN<GL.RERUN.RUN.EXTN,Y.RERUN.POS> = Y.RERUN
    END ELSE
        Y.RERUN = 1
        Y.DATE.COUNT = DCOUNT(R.REDO.GL.L.RERUN.EXTN<GL.RERUN.RUN.DATE>,@VM) + 1
        R.REDO.GL.L.RERUN.EXTN<GL.RERUN.RUN.DATE,Y.DATE.COUNT> = Y.SYSTEM.DATE
        R.REDO.GL.L.RERUN.EXTN<GL.RERUN.RUN.EXTN,Y.DATE.COUNT> = Y.RERUN
    END

    GOSUB WRITE.REDO.GL.L.RERUN.EXTN

RETURN
*--------------------------------------------------------------------------------------------------------
******************
CALL.TO.INTERFACE:
******************

    GIT.PROCESS.ID = ''
    GIT.OUT.CALL   = 1
    GIT.FUTURE.1    = ''
    GIT.FUTURE2    = ''
    GIT.FUTURE3    = ''
    GIT.ERROR.MSG  = ''

    CALL GIT.INTERFACE.OUT.RUN(GIT.INTERFACE.OUT.ID,GIT.PROCESS.ID,GIT.OUT.CALL,GIT.FUTURE.1,GIT.FUTURE.2,GIT.FUTURE.3,GIT.ERROR.MSG)

    IF NOT(GIT.ERROR.MSG) THEN
        LOG.MSG = "TAM-LOG-SAP-DEBUG:APAP-ALERT-INFO:1023: SAP File Extracted by  ":OPERATOR:"!"
        CALL RAD.LOG.MSG("SAP","DEBUG",LOG.MSG)
    END ELSE
        LOG.MSG = "TAM-LOG-SAP-DEBUG:APAP-ALERT-INFO:1024: SAP File Extract not generated by  ":OPERATOR:"!"
        CALL RAD.LOG.MSG("SAP","DEBUG",LOG.MSG)
    END

RETURN
*--------------------------------------------------------------------------------------------------------
************************
GENERATE.ENQUIRY.REPORT:
************************

    ENQUIRY.REPORT.ID = 'REDO.APAP.ER.SAP.DETAIL.R'

    Y.ENQ.VALUE = GIT.INTERFACE.OUT.ID: '|':Y.EXT.FILE.NAME   ;*PACS00072689 - S/E
    DIM R.NEW.BACK(500)

    MAT R.NEW.BACK = MAT R.NEW
    ID.NEW.BACK = ID.NEW


*  MATREAD R.NEW FROM F.ENQUIRY.REPORT,ENQUIRY.REPORT.ID THEN ;*Tus Start
    ARRAY.SIZE = ''
    CALL F.MATREAD(FN.ENQUIRY.REPORT,ENQUIRY.REPORT.ID,MAT R.NEW,ARRAY.SIZE,F.ENQUIRY.REPORT,R.NEW.ERR)
    IF R.NEW.ERR EQ '' THEN  ;* Tus End
        R.NEW(ENQ.REP.LIST)<1,1,1> = Y.ENQ.VALUE
        R.NEW(ENQ.REP.OPERAND)<1,1,1> = 'EQ'
        CALL ENQUIRY.REPORT.RUN
    END

    MAT R.NEW = MAT R.NEW.BACK
    ID.NEW = ID.NEW.BACK
* PACS00169428 & PACS00169423 - Deletion of Detail record
    GOSUB DELETE.DETAILS

RETURN
*--------------------------------------------------------------------------------------------------------
DELETE.DETAILS:
*--------------
* The detail file is no more needed after report generation

    LOCATE GIT.INTERFACE.OUT.ID IN R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.GIT.ROUTINE,1> SETTING Y.GIT.POS ELSE
        RETURN
    END

    Y.FILE.PATH = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXTRACT.OUT.PATH,Y.GIT.POS>

    IF Y.FILE.PATH NE '' THEN
        CALL F.DELETE(Y.FILE.PATH,Y.EXT.FILE.NAME)
        CALL JOURNAL.UPDATE(Y.EXT.FILE.NAME)
    END

RETURN
*--------------------------------------------------------------------------------------------------------
**************
PROCESS.CLEAR:
**************

    Y.RETENTION.DATE = R.NEW(SAP.GL.EO.ACTION.DATE)

    IF NOT(Y.RETENTION.DATE) AND R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.RETEN.PERIOD> THEN
        Y.RETENTION.DATE = TODAY

        BEGIN CASE

            CASE R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.RETEN.PERIOD> EQ "DAY"
                CALL CDT('',Y.RETENTION.DATE,'-1W')

            CASE R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.RETEN.PERIOD> EQ "WEEK"
                CALL CDT('',Y.RETENTION.DATE,'-5W')

            CASE R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.RETEN.PERIOD> EQ "FORTNIGHT"
                CALL CDT('',Y.RETENTION.DATE,'-10W')

            CASE R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.RETEN.PERIOD> EQ "MONTH"
                CALL CDT('',Y.RETENTION.DATE,'-20W')

            CASE R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.RETEN.PERIOD> EQ "QUARTER"
                CALL CDT('',Y.RETENTION.DATE,'-60W')

            CASE R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.RETEN.PERIOD> EQ "HALF YEAR"
                CALL CDT('',Y.RETENTION.DATE,'-120W')

        END CASE
    END

    IF Y.RETENTION.DATE EQ '' THEN
        CALL CDT('',Y.RETENTION.DATE,'-1W')
    END

    SEL.CMD = 'SELECT ':FN.REDO.CAPL.L.RE.STAT.LINE.CONT:' WITH DATE.UPDATED LT ':Y.RETENTION.DATE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    LOOP
        REMOVE REDO.CAPL.L.RE.STAT.LINE.CONT.ID FROM SEL.LIST SETTING CAPL.LINE.CONT.POS
    WHILE REDO.CAPL.L.RE.STAT.LINE.CONT.ID:CAPL.LINE.CONT.POS
        CALL F.DELETE(FN.REDO.CAPL.L.RE.STAT.LINE.CONT,REDO.CAPL.L.RE.STAT.LINE.CONT.ID)
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
*********************************
READ.REDO.GL.H.EXTRACT.PARAMETER:
*********************************
* In this para of the code, file REDO.GL.H.EXTRACT.PARAMETER is read
    R.REDO.GL.H.EXTRACT.PARAMETER  = ''
    REDO.GL.H.EXTRACT.PARAMETER.ER = ''
    CALL CACHE.READ(FN.REDO.GL.H.EXTRACT.PARAMETER,REDO.GL.H.EXTRACT.PARAMETER.ID,R.REDO.GL.H.EXTRACT.PARAMETER,REDO.GL.H.EXTRACT.PARAMETER.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
******************************
READ.REDO.GL.W.EXTRACT.ONLINE:
******************************
* In this para of the code, file REDO.GL.W.EXTRACT.ONLINE is read
    R.REDO.GL.W.EXTRACT.ONLINE  = ''
    REDO.GL.W.EXTRACT.ONLINE.ER = ''
    CALL CACHE.READ(FN.REDO.GL.W.EXTRACT.ONLINE,REDO.GL.W.EXTRACT.ONLINE.ID,R.REDO.GL.W.EXTRACT.ONLINE,REDO.GL.W.EXTRACT.ONLINE.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
************************
READ.GIT.TRANSPORT.FILE:
************************
* In this para of the code, file GIT.TRANSPORT.FILE is read
    R.GIT.TRANSPORT.FILE  = ''
    GIT.TRANSPORT.FILE.ER = ''
    CALL F.READ(FN.GIT.TRANSPORT.FILE,GIT.TRANSPORT.FILE.ID,R.GIT.TRANSPORT.FILE,F.GIT.TRANSPORT.FILE,GIT.TRANSPORT.FILE.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
**************************
READ.REDO.GL.L.RERUN.EXTN:
**************************
* In this para of the code, file REDO.GL.L.RERUN.EXTN is read
    R.REDO.GL.L.RERUN.EXTN  = ''
    REDO.GL.L.RERUN.EXTN.ER = ''
    CALL F.READ(FN.REDO.GL.L.RERUN.EXTN,REDO.GL.L.RERUN.EXTN.ID,R.REDO.GL.L.RERUN.EXTN,F.REDO.GL.L.RERUN.EXTN,REDO.GL.L.RERUN.EXTN.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
***************************
WRITE.REDO.GL.L.RERUN.EXTN:
***************************
    CALL F.WRITE(FN.REDO.GL.L.RERUN.EXTN,REDO.GL.L.RERUN.EXTN.ID,R.REDO.GL.L.RERUN.EXTN)
    CALL JOURNAL.UPDATE(REDO.GL.L.RERUN.EXTN.ID)

RETURN
*--------------------------------------------------------------------------------------------------------
*************************
WRITE.GIT.TRANSPORT.FILE:
*************************
    CALL F.WRITE(FN.GIT.TRANSPORT.FILE,GIT.TRANSPORT.FILE.ID,R.GIT.TRANSPORT.FILE)
    CALL JOURNAL.UPDATE(GIT.TRANSPORT.FILE.ID)

RETURN
*--------------------------------------------------------------------------------------------------------
******************
WRITE.BACKUP:
*******************

    Y.FILE.NAME=Y.EXT.FILE.NAME
    OPEN '',Y.OUT.PATH TO F.FILE.PATH THEN

    END

    READ R.FILE.DATA FROM F.FILE.PATH,Y.FILE.NAME ELSE

        Y.RESP.ERR =Y.FILE.NAME :' No records for the day - ':R.NEW(SAP.GL.EO.ACTION.DATE)
        INT.CODE = 'SAP002'
        IF RUNNING.UNDER.BATCH THEN
            INT.TYPE ='BATCH'
        END
        ELSE
            INT.TYPE = 'ONLINE'
        END
        BAT.NO  = ''
        BAT.TOT = ''
        INFO.OR = ''
        INFO.DE = ''
        ID.PROC = 'REDO.H.GL.EXTRACT.PARAMETER'
        MON.TP  = '04'
        DESC    = Y.FILE.NAME :' File not generated'
        REC.CON = ' No records for the day - ':R.NEW(SAP.GL.EO.ACTION.DATE)
        EX.USER = ''
        EX.PC   = ''
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
** R22 Manual conversion
        CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        RETURN
    END
    Y.BACKUP.PATH=R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.BACKUP.PATH>
    OPEN '',Y.BACKUP.PATH TO F.BACKUP.PATH THEN
    END
*WRITE R.FILE.DATA TO F.BACKUP.PATH,Y.FILE.NAME
RETURN
END       ;* End of Program
