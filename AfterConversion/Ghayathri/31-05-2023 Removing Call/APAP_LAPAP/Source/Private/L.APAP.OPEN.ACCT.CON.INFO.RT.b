* @ValidationCode : MjotMTgzNDAzNjQ1NjpDcDEyNTI6MTY4NDIyMjc5NjcyNzpJVFNTOi0xOi0xOjM3NTU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:09:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 3755
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.OPEN.ACCT.CON.INFO.RT(Y.FINAL)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion  - F.READ to CACHE.READ , B to B.VAR , = to EQ and ++ to +=1
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.COUNTRY
    $INSERT I_F.DATES
    $INSERT I_F.COMPANY

    GOSUB INI
    GOSUB GET_PARAMS
    GOSUB GET_ACCOUNT_INF
    GOSUB GET_FIRST_TIT
    GOSUB GET_SECOND_TIT
    GOSUB GET_OFFICIAL_INF
    GOSUB FORMAR_Y_FINAL

INI:
    FN.CU.ACC = "F.CUSTOMER.ACCOUNT"
    FV.CUS.ACC = ""
    R.CUS.ACC = ""
    CUS.ACC.ERR = ""
    CALL OPF(FN.CU.ACC,FV.CUS.ACC)

    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""
    R.CUS = ""
    CUS.ERR = ""
    CALL OPF(FN.CUS,FV.CUS)

    FN.ACC = "F.ACCOUNT"
    FV.ACC = ""
    R.ACC = ""
    ACC.ERR = ""
    CALL OPF(FN.ACC,FV.ACC)

    FN.CAT = "F.CATEGORY"
    FV.CAT = ""
    R.CAT = ""
    CAT.ERR = ""
    CALL OPF(FN.CAT,FV.CAT)

    FN.COU = "F.COUNTRY"
    FV.COU = ""
    R.COU = ""
    COU.ERR = ""
    CALL OPF(FN.COU,FV.COU)

    FN.COM = "F.COMPANY"
    FV.COM = ""
    R.COM = ""
    COM.ERR = ""
    CALL OPF(FN.COU,FV.COU)

    FN.URB.ENS.RES.DOMI = "F.REDO.URB.ENS.RES.DOMI"
    FV.URB.ENS.RES.DOMI = ""
    R.URB.ENS.RES.DOMI  = ""
    ERR.URB.ENS.RES.DOMI = ""
    CALL OPF(FN.URB.ENS.RES.DOMI,FV.URB.ENS.RES.DOMI)

    FN.SECTOR.DOMI = "F.REDO.SECTOR.DOMI"
    FV.SECTOR.DOMI = ""
    R.SECTOR.DOMI = ""
    ERR.SECTOR.DOMI = ""
    CALL OPF(FN.SECTOR.DOMI,FV.SECTOR.DOMI)

RETURN

GET_PARAMS:
    LOCATE "ACCOUNT.NUMBER" IN D.FIELDS<1> SETTING CUS.POS THEN
        F.ID = D.RANGE.AND.VALUE<CUS.POS>
    END
    LOCATE "OFFICIAL.CIDENT" IN D.FIELDS<1> SETTING CUS.POS THEN
        F.OFFICIAL.CIDENT = D.RANGE.AND.VALUE<CUS.POS>
    END
RETURN

GET_ACCOUNT_INF:

    CALL F.READ(FN.ACC,F.ID,R.ACC, FV.ACC, ACC.ERR)
    T.AC.CUSTOMER   = R.ACC<AC.CUSTOMER>
    T.AC.CUSTOMER.2 = ""
    T.AC.CUSTOMER.3 = ""
    T.AC.CATEGORY = R.ACC<AC.CATEGORY>
    T.CO.CODE = R.ACC<AC.CO.CODE>
    T.SUCURSAL = ""
    T.CIUDAD.SUCURSAL = ""
    GOSUB GET_CO_CODE
    IF (T.AC.CATEGORY GE 6000) AND (T.AC.CATEGORY LE 6599) THEN
        WAKAWAKA = "OK"
        E_MSG = ""
    END ELSE
        E_MSG = "EL PRODUCTO ESPECIFICADO NO ES UNA CUENTA DE AHORRO LIBRETA/DEBITO."
        GOSUB ENQ_ERROR
    END

    GOSUB GET_ACCOUNT_CAT
    T.TIPO.CTA = "Cuenta Individual"
    T.AC.RELATION.CODE  = R.ACC<AC.RELATION.CODE>
    T.CANT.VM.REL.CO = DCOUNT(T.AC.RELATION.CODE,@VM)
    FOR A = 1 TO T.CANT.VM.REL.CO STEP 1
        RC = R.ACC<AC.RELATION.CODE, A>
        IF (RC EQ 500) THEN
            T.TIPO.CTA = "Cuenta Mancomunada 'Y'"
            BREAK
        END
        IF (RC EQ 501) THEN
            T.TIPO.CTA = "Cuenta Mancomunada 'O'"
            BREAK
        END
        IF (RC EQ 510) THEN
            T.TIPO.CTA = "Cuenta de Menor"
            BREAK
        END
    NEXT A
