* @ValidationCode : MjotNjA2NDM2MTU2OkNwMTI1MjoxNjg0ODU0NDAyNDg2OklUU1M6LTE6LTE6MTI0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 124
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.VALID.ACCOUNTS(SEL.ACCT.LIST)

******************************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : NATCHIMUTHU
* Program Name  : REDO.BRR.INWRETURN.PROCESS
* ODR           : ODR-2010-09-0171
*----------------------------------------------------------------------------
* DESCRIPTION  : REDO.BRR.INWRETURN.PROCESS Multithreading routine responsible for generates
*  flat file with account ID, status with name obtained from parameter file F.REDO.ACCT.STATUS.CODE
* .Agent no obtained from I_BATCH.FILES
*-----------------------------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE          DESCRIPTION
* 08.10.2010     NATCHIMUTHU     ODR-2010-09-0171   INITIAL CREATION
* Date                   who                   Reference              
* 17-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - SESSION.NO TO AGENT.NUMBER AND ADD I_TSA.COMMON
* 17-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*
*------------------------------------------------------------------------------------------
    $INSERT I_TSA.COMMON  ;*R22 AUTO CONVERSTION ADD I_TSA.COMMON
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_F.REDO.ACCT.STATUS.CODE
    $INSERT I_REDO.B.VALID.ACCOUNTS.COMMON

    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.INTERFACE.ACT
    $INSERT I_F.REDO.INTERFACE.ACT.DETAILS
    $INSERT I_F.REDO.INTERFACE.NOTIFY
    $INSERT I_F.REDO.INTERFACE.MON.TYPE
    $INSERT I_F.REDO.INTERFACE.SMAIL
    $INSERT I_F.LOCKING
    $INSERT I_F.REDO.APAP.CLEAR.PARAM


    GOSUB PROCESS

RETURN

*---------------------------------------------------------------------------------------------------------------------------------------
PROCESS:
*********

    TOT.ACCT.CNTR = ''
    LOOP.CNTR = ''
    WT.FINAL.ARRAY = ''


*    TOT.ACCT.CNTR = DCOUNT(SEL.ACCT.LIST,"/")
*    LOOP.CNTR = 1

*    LOOP
*    WHILE LOOP.CNTR LE TOT.ACCT.CNTR

    GOSUB CLEAR.VARIABLES

*        Y.ACCT.NO = FIELD(SEL.ACCT.LIST,"/",LOOP.CNTR)
    Y.STS = ''
    Y.ACCT.NO = SEL.ACCT.LIST
    AC.CHECK.DIGIT = ''
    Y.STATUS.CODE=''
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF NOT(R.ACCOUNT) THEN
        CALL EB.READ.HISTORY.REC(F.AC.HIS,Y.ACCT.NO,R.ACCOUNT,YERROR)
        Y.ACCT.NO = FIELD(Y.ACCT.NO,';',1)
        Y.CAT = R.ACCOUNT<AC.CATEGORY>
        LOCATE Y.CAT IN Y.CATEG.APERTA SETTING PLO ELSE
            RETURN
        END
    END

    IF R.ACCOUNT<AC.CLOSURE.DATE> EQ '' THEN
        Y.STATUS.CLS = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.AC.OPEN.CODE>
    END ELSE
        Y.STATUS.CLS = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.AC.CLOSE.CODE>
    END

    CURRENCY = R.ACCOUNT<AC.CURRENCY>
    CATEGORY = R.ACCOUNT<AC.CATEGORY>
** LOCATE CATEGORY IN Y.CATEG.APERTA<1> SETTING POS.CATEG ELSE

**    RETURN

