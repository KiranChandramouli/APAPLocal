*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.VALIDA.ACTY.RT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_GTS.COMMON
    $INSERT BP I_F.REDO.ID.CARD.CHECK
    $INSERT BP I_F.ST.LAPAP.OCC.CUSTOMER
    $INSERT T24.BP I_System


    GOSUB DO.INITIALIZE

    IF R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) NE 'RNC' THEN

        IF R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) EQ 'NO CLIENTE APAP' THEN
            GOSUB DO.VALIDATE.ACCTY
        END
    END
    RETURN

DO.INITIALIZE:
    APPL.NAME.ARR = "REDO.ID.CARD.CHECK"
    FLD.NAME.ARR = "L.ADDRESS" : @VM : "L.TELEPHONE" : @VM : "L.ADI.INFO" : @VM : "L.NACIONALITY" : @VM : "L.BIRTH.DATE" : @VM : "L.OCC.GENDER"
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    Y.L.ADDRESS.POS = FLD.POS.ARR<1,1>
    Y.L.TELEPHONE.POS = FLD.POS.ARR<1,2>
    Y.L.ADI.INFO.POS = FLD.POS.ARR<1,3>
    Y.L.NACIONALITY.POS = FLD.POS.ARR<1,4>
    Y.L.BIRTH.DATE.POS = FLD.POS.ARR<1,5>
    Y.L.GENDER.POS = FLD.POS.ARR<1,6>
    RETURN

DO.VALIDATE.ACCTY:

    IF R.NEW(10)<1,Y.L.ADDRESS.POS> EQ '' OR R.NEW(10)<1,Y.L.BIRTH.DATE.POS> EQ '' OR R.NEW(10)<1,Y.L.NACIONALITY.POS> EQ '' THEN
        AF = 2
        TEXT = "No se puede consultar Accuity"
        ETEXT = TEXT
        E = TEXT
        CALL STORE.END.ERROR
        RETURN
    END
*A consultar Accuity
    Y.RES = ''
    Y.IDENTIFICATION = R.NEW(REDO.CUS.PRF.IDENTITY.NUMBER)
    Y.C.NAME = R.NEW(REDO.CUS.PRF.CUSTOMER.NAME)
    Y.NAT = R.NEW(10)<1,Y.L.NACIONALITY.POS>
    IF R.NEW(10)<1,Y.L.GENDER.POS> EQ 'MALE' THEN
        Y.GENDER = 'MASCULINO'
    END ELSE
        Y.GENDER = 'FEMENINO'
    END
    Y.DOB = R.NEW(10)<1,Y.L.BIRTH.DATE.POS>
    IF Y.IDENTIFICATION NE '' AND Y.C.NAME NE '' AND Y.NAT NE '' AND Y.GENDER NE '' AND Y.DOB NE '' THEN
        CALL LAPAP.QUERY.ACCUITY.RT(Y.IDENTIFICATION,Y.C.NAME,Y.NAT,Y.GENDER,Y.DOB,Y.RES)
    END

    Y.DECISION = Y.RES<3>
    IF Y.DECISION EQ 'No' THEN
*CALL System.setVariable("CURRENT.VAR.ACCTY.VAL","NoHit")
        CRT 'No hit Accuity'
    END ELSE

        IF GETENV("ACCUITY_INQUIRY_NOTIFY", shouldNotifyAssertion) THEN
            IF shouldNotifyAssertion EQ 'yes' THEN

                CALL LAPAP.PLAF.NOTIFY.RT("RESTRICTIVA")
            END
        END

        AF = 2
        AV = ""
        AS = ""
        TEXT = "No cumple con politicas internas."
        ETEXT = TEXT
        CALL STORE.END.ERROR
    END
    RETURN
END