*    CNT.B = 0
    FOR B.VAR = 1 TO T.CANT.VM.REL.CO STEP 1
        RC = R.ACC<AC.RELATION.CODE, A>
        IF (RC EQ 500) OR (RC EQ 501) OR (RC EQ 510) THEN
            T.AC.CUSTOMER.2 = R.ACC<AC.JOINT.HOLDER, B.VAR>
            BREAK
        END
*********************************************************************************************************************************
*No descomentar las siguientes lineas, pues ahora en caso de ser persona juridica sus representantes se buscan en la tabla...
*... CUSTOMER
*        REL.COD.REP = ""
*        IF CNT.B EQ 1 THEN
*           REL.COD.REP = R.ACC<AC.RELATION.CODE, B>
*            IF REL.COD.REP EQ 104 THEN
*               REL.CUS.REP = R.ACC<AC.JOINT.HOLDER, B>
*                T.AC.CUSTOMER.2 = REL.CUS.REP
*                CNT.B = CNT.B + 1
*            END
*       END
*        IF CNT.B EQ 2 THEN
*           REL.COD.REP = R.ACC<AC.RELATION.CODE, B>
*            IF REL.COD.REP EQ 104 THEN
*                REL.CUS.REP = R.ACC<AC.JOINT.HOLDER, B>
*               T.AC.CUSTOMER.3 = REL.CUS.REP
*                CNT.B = CNT.B + 1
*            END
*        END
*        IF CNT.B EQ 2 THEN
*            BREAK
*        END
*********************************************************************************************************************************
    NEXT B.VAR

    T.TODAY = R.DATES(EB.DAT.TODAY)

    T.TIPO.CLIENTE = ""
    T.ARCHIVO = ""
    T.TIT.NOMBRE.1 = ""
    T.TIT.APELLI.1 = ""
    T.TIT.NACIONALIDAD.1 = ""
    T.TIT.IDENTI.1 = ""
    T.CUS.EMAIL.1.1 = ""
    T.DIRECCION.1 = ""
    T.TIT.NOMBRE.2 = ""
    T.TIT.APELLI.2 = ""
    T.TIT.NACIONALIDAD.2 = ""
    T.TIT.IDENTI.2 = ""
    T.CUS.EMAIL.1.2 = ""
    T.DIRECCION.2 = ""
    T.RAZON.SOCIAL = ""
    T.RNC = ""
    T.DIRECCION.EMPR = ""
    T.TIPO.DOC1 = ""
    T.TIPO.DOC2 = ""
    T.ESTADO.CIVIL = ""
    T.ESTADO.CIVIL2 = ""

RETURN

GET_ACCOUNT_CAT:
    CALL CACHE.READ(FN.CAT, T.AC.CATEGORY, R.CAT, CAT.ERR)	;*R22 Auto Conversion  - F.READ to CACHE.READ
    T.EB.CAT.DESCRIPTION = R.CAT<EB.CAT.DESCRIPTION>

RETURN

