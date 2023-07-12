SUBROUTINE LAPAP.V.OCUS.FIELDS.RT
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_F.ST.LAPAP.OCC.CUSTOMER
    $INSERT I_System

    GOSUB DO.INITIALIZE
    GOSUB DO.VALIDATE
*IF R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) NE 'RNC' THEN
*
*    IF R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) EQ 'NO CLIENTE APAP' THEN
*        GOSUB DO.VALIDATE.ACCTY
*    END
*END
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

DO.VALIDATE:
    IF R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) EQ 'NO CLIENTE APAP' THEN


        IF R.NEW(10)<1,Y.L.ADDRESS.POS> EQ '' AND COMI EQ '' THEN
            TEXT = "Campos de cliente ocasional <Domicilio> es requerido para no cliente APAP"
            ETEXT = TEXT
            E = TEXT
            CALL STORE.END.ERROR
        END

    END
RETURN

DO.VALIDATE.ACCTY:

    IF (R.NEW(10)<1,Y.L.BIRTH.DATE.POS> NE '' AND R.NEW(10)<1,Y.L.NACIONALITY.POS> NE '' AND R.NEW(10)<1,Y.L.GENDER.POS> NE '') THEN
        V.VAR1.RAN = ''
        V.VAR1.RAN = System.getVariable("CURRENT.VAR.ACCTY.RAN")

        IF (V.VAR1.RAN EQ 'true') THEN

            V.VAR2.VALUE = System.getVariable("CURRENT.VAR.ACCTY.VAL")
            IF (V.VAR2.VALUE EQ 'IsHit') THEN
                TEXT = "No cumple con politi­cas internas."
                ETEXT = TEXT
                E = TEXT
                CALL STORE.END.ERROR
            END

        END ELSE
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
                CALL System.setVariable("CURRENT.VAR.ACCTY.RAN","true")
            END

            Y.DECISION = Y.RES<3>
            IF Y.DECISION EQ 'No' THEN
                CALL System.setVariable("CURRENT.VAR.ACCTY.VAL","NoHit")
            END ELSE
                CALL System.setVariable("CURRENT.VAR.ACCTY.VAL","IsHit")
                TEXT = "No cumple con politi­cas internas."
                ETEXT = TEXT
                E = TEXT
                CALL STORE.END.ERROR
            END
        END

        RETURN
    END
END
