* @ValidationCode : MjotMTA3NjMxMDEzNzpDcDEyNTI6MTY4Mzg5MjYyOTM5MzpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM


SUBROUTINE REDO.GL.B.EXTRACT.RTN
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.GL.B.EXTRACT.RTN
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.GL.B.EXTRACT.RTN is an BATCH routine ,
*                    this routine inturn calls the GIT routines to create extracts/reports
*Linked With       : Batch
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
* 22 Oct 2010       Shiva Prasad Y       ODR-2009-12-0294 C.12          Initial Creation
* 03 Jun 2011       Pradeep S            PACS00072689                   Changes in creating Enquiry report for both GL & PL
* 26  JUB 2011      Prabhu N             PACS00032519                   Changes added for encryption
* 26  JUB 2011      Prabhu N             PACS00032519                   RUNNING UNDER BATCH EQ 0 is commented
* 20-12-2011        SHANKAR RAJU         PACS00169428 & PACS00169423    Deletion of Detail record
* 13.04.2023       Conversion Tool       R22                            Auto Conversion     - FM TO @FM, VM TO @VM, F TO CACHE, ++ TO += 1
* 13.04.2023       Shanmugapriya M       R22                            Manual Conversion   - Add call routine prefix
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_F.GIT.TRANSPORT.FILE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
    $INSERT I_GIT.COMMON
    $INSERT I_F.ENQUIRY.REPORT
    $INSERT I_F.RE.TXN.CODE
    $INSERT I_F.REDO.GL.L.RERUN.EXTN
    $INSERT I_F.REDO.GL.W.EXTRACT.ONLINE
    $INSERT I_F.CURRENCY
    $INSERT I_F.COMPANY
    $INSERT I_F.MNEMONIC.COMPANY
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

    FN.REDO.GL.W.EXTRACT.ONLINE = 'F.REDO.GL.W.EXTRACT.ONLINE'
    F.REDO.GL.W.EXTRACT.ONLINE  = ''
    CALL OPF(FN.REDO.GL.W.EXTRACT.ONLINE,F.REDO.GL.W.EXTRACT.ONLINE)

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
*    R.REDO.GL.W.EXTRACT.ONLINE = ''
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
        CALL CACHE.READ(FN.MNEMONIC.COMPANY, Y.COMPANY.MNE.ID, R.MNEMONIC.COMPANY, ERR)        ;** R22 Auto conversion - F TO CACHE
        Y.COMPANY.ID=R.MNEMONIC.COMPANY<AC.MCO.COMPANY>
        CALL CACHE.READ(FN.COMPANY, Y.COMPANY.ID, R.COMPANY.REC, ERR.COMP)                     ;** R22 Auto conversion - F TO CACHE
        Y.COMPANY.LIST<-1> = Y.COMPANY.ID
        Y.SAP.COST.CENTER.LIST<-1>=R.COMPANY.REC<EB.COM.LOCAL.REF,LOC.EXT.GL.CC.POS>

    REPEAT

RETURN
**************
GET.RE.TXN:
**************
    SEL.CMD.RE = 'SELECT ': FN.RE.TXN.CODE
    CALL EB.READLIST(SEL.CMD.RE,Y.SPEC.TXN.CODE.LIST,'',NO.OF.REC.RE,SEL.ERR)

    LOOP
        REMOVE Y.SPEC.TXN.CODE.ID FROM Y.SPEC.TXN.CODE.LIST SETTING Y.SPEC.TXN.CODE.POS
    WHILE Y.SPEC.TXN.CODE.ID:Y.SPEC.TXN.CODE.POS
        CALL CACHE.READ(FN.RE.TXN.CODE, Y.SPEC.TXN.CODE.ID, R.RE.TXN.CODE, ERR.COMP)             ;** R22 Auto conversion - F TO CACHE
        Y.SPEC.TXN.DESC.LIST<-1>=R.RE.TXN.CODE<RE.TXN.DESCRIPTION>
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para


    SEL.CMD = 'SELECT ':FN.CURRENCY:' WITH @ID NE ':LCCY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE SEL.NOR
        Y.CURRENCY = SEL.LIST<Y.VAR1>
        CALL CACHE.READ(FN.CURRENCY, Y.CURRENCY, R.CURRENCY, CUR.ERR)          ;** R22 Auto conversion - F TO CACHE
        Y.CUR.MARK = R.CURRENCY<EB.CUR.CURRENCY.MARKET>
        LOCATE '1' IN Y.CUR.MARK<1,1> SETTING POS.CUR THEN
            Y.MID.VAL.RATE = R.CURRENCY<EB.CUR.REVAL.RATE,POS.CUR>
            R.REDO.CCY.DAILY.RATES<1> = Y.MID.VAL.RATE
            Y.ID.CCY = Y.CURRENCY:'*':R.DATES(EB.DAT.LAST.WORKING.DAY)
            CALL F.WRITE(FN.REDO.CCY.DAILY.RATES,Y.ID.CCY,R.REDO.CCY.DAILY.RATES)
        END
        Y.VAR1 += 1             ;** R22 Auto conversion - ++ TO += 1
    REPEAT

    REDO.GL.H.EXTRACT.PARAMETER.ID = 'SYSTEM'
    GOSUB READ.REDO.GL.H.EXTRACT.PARAMETER

    GOSUB PROCESS.EXTRACT

