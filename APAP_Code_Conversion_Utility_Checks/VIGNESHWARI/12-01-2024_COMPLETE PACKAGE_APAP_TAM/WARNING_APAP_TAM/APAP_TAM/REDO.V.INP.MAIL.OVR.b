* @ValidationCode : MjoxNzg4OTMxNDQzOkNwMTI1MjoxNzA1MDQ4MjgyNDIyOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Jan 2024 14:01:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE REDO.V.INP.MAIL.OVR
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: INPUT routine
*------------
*DESCRIPTION:
*------------
* This is Input routine attached to the versions of FX, TT and FT. The routine
* is used to raise override based on settings mentioned in the FX.PRAMETER table and
* is used to send mail to appropriate user regardings the transaction status
*---------------------------------------------------------------------------
* Input / Output
*----------------
*
* Input / Output
* IN     : -na-
* OUT    : -na-
*
*-------------------------------------------------------------------------------------------------------------
* Revision History
* Date          Who               Reference           Description
* 23-NOV-2010   A.SabariKumar     ODR-2010-07-0075    Initial Creation
* 24-MAR-2011   A.SabariKumar     PACS00038161        HD FIX
* 07-JUL-2011   Pradeep S         PACS00082438        Branch Limit logic included for Forex module
*                                                     Core Review changes - F.READ Changed to CACHE.READ
* 09-SEP-2011   Marimuthu S       PACS00121111        Override blocked
* 20-OCT-2011   Pradeep S         PACS00149084        Branch validations included
*                                                     Removed hordcode for E-Mail descriptions
*                                                     Mapped thru parameter tables
* 19-JAN-2012   Pradeep S         PACS00176059        Process only for FXSN number transaction.
* 30-AUG-2013   Vignesh Kumaar R  PACS00289159        FX Override shouldn't be raised for the TT cheque version
* 03-AUG-2014   Vignesh Kumaar R  PACS00384795        POSITION LIMIT HAS TO BE BASED ON THE SELL
* 14-AUG-2014   Vignesh Kumaar R  PACS00395700        OVERALL POSITION LIMIT EXCEED OVERRIDE GENERATES WRONGLY
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,FM TO @FM,SM TO @SM, F.READ TO CACHE.READ
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION  CALL RTN FORMAT MODIFIED
*--------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.FOREX
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.FX.PARAMETERS
    $INSERT I_GTS.COMMON
    $INSERT I_F.COMPANY
    $INSERT I_F.ACCOUNT
*
    $INSERT I_F.REDO.APAP.FX.BRN.COND
    $INSERT I_F.REDO.APAP.FX.BRN.POSN
    $INSERT I_F.REDO.INTERFACE.SMAIL
    $INSERT I_F.REDO.ISSUE.EMAIL
    $INSERT I_F.REDO.APAP.PARAM.EMAIL
    $INSERT I_F.REDO.FXSN.TXN.VERSION
    $INSERT I_REDO.FX.OVR.COMMON
    $USING APAP.REDOVER

    IF V$FUNCTION MATCHES "D":@VM:"R" ELSE ;*R22 AUTO CONVERSION
        GOSUB INITIALISE
        GOSUB PRE.CHECK
        IF PROCESS.GOHEAD THEN
            GOSUB PROCESS
        END
    END

RETURN

*---------------------------------------------------------------------------
INITIALISE:
*------------
*Initialise/Open necessary varibles/files

    FLD.POS = ''
    PARAM.ERR = ''
    Y.LT.ID = ''
    Y.OVERALL.POSN = ''
    R.BRN.COND = ''
    Y.FX.POSN = ''
    Y.POSN.FLAG = ''
    Y.CURR.NO = ''
    Y.TIME.TO.WRITE = ''
    Y.FIRST.OVR.VAL = ''
    R.FX.PARAM = ''
    Y.PRE.APPLICATION = APPLICATION
    Y.ACTUAL.END.TIMING = ''
    Y.HOUR.ALONE = ''
    Y.HOUR.MIN = ''
    Y.OVERALL.TIME = ''

    FN.FX.PARAMETERS = 'F.FX.PARAMETERS'
    F.FX.PARAMETERS = ''
    CALL OPF(FN.FX.PARAMETERS,F.FX.PARAMETERS)

    FN.REDO.APAP.FX.BRN.COND = 'F.REDO.APAP.FX.BRN.COND'
    F.REDO.APAP.FX.BRN.COND = ''
    CALL OPF(FN.REDO.APAP.FX.BRN.COND,F.REDO.APAP.FX.BRN.COND)

    FN.REDO.APAP.FX.BRN.POSN = 'F.REDO.APAP.FX.BRN.POSN'
    F.REDO.APAP.FX.BRN.POSN = ''
    CALL OPF(FN.REDO.APAP.FX.BRN.POSN,F.REDO.APAP.FX.BRN.POSN)

    FN.FOREX = 'F.FOREX'
    F.FOREX = ''
    CALL OPF(FN.FOREX,F.FOREX)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.REDO.APAP.PARAM.EMAIL = 'F.REDO.APAP.PARAM.EMAIL'
    F.REDO.APAP.PARAM.EMAIL = ''
    CALL OPF(FN.REDO.APAP.PARAM.EMAIL,F.REDO.APAP.PARAM.EMAIL)

    FN.REDO.ISSUE.EMAIL = 'F.REDO.ISSUE.EMAIL'
    F.REDO.ISSUE.EMAIL = ''
    CALL OPF(FN.REDO.ISSUE.EMAIL,F.REDO.ISSUE.EMAIL)
    R.REDO.ISSUE.EMAIL = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.COMP = 'F.COMPANY'
    F.COMP = ''
    CALL OPF(FN.COMP,F.COMP)

    FN.FXSN.VERSION = 'F.REDO.FXSN.TXN.VERSION'
    F.FXSN.VERSION = ''
    CALL OPF(FN.FXSN.VERSION,F.FXSN.VERSION)

