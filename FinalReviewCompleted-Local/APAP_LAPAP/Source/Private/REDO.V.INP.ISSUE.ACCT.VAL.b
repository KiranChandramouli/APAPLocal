$PACKAGE APAP.LAPAP
SUBROUTINE REDO.V.INP.ISSUE.ACCT.VAL
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is a Input validation routine attached in the Claims & Request versions
* to validate the account number.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description
* 2015/12/11    Ashokkumar.V.P
*DATE           WHO                 REFERENCE               DESCRIPTION
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED
*21-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.ISSUE.REQUESTS
    $INSERT I_F.REDO.FRONT.CLAIMS
    $INSERT I_F.REDO.ISSUE.CLAIMS ;*R22 AUTO CONVERSION END

    GOSUB INIT
    IF ACCT.ID THEN
        GOSUB PROCESS
    END
RETURN

INIT:
*****
    FN.ACCOUNT='F.ACCOUNT';    F.ACCOUNT=''; ACCT.ID = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.ACCOUNT.H='F.ACCOUNT$HIS';    F.ACCOUNT.H=''
    CALL OPF(FN.ACCOUNT.H,F.ACCOUNT.H)
    IF APPLICATION EQ 'REDO.ISSUE.REQUESTS' THEN
        ACCT.ID = R.NEW(ISS.REQ.ACCOUNT.ID)
    END
    IF APPLICATION EQ 'REDO.FRONT.CLAIMS' THEN
        ACCT.ID = R.NEW(FR.CL.ACCOUNT.ID)
    END
    IF APPLICATION EQ 'REDO.ISSUE.CLAIMS' THEN
        ACCT.ID = R.NEW(ISS.CL.ACCOUNT.ID)
    END
RETURN

PROCESS:
********
    ERR.ACCOUNT = ''; R.ACCOUNT = ''; ERRH.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    IF NOT(R.ACCOUNT) THEN
        ACT.HIST.ID = ACCT.ID
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.H,ACT.HIST.ID,R.ACCOUNT,ERRH.ACCOUNT)
    END
* Account number will be selected from drop down and not mandatory.
    IF ACCT.ID AND NOT(R.ACCOUNT) THEN
        ETEXT = 'EB-REDO.ACCT.MISS'
        CALL STORE.END.ERROR
        RETURN
    END
RETURN
END
