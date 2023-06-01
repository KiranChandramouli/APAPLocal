* @ValidationCode : MjotMjEzODE0Mzc4MjpDcDEyNTI6MTY4NTYxODcyNjUyNzpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 01 Jun 2023 16:55:26
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
$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.COMM.LOAN.SECTOR.EXT(REC.ID)
*----------------------------------------------------------------------------
* Company Name   : APAP
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.COMMERCIAL.LOAN.SECTOR.EXTRACT
* Date           : 16-May-2013
*----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the AA Commercial loans happened on daily basis
*----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
* 03-Oct-2014  Ashokkumar.V.P       PACS00305229:- Displaying Credit lines details
* 12-May-2015  Ashokkumar.V.P       PACS00305229:- Added new fields mapping change
* 10-Jun-2015  Ashokkumar.V.P       PACS00459382:- Removed the closed loan and NAB account created on same date
* 26-Jun-2015  Ashokkumar.V.P       PACS00466618:- Fixed the NAB account created on same date for old NAB loans.
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   T24.BP & LAPAP.BP  is removed , VM to@VM
*24-04-2023       HARISHVIKRAM C           MANUAL R22 CODE CONVERSION    CALL routine format modified, YLST.TODAY added in Insert file I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON

*----------------------------------------------------------------------------------------

*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.EB.CONTRACT.BALANCES;* Added by M.Medina
    $INSERT I_F.RE.STAT.REP.LINE;* Added by M.Medina
    $INSERT I_F.AA.PRODUCT.GROUP
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.ACCOUNT
    $INSERT I_F.DATES
*   $INSERT I_F.AA.ACCOUNT
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.COMMON ;*R22 AUTO CODE CONVERSION
*
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------------
PROCESS:
*------*
    YCOMM.FLG = 0; CNT.LINE = 0
    GOSUB PROCESS.INIT
    CALL F.READ(FN.AA.ARRANGEMENT,REC.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ERR)
    IF NOT(R.AA.ARRANGEMENT) THEN
        RETURN
    END
    YAA.PROD = R.AA.ARRANGEMENT<AA.ARR.PRODUCT,1>
    YAA.PROD.GRP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    YAA.ARR.STAT = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
    STAR.DATE.VAL = R.AA.ARRANGEMENT<AA.ARR.START.DATE>
    ACCOUNT.ID = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID,1>
    NU.LOAN.PRINT = ACCOUNT.ID
    IF STAR.DATE.VAL GT YLST.TODAY THEN
        RETURN
    END

    IF YAA.ARR.STAT NE 'CURRENT' AND YAA.ARR.STAT NE 'EXPIRED' THEN
        RETURN
    END

    LOCATE YAA.PROD IN Y.TXNLINPD.VAL.ARR<1,1> SETTING TXNCE.POS ELSE
        YCOMM.FLG = 1
    END

    IF YCOMM.FLG EQ 1 AND YAA.PROD.GRP EQ "LINEAS.DE.CREDITO" THEN
        RETURN
    END
    ARRAY.VAL = ''; Y.LOAN.STATUS = ''; Y.CLOSE.LN.FLG = 0
    APAP.LAPAP.redoRptClseWriteLoans(REC.ID,R.AA.ARRANGEMENT,ARRAY.VAL) ;*MANUAL R22 CODE CONVERSION
    Y.LOAN.STATUS = ARRAY.VAL<1>
    Y.CLOSE.LN.FLG = ARRAY.VAL<2>
    IF Y.LOAN.STATUS EQ "Write-off" THEN
        RETURN
    END
    IF Y.CLOSE.LN.FLG EQ 1 THEN
        RETURN
    END

    GOSUB GET.ARR.DETAILS     ;* added by M.Medina
    CUS.ID = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    IF R.CUSTOMER THEN
        GOSUB GET.CUST.DETAIL ;* Added by M.Medina
    END
    GOSUB AA.ACCOUNT.READ
    GOSUB GET.INTEREST.RATE
    GOSUB GET.ACC.ACCOUNT
    GOSUB ACC.NAB.PROCESS
    GOSUB RUN.PROCESS
