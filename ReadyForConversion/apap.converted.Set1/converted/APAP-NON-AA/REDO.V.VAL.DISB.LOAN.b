SUBROUTINE REDO.V.VAL.DISB.LOAN
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*  This routine is Validation routine attached to update INTERNAL account numbers
*
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*-----------------------------------------------------------------------------
*   Date               who           Reference            Description
* 04-28-2011          Bharath G         N.45              INITIAL CREATION
*-----------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.AA.DISB.LOAN
    $INSERT I_F.REDO.BRANCH.INT.ACCT.PARAM

    IF V$FUNCTION EQ 'I' THEN
        GOSUB INIT
        GOSUB PROCESS
    END

RETURN
*-----------------------------------------------------------------------------
******
INIT:
******
    FN.REDO.BRANCH.INT.ACCT.PARAM = 'F.REDO.BRANCH.INT.ACCT.PARAM'
    F.REDO.BRANCH.INT.ACCT.PARAM = ''
    R.REDO.BRANCH.INT.ACCT.PARAM = ''
    CALL OPF(FN.REDO.BRANCH.INT.ACCT.PARAM,F.REDO.BRANCH.INT.ACCT.PARAM)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    R.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    Y.DISB.AMT = ''

RETURN
*-----------------------------------------------------------------------------
********
PROCESS:
********
*
    Y.CMPNY = R.NEW(DISB.LN.BRANCH.ID)
    Y.AA.ID = R.NEW(DISB.LN.ARRANGEMENT.ID)

    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)
    IF R.AA.ARRANGEMENT THEN
        Y.CURRENCY = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
        Y.CO.CODE  = R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
        Y.STATUS   = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
    END

    LOOP
        REMOVE Y.CMPNY.ID FROM Y.CMPNY SETTING CMPNY.POS
    WHILE Y.CMPNY.ID:CMPNY.POS
        CALL F.READ(FN.REDO.BRANCH.INT.ACCT.PARAM,Y.CMPNY.ID,R.REDO.BRANCH.INT.ACCT.PARAM,F.REDO.BRANCH.INT.ACCT.PARAM,INT.ERR)
        IF R.REDO.BRANCH.INT.ACCT.PARAM THEN
            Y.ACCT.CURR = R.REDO.BRANCH.INT.ACCT.PARAM<BR.INT.ACCT.CURRENCY>
            Y.INT.ACCT  = R.REDO.BRANCH.INT.ACCT.PARAM<BR.INT.ACCT.BRANCH.INT.ACCT>
            LOCATE Y.CURRENCY IN Y.ACCT.CURR<1,1> SETTING CURR.POS THEN
                Y.INTERNAL.ACCT = Y.INT.ACCT<1,CURR.POS>
                LOCATE Y.CMPNY.ID IN Y.CMPNY SETTING Y.CMPNY.POSITION THEN
                    R.NEW(DISB.LN.BRANCH.DISB.ACC)<1,Y.CMPNY.POSITION> = Y.INT.ACCT<1,CURR.POS>
                END
            END
        END
    REPEAT

RETURN
*-----------------------------------------------------------------------------
END
