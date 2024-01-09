* @ValidationCode : MjoxMzk4OTY0MzYyOkNwMTI1MjoxNjk3NzE3MDc1MzM1OnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Oct 2023 17:34:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
    $PACKAGE APAP.REDOAPAP
*-----------------------------------------------------------------------------
* <Rating>-57</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.UPD.ACCOUNT.STATUS.DATE(ACCOUNT.ID,STATUS.SEQ)
*-------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.B.PREVALANCE.STATUS
*DESCRIPTION:This is call routone, used to update the status and its updated dates for the fields L.AC.STATUS1 and L.AC.STATUS2)
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : ACCOUNT.ID
*     : STATUS.SEQ
* OUT :
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*--------------------------------------------------------------------------------------
* Date            Developer         Development        Details
*--------------------------------------------------------------------------------------
* 13-01-2023         Edwin                Accounting CR      Deceased status update
* 31 JAN 2023�   Edwin Charles D�         ACCOUNTING-CR�             TSR479892
* 16-02-2023     Edwin Charles D�         ACCOUNTING-CR              TSR-502386
* 20 AUG 2023�   Edwin Charles D�         ACCOUNTING-CR�             TSR637100
* 19 OCT 2023  VICTORIA S                 MANUAL CONVERSION              FM TO @FM, VM TO @VM, SM TO @SM
* 26 NOV 2023  EDWIN CHARLES              R22 Conversion COB issue
*--------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_F.REDO.PREVALANCE.STATUS
    $INSERT I_F.REDO.T.ACCTSTAT.BY.DATE
    $INSERT I_F.REDO.T.STATSEQ.BY.ACCT
    $INSERT I_REDO.B.STATUS1.UPD.COMMON

*-------------------------------------------------------------------------------
    IF ACCOUNT.ID AND STATUS.SEQ THEN
        GOSUB INIT
        GOSUB PROCESS
    END

    RETURN
