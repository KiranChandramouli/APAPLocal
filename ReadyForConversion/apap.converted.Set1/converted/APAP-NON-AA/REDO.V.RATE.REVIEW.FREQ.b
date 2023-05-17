SUBROUTINE REDO.V.RATE.REVIEW.FREQ
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* API routine check the rate frequency
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------
* Modification History :
* Date Who Reference Description
* 10-10-2011 JEEVA T B.16
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.INTEREST


    GOSUB INITIALISE
    GOSUB CHECK.PERIOD

RETURN


INITIALISE:


    Y.VAL = ''
    LOC.REF.APPL="AA.PRD.DES.INTEREST"
    LOC.REF.FIELDS="L.AA.RT.RV.FREQ"
    LOC.REF.POS=" "
    CALL GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    L.AA.RT.RV.FREQ.POS = LOC.REF.POS<1,1>

    Y.VAL = R.NEW(AA.INT.LOCAL.REF)<1,L.AA.RT.RV.FREQ.POS>

    LEN.COMI = LEN(Y.VAL)
    PERIOD = Y.VAL[LEN.COMI,1]
    VALUE = Y.VAL[1,LEN.COMI-1]

RETURN

CHECK.PERIOD:

    IF Y.VAL THEN

        IF NOT(PERIOD MATCHES 'D':@VM:'W':@VM:'M':@VM:'Y') THEN
            ETEXT = 'EB-LAST.LETTER.SHLD.BE.DWMY'
        END ELSE
            FMT.VAL = FMT(VALUE,'3"0"R')
            PRD = FMT.VAL:PERIOD
            IF FMT.VAL EQ '000' THEN
                ETEXT = 'EB-INVALID.PERIOD'
            END

            IF NOT(PRD MATCHES '3N1A') THEN
                ETEXT = 'EB-INCORRECT.FMT.SHOULD.BE.NNNX'
            END

            IF NOT(ETEXT) THEN
                IF PERIOD EQ 'M' AND VALUE GT 999 THEN
                    ETEXT = 'EB-BNE.RG.1.999'
                END
            END
        END
        IF ETEXT THEN
            AF = AA.INT.LOCAL.REF
            AV = L.AA.RT.RV.FREQ.POS
            CALL STORE.END.ERROR
        END
    END
RETURN

END
