* @ValidationCode : Mjo5MDY3ODc0MDc6Q3AxMjUyOjE2ODIzMTY4MDM3NzM6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 11:43:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.AA.ADV.PAY.RPT
*-------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED,++ TO +=1
*24-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_BATCH.FILES
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ACTIVITY.BALANCES
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.L.NCF.STOCK
    $INSERT I_F.REDO.H.REPORTS.PARAM     ;*R22 AUTO CODE CONVERSION.END

    GOSUB INIT
    GOSUB GET.PARAM
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'; F.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)
    FN.AA.ACTIVITY.BALANCES = 'F.AA.ACTIVITY.BALANCES'; F.AA.ACTIVITY.BALANCES = ''
    CALL OPF(FN.AA.ACTIVITY.BALANCES,F.AA.ACTIVITY.BALANCES)
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'; F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    FN.REDO.L.NCF.STOCK = 'F.REDO.L.NCF.STOCK'; F.REDO.L.NCF.STOCK = ''
    CALL OPF(FN.REDO.L.NCF.STOCK,F.REDO.L.NCF.STOCK)
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'; F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    YEND.DATE = ''; YSTART.DATE = ''
RETURN

GET.PARAM:
**********
    Y.LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    REDO.L.NCF.STOCK.ERR = ''; R.REDO.L.NCF.STOCK = ''; YBALANC.TYP = ''
    CALL CACHE.READ(FN.REDO.L.NCF.STOCK,'SYSTEM',R.REDO.L.NCF.STOCK,REDO.L.NCF.STOCK.ERR)
    YBALANC.TYP = R.REDO.L.NCF.STOCK<ST.AA.IC.TYPE>
    Y.PARAM.ID = 'REDO.AA.ADVPAY'; R.REDO.H.REPORTS.PARAM = ''; Y.PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,Y.PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
    END
    LOCATE 'FROM.DATE' IN Y.FIELD.NAME<1,1> SETTING Y.FRM.POS THEN
        YSTART.DATE = Y.FIELD.VAL<1,Y.FRM.POS>
    END
    LOCATE 'TO.DATE' IN Y.FIELD.NAME<1,1> SETTING Y.TO.POS THEN
        YEND.DATE = Y.FIELD.VAL<1,Y.TO.POS>
    END
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    Y.FINAL.OUT.FILE.NAME = Y.FILE.NAME:TODAY:".txt"
    R.FIL = ''; READ.FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,Y.FINAL.OUT.FILE.NAME,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,Y.FINAL.OUT.FILE.NAME
    END
    IF NOT(YSTART.DATE) AND NOT(YEND.DATE) THEN
        YSTART.DATE = Y.LAST.WORK.DAY[1,6]:'01'
        COMI = YSTART.DATE
        CALL LAST.DAY.OF.THIS.MONTH
        YEND.DATE = COMI
    END
RETURN

PROCESS:
********
    YFILE.VAL = "ACCOUNT.NUMBER|EFFECTIVE DATE|AMOUNT|ACTIVITY ID|ACTIVITY"
    SEL.AACMD = "SSELECT ":FN.AA.ARRANGEMENT.ACTIVITY:" WITH ACTIVITY EQ 'LENDING-SETTLE-RP.PAGO.ANTICIPADO' AND (EFFECTIVE.DATE GE ":YSTART.DATE:" AND EFFECTIVE.DATE LE ":YEND.DATE:")"
    CALL EB.READLIST(SEL.AACMD,SEL.REC,'',SEL.LIST,SEL.ERR)
    ACTIVTTY.VAL = "LENDING-SETTLE-RP.PAGO.ANTICIPADO"
    LOOP
        REMOVE AAA.ID FROM SEL.REC SETTING AAA.POSN
    WHILE AAA.ID:AAA.POSN
        ERR.AAA = ''; R.AA.ARRANGEMENT.ACTIVITY = ''; YTOTAL.AMOUNT = 0
        CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,AAA.ID,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,ERR.AAA)
        AA.ARR.ID = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.ARRANGEMENT>
        AA.EFF.ID = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.EFFECTIVE.DATE>
        YTOTAL.AMOUNT = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.AMOUNT.LCY>
        ERR.AAB = ''; R.AA.ACTIVITY.BALANCES = ''; ACT.REF = ''; V.POSN = 0; YTOT.AMT = 0
        CALL F.READ(FN.AA.ACTIVITY.BALANCES,AA.ARR.ID,R.AA.ACTIVITY.BALANCES,F.AA.ACTIVITY.BALANCES,ERR.AAB)
        ACT.REF = R.AA.ACTIVITY.BALANCES<AA.ACT.BAL.ACTIVITY.REF>
        LOCATE AAA.ID IN ACT.REF<1,1> SETTING V.POSN THEN
            GOSUB PROCESS.SUB
        END
        ERR.AA.ARR = ''; R.AA.ARRANGEMENT = ''; YACCOUNT.NO = ''; YTEMP.AMT = ''
        CALL F.READ(FN.AA.ARRANGEMENT,AA.ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ERR.AA.ARR)
        YACCOUNT.NO  = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
        YTEMP.AMT = YTOTAL.AMOUNT - YTOT.AMT
        IF YTOT.AMT GT 0 THEN
            YFILE.VAL<-1> = YACCOUNT.NO:"|":AA.EFF.ID:"|":YTOT.AMT:"|":AAA.ID:"|":ACTIVTTY.VAL
        END
    REPEAT

    WRITE YFILE.VAL ON F.CHK.DIR, Y.FINAL.OUT.FILE.NAME ON ERROR
        Y.ERR.MSG = "Unable to Write ":Y.FINAL.OUT.FILE.NAME
        RETURN
    END
    R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,Y.FRM.POS> = ''
    R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,Y.TO.POS> = ''
    CALL F.WRITE(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM)
RETURN

PROCESS.SUB:
************
    YTOT.AMT= 0
    ACT.PROP = R.AA.ACTIVITY.BALANCES<AA.ACT.BAL.PROPERTY,V.POSN>
    ACT.PROP.AMT = R.AA.ACTIVITY.BALANCES<AA.ACT.BAL.PROPERTY.AMT,V.POSN>
    CNT = 1
    LOOP
        REMOVE ACT.ID FROM ACT.PROP SETTING ACT.POSN
    WHILE ACT.ID:ACT.POSN
        ACT.VAL = ''
        ACT.VAL = FIELD(ACT.ID,'.',2)
        LOCATE ACT.VAL IN YBALANC.TYP<1,1> SETTING YPOSN THEN
            YTOT.AMT += R.AA.ACTIVITY.BALANCES<AA.ACT.BAL.PROPERTY.AMT,V.POSN,CNT>
        END
        CNT += 1
    REPEAT
RETURN
END
