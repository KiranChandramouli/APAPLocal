* @ValidationCode : MjotMzAzNDE0ODYzOlVURi04OjE2ODkyNTUwNjk5MDY6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 19:01:09
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.OCUS.SET.RT
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 13-07-2023    Conversion Tool        R22 Auto Conversion     BPP is removed in insert file,REM to DISPLAY.MESSAGE(TEXT, '')
* 13-07-2023    Narmadha V             R22 Manual Conversion   Call routine format modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion - START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_F.ST.LAPAP.OCC.CUSTOMER ;*R22 Auto Conversion - END


*MSG<-1> = 'Hago llamada'
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
    GOSUB GET.L.REF

    IF R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) EQ 'NO CLIENTE APAP' THEN
        GOSUB INI.CHECK
    END ELSE
*Limpiar campos
        R.NEW(10)<1,Y.L.ADDRESS.POS> = ''
        R.NEW(10)<1,Y.L.TELEPHONE.POS> = ''
        R.NEW(10)<1,Y.L.ADI.INFO.POS> = ''
        R.NEW(10)<1,Y.L.NACIONALITY.POS> = ''
        R.NEW(10)<1,Y.L.BIRTH.DATE.POS> = ''
        R.NEW(10)<1,Y.L.OCC.GENDER.POS> = ''
    END

RETURN

GET.L.REF:
    APPL.NAME.ARR = "REDO.ID.CARD.CHECK" : @FM : "ST.LAPAP.OCC.CUSTOMER"
    FLD.NAME.ARR = "L.ADDRESS" : @VM : "L.TELEPHONE" : @VM : "L.ADI.INFO" : @VM : "L.NACIONALITY" : @VM : "L.BIRTH.DATE"
    FLD.NAME.ARR := @VM : "L.OCC.GENDER" : @VM : "L.OCC.D.ADDRESS"
    FLD.NAME.ARR := @FM : "L.OC.DO.ADDRESS"
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)


    Y.L.ADDRESS.POS = FLD.POS.ARR<1,1>
    Y.L.TELEPHONE.POS = FLD.POS.ARR<1,2>
    Y.L.ADI.INFO.POS = FLD.POS.ARR<1,3>
    Y.L.NACIONALITY.POS = FLD.POS.ARR<1,4>
    Y.L.BIRTH.DATE.POS = FLD.POS.ARR<1,5>
    Y.L.OCC.GENDER.POS = FLD.POS.ARR<1,6>
    Y.L.OCC.D.ADDRESS.POS = FLD.POS.ARR<1,7>
    Y.L.OC.DO.ADDRESS.POS = FLD.POS.ARR<2,1>


RETURN

INI.CHECK:
    Y.NUMERO.DOC = COMI

*MSG = ''
*MSG<-1> = 'Y.NUMERO.DOC: ' : Y.NUMERO.DOC
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
    FN.OCC = 'FBNK.ST.LAPAP.OCC.CUSTOMER'
    FV.OCC = ''
    CALL OPF(FN.OCC, FV.OCC)

    IF R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) EQ 'NO CLIENTE APAP' THEN
        GOSUB DO.PROCESS
    END ELSE
        T.LOCREF<Y.L.ADDRESS.POS,7> = 'NOINPUT'
        T.LOCREF<Y.L.TELEPHONE.POS,7> = 'NOINPUT'
        T.LOCREF<Y.L.ADI.INFO.POS,7> = 'NOINPUT'
        T.LOCREF<Y.L.NACIONALITY.POS,7> = 'NOINPUT'
        T.LOCREF<Y.L.BIRTH.DATE.POS,7> = 'NOINPUT'
        T.LOCREF<Y.L.OCC.GENDER.POS,7> = 'NOINPUT'
        T.LOCREF<Y.L.OCC.D.ADDRESS.POS,7> = 'NOINPUT'

*T.LOCREF<Y.L.ADDRESS.POS,2> = ''
*T.LOCREF<Y.L.TELEPHONE.POS,2> = ''
*T.LOCREF<Y.L.ADI.INFO.POS,2> = ''
*T.LOCREF<Y.L.NACIONALITY.POS,2> = ''
*T.LOCREF<Y.L.BIRTH.DATE.POS,2> = ''
*T.LOCREF<Y.L.OCC.GENDER.POS,2> = ''

    END
RETURN