GET_FIRST_TIT:
    CALL F.READ(FN.CUS,T.AC.CUSTOMER,R.CUS, FV.CUS, CUS.ERR)
    T.TIPO.CLIENTE = ""
    T.ARCHIVO = "CNT.CTA.AH.PF.xsl"
    CALL GET.LOC.REF("CUSTOMER", "L.CU.TIPO.CL",CUS.POS.4)
    T.TIPO.CLIENTE = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.4>
    IF R.CUS<EB.CUS.LOCAL.REF,CUS.POS.4> NE "PERSONA JURIDICA" THEN
        T.TIPO.CLIENTE = "PERSONA FISICA"
    END
    IF R.CUS<EB.CUS.LOCAL.REF,CUS.POS.4> EQ "PERSONA JURIDICA" THEN
        T.ARCHIVO = "CNT.CTA.AH.PJ.xsl"
    END ELSE
        T.ARCHIVO = "CNT.CTA.AH.PF.xsl"
    END

    IF R.CUS<EB.CUS.LOCAL.REF,CUS.POS.4> NE "PERSONA JURIDICA" THEN
        T.TIT.NOMBRE.1 = R.CUS<EB.CUS.GIVEN.NAMES>
        T.TIT.APELLI.1 = R.CUS<EB.CUS.FAMILY.NAME>
        T.TIT.NACIONALIDAD.1 = R.CUS<EB.CUS.NATIONALITY>
        T.TIT.IDENTI.1 = ""
        CALL GET.LOC.REF("CUSTOMER", "L.CU.CIDENT",CUS.POS)
        T.CUS.CIDENT = R.CUS<EB.CUS.LOCAL.REF,CUS.POS>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.RNC",CUS.POS.1)
        T.CUS.RNC = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.1>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.PASS.NAT",CUS.POS.2)
        T.CUS.PASS.NAT = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.2>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.ACTANAC",CUS.POS.3)
        T.CUS.ACTANAC.1 = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.3>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.NOUNICO",CUS.POS.4)
        T.CUS.NOUNICO.1 = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.4>
        IF T.CUS.RNC NE "" THEN
            T.TIT.IDENTI.1 = "-RNC.^" : T.CUS.RNC
        END
        IF T.CUS.PASS.NAT NE "" THEN
            T.TIT.IDENTI.1 = "-Pas. No.^" : T.CUS.PASS.NAT
        END
        IF T.CUS.ACTANAC.1 NE "" THEN
            T.TIT.IDENTI.1 = "-Act. Nac.^" : T.CUS.ACTANAC.1
        END
        IF T.CUS.CIDENT NE "" THEN
            T.TIT.IDENTI.1 = "-Ced.^" : T.CUS.CIDENT
        END
        IF T.CUS.NOUNICO.1 NE "" THEN
            T.TIT.IDENTI.1 = "-No.Uni.^" : T.CUS.NOUNICO.1
        END
**HAGO UNA PEQUEñA LIMPIEZA A LA VARIABLE DE IDENTIDAD EN CASO DE QUE EL CUSTOMER NO EXISTA...
        IF R.CUS EQ "" THEN
            T.TIT.IDENTI.1 = ""
        END
        T.CUS.EMAIL.1.1 = R.CUS<EB.CUS.EMAIL.1,1>

        T.URB.ENS.RES = ""

        CALL GET.LOC.REF("CUSTOMER", "L.CU.URB.ENS.RE",XX.YY.POS.1)
        CU.URB.ENS.RES = R.CUS<EB.CUS.LOCAL.REF,XX.YY.POS.1>
        GOSUB GET_URB.ENS.RES
        T.SECTOR = ""

        CALL GET.LOC.REF("CUSTOMER", "L.CU.RES.SECTOR",XX.YY.POS.2)
        CU.SECTOR = R.CUS<EB.CUS.LOCAL.REF,XX.YY.POS.2>
        GOSUB GET_SECTOR
        T.DIRECCION.1 = R.CUS<EB.CUS.STREET> : " " : R.CUS<EB.CUS.ADDRESS> : " " : T.URB.ENS.RES : " " : T.SECTOR : " " : R.CUS<EB.CUS.COUNTRY>
        T.ESTADO.CIVIL = R.CUS<EB.CUS.MARITAL.STATUS>

        GOSUB GET_FIRST_COUNTRY
    END ELSE
*DE LO CONTRARIO ES PERSONA JURIDICA, ASI QUE EL TITULAR UNO SERIA EL REPRESENTANTE 1
*Y EL CUSTOMER ENLAZADO A LA CUENTA ES LA PERSONA JURIDICA.
        T.RAZON.SOCIAL = R.CUS< EB.CUS.NAME.1> : " " : R.CUS< EB.CUS.NAME.2>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.RNC",CUS.POS.1)
        T.CUS.RNC = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.1>
        T.RNC = T.CUS.RNC
