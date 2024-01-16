* @ValidationCode : MjoxNDk0OTQzNzYzOkNwMTI1MjoxNzA0Njk5NDI2Mjk4OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Jan 2024 13:07:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOFILE.GTEE.MVMT.RPT(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOFILE.GTEE.MVMT.RPT
*--------------------------------------------------------------------------------------------------------
*Description       : This is a NO-FILE enquiry routine, the routine based on the selection criteria selects
*                    the records from AA.ARRANGEMENT and displays the processed records
*Linked With       : Enquiry REDO.APAP.NOF.LAON.STATUS.RPT
*In  Parameter     : N/A
*Out Parameter     : Y.OUT.ARRAY
*Files  Used       : AA.ARRANGEMENT
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                        Reference                   Description
*     ------               -----                      -------------                -------------
* 31 August 2010       Arulprakasam P & G Sabari      ODR-2010-03-0103 163         Initial Creation
* 08 FEB 2011          Ganesh R                       PACS00180415                 Removed second select on AA.ARR.TERM.AMOUNT
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM , ++ to +=
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
* 29-12-2023      HARISHVIKRAM                 R22 Manual conversion
*----------------------------------------------------------------------------------------
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*$INSERT I_F.AA.ARRANGEMENT                    ;*R22 Manual Conversion
    $INSERT I_F.COLLATERAL
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    $USING APAP.TAM
    $USING APAP.AA
    $USING AA.Framework
*-------------------------------------------------------------------------------------------------------
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
* In this para of the code, file variables are initialised and opened

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AA.ARR.ACCOUNT = 'F.AA.ARR.ACCOUNT'
    F.AA.ARR.ACCOUNT = ''
    CALL OPF(FN.AA.ARR.ACCOUNT,F.AA.ARR.ACCOUNT)

    FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'
    F.AA.ARR.TERM.AMOUNT = ''
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)

    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL = ''
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.REDO.CUST.ARR = 'F.REDO.CUSTOMER.ARRANGEMENT'
    F.REDO.CUST.ARR  = ''
    CALL OPF(FN.REDO.CUST.ARR,F.REDO.CUST.ARR)

    Y.TERM.ACC.IDS = '' ; BALANCE.TO.CHECK = '' ; Y.AMOUNT = '' ; Y.OUTSTANDING.BAL = '' ; Y.LOAN.NUMBER = ''
    Y.DISBUR.DATE = ''  ; Y.DISBUR.DATE1 = '' ; Y.PRO.TYP = '' ; Y.GTEE.DOC = '' ; Y.PRE.LOA.NO = ''
    Y.DISBURS.AMT = '' ; Y.DESC = ''

RETURN

*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    GOSUB CHECK.SELECTION
    GOSUB GET.COLLATERAL.DETAILS

RETURN

*--------------------------------------------------------------------------------------------------------
****************
CHECK.SELECTION:
****************

    SEL.CMD.COL = "SELECT ":FN.COLLATERAL

    LOCATE "GTEE.TXN.DATE" IN D.FIELDS<1> SETTING Y.GTEE.TXN.DATE THEN
        Y.GTEE.TXN.DATE = D.RANGE.AND.VALUE<Y.GTEE.TXN.DATE>
        IF Y.GTEE.TXN.DATE NE '' THEN
            SEL.CMD.COL := " AND WITH VALUE.DATE EQ ":Y.GTEE.TXN.DATE
        END
    END

    LOCATE "MVMT.TYPE" IN D.FIELDS<1> SETTING Y.MVMT.TYPE THEN
        Y.MVMT.TYPE = D.RANGE.AND.VALUE<Y.MVMT.TYPE>
        IF Y.MVMT.TYPE NE '' THEN
            SEL.CMD.COL := " AND WITH L.CO.MVMT.TYPE EQ ":Y.MVMT.TYPE
        END
    END

    LOCATE "REASN.MVMT" IN D.FIELDS<1> SETTING Y.REASN.MVMT THEN
        Y.REASN.MVMT = D.RANGE.AND.VALUE<Y.REASN.MVMT>
        IF Y.REASN.MVMT NE '' THEN
            SEL.CMD.COL := " AND WITH L.CO.REASN.MVMT EQ ":Y.REASN.MVMT
        END
    END

    LOCATE "LOC.STAT" IN D.FIELDS<1> SETTING Y.LOC.STAT THEN
        Y.LOC.STAT = D.RANGE.AND.VALUE<Y.LOC.STAT>
        IF Y.LOC.STAT NE '' THEN
            SEL.CMD.COL := " AND WITH L.CO.LOC.STATUS EQ ":Y.LOC.STAT
        END
    END

    LOCATE "COL.CODE" IN D.FIELDS<1> SETTING Y.COL.CODE.POS THEN
        Y.COL.CODE = D.RANGE.AND.VALUE<Y.COL.CODE.POS>
        IF Y.COL.CODE NE '' THEN
            SEL.CMD.COL := " AND WITH COLLATERAL.CODE EQ ":Y.COL.CODE
        END
    END

    LOCATE "RSPN.MVMT" IN D.FIELDS<1> SETTING Y.RSPN.MVMT.POS THEN
        Y.RSPN.MVMT = D.RANGE.AND.VALUE<Y.RSPN.MVMT.POS>
        IF Y.RSPN.MVMT NE '' THEN
            SEL.CMD.COL := " AND WITH L.CO.RES.MVMT EQ ":Y.RSPN.MVMT
        END
    END

    CALL EB.READLIST(SEL.CMD.COL,SEL.LIST.COL,'',NO.OF.REC.COL,SEL.ERR.COL)

