SUBROUTINE REDO.CONV.MNEM.TO.STATUS(ACCT.ID,Y.STATUS)
*---------------------------------------------------------------------------------
*This is call routine to get the reclassification accounts for entries
*----------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : Edwin Charles
* Program Name  : REDO.CONV.MNEM.TO.STATUS
*
* Routine Name   :REDO.CONV.MNEM.TO.STATUS
* LINKED WITH:
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
* MODIFICATION DETAILS:
*  DATE               NAME                       REFERENCE                           DESCRIPTION
* 31 JAN 2023    Edwin Charles D               ACCOUNTING-CR                             TSR479892

*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.T.STATSEQ.BY.ACCT
    $INSERT I_F.DATES
    $INSERT I_F.REDO.T.ACCTSTAT.BY.DATE

    GOSUB INIT
    GOSUB PROCESS
RETURN
*----------------------------
INIT:

    FN.REDO.T.STATSEQ.BY.ACCT = 'F.REDO.T.STATSEQ.BY.ACCT'
    F.REDO.T.STATSEQ.BY.ACCT = ''
    CALL OPF(FN.REDO.T.STATSEQ.BY.ACCT,F.REDO.T.STATSEQ.BY.ACCT)

    FN.REDO.T.ACCTSTAT.BY.DATE = 'F.REDO.T.ACCTSTAT.BY.DATE'
    F.REDO.T.ACCTSTAT.BY.DATE = ''
    CALL OPF(FN.REDO.T.ACCTSTAT.BY.DATE,F.REDO.T.ACCTSTAT.BY.DATE)

    FN.DATES = 'F.DATES'
    F.DATES = ''
    CALL OPF(FN.DATES,F.DATES)

RETURN

*----------------------------
PROCESS:
*********

    IF Y.STATUS THEN
        Y.TEMP.STATUS = CHANGE(Y.STATUS,'-',@FM)
        Y.STATUS = ''
    END ELSE
        R.DATE = ''
        CALL CACHE.READ(FN.DATES, 'DO0010001', R.DATE, DAT.ERR)
****LAST WORKING IS USE FOR COB****
        CURR.DATE = R.DATE<EB.DAT.LAST.WORKING.DAY>
***TODAY IS USE FOR ONLINE TEST SERVICE****
*        CURR.DATE = TODAY
        CALL F.READ(FN.REDO.T.ACCTSTAT.BY.DATE,CURR.DATE,R.REDO.T.ACCTSTAT.BY.DATE,F.REDO.T.ACCTSTAT.BY.DATE,DATE.ERR)
        DATE.ARRAY = R.REDO.T.ACCTSTAT.BY.DATE<REDAT.ACCOUNT>
        CHANGE @VM TO @FM IN DATE.ARRAY
        LOCATE ACCT.ID IN DATE.ARRAY<1> SETTING DAT.POS THEN
            CALL F.READ(FN.REDO.T.STATSEQ.BY.ACCT,ACCT.ID,R.REDO.T.STATSEQ.BY.ACCT,F.REDO.T.STATSEQ.BY.ACCT,ACCT.ERR)
            R.OLD.COMB.STATUS = R.REDO.T.STATSEQ.BY.ACCT<REDT.L.AC.STATUS.HAPPEN>
            CNT.OLD = DCOUNT(R.OLD.COMB.STATUS,@VM)
            R.OLD.COMB.STATUS.FINAL = R.REDO.T.STATSEQ.BY.ACCT<REDT.L.AC.STATUS.HAPPEN,CNT.OLD>
            Y.TEMP.STATUS = ''
            Y.TEMP.STATUS = CHANGE(R.OLD.COMB.STATUS.FINAL,'-',@FM)
        END
    END

    TOT.STATUS = DCOUNT(Y.TEMP.STATUS,@FM)
    STS.CNT = '1'
    LOOP
    WHILE STS.CNT LE TOT.STATUS
        BEGIN CASE
            CASE Y.TEMP.STATUS<STS.CNT> EQ 'AC'
                Y.STATUS<-1> = 'ACTIVE'
            CASE Y.TEMP.STATUS<STS.CNT> EQ 'IL'
                Y.STATUS<-1> = '3YINACTIVE'
            CASE Y.TEMP.STATUS<STS.CNT> EQ 'IM'
                Y.STATUS<-1> = 'ABANDONED'
            CASE Y.TEMP.STATUS<STS.CNT> EQ 'EM'
                Y.STATUS<-1> = 'GARNISHMENT'
            CASE Y.TEMP.STATUS<STS.CNT> EQ 'PG'
                Y.STATUS<-1> = 'GUARANTEE.STATUS'
            CASE Y.TEMP.STATUS<STS.CNT> EQ 'FA'
                Y.STATUS<-1> = 'DECEASED'
        END CASE
        STS.CNT += 1
    REPEAT
    Y.STATUS = CHANGE(Y.STATUS,@FM,':')
RETURN
END