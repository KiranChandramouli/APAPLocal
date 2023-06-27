* @ValidationCode : MjotMzc3MzMxMzM2OkNwMTI1MjoxNjg1MDc5NzY4MDY1OklUU1M6LTE6LTE6ODU1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 May 2023 11:12:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 855
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.V.AUTH.LOCK.ACCT
*---------------------------------------------------------------------------------
*This is an Authorisation routine for the version AC.LOCKED.EVENTS,INPUT it will lock
*the customer's account
*----------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : GANESH R
* Program Name  : REDO.V.INP.GARNISHMENT.MAINT
* ODR NUMBER    : ODR-2009-10-0531
* HD REFERENCE  : HD1016159
*Routine Name   :REDO.V.AUTH.LOCK.ACCT
*LINKED WITH:
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
*MODIFICATION DETAILS:
*27.4.2010       ODR-2009-10-0531
* 16-02-2011        Prabhu.N         B.88-HD1040884  Once the garnishment amount is over it will return the value
*  DATE            NAME                  REFERENCE                     DESCRIPTION
* 24 NOV  2022    Edwin Charles D       ACCOUNTING-CR                 Changes applied for Accounting reclassification CR
*25-05-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM, VM TO @VM, SM TO @SM, ++ TO +=1
*25-05-2023    VICTORIA S          R22 MANUAL CONVERSION   Call routine modified
*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.LOCKING
    $INSERT I_F.OVERRIDE

    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN
*----------------------------
INIT:
    LOC.APPLICATION='AC.LOCKED.EVENTS':@FM:'ACCOUNT' ;*R22 AUTO CONVERSION
    LOCAL.FIELD='L.AC.GAR.AMT':@VM:'L.AC.ACCT.LOCK':@VM:'L.AC.CUSTOMER':@VM:'L.AC.GAR.REF.NO':@VM:'L.AC.LOCKE.TYPE':@VM:'L.AC.AVAIL.BAL':@VM:'L.AC.STATUS2':@FM:'L.AC.AV.BAL' ;*R22 AUTO CONVERSION
    LOC.POS=''
    VAR.COUNT1=2
    OVERRIDE.ID='GARNISH.AMT.NOT.EQUAL'
    LOCK.AMT = 0
RETURN
*------------------------------
OPENFILE:

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AC.LOCKED.EVENTS='F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS=''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    FN.LOCKING='F.LOCKING'
    F.LOCKING=''
    CALL OPF(FN.LOCKING,F.LOCKING)

    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT=''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.OVERRIDE='F.OVERRIDE'
    F.OVERRIDE=''
    CALL OPF(FN.OVERRIDE,F.OVERRIDE)
RETURN

*----------------------------
PROCESS:
    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOCAL.FIELD,LOC.POS)
    LOC.GAR.AMT.POS=LOC.POS<1,1>
    LOC.ACCT.LOCK.POS=LOC.POS<1,2>
    LOC.CUSTOMER.POS=LOC.POS<1,3>
    LOC.GAR.REF.POS=LOC.POS<1,4>
    LOC.LOCK.TYPE.POS=LOC.POS<1,5>
    LOC.AVAIL.BAL.POS=LOC.POS<1,6>
    LOC.STATUS.POS=LOC.POS<1,7>
    Y.ACC.AV.POS=LOC.POS<2,1>
    VAL.GAR.AMT=R.NEW(AC.LCK.LOCAL.REF)<1,LOC.GAR.AMT.POS>
    VAL.ACCT.LOCK=R.NEW(AC.LCK.LOCAL.REF)<1,LOC.ACCT.LOCK.POS>
    ACCT.COUNT=DCOUNT(VAL.ACCT.LOCK,@SM) ;*R22 AUTO CONVERSION
    VAR.LOCK.AMT=R.NEW(AC.LCK.LOCKED.AMOUNT)

    CUSTOMER=R.NEW(AC.LCK.LOCAL.REF)<1,LOC.CUSTOMER.POS>
*CALL F.READ(FN.CUSTOMER.ACCOUNT,CUSTOMER,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,CUST.ERR)
    VAR.TOT.LOCK.AMT=VAR.LOCK.AMT
    LOOP
    WHILE VAR.COUNT1 LE ACCT.COUNT
        GOSUB PROCESS1
        VAR.COUNT1 += 1 ;*R22 AUTO CONVERSION
    REPEAT
RETURN

********
PROCESS1:
*********
* B.88-HD1040884-Start of modification-------------
    IF VAL.GAR.AMT LE VAR.TOT.LOCK.AMT THEN
        RETURN
    END
