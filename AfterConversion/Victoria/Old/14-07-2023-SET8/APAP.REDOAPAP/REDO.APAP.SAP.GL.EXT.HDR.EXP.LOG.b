$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.SAP.GL.EXT.HDR.EXP.LOG(GIT.OUT.MSG,GIT.ERR)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.SAP.GL.EXT.HDR.EXP.LOG
*--------------------------------------------------------------------------------------------------------
*Description       : This is an OUT routine, this routine is used to form the header and footer for the
*                    record output from GIT Interface
*Linked With       : GIT.TRANSPORT.FILE - SAP.NORMAL.EXTRACT-1 & SAP.REVAL.EXTRACT-1
*In  Parameter     : GIT.OUT.MSG - GIT Output Record
*Out Parameter     : GIT.OUT.MSG - GIT Output Record
*                    GIT.ERR     - GIT Error
*Files  Used       : GIT.INTERFACE.OUT                   As              I               Mode
*                    REDO.GL.H.EXTRACT.PARAMETER         As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 09 Nov 2010       Shiva Prasad Y       ODR-2009-12-0294 C.12         Initial Creation
* 03 JUN 2011       Pradeep S            PACS00072689                   Seperate GIT created for PL
*19 JUN  2011       Prabhu N             PACS00032519                  Encryption added
*19 JUN  2011       Prabhu N             PACS00100804                  FIX with application Name
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM, VM TO @VM, ++ TO += 1
*13-07-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE MODIFIED
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_GIT.COMMON
    $INSERT I_F.GIT.INTERFACE.OUT
    $INSERT I_F.GIT.TRANSPORT.FILE
    $INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
    $INSERT JBC.h
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.GL.W.EXTRACT.ONLINE
    $INSERT I_GIT.ONLINE.VAR
    $USING APAP.REDOCHNLS
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
    FN.GIT.INTERFACE.OUT = 'F.GIT.INTERFACE.OUT'
    F.GIT.INTERFACE.OUT = ''
    CALL OPF(FN.GIT.INTERFACE.OUT,F.GIT.INTERFACE.OUT)

    FN.REDO.GL.H.EXTRACT.PARAMETER = 'F.REDO.GL.H.EXTRACT.PARAMETER'
    F.REDO.GL.H.EXTRACT.PARAMETER = ''
    CALL OPF(FN.REDO.GL.H.EXTRACT.PARAMETER,F.REDO.GL.H.EXTRACT.PARAMETER)

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

    FN.GIT.TRANSPORT.FILE = 'F.GIT.TRANSPORT.FILE'
    F.GIT.TRANSPORT.FILE = ''
    CALL OPF(FN.GIT.TRANSPORT.FILE,F.GIT.TRANSPORT.FILE)

    FN.REDO.GL.W.EXTRACT.ONLINE='F.REDO.GL.W.EXTRACT.ONLINE'
    F.REDO.GL.W.EXTRACT.ONLINE=''
    CALL OPF(FN.REDO.GL.W.EXTRACT.ONLINE,F.REDO.GL.W.EXTRACT.ONLINE)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    Y.TOT.DB.COUNT = 0
    Y.TOT.CR.COUNT = 0
    Y.TOT.DB.AMT = 0
    Y.TOT.CR.AMT = 0

    GOSUB GET.PARAMETER.DETAILS
    Y.FLAG = ''
    LOCATE GIT.COM.OUT.INT.ID IN R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.GIT.ROUTINE,1> SETTING Y.BAL.POS ELSE
        RETURN
    END

    IF R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.BALANCE.FILE,Y.BAL.POS> EQ 'YES' THEN
        Y.FLAG = 1
    END
    Y.PATH = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXTRACT.OUT.PATH,Y.BAL.POS>
    CRLF=CHARX(013):CHARX(254)
    CHANGE CRLF TO @FM IN GIT.OUT.MSG ;*R22 AUTO CONVERSION
    CRLF=CHARX(013):CHARX(010)
    CHANGE CRLF TO @FM IN GIT.OUT.MSG ;*R22 AUTO CONVERSION
    GIT.OUT.MSG.DUP = GIT.OUT.MSG

    GOSUB GET.REC.FLD.DELIM
    GOSUB SORT.OUT.MSG
    IF Y.FLAG THEN
        GOSUB POST.FORCE.ITEM
        Y.SORTED.REC = Y.OUT.RECORD
    END

    GOSUB UPDATE.HEADER.DETAILS
    GOSUB GENERATE.EXCEPTION.LOG
