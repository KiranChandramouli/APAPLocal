$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.INPUTTED.AMTO
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
* DATE           WHO           REFERENCE         DESCRIPTION
*
* 19.02.2010    H GANESH     ODR-2009-12-0285  INITIAL CREATION
* 19-JUL-2011   J.COSTA C.       PACS              Issues as VERSION NAME was hardcoded
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM,VM TO @VM
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE ADDED
*----------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
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
    Y.AMOUNT      = R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.AMOUNT>
    Y.BENEFICIARY = R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.BENEFICIARY,1>
    Y.STATUS      = R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS>
*
    BEGIN CASE
        CASE Y.STATUS NE 'RECLASSIFY'
            Y.ERR.MSG = 'EB-CHEQUE.STATUS.IS.&':@FM:Y.STATUS ;*R22 AUTO CONVERSION
*
        CASE 1
            R.NEW(TT.TE.AMOUNT.LOCAL.1)   = Y.AMOUNT
            R.NEW(WPOS.LR)<1,Y.TT.BENEF>  = Y.BENEFICIARY
*CALL REDO.HANDLE.COMM.TAX.FIELDS
*R22 MANUAL CONVERSION
            CALL APAP.TAM.REDO.HANDLE.COMM.TAX.FIELDS
    END CASE
*
    GOSUB CONTROL.MSG.ERROR
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
*    Y.CHEQUE.NO     = R.NEW(TT.TE.CHEQUE.NUMBER)
    Y.CHEQUE.NO  = COMI

    WCAMPO    = "L.TT.BENEFICIAR"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM) ;*R22 AUTO CONVERSION
    CALL MULTI.GET.LOC.REF("TELLER",WCAMPO,YPOS)
    Y.TT.BENEF     = YPOS<1,1>
    WPOS.LR    = TT.TE.LOCAL.REF
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
    LOOP.CNT  = 1   ;   MAX.LOOPS = 1
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NO,R.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,ADMIN.CHQ.ERR)
                IF ADMIN.CHQ.ERR THEN
                    Y.ERR.MSG = 'EB-ADMIN.CHEQUE.&.DOES.NOT.EXIST':@FM:Y.CHEQUE.NO ;*R22 AUTO CONVERSION
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
