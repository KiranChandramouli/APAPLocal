SUBROUTINE REDO.V.INP.PARTIAL.THR.RET.CHQ
*-------------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used as a Input routine to check partial amount values
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
* 27-10-2011        S.MARIMUTHU     PACS00142802         Initial Creation
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_System
    $INSERT I_F.VERSION
    $INSERT I_GTS.COMMON


    IF OFS$SOURCE.ID EQ 'FASTPATH' AND R.VERSION(EB.VER.VERSION.TYPE) EQ 'NV' THEN
        RETURN
    END

MAIN:

    GOSUB PROCESS
    GOSUB PGM.END

PROCESS:

    APPL = 'FUNDS.TRANSFER'
    L.FIELDS = 'CERT.CHEQUE.NO':@VM:'L.LOAN.COND':@VM:'L.AA.PART.ALLOW'
    POS = ''
    CALL MULTI.GET.LOC.REF(APPL,L.FIELDS,POS)
    Y.CHQ.POS = POS<1,1>
    Y.LN.COND = POS<1,2>
    Y.PART.POS = POS<1,3>

    Y.LOAN.COND = R.NEW(FT.LOCAL.REF)<1,Y.LN.COND>
    Y.LOAN.COND = CHANGE(Y.LOAN.COND,@SM,@VM)

    Y.CHQ.NOS = R.NEW(FT.LOCAL.REF)<1,Y.CHQ.POS>

    IF Y.CHQ.NOS THEN
        IF 'ThreeReturnedChecks' MATCHES Y.LOAN.COND THEN
            ETEXT = 'EB-REQ.COLL.AREA.AUTH1'
            AF = FT.CREDIT.ACCT.NO
*AF = FT.LOCAL.REF
*AV = Y.LN.COND
            CALL STORE.END.ERROR
        END
    END

    IF PGM.VERSION EQ ',REDO.MULTI.AA.ACCRAP.UPD' OR PGM.VERSION EQ ',REDO.MULTI.AA.ACCRAP.UPD.TR' THEN
        Y.AMT = System.getVariable("CURRENT.CRED.AMT")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            Y.AMT = ""
        END

        IF Y.AMT EQ "CURRENT.CRED.AMT" THEN
            LOCATE 'EB-UNKNOWN.VARIABLE' IN E<1,1> SETTING POS THEN
                E = ''
            END
            RETURN
        END
        IF R.NEW(FT.LOCAL.REF)<1,Y.PART.POS> EQ 'YES' OR R.NEW(FT.LOCAL.REF)<1,Y.PART.POS> EQ 'SI' THEN
            IF R.NEW(FT.CREDIT.AMOUNT) LT Y.AMT THEN
                AF = FT.CREDIT.AMOUNT
                ETEXT = 'EB-REDO.PART.AMT.LESS'
                CALL STORE.END.ERROR
            END
        END
        IF R.NEW(FT.LOCAL.REF)<1,Y.PART.POS> EQ 'NO' THEN
            IF (R.NEW(FT.CREDIT.AMOUNT) NE Y.AMT) AND (Y.AMT GT 0) THEN
                AF = FT.CREDIT.AMOUNT
                ETEXT = 'EB-PART.NOT.ALLOW'
                CALL STORE.END.ERROR
                Y.FIN.AMT = ''
            END
        END
    END

    CALL REDO.CK.PO.NORMAL.REP.VL

RETURN

PGM.END:

END