RETURN
*----------------------------------------------------------------------------
GET.ACC.ACCOUNT:
****************
*
    IF ACCOUNT.ID EQ '' THEN
        RETURN
    END
    R.ACCOUNT = ''; ERR.ACCOUNT = ''; YNAB.STATUS = ''; YPRINCIP.GRP = 0; YACCT.GRP = 0
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    YNAB.STATUS = R.ACCOUNT<AC.LOCAL.REF,L.OD.STATUS.POS>
    CALL F.READ(FN.EB.CONTRACT.BALANCES,ACCOUNT.ID,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES,EB.CONTRACT.BALANCES.ERR)
    IF R.EB.CONTRACT.BALANCES THEN
        Y.CONSOL.KEY = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>
        Y.CONSOL.PART = FIELD(Y.CONSOL.KEY,'.',1,16)
        Y.ASSET.TYPE = R.EB.CONTRACT.BALANCES<ECB.CURR.ASSET.TYPE>
        CTR.BAL.TYPE = 1
        CNT.BAL.TYPE = DCOUNT(Y.ASSET.TYPE,@VM)
        LOOP
        WHILE CTR.BAL.TYPE LE CNT.BAL.TYPE
            ACC.POS = ''
            BAL.TYPE1 = Y.ASSET.TYPE<1,CTR.BAL.TYPE>
            LEN.TYPE = LEN(BAL.TYPE1)
            REQ.LEN = BAL.TYPE1[((LEN.TYPE-AC.LEN)+1),AC.LEN]
            REQ.INT.LEN = BAL.TYPE1[((LEN.TYPE-PRIN.INT.LEN)+1),PRIN.INT.LEN]
            IF (REQ.LEN EQ 'ACCOUNT') OR (REQ.INT.LEN EQ 'PRINCIPALINT') THEN
                Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':BAL.TYPE1         ;*alter the consol key with current balance type in analysis
                Y.VARIABLE = ''
                CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
                Y.LINE = Y.RPRTS:'.':Y.LINES
                CALL F.READ(FN.RE.STAT.REP.LINE,Y.LINE,R.LINE,F.RE.STAT.REP.LINE,REP.ERR)
                GOSUB REG.ACCOUNT.NO
            END
*
            CTR.BAL.TYPE += 1
        REPEAT
    END
RETURN

REG.ACCOUNT.NO:
***************
    IF NOT(R.LINE) THEN
        RETURN
    END
    Y.REGULATORY.ACC.NO = R.LINE<RE.SRL.DESC,1>   ;* get accounting account for the current balance type in analysis
    LOCATE Y.REGULATORY.ACC.NO IN SAVE.ACC.AC<1> SETTING ACC.POS THEN
        GOSUB CHECK.ASSET.TYPE
    END ELSE
        GOSUB SAVE.UNIQUE.AC.ACC
    END
    IF REQ.LEN EQ 'ACCOUNT' THEN
        YACCT.GRP += DAT.BALANCES
    END
    IF REQ.LEN EQ 'PRINCIPALINT' THEN
        YPRINCIP.GRP += DAT.BALANCES
    END
RETURN

SAVE.UNIQUE.AC.ACC:
*******************
*
    SAVE.ACC.AC<-1> = Y.REGULATORY.ACC.NO
    CALL AA.GET.PERIOD.BALANCES(ACCOUNT.ID, BAL.TYPE1,REQUEST.TYPE, START.DATE, END.DATE, '',BAL.DETAILS, ERROR.MESSAGE)
    ASSET.TYPE.ARRAY<-1> = BAL.TYPE1
    DAT.BALANCES = BAL.DETAILS<4>
    BAL.AMT<-1> = DAT.BALANCES
RETURN

SAVE.EXISTING.AC.ACC:
*********************
*
    CALL AA.GET.PERIOD.BALANCES(ACCOUNT.ID, BAL.TYPE1,REQUEST.TYPE, START.DATE, END.DATE, '',BAL.DETAILS, ERROR.MESSAGE)
    DAT.BALANCES = BAL.DETAILS<4>
    NEW.AMT = DAT.BALANCES + BAL.AMT<ACC.POS>
    BAL.AMT<ACC.POS> = NEW.AMT