*T.DIRECCION.EMPR = R.CUS<EB.CUS.STREET>
        T.URB.ENS.RES = ""

        CALL GET.LOC.REF("CUSTOMER", "L.CU.URB.ENS.RE",XX.YY.POS.1)
        CU.URB.ENS.RES = R.CUS<EB.CUS.LOCAL.REF,XX.YY.POS.1>
        GOSUB GET_URB.ENS.RES
        T.SECTOR = ""

        CALL GET.LOC.REF("CUSTOMER", "L.CU.RES.SECTOR",XX.YY.POS.2)
        CU.SECTOR = R.CUS<EB.CUS.LOCAL.REF,XX.YY.POS.2>
        GOSUB GET_SECTOR
        T.DIRECCION.EMPR = R.CUS<EB.CUS.STREET> : " " : R.CUS<EB.CUS.ADDRESS> : " " : T.URB.ENS.RES : " " : T.SECTOR : " " : R.CUS<EB.CUS.COUNTRY>
*Obtengo el primer representante si hay alguno
*En caso de ser persona juridica sus representantes se guardan en los campos RELATION.CODE & REL.CUSTOMER (relacion & cliente)
        T.RELACIONES = R.CUS<EB.CUS.RELATION.CODE>
        T.CANT.VM.REL.CO.PJ = DCOUNT(T.RELACIONES,@VM)
        REL.CONTADOR = 0
        FOR C = 1 TO T.CANT.VM.REL.CO.PJ STEP 1
            T.REL.ACTUAL = R.CUS<EB.CUS.RELATION.CODE, C>
            IF T.REL.ACTUAL EQ 104 THEN
                REL.CONTADOR += 1
                IF (REL.CONTADOR EQ 1) THEN
                    T.AC.CUSTOMER.2 = R.CUS<EB.CUS.REL.CUSTOMER, C>
                    IF REL.CONTADOR EQ T.CANT.VM.REL.CO.PJ THEN
                        BREAK
                    END
                END

                IF (REL.CONTADOR EQ 2) THEN
                    T.AC.CUSTOMER.3 = R.CUS<EB.CUS.REL.CUSTOMER, C>
                    IF REL.CONTADOR EQ T.CANT.VM.REL.CO.PJ THEN
                        BREAK
                    END
                END

            END
        NEXT C

        CALL F.READ(FN.CUS,T.AC.CUSTOMER.2,R.CUS2, FV.CUS, CUS2.ERR)
        T.TIT.NOMBRE.1 = R.CUS2<EB.CUS.GIVEN.NAMES>
        T.TIT.APELLI.1 = R.CUS2<EB.CUS.FAMILY.NAME>
        T.TIT.NACIONALIDAD.1 = R.CUS2<EB.CUS.NATIONALITY>
        T.TIT.IDENTI.1 = ""
        CALL GET.LOC.REF("CUSTOMER", "L.CU.CIDENT",CUS.POS)
        T.CUS.CIDENT = R.CUS2<EB.CUS.LOCAL.REF,CUS.POS>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.PASS.NAT",CUS.POS.2)
        T.CUS.PASS.NAT = R.CUS2<EB.CUS.LOCAL.REF,CUS.POS.2>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.ACTANAC",CUS.POS.3)
        T.CUS.ACTANAC.1 = R.CUS2<EB.CUS.LOCAL.REF,CUS.POS.3>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.NOUNICO",CUS.POS.4)
        T.CUS.NOUNICO.1 = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.4>
        IF T.CUS.PASS.NAT NE "" THEN
            T.TIT.IDENTI.1 = "-Pasaporte No.:^" : T.CUS.PASS.NAT
        END
        IF T.CUS.ACTANAC.1 NE "" THEN
            T.TIT.IDENTI.1 = "-Acta Nac.:^" : T.CUS.ACTANAC.1
        END
        IF T.CUS.CIDENT NE "" THEN
            T.TIT.IDENTI.1 = "-Ced.^" : T.CUS.CIDENT
        END ELSE
            T.TIT.IDENTI.1 = "-No.Uni.^" : T.CUS.NOUNICO.1
        END