RETURN

*---------------------------------------------------------------------------
PROCESS:
*------------
* The section identifies the application and calculetes the USD amount involved in the transaction
* and compares the same with REDO.APAP.FX.BRN.COND template field OVERALL.POSN and raise override
* and sends message on certain.conditions

    GOSUB GET.PARAM.TIME
    GOSUB GET.LT.VALUES1
    GOSUB GET.LT.VALUES2

*APAP.REDOVER.redoVCallUsdEqv(Y.USD.AMOUNT,Y.REC.STATUS,Y.CURR.NO) ;* R22 Manual conversion - CALL method format changed
    APAP.REDOVER.redoVCallUsdEqv(Y.USD.AMOUNT,Y.REC.STATUS,Y.CURR.NO) ;*R22 MANUAL CODE CONVERSION

    GOSUB CHECK.BUY.SELL.TRADE
    GOSUB GET.OVERALL.FLAG
    GOSUB GET.BRANCH.FLAG

*PACS00082438 - S
*BEGIN CASE
*CASE Y.PRE.APPLICATION EQ 'FUNDS.TRANSFER'
*GOSUB MAIL.FLAG
*CASE Y.PRE.APPLICATION EQ 'TELLER'
*GOSUB MAIL.FLAG
*END CASE

    GOSUB MAIL.FLAG

*PACS00082438 - E

    IF Y.POSN.FLAG EQ 1 THEN    ;* mail section for Overall Limit
        Y.TO.MAIL = ''
        Y.SUBJECT = ''
        Y.BODY = ''
        Y.TO.MAIL = Y.EMAIL.IDS
*PACS00149084 - S
*Y.SUBJECT = "Overall limit exceed - Urgent"
*Y.BODY = "Overall branch limit exceed. Please check."
*Y.BODY:= " This is System generated message. Please do not reply."
        Y.SUBJECT = Y.SUBJECT.OVR
        Y.BODY = Y.BODY.OVR
*PACS00149084 - E
        GOSUB SEND.MAIL
    END

    IF Y.POSN.FLAG EQ 1 AND Y.FIRST.OVR.VAL EQ '' THEN
        TIME.STAMP = TIMEDATE()
        Y.TIME.FIRST = TIME.STAMP[1,5]
        Y.TIME.FIRST.ALONE = FIELD(Y.TIME.FIRST,':',1)
        Y.MINUTE.FIRST.ALONE = FIELD(Y.TIME.FIRST,':',2)
        Y.TIME.TO.WRITE = TODAY:Y.TIME.FIRST.ALONE:Y.MINUTE.FIRST.ALONE
        R.FX.PARAM<FX.P.LOCAL.REF,Y.FIRST.OVR.POS> = Y.TIME.TO.WRITE
*        CALL F.WRITE(FN.FX.PARAMETERS,'FX.PARAMETERS',R.FX.PARAM)
        IDVAR.1 = 'FX.PARAMETERS' ;* R22 UTILITY AUTO CONVERSION
        CALL F.WRITE(FN.FX.PARAMETERS,IDVAR.1,R.FX.PARAM);* R22 UTILITY AUTO CONVERSION
    END

    IF Y.POSN.FLAG EQ '' AND Y.FIRST.OVR.VAL NE '' THEN
        R.FX.PARAM<FX.P.LOCAL.REF,Y.FIRST.OVR.POS> = ''
