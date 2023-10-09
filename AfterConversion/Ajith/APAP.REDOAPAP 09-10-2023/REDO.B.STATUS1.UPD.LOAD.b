* @ValidationCode : MjotMTY1MDY4OTU6Q3AxMjUyOjE2OTY4Mjc4NzU1NTE6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Oct 2023 10:34:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.STATUS1.UPD.LOAD

*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RAJA SAKTHIVEL K P
* PROGRAM NAME : REDO.B.STATUS1.UPD.LOAD
*------------------------------------------------------------------
* Description : This is the load rotuine to initialise all the variables
* to be used in this batch routine
*------------------------------------------------------------------

*Modification Details:
*=====================
* 29-JUN-2010        RAJA SAKTHIVEL  ODR-2009-10-0315       Initial Creation
* 20-Apr-11          H Ganesh        PACS00054881           Logic added to read eb lookup
* 05-07-2011         JEEVA T          PACS00084781          reading account parameter file
* 05-02-2013         SHEK             Performance           Change REDO.CUST.PRD.LIST to REDO.CUST.PRD.LST


* DATE         NAME                     REFERENCE            DESCRIPTION
* 31 JAN 2023 Edwin Charles D         ACCOUNTING-CR            TSR479892

*------------------------------------------------------------------
*---------------------------------------------------------------------
* 09-10-2023     AJITH KUMAR .S               R22 MANUAL CODE CONVERSION                  FM ,VM,SM to @FM, @VM,@SM
*
*--------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.ACCOUNT.PARAMETER
    $INSERT I_REDO.B.STATUS1.UPD.COMMON
    $INSERT I_F.REDO.PREVALANCE.STATUS

    GOSUB INITIALISE
RETURN

INITIALISE:
    Y.STATUS.SEQ.ARRAY = ''
    Y.AC.ARRAY = ''
    LAST.CR.DT = ''
    SYS.DATE = ''
    NO.OF.MTHS = ''
    REF.POS = ''
    SEL.CMD = ''
    SEL.LIST = ''
    NO.OF.REC = ''
    RET.CODE = ''
    Y.LOOKUP.ARRAY=''
*R.ACCOUNT.PARAMETER = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.PARAMETER = 'F.ACCOUNT.PARAMETER'
    F.ACCOUNT.PARAMETER = ''
    CALL OPF(FN.ACCOUNT.PARAMETER,F.ACCOUNT.PARAMETER)

    FN.ACCOUNT.ACT = 'F.ACCOUNT.ACT'
    F.ACCOUNT.ACT = ''
    CALL OPF(FN.ACCOUNT.ACT,F.ACCOUNT.ACT)

    FN.CUST.PRD.LIST='F.REDO.CUST.PRD.LIST'
    F.CUST.PRD.LIST=''
    CALL OPF(FN.CUST.PRD.LIST,F.CUST.PRD.LIST)

    FN.CUST.PRD.LST='F.REDO.CUST.PRD.LST'
    F.CUST.PRD.LST=''
    CALL OPF(FN.CUST.PRD.LST, F.CUST.PRD.LST)

    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT=''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.AZ.ACCOUNT$HIS = 'F.AZ.ACCOUNT$HIS'
    F.AZ.ACCOUNT$HIS = ''
    CALL OPF(FN.AZ.ACCOUNT$HIS,F.AZ.ACCOUNT$HIS)

    FN.AZ.PRODUCT.PARAM='F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAM=''
    CALL OPF(FN.AZ.PRODUCT.PARAM,F.AZ.PRODUCT.PARAM)

    FN.UPD.ACC.LIST='F.REDO.UPD.ACC.LIST'
    F.UPD.ACC.LIST=''
    CALL OPF(FN.UPD.ACC.LIST,F.UPD.ACC.LIST)

    FN.EB.LOOKUP='F.EB.LOOKUP'
    F.EB.LOOKUP=''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)
*PACS00308629 - S
    FN.REDO.WAIVE.LEDGER.ACCT = 'F.REDO.WAIVE.LEDGER.ACCT'
    F.REDO.WAIVE.LEDGER.ACCT = ''
    CALL OPF(FN.REDO.WAIVE.LEDGER.ACCT,F.REDO.WAIVE.LEDGER.ACCT)
*PACS00308629 -E
    LREF.APP = 'ACCOUNT':@FM:'EB.LOOKUP':@FM:'AZ.ACCOUNT'
    LREF.FIELDS = 'L.AC.STATUS1':@VM:'L.AC.STATUS2':@VM:'L.AC.STATUS':@VM:'L.AC.AZ.ACC.REF':@FM:'L.AC.MONTHS':@VM:'L.WAIVE.LEDGER':@FM:'L.AC.STATUS'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    REF.POS=LREF.POS<1,1>
    STATUS2.POS=LREF.POS<1,2>
    Y.L.AC.STATUS.POS = LREF.POS<1,3>
    POS.L.AC.MONTHS=LREF.POS<2,1>
    POS.L.WAIVE.LEDGER= LREF.POS<2,2>
    Y.AZ.L.AC.STATUS.POS=LREF.POS<3,1>
    Y.AZ.ACC.REF.POS=LREF.POS<1,4>
    Y.LAST.WRK.DAY=R.DATES(EB.DAT.LAST.WORKING.DAY)
