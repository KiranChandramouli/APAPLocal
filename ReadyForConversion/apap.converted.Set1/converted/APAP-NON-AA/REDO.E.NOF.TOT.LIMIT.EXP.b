SUBROUTINE REDO.E.NOF.TOT.LIMIT.EXP(Y.OUT.ARRAY)
*-----------------------------------------------------------------------------
*COMPANY NAME: Group Financiero Banorte
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: NOFILE routine
*------------
*DESCRIPTION:
*------------
*  This routine is attached as NOFILE routine for the ENQUIRY REDO.USER.TOT.LIMIT.EXP
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
    ENQ.ID = ''
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

    Y.ENQ.SELECTION = FIELD(ENQ.SELECTION,@FM,1,1)
    ENQ.ID = Y.ENQ.SELECTION
    Y.TODAY = TODAY
    LOCATE "EXPIRY.DAYS" IN D.FIELDS<1> SETTING EXP.POS THEN
        Y.EXP.DAYS =  D.RANGE.AND.VALUE<EXP.POS>
        SEL.CMD = 'SELECT ':FN.REDO.APAP.USER.LIMITS
    END
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    LOOP
        REMOVE Y.USR.ID FROM SEL.LIST SETTING USR.POS
    WHILE Y.USR.ID:USR.POS
        GOSUB FETCH.VALID.DATE

        Y.DIFF = 'C'
        IF Y.TODAY NE '' AND Y.TOT.TXN.DATE NE '' THEN
            CALL CDD('',Y.TODAY,Y.TOT.TXN.DATE,Y.DIFF)
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
* (i.e.)TOT.TXN.LIM.DATE

    R.USR.LIM = ''
    Y.LIST.APPLICATION = ''
    Y.TOT.TXN.DATE = ''

    CALL F.READ(FN.REDO.APAP.USER.LIMITS,Y.USR.ID,R.USR.LIM,F.REDO.APAP.USER.LIMITS,USR.ERR)
    Y.LIST.APPLICATION = R.USR.LIM<REDO.USR.LIM.APPLICATION>
    CHANGE @VM TO @FM IN Y.LIST.APPLICATION
    IF ENQ.ID EQ 'REDO.FX.TOT.LIMIT.EXP' THEN
        LOCATE 'FX' IN Y.LIST.APPLICATION SETTING Y.FX.POS THEN
            Y.TOT.TXN.DATE = R.USR.LIM<REDO.USR.LIM.TOT.TXN.LIM.DATE,Y.FX.POS>
        END
    END
    IF ENQ.ID EQ 'REDO.MM.TOT.LIMIT.EXP' THEN
        LOCATE 'MM' IN Y.LIST.APPLICATION SETTING Y.MM.POS THEN
            Y.TOT.TXN.DATE = R.USR.LIM<REDO.USR.LIM.TOT.TXN.LIM.DATE,Y.MM.POS>
        END
    END
    IF ENQ.ID EQ 'REDO.SC.TOT.LIMIT.EXP' THEN
        LOCATE 'SC' IN Y.LIST.APPLICATION SETTING Y.SC.POS THEN
            Y.TOT.TXN.DATE = R.USR.LIM<REDO.USR.LIM.TOT.TXN.LIM.DATE,Y.SC.POS>
        END
    END
RETURN

*---------------------------------------------------------------------------
FORM.ARRAY:
*-----------
* The section forms the oputgoing array for the enquiry output

    Y.OUT.ARRAY<-1> = Y.USR.ID:"*":Y.TOT.TXN.DATE

RETURN
*---------------------------------------------------------------------------
END
