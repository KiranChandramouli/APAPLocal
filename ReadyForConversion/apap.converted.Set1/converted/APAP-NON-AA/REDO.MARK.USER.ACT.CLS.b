SUBROUTINE REDO.MARK.USER.ACT.CLS

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER

MAIN:

    IF APPLICATION NE 'USER' THEN
        GOSUB PGM.END
    END

    Y.APL = 'USER'
    Y.FLDS = 'L.TELR.LOAN':@VM:'L.ALLOW.ACTS'  ; PS.OO = ''
    CALL MULTI.GET.LOC.REF(Y.APL,Y.FLDS,PS.OO)
    Y.TLR.POS = PS.OO<1,1>
    Y.AL.C.POS = PS.OO<1,2>

    Y.USR = R.NEW(EB.USE.LOCAL.REF)<1,Y.TLR.POS>

    BEGIN CASE
        CASE R.NEW(EB.USE.LOCAL.REF)<1,Y.TLR.POS> EQ 'TELLER'
            IF R.NEW(EB.USE.LOCAL.REF)<1,Y.AL.C.POS> EQ '' THEN
                AF = EB.USE.LOCAL.REF
                AV = Y.AL.C.POS
                ETEXT = 'EB-MAND.IF.TELLER'
                CALL STORE.END.ERROR
            END

        CASE R.NEW(EB.USE.LOCAL.REF)<1,Y.TLR.POS> EQ 'LOANUSER'
            IF R.NEW(EB.USE.LOCAL.REF)<1,Y.AL.C.POS> NE '' THEN
                AF = EB.USE.LOCAL.REF
                AV = Y.AL.C.POS
                ETEXT = 'EB-NOT.APPL.LOANS'
                CALL STORE.END.ERROR
            END

        CASE R.NEW(EB.USE.LOCAL.REF)<1,Y.TLR.POS> EQ 'OTHERS'
            IF R.NEW(EB.USE.LOCAL.REF)<1,Y.AL.C.POS> NE '' THEN
                AF = EB.USE.LOCAL.REF
                AV = Y.AL.C.POS
                ETEXT = 'EB-NOT.OTH.LOANS'
                CALL STORE.END.ERROR
            END

    END CASE

RETURN

PGM.END:

END