RETURN
*----------------------------------------------------------------------------
CHECK.ASSET.TYPE:
*****************
*
    LOCATE BAL.TYPE1 IN ASSET.TYPE.ARRAY<1> SETTING ASSET.POS THEN
        ASSET.POS = ''
    END ELSE
        ASSET.TYPE.ARRAY<-1> = BAL.TYPE1
        GOSUB SAVE.EXISTING.AC.ACC
    END
RETURN
*----------------------------------------------------------------------------
GET.INTEREST.RATE:
******************
*
    INT.ID = REC.ID:'-PRINCIPALINT'
    R.AA.INTEREST.ACCRUALS = ''
    AA.INTEREST.ACCRUALS.ERR = ''
    CALL F.READ(FN.AA.INTEREST.ACCRUALS,INT.ID,R.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS,AA.INTEREST.ACCRUALS.ERR)
    IF R.AA.INTEREST.ACCRUALS THEN
        INT.ACCRUAL.PRINT = R.AA.INTEREST.ACCRUALS<AA.INT.ACC.RATE,1> ;* Added by M.Medina, RATE field of the first multivalue
        IF INT.ACCRUAL.PRINT EQ '' THEN
            GOSUB GET.INT.RATE
        END
    END
RETURN
*----------------------------------------------------------------------------
RUN.PROCESS:
*----------*
    IF YACCT.GRP EQ 0 AND YPRINCIP.GRP NE 0 AND YCR.AMT NE 0 THEN
        RETURN
    END
    CTR.LINE = 1
    CNT.LINE = DCOUNT(SAVE.ACC.AC,@FM)
    LOOP
    WHILE CTR.LINE LE CNT.LINE
        ACC.NO.LINE = SAVE.ACC.AC<CTR.LINE>
        BAL.AMT.LINE = BAL.AMT<CTR.LINE>
        NOT.PRINT.INT.ACC = ACC.NO.LINE[1,1]
        IF BAL.AMT.LINE LT '0' THEN
            IF NOT.PRINT.INT.ACC EQ '8' THEN
                CTR.LINE += 1
                CONTINUE
            END
            YGL.CODE.TMP = ACC.NO.LINE
            AC.BAL.PRINT = ABS(BAL.AMT.LINE)
            GOSUB AC.ACCOUNT.PRINT.FORM
            TOT.SEC.PROD = 0
            IF SECT.PROD EQ "MICROEMPRESA" OR SECT.PROD EQ "SECTOR PRODUCTIVO" THEN
                TOT.SEC.PROD = AC.BAL.PRINT
            END
            RETURN.MSG = STRT.DATE.PRINT:'|':NU.LOAN.PRINT:'|':TERM.PRINT:'|':INT.ACCRUAL.PRINT:'|':CUST.NAME.PRINT:'|':CUST.ID.PRINT:'|':YGL.CODE.TMP:'|':AC.BAL.PRINT:'|':SECT.PROD:'|':TOT.SEC.PROD
            WRK.FILE.ID = REC.ID:'.':CTR.LINE
            CALL F.WRITE(FN.DR.REG.COM.LOAN.SECTOR.WORKFILE,WRK.FILE.ID,RETURN.MSG)
            WRK.FILE.ID = ''
        END
        CTR.LINE += 1
    REPEAT
RETURN

