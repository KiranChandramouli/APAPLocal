SUBROUTINE REDO.E.CNV.NCF
************************************************************
************************************************************
* Description : This subroutine is attached as a conversion routine in the
*enquiry REDO.ACCOUNT.STATEMENT
*-------------------------------------------------------------------------
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
* 25-MAR-2010        Prabhu.N       ODR-2009-10-0321     Initial Creation
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.REDO.NCF.ISSUED
    $INSERT I_ENQUIRY.COMMON


    GOSUB INITIALISE
    GOSUB OPENING
    GOSUB READ.AND.ASSIGN
RETURN

*----------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------


    Y.TRANS.REF = ''

RETURN

*-----------------------------------------------------------------
OPENING:
*-----------------------------------------------------------------

    FN.REDO.NCF.ISSUED= 'F.REDO.NCF.ISSUED'
    F.REDO.NCF.ISSUED=''
    CALL OPF(FN.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED)

RETURN

*-----------------------------------------------------------------
READ.AND.ASSIGN:
*-----------------------------------------------------------------
* Value of O.DATA is assigned to Customer ID to read the particular custom
*-----------------------------------------------------------------


    IF  O.DATA EQ '' THEN

        Y.TRANS.REF=R.RECORD<AC.STE.TRANS.REFERENCE>
        VAR.SEL.NCF.ISSUED="SELECT ":FN.REDO.NCF.ISSUED:" WITH TXN.ID EQ ":Y.TRANS.REF:" AND BATCH NE YES"
        CALL EB.READLIST(VAR.SEL.NCF.ISSUED,VAR.NCF.ID,'',NO.OF.REC,ERR)
        CALL F.READ(FN.REDO.NCF.ISSUED,VAR.NCF.ID,R.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED,ERR)
        IF R.REDO.NCF.ISSUED<ST.IS.MODIFIED.NCF> NE '' THEN
            Y.FINAL=R.REDO.NCF.ISSUED<ST.IS.NCF>:@VM:R.REDO.NCF.ISSUED<ST.IS.MODIFIED.NCF>
        END
        ELSE
            Y.FINAL=R.REDO.NCF.ISSUED<ST.IS.NCF>
        END
        VM.COUNT=DCOUNT(Y.FINAL,@VM)
        O.DATA = Y.FINAL<1,VC>
        RETURN
    END
