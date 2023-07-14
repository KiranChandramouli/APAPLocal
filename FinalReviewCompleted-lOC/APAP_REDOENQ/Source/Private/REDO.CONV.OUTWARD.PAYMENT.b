$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.OUTWARD.PAYMENT
*--------------------------------------------------
*Description: This is the conversation routine to display the account
* in the enquiry REDO.RETURN.OUT.CHQ.
*--------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ALTERNATE.ACCOUNT
    $INSERT I_F.REDO.CLEARING.OUTWARD
    $INSERT I_F.REDO.OUTWARD.RETURN

    IF O.DATA THEN
        RETURN
    END
    GOSUB PROCESS
RETURN
*--------------------------------------------------
PROCESS:
*--------------------------------------------------

    FN.REDO.OUTWARD.RETURN = 'F.REDO.OUTWARD.RETURN'
    F.REDO.OUTWARD.RETURN  = ''
    CALL OPF(FN.REDO.OUTWARD.RETURN,F.REDO.OUTWARD.RETURN)

    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'

    F.ALTERNATE.ACCOUNT  = ''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

    IF R.RECORD<CLEAR.OUT.TFS.REFERENCE> EQ 'PAYMENT' THEN
        CALL F.READ(FN.REDO.OUTWARD.RETURN,ID,R.ROR,F.REDO.OUTWARD.RETURN,ROR.ERR)
        Y.ACCOUNT.NO = FMT(R.ROR<CLEAR.RETURN.ACCOUNT>,'11"0"R')
        CALL F.READ(FN.ALTERNATE.ACCOUNT,Y.ACCOUNT.NO,R.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT,ALT.ERR)
        IF R.ALTERNATE.ACCOUNT THEN
            Y.ACCOUNT.NO = R.ALTERNATE.ACCOUNT<AAC.GLOBUS.ACCT.NUMBER>
        END
        O.DATA = Y.ACCOUNT.NO
    END

RETURN
END