*-------Modification ends--------------------------------
    ACC.LOCK.ID=FIELD(VAL.ACCT.LOCK,@SM,VAR.COUNT1) ;*R22 AUTO CONVERSION
    CALL F.READ(FN.ACCOUNT,ACC.LOCK.ID,REC.ACCOUNT,F.ACCOUNT,ERR.ACC)
    VAR.GARNISH.AMT = VAL.GAR.AMT - VAR.LOCK.AMT - LOCK.AMT
    BALANCE=REC.ACCOUNT<AC.LOCAL.REF><1,Y.ACC.AV.POS>
    IF BALANCE GT VAR.GARNISH.AMT THEN
        LOCK.AMT = VAR.GARNISH.AMT
    END
    ELSE
        LOCK.AMT = BALANCE
    END
    VAR.TOT.LOCK.AMT += LOCK.AMT ;*R22 AUTO CONVERSION
    VAR.GAR.REF=R.NEW(AC.LCK.LOCAL.REF)<1,LOC.GAR.REF.POS>
    VAR.CUSTOMER=R.NEW(AC.LCK.LOCAL.REF)<1,LOC.CUSTOMER.POS>
    VAR.AVAIL.BAL=R.NEW(AC.LCK.LOCAL.REF)<1,LOC.AVAIL.BAL.POS>
    VAR.STATUS=R.NEW(AC.LCK.LOCAL.REF)<1,LOC.STATUS.POS>
    VAR.LOCK.TYPE=R.NEW(AC.LCK.LOCAL.REF)<1,LOC.LOCK.TYPE.POS>
    VAR.FROM.DATE=R.NEW(AC.LCK.FROM.DATE)
    VAR.TO.DATE=R.NEW(AC.LCK.TO.DATE)
    GOSUB CREATE.LOCK.ID
    ACCT.ID='ACLK':VAL.CONTENT
    CALL F.READ(FN.AC.LOCKED.EVENTS,ACCT.ID,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,EVENTS.ERR)
    R.AC.LOCKED.EVENTS<AC.LCK.ACCOUNT.NUMBER> = ACC.LOCK.ID
    R.AC.LOCKED.EVENTS<AC.LCK.FROM.DATE> = VAR.FROM.DATE
    R.AC.LOCKED.EVENTS<AC.LCK.TO.DATE> = VAR.TO.DATE
    R.AC.LOCKED.EVENTS<AC.LCK.LOCKED.AMOUNT> = LOCK.AMT
    R.AC.LOCKED.EVENTS<AC.LCK.LOCAL.REF,LOC.GAR.REF.POS> = VAR.GAR.REF
    R.AC.LOCKED.EVENTS<AC.LCK.LOCAL.REF,LOC.AVAIL.BAL.POS> = VAR.AVAIL.BAL
    R.AC.LOCKED.EVENTS<AC.LCK.LOCAL.REF,LOC.CUSTOMER.POS> = VAR.CUSTOMER
    R.AC.LOCKED.EVENTS<AC.LCK.LOCAL.REF,LOC.GAR.AMT.POS> = VAR.GARNISH.AMT
    R.AC.LOCKED.EVENTS<AC.LCK.LOCAL.REF,LOC.ACCT.LOCK.POS> = VAL.ACCT.LOCK
    APP.NAME = 'AC.LOCKED.EVENTS'
    OFSFUNCT = 'I'
    PROCESS  = 'PROCESS'
    OFSVERSION = 'AC.LOCKED.EVENTS,LOCK'
    GTSMODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = ACCT.ID
    OFSRECORD = ''

    OFS.MSG.ID =''
    OFS.SOURCE.ID = 'REDO.OFS.ACI.UPDATE'
    OFS.ERR = ''

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.AC.LOCKED.EVENTS,OFSRECORD)
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

**** CALL ROUTINE TO UPDATE IN DATE TABLE****

*CALL REDO.UPD.ACCOUNT.STATUS.DATE(ACC.LOCK.ID,VAR.STATUS)
    APAP.REDOAPAP.redoUpdAccountStatusDate(ACC.LOCK.ID,VAR.STATUS) ;*R22 MANUAL CONVERSION
*********************************************
RETURN
**************
CREATE.LOCK.ID:
***************
    LOCKING.ID='FBNK.AC.LOCKED.EVENTS'
    CALL F.READ(FN.LOCKING,LOCKING.ID,R.LOCKING,F.LOCKING,LOCK.ERR)
    VAR.CONTENT=R.LOCKING<EB.LOK.CONTENT>
    VAL.CONTENT = VAR.CONTENT[5,11] + 1
    VAR.REMARK=R.LOCKING<EB.LOK.REMARK>
    ACCT.ID='ACLK':VAL.CONTENT
    R.LOCKING<EB.LOK.CONTENT>='ACLK':VAL.CONTENT
    R.LOCKING<EB.LOK.REMARK>=VAR.REMARK
    CALL F.WRITE(FN.LOCKING,LOCKING.ID,R.LOCKING)
RETURN
END