*-------------------------------------------------------------------------------
    Y.FINAL.REC.CNT=DCOUNT(Y.FINAL.REC,@FM) ;*R22 AUTO CONVERSION
    Y.LOOP.FINAL.CNT=1
    LOOP
    WHILE Y.LOOP.FINAL.CNT LE Y.FINAL.REC.CNT
        R.RETURN.MESSAGE=Y.FINAL.REC<Y.LOOP.FINAL.CNT>
        Y.RECORD.LINE=R.RETURN.MESSAGE
        GOSUB INITIALIZE.ENCRYPT
        GOSUB OPEN.FILES.ENCRYPT
        GOSUB PROCESS.ENCRYPT
*    Y.ENCRP.REC<Y.LOOP.FINAL.CNT> = Y.RECORD.LINE
        Y.ENCRP.REC<-1> = Y.RECORD.LINE
        Y.LOOP.FINAL.CNT += 1 ;*R22 AUTO CONVERSION
    REPEAT
    GIT.OUT.MSG=Y.ENCRP.REC
RETURN
*--------------------------------------------------------------------------------------------------------
*************************
INITIALIZE.ENCRYPT:
*************************
    Y.ERR = ''
    Y.PARAM.ID = "DES333"
    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    F.REDO.INTERFACE.PARAM = ""
    R.REDO.INTERFACE.PARAM = ""
    GOAHEAD = ''
RETURN
*************************
OPEN.FILES.ENCRYPT:
*************************
    yLine=''
    CALL OPF(FN.REDO.INTERFACE.PARAM, F.REDO.INTERFACE.PARAM)
    CALL F.READ(FN.REDO.INTERFACE.PARAM, Y.PARAM.ID, R.REDO.INTERFACE.PARAM, F.REDO.INTERFACE.PARAM, Y.ERR)
    IF NOT(R.REDO.INTERFACE.PARAM) THEN
        RETURN
    END
    GOAHEAD = 'TRUE'
    yEncripKey = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.ENCRIP.KEY>
    yLine = R.RETURN.MESSAGE

RETURN
*************************
PROCESS.ENCRYPT:
*************************

    IF R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.ENCRIPTATION> EQ 'SI' THEN
        yLine=''
        yLine = ENCRYPT(R.RETURN.MESSAGE,yEncripKey,JBASE_CRYPT_3DES_BASE64)
    END ELSE
        yLine = R.RETURN.MESSAGE
    END

    Y.RECORD.LINE=yLine
RETURN
*--------------------------------------------------------------------------------------------------------
******************
GET.REC.FLD.DELIM:
******************
    GIT.INTERFACE.OUT.ID = GIT.COM.OUT.INT.ID
    GOSUB READ.GIT.INTERFACE.OUT

    Y.REC.DELIM = R.GIT.INTERFACE.OUT<GIT.INT.OUT.RECORD.DELIM>
    Y.FLD.DELIM = R.GIT.INTERFACE.OUT<GIT.INT.OUT.FIELD.DELIM>

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
GET.PARAMETER.DETAILS:
**********************
    REDO.GL.H.EXTRACT.PARAMETER.ID = 'SYSTEM'
    GOSUB READ.REDO.GL.H.EXTRACT.PARAMETER

    Y.DB.CODE = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXT.DEBIT.CODE>
    Y.CR.CODE = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.EXT.CREDIT.CODE>
    Y.HEADER.MARKER  =R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.HD.ID.MARKER>
    Y.COMPANY.MARKER =R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.COM.ID.MARKER>
    Y.RECORD.MARKER  =R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.DET.ID.MARKER>
    IF NOT(R.REDO.GL.W.EXTRACT.ONLINE) THEN
        CALL CACHE.READ(FN.REDO.GL.W.EXTRACT.ONLINE,'SYSTEM',R.REDO.GL.W.EXTRACT.ONLINE,ERR)
    END
    Y.DATE=R.REDO.GL.W.EXTRACT.ONLINE<SAP.GL.EO.ACTION.DATE>
