SUBROUTINE REDO.V.VAL.INPUTTED.AMTI
*---------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.VAL.INPUTTED.AMT
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*
*  DESCRIPTION: VALIDATION routine attached to CHEQUE.NO field.
*                               Validates if it is an ADMIN CHEQUE
*                               Validates if status is correct
*
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE           WHO               REFERENCE         DESCRIPTION
*
* 19.02.2010    H GANESH           ODR-2009-12-0285  INITIAL CREATION
* 19-JUL-2011   J.COSTA C.         PACS              Issues as VERSION NAME was hardcoded
* 01-AUG-2013   Vignesh Kumaar R   PACS00303915      ADMIN CHEQUE ISSUE NUMBER
*----------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
*
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS

    GOSUB INIT
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*
    R.NEW(TT.TE.AMOUNT.LOCAL.1)  = Y.AMOUNT
    R.NEW(WPOS.LR)<1,Y.TT.BENEF> = Y.BENEFICIARY
*
    CALL REDO.HANDLE.COMM.TAX.FIELDS
*
RETURN
*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
    IF Y.ERR.MSG THEN
        ETEXT           = Y.ERR.MSG
        CALL STORE.END.ERROR
        ETEXT           = ""
    END
*
RETURN
*
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
*
    PROCESS.GOAHEAD = 1
    Y.ERR.MSG       = ""
*
    FN.REDO.ADMIN.CHQ.DETAILS = 'F.REDO.ADMIN.CHQ.DETAILS'
    F.REDO.ADMIN.CHQ.DETAILS  = ''
*
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
*
    Y.CHEQUE.NO     = COMI
*
    WCAMPO     = "L.TT.BENEFICIAR"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
*
    CALL MULTI.GET.LOC.REF("TELLER",WCAMPO,YPOS)
    Y.TT.BENEF     = YPOS<1,1>
*
    WPOS.LR    = TT.TE.LOCAL.REF
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NO,R.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,ADMIN.CHQ.ERR)
                IF ADMIN.CHQ.ERR THEN
                    Y.ERR.MSG       = 'EB-ADMIN.CHEQUE.&.DOES.NOT.EXIST':@FM:Y.CHEQUE.NO
                    PROCESS.GOAHEAD = ""
                END
            CASE LOOP.CNT EQ 2

* Fix for PACS00303915 [ADMIN CHEQUE ISSUE NUMBER]

                Y.INT.ACCOUNT = R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.CHEQUE.INT.ACCT>
                Y.INT.ACCOUNT<-1> = R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.ISSUE.ACCOUNT>

*            IF R.NEW(TT.TE.DR.CR.MARKER) EQ "DEBIT" THEN
*                Y.TT.ACCOUNT = R.NEW(TT.TE.ACCOUNT.2)
*            END ELSE
                Y.TT.ACCOUNT = R.NEW(TT.TE.ACCOUNT.1)
*            END

*            IF Y.INT.ACCOUNT NE Y.TT.ACCOUNT THEN
                LOCATE Y.TT.ACCOUNT IN Y.INT.ACCOUNT SETTING Y.POS ELSE
                    Y.ERR.MSG       = 'EB-CHEQUE.FROM.OTHER.ACCOUNT.&':@FM:Y.CHEQUE.NO
                    PROCESS.GOAHEAD = ""
                END
* End of Fix

            CASE LOOP.CNT EQ 3
                Y.AMOUNT      = R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.AMOUNT>
                Y.BENEFICIARY = R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.BENEFICIARY,1>
                Y.STATUS      = R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS>
*
                IF (Y.STATUS NE 'ISSUED' AND V$FUNCTION EQ "I") OR (V$FUNCTION EQ "R" AND Y.STATUS NE "PAID") THEN
                    Y.ERR.MSG = 'EB-CHEQUE.STATUS.IS.&':@FM:Y.STATUS
                    PROCESS.GOAHEAD = ""
                END

        END CASE
*       Message Error
        GOSUB CONTROL.MSG.ERROR
*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
RETURN

END