RETURN

***********************
GET.COLLATERAL.DETAILS:
***********************

    GOSUB FIND.MULTI.LOCAL.REF
    SEL.LIST.COL1 = SEL.LIST.COL
    SEL.LIST.CNT = DCOUNT(SEL.LIST.COL,@FM)
    SEL.INT.CNT = 1
    LOOP
        REMOVE COLLATERAL.ID FROM SEL.LIST.COL SETTING Y.COL.POS
    WHILE SEL.INT.CNT LE SEL.LIST.CNT
        R.COLLATERAL  = ''
        COLLATERAL.ER = ''
        CALL F.READ(FN.COLLATERAL,COLLATERAL.ID,R.COLLATERAL,F.COLLATERAL,COLLATERAL.ER)
        Y.COLL.ID = COLLATERAL.ID
        Y.TYPE.OF.GUAR = R.COLLATERAL<COLL.COLLATERAL.CODE>
        IF Y.TYPE.OF.GUAR EQ 450 THEN
            Y.DESC = R.COLLATERAL<COLL.LOCAL.REF,L.COL.PROP.DESC.POS>
        END ELSE
            Y.DESC = R.COLLATERAL<COLL.LOCAL.REF,L.COL.SEC.DESC.POS>
        END
        Y.TYPE.MVMT = R.COLLATERAL<COLL.LOCAL.REF,L.CO.MVMT.TYPE.POS>
        Y.RSN.MVMT = R.COLLATERAL<COLL.LOCAL.REF,L.CO.REASN.MVMT.POS>
        Y.LOCATION.STATUS = R.COLLATERAL<COLL.LOCAL.REF,L.CO.LOC.STATUS.POS>
        Y.REC.DT = R.COLLATERAL<COLL.LOCAL.REF,L.CO.SRECP.DATE.POS>
        Y.MVMT.DT = R.COLLATERAL<COLL.LOCAL.REF,L.CO.DATE.MVMT.POS>
        Y.RES.MVMT = R.COLLATERAL<COLL.LOCAL.REF,L.CO.RES.MVMT.POS>
        Y.REG.DT = R.COLLATERAL<COLL.LOCAL.REF,L.CO.REG.DATE.POS>
        Y.CER.DLY.DT = R.COLLATERAL<COLL.LOCAL.REF,L.CO.CR.DATE.POS>
*****************
*PACS00180415-S

        Y.CUS.ID = FIELD(Y.COLL.ID,'.',1)
        CALL F.READ(FN.REDO.CUST.ARR,Y.CUS.ID,R.REDO.CUST.ARR,F.REDO.CUST.ARR,CUST.ERR)
        IF R.REDO.CUST.ARR THEN
            Y.ARR.ID.LIST = R.REDO.CUST.ARR<CUS.ARR.OWNER>
            Y.ARR.ID.COUNT= DCOUNT(Y.ARR.ID.LIST,@VM)
        END
*PACS00180415-E
*****************
        GOSUB GET.AA.DETAILS
        GOSUB FORM.FINAL.ARR
    REPEAT
RETURN

