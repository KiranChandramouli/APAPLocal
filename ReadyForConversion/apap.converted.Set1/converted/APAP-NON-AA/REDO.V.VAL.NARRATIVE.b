SUBROUTINE REDO.V.VAL.NARRATIVE
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This is Validation routine for the field CERTIFIED CHEQUE NO to update
* NARRATIVE, Amount and Account fields
*
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
* Linked : TELLER
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.VAL.NARRATIVE
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 16.03.2010      SUDHARSANAN S     ODR-2009-10-0319  INITIAL CREATION
* 25.07.2011      NELSON SALGADO    PACS00089771
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.TELLER
*
    $INSERT I_F.CERTIFIED.CHEQUE.DETAILS
    $INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
*


    GOSUB INIT
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
*
RETURN
*
*------------------------------------------------------------------------------
INIT:
*-------------------------------------------------------------------------------
*
    YFLAG.ONEYEAR   = ""
    PROCESS.GOAHEAD = 1
    Y.ERR.MSG       = ""
*
    FN.CERTIFIED.CHEQUE.DETAILS = 'F.CERTIFIED.CHEQUE.DETAILS'
    F.CERTIFIED.CHEQUE.DETAILS  = ''
*
    FN.CERTIFIED.CHEQUE.PARAMETER = 'F.CERTIFIED.CHEQUE.PARAMETER'
    F.CERTIFIED.CHEQUE.PARAMETER  = ''
*
    CALL OPF(FN.CERTIFIED.CHEQUE.DETAILS,F.CERTIFIED.CHEQUE.DETAILS)
    CALL OPF(FN.CERTIFIED.CHEQUE.PARAMETER,F.CERTIFIED.CHEQUE.PARAMETER)
*
    WCAMPO    = "L.TT.BENEFICIAR":@VM:"L.CREDIT.AMOUNT":@VM:"L.DEBIT.AMOUNT":@VM:'CERT.CHEQUE.NO'
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    CALL MULTI.GET.LOC.REF("TELLER",WCAMPO,YPOS)
    Y.TT.BENEF          = YPOS<1,1>
    DEBIT.POS           = YPOS<1,2>
    CREDIT.POS          = YPOS<1,3>
    POS.CERT.CHEQUE.NO  = YPOS<1,4>
*
    WPOS.LR          = TT.TE.LOCAL.REF
    Y.CERT.CHEQUE.NO = COMI
*
    R.NEW(TT.TE.AMOUNT.LOCAL.2)<1,1> = ""
    R.NEW(TT.TE.NET.AMOUNT)          = ""
*
    IF R.NEW(TT.TE.DR.CR.MARKER) EQ "DEBIT" THEN
        Y.ACCOUNT = R.NEW(TT.TE.ACCOUNT.1)
    END ELSE
        Y.ACCOUNT = R.NEW(TT.TE.ACCOUNT.2)
    END
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
    LOOP.CNT  = 1   ;   MAX.LOOPS = 4
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                CALL CACHE.READ(FN.CERTIFIED.CHEQUE.PARAMETER,ID.COMPANY,R.CERT.CHEQ.PARAM,PARAM.ERR)
                IF R.CERT.CHEQ.PARAM<CERT.CHEQ.YEAR.ACCOUNT> EQ Y.ACCOUNT THEN
                    YFLAG.ONEYEAR = 1
                END
                GOSUB GET.BACK.DATE

            CASE LOOP.CNT EQ 2
                R.CERT.CHEQ.DET = ""    ;* VNL - 2012APR26 - S/E
                CALL F.READ(FN.CERTIFIED.CHEQUE.DETAILS,Y.CERT.CHEQUE.NO,R.CERT.CHEQ.DET,F.CERTIFIED.CHEQUE.DETAILS,CERT.ERR)
                IF NOT(R.CERT.CHEQ.DET) THEN
                    Y.ERR.MSG       = 'EB-CHECK.CERT.NO'
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 3
                Y.STATUS = R.CERT.CHEQ.DET<CERT.DET.STATUS>

*** Below lines are commented after discussion with user, it should check against the account on CERTIFIED.CHEQUE.DETAILS(CCD). There is  another process
*** to change the ACCOUNT value(on CCD) to YEAR.ACCOUNT value. So verify the ACCOUNT value(Which belongs to cheque) rather DATE.
*
*           IF (YFLAG.ONEYEAR AND R.CERT.CHEQ.DET<CERT.DET.DATE> GT WDATE.ONEYEAR) OR (NOT(YFLAG.ONEYEAR) AND R.CERT.CHEQ.DET<CERT.DET.DATE> LE WDATE.ONEYEAR) THEN
*               Y.ERR.MSG = "EB-VERSION.NOT.INTENDED.FOR.CHECK.DATE.&":FM:R.CERT.CHEQ.DET<CERT.DET.DATE>
*               PROCESS.GOAHEAD = ""
*           END