RETURN
*--------------------------------------------------------------------------------------------------------
*************
SORT.OUT.MSG:
*************
    Y.REC.COUNT = DCOUNT(GIT.OUT.MSG.DUP,@FM) ;*R22 AUTO CONVERSION
    Y.REC.START = 1
    LOOP
    WHILE Y.REC.START LE Y.REC.COUNT
        Y.REC.LINE = GIT.OUT.MSG.DUP<Y.REC.START>
        Y.SORT.VAL = FIELD(Y.REC.LINE,Y.FLD.DELIM,3):FIELD(Y.REC.LINE,Y.FLD.DELIM,4)

        Y.REC.SORT.LIST<-1> = Y.REC.LINE:@FM:Y.SORT.VAL ;*R22 AUTO CONVERSION
        Y.SORT.LIST<-1> = Y.SORT.VAL

        Y.REC.START += 1
    REPEAT

    Y.SORT.LIST = SORT(Y.SORT.LIST)

    LOOP
        REMOVE Y.SORTED.VAL FROM Y.SORT.LIST SETTING Y.SORT.POS
    WHILE Y.SORTED.VAL : Y.SORT.POS
        LOCATE Y.SORTED.VAL IN Y.REC.SORT.LIST SETTING Y.LOC.POS THEN
            Y.SORTED.REC<-1> = Y.REC.SORT.LIST<Y.LOC.POS-1>
            DEL Y.REC.SORT.LIST<Y.LOC.POS>
            DEL Y.REC.SORT.LIST<Y.LOC.POS-1>
        END
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
****************
POST.FORCE.ITEM:
****************
    Y.DB.AMT = 0
    Y.CR.AMT = 0
    Y.DB.AMT.FCY=0
    Y.CR.AMT.FCY=0
    Y.OLD.COMP.CCY = FIELD(Y.SORTED.REC<1>,Y.FLD.DELIM,3):FIELD(Y.SORTED.REC<1>,Y.FLD.DELIM,4)

    Y.REC.COUNT = DCOUNT(Y.SORTED.REC,@FM) + 1 ;*R22 AUTO CONVERSION
    Y.REC.START = 1
    LOOP
    WHILE Y.REC.START LE Y.REC.COUNT
        Y.LINE = Y.SORTED.REC<Y.REC.START>
        Y.COMP.CCY = FIELD(Y.LINE,Y.FLD.DELIM,3):FIELD(Y.LINE,Y.FLD.DELIM,4)
        IF Y.OLD.COMP.CCY EQ Y.COMP.CCY THEN
            GOSUB GET.CR.DB.AMT
            Y.OUT.RECORD<-1> = Y.LINE
        END ELSE
            Y.OLD.COMP.CCY = Y.COMP.CCY
            GOSUB CHECK.DB.CR.AMT
        END
        Y.REC.START += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
**************
GET.CR.DB.AMT:
**************

    IF FIELD(Y.LINE,Y.FLD.DELIM,1) EQ Y.DB.CODE THEN
        Y.DB.AMT += FIELD(Y.LINE,Y.FLD.DELIM,5)
        Y.DB.AMT.FCY+=FIELD(Y.LINE,Y.FLD.DELIM,6)
    END ELSE
        Y.CR.AMT += FIELD(Y.LINE,Y.FLD.DELIM,5)
        Y.CR.AMT.FCY+=FIELD(Y.LINE,Y.FLD.DELIM,6)
    END

RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.DB.CR.AMT:
****************
    IF Y.DB.AMT EQ Y.CR.AMT THEN
        Y.REC.START -= 1
        Y.DB.AMT = 0
        Y.CR.AMT = 0
        Y.DB.AMT.FCY=0
        Y.CR.AMT.FCY=0
        RETURN
    END

    Y.FORCE.POST.ITEM = 1

    Y.SAP.ACC.NO = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.BAL.ENTRY.NO,Y.BAL.POS>

    IF Y.DB.AMT GT Y.CR.AMT THEN
        Y.TXN.CODE = Y.CR.CODE:'F'
        Y.CONT.IND = 'NCT'
        GOSUB FORCE.POST.ITEM
    END ELSE
        Y.TXN.CODE = Y.DB.CODE:'F'
        Y.CONT.IND = 'NCT'
        GOSUB FORCE.POST.ITEM
    END

    Y.REC.START -= 1
    Y.DB.AMT = 0
    Y.DB.AMT.FCY=0
    Y.CR.AMT = 0
    Y.CR.AMT.FCY=0
RETURN
*--------------------------------------------------------------------------------------------------------
****************
FORCE.POST.ITEM:
****************
    Y.COMPANY  = FIELD(Y.SORTED.REC<Y.REC.START-1>,Y.FLD.DELIM,3)
    Y.CURRENCY = FIELD(Y.SORTED.REC<Y.REC.START-1>,Y.FLD.DELIM,4)

    Y.LCY.AMT = ''
    Y.FCY.AMT = ''
    Y.CR.FMT = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.CREDIT.FORMAT,Y.BAL.POS>
    Y.DB.FMT = R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.DEBIT.FORMAT,Y.BAL.POS>

    IF Y.TXN.CODE EQ Y.CR.CODE:'F' THEN
        Y.LCY.AMT = ABS(Y.DB.AMT - Y.CR.AMT)
        Y.FCY.DIFF=ABS(Y.DB.AMT.FCY-Y.CR.AMT.FCY)
        GOSUB FORMAT.OUT
        IF Y.CR.FMT EQ '-' THEN
            Y.LCY.AMT = (-1) * Y.LCY.AMT
            Y.FCY.DIFF= (-1) * Y.FCY.DIFF
        END
    END ELSE
        Y.LCY.AMT = ABS(Y.DB.AMT - Y.CR.AMT)
        Y.FCY.DIFF=ABS(Y.DB.AMT.FCY-Y.CR.AMT.FCY)
        GOSUB FORMAT.OUT
        IF Y.DB.FMT EQ '-' THEN
            Y.LCY.AMT = (-1) * Y.LCY.AMT
            Y.FCY.DIFF= (-1) * Y.FCY.DIFF
        END
    END
*    Y.OUT.RECORD<-1> = Y.TXN.CODE:Y.FLD.DELIM:Y.SAP.ACC.NO:Y.FLD.DELIM:Y.COMPANY:Y.FLD.DELIM:Y.CURRENCY:Y.FLD.DELIM:Y.LCY.AMT:Y.FLD.DELIM:Y.FCY.AMT:Y.FLD.DELIM:Y.CONT.IND:Y.FLD.DELIM:Y.COMPANY
    Y.OUT.RECORD<-1> = Y.TXN.CODE:Y.FLD.DELIM:Y.SAP.ACC.NO:Y.FLD.DELIM:Y.COMPANY:Y.FLD.DELIM:Y.CURRENCY:Y.FLD.DELIM:Y.LCY.AMT:Y.FLD.DELIM:Y.FCY.DIFF:Y.FLD.DELIM:Y.CONT.IND:Y.FLD.DELIM:Y.COMPANY
RETURN
*----------
FORMAT.OUT:
*----------
    Y.LCY.AMT.LEN=LEN(Y.LCY.AMT)
    IF Y.LCY.AMT AND Y.LCY.AMT.LEN LT 2 THEN
        Y.LCY.AMT=FMT(Y.LCY.AMT,'R%2')
    END
    Y.FCY.DIFF.LEN=LEN(Y.FCY.DIFF)
    IF Y.FCY.DIFF.LEN LT 2 AND Y.FCY.DIFF THEN
        Y.FCY.DIFF=FMT(Y.FCY.DIFF,'R%2')
    END
