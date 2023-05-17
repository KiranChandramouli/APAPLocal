SUBROUTINE REDO.DS.INT.PAY.TYPE(VAR.INT.PAY.TYPE)
*---------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to get the L.TYPE.INT.PAY value from the AZ.ACCOUNT
*---------------------------------------------------------------------------------------------
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
* Revision History:
*------------------
* Date who Reference Description
* 06-NOV-2011 Sudharsanan S cr.18 Initial creation
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT

    GOSUB INIT
    GOSUB FILEOPEN
    GOSUB PROCESS
RETURN
*----
INIT:
*----
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''

    LREF.APP = 'AZ.ACCOUNT'
    LREF.FIELD='L.TYPE.INT.PAY'
    LREF.POS = ''
RETURN
*--------
FILEOPEN:
*--------
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    CALL GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)

RETURN
*--------
PROCESS:
*--------
* This part checks the id and get the description accordingly

    Y.INT.TYPE = R.NEW(AZ.LOCAL.REF)<1,LREF.POS>
    Y.INT.LIQ.ACCT = R.NEW(AZ.INTEREST.LIQU.ACCT)
    IF Y.INT.TYPE THEN
        GOSUB CHECK.EB.VALUES
        GOSUB UPD.PAY.TYPE
    END
RETURN

*----------------
CHECK.EB.VALUES:
*----------------
    VIRTUAL.TAB.ID='L.TYPE.INT.PAY'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
    Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
    Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC
    LOCATE Y.INT.TYPE IN Y.LOOKUP.LIST SETTING POS1 THEN
        VAR.USER.LANG = R.USER<EB.USE.LANGUAGE>
        VAL.INT.TYPE = Y.LOOKUP.DESC<POS1,VAR.USER.LANG>
        IF NOT(VAL.INT.TYPE) THEN
            VAR.INT.TYPE = Y.LOOKUP.DESC<POS1,1>
        END ELSE
            VAR.INT.TYPE = VAL.INT.TYPE
        END
    END
RETURN
*----------------
UPD.PAY.TYPE:
*----------------
    IF Y.INT.TYPE EQ 'Credit.To.Account' THEN
        VAR.INT.PAY.TYPE = VAR.INT.TYPE:" ":Y.INT.LIQ.ACCT
    END ELSE
        VAR.INT.PAY.TYPE = VAR.INT.TYPE
    END
RETURN
*---------------------------------------------------------------------------
END