*** Below lines are modified after testing done by the user. User wants a different message if cheque status is PAID.
*
                IF (Y.STATUS NE 'ISSUED' AND V$FUNCTION EQ "I") OR (Y.STATUS NE 'PAID' AND V$FUNCTION EQ "R") THEN
                    IF Y.STATUS EQ 'PAID' THEN
                        Y.ERR.MSG = "EB-CHEQUE.STATUS.IS.PAID"
                    END ELSE
                        Y.ERR.MSG = "EB-CHEQUE.STATUS.IS.&":@FM:R.CERT.CHEQ.DET<CERT.DET.STATUS>
                    END
                    PROCESS.GOAHEAD = ""
                END


            CASE LOOP.CNT EQ 4
                IF Y.ACCOUNT NE R.CERT.CHEQ.DET<CERT.DET.ACCOUNT> THEN
                    Y.ERR.MSG = "EB-VERSION.NOT.INTENDED.FOR.CHECK.ACC":@FM:R.CERT.CHEQ.DET<CERT.DET.ACCOUNT>
                    PROCESS.GOAHEAD = ""
                END
*

        END CASE
*       Message Error
        GOSUB CONTROL.MSG.ERROR
*       Increase
        LOOP.CNT += 1
*
    REPEAT
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
* ============
GET.BACK.DATE:
* ============
*
    WYY.VAL       = TODAY[1,4] - 1
    WDATE.ONEYEAR = WYY.VAL : TODAY[5,4]
*
RETURN
*
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*
    W.ACCOUNT     = ""
    Y.CHEQUE.TYPE = R.CERT.CHEQ.PARAM<CERT.CHEQ.TYPE>
    CHANGE @VM TO @FM IN Y.CHEQUE.TYPE
*
    R.NEW(WPOS.LR)<1,Y.TT.BENEF>      = R.CERT.CHEQ.DET<CERT.DET.BENEFICIARY,1>
    R.NEW(TT.TE.AMOUNT.LOCAL.1)       = R.CERT.CHEQ.DET<CERT.DET.AMOUNT>
*
    CALL REDO.HANDLE.COMM.TAX.FIELDS
*
    Y.CHEQUE.NO = Y.CERT.CHEQUE.NO[1,1]
*
    IF NOT(YFLAG.ONEYEAR) THEN
        LOCATE 'GOVT' IN Y.CHEQUE.TYPE SETTING POS1 THEN
            Y.SER.NO = R.CERT.CHEQ.PARAM<CERT.CHEQ.START.SERIAL.NO,POS1>
            IF Y.SER.NO EQ Y.CHEQUE.NO THEN
                W.ACCOUNT = R.CERT.CHEQ.PARAM<CERT.CHEQ.ACCOUNT.NO,POS1>
            END
        END
        LOCATE 'NON.GOVT' IN Y.CHEQUE.TYPE SETTING POS2 THEN
            Y.SER.NO = R.CERT.CHEQ.PARAM<CERT.CHEQ.START.SERIAL.NO,POS2>
            IF Y.SER.NO EQ Y.CHEQUE.NO THEN
                W.ACCOUNT = R.CERT.CHEQ.PARAM<CERT.CHEQ.ACCOUNT.NO,POS2>
            END
        END
    END
*
*    CALL TT.PERFORM.DEF.PROCESSING
*
    IF R.NEW(TT.TE.DR.CR.MARKER) EQ "CREDIT" THEN
        R.NEW(TT.TE.LOCAL.REF)<1,CREDIT.POS>  = R.CERT.CHEQ.DET<CERT.DET.AMOUNT>
        R.NEW(TT.TE.LOCAL.REF)<1,DEBIT.POS>   = R.NEW(TT.TE.NET.AMOUNT)
        IF NOT(YFLAG.ONEYEAR) THEN
            R.NEW(TT.TE.ACCOUNT.2)                = W.ACCOUNT
        END
    END ELSE
        R.NEW(TT.TE.LOCAL.REF)<1,DEBIT.POS>  = R.CERT.CHEQ.DET<CERT.DET.AMOUNT>
        R.NEW(TT.TE.LOCAL.REF)<1,CREDIT.POS> = R.NEW(TT.TE.NET.AMOUNT)
        IF NOT(YFLAG.ONEYEAR) THEN
            R.NEW(TT.TE.ACCOUNT.1)                = W.ACCOUNT
        END
    END
*
RETURN
*
*-----------------------------------------------------------------------------------------------------------
END
