* @ValidationCode : MjotMTYwNjgxMjYyOkNwMTI1MjoxNjgyMDc4ODcwODU0OklUU1M6LTE6LTE6MTAxNToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:37:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1015
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
*-----------------------------------------------------------------------------
* <Rating>67</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE NOFILE.REDO.ENQ.REP.COMPLAINTS(Y.ARRAY)
***********************************************************************

* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: NOFILE.REDO.ENQ.REP.COMPLAINTS
* ODR NO : ODR-2009-12-0283
*----------------------------------------------------------------------
*DESCRIPTION:

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*16.08.2010 S SUDHARSANAN ODR-2009-12-0283 INITIAL CREATION
*
* 18-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 18-APR-2023      Harishvikram C   Manual R22 conversion      CALL routine format modified, FM TO @FM, VM to @VM, SM to @SM
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.COMPLAINTS
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.SLA.PARAM

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB LOC.REF
    GOSUB GET.COMPLAINTS.IDS
    GOSUB GET.CUS.IDS
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
* All variables are intialized here
    Y.COMPLAINTS.ARR.ID = ''
    Y.CUS.ARR.ID = ''
    VAR.COMPLAINTS = ''
    VAR.CUS = ''
    Y.SLA.DAYS = ''

RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
* All files needed throughtout the routine are opened here

    FN.REDO.ISSUE.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'
    F.REDO.ISSUE.COMPLAINTS =''
    CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.SLA.PARAM='F.REDO.SLA.PARAM'
    F.REDO.SLA.PARAM=''
    CALL OPF(FN.REDO.SLA.PARAM,F.REDO.SLA.PARAM)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*----------------------------------------------------------------------
LOC.REF:
*----------------------------------------------------------------------
* To get the position of local fields

    LOC.REF.APPLICATION="CUSTOMER"
    LOC.REF.FIELDS='L.CU.SEGMENTO'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    L.CU.SEGMENTO.POS=LOC.REF.POS

RETURN
*----------------------------------------------------------------------
GET.COMPLAINTS.IDS:
*----------------------------------------------------------------------
* All selection fields related to REDO.ISSUE.COMPLAINTS application are processed here

    VALUE.BK = D.RANGE.AND.VALUE
    OPERAND.BK = D.LOGICAL.OPERANDS
    FIELDS.BK = D.FIELDS

    D.RANGE.AND.VALUE=''
    D.LOGICAL.OPERANDS=''
    D.FIELDS=''

    COMPLAINTS.APP.FLDS = 'PRODUCT.TYPE':@FM:'STATUS':@FM:'TYPE':@FM:'CUST.ID.NUMBER':@FM:'OPENING.DATE':@FM:'CLOSING.DATE':@FM:'INPUTTER':@FM:'SUPPORT.GROUP':@FM:'OPENING.CHANNEL':@FM:'BRANCH':@FM:'ACCOUNT.OFFICER':@FM:'RISK.LEVEL'
    LOOP
        REMOVE APP.FLD FROM COMPLAINTS.APP.FLDS SETTING COMPLAINTS.FLD.POS
    WHILE APP.FLD:COMPLAINTS.FLD.POS
        LOCATE APP.FLD IN FIELDS.BK<1> SETTING POS1 THEN
            VAR.COMPLAINTS=1
            GOSUB UPDATE.COM.VAR
        END
    REPEAT
    IF D.FIELDS NE '' THEN
        FILE.NAME = FN.REDO.ISSUE.COMPLAINTS
        CALL APAP.REDOENQ.REDO.E.FORM.SEL.STMT(FILE.NAME, '', '', SEL.COMPLAINTS.CMD) ;*Manual R22 conversion
        CALL EB.READLIST(SEL.COMPLAINTS.CMD,COMPLAINTS.ID.LST,'',NO.OF.REC.COMPLAINTS,SEL.ERR)
        Y.COMPLAINTS.ARR.ID=COMPLAINTS.ID.LST
    END
RETURN

*----------------------------------------------------------------------
GET.CUS.IDS:
*----------------------------------------------------------------------
* All selection fields related to CUSTOMER application are processed here

    D.RANGE.AND.VALUE=''
    D.LOGICAL.OPERANDS=''
    D.FIELDS=''

    CUS.APP.FLDS='L.CU.SEGMENTO'
    LOOP
        REMOVE CUS.FLD FROM CUS.APP.FLDS SETTING CUS.FLD.POS
    WHILE CUS.FLD:CUS.FLD.POS
        LOCATE CUS.FLD IN FIELDS.BK<1> SETTING POS1 THEN
            VAR.CUS=1
            GOSUB UPDATE.COM.VAR
        END
    REPEAT
    IF D.FIELDS NE '' THEN
        FILE.NAME = FN.CUSTOMER
        CALL APAP.REDOENQ.REDO.E.FORM.SEL.STMT(FILE.NAME, '', '', SEL.CUS.CMD) ;*Manual R22 conversion
        CALL EB.READLIST(SEL.CUS.CMD,CUS.ID.LST,'',NO.OF.REC.CUS,SEL.CUS.ERR)
        Y.CUS.ARR.ID=CUS.ID.LST
    END