**HAGO UNA PEQUEñA LIMPIEZA A LA VARIABLE DE IDENTIDAD EN CASO DE QUE EL CUSTOMER NO EXISTA...
        IF R.CUS2 EQ "" THEN
            T.TIT.IDENTI.1 = ""
        END
        T.CUS.EMAIL.1.1 = R.CUS2<EB.CUS.EMAIL.1,1>

        T.URB.ENS.RES = ""

        CALL GET.LOC.REF("CUSTOMER", "L.CU.URB.ENS.RE",XX.YY.POS.1)
        CU.URB.ENS.RES = R.CUS2<EB.CUS.LOCAL.REF,XX.YY.POS.1>
        GOSUB GET_URB.ENS.RES
        T.SECTOR = ""

        CALL GET.LOC.REF("CUSTOMER", "L.CU.RES.SECTOR",XX.YY.POS.2)
        CU.SECTOR = R.CUS2<EB.CUS.LOCAL.REF,XX.YY.POS.2>
        GOSUB GET_SECTOR
        T.DIRECCION.1 = R.CUS2<EB.CUS.STREET> : " " : R.CUS2<EB.CUS.ADDRESS> : " " : T.URB.ENS.RES : " " : T.SECTOR : " " : R.CUS2<EB.CUS.COUNTRY>

        GOSUB GET_FIRST_COUNTRY

    END




RETURN

GET_SECOND_TIT:
**Si T.AC.CUSTOMER NO ES NULO y T.AC.CUSTOMER.2 NO ES NULO, VERIFICO T.AC.CUSTOMER.3
**DE LO CONTRARIO VERIFICO T.AC.CUSTOMER.2

    IF T.AC.CUSTOMER NE "" AND T.AC.CUSTOMER.2 NE "" AND T.AC.CUSTOMER.3 NE "" THEN
        CALL F.READ(FN.CUS,T.AC.CUSTOMER.3,R.CUS, FV.CUS, CUS.ERR)
        T.TIT.NOMBRE.2 = R.CUS<EB.CUS.GIVEN.NAMES>
        T.TIT.APELLI.2 = R.CUS<EB.CUS.FAMILY.NAME>
        T.TIT.NACIONALIDAD.2 = R.CUS<EB.CUS.NATIONALITY>
        T.TIT.IDENTI.2 = ""
        CALL GET.LOC.REF("CUSTOMER", "L.CU.CIDENT",CUS.POS)
        T.CUS.CIDENT.2 = R.CUS<EB.CUS.LOCAL.REF,CUS.POS>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.RNC",CUS.POS.1)
        T.CUS.RNC.2 = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.1>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.PASS.NAT",CUS.POS.2)
        T.CUS.PASS.NAT.2 = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.2>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.ACTANAC",CUS.POS.3)
        T.CUS.ACTANAC.2 = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.3>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.NOUNICO",CUS.POS.4)
        T.CUS.NOUNICO.2 = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.4>
        IF T.CUS.RNC.2 NE "" THEN
            T.TIT.IDENTI.2 = "RNC^" : T.CUS.RNC.2
        END
        IF T.CUS.PASS.NAT.2 NE "" THEN
            T.TIT.IDENTI.2 = "-Pas. No.^" : T.CUS.PASS.NAT.2
        END
        IF T.CUS.ACTANAC.2 NE "" THEN
            T.TIT.IDENTI.2 = "-Act. Nac.^" : T.CUS.ACTANAC.2
        END
        IF T.CUS.CIDENT.2 NE "" THEN
            T.TIT.IDENTI.2 = "-Ced.^" : T.CUS.CIDENT.2
        END ELSE
            T.TIT.IDENTI.2 = "-No.Uni.^" : T.CUS.NOUNICO.2
        END
        T.CUS.EMAIL.1.2 = R.CUS<EB.CUS.EMAIL.1,1>
        T.DIRECCION.2 = R.CUS<EB.CUS.STREET> : "" : R.CUS<EB.CUS.ADDRESS>
        GOSUB GET_SECOND_COUNTRY
    END
    IF T.TIPO.CLIENTE EQ "PERSONA FISICA" THEN
        CALL F.READ(FN.CUS,T.AC.CUSTOMER.2,R.CUS, FV.CUS, CUS.ERR)
        T.TIT.NOMBRE.2 = R.CUS<EB.CUS.GIVEN.NAMES>
        T.TIT.APELLI.2 = R.CUS<EB.CUS.FAMILY.NAME>
        T.TIT.NACIONALIDAD.2 = R.CUS<EB.CUS.NATIONALITY>
        T.TIT.IDENTI.2 = ""
        CALL GET.LOC.REF("CUSTOMER", "L.CU.CIDENT",CUS.POS)
        T.CUS.CIDENT.2 = R.CUS<EB.CUS.LOCAL.REF,CUS.POS>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.RNC",CUS.POS.1)
        T.CUS.RNC.2 = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.1>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.PASS.NAT",CUS.POS.2)
        T.CUS.PASS.NAT.2 = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.2>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.ACTANAC",CUS.POS.3)
        T.CUS.ACTANAC.2 = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.3>
        CALL GET.LOC.REF("CUSTOMER", "L.CU.NOUNICO",CUS.POS.4)
        T.CUS.NOUNICO.2 = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.4>
        IF T.CUS.RNC NE "" THEN
            T.TIT.IDENTI.2 = "RNC.^" : T.CUS.RNC.2
        END
        IF T.CUS.PASS.NAT.2 NE "" THEN
            T.TIT.IDENTI.2 = "-Pas. No.^" : T.CUS.PASS.NAT.2
        END
        IF T.CUS.ACTANAC.2 NE "" THEN
            T.TIT.IDENTI.2 = "-Act. Nac.^" : T.CUS.ACTANAC.2
        END
        IF T.CUS.CIDENT.2 NE "" THEN
            T.TIT.IDENTI.2 = "-Ced.^" : T.CUS.CIDENT.2
        END ELSE
            T.TIT.IDENTI.2 = "-No.Uni.^" : T.CUS.NOUNICO.2
        END