*        CALL F.WRITE(FN.FX.PARAMETERS,'FX.PARAMETERS',R.FX.PARAM)
        IDVAR.1 = 'FX.PARAMETERS' ;* R22 UTILITY AUTO CONVERSION
        CALL F.WRITE(FN.FX.PARAMETERS,IDVAR.1,R.FX.PARAM);* R22 UTILITY AUTO CONVERSION
    END

* Calculates the Current time and compares it with parameter time to raise
* override
    GOSUB GET.ACTUAL.TIMING
    IF Y.ACTUAL.END.TIMING EQ '' THEN
        RETURN
    END
    IF V$FUNCTION EQ 'I' THEN
        IF Y.POSN.FLAG EQ 1 AND Y.SYSTEM.TIMING GT Y.ACTUAL.END.TIMING THEN
            CURR.NO = Y.CURR.NO + 1
            TEXT = 'REDO.OVR.LIM.EXC'
            CALL STORE.OVERRIDE(CURR.NO)
            Y.FX.OVERRIDE.DET<-1> = 'REDO.OVR.LIM.EXC'
        END
    END
RETURN

*--------------------------------------------------------------------------
GET.PARAM.TIME:
*----------------
*The section reads the FX.PARAMETERS template and gets the value of the local filed
*L.FX.OVR.TIME by calling the core routine MULTI.GET.LOC.REF

*PACS00149084 - S
    APPL.NAME = 'FX.PARAMETERS':@FM:'FOREX' ;*R22 AUTO CONVERSION
    FLD.NAME = 'L.FX.OVR.TIME':@VM:'L.FX.FIR.OVR':@FM:'L.FX.BRANCH' ;*R22 AUTO CONVERSION
    CALL MULTI.GET.LOC.REF(APPL.NAME,FLD.NAME,FLD.POS)
    Y.OVR.POS = FLD.POS<1,1>
    Y.FIRST.OVR.POS = FLD.POS<1,2>
    Y.FX.BRANCH.POS = FLD.POS<2,1>
*PACS00149084 - E
    CALL CACHE.READ(FN.FX.PARAMETERS,'FX.PARAMETERS',R.FX.PARAM,PARAM.ERR)
    Y.OVERALL.TIME = R.FX.PARAM<FX.P.LOCAL.REF><1,Y.OVR.POS>
    Y.FIRST.OVR.VAL = R.FX.PARAM<FX.P.LOCAL.REF><1,Y.FIRST.OVR.POS>
RETURN

*---------------------------------------------------------------------------
GET.LT.VALUES1:
*----------------
* The section reads rthe local template "REDO.APAP.FX.BRN.COND" with SYSTEM as ID
* fetches the values of certain fields

    Y.LT.ID = 'SYSTEM'          ;* Id for reading the locl template1 REDO.APAP.FX.BRN.COND
*CALL F.READ(FN.REDO.APAP.FX.BRN.COND,Y.LT.ID,R.BRN.COND,F.REDO.APAP.FX.BRN.COND,COND.ERR)
    CALL CACHE.READ(FN.REDO.APAP.FX.BRN.COND,Y.LT.ID,R.BRN.COND,COND.ERR)         ;*PACS00082438
    Y.FX.POSN = R.BRN.COND<REDO.BRN.COND.FX.POSN>
    Y.OVERALL.POSN =R.BRN.COND<REDO.BRN.COND.OVERALL.POSN>
    Y.EMAIL.IDS = R.BRN.COND<REDO.BRN.COND.EMAIL.ID>
*PACS00149084 - S
    Y.SUBJECT.OVR = '' ; Y.BODY.OVR = ''
    Y.SUBJECT.OVR = R.BRN.COND<REDO.BRN.COND.EMAIL.SUBJECT>
    Y.BODY.OVR = R.BRN.COND<REDO.BRN.COND.EMAIL.BODY>
    CHANGE @VM TO ',' IN Y.EMAIL.IDS ;*R22 AUTO CONVERSION START
    CHANGE @VM TO " " IN Y.SUBJECT
    CHANGE @VM TO " " IN Y.BODY ;*R22 AUTO CONVERSION END
*PACS00149084 - E
RETURN

*---------------------------------------------------------------------------
GET.LT.VALUES2:
*----------------
* The section reads rthe local template "REDO.APAP.FX.BRN.POSN" with ID.COMPANY as ID
* fetches the values of certain fields

