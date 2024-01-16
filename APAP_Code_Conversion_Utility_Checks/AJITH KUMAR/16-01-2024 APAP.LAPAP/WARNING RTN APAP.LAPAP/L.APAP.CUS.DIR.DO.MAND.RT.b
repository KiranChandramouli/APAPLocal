* @ValidationCode : MjoxNjcyNDAyMTg6Q3AxMjUyOjE2OTAxNjc1MjkyNTk6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* @(#) L.APAP.CUS.DIR.DO.MAND.RT Ported to jBASE 16:16:58  28 NOV 2017
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.CUS.DIR.DO.MAND.RT
    $INSERT I_COMMON                        ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ST.LAPAP.RD.CITIES
    $INSERT I_F.ST.LAPAP.RD.PROVINCES        ;*R22 Auto conversion - End
   $USING EB.LocalReferences

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
*    CALL GET.LOC.REF("CUSTOMER","L.CU.URB.ENS.RE",FT.POS.1)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.URB.ENS.RE",FT.POS.1);* R22 UTILITY AUTO CONVERSION
    P.L.CU.URB.ENS.RE = R.NEW(LOCAL.REF.FIELD)<1,FT.POS.1>
*    CALL GET.LOC.REF("CUSTOMER","L.CU.RES.SECTOR",FT.POS.2)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.RES.SECTOR",FT.POS.2);* R22 UTILITY AUTO CONVERSION
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
