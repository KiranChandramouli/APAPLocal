* @ValidationCode : MjotMTk3MTkwNzAzNzpDcDEyNTI6MTY4NDgzNjA0MjM5NzpJVFNTOi0xOi0xOjgwOToxOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 809
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.INP.LOAN.NO
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.INP.LOAN.NO
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to extract the ID.COMP1 from the
*                    file AA.ARR.TERM.AMOUNT with the local feild L.AA.COL equal to ID.NEW, if YES
*                    then assign the value of ID.COMP1 to this field
*Linked With       : COLLATERAL,DOC.RECEPTION AND COLLATERAL,DOC.MOVEMENT
*In  Parameter     :
*Out Parameter     :
*Files  Used       : AA.ARR.TERM.AMOUNT            As          I   Mode
*                    COLLATERAL                    As          I   Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 26/05/2010    Shiva Prasad Y     ODR-2009-10-0310 B.180C      Initial Creation
* 04/05/2011    Kavitha            PACS00054322 B.180C          Bug fix
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   SM to @SM , FM to @FM
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ALTERNATE.ACCOUNT
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.ACCT.BALANCE.ACTIVITY

*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
    FN.AA.ARR.TERM.AMOUNT='F.AA.ARR.TERM.AMOUNT'
    F.AA.ARR.TERM.AMOUNT=''
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.ALTERNATE.ACCOUNT='F.ALTERNATE.ACCOUNT'
    F.ALTERNATE.ACCOUNT=''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

    FN.EB.CONTRACT.BALANCES='F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES=''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.ACCT.ACTIVITY='F.ACCT.BALANCE.ACTIVITY'
    F.ACCT.ACTIVITY =''
    CALL OPF(FN.ACCT.ACTIVITY ,F.ACCT.ACTIVITY)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB GET.ARRANGEMENTS

*PACS00054322 - S
    IF PGM.VERSION EQ ",DOC.MOVEMENT" THEN
        SEC.DOC.OLD.VALUE = R.OLD(COLL.LOCAL.REF)<1,LOC.L.CO.SEC.DOC.POS>
        Y.SEC.COUNT1 =        DCOUNT(SEC.DOC.OLD.VALUE,@SM)
        SEC.DOC.NEW.VALUE = R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.SEC.DOC.POS>
        Y.SEC.COUNT1 =        DCOUNT(SEC.DOC.NEW.VALUE,@SM)

        IF SEC.DOC.OLD.VALUE NE SEC.DOC.NEW.VALUE THEN
            AF = COLL.LOCAL.REF
            AV = LOC.L.CO.SEC.DOC.POS
            AS = Y.SEC.COUNT1
            ETEXT = 'CO-DOC.REC.NOT.AMEND'
            CALL STORE.END.ERROR
        END
*APAP.REDOAPAP.REDO.APAP.VAL.REASN.MVMT.M
        APAP.REDOAPAP.redoApapValReasnMvmtM()
* APAP.REDOAPAP.REDO.APAP.VAL.DATE.MVMT.M
        APAP.REDOAPAP.redoApapValDateMvmtM()
    END
    IF PGM.VERSION EQ ",DOC.RECEPTION" THEN
*APAP.REDOAPAP.REDO.APAP.V.RECEP.DATE
        APAP.REDOAPAP.redoApapVRecepDate()
*APAP.REDOAPAP.REDO.APAP.VAL.REG.TITLE.DATE
        APAP.REDOAPAP.redoApapValRegTitleDate()

    END
*PACS00054322 -E
RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.ARRANGEMENTS:
*****************
    Y.SEL.TERM.AMT.CMD = "SSELECT ":FN.AA.ARR.TERM.AMOUNT:" WITH L.AA.COL EQ ":ID.NEW
    CALL EB.READLIST(Y.SEL.TERM.AMT.CMD,Y.SEL.TERM.AMT.LIST,'',NO.OF.TERM.REC,Y.RET.TERM.CODE)
    LOOP
        REMOVE AA.ID FROM Y.SEL.TERM.AMT.LIST SETTING POS.AA.1
    WHILE AA.ID:POS.AA.1
        AA.ARRANGEMENT.VAL = FIELD(AA.ID,'-',1)
        LOCATE AA.ARRANGEMENT.VAL IN AA.ARRANGEMENT.LIST SETTING POS.AA ELSE
            AA.ARRANGEMENT.LIST<-1> = AA.ARRANGEMENT.VAL
        END
    REPEAT

*    Y.REC.COUNT = DCOUNT(Y.SEL.TERM.AMT.LIST,FM)
    Y.REC.COUNT = DCOUNT(AA.ARRANGEMENT.LIST,@FM)
    Y.COUNT = 1

    LOOP
    WHILE Y.COUNT LE Y.REC.COUNT
        Y.ARR.TERM.ID=Y.SEL.TERM.AMT.LIST<Y.COUNT>
*    AA.ARRANGEMENT.ID = FIELD(Y.ARR.TERM.ID,'-',1)
        AA.ARRANGEMENT.ID = AA.ARRANGEMENT.LIST<Y.COUNT>
        GOSUB READ.AA.ARRANGEMENT
        R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.LOAN.NO.POS,Y.COUNT>    = AA.ARRANGEMENT.ID
        R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.LOAN.PORTF.POS,Y.COUNT> = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
        R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.LOAN.PROD.POS,Y.COUNT>  = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
        R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.LOAN.STAT.POS,Y.COUNT>  = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
        GOSUB GET.LOAN.AMT

        Y.COUNT += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
