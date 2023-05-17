SUBROUTINE REDO.V.AUT.CLAIMS.CLOSE.LETTER
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : A Authorisation to generate the PDF for CLOSE letter and this routine
* is attached to REDO.ISSUE.CLAIMS,NEW VERSION
*
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : B RENUGADEVI
* PROGRAM NAME : REDO.V.AUT.CLAIMS.CLOSE.LETTER
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 16.AUG.2010       BRENUGADEVI        ODR-2009-12-0283  INITIAL CREATION
* 30.MAY.2011       PRADEEP S          PACS00071941      PDF Generated during notification
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.CLAIMS

    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****

    FN.REDO.ISSUE.CLAIMS = 'F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS  = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)
RETURN

********
PROCESS:
********
    Y.ID       = ID.NEW
    Y.STATUS   = R.NEW(ISS.CL.CLOSE.NOTIFICATION)
    TASK.NAME  = "ENQ REDO.ENQ.CLAIM.STATUS.CLOSE @ID EQ ":Y.ID

*PACS00071941 - S
*IF Y.STATUS EQ 'YES' THEN
    CALL EB.SET.NEW.TASK(TASK.NAME)
*END
*PACS00071941 - E
RETURN
END
