SUBROUTINE REDO.APAP.GET.ALT.ACCT
*-----------------------------------------------------------------------------
*DESCRIPTIONS:
*-------------
* It is Conversion Routine can be used when a multivalue field
* used to display in enquiry
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                 Reference
* 24-MAY-13      RIYAS              INITIALVERSION
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*---------------------------------------------------------------------------
*

    CALL F.READ(FN.ACCOUNT,O.DATA,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

    Y.ALT.ACCT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
    Y.ALT.ACCT.ID = R.ACCOUNT<AC.ALT.ACCT.ID>
    CHANGE @VM TO @FM IN Y.ALT.ACCT.TYPE
    CHANGE @VM TO @FM IN Y.ALT.ACCT.ID
    LOCATE 'ALTERNO1' IN Y.ALT.ACCT.TYPE SETTING ALT.POS THEN
        O.DATA = Y.ALT.ACCT.ID<ALT.POS>
    END ELSE
        O.DATA = ''
    END
RETURN
END