RETURN
*--------------------------------------------------------------------------------------------------------
****************
PROCESS.EXTRACT:
****************
    GOSUB UPDATE.EXTRACT.ONLINE
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
*        CALL System.setVariable("CURRENT.COUNT",Y.GIT.START)
        GOSUB WRITE.BACKUP
        IF GIT.INTERFACE.OUT.ID MATCHES 'SAP.DETAIL.REPORT':@VM:'SAP.DETAIL.REPORT.PL' THEN    ;*PACS00072689 - S/E
            GOSUB GENERATE.ENQUIRY.REPORT
        END
        Y.GIT.START += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
UPDATE.EXTRACT.ONLINE:
**********************
    REDO.GL.W.EXTRACT.ONLINE.ID = 'SYSTEM'
    GOSUB READ.REDO.GL.W.EXTRACT.ONLINE

    R.REDO.GL.W.EXTRACT.ONLINE<SAP.GL.EO.ACTION.DATE> = R.DATES(EB.DAT.LAST.WORKING.DAY)

    GOSUB WRITE.REDO.GL.W.EXTRACT.ONLINE

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
    Y.FILE.FMT.DATE=R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.FILE.FMT.DATE=Y.FILE.FMT.DATE[7,2]:Y.FILE.FMT.DATE[5,2]:Y.FILE.FMT.DATE[1,4]
    Y.EXT.FILE.NAME = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXTRACT.NAME,Y.GIT.START>:Y.FILE.FMT.DATE:Y.FILE.EXTN

    GIT.TRANSPORT.FILE.ID = GIT.INTERFACE.OUT.ID:'-1'
    GOSUB READ.GIT.TRANSPORT.FILE

    R.GIT.TRANSPORT.FILE<GIT.TRA.FIL.OUT.PATH>      = Y.OUT.PATH
    R.GIT.TRANSPORT.FILE<GIT.TRA.FIL.OUT.FILE.NAME> = Y.EXT.FILE.NAME

    GOSUB WRITE.GIT.TRANSPORT.FILE

    LOG.MSG = "TAM-LOG-SAP-DEBUG:APAP-ALERT-INFO:1023: SAP File Extract Start Processing by  ":OPERATOR:"!"
    CALL RAD.LOG.MSG("SAP","DEBUG",LOG.MSG)

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
    RUNNING.UNDER.BATCH = 0
    CALL GIT.INTERFACE.OUT.RUN(GIT.INTERFACE.OUT.ID,GIT.PROCESS.ID,GIT.OUT.CALL,GIT.FUTURE.1,GIT.FUTURE.2,GIT.FUTURE.3,GIT.ERROR.MSG)
    RUNNING.UNDER.BATCH = 1

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

    Y.ENQ.VALUE = GIT.INTERFACE.OUT.ID:'|':Y.EXT.FILE.NAME    ;*PACS00072689 - S/E


*  MATREAD R.NEW FROM F.ENQUIRY.REPORT,ENQUIRY.REPORT.ID THEN ;*Tus Start
    ARRAY.SIZE = ''
    CALL F.MATREAD(FN.ENQUIRY.REPORT,ENQUIRY.REPORT.ID,MAT R.NEW,ARRAY.SIZE,F.ENQUIRY.REPORT,R.NEW.ERR)
    IF R.NEW.ERR EQ '' THEN  ;* Tus End
        R.NEW(ENQ.REP.LIST)<1,1,1> = Y.ENQ.VALUE
        R.NEW(ENQ.REP.OPERAND)<1,1,1> = 'EQ'
        CALL ENQUIRY.REPORT.RUN
    END
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
    END

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
*******************************
WRITE.REDO.GL.W.EXTRACT.ONLINE:
*******************************
*    WRITE R.REDO.GL.W.EXTRACT.ONLINE TO F.REDO.GL.W.EXTRACT.ONLINE,REDO.GL.W.EXTRACT.ONLINE.ID
    CALL F.WRITE(FN.REDO.GL.W.EXTRACT.ONLINE,REDO.GL.W.EXTRACT.ONLINE.ID,R.REDO.GL.W.EXTRACT.ONLINE)
RETURN
*--------------------------------------------------------------------------------------------------------
***************************
WRITE.REDO.GL.L.RERUN.EXTN:
***************************
    CALL F.WRITE(FN.REDO.GL.L.RERUN.EXTN,REDO.GL.L.RERUN.EXTN.ID,R.REDO.GL.L.RERUN.EXTN)

RETURN
*--------------------------------------------------------------------------------------------------------
*************************
WRITE.GIT.TRANSPORT.FILE:
*************************
    CALL F.WRITE(FN.GIT.TRANSPORT.FILE,GIT.TRANSPORT.FILE.ID,R.GIT.TRANSPORT.FILE)

RETURN
*PACS00032519-S
******************
WRITE.BACKUP:
*******************
    Y.FILE.NAME=Y.EXT.FILE.NAME
    OPEN '',Y.OUT.PATH TO F.FILE.PATH THEN

    END
    READ R.FILE.DATA FROM F.FILE.PATH,Y.FILE.NAME ELSE

        Y.RESP.ERR =Y.FILE.NAME :' File not generated'
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
*  REC.CON = Y.FILE.NAME :' File not generated'
        REC.CON = 'No Records available for this day to process ':Y.FILE.FMT.DATE

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
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