FORM.FINAL.ARR:

    IF Y.CONT.FLAG THEN
        CHANGE '#' TO '' IN Y.GTEE.DOC
        CHANGE @FM TO @VM IN Y.GTEE.DOC

        CHANGE '#' TO '' IN Y.LOAN.NUMBER
        CHANGE @FM TO @VM IN Y.LOAN.NUMBER

        CHANGE '#' TO '' IN Y.PRE.LOA.NO
        CHANGE @FM TO @VM IN Y.PRE.LOA.NO

        CHANGE '#' TO '' IN Y.PRO.TYP
        CHANGE @FM TO @VM IN Y.PRO.TYP

        CHANGE '#' TO '' IN Y.DISBUR.DATE1
        CHANGE @FM TO @VM IN Y.DISBUR.DATE1

        CHANGE '#' TO '' IN Y.DISBURS.AMT
        CHANGE @FM TO @VM IN Y.DISBURS.AMT

        CHANGE '#' TO '' IN Y.OUTSTANDING.BAL
        CHANGE @FM TO @VM IN Y.OUTSTANDING.BAL

        Y.OUT.ARRAY<-1> := Y.TYPE.OF.GUAR:"*":Y.COLL.ID:"*":Y.DESC:"*":Y.GTEE.DOC:"*":Y.LOAN.NUMBER:"*":Y.PRE.LOA.NO:"*":Y.PRO.TYP:"*"
        Y.OUT.ARRAY := Y.DISBUR.DATE1:"*":Y.DISBURS.AMT:"*":Y.OUTSTANDING.BAL:"*":Y.TYPE.MVMT:"*":Y.RSN.MVMT:"*":Y.LOCATION.STATUS:"*":Y.REC.DT:"*":Y.MVMT.DT:"*"
        Y.OUT.ARRAY := Y.RES.MVMT:"*":Y.REG.DT:"*":Y.CER.DLY.DT:"*"
        Y.OUTSTANDING.BAL = ''
    END

RETURN
*--------------------------------------------------------------------------------------------------------
***********************
GET.AA.DETAILS:
***********************
*********************
*PACS00180415-S
    Y.AMT.INT = 1
    LOOP
        REMOVE Y.CUST.ARR.ID FROM Y.ARR.ID.LIST SETTING Y.CUS.ARR.POS
    WHILE Y.AMT.INT LE Y.ARR.ID.COUNT
        GOSUB GET.AA.ARR.TERM.AMOUNT
        IF Y.CONT.FLAG THEN
            GOSUB GET.AA.ARR.ACCOUNT
            Y.DISBURS.AMT = Y.AMOUNT
        END
        Y.AMT.INT += 1
    REPEAT
*PACS00180415-E
**********************
RETURN

***********************
GET.AA.ARR.TERM.AMOUNT:
***********************
    Y.CONT.FLAG = ''
    Y.TERM.ACC.IDS = ''
    Y.AMOUNT = ''
*************************
*PACS00180415-S
    ARR.AMT.ID      = Y.CUST.ARR.ID
    EFF.AMT.DATE    = TODAY
    PROP.AMT.CLASS  = 'TERM.AMOUNT'
    PROPERTY.AMT    = ''
    R.AMT.CONDITION = ''
    ERR.AMT.MSG     = ''
    APAP.AA.redoCrrGetConditions(ARR.AMT.ID,EFF.AMT.DATE,PROP.AMT.CLASS,PROPERTY.AMT,R.AMT.CONDITION,ERR.AMT.MSG)
    Y.AMT.COLL.ID = R.AMT.CONDITION<AA.AMT.LOCAL.REF,L.AA.COL.POS>
    IF Y.AMT.COLL.ID EQ COLLATERAL.ID THEN
        Y.CONT.FLAG = 1
    END
    IF Y.CONT.FLAG THEN
        LOCATE FIELD(ARR.AMT.ID,'-',1) IN Y.TERM.ACC.IDS SETTING Y.AA.POS THEN
            Y.AMOUNT<Y.AA.POS> += R.AMT.CONDITION<AA.AMT.AMOUNT>
        END ELSE
            Y.TERM.ACC.IDS<-1> = FIELD(ARR.AMT.ID,'-',1)
            Y.AMOUNT<-1> = R.AMT.CONDITION<AA.AMT.AMOUNT>
        END
    END
*PACS00180415-E
*************************
RETURN

*********************
GET.AA.ARR.ACCOUNT:
*********************
    Y.LOAN.NUMBER = '' ; Y.DISBUR.DATE1 = '' ; Y.PRO.TYP = '' ; Y.GTEE.DOC = '' ; Y.PRE.LOA.NO = ''

    LOOP
        REMOVE SEL.AA.ID FROM Y.TERM.ACC.IDS SETTING Y.AA.POS
    WHILE SEL.AA.ID:Y.AA.POS
        ARR.ID      = SEL.AA.ID
        EFF.DATE    = TODAY
        PROP.CLASS  = 'ACCOUNT'
        PROPERTY    = ''
        R.CONDITION = ''
        ERR.MSG     = ''

        APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.AA.ARR.ACCOUNT,ERR.MSG)

        IF SEL.AA.ID THEN
            Y.LOAN.NUMBER<-1> = SEL.AA.ID
        END ELSE
            Y.LOAN.NUMBER<-1> = '#'
        END

        IF R.AA.ARR.ACCOUNT<AA.AC.ACCOUNT.TITLE.1> THEN
            Y.PRO.TYP<-1> = R.AA.ARR.ACCOUNT<AA.AC.ACCOUNT.TITLE.1>
        END ELSE
            Y.PRO.TYP<-1> = '#'
        END

        IF R.AA.ARR.ACCOUNT<AA.AC.LOCAL.REF,L.AA.LOAN.DOC.POS> THEN
            Y.GTEE.DOC<-1> = R.AA.ARR.ACCOUNT<AA.AC.LOCAL.REF,L.AA.LOAN.DOC.POS>
        END ELSE
            Y.GTEE.DOC<-1> = '#'
        END

        IF R.AA.ARR.ACCOUNT<AA.AC.ALT.ID> THEN
            Y.PRE.LOA.NO<-1> = R.AA.ARR.ACCOUNT<AA.AC.ALT.ID>
        END ELSE
            Y.PRE.LOA.NO<-1> = '#'
        END

        CALL F.READ(FN.AA.ACCOUNT.DETAILS,SEL.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.AA.ERR)
        IF R.AA.ACCOUNT.DETAILS<AA.AD.START.DATE> THEN
            Y.DISBUR.DATE1<-1> = R.AA.ACCOUNT.DETAILS<AA.AD.START.DATE>
        END ELSE
            Y.DISBUR.DATE1<-1> = '#'
        END