RETURN
*----------------------------------------------------------------------
UPDATE.COM.VAR:
*----------------------------------------------------------------------

    D.RANGE.AND.VALUE<-1>=VALUE.BK<POS1>
    D.LOGICAL.OPERANDS<-1>=OPERAND.BK<POS1>
    D.FIELDS<-1>=FIELDS.BK<POS1>

RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
* Final List of claim's ID are sorted out here

    BEGIN CASE
        CASE VAR.COMPLAINTS NE '' AND VAR.CUS NE ''
            IF Y.COMPLAINTS.ARR.ID NE '' AND Y.CUS.ARR.ID NE '' THEN
                GOSUB PROCESS1
                GOSUB PROCESS4
            END
        CASE VAR.COMPLAINTS NE '' AND VAR.CUS EQ ''
            IF Y.COMPLAINTS.ARR.ID NE '' THEN
                GOSUB PROCESS2
                GOSUB PROCESS4
            END
        CASE VAR.COMPLAINTS EQ '' AND VAR.CUS NE ''
            IF Y.CUS.ARR.ID NE '' THEN
                GOSUB PROCESS3
                GOSUB PROCESS4
            END
        CASE VAR.COMPLAINTS EQ '' AND VAR.CUS EQ ''
            SEL.CMD2 = 'SELECT ':FN.REDO.ISSUE.COMPLAINTS
            CALL EB.READLIST(SEL.CMD2,SEL.COMP.LIST2,'',NOR.COMP2,COMP.ERROR)
            Y.COMMON.ARRAY = SEL.COMP.LIST2
            GOSUB PROCESS4
    END CASE

RETURN
*------------------------------------------------------------------------------------------
PROCESS1:
*-------------------------------------------------------------------------------------------
    Y.COMPLAINTS.ARR.ID.CNT=DCOUNT(Y.COMPLAINTS.ARR.ID,@FM)
    VAR1=1
    LOOP
    WHILE VAR1 LE Y.COMPLAINTS.ARR.ID.CNT
        Y.COMPLAINTS.ID = Y.COMPLAINTS.ARR.ID<VAR1>
        CALL F.READ(FN.REDO.ISSUE.COMPLAINTS,Y.COMPLAINTS.ID,R.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS,COMP.ERR)
        Y.CUST.CODE = R.COMPLAINTS<ISS.COMP.CUSTOMER.CODE>
        LOCATE Y.CUST.CODE IN Y.CUS.ARR.ID SETTING POS2 THEN
            Y.COMMON.ARRAY<-1>=Y.COMPLAINTS.ARR.ID<VAR1>
        END
        VAR1++
    REPEAT
RETURN
*--------------------------------------------------------------------------------------------
PROCESS2:
*-----------------------------------------------------------------------------------------------
    Y.COMMON.ARRAY = Y.COMPLAINTS.ARR.ID
RETURN
*--------------------------------------------------------------------------------------------------
PROCESS3:
*----------------------------------------------------------------------------------------------------
    Y.CUS.ID = Y.CUS.ARR.ID
    CHANGE @FM TO " " IN Y.CUS.ID
    SEL.COMPLAINTS.CMD1='SELECT ':FN.REDO.ISSUE.COMPLAINTS:" WITH CUSTOMER.CODE EQ ":Y.CUS.ID
    CALL EB.READLIST(SEL.COMPLAINTS.CMD1,SEL.COMPLAINTS.LIST1,'',NOR.COMPLAINTS,CUST.ER)
    Y.COMMON.ARRAY = SEL.COMPLAINTS.LIST1