*************
GET.LOAN.AMT:
*************
    ALTERNATE.ACCOUNT.ID = AA.ARRANGEMENT.ID
    GOSUB READ.ALTERNATE.ACCOUNT

    EB.CONTRACT.BALANCES.ID = R.ALTERNATE.ACCOUNT<AAC.GLOBUS.ACCT.NUMBER>
    GOSUB READ.EB.CONTRACT.BALANCES

    LOCATE 'CURACCOUNT' IN R.EB.CONTRACT.BALANCES<ECB.BAL.TYPE,1> SETTING Y.CURACCOUNT.POS ELSE
        R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.LOAN.AMT.POS,Y.COUNT> = '0'
        RETURN
    END

    Y.BAL.TYPE = R.EB.CONTRACT.BALANCES<ECB.BAL.TYPE,Y.CURACCOUNT.POS>
    Y.BT.ACT.MONTHS.LIST = R.EB.CONTRACT.BALANCES<ECB.BT.ACT.MONTHS,Y.CURACCOUNT.POS>
    Y.BT.ACT.MONTHS.LIST = SORT(Y.BT.ACT.MONTHS.LIST)
    Y.BT.ACT.MONTHS = FIELD(Y.BT.ACT.MONTHS.LIST,@FM,DCOUNT(Y.BT.ACT.MONTHS.LIST,@FM),1)

*TUS change START
*ACCT.ACTIVITY.ID = EB.CONTRACT.BALANCES.ID:'.': Y.BAL.TYPE:'-':Y.BT.ACT.MONTHS
    ACCT.BAL.ACTIVITY.ID = EB.CONTRACT.BALANCES.ID:'-':Y.BT.ACT.MONTHS

    GOSUB READ.ACCT.ACTIVITY
    IF R.ACCT.ACTIVITY THEN
        R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.LOAN.AMT.POS,Y.COUNT> = R.ACCT.ACTIVITY<IC.ACT.BK.BALANCE>
    END
*TUS change END
RETURN
*--------------------------------------------------------------------------------------------------------
********************
READ.AA.ARRANGEMENT:
********************
    R.AA.ARRANGEMENT  = ''
    AA.ARRANGEMENT.ER = ''
    CALL F.READ(FN.AA.ARRANGEMENT,AA.ARRANGEMENT.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
READ.ALTERNATE.ACCOUNT:
***********************
    R.ALTERNATE.ACCOUNT  = ''
    ALTERNATE.ACCOUNT.ER = ''
    CALL F.READ(FN.ALTERNATE.ACCOUNT,ALTERNATE.ACCOUNT.ID,R.ALTERNATE.ACCOUNT ,F.ALTERNATE.ACCOUNT ,ALTERNATE.ACCOUNT.ER)

RETURN
*----------------------------------------------------------------------------------------------------------
*************************
READ.EB.CONTRACT.BALANCES:
*************************
    R.EB.CONTRACT.BALANCES  = ''
    EB.CONTRACT.BALANCES.ER = ''
    CALL F.READ(FN.EB.CONTRACT.BALANCES,EB.CONTRACT.BALANCES.ID,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES,EB.CONTRACT.BALANCES.ER)

RETURN
*----------------------------------------------------------------------------------------------------------
*******************
READ.ACCT.ACTIVITY:
********************
*TUS change START
    R.ACCT.ACTIVITY  = ''
    R.ACCT.ACTIVITY.TEMP = ''
    R.ACCT.BAL.ACTIVITY = ''

    ACCT.ACTIVITY.ER = ''
    CALL F.READ(FN.ACCT.ACTIVITY,ACCT.BAL.ACTIVITY.ID,R.ACCT.BAL.ACTIVITY,F.ACCT.ACTIVITY,ACCT.ACTIVITY.ER)
    IF R.ACCT.BAL.ACTIVITY THEN
        LOCATE Y.BAL.TYPE IN R.ACCT.BAL.ACTIVITY<1, 1> SETTING BALANCE.TYPE.POS THEN
            R.ACCT.ACTIVITY.TEMP = R.ACCT.BAL.ACTIVITY<2, BALANCE.TYPE.POS>
            R.ACCT.ACTIVITY=RAISE(RAISE(R.ACCT.ACTIVITY.TEMP))
        END
    END
*TUS change END
RETURN
*-----------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    LREF.APPL = 'COLLATERAL'
    LREF.FIELDS = 'L.CO.LOAN.NO':@VM:'L.CO.LOAN.PORTF':@VM:'L.CO.LOAN.PROD':@VM:'L.CO.LOAN.STAT':@VM:'L.CO.LOAN.AMT':@VM:'L.CO.SEC.DOC'
    LREF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APPL, LREF.FIELDS, LREF.POS)

    LOC.L.CO.LOAN.NO.POS     = LREF.POS<1,1>
    LOC.L.CO.LOAN.PORTF.POS  = LREF.POS<1,2>
    LOC.L.CO.LOAN.PROD.POS   = LREF.POS<1,3>
    LOC.L.CO.LOAN.STAT.POS   = LREF.POS<1,4>
    LOC.L.CO.LOAN.AMT.POS    = LREF.POS<1,5>
    LOC.L.CO.SEC.DOC.POS     = LREF.POS<1,6>

RETURN
*---------------------------------------------------------------------------------------------------------------------------
END