**HAGO UNA PEQUEñA LIMPIEZA A LA VARIABLE DE IDENTIDAD EN CASO DE QUE EL CUSTOMER NO EXISTA...
        IF T.TIT.IDENTI.2 EQ "RNC.^" OR T.TIT.IDENTI.2 EQ "-Pas. No.^" OR T.TIT.IDENTI.2 EQ "-Ced.^"  OR T.TIT.IDENTI.2 EQ "-No.Uni.^" THEN
            T.TIT.IDENTI.2 = ""
        END
        T.CUS.EMAIL.1.2 = R.CUS<EB.CUS.EMAIL.1,1>
        T.ESTADO.CIVIL2 = R.CUS<EB.CUS.MARITAL.STATUS>
        T.URB.ENS.RES = ""

        CALL GET.LOC.REF("CUSTOMER", "L.CU.URB.ENS.RE",XX.YY.POS.1)
        CU.URB.ENS.RES = R.CUS<EB.CUS.LOCAL.REF,XX.YY.POS.1>
        GOSUB GET_URB.ENS.RES
        T.SECTOR = ""

        CALL GET.LOC.REF("CUSTOMER", "L.CU.RES.SECTOR",XX.YY.POS.2)
        CU.SECTOR = R.CUS<EB.CUS.LOCAL.REF,XX.YY.POS.2>
        GOSUB GET_SECTOR
        T.DIRECCION.2 = R.CUS<EB.CUS.STREET> : " " : R.CUS<EB.CUS.ADDRESS> : " " : T.URB.ENS.RES : " " : T.SECTOR : " " : R.CUS<EB.CUS.COUNTRY>

        GOSUB GET_SECOND_COUNTRY
    END


RETURN

GET_FIRST_COUNTRY:
    CALL CACHE.READ(FN.COU, T.TIT.NACIONALIDAD.1, R.COU, COU.ERR)	;*R22 Auto Conversion  - F.READ to CACHE.READ
    T.COU.COUNTRY.NAME.1 = R.COU<EB.COU.COUNTRY.NAME>

RETURN

GET_SECOND_COUNTRY:
    CALL CACHE.READ(FN.COU, T.TIT.NACIONALIDAD.2, R.COU, COU.ERR)	;*R22 Auto Conversion  - F.READ to CACHE.READ
    T.COU.COUNTRY.NAME.2 = R.COU<EB.COU.COUNTRY.NAME>

RETURN

