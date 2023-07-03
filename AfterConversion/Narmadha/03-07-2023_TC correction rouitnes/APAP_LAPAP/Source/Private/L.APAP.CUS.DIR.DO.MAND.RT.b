* @ValidationCode : MjoxMTAzOTE0MTEwOlVURi04OjE2ODgzNjU2NTg5NDM6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 Jul 2023 11:57:38
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
*-----------------------------------------------------------------------------
* @(#) L.APAP.CUS.DIR.DO.MAND.RT Ported to jBASE 16:16:58  28 NOV 2017
* <Rating>-15</Rating>
*03-07-2023   Narmadha V   Manual R22 Conversion   Remove BP in insert file, commented inesert file
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.CUS.DIR.DO.MAND.RT
    $INSERT   I_COMMON ;* Manual R22 Conversion
    $INSERT   I_EQUATE ;* Manual R22 Conversion
    $INSERT   I_F.CUSTOMER ;* Manual R22 Conversion
*   $INSERT BP I_F.ST.LAPAP.RD.CITIES ;* Manual R22 Conversion - Commented the insert file
*    $INSERT BP I_F.ST.LAPAP.RD.PROVINCES ;* Manual R22 Conversion - Commented the insert file

*------------------------------------------------------------------------------------------------------------
    P.RESIDENCE = ""
    P.TOWN.COUNTRY = ""
    P.L.CU.URB.ENS.RE = ""
    P.L.CU.RES.SECTOR = ""


    FN.CITIES = "F.ST.LAPAP.RD.CITIES"
    F.CITIES = ""
    CALL OPF(FN.CITIES,F.CITIES)

    FN.PROVINCE = "F.ST.LAPAP.RD.PROVINCES"
    F.PROVINCE = ""
    CALL OPF(FN.PROVINCE,F.PROVINCE)



*------------------------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------------------------

    P.RESIDENCE = R.NEW(EB.CUS.RESIDENCE)
    P.COUNTRY = R.NEW(EB.CUS.COUNTRY)
    P.TOWN.COUNTRY = R.NEW(EB.CUS.TOWN.COUNTRY)
    CALL GET.LOC.REF("CUSTOMER","L.CU.URB.ENS.RE",FT.POS.1)
    P.L.CU.URB.ENS.RE = R.NEW(LOCAL.REF.FIELD)<1,FT.POS.1>
    CALL GET.LOC.REF("CUSTOMER","L.CU.RES.SECTOR",FT.POS.2)
    P.L.CU.RES.SECTOR = R.NEW(LOCAL.REF.FIELD)<1,FT.POS.2>
*------------------------------------------------------------------------------------------------------------
*P.COUNTRY = EREPLACE(P.COUNTRY," ",".")
*P.TOWN.COUNTRY = EREPLACE(P.TOWN.COUNTRY," ",".")

    IF P.RESIDENCE EQ "DO" THEN
        IF P.TOWN.COUNTRY EQ "" THEN
            MESSAGE = 'CAMPO: PROVINCIA, REQUERIDO CUANDO PAIS : DO (REP. DOMINICANA).'
            E = MESSAGE
            ETEXT = E
            CALL ERR
        END
    END

*---
    SEL.CMD = ""; NO.OF.REC = ""; SEL.ERR = ""
    SEL.CMD = "SELECT ":FN.CITIES:" WITH DESCRIPTION EQ '": P.COUNTRY: "'"

    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.REC,SEL.ERR)
    LOOP
        REMOVE CITIES.ID FROM SEL.LIST SETTING CITIES.POS
    WHILE CITIES.ID : CITIES.POS
        CALL F.READ(FN.CITIES,CITIES.ID,R.CITIES,F.CITIES,ERR.CITIES)
    REPEAT
*---

*---
    SEL.CMD = ""; NO.OF.REC = ""; SEL.ERR = ""
    SEL.CMD = "SELECT ":FN.PROVINCE:" WITH DESCRIPTION EQ '": P.TOWN.COUNTRY: "'"

    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.REC,SEL.ERR)
    LOOP
        REMOVE PRV.ID FROM SEL.LIST SETTING PRV.POS
    WHILE PRV.ID : PRV.POS
        CALL F.READ(FN.PROVINCE,PRV.ID,R.PROVINCES,F.PROVINCE,ERR.PROVINCES)
    REPEAT
*---

*CALL F.READ(FN.PROVINCE,P.TOWN.COUNTRY,R.PROVINCES,F.PROVINCE,ERR.PROVINCES)
*CALL F.READ(FN.CITIES,P.COUNTRY,R.CITIES,F.CITIES,ERR.CITIES)


    IF P.RESIDENCE EQ "DO" THEN
*IF P.TOWN.COUNTRY EQ "" THEN
*    MESSAGE = 'CAMPO: PROVINCIA, REQUERIDO CUANDO PAIS : DO (REP. DOMINICANA).'
*    E = MESSAGE
*    ETEXT = E
*    CALL ERR
*END

        IF ERR.CITIES THEN
            ETEXT = "INDIQUE UNO DE LOS POSIBLE VALORES DE LA LISTA PARA EL CAMPO CIUDAD"
            CALL STORE.END.ERROR
        END

        IF ERR.PROVINCES THEN
            ETEXT = "INDIQUE UNO DE LOS POSIBLE VALORES DE LA LISTA PARA EL CAMPO PROVINCIA"
            CALL STORE.END.ERROR
        END



*IF P.L.CU.URB.ENS.RE EQ "" THEN
*MESSAGE = 'CAMPO: URB/ENS/RES, REQUERIDO CUANDO PAIS : DO (REP. DOMINICANA).'
*E = MESSAGE
*ETEXT = E
*CALL ERR
*END
*IF P.L.CU.RES.SECTOR EQ "" THEN
*MESSAGE = 'CAMPO: SECTOR, REQUERIDO CUANDO PAIS : DO (REP. DOMINICANA).'
*E = MESSAGE
*ETEXT = E
*CALL ERR
*END


    END
*------------------------------------------------------------------------------------------------------------


RETURN

END
