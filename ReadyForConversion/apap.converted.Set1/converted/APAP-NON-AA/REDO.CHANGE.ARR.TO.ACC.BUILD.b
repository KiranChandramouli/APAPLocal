SUBROUTINE REDO.CHANGE.ARR.TO.ACC.BUILD(ENQ.DATA)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used as BUILD routine, to accept arrangement id and account no in selection criteria.
*-------------------------------------------------------------------------------
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
*   Date               who           Reference            Description
* 26-09-2011        S.MARIMUTHU     PACS00128531         Initial Creation
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT


MAIN:

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


    LOCATE '@ID' IN ENQ.DATA<2,1> SETTING POS THEN
        Y.ID = ENQ.DATA<4,1>
        IF Y.ID[1,2] NE 'AA' THEN
            CALL F.READ(FN.ACCOUNT,Y.ID,R.ACC,F.ACCOUNT,AA.ERR)
            Y.AC.ID = R.ACC<AC.ARRANGEMENT.ID>
            ENQ.DATA<4,POS> = Y.AC.ID
        END
    END

    GOSUB PGM.END

RETURN

PGM.END:

END