*PACS00149084 - S
    IF APPLICATION EQ 'FOREX' THEN
        Y.BRN.ID = R.NEW(FX.LOCAL.REF)<1,Y.FX.BRANCH.POS>
    END ELSE
        Y.BRN.ID = ID.COMPANY     ;*Id for reading the locl template1 REDO.APAP.FX.BRN.POSN
    END

    CALL CACHE.READ(FN.COMP, Y.BRN.ID, R.COMP, ERR.COM) ;*R22 AUTO CONVERSION

    CALL F.READ(FN.REDO.APAP.FX.BRN.POSN,Y.BRN.ID,R.POSITION,F.REDO.APAP.FX.BRN.POSN,POSN.ERR)
    Y.TOTAL.BRN.LIM = R.POSITION<REDO.BRN.POSN.TOT.BRN.LIMIT>
    Y.BRAN.TDY.VAL = R.POSITION<REDO.BRN.POSN.BRN.TDY.TXN.VALUE>
    Y.MAIL.ID = R.POSITION<REDO.BRN.POSN.MAIL.ID>
    Y.SUBJECT.BRN = '' ; Y.BODY.BRN = ''
    Y.SUBJECT.BRN = R.POSITION<REDO.BRN.POSN.EMAIL.SUBJECT>
    Y.BODY.BRN = R.POSITION<REDO.BRN.POSN.EMAIL.BODY>
    CHANGE @VM TO ',' IN Y.MAIL.ID ;*R22 AUTO CONVERSION START
    CHANGE @VM TO ' ' IN Y.SUBJECT.BRN
    CHANGE @VM TO ' ' IN Y.BODY.BRN ;*R22 AUTO CONVERSION END
*PACS00149084 - E
RETURN

*---------------------------------------------------------------------------
GET.OVERALL.FLAG:
*---------------------------------------------------------------------------

    Y.CURR.POSN = Y.USD.AMOUNT
    Y.TOT.POSN = Y.CURR.POSN + Y.FX.POSN  ;* For Overall Limit

* Fix for PACS00384795 [POSITION LIMIT HAS TO BE BASED ON THE SELL]

    Y.TOT.POSN.POS = ABS(Y.TOT.POSN)
*    IF Y.TOT.POSN[1,1] EQ '-' AND Y.TOT.POSN.POS GT Y.OVERALL.POSN THEN         ;* Checks overall amount with Overall Position
    IF Y.TOT.POSN.POS GT Y.OVERALL.POSN THEN
* End of Fix

        Y.POSN.FLAG = 1
    END
RETURN

*---------------------------------------------------------------------------
GET.BRANCH.FLAG:
*---------------------------------------------------------------------------

    Y.CURR.BRN.COND = Y.BRAN.TDY.VAL + Y.USD.AMOUNT ;* For Branch Limit

* Fix for PACS00384795 [POSITION LIMIT HAS TO BE BASED ON THE SELL]

    Y.CURR.BRN.COND.POS = ABS(Y.CURR.BRN.COND)
*    IF Y.CURR.BRN.COND[1,1] EQ '-' AND Y.CURR.BRN.COND.POS GT Y.TOTAL.BRN.LIM THEN        ;* Checks Branch amount with branch position
    IF Y.CURR.BRN.COND.POS GT Y.TOTAL.BRN.LIM THEN
* End of Fix

        Y.BRAN.FLAG = 1
    END
RETURN

*---------------------------------------------------------------------------
MAIL.FLAG:
*------------

    Y.TO.MAIL = ''
    Y.SUBJECT = ''
    Y.BODY = ''
    IF Y.BRAN.FLAG EQ 1 THEN
        Y.TO.MAIL = Y.MAIL.ID
*PACS00149084 - S
*Y.SUBJECT = "Branch Position Limit Exceed - Urgent"
*Y.BODY = "Branch description limit exceeds. Kindly check"
*Y.BODY:= " This is System generated message. Please do not reply."
        Y.SUBJECT = R.COMP<EB.COM.COMPANY.NAME>:":":Y.SUBJECT.BRN
        Y.BODY = R.COMP<EB.COM.COMPANY.NAME>:":":Y.BODY.BRN
*PACS00149084 - E

** PACS00121111 -S