*--------------------------------------------------------------------------------
INIT:
*****
    FN.REDO.T.ACCTSTAT.BY.DATE = 'F.REDO.T.ACCTSTAT.BY.DATE'
    F.REDO.T.ACCTSTAT.BY.DATE = ''
    CALL OPF(FN.REDO.T.ACCTSTAT.BY.DATE,F.REDO.T.ACCTSTAT.BY.DATE)

    FN.REDO.T.STATSEQ.BY.ACCT = 'F.REDO.T.STATSEQ.BY.ACCT'
    F.REDO.T.STATSEQ.BY.ACCT = ''
    CALL OPF(FN.REDO.T.STATSEQ.BY.ACCT,F.REDO.T.STATSEQ.BY.ACCT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.DATES = 'F.DATES'
    F.DATES = ''
    CALL OPF(FN.DATES,F.DATES)

*To capture the ACCOUNT ids into savedlists

    IF RUNNING.UNDER.BATCH THEN
        FN.EXP.FILE.PATH = '&SAVEDLISTS&/TEMP.ACCOUNTS'     ;* R22 COB issue
        OPEN FN.EXP.FILE.PATH TO F.EXP.FILE.PATH ELSE
            Y.MK.CMD = "mkdir ../bnk.run/&SAVEDLISTS&/TEMP.ACCOUNTS"
            EXECUTE Y.MK.CMD
            OPEN FN.EXP.FILE.PATH TO F.EXP.FILE.PATH ELSE
            END
        END
    END

    APPL = 'ACCOUNT'
    F.FIELDS = 'L.AC.STATUS1':@VM:'L.AC.STATUS2'  ;*R22 MANUAL CONVERSION
    CALL MULTI.GET.LOC.REF(APPL,F.FIELDS,LOC.POS)
    Y.ST.PS1 = LOC.POS<1,1>
    Y.ST.PS2 = LOC.POS<1,2>

    RETURN

PROCESS:
*--------------------------------------------------------------------------------
    R.DATE = ''
    CALL F.READ(FN.DATES,'DO0010001',R.DATE,F.DATES,DAT.ERR)
    IF RUNNING.UNDER.BATCH THEN
*CURR.DATE = R.DATE<EB.DAT.LAST.WORKING.DAY>
    END ELSE
        CURR.DATE = TODAY
    END

    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,AC.ERR)
    CALL F.READ(FN.REDO.T.ACCTSTAT.BY.DATE,CURR.DATE,R.REDO.T.ACCTSTAT.BY.DATE,F.REDO.T.ACCTSTAT.BY.DATE,DATE.ERR)
    DATE.ARRAY = R.REDO.T.ACCTSTAT.BY.DATE<REDAT.ACCOUNT>

    CHANGE @VM TO @FM IN DATE.ARRAY     ;*R22 MANUAL CONVERSION
    IF STATUS.SEQ MATCHES 'DECEASED':@VM:'GARNISHMENT':@VM:'GARNISHMENT.REV':@VM:'GUARANTEE.REV' THEN         ;*TSR637100 ;*R22 MANUAL CONVERSION
    END ELSE
        LOCATE ACCOUNT.ID IN DATE.ARRAY<1> SETTING DAT.POS THEN
        END ELSE
            R.REDO.T.ACCTSTAT.BY.DATE<REDAT.ACCOUNT,-1> = ACCOUNT.ID
            IF NOT(RUNNING.UNDER.BATCH) THEN      ;* For online only
                WRITE R.REDO.T.ACCTSTAT.BY.DATE ON F.REDO.T.ACCTSTAT.BY.DATE,CURR.DATE
            END ELSE
                WRITE ACCOUNT.ID ON F.EXP.FILE.PATH, ACCOUNT.ID ON ERROR        ;* For Batch job only
                    Y.ERR.MSG = "Unable to Write '":F.EXP.FILE.PATH:"'"
                END
            END
        END
    END

    CALL F.READ(FN.REDO.T.STATSEQ.BY.ACCT,ACCOUNT.ID,R.REDO.T.STATSEQ.BY.ACCT,F.REDO.T.STATSEQ.BY.ACCT,ACCT.ERR)
    R.OLD.COMB.STATUS =  R.REDO.T.STATSEQ.BY.ACCT<REDT.L.AC.STATUS.HAPPEN>
    CNT.OLD = DCOUNT(R.OLD.COMB.STATUS,@VM)       ;*R22 MANUAL CONVERSION
    R.OLD.COMB.STATUS.FINAL = R.REDO.T.STATSEQ.BY.ACCT<REDT.L.AC.STATUS.HAPPEN,CNT.OLD>

    GOSUB FINAL.STATUS.UPDATE

    IF R.OLD.COMB.STATUS.FINAL NE COMB.STATUS THEN
        BEGIN CASE
        CASE NOT(R.OLD.COMB.STATUS.FINAL)
            R.REDO.T.STATSEQ.BY.ACCT<REDT.L.AC.STATUS.HAPPEN> = COMB.STATUS     ;* This is called for writing the first status update
            WRITE R.REDO.T.STATSEQ.BY.ACCT ON F.REDO.T.STATSEQ.BY.ACCT,ACCOUNT.ID
            Y.AC.ARRAY<-1> = ACCOUNT.ID
            Y.STATUS.SEQ.ARRAY<-1> = COMB.STATUS
        CASE 1
            R.REDO.T.STATSEQ.BY.ACCT<REDT.L.AC.STATUS.HAPPEN,-1> = COMB.STATUS
            WRITE R.REDO.T.STATSEQ.BY.ACCT ON F.REDO.T.STATSEQ.BY.ACCT,ACCOUNT.ID
            Y.AC.ARRAY<-1> = ACCOUNT.ID
            Y.STATUS.SEQ.ARRAY<-1> = COMB.STATUS
        END CASE
    END

    RETURN

FINAL.STATUS.UPDATE:
********************
    Y.FINAL.MNEM = ''
    Y.FINAL.MNEM = CHANGE(R.OLD.COMB.STATUS.FINAL,'-',@FM)  ;*R22 MANUAL CONVERSION
    Y.FINAL.STATUS = CHANGE(STATUS.SEQ,':',@FM)   ;*R22 MANUAL CONVERSION

****THIS WILL EXECUTE ONLY FOR STATSEQ HAS CONTAIN STATUS1 VALUE*****
    TOT.STATUS = 0
    TOT.STATUS = DCOUNT(Y.FINAL.STATUS,@FM)       ;*R22 MANUAL CONVERSION
    IF Y.FINAL.STATUS MATCHES 'ACTIVE':@VM:'6MACTIVE':@VM:'3YINACTIVE':@VM:'ABANDONED' THEN         ;* applicable for one status on current changes ;*R22 MANUAL CONVERSION
        GOSUB REMOVE.STATUS.ONE
    END

    STS.CNT = 1
    LOOP
    WHILE STS.CNT LE TOT.STATUS
        Y.MNEM = ''; Y.MNEM2 = ''
        Y.MNEM = Y.FINAL.STATUS<STS.CNT>; Y.MNEM2 = Y.FINAL.STATUS<STS.CNT>
        GOSUB AC.STS1.MNEM
        GOSUB AC.STS2.MNEM
        STS.CNT++
    REPEAT

    COMB.STATUS = CHANGE(Y.FINAL.MNEM,@FM,'-')    ;*R22 MANUAL CONVERSION

    RETURN

