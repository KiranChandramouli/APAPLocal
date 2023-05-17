SUBROUTINE REDO.AA.ACCOUNT.CLOSE.PHANTOM
*--------------------------------------------------------------
*Description: This routine is to remove the arrangement id field for AA Account.
*             And it is attached to EB.PHANTOM>REDO.AA.ACCOUNT.CLOSE
*             PACS00470074
*--------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.PHANTOM

    GOSUB OPEN.FILES
    GOSUB PROCESS


    TEXT    = ERR.MSG:" - &"
    TEXT<2> = Y.AA.ACC.ID
    CALL OVE


RETURN
*--------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------
    ERR.MSG = ""

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------


    Y.AA.ACC.ID = R.NEW(TD.DESCRIPTION)<1,1>
    CALL F.READ(FN.ACCOUNT,Y.AA.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT EQ "" THEN
        ERR.MSG = "ERROR - ACCOUNT RECORD NOT EXIST"
        RETURN
    END
    IF R.ACCOUNT<AC.ARRANGEMENT.ID> THEN
        R.ACCOUNT<AC.ARRANGEMENT.ID> = ""
        TEMP.V = V
        V = AC.AUDIT.DATE.TIME
        CALL F.LIVE.WRITE(FN.ACCOUNT,Y.AA.ACC.ID,R.ACCOUNT)
        V = TEMP.V
        CALL JOURNAL.UPDATE("")
        ERR.MSG = "Updated Successfully"
    END ELSE
        ERR.MSG = "ERROR - ARRANGEMENT ID ALREADY REMOVED"
    END

RETURN
END