* Fix for PACS00289159 [FX Override shouldn't be raised for the TT cheque version]

        IF PGM.VERSION NE ',CHQ.OTHERS.LOAN.DUM' AND PGM.VERSION NE ',REDO.AMD.CHQ.TAX'  THEN

* End of Fix
            CURR.NO = Y.CURR.NO + 1
            TEXT = 'REDO.FTTT.BRN.LIM'
            CALL STORE.OVERRIDE(CURR.NO)
            Y.FX.OVERRIDE.DET<-1> = 'REDO.FTTT.BRN.LIM'
        END

** PACS00121111 -E
        GOSUB SEND.MAIL
    END
RETURN

*---------------------------------------------------------------------------
SEND.MAIL:
*------------
*    CALL CACHE.READ(FN.REDO.APAP.PARAM.EMAIL,'SYSTEM',R.EMAIL,MAIL.ERR)
    IDVAR.1 = 'SYSTEM' ;* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.REDO.APAP.PARAM.EMAIL,IDVAR.1,R.EMAIL,MAIL.ERR);* R22 UTILITY AUTO CONVERSION
    Y.FILE.PATH = R.EMAIL<REDO.PRM.MAIL.IN.PATH.MAIL>
    CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
    Y.TEMP.ID = UNIQUE.TIME
    FILENAME            = UNIQUE.TIME
    FN.HRMS.FILE        = Y.FILE.PATH
    F.HRMA.FILE         = ""
    CALL OPF(FN.HRMS.FILE,F.HRMA.FILE)

*    CALL CACHE.READ(FN.REDO.ISSUE.EMAIL,'SYSTEM',R.REDO.ISSUE.EMAIL,MAIL.ERR)
    IDVAR.1 = 'SYSTEM' ;* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.REDO.ISSUE.EMAIL,IDVAR.1,R.REDO.ISSUE.EMAIL,MAIL.ERR);* R22 UTILITY AUTO CONVERSION
    BK.MAIL.ID    = R.REDO.ISSUE.EMAIL<ISS.ML.MAIL.ID>
    Y.FROM.MAIL   = BK.MAIL.ID

    RECORD = Y.FROM.MAIL:"#":Y.TO.MAIL:"#":Y.SUBJECT:"#":Y.BODY
    WRITE RECORD TO F.HRMA.FILE,FILENAME
RETURN

*---------------------------------------------------------------------------
GET.ACTUAL.TIMING:
*-------------------
* Calculates actual end time to send the mail

    Y.ACTUAL.END.TIMING = Y.OVERALL.TIME*60
    Y.SYSTEM.TIMING = TIME()
RETURN

*---------------------------------------------------------------------------
PRE.CHECK:
*----------
* Pre check to process only for FXSN number

    PROCESS.GOHEAD = @TRUE
*    CALL CACHE.READ(FN.FXSN.VERSION,'SYSTEM',R.FXSN.VERSION,ERR.FSXN)
    IDVAR.1 = 'SYSTEM' ;* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.FXSN.VERSION,IDVAR.1,R.FXSN.VERSION,ERR.FSXN);* R22 UTILITY AUTO CONVERSION
    IF R.FXSN.VERSION THEN
        Y.FXSN.VERSION = R.FXSN.VERSION<REDO.TXN.VER.VERSION.NAME>
        CHANGE @VM TO @FM IN Y.FXSN.VERSION ;*R22 AUTO CONVERSION
        Y.CURR.VERSION = APPLICATION:PGM.VERSION
        LOCATE Y.CURR.VERSION IN Y.FXSN.VERSION SETTING FXSN.POS ELSE
            PROCESS.GOHEAD = @FALSE
        END
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------------
CHECK.BUY.SELL.TRADE:
*-------------------*
* Fix for PACS00395700 [OVERALL POSITION LIMIT EXCEED OVERRIDE GENERATES WRONGLY]

    Y.DC.FLAG = ''

    BEGIN CASE

        CASE APPLICATION EQ 'FOREX'

            Y.FX.BOUGHT.CCY = R.NEW(FX.CURRENCY.BOUGHT)
            IF Y.FX.BOUGHT.CCY NE LCCY THEN
                Y.DC.FLAG = 'BUY'
            END ELSE
                Y.DC.FLAG = 'SELL'
            END

        CASE APPLICATION EQ 'FUNDS.TRANSFER'

            IF R.NEW(FT.DEBIT.CURRENCY) NE LCCY THEN
                Y.DC.FLAG = 'BUY'
            END ELSE
                Y.DC.FLAG = 'SELL'
            END

        CASE APPLICATION EQ 'TELLER'

            Y.DB.CR.MARK = R.NEW(TT.TE.DR.CR.MARKER)
            Y.TT.CCY = R.NEW(TT.TE.CURRENCY.1)
            IF Y.DB.CR.MARK EQ 'DEBIT' AND Y.TT.CCY NE LCCY THEN
                Y.DC.FLAG = 'BUY'
            END ELSE
                Y.DC.FLAG = 'SELL'
            END

    END CASE

    IF Y.DC.FLAG EQ 'SELL' THEN
        Y.USD.AMOUNT = Y.USD.AMOUNT * (-1)
    END

RETURN

*---------------------------------------------------------------------------
END