** END
    Y.CUST.ID      = R.ACCOUNT<AC.CUSTOMER>
    Y.STATUS2.LIST = R.ACCOUNT<AC.LOCAL.REF,AC.STATUS2.POS>
    AC.CHECK.DIGIT = R.ACCOUNT<AC.LOCAL.REF,AC.CHK.DIG.POS>

    ALT.ACCT.ID = R.ACCOUNT<AC.ALT.ACCT.ID>

    GOSUB GET.STATUS.CODE

    GOSUB CALC.FINAL.ACCT

    Y.STATUS.CODE1 = Y.STATUS.CODE
    Y.STATUS.CODE1 = FMT(Y.STATUS.CODE1,'4"0"R')

    Y.FINAL.ARRAY = ''

    Y.FINAL.ARRAY = Y.ACCT.NO1:",":Y.STATUS.C

    GET.FILE.NAME1 = FIELD(CCY.FILE.NAME,'.',1)
    GET.FILE.NAME2 = FIELD(CCY.FILE.NAME,'.',2)

    PYMNT.FILE = TODAY:GET.FILE.NAME1:CURRENCY:".":GET.FILE.NAME2:"_":AGENT.NUMBER ;*R22 AUTO CONVERSTION SESSION.NO TO AGENT.NUMBER

*    HEADR.PART = 'UPDATEMATCH,DATE=':TODAY:',TABLE=CuentasValidas,WORKSOURCE=20'

*  GOSUB OPEN.DATA.FILE

*   IF LOOP.CNTR = 1 THEN
*       WT.FINAL.ARRAY = HEADR.PART
*       GOSUB WRITE.DATA.FILE
*   END
*    LOCATE CATEGORY IN Y.CATEG.APERTA<1> SETTING POS.CATEG THEN
    WT.FINAL.ARRAY = Y.FINAL.ARRAY
    GOSUB WRITE.DATA.FILE
*    END
*LOOP.CNTR += 1

*REPEAT

RETURN
*--------------------------------------------
*OPEN.DATA.FILE:

*  OPENSEQ CCY.OUT.PATH,PYMNT.FILE TO F.FILE.NAME ELSE
*      CREATE F.FILE.NAME ELSE
*          OPEN.ERR = 'Unable to Open / Create ':CCY.OUT.PATH:" " PYMNT.FILE
*          RETURN
*          CALL EXCEPTION.LOG("S","FT","CREATE.CRP.FILE","","001","",CCY.OUT.PATH,PYM NT.FILE,"",OPEN.ERR,"")
*      END
*  END


* RETURN
*--------------------------------------------
WRITE.DATA.FILE:

    WRITESEQ WT.FINAL.ARRAY APPEND TO F.FILE.NAME ELSE
        WRITE.ERR = 'Unable to Write ':CCY.OUT.PATH:" ":PYMNT.FILE
        CALL EXCEPTION.LOG("S","FT","CREATE.CRP.FILE","","001","",CCY.OUT.PATH,PYMNT.FILE,"",WRITE.ERR,"")
        RETURN
    END

RETURN
*------------------
CLEAR.VARIABLES:

    Y.CHG.DIGIT = ''
    Y.L.CU.CIDENT = ''
    Y.L.CU.NOUNICO = ''
    Y.L.CU.RNC = ''
    Y.L.CU.ACTANAC = ''
    Y.ACCT.NO = ''
    CURRENCY = ''
    Y.CUST.ID = ''
    Y.STATUS2.LIST = ''
    Y.CHG.DIGIT.TO.ZER = ''
    Y.CHG.DIGIT.FR.ZER = ''
    Y.CHG.ORG.DIGIT = ''

RETURN
*----------------------------

GET.STATUS.CODE:

    LOCATE Y.STATUS2.LIST IN Y.REDO.PREVAL.STATUS<1,1> SETTING POS1 THEN
        Y.STATUS.CODE = R.REDO.ACCT.STATUS.CODE<REDO.ACCT.STATUS.STATUS.CODE,POS1>
        INT.CODE ='APA004'
        INT.TYPE ='BATCH'
        BAT.NO =''
        BAT.TOT =''
        INFO.OR =''
        INFO.DE =''
        ID.PROC = Y.ACCT.NO
        MON.TP ='01'
        DESC = 'STATUS CODE MATCHED IN REDO.ACCOUNT.STATUS.CODE'
        REC.CON = ''
        EX.USER = ''
        EX.PC = ''
