* @ValidationCode : MjotMTE0OTM1MjQ3ODpDcDEyNTI6MTY4OTMzOTcyNjU2MTpJVFNTOi0xOi0xOjg2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Jul 2023 18:32:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 86
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.VALIDA.ACTY.RT
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion            BP removed in INSERT File
*13/07/2023      Suresh                     R22 Manual Conversion          CALL routine format modified
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_F.ST.LAPAP.OCC.CUSTOMER
    $INSERT I_System ;*R22 Auto Conversion - End


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
        APAP.LAPAP.lapapQueryAccuityRt(Y.IDENTIFICATION,Y.C.NAME,Y.NAT,Y.GENDER,Y.DOB,Y.RES) ;*R22 Manual Conversion
    END

    Y.DECISION = Y.RES<3>
    IF Y.DECISION EQ 'No' THEN
*CALL System.setVariable("CURRENT.VAR.ACCTY.VAL","NoHit")
        CRT 'No hit Accuity'
    END ELSE

        IF GETENV("ACCUITY_INQUIRY_NOTIFY", shouldNotifyAssertion) THEN
            IF shouldNotifyAssertion EQ 'yes' THEN

                APAP.LAPAP.lapapPlafNotifyRt("RESTRICTIVA") ;*R22 Manual Conversion
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