REMOVE.STATUS.ONE:
******************

    LOCATE 'AC' IN Y.FINAL.MNEM<1> SETTING POS1 THEN
        DEL Y.FINAL.MNEM<POS1>
    END
    LOCATE 'IL' IN Y.FINAL.MNEM<1> SETTING POS1 THEN
        DEL Y.FINAL.MNEM<POS1>
    END
    LOCATE 'IM' IN Y.FINAL.MNEM<1> SETTING POS1 THEN
        DEL Y.FINAL.MNEM<POS1>
    END

    RETURN

AC.STS1.MNEM:
*************
    TOT.STAT = DCOUNT(Y.FINAL.MNEM, @FM)          ;*R22 MANUAL CONVERSION
    BEGIN CASE

    CASE Y.FINAL.MNEM<TOT.STAT> NE 'AC' AND (Y.MNEM EQ 'ACTIVE' OR Y.MNEM EQ '6MACTIVE')
        LOCATE 'AC' IN Y.FINAL.MNEM<1> SETTING POS1 THEN
            DEL Y.FINAL.MNEM<POS1>
        END
        Y.FINAL.MNEM<-1> = 'AC'

    CASE Y.FINAL.MNEM<TOT.STAT> NE 'IL' AND Y.MNEM EQ '3YINACTIVE'
        LOCATE 'IL' IN Y.FINAL.MNEM<1> SETTING POS1 THEN
            DEL Y.FINAL.MNEM<POS1>
        END
        Y.FINAL.MNEM<-1> = 'IL'

    CASE Y.FINAL.MNEM<TOT.STAT> NE 'IM' AND Y.MNEM EQ 'ABANDONED'
        LOCATE 'IM' IN Y.FINAL.MNEM<1> SETTING POS1 THEN
            DEL Y.FINAL.MNEM<POS1>
        END
        Y.FINAL.MNEM<-1> = 'IM'

    END CASE

    RETURN

AC.STS2.MNEM:
*************
    TOT.STAT = DCOUNT(Y.FINAL.MNEM, @FM)          ;*R22 MANUAL CONVERSION
    BEGIN CASE
    CASE Y.FINAL.MNEM<TOT.STAT> NE 'PG' AND Y.MNEM2 EQ 'GUARANTEE.STATUS'
        LOCATE 'PG' IN Y.FINAL.MNEM<1> SETTING POS1 THEN
            DEL Y.FINAL.MNEM<POS1>
        END
        Y.FINAL.MNEM<-1> = 'PG'

    CASE Y.FINAL.MNEM<TOT.STAT> NE 'FA' AND Y.MNEM2 EQ 'DECEASED'
        LOCATE 'FA' IN Y.FINAL.MNEM<1> SETTING POS1 THEN
            DEL Y.FINAL.MNEM<POS1>
        END
        Y.FINAL.MNEM<-1> = 'FA'

    CASE Y.FINAL.MNEM<TOT.STAT> NE 'EM' AND Y.MNEM2 EQ 'GARNISHMENT'
        LOCATE 'EM' IN Y.FINAL.MNEM<1> SETTING POS1 THEN
            DEL Y.FINAL.MNEM<POS1>
        END
        Y.FINAL.MNEM<-1> = 'EM'

    CASE  Y.MNEM2 EQ 'GUARANTEE.REV'    ;*TSR637100 start
        LOCATE 'PG' IN Y.FINAL.MNEM<1> SETTING POS1 THEN
            DEL Y.FINAL.MNEM<POS1>
        END

    CASE  Y.MNEM2 EQ 'GARNISHMENT.REV'
        LOCATE 'EM' IN Y.FINAL.MNEM<1> SETTING POS1 THEN
            DEL Y.FINAL.MNEM<POS1>
        END         ;*TSR637100  end

    END CASE

    RETURN
END