*PACS00308629-S
    Y.TRANS.ID = 'ACCOUNT'
    CALL CACHE.READ(FN.REDO.WAIVE.LEDGER.ACCT,Y.TRANS.ID,R.REDO.WAIVE.LEDGER.ACCT,WAIVE.ERR)
*PACS00308629-E
    PrdIdList = ''; PrdListRec = ''
    PARAM.STATUS = ''; PREVALANCE.STATUS = ''; STAT.FM.CNTR = 0 ; ACCT.TYPE.LIST = ''
    FN.REDO.PREVALANCE.STATUS = 'F.REDO.PREVALANCE.STATUS'
    F.REDO.PREVALANCE.STATUS = ''
    CALL OPF(FN.REDO.PREVALANCE.STATUS,F.REDO.PREVALANCE.STATUS)

* 20170327 /S TUS
    CALL CACHE.READ(FN.REDO.PREVALANCE.STATUS,'SYSTEM',R.REDO.PREVALANCE.STATUS,F.ERR)
    PARAM.STATUS.VAL = R.REDO.PREVALANCE.STATUS<REDO.PRE.STATUS>
    PREVALANCE.STATUS.VAL = CHANGE(R.REDO.PREVALANCE.STATUS<REDO.PRE.PREVALANT.STATUS>,@VM,@FM)
    ACCT.TYPE.VAL = CHANGE(R.REDO.PREVALANCE.STATUS<REDO.PRE.ACCT.TYPE>,@VM,@FM)

    STAT.FM.CNTR = DCOUNT(PARAM.STATUS.VAL,@VM)
    LOOP.FM.CNTR = 1

    LOOP
    WHILE LOOP.FM.CNTR LE STAT.FM.CNTR
        Y.FM.STATUS = PARAM.STATUS.VAL<1,LOOP.FM.CNTR>
*Y.FM.STATUS = SORT(Y.FM.STATUS)
        Y.FM.STATUS = CHANGE(Y.FM.STATUS,@FM,':')
        Y.FM.STATUS = CHANGE(Y.FM.STATUS,@SM,':')
        PARAM.STATUS<-1> = Y.FM.STATUS
        PREVALANCE.STATUS<-1> = PREVALANCE.STATUS.VAL<LOOP.FM.CNTR>
        ACCT.TYPE.LIST<-1> = ACCT.TYPE.VAL<LOOP.FM.CNTR>
        LOOP.FM.CNTR + = 1
    REPEAT
* 20170327 /E TUS

*   SYS.DATE = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    SYS.DATE = TODAY

    EB.LOOKUP.1='L.AC.STATUS1'
    CALL EB.LOOKUP.LIST(EB.LOOKUP.1)
    VIRTUAL.AC1.STATS = EB.LOOKUP.1<2>
    CHANGE '_' TO @FM IN VIRTUAL.AC1.STATS
    NO.OF.IDS = DCOUNT(VIRTUAL.AC1.STATS,@FM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE NO.OF.IDS
        Y.LOOKUP.ID=VIRTUAL.AC1.STATS<Y.VAR1>
        Y.LOOK.ID = "L.AC.STATUS1*":VIRTUAL.AC1.STATS<Y.VAR1>
        CALL F.READ(FN.EB.LOOKUP,Y.LOOK.ID,R.LOOKUP,F.EB.LOOKUP,LOOK.ERR)
        Y.LOOKUP.ARRAY<1,-1>=R.LOOKUP<EB.LU.LOOKUP.ID>
        Y.LOOKUP.ARRAY<2,-1>=R.LOOKUP<EB.LU.LOCAL.REF,POS.L.AC.MONTHS>
        Y.LOOKUP.ARRAY<3,-1>=R.LOOKUP<EB.LU.LOCAL.REF,POS.L.WAIVE.LEDGER>
        GOSUB GET.NDATE
        Y.LOOKUP.ARRAY<4,-1>=NDATE
        Y.VAR1++
    REPEAT
* //sort the dates.  this is useful to locate a date in a range
    SORTED.DATES = SORT(RAISE(Y.LOOKUP.ARRAY<4>)) ;* Sort the dates
RETURN

GET.NDATE:
*---------
    NDATE = ''
    Y.FUTURE.DATE = R.LOOKUP<EB.LU.LOCAL.REF,POS.L.AC.MONTHS>
    IF Y.FUTURE.DATE NE '' THEN
        CALL CALENDAR.DAY(SYS.DATE,"-",Y.FUTURE.DATE)
        NDATE = Y.FUTURE.DATE
    END ELSE
        NDATE = TODAY
    END

RETURN
*---------(GetNdate)
END