RETURN
*-------------------------------------------------------------------------------------------------------
PROCESS4:
*------------------------------------------------------------------------------------------------------
    Y.ARRAY.CNT = DCOUNT(Y.COMMON.ARRAY,@FM)
    VAR2=1
    LOOP
    WHILE VAR2 LE Y.ARRAY.CNT
        Y.ISSUE.COMPLAINTS.ID = Y.COMMON.ARRAY<VAR2>

        CALL F.READ(FN.REDO.ISSUE.COMPLAINTS,Y.ISSUE.COMPLAINTS.ID,R.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS,COMPLAINTS.ERR)
        GOSUB COMPLAINT.DETAILS

        CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.CODE,R.CUST,F.CUSTOMER,CUS.ERR)
        Y.SEGMENT = R.CUST<EB.CUS.LOCAL.REF,L.CU.SEGMENTO.POS>
        Y.SEG.CHANNEL = Y.OPEN.CHANNEL:'-':Y.SEGMENT
        Y.CUST.NAME = R.CUST<EB.CUS.SHORT.NAME>
        CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        Y.ALT.ACCT.ID = R.ACCOUNT<AC.ALT.ACCT.ID>
        Y.DESC = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.CLAIM.TYPE>
        GOSUB PARAM.DETAILS

        Y.OPEN.DATE = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.OPENING.DATE>
        Y.CLOSE.DATE = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.CLOSING.DATE>
        Y.RES.DATE = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.DATE.RESOLUTION>
        Y.TXN.DATE = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.TRANSACTION.DATE>

        IF Y.CLOSE.DATE NE '' AND Y.TXN.DATE NE '' THEN
            CALL CDD('',Y.TXN.DATE,Y.CLOSE.DATE,NO.OF.DAYS1)
        END
        Y.SERVICE.DURATION = NO.OF.DAYS1
        IF Y.CLOSE.DATE NE '' AND Y.OPEN.DATE NE '' THEN
            CALL CDD('',Y.OPEN.DATE,Y.CLOSE.DATE,NO.OF.DAYS2)
        END
        Y.RESPONSE.TIME = NO.OF.DAYS2
        Y.AMOUNT.CLAIM = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.AMOUNT.CLAIM>
        Y.AMOUNT.PAID = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.TRANSACTION.AMOUNT>
        Y.DATE.NOTIFY = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.DATE.NOTIFICATION>
        IF Y.DATE.NOTIFY NE '' AND Y.OPEN.DATE NE '' THEN
            CALL CDD('',Y.DATE.NOTIFY,Y.OPEN.DATE,NO.OF.DAYS3)
        END
        Y.OPEN.NOTIFY = NO.OF.DAYS3
        IF Y.DATE.NOTIFY NE '' AND Y.CLOSE.DATE NE '' THEN
            CALL CDD('',Y.DATE.NOTIFY,Y.CLOSE.DATE,NO.OF.DAYS4)
        END
        Y.CLOSE.NOTIFY = NO.OF.DAYS4
        Y.CLOSED = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.CLOSING.STATUS>
        Y.SUPP.GRP = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.SUPPORT.GROUP>
        Y.COMPLAINCE = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.SER.AGR.COMP>
        Y.BRANCH = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.BRANCH>
        Y.USER.MODIFIER = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.INPUTTER>
        Y.ARRAY<-1> = Y.ISSUE.COMPLAINTS.ID:'*':Y.PRDT.TYPE:'*':Y.STATUS:'*':Y.OPEN.DATE:'*':Y.TYPE:'*':Y.SEGMENT:'*':Y.CUST.NAME:'*':Y.CUSTOMER.ID.NO:'*':Y.ACCT.ID:'*':Y.ALT.ACCT.ID:'*':Y.SLA.DAYS:'*':Y.CLOSE.DATE:'*':Y.RESPONSE.TIME:'*':Y.DESC:'*':Y.AMOUNT.CLAIM:'*':Y.AMOUNT.PAID:'*':Y.DATE.NOTIFY:'*':Y.OPEN.NOTIFY:'*':Y.CLOSE.NOTIFY:'*':Y.SERVICE.DURATION:'*':Y.CLOSED:'*':Y.COMPLAINCE:'*':Y.BRANCH:'*':Y.SUPP.GRP:'*':Y.USER.MODIFIER
        VAR2++
    REPEAT
RETURN
*-------------------------------------------------------------------------------------------------------
COMPLAINT.DETAILS:
*--------------------------------------------------------------------------------------------------------
    Y.CUSTOMER.CODE = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.CUSTOMER.CODE>
    Y.OPEN.CHANNEL = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.OPENING.CHANNEL>
    Y.PRDT.TYPE = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.PRODUCT.TYPE>
    VAR.PRDT.TYPE = FIELD(Y.PRDT.TYPE,"-",2)
    Y.TYPE = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.TYPE>
    VAR.TYPE = FIELD(Y.TYPE,"-",2)
    Y.STATUS = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.STATUS>
    Y.SLA.ID = VAR.TYPE:'-':VAR.PRDT.TYPE
    Y.CUSTOMER.ID.NO = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.CUST.ID.NUMBER>
    Y.ACCT.ID = R.REDO.ISSUE.COMPLAINTS<ISS.COMP.ACCOUNT.ID>
RETURN
*----------------------------------------------------------------------------------------------------------
PARAM.DETAILS:
*-----------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.REDO.SLA.PARAM,Y.SLA.ID,R.REDO.SLA.PARAM,F.REDO.SLA.PARAM,SLA.ERR)
    Y.DESC.SLA = R.REDO.SLA.PARAM<SLA.DESCRIPTION>
    CHANGE @VM TO @FM IN Y.DESC.SLA
    LOCATE Y.DESC IN Y.DESC.SLA SETTING SLA.POS THEN
        Y.START.CHANNEL = R.REDO.SLA.PARAM<SLA.START.CHANNEL,SLA.POS>
        CHANGE @SM TO @FM IN Y.START.CHANNEL
        CNT1 = DCOUNT(Y.START.CHANNEL,@FM)
        CNT =1
        LOOP
        WHILE CNT LE CNT1
            IF Y.START.CHANNEL<CNT> EQ Y.SEG.CHANNEL THEN
                Y.SLA.DAYS = R.REDO.SLA.PARAM<SLA.SEG.DAYS,SLA.POS,CNT>
                BREAK
            END
            CNT++
        REPEAT
    END
RETURN
*-----------------------------------------------------------------------------------------------------------
END