GET_OFFICIAL_INF:
    SEL.CMD = "SELECT FBNK.CUSTOMER WITH L.CU.CIDENT EQ " : F.OFFICIAL.CIDENT : " SAMPLE 1"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)
    LOOP REMOVE T.OFFICIAL.CUS.ID FROM SEL.LIST SETTING STMT.POS
    WHILE T.OFFICIAL.CUS.ID DO
        CALL F.READ(FN.CUS,T.OFFICIAL.CUS.ID,R.CUS, FV.CUS, CUS.ERR)
        T.NOMBRE.OFICIAL = R.CUS<EB.CUS.GIVEN.NAMES>
        T.APELLIDO.OFICIAL = R.CUS<EB.CUS.FAMILY.NAME>
        T.IDENTI.OFICIAL = F.OFFICIAL.CIDENT
*T.CO.CODE = R.CUS<EB.CUS.CO.CODE>
*T.SUCURSAL = ""
*T.CIUDAD.SUCURSAL = ""
*GOSUB GET_CO_CODE
    REPEAT
    IF T.NOMBRE.OFICIAL EQ "" THEN
        E_MSG = "CEDULA DE OFICIAL NO FUE ENCONTRADA, FAVOR VERIFICAR."
        GOSUB ENQ_ERROR
    END
RETURN

GET_CO_CODE:
    CALL CACHE.READ(FN.COM, T.CO.CODE, R.COM, COM.ERR)	;*R22 Auto Conversion  - F.READ to CACHE.READ
    T.SUCURSAL = R.COM<EB.COM.COMPANY.NAME>
    T.CIUDAD.SUCURSAL = R.COM<EB.COM.NAME.ADDRESS,3>
RETURN

GET_URB.ENS.RES:
    T.URB.ENS.RES = ""
    CALL F.READ(FN.URB.ENS.RES.DOMI,CU.URB.ENS.RES,R.URB.ENS.RES.DOMI, FV.URB.ENS.RES.DOMI, ERR.URB.ENS.RES.DOMI)
    T.URB.ENS.RES = R.URB.ENS.RES.DOMI<1>         ;**EQU XX.YY.DESCRIPTION
RETURN

GET_SECTOR:
    T.SECTOR = ""
    CALL F.READ(FN.SECTOR.DOMI,CU.SECTOR,R.SECTOR.DOMI, FV.SECTOR.DOMI, ERR.SECTOR.DOMI)
    T.SECTOR = R.SECTOR.DOMI<1>         ;*EQU XX.YY.DESCRIPTION
RETURN

FORMAR_Y_FINAL:
    IF R.ACC NE "" THEN
        Y.FINAL<-1> = F.ID : "*" : T.AC.CUSTOMER : "*" : T.AC.CUSTOMER.2 : "*" : T.AC.CATEGORY : "*" : T.EB.CAT.DESCRIPTION : "*" : T.TIPO.CTA : "*"  : T.TIT.NOMBRE.1 : "*" : T.TIT.APELLI.1 : "*" : T.TIT.NACIONALIDAD.1 : "*" : T.COU.COUNTRY.NAME.1 : "*" : T.TIT.IDENTI.1 : "*" : T.CUS.EMAIL.1.1 : "*" : T.DIRECCION.1 : "*" : T.TIT.NOMBRE.2 : "*" : T.TIT.APELLI.2 : "*" : T.TIT.NACIONALIDAD.2 : "*" : T.COU.COUNTRY.NAME.2 : "*" : T.TIT.IDENTI.2 : "*" : T.CUS.EMAIL.1.2 : "*" : T.DIRECCION.2 : "*" : T.NOMBRE.OFICIAL : "*" : T.APELLIDO.OFICIAL : "*" : T.IDENTI.OFICIAL : "*" : T.SUCURSAL : "*" : T.TODAY : "*" : T.TIPO.CLIENTE : "*" : T.CIUDAD.SUCURSAL : "*" : T.RAZON.SOCIAL : "*" : T.CUS.RNC : "*" : T.DIRECCION.EMPR : "*" : T.ARCHIVO : "*" : T.ESTADO.CIVIL : "*" : T.ESTADO.CIVIL2
    END ELSE
        Y.FINAL<-1> = "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND" : "*" : "NO RECORD FOUND"
    END

RETURN


ENQ_ERROR:
    ENQ.ERROR = E_MSG
    ENQ.ERROR<1,2> = 2
RETURN

END