*  CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END ELSE
        INT.CODE ='APA004'
        INT.TYPE ='BATCH'
        BAT.NO =''
        BAT.TOT =''
        INFO.OR =''
        INFO.DE =''
        ID.PROC = Y.ACCT.NO
        MON.TP ='03'
        DESC = 'STATUS CODE NOT MATCHED IN REDO.ACCOUNT.STATUS.CODE'
        REC.CON = ''
        EX.USER = ''
        EX.PC = ''
* CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END

* RETURN
*------------------
GET.ACCT.CODE:

    Y.CHG.DIGIT.TOT.ZER = ''
    CALL F.READ(FN.CUSTOMER,Y.CUST.ID,R.CUSTOMER,F.CUSTOMER,CUST.ERR)

    Y.L.CU.CIDENT    = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.CIDENT.POS>
    Y.L.CU.NOUNICO   = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.NOUNICO.POS>
    Y.L.CU.RNC       = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.RNC.POS>
    Y.L.CU.ACTANAC   = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.ACTANAC.POS>


    BEGIN CASE

        CASE Y.L.CU.CIDENT
            Y.CHG.DIGIT = Y.L.CU.CIDENT

        CASE Y.L.CU.NOUNICO
            Y.CHG.DIGIT = Y.L.CU.NOUNICO

        CASE Y.L.CU.RNC
            Y.CHG.DIGIT = Y.L.CU.RNC

        CASE Y.L.CU.ACTANAC
            Y.CHG.DIGIT = Y.L.CU.ACTANAC

    END CASE


RETURN
*------------------
CALC.FINAL.ACCT:

    IF CATEGORY GE 1000 AND CATEGORY LE 1999 THEN

        Y.CHG.DIGIT.FR.ZER = FMT(Y.ACCT.NO,'11"0"R')
        Y.CHG.DIGIT.TO.ZER = FMT(AC.CHECK.DIGIT,'2"0"R')
*       Y.ACCT.NO1 = Y.CHG.DIGIT.FR.ZER:Y.CHG.DIGIT.TO.ZER
        Y.ACCT.NO1 = Y.CHG.DIGIT.FR.ZER
        Y.STATUS.C = Y.CHG.DIGIT.TO.ZER:Y.STATUS.CLS

    END ELSE

        IF Y.CUST.ID THEN
            GOSUB GET.ACCT.CODE
            IF Y.CHG.DIGIT THEN
                Y.CHG.DIGIT.CNT = LEN(Y.CHG.DIGIT)
                Y.CHG.ORG.DIGIT = Y.CHG.DIGIT[Y.CHG.DIGIT.CNT,1]
                Y.CHG.DIGIT.FR.ZER = FMT(Y.ACCT.NO,'11"0"R')
                Y.CHG.DIGIT.TO.ZER = FMT(Y.CHG.ORG.DIGIT,'2"0"R')
*                Y.ACCT.NO1 = Y.CHG.DIGIT.FR.ZER:Y.CHG.DIGIT.TO.ZER
                Y.ACCT.NO1 = Y.CHG.DIGIT.FR.ZER
                Y.STATUS.C = Y.CHG.DIGIT.TO.ZER:Y.STATUS.CLS
            END ELSE
                Y.CHG.DIGIT.FR.ZER = FMT(Y.ACCT.NO,'11"0"R')
                Y.CHG.DIGIT.TO.ZER = FMT(Y.CHG.ORG.DIGIT,'2"0"R')
*                Y.ACCT.NO1 = Y.CHG.DIGIT.FR.ZER:Y.CHG.DIGIT.TO.ZER
                Y.ACCT.NO1 = Y.CHG.DIGIT.FR.ZER
                Y.STATUS.C = Y.CHG.DIGIT.TO.ZER:Y.STATUS.CLS
            END
        END
*ELSE
*            Y.ACCT.NO1 = FMT(ALT.ACCT.ID,'13"0"L')
*       END
    END

RETURN
*-------------------------

END
