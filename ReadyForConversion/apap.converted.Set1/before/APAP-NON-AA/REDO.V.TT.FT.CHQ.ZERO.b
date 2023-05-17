*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.V.TT.FT.CHQ.ZERO
*
* Client: APAP
* Description: Routine to remove the leading zero's from the CERT.CHEQUE.NO field.
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER

    IF COMI NE '' THEN
        GOSUB INIT
        GOSUB PROCESS
    END
    RETURN

INIT:
*****
    APPL.NAME = "FUNDS.TRANSFER":FM:"TELLER"
    APPL.FIELD = "CERT.CHEQUE.NO":FM:"CERT.CHEQUE.NO"
    APPL.LOC = ''
    CALL MULTI.GET.LOC.REF(APPL.NAME,APPL.FIELD,APPL.LOC)
    FT.CERT.CHEQUE.NO = APPL.LOC<1,1>
    TT.CERT.CHEQUE.NO = APPL.LOC<2,1>
    RETURN

PROCESS:
******** 
    YCHQ.VAL = ''
    IF APPLICATION EQ 'FUNDS.TRANSFER' AND AV EQ FT.CERT.CHEQUE.NO THEN
        YCHQ.VAL = COMI
        COMI = TRIM(YCHQ.VAL,"0","L")
        R.NEW(FT.LOCAL.REF)<1,FT.CERT.CHEQUE.NO,AS> = COMI
        V$DISPLAY = COMI
    END

    IF APPLICATION EQ 'TELLER' AND AV EQ TT.CERT.CHEQUE.NO THEN
        YCHQ.VAL = COMI
        COMI = TRIM(YCHQ.VAL,"0","L")
        R.NEW(TT.TE.LOCAL.REF)<1,TT.CERT.CHEQUE.NO> = COMI
        V$DISPLAY = COMI
    END
    RETURN
END