DO.PROCESS:
    GOSUB DO.ALLOW
    CALL F.READ(FN.OCC, Y.NUMERO.DOC, RS.OCC, FV.OCC, ERR.OCC)

    IF (RS.OCC) THEN

        IF R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) EQ '' THEN
            R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = RS.OCC<ST.L.OCC.NAME>
        END
        IF R.NEW(10)<1,Y.L.ADDRESS.POS> EQ '' THEN
            R.NEW(10)<1,Y.L.ADDRESS.POS> = RS.OCC<ST.L.OCC.ADDRESS>
        END
        IF R.NEW(10)<1,Y.L.TELEPHONE.POS> EQ '' THEN
            R.NEW(10)<1,Y.L.TELEPHONE.POS> = RS.OCC<ST.L.OCC.TEL.NUMER>
        END
        IF R.NEW(10)<1,Y.L.ADI.INFO.POS> EQ '' THEN
            R.NEW(10)<1,Y.L.ADI.INFO.POS> = RS.OCC<ST.L.OCC.ADI.INFO>
        END
        IF R.NEW(10)<1,Y.L.NACIONALITY.POS> EQ '' THEN
            R.NEW(10)<1,Y.L.NACIONALITY.POS> = RS.OCC<ST.L.OCC.COUNTRY>
        END
        IF R.NEW(10)<1,Y.L.BIRTH.DATE.POS> EQ '' THEN
            R.NEW(10)<1,Y.L.BIRTH.DATE.POS> = RS.OCC<ST.L.OCC.BIRTH.DATE>
        END
        IF R.NEW(REDO.CUS.PRF.PASSPORT.COUNTRY) EQ '' THEN
            R.NEW(REDO.CUS.PRF.PASSPORT.COUNTRY) = RS.OCC<ST.L.OCC.COUNTRY>
        END
        IF R.NEW(10)<1,Y.L.OCC.GENDER.POS> EQ '' THEN
            R.NEW(10)<1,Y.L.OCC.GENDER.POS> = RS.OCC<ST.L.OCC.GENDER>
        END
        IF R.NEW(10)<1,Y.L.OCC.D.ADDRESS.POS> EQ '' THEN
            R.NEW(10)<1,Y.L.OCC.D.ADDRESS.POS> = RS.OCC<ST.L.OCC.LOCAL.REF,1,Y.L.OC.DO.ADDRESS.POS>
        END


    END ELSE
        IF R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) EQ 'CEDULA' THEN
            T(REDO.CUS.PRF.PASSPORT.COUNTRY)<3> = 'NOINPUT'
            P.OUT.ARR = ''
            P.ERROR = ''
            APAP.LAPAP.lapapGetOcusPadronRt(Y.NUMERO.DOC,P.OUT.ARR,P.ERROR) ;* R22 Manual Conversion
*MSG = ''
*MSG<-1> = 'No es cliente, y se hace llamada de padron'
*MSG<-1> = 'Data obtenida= ' : P.OUT.ARR<1>
*MSG<-1> = 'Err if any=': P.ERROR
*MSG<-1> = 'Info ref R.OLD= ' : R.OLD(REDO.CUS.PRF.CUSTOMER.NAME)
*MSG<-1> = 'Info ref R.NEW.LAST= ' : R.NEW.LAST(REDO.CUS.PRF.CUSTOMER.NAME)
*MSG<-1> = 'Info ref N= ': N(REDO.CUS.PRF.CUSTOMER.NAME)

*MSG<-1> = 'Error obtenido: ' : P.ERROR
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
            IF (P.OUT.ARR) THEN
                IF R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) EQ '' THEN
                    R.NEW(REDO.CUS.PRF.CUSTOMER.NAME) = P.OUT.ARR<1,1>
                END
                IF P.OUT.ARR<1,9> NE '' AND R.NEW(10)<1,Y.L.TELEPHONE.POS> EQ '' THEN
                    R.NEW(10)<1,Y.L.TELEPHONE.POS> = P.OUT.ARR<1,9>
                END
                IF (P.OUT.ARR<1,4> NE '' OR P.OUT.ARR<1,5> NE '' OR P.OUT.ARR<1,7> NE '') AND R.NEW(10)<1,Y.L.ADDRESS.POS> EQ '' THEN
                    R.NEW(10)<1,Y.L.ADDRESS.POS> = P.OUT.ARR<1,4> : ' ' : P.OUT.ARR<1,5> : ' ' : P.OUT.ARR<1,7>
                END
                R.NEW(10)<1,Y.L.NACIONALITY.POS> = 'DO'
                IF P.OUT.ARR<1,6> EQ 'M' THEN
                    R.NEW(10)<1,Y.L.OCC.GENDER.POS> = 'MALE'
                END ELSE
                    R.NEW(10)<1,Y.L.OCC.GENDER.POS> = 'FEMALE'
                END
                IF P.OUT.ARR<1,2> NE '' AND R.NEW(10)<1,Y.L.BIRTH.DATE.POS> EQ '' THEN
                    R.NEW(10)<1,Y.L.BIRTH.DATE.POS> = P.OUT.ARR<1,2>[7,4] : P.OUT.ARR<1,2>[4,2]:P.OUT.ARR<1,2>[1,2]
                END

            END
            IF (P.ERROR) THEN
                Y.ERR.MSG = P.ERROR<1,1>
                TEXT = 'ERROR CONSULTANDO INFO. PADRON: ' : Y.ERR.MSG
                CALL DISPLAY.MESSAGE(TEXT, '') ;*R22 Auto Conversion
            END
        END
    END

RETURN

DO.ALLOW:
    T.LOCREF<Y.L.ADDRESS.POS,7> = ''
    T.LOCREF<Y.L.TELEPHONE.POS,7> = ''
    T.LOCREF<Y.L.ADI.INFO.POS,7> = ''
    T.LOCREF<Y.L.NACIONALITY.POS,7> = ''
    T.LOCREF<Y.L.BIRTH.DATE.POS,7> = ''
    T.LOCREF<Y.L.OCC.GENDER.POS,7> = ''
    T.LOCREF<Y.L.OCC.D.ADDRESS.POS,7> = ''


*T.LOCREF<Y.L.ADDRESS.POS,2> = '10.1'
*T.LOCREF<Y.L.TELEPHONE.POS,2> = '10.1'
*T.LOCREF<Y.L.ADI.INFO.POS,2> = '10.1'
*T.LOCREF<Y.L.NACIONALITY.POS,2> = '10.1'
*T.LOCREF<Y.L.BIRTH.DATE.POS,2> = '10.1'
*T.LOCREF<Y.L.OCC.GENDER.POS,2> = '10.1'


RETURN
END
