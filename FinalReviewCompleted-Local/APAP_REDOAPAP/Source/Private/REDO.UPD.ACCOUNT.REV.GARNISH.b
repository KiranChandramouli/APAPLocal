* @ValidationCode : Mjo2ODU3NTQ3NDY6Q3AxMjUyOjE2ODUwMTUyMzI3NjQ6dmljdG86LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 May 2023 17:17:12
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
SUBROUTINE REDO.UPD.ACCOUNT.REV.GARNISH
*-------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.UPD.ACCOUNT.REV.GARNISH
*DESCRIPTION:This is to reverse the EM status in the local table.
*DATE          NAME                REFERENCE               DESCRIPTION
*24 NOV  2022  Edwin Charles D     ACCOUNTING-CR           Changes applied for Accounting reclassification CR
*25-05-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM, FM TO @FM,++ TO +=1
*25-05-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
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
*
*--------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.T.STATSEQ.BY.ACCT
    $INSERT I_F.AC.LOCKED.EVENTS
*-------------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

RETURN
*--------------------------------------------------------------------------------
INIT:
*****

    FN.REDO.T.STATSEQ.BY.ACCT = 'F.REDO.T.STATSEQ.BY.ACCT'
    F.REDO.T.STATSEQ.BY.ACCT = ''
    CALL OPF(FN.REDO.T.STATSEQ.BY.ACCT,F.REDO.T.STATSEQ.BY.ACCT)

    APPL = 'ACCOUNT'
    F.FIELDS = 'L.AC.STATUS1':@VM:'L.AC.STATUS2' ;*R22 AUTO CONVERSION
    CALL MULTI.GET.LOC.REF(APPL,F.FIELDS,LOC.POS)
    Y.ST.PS1 = LOC.POS<1,1>
    Y.ST.PS2 = LOC.POS<1,2>
RETURN

PROCESS:
*--------------------------------------------------------------------------------
    ACCOUNT.ID = R.NEW(AC.LCK.ACCOUNT.NUMBER)
    CALL F.READ(FN.REDO.T.STATSEQ.BY.ACCT,ACCOUNT.ID,R.REDO.T.STATSEQ.BY.ACCT,F.REDO.T.STATSEQ.BY.ACCT,ACCT.ERR)
    R.OLD.COMB.STATUS =  R.REDO.T.STATSEQ.BY.ACCT<REDT.L.AC.STATUS.HAPPEN>
    CNT.OLD = DCOUNT(R.OLD.COMB.STATUS,@VM) ;*R22 AUTO CONVERSION
    R.OLD.COMB.STATUS.FINAL = R.REDO.T.STATSEQ.BY.ACCT<REDT.L.AC.STATUS.HAPPEN,CNT.OLD>
    CHANGE '-' TO @FM IN R.OLD.COMB.STATUS.FINAL ;*R22 AUTO CONVERSION
    TOT.CNT = DCOUNT(R.OLD.COMB.STATUS.FINAL, @FM) ;*R22 AUTO CONVERSION
    R.NEW.COMB.STATUS.FINAL = ''
    CNT = 1
    LOOP
    WHILE CNT LE TOT.CNT
        IF R.OLD.COMB.STATUS.FINAL<CNT> NE 'EM' THEN
            IF NOT(R.NEW.COMB.STATUS.FINAL) THEN
                R.NEW.COMB.STATUS.FINAL = R.OLD.COMB.STATUS.FINAL<CNT>
            END ELSE
                R.NEW.COMB.STATUS.FINAL<-1> = R.OLD.COMB.STATUS.FINAL<CNT>
            END
        END
        CNT += 1 ;*R22 AUTO CONVERSION
    REPEAT
    CHANGE @FM TO '-' IN R.NEW.COMB.STATUS.FINAL ;*R22 AUTO CONVERSION
    R.REDO.T.STATSEQ.BY.ACCT<REDT.L.AC.STATUS.HAPPEN,CNT.OLD> = R.NEW.COMB.STATUS.FINAL
    WRITE R.REDO.T.STATSEQ.BY.ACCT ON F.REDO.T.STATSEQ.BY.ACCT,ACCOUNT.ID
RETURN
END
