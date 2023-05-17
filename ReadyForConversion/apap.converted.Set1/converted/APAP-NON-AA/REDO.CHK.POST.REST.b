SUBROUTINE REDO.CHK.POST.REST

*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CHK.POST.REST
*--------------------------------------------------------------------------------------------------------
*Description  : This validation is to check the posting restriction on the account or not.this is a calling routine from
*               REDO.INITI.CARD.VAL
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------          ------               -------------            -------------
* 1 FEB  2011     Balagurunathan         PACS00137917             * PACS00137917 FIX
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.POSTING.RESTRICT

    $INSERT I_POST.COMMON

    IF V$FUNCTION NE 'I' THEN
        RETURN

    END
    GOSUB INITIALISE
    GOSUB PROCES





RETURN


INITIALISE:
    BLK.MARK.ACCT=''
    FN.POSTING.RESTRICT='F.POSTING.RESTRICT'
    F.POSTING.RESTRICT=''
    CALL OPF(FN.POSTING.RESTRICT,F.POSTING.RESTRICT)

RETURN


PROCES:

    CALL CACHE.READ(FN.POSTING.RESTRICT, Y.POST.ID, R.POSTING.RESTRICT, REST.ERR)

    IF R.POSTING.RESTRICT<AC.POS.RESTRICTION.TYPE> EQ 'DEBIT' OR R.POSTING.RESTRICT<AC.POS.RESTRICTION.TYPE> EQ 'ALL' THEN

        BLK.MARK.ACCT = 'TRUE'
    END ELSE
        BLK.MARK.ACCT = 'FALSE'

    END

    IF (APPLICATION EQ 'FUNDS.TRANSFER' OR APPLICATION EQ 'AC.LOCKED.EVENTS') AND BLK.MARK.ACCT EQ 'TRUE' THEN

        ETEXT="EB-POSTING.RESTRICT"
        CALL STORE.END.ERROR
    END

RETURN




END