ACC.NAB.PROCESS:
****************
    ERR.AA.ACCOUNT.DETAILS = ''; R.AA.ACCOUNT.DETAILS = ''; SUSPEND.VAL = ''; SUSPEND.STAT = ''; SUSPEND.DTE = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,REC.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ERR.AA.ACCOUNT.DETAILS)
    SUSPEND.VAL = R.AA.ACCOUNT.DETAILS<AA.AD.SUSPENDED>
    SUSPEND.STAT = R.AA.ACCOUNT.DETAILS<AA.AD.SUSP.STATUS,1>
    SUSPEND.DTE = R.AA.ACCOUNT.DETAILS<AA.AD.SUSP.DATE,1>
    IF SUSPEND.STAT EQ 'SUSPEND' AND SUSPEND.DTE GT YLST.TODAY THEN
        RETURN
    END
    R.REDO.CONCAT.ACC.NAB = ''; NAB.ERR = ''; ERR.ACCOUNT = ''; R.ACCOUNT = ''; YNAB.STATUS = ''
    YCR.DTE = ''; YCR.AMT = 0
    CALL F.READ(FN.REDO.CONCAT.ACC.NAB,ACCOUNT.ID,R.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB,NAB.ERR)
    IF NOT(R.REDO.CONCAT.ACC.NAB) THEN
        RETURN
    END
    Y.ACCT.ID = ''; Y.ACCT.ID = R.REDO.CONCAT.ACC.NAB
    YCRF.TYPE = "OFFDB"; REQUEST.TYPE<4> = "ECB"
    START.DATE = YLST.TODAY; END.DATE = YLST.TODAY; BAL.DETAILS = 0; ERROR.MESSAGE = ''
    CALL AA.GET.PERIOD.BALANCES(Y.ACCT.ID, YCRF.TYPE,REQUEST.TYPE, START.DATE, END.DATE, '',BAL.DETAILS, ERROR.MESSAGE)
    YCR.AMT = BAL.DETAILS<4>
    YCR.AMT = ABS(YCR.AMT)
    YGL.CODE.TMP = ''; R.EB.CONTRACT.BALANCES = ''; Y.IN.CONSOL.KEY = ''
    CALL F.READ(FN.EB.CONTRACT.BALANCES,R.REDO.CONCAT.ACC.NAB,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES,EB.CONTRACT.BALANCES.ERR)
    IF NOT(R.EB.CONTRACT.BALANCES) THEN
        RETURN
    END
    Y.CONSOL.KEY = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>
    Y.CONSOL.PART = FIELD(Y.CONSOL.KEY,'.',1,16)
    Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':YCRF.TYPE
    Y.VARIABLE = ''; Y.RPRTS = ''; Y.LINES = ''
    CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
    Y.LINE = Y.RPRTS:'.':Y.LINES
    CALL F.READ(FN.RE.STAT.REP.LINE,Y.LINE,R.LINE,F.RE.STAT.REP.LINE,REP.ERR)
    YGL.CODE.TMP = R.LINE<RE.SRL.DESC,1>
    GOSUB AC.ACCOUNT.PRINT.FORM
    TOT.SEC.PROD = 0
    IF SECT.PROD EQ "MICROEMPRESA" OR SECT.PROD EQ "SECTOR PRODUCTIVO" THEN
        TOT.SEC.PROD = YCR.AMT
    END
    IF YCR.AMT NE 0 THEN
        RETURN.MSG = STRT.DATE.PRINT:'|':NU.LOAN.PRINT:'|':TERM.PRINT:'|':INT.ACCRUAL.PRINT:'|':CUST.NAME.PRINT:'|':CUST.ID.PRINT:'|':YGL.CODE.TMP:'|':YCR.AMT:'|':SECT.PROD:'|':TOT.SEC.PROD
        CNT.LINE += 15
        WRK.FILE.ID = REC.ID:'.':CNT.LINE
        CALL F.WRITE(FN.DR.REG.COM.LOAN.SECTOR.WORKFILE,WRK.FILE.ID,RETURN.MSG)
    END
RETURN

AC.ACCOUNT.PRINT.FORM:
**********************
    Y.STP1 = ''; YSTP1 = ''; Y.STP2 = ''; YSTP2 = ''; YFLD9 = ''
    SECT.PROD = ''
    YSTP1 = RIGHT(YGL.CODE.TMP,5)
    YSTP2 = RIGHT(YGL.CODE.TMP,8)
    YFLD9 = RIGHT(YGL.CODE.TMP,8)
    IF YSTP1 NE "04.02" THEN
        YGL.CODE.TMP:=FMT(GL.ST2,'R%2')
    END

    IF YSTP2 EQ "03.01.99" THEN
        YGL.CODE.TMP:=FMT(YORIGEN.RECURSOS,'R%2')
        IF Y.AA.LOAN THEN
            YGL.CODE.TMP:=FMT(Y.AA.LOAN,'R%2')
        END
    END
    CHANGE '.' TO '' IN YGL.CODE.TMP

    IF YFLD9 EQ "03.02.01" THEN
        SECT.PROD = "MICROEMPRESA"
    END ELSE
        IF Y.AA.LOAN MATCHES '01':@VM:'02':@VM:'04':@VM:'06' THEN
            SECT.PROD = "SECTOR PRODUCTIVO"
        END ELSE
            SECT.PROD = "SECTOR NO PRODUCTIVO"
        END
    END
