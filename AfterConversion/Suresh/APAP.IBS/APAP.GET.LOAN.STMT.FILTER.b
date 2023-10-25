$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>614</Rating>
*-----------------------------------------------------------------------------
*    SUBROUTINE AT.GET.ACCT.ENT.DETLS(Y.ACCT.NO,NO.OF.TXNS,TXN.DETLS)
SUBROUTINE APAP.GET.LOAN.STMT.FILTER(REQUEST)
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.INTERCO.PARAMETER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.REFERENCE.DETAILS
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.TRANSACTION


    GOSUB INITIALISE

    GOSUB PROCESS


RETURN
*-------------------------------------------------------------------------------
INITIALISE:
*
* get the branch mnemonic using the account no

    Y.ACCT.NO = REQUEST[',', 1, 1]
    DATE.FROM = REQUEST[',', 2, 1]
    DATE.TO = REQUEST[',', 3, 1]

    IF NOT(Y.ACCT.NO) THEN
        RETURN
    END

    IF NOT(DATE.FROM) THEN
        NO.OF.TXNS = 5
    END

    CALL GET.ACCT.BRANCH(Y.ACCT.NO,Y.ACCT.BR.MNE,Y.ACCT.COMP.CDE)

    FN.ACCOUNT = 'F':Y.ACCT.BR.MNE:'.ACCOUNT'
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)      ;*open after changing com
*
    FN.STMT.ENTRY = 'F':Y.ACCT.BR.MNE:'.STMT.ENTRY'
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)          ;*open after changing com
*
    FN.AA.REF.DETS = 'F.AA.REFERENCE.DETAILS'
    CALL OPF(FN.AA.REF.DETS, F.AA.REF.DETS)

    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY, F.AA.ARRANGEMENT.ACTIVITY)

RETURN          ;*initialise

*-------------------------------------------------------------------------------
PROCESS:
*

*    IF NO.OF.TXNS THEN
*        REQ.NO.OF.STMTS = NO.OF.TXNS
*    END

*  CALL F.READ(FN.ACCOUNT, Y.ACCT.NO, R.ACCOUNT, F.ACCOUNT, AC.ERR)
    READ R.ACCOUNT FROM F.ACCOUNT, Y.ACCT.NO ELSE AC.ERR = 'RECORD NOT FOUND'
    IF NOT(AC.ERR) THEN
        AA.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
        CALL F.READ(FN.AA.REF.DETS, AA.ID, R.AA.REF.DETS, F.AA.REF.DETS, AA.ERR)
        IF NOT(AA.ERR) THEN
            AAA.IDS = RAISE(R.AA.REF.DETS<AA.REF.AAA.ID>)
            TRANS.REFS = RAISE(R.AA.REF.DETS<AA.REF.TRANS.REF>)
            GOSUB GET.AAA.IDS
        END
    END

    REQUEST = STMT.IDS

RETURN

*---------------------------------------------------------------------------------------------*
GET.AAA.IDS:
*

    NO.AAA.IDS = DCOUNT(AAA.IDS, @FM)
    J = 1
    FOR I=NO.AAA.IDS TO 1 STEP -1
        AAA.ID = AAA.IDS<I>
        CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY, AAA.ID, R.AAA.REC, F.AA.ARRANGEMENT.ACTIVITY, AA.ERR)
        IF NOT(AA.ERR) THEN
            STMT.ENT.DATE = R.AAA.REC<AA.ARR.ACT.EFFECTIVE.DATE>
            BEGIN CASE
                CASE DATE.TO
                    IF STMT.ENT.DATE LE DATE.TO AND STMT.ENT.DATE GE DATE.FROM THEN
                        STMT.IDS<J> = AAA.ID
                    END
                    IF STMT.ENT.DATE LT DATE.FROM THEN
                        BREAK
                    END ELSE
                        IF STMT.ENT.DATE GT DATE.TO THEN CONTINUE
                    END
                CASE DATE.FROM
                    IF STMT.ENT.DATE GE DATE.FROM THEN
                        STMT.IDS<J> = AAA.ID
                    END ELSE
                        BREAK
                    END
                CASE NO.OF.TXNS
                    STMT.IDS<J> = AAA.ID
                    IF J GE NO.OF.TXNS THEN BREAK
            END CASE
            J++
        END
    NEXT I

RETURN          ;*From get.stmt.ids

*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
END
