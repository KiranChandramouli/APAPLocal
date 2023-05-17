SUBROUTINE REDO.V.VALIDATE.SETTLE.ACC

*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This is a validation routine to validate the settlement account and deposit account
* ACCOUNT.CLOSURE,REDO.EN.LINEA
*
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date        who               Reference       Description
*27-7-15        Maheswaran j    PACS00462895    Validate the  accounts
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CLOSURE

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*----
    Y.APPL = 'ACCOUNT.CLOSURE'
    Y.FIELDS = 'L.AC.AZ.ACC.REF'
    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPL, Y.FIELDS, Y.POS)
    Y.ACC.POSS = Y.POS<1,1>
RETURN

PROCESS:
*-------
    Y.SETLLE.AC = COMI
    Y.ACC = R.NEW(AC.ACL.LOCAL.REF)<1,Y.ACC.POSS>
    IF Y.SETLLE.AC EQ Y.ACC THEN
        AF =  AC.ACL.SETTLEMENT.ACCT
        ETEXT = 'EB-CHK.AC.SETTLE.ACC'
        CALL STORE.END.ERROR
    END
RETURN

END