*        CALL F.READ(FN.AA.ARRANGEMENT,SEL.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ERR)      ;*R22 Manual Conversion - Start
        R.AA.ARRANGEMENT = AA.Framework.Arrangement.Read(SEL.AA.ID, AA.ARRANGEMENT.ERR)
        
*Y.LINK.APP = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL>
        Y.LINK.APP = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrLinkedAppl>
*Y.LINK.APP.ID = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
        Y.LINK.APP.ID = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrLinkedApplId>                       ;*R22 Manual Conversion
        Y.BALANCE.TO.CHECK.ARRAY = 'CURACCOUNT':@VM:'DUEACCOUNT':@VM:'GRCACCOUNT':@VM:'DELACCOUNT':@VM:'NABACCOUNT'

        GOSUB BALANCE.CHECK

    REPEAT
RETURN
*-----------------------------------------------------------------------------------------------------------------------------------------
**************
BALANCE.CHECK:
**************
    Y.OUTSTANDING.BAL1 = ''
    LOOP
        REMOVE BALANCE.TO.CHECK FROM Y.BALANCE.TO.CHECK.ARRAY SETTING Y.BAL.CHECK.POS
    WHILE BALANCE.TO.CHECK:Y.BAL.CHECK.POS
        DATE.OPTIONS = ''
        EFFECTIVE.DATE = TODAY
        DATE.OPTIONS<4>  = 'ECB'
        BALANCE.AMOUNT = ""
*CALL AA.GET.PERIOD.BALANCES(Y.LINK.APP.ID, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "")
        AA.Framework.GetPeriodBalances(Y.LINK.APP.ID, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "");* R22 UTILITY AUTO CONVERSION
        Y.OUTSTANDING.BAL1 = Y.OUTSTANDING.BAL1 + BAL.DETAILS<IC.ACT.BALANCE>
    REPEAT


    IF Y.OUTSTANDING.BAL1 THEN
        Y.OUTSTANDING.BAL<-1> = Y.OUTSTANDING.BAL1
    END ELSE
        Y.OUTSTANDING.BAL<-1> = '#'
    END

RETURN
*-------------------------------------------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************

    APPL.ARRAY = 'COLLATERAL':@FM:'AA.ARR.ACCOUNT':@FM:'AA.ARR.TERM.AMOUNT'
    FLD.ARRAY = 'L.COL.SEC.DESC':@VM:'L.COL.PROP.DESC':@VM:'L.CO.MVMT.TYPE':@VM:'L.CO.REASN.MVMT':@VM:'L.CO.LOC.STATUS':@VM:'L.CO.SRECP.DATE':@VM:'L.CO.DATE.MVMT':@VM:'L.CO.RES.MVMT':@VM:'L.CO.REG.DATE':@VM:'L.CO.CR.DATE':@FM:'L.AA.LOAN.DOC':@FM:'L.AA.COL'

    FLD.POS = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    L.COL.SEC.DESC.POS = FLD.POS<1,1>
    L.COL.PROP.DESC.POS = FLD.POS<1,2>
    L.CO.MVMT.TYPE.POS = FLD.POS<1,3>
    L.CO.REASN.MVMT.POS = FLD.POS<1,4>
    L.CO.LOC.STATUS.POS = FLD.POS<1,5>
    L.CO.SRECP.DATE.POS = FLD.POS<1,6>
    L.CO.DATE.MVMT.POS = FLD.POS<1,7>
    L.CO.RES.MVMT.POS = FLD.POS<1,8>
    L.CO.REG.DATE.POS = FLD.POS<1,9>
    L.CO.CR.DATE.POS = FLD.POS<1,10>
    L.AA.LOAN.DOC.POS = FLD.POS<2,1>
    L.AA.COL.POS = FLD.POS<3,1>

RETURN
END