RETURN
**********************
UPDATE.HEADER.DETAILS:
**********************
    SEL.CMD.COMP = 'SELECT ':FN.COMPANY
    CALL EB.READLIST(SEL.CMD.COMP,SEL.LIST.COMP,'',NO.OF.REC.COMP,SEL.ERR.COMP)

    Y.COMP.CNT=1
    LOOP
    WHILE Y.COMP.CNT LE NO.OF.REC.COMP
        Y.COMPANY.ID=SEL.LIST.COMP<Y.COMP.CNT>
        GOSUB GET.COMP.DETAILS
        SEL.LIST.COMP.COST<Y.COMP.CNT>=Y.SAP.COST.CENTRE
        Y.COMP.CNT += 1 ;*R22 AUTO CONVERSION
    REPEAT

    Y.REC.COUNT = DCOUNT(Y.SORTED.REC,@FM) ;*R22 AUTO CONVERSION
    Y.REC.START = 1

    LOOP
    WHILE Y.REC.START LE Y.REC.COUNT

        Y.LINE = Y.SORTED.REC<Y.REC.START>
        IF NOT(Y.LINE) THEN
            Y.REC.START += 1
        END
        ELSE
            IF NOT(FIELD(Y.LINE,Y.FLD.DELIM,2)) THEN
                Y.SAP.CP.ERR = 1
            END

            LOCATE COMPANY.ID IN SEL.LIST.COMP.COST<1> SETTING Y.COMP.POS THEN
                DEL SEL.LIST.COMP<Y.COMP.POS>
                DEL SEL.LIST.COMP.COST<Y.COMP.POS>
            END
            GOSUB GET.CR.DB.VALUES
            COMPANY.ID = FIELD(Y.LINE,Y.FLD.DELIM,3)
            IF Y.OLD.COMP EQ COMPANY.ID THEN

                GOSUB GET.CR.DB.AMT
                CHANGE Y.FLD.DELIM TO @FM IN Y.LINE ;*R22 AUTO CONVERSION
                Y.LINE<3>=Y.LINE<8>
                DEL Y.LINE<8>
                CHANGE @FM TO Y.FLD.DELIM IN Y.LINE ;*R22 AUTO CONVERSION
                Y.FINAL.REC<-1> = Y.RECORD.MARKER:Y.FLD.DELIM:Y.LINE
            END ELSE
                Y.OLD.COMP = COMPANY.ID
                GOSUB GET.COMP.DETAILS
                CHANGE Y.FLD.DELIM TO @FM IN Y.LINE ;*R22 AUTO CONVERSION
                Y.LINE<3>=Y.LINE<8>
                DEL Y.LINE<8>
                CHANGE @FM TO Y.FLD.DELIM IN Y.LINE ;*R22 AUTO CONVERSION
                Y.FINAL.REC<-1> =Y.COMPANY.MARKER:Y.FLD.DELIM: COMPANY.ID
                Y.FINAL.REC<-1> =Y.RECORD.MARKER:Y.FLD.DELIM: Y.LINE
            END
            Y.REC.START += 1
        END
    REPEAT
*PACS00100804-S
    IF APPLICATION EQ 'REDO.GL.W.EXTRACT.ONLINE' THEN
        Y.PROCESS.IND = 'RP'
    END ELSE
        Y.PROCESS.IND = 'PR'
    END
