* @ValidationCode : Mjo1OTQ5MzIzNTc6Q3AxMjUyOjE2ODUwNzk3NjY5MTc6SVRTUzotMTotMTo2NjM6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 May 2023 11:12:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 663
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.S.NOFILE.AC.STATUS(Y.FINAL.ARR)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :

*DATE          NAME                REFERENCE               DESCRIPTION
*31 JAN 2023   Edwin Charles D     ACCOUNTING-CR           TSR479892
*25-05-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM, FM TO @FM, I TO I.VAR
*25-05-2023    VICTORIA S          R22 MANUAL CONVERSION   call routine modified
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.REDO.PREVALANCE.STATUS
    $INSERT I_F.REDO.T.STATSEQ.BY.ACCT
    $INSERT I_F.REDO.T.ACCTSTAT.BY.DATE

    GOSUB OPEN.TABLE
    GOSUB PROCESS

RETURN

OPEN.TABLE:
**********
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.T.STATSEQ.BY.ACCT = 'F.REDO.T.STATSEQ.BY.ACCT'
    F.REDO.T.STATSEQ.BY.ACCT = ''
    CALL OPF(FN.REDO.T.STATSEQ.BY.ACCT,F.REDO.T.STATSEQ.BY.ACCT)

    FN.REDO.T.ACCTSTAT.BY.DATE = 'F.REDO.T.ACCTSTAT.BY.DATE'
    F.REDO.T.ACCTSTAT.BY.DATE = ''
    CALL OPF(FN.REDO.T.ACCTSTAT.BY.DATE,F.REDO.T.ACCTSTAT.BY.DATE)


    FN.EXP.FILE.PATH = '/T24/areas/t24cmctem/bnk/bnk.run/&SAVEDLISTS&'
    OPEN FN.EXP.FILE.PATH TO F.EXP.FILE.PATH ELSE
    END
***GETTING LOCAL STATUS VALUES 1&2***
    APPL = 'ACCOUNT'
    F.FIELDS = 'L.AC.STATUS1':@VM:'L.AC.STATUS2':@VM:'L.AC.STATUS' ;*R22 AUTO CONVERSION
    CALL MULTI.GET.LOC.REF(APPL,F.FIELDS,LOC.POS)
    Y.ST.PS1 = LOC.POS<1,1>
    Y.ST.PS2 = LOC.POS<1,2>
    Y.FIN.STATUS = LOC.POS<1,3>
RETURN

PROCESS:
********

    LOCATE "START.DATE" IN D.FIELDS<1> SETTING SRT.POS THEN
        START.DATE = D.RANGE.AND.VALUE<SRT.POS>
    END

    LOCATE "END.DATE" IN D.FIELDS<1> SETTING END.POS THEN
        END.DATE = D.RANGE.AND.VALUE<END.POS>
    END

    SEL.CMD = 'SELECT ':FN.REDO.T.ACCTSTAT.BY.DATE:' WITH @ID GE ':START.DATE:' AND WITH @ID LE ':END.DATE
    CALL EB.READLIST (SEL.CMD, SEL.LIST, '', NO.OF.REC, ERR.LIST)

    LOOP
        REMOVE DAT.ID FROM SEL.LIST SETTING DATE.POS
    WHILE DAT.ID:DATE.POS DO
        CALL F.READ(FN.REDO.T.ACCTSTAT.BY.DATE,DAT.ID,DAT.REC,F.REDO.T.ACCTSTAT.BY.DATE,DAT.ER)
****AC TABLE****
        GOSUB ACCOUNT.STATUS
        ACCT.ARR<-1> = TEMP.ARR
    REPEAT

    GOSUB ACCOUNT.WISE

    CHANGE @VM TO '*' IN Y.ARRAY ;*R22 AUTO CONVERSION
    CHANGE '|' TO @FM IN Y.ARRAY ;*R22 AUTO CONVERSION
    Y.FINAL.ARR<-1> = Y.ARRAY
RETURN

ACCOUNT.STATUS:
***************
    TEMP.ARR = ''
    DEB.MOV = ''
    LOOP
        REMOVE AC.ID FROM DAT.REC SETTING AC.POS
    WHILE AC.ID:AC.POS DO
***LOCAL STATUS****
        CALL F.READ(FN.REDO.T.STATSEQ.BY.ACCT,AC.ID,AC.STATUS.REC,F.REDO.T.STATSEQ.BY.ACCT,AC.ER)
        AC.LOC.STATUS = AC.STATUS.REC<REDT.L.AC.STATUS.HAPPEN>
        CNT.STATUS = DCOUNT(AC.LOC.STATUS,@VM) ;*R22 AUTO CONVERSION
        AC.FINAL.STATUS = AC.LOC.STATUS<1,CNT.STATUS>
        CALL F.READ(FN.ACCOUNT,AC.ID,AC.REC,F.ACCOUNT,ACCT.ERR)
        AC.FINAL.STATUS = AC.REC<AC.LOCAL.REF,Y.FIN.STATUS>
        AC.BAL = '' ; INT.BAL = ''
***LOCK DATE WITH IN RANGE OF START DATE***

        BOOKING.DATE = DAT.ID

*CALL REDO.V.CHECK.BAL.INT.ENTRIES(AC.ID,BAL.CR.AMT,BAL.DR.AMT,INT.CR.AMT,INT.DR.AMT,Y.BAL.DET,Y.INT.DET)
        CALL APAP.REDOAPAP.redoVCheckBalIntEntries(AC.ID,BAL.CR.AMT,BAL.DR.AMT,INT.CR.AMT,INT.DR.AMT,Y.BAL.DET,Y.INT.DET) ;*R22 MANUAL CONVERSION
        IF BAL.CR.AMT OR BAL.DR.AMT THEN
            BALANCE.TYPE = 'PRINCIPAL'
            AC.BAL = AC.REC<AC.WORKING.BALANCE>
            TEMP.ARR<-1> = AC.ID:'*':BOOKING.DATE:'*':AC.FINAL.STATUS:'*':AC.BAL:'*':BAL.DR.AMT:'*':BAL.CR.AMT:'*':BALANCE.TYPE
        END

        IF INT.CR.AMT OR INT.DR.AMT THEN
            BALANCE.TYPE = 'CR-INT' ; INT.BAL = INT.DR.AMT + INT.CR.AMT
            TEMP.ARR<-1> = AC.ID:'*':BOOKING.DATE:'*':AC.FINAL.STATUS:'*':INT.BAL:'*':INT.DR.AMT:'*':INT.CR.AMT:'*':BALANCE.TYPE
        END

    REPEAT
RETURN

ACCOUNT.WISE:
*************

    TOT.CNT = DCOUNT(ACCT.ARR,@FM) ;*R22 AUTO CONVERSION START
    FOR I.VAR = 1 TO TOT.CNT
        Y.CHECK = ACCT.ARR<I.VAR>
        CHANGE '*' TO @VM IN Y.CHECK
        Y.AC.ID = FIELD(Y.CHECK,@VM,1) ;*R22 AUTO CONVERSION END
        FIND Y.AC.ID IN Y.ARRAY SETTING Y.POS THEN
            Y.CHECK = CHANGE(Y.CHECK,Y.AC.ID,'|')
            Y.ARRAY<Y.POS,-1> = Y.CHECK
        END ELSE
            Y.ARRAY<-1> = Y.CHECK
        END

    NEXT I.VAR ;*R22 AUTO CONVERSION

RETURN
END
