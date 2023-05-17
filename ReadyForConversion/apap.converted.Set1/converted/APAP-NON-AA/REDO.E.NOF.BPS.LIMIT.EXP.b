SUBROUTINE REDO.E.NOF.BPS.LIMIT.EXP(Y.OUT.ARRAY)
*-----------------------------------------------------------------------------
*COMPANY NAME: Group Financiero Banorte
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: NOFILE routine
*------------
*DESCRIPTION:
*------------
*  This routine is attached as NOFILE routine for the ENQUIRY REDO.USER.BPS.LIMIT.EXP
* The routine makes the select over the records of REDO.APAP.USER.LIMITS based on user selection
* process the same
*---------------------------------------------------------------------------
* Input / Output
*----------------
*
* Input / Output
* IN     : -na-
* OUT    : Y.OUT.ARRAY
*
*---------------------------------------------------------------------------
* Revision History
* Date           Who                Reference              Description
* 08-NOV-2010   A.SabariKumar     ODR-2010-07-0075       Initial Creation
*---------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.APAP.USER.LIMITS

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

*---------------------------------------------------------------------------
INITIALISE:
*------------
*Initialise/Open necessary varibles/files

    Y.EXP.DAYS = ''
    EXP.POS = ''
    Y.TODAY = ''
    SEL.CMD = ''
    SEL.LIST = ''
    USR.POS = ''
    SEL.ERR = ''
    Y.USR.ID = ''
    R.USR.LIM = ''
    USR.ERR = ''
    Y.DIFF = 'C'

    FN.REDO.APAP.USER.LIMITS = 'F.REDO.APAP.USER.LIMITS'
    F.REDO.APAP.USER.LIMITS =  ''
    CALL OPF(FN.REDO.APAP.USER.LIMITS,F.REDO.APAP.USER.LIMITS)

RETURN

*---------------------------------------------------------------------------
PROCESS:
*-----------
* The section forms the outgoing array based on the user selection equaling the
* fetched field accordingly

    Y.TODAY = TODAY
    LOCATE "EXPIRY.DAYS" IN D.FIELDS<1> SETTING EXP.POS THEN
        Y.EXP.DAYS =  D.RANGE.AND.VALUE<EXP.POS>
        SEL.CMD = 'SELECT ':FN.REDO.APAP.USER.LIMITS
    END
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    Y.USR.ID = ''
    LOOP
        REMOVE Y.USR.ID FROM SEL.LIST SETTING USR.POS
    WHILE Y.USR.ID:USR.POS
        Y.BPS.TXN.DATE = ''
        GOSUB FETCH.VALID.DATE
        Y.DIFF = 'C'
        IF Y.TODAY NE '' AND Y.BPS.TXN.DATE NE '' THEN
            CALL CDD('',Y.TODAY,Y.BPS.TXN.DATE,Y.DIFF)
            Y.DIFF = ABS(Y.DIFF)
        END
        IF Y.EXP.DAYS EQ Y.DIFF THEN
            GOSUB FORM.ARRAY
        END
    REPEAT
RETURN

*---------------------------------------------------------------------------
FETCH.VALID.DATE:
*----------------
* Reads the local template "REDO.APAP.USER.LIMITS" and fetchs the required values
* (i.e.)BPS.LIM.VALID.DATE

    CALL F.READ(FN.REDO.APAP.USER.LIMITS,Y.USR.ID,R.USR.LIM,F.REDO.APAP.USER.LIMITS,USR.ERR)
    Y.BPS.TXN.DATE = R.USR.LIM<REDO.USR.LIM.BPS.LIM.VALID.DATE>
RETURN

*---------------------------------------------------------------------------
FORM.ARRAY:
*-----------
* The section forms the oputgoing array for the enquiry output

    Y.OUT.ARRAY<-1> = Y.USR.ID:"*":Y.BPS.TXN.DATE

RETURN
*---------------------------------------------------------------------------
END