*PACS00100804-E
*IF GIT.INTERFACE.OUT.ID EQ 'SAP.REVAL.EXTRACT' THEN
    IF GIT.INTERFACE.OUT.ID MATCHES 'SAP.REVAL.EXTRACT':@VM:'SAP.REVAL.EXTRACT.PL' THEN      ;*PACS00072689 - S/E ;*R22 AUTO CONVERSION
        Y.REV = Y.FLD.DELIM:'REV'
    END

    IF Y.FORCE.POST.ITEM THEN
        IF Y.TOT.DB.AMT GE Y.TOT.CR.AMT THEN
            Y.TOT.H.DB.AMT = Y.TOT.DB.AMT
            Y.TOT.H.CR.AMT = Y.TOT.DB.AMT
        END ELSE
            Y.TOT.H.DB.AMT = Y.TOT.CR.AMT
            Y.TOT.H.CR.AMT = Y.TOT.CR.AMT
        END
    END ELSE
        Y.TOT.H.DB.AMT = Y.TOT.DB.AMT
        Y.TOT.H.CR.AMT = Y.TOT.CR.AMT
    END

    IF RUNNING.UNDER.BATCH THEN
        Y.RUN = ''
        Y.YEAR  = TODAY[1,4]
        Y.MONTH = TODAY[5,2]
        Y.DAY   = TODAY[2]
    END ELSE
        Y.RUN = 'R'
        Y.YEAR  = Y.DATE[1,4]
        Y.MONTH = Y.DATE[5,2]
        Y.DAY   = Y.DATE[2]
    END
    Y.DATE  = Y.DAY:Y.MONTH:Y.YEAR
*----Y.RUN removed*-------------------------------------------------------------------------
    Y.MAIN.HDR =Y.HEADER.MARKER:Y.FLD.DELIM: Y.DATE :Y.FLD.DELIM: Y.TOT.H.DB.AMT :Y.FLD.DELIM: Y.TOT.H.CR.AMT :Y.FLD.DELIM: Y.TOT.DB.COUNT :Y.FLD.DELIM: Y.TOT.CR.COUNT :Y.FLD.DELIM: Y.PROCESS.IND :Y.REV
    INS Y.MAIN.HDR BEFORE Y.FINAL.REC<1>

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.CR.DB.VALUES:
*****************
    IF FIELD(Y.LINE,Y.FLD.DELIM,1) EQ Y.DB.CODE THEN
        Y.TOT.DB.COUNT += 1
        Y.DB.AMT = FIELD(Y.LINE,Y.FLD.DELIM,5)
        Y.TOT.DB.AMT +=  Y.DB.AMT
        Y.TOT.EXP.DB.AMT += Y.DB.AMT
    END

    IF FIELD(Y.LINE,Y.FLD.DELIM,1) EQ Y.CR.CODE THEN
        Y.TOT.CR.COUNT += 1
        Y.CR.AMT = FIELD(Y.LINE,Y.FLD.DELIM,5)
        Y.TOT.CR.AMT +=  Y.CR.AMT
        Y.TOT.EXP.CR.AMT += Y.CR.AMT
    END

    IF FIELD(Y.LINE,Y.FLD.DELIM,1) EQ Y.DB.CODE:'F' THEN
        Y.TOT.DB.COUNT += 1
        CHANGE Y.DB.CODE:'F' TO Y.DB.CODE IN Y.LINE
        Y.DB.AMT = FIELD(Y.LINE,Y.FLD.DELIM,5)
        Y.TOT.DB.AMT +=  Y.DB.AMT
    END

    IF FIELD(Y.LINE,Y.FLD.DELIM,1) EQ Y.CR.CODE:'F' THEN
        Y.TOT.CR.COUNT += 1
        CHANGE Y.CR.CODE:'F' TO Y.CR.CODE IN Y.LINE
        Y.CR.AMT = FIELD(Y.LINE,Y.FLD.DELIM,5)
        Y.TOT.CR.AMT +=  Y.CR.AMT
    END

RETURN
*--------------------------------------------------------------------------------------------------------
***********************
GENERATE.EXCEPTION.LOG:
***********************
    GIT.TRANSPORT.FILE.ID = GIT.COM.OUT.INT.ID:'-1'
    GOSUB READ.GIT.TRANSPORT.FILE