RETURN

GET.INT.RATE:
************
    ArrangementID = REC.ID
    idPropertyClass = 'INTEREST'
    idProperty = ''
    effectiveDate = ''
    returnIds = ''
    returnConditions = ''
    returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    INT.REC = RAISE(returnConditions)
    CNT.RATE = DCOUNT(INT.REC<AA.INT.EFFECTIVE.RATE>,'VM')
    INT.ACCRUAL.PRINT = INT.REC<AA.INT.EFFECTIVE.RATE,CNT.RATE>
RETURN
*----------------------------------------------------------------------------
GET.ARR.DETAILS:    *start - Added by Mauricio M.
*--------------*
*Fecha_Valida
    STRT.DATE = LAST.WORK.DAY ;*Come from DR.REG.COMM.LOAN.SECTOR.EXT.SELECT
    GOSUB DATE.FORMAT
    GOSUB GET.LOAN.TERM
RETURN

GET.LOAN.TERM:
**************
    TERM.AMT.ID = REC.ID:'-COMMITMENT-':STAR.DATE.VAL:'.1'
    CALL F.READ(FN.AA.ARR.TERM.AMOUNT,TERM.AMT.ID,R.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT,AA.ARR.TERM.AMOUNT.ERR)
    IF R.AA.ARR.TERM.AMOUNT THEN
        TERM = R.AA.ARR.TERM.AMOUNT<AA.AMT.TERM>
        GOSUB TERM.FORMAT
    END
RETURN
*----------------------------------------------------------------------------
PROCESS.INIT1:
*************
    R.AA.ARRANGEMENT = ''
    AA.ARRANGEMENT.ERR = ''
    REQUEST.TYPE = ''
    R.CUSTOMER = ''
    CUSTOMER.ERR = ''
    START.DATE = ''
    START.DATE = STAR.DATE.VAL
    END.DATE = LAST.WORK.DAY
    REQUEST.TYPE<4>='ECB'
    STRT.DATE.PRINT = ''
    NU.LOAN.PRINT = ''
    CUST.NAME.PRINT = ''
    CUST.ID.PRINT = ''
    INT.ACCRUAL.PRINT = ''
    AC.BAL.PRINT = ''
    AC.ACCOUNT.PRINT = ''
    AC.INTEREST.PRINT = ''
    LINK.POS = ''
    STRT.DATE = ''
    ACCOUNT.ID = ''
    LEN.TERM = ''
    D.PART = ''
    TERM.PRINT = ''
    ASSET.TYPE.ARRAY = ''
RETURN
*----------------------------------------------------------------------------
PROCESS.INIT:
*************
    GOSUB PROCESS.INIT1
    YAA.PROD = ''
    R.AA.ARR.TERM.AMOUNT = ''
    AA.ARR.TERM.AMOUNT.ERR = ''
    SAVE.ACC.AC = ''
    BAL.AMT = ''
    R.EB.CONTRACT.BALANCES = ''
    EB.CONTRACT.BALANCES.ERR = ''
    AC.LEN = 7      ;* This is length of word 'ACCOUNT'
    PRIN.INT.LEN = 12         ;* This is length of word 'PRINCIPALINT'
    YAA.PROD = ''; YAA.PROD.GRP = ''; YAA.ARR.STAT = ''
RETURN
*----------------------------------------------------------------------------
GET.CUST.DETAIL:
****************
*
*NOMBRE_COMPLETO
    L.CU.TIPO.CL.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS>
    BEGIN CASE
        CASE L.CU.TIPO.CL.VAL EQ 'PERSONA FISICA'
            CUSTOMER.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
        CASE L.CU.TIPO.CL.VAL EQ 'CLIENTE MENOR'
            CUSTOMER.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
        CASE L.CU.TIPO.CL.VAL EQ 'PERSONA JURIDICA'
            CUSTOMER.NAME = R.CUSTOMER<EB.CUS.NAME.1>:' ':R.CUSTOMER<EB.CUS.NAME.2>
    END CASE
