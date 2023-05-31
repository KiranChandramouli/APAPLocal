$PACKAGE APAP.REDOENQ
SUBROUTINE E.NOFILE.BAT.ALL.CHQS(Y.FINAL.ARRAY)
*------------------------------------------------------------------------------------------
*DESCRIPTION : This is a no file enquiry routine for the enquiry REDO.ALL.CHQS
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : Y.FINAL.ARRAY
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RAJKUMAR AC
* PROGRAM NAME : E.NOFILE.BAT.ALL.CHQS
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 27.07.2010      AC.RAJKUMAR      ODR-2010-02-0001   INITIAL CREATION              
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.BAT.CHQ.DETAILS
*
    FN.REDO.H.BAT.CHQ.DETAILS = 'F.REDO.H.BAT.CHQ.DETAILS'
    F.REDO.H.BAT.CHQ.DETAILS  = ''
    CALL OPF(FN.REDO.H.BAT.CHQ.DETAILS, F.REDO.H.BAT.CHQ.DETAILS)
*
    Y.FINAL.ARRAY = ''
    Y.CHEQUE = ''
    Y.AMOUNT = ''
    Y.DATE = TODAY
*
    SEL.CMD1 = "SELECT ":FN.REDO.H.BAT.CHQ.DETAILS:" WITH BATCH.GEN.DATE EQ ":Y.DATE:" BY TELLER.ID"
    Y.TELLER.ID = ''
    Y.LAST.TELLER.ID = ''
    Y.FLAG = 1
    CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',NOR1,SEL.ERR1)
    LOOP
        REMOVE Y.BATCH.ID FROM SEL.LIST1 SETTING POS1
    WHILE Y.BATCH.ID:POS1
        CALL F.READ(FN.REDO.H.BAT.CHQ.DETAILS, Y.BATCH.ID, R.REC.REDO.H.BAT.CHQ.DETAILS, F.REDO.H.BAT.CHQ.DETAILS, Y.ERR)
        Y.TELLER.ID      = R.REC.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.TELLER.ID>
        Y.BRANCH.ID      = R.REC.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.BRANCH.ID>
        Y.TELLER.NAME    = R.REC.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.TELLER.NAME>
        Y.BATCH.GEN.DATE = R.REC.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.BATCH.GEN.DATE>
        IF Y.LAST.TELLER.ID NE Y.TELLER.ID THEN
            IF Y.LAST.TELLER.ID NE '' THEN
                GOSUB FORM.ARRAY
            END
            Y.CHEQUE = ''
            Y.AMOUNT = ''
            Y.TEMP.ARRAY = Y.BRANCH.ID:'*':Y.TELLER.ID:'*':Y.TELLER.NAME:'*':Y.BATCH.GEN.DATE
            Y.CHEQUE  = R.REC.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.TOTAL.CHEQUES>
            Y.AMOUNT = R.REC.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.TOTAL.CHQ.AMT>
            Y.TOTAL.BATCH = Y.FLAG
        END ELSE
            Y.TOTAL.BATCH += 1
            Y.CHEQUE        + = R.REC.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.TOTAL.CHEQUES>
            Y.AMOUNT        + = R.REC.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.TOTAL.CHQ.AMT>
        END
        Y.LAST.TELLER.ID = Y.TELLER.ID
    REPEAT
    IF Y.LAST.TELLER.ID NE '' THEN
        GOSUB FORM.ARRAY
    END
RETURN
*
FORM.ARRAY:
    Y.FINAL.ARRAY<-1> = Y.TEMP.ARRAY:'*':Y.TOTAL.BATCH:'*':Y.CHEQUE:'*':Y.AMOUNT
RETURN
END
*