*    EXP.LOG.PATH = R.GIT.TRANSPORT.FILE<GIT.TRA.FIL.OUT.PATH>
    EXP.LOG.ID   = 'EXP.':GIT.COM.OUT.PROCESS.ID

    IF SEL.LIST.COMP THEN
        CHANGE @FM TO ',' IN SEL.LIST.COMP ;*R22 AUTO CONVERSION
        R.EXP.LOG<-1> = 'Branch ':SEL.LIST.COMP:' has not processed any transactions'
    END

    IF Y.TOT.EXP.DB.AMT NE Y.TOT.EXP.CR.AMT THEN
        R.EXP.LOG<-1> = 'Credits of ':Y.TOT.EXP.CR.AMT:' not equal to Debits of ':Y.TOT.EXP.DB.AMT
    END

    IF Y.SAP.CP.ERR THEN
        R.EXP.LOG<-1> = 'Sap Account number is not present'
    END

    GOSUB WRITE.EXP.LOG

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.COMP.DETAILS:
*****************
    GOSUB READ.COMPANY
    GOSUB FIND.MULTI.LOCAL.REF

    Y.SAP.COST.CENTRE = R.COMPANY.REC<EB.COM.LOCAL.REF,LOC.L.CO.EXT.GL.CC.POS>

RETURN
*--------------------------------------------------------------------------------------------------------
***********************
READ.GIT.INTERFACE.OUT:
***********************
    R.GIT.INTERFACE.OUT  = ''
    GIT.INTERFACE.OUT.ER = ''
    CALL F.READ(FN.GIT.INTERFACE.OUT,GIT.INTERFACE.OUT.ID,R.GIT.INTERFACE.OUT,F.GIT.INTERFACE.OUT,GIT.INTERFACE.OUT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************************
READ.REDO.GL.H.EXTRACT.PARAMETER:
*********************************
    R.REDO.GL.H.EXTRACT.PARAMETER  = ''
    REDO.GL.H.EXTRACT.PARAMETER.ER = ''
    CALL CACHE.READ(FN.REDO.GL.H.EXTRACT.PARAMETER,REDO.GL.H.EXTRACT.PARAMETER.ID,R.REDO.GL.H.EXTRACT.PARAMETER,REDO.GL.H.EXTRACT.PARAMETER.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.COMPANY:
*************
    R.COMPANY.REC  = ''
    COMPANY.ER     = ''
*  CALL F.READ(FN.COMPANY,Y.COMPANY.ID,R.COMPANY.REC,F.COMPANY,COMPANY.ER)  ;* TUS Start
    CALL CACHE.READ(FN.COMPANY,Y.COMPANY.ID,R.COMPANY.REC,COMPANY.ER)    ;* TUS End

RETURN
*--------------------------------------------------------------------------------------------------------
************************
READ.GIT.TRANSPORT.FILE:
************************
    R.GIT.TRANSPORT.FILE.REC  = ''
    GIT.TRANSPORT.FILE.ER     = ''
    CALL F.READ(FN.GIT.TRANSPORT.FILE,GIT.TRANSPORT.FILE.ID,R.GIT.TRANSPORT.FILE,F.GIT.TRANSPORT.FILE,GIT.TRANSPORT.FILE.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
**************
WRITE.EXP.LOG:
**************
*    OPEN '',EXP.LOG.PATH TO F.EXP.LOG THEN
*    END
*    WRITE R.EXP.LOG TO F.EXP.LOG,EXP.LOG.ID

*    Y.BACKUP.PATH=R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.BACKUP.PATH>
*    OPEN '',Y.BACKUP.PATH TO F.BACKUP.PATH THEN
*    END
*    WRITE R.EXP.LOG TO F.BACKUP.PATH,EXP.LOG.ID

    Y.RESP.ERR =R.EXP.LOG
    INT.CODE = 'SAP002'
    IF RUNNING.UNDER.BATCH THEN
        INT.TYPE='BATCH'
    END
    ELSE
        INT.TYPE = 'ONLINE'
    END
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = 'REDO.H.GL.EXTRACT.PARAMETER'
    MON.TP = '04'
    CHANGE @FM TO '&' IN Y.RESP.ERR ;*R22 AUTO CONVERSION
    DESC = Y.RESP.ERR
    REC.CON = Y.RESP.ERR
    EX.USER = ''
    EX.PC = ''
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*R22 MANUAL CONVERSION
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'COMPANY'
    FLD.ARRAY  = 'L.CO.EXT.GL.CC'
    FLD.POS    = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.CO.EXT.GL.CC.POS =  FLD.POS<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* ENd of Program