*
    CUST.NAME.PRINT = CUSTOMER.NAME
    GOSUB GET.CUST.ID
RETURN
*----------------------------------------------------------------------------
GET.CUST.ID:
************
*NUMERO_IDENTIFICACION
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS> THEN
        CUSTOMER.ID = R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
        CUST.ID.PRINT = CUSTOMER.ID[1,3]:'-':CUSTOMER.ID[4,7]:'-':CUSTOMER.ID[11,1]
    END ELSE
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS> THEN
            CUSTOMER.ID = R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS>
            CUST.ID.PRINT = CUSTOMER.ID[1,1]:'-':CUSTOMER.ID[2,2]:'-':CUSTOMER.ID[4,5]:'-':CUSTOMER.ID[9,1]
        END ELSE
            CUST.ID.PRINT = R.CUSTOMER<EB.CUS.NATIONALITY>:R.CUSTOMER<EB.CUS.LEGAL.ID,1>
        END
    END
RETURN
*----------------------------------------------------------------------------
DATE.FORMAT:        *FORMAT VALUES
*--------*
    IF STRT.DATE THEN         ;*Fecha_valida
        STRT.DATE.PRINT = STRT.DATE[7,2]:'/':STRT.DATE[5,2]:'/':STRT.DATE[1,4]
    END
RETURN

AA.ACCOUNT.READ:
*---------------
    ARRANGEMENT.ID = REC.ID ; R.AA.ACCOUNT.APP = ''; Y.ORIGEN.RECURSOS = ''; Y.AA.LOAN = ''
    PROP.CLASS = 'ACCOUNT'; PROP.NAME = ''; RET.ERR = ''; returnConditions = '' ; YORIGEN.RECURSOS = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARRANGEMENT.ID,PROP.CLASS,PROP.NAME,'','',returnConditions,RET.ERR)
    R.AA.ACCOUNT.APP = RAISE(returnConditions)
    Y.ORIGEN.RECURSOS = R.AA.ACCOUNT.APP<AA.AC.LOCAL.REF,ORIGEN.RECURSOS.POS>
    Y.AA.LOAN = R.AA.ACCOUNT.APP<AA.AC.LOCAL.REF,L.AA.LOAN.DSN.POS>
    IF Y.ORIGEN.RECURSOS EQ '01' THEN
        YORIGEN.RECURSOS = '01'
    END
    IF Y.ORIGEN.RECURSOS NE '01' AND Y.ORIGEN.RECURSOS NE '' THEN
        YORIGEN.RECURSOS = '02'
    END
RETURN

TERM.FORMAT:        *FORMAT VALUES
*--------*
    LEN.TERM = LEN(TERM)
    D.PART = LEN.TERM - 1
    IF TERM[LEN.TERM,1] EQ 'D' THEN
        TERM.IN.DAYS = TERM[1,D.PART]
    END ELSE
        MAT.DATE = R.AA.ARR.TERM.AMOUNT<AA.AMT.MATURITY.DATE>
        ID.COM3 = FIELD(R.AA.ARR.TERM.AMOUNT<AA.AMT.ID.COMP.3>,'.',1)
        IF MAT.DATE AND ID.COM3 THEN
            Y.REGION = ''
            Y.DAYS   = 'C'
            CALL CDD(Y.REGION, MAT.DATE, ID.COM3, Y.DAYS)
            TERM.IN.DAYS = ABS(Y.DAYS)
        END ELSE
            TERM.IN.DAYS = ''
        END
    END
    TERM.PRINT = TERM.IN.DAYS
    GOSUB GET.TERM.GRP
RETURN

GET.TERM.GRP:
*************
    GL.ST2 = ''
    IF TERM.PRINT LE 365 THEN
        GL.ST2 = '01'
    END

    IF TERM.PRINT GT 365 AND TERM.PRINT LT 1825 THEN
        GL.ST2 = '02'
    END
    IF TERM.PRINT GE 1825 THEN
        GL.ST2 = '03'
    END
RETURN
*
END
