* @ValidationCode : MjoxNTI0Njg3MzAzOkNwMTI1MjoxNjgyMzMxMzIyNzEwOklUU1M6LTE6LTE6Mjk0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 294
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.BENEFICIARY(Y.FINAL)
*--------------------------------------------------------------------------------------------------
* Description           : Rutina para que retorna el listado de beneficiarios de un cliente
* Developed On          : ---
* Developed By          : Anthony Martinez
* Development Reference : ---
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
* Defect Reference       Modified By                    Date of Change        Change Details
* --------               Anthony Martinez               22/11/2018            Creation
* --------               Anthony Martinez               01/09/2019            Fix for beneficiaries shown to customer that do not belong to him
*
* 21-APR-2023   	  Conversion tool    R22 Auto conversion        F.READ to CACHE.READ, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.BENEFICIARY ;*R22 Auto conversion - END
   $USING EB.LocalReferences

*--OBTENEMOS LOS CAMPOS ENVIADOS DESDE EL SS
    LOCATE "CUST.ID" IN D.FIELDS<1> SETTING CUS.POS THEN
        CUST.ID = D.RANGE.AND.VALUE<CUS.POS> : "-"
    END

    LOCATE "BENEFICIARY.TYPE" IN D.FIELDS<1> SETTING BENEFICIARY.POS THEN
        BENEFICIARY.TYPE = D.RANGE.AND.VALUE<BENEFICIARY.POS>
    END

*--OBJECTOS PARA ABRIR EL ARCHIVO FBNK.CUS.BEN.LIST
    FN.BEN.LIST = "F.CUS.BEN.LIST"; FT.BEN.LIST = ""; RS.BEN.LIST = ""; ERR.BEN.LIST = ""

*--PARA EJECUTAR QUERY
    SEL.LIST = ""; NO.OF.REC = ""; SEL.ERR = ""; BEN.LIST.POS = ""

*--PARA ABRIR EL ACHIVO DE FBNK.CUS.BEN.LIST
    CALL OPF(FN.BEN.LIST, FT.BEN.LIST)

*--FORMAMOS EL QUERY A EJECUTAR

    Y.FILTER = " WITH @ID LIKE " : CUST.ID : "..."

    IF BENEFICIARY.TYPE EQ 1 THEN
        Y.FILTER = " WITH @ID EQ " : CUST.ID : "OWN"
    END

    IF BENEFICIARY.TYPE EQ 2 THEN
        Y.FILTER = " WITH @ID EQ " : CUST.ID : "OTHER"
    END

    SEL.CMD = "SELECT " : FN.BEN.LIST : Y.FILTER

*--EJECUTAMOS LA CONSULTA A LA TABLA DE FBNK.CUS.BEN.LIST
    CALL EB.READLIST(SEL.CMD, SEL.LIST,"", NO.OF.REC, SEL.ERR)

    LOOP

        REMOVE Y.BEN.LIST.ID FROM SEL.LIST SETTING BEN.LIST.POS

    WHILE Y.BEN.LIST.ID DO

        CALL F.READ(FN.BEN.LIST, Y.BEN.LIST.ID, RS.BEN.LIST, FT.BEN.LIST, ERR.BEN.LIST)

        FN.BEN = "F.BENEFICIARY"; FV.BEN = ""; R.BEN = ""; ERR.BEN = ""
        CALL OPF(FN.BEN, FV.BEN)

        Y.CANT.RECS = DCOUNT(RS.BEN.LIST, @FM)

        FOR A = 1 TO Y.CANT.RECS  STEP 1

            BEN.ID = FIELD(RS.BEN.LIST<A>, "*", 2)

            CALL CACHE.READ(FN.BEN, BEN.ID, R.BEN, ERR.BEN) ;*R22 Auto conversion

            Y.NICKNAME = R.BEN<ARC.BEN.NICKNAME>

*            CALL GET.LOC.REF("BENEFICIARY", "L.BEN.CUST.NAME", L.BEN.CUST.NAME.POS)
EB.LocalReferences.GetLocRef("BENEFICIARY", "L.BEN.CUST.NAME", L.BEN.CUST.NAME.POS);* R22 UTILITY AUTO CONVERSION
            Y.CUST.NAME = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.CUST.NAME.POS, 1>

*            CALL GET.LOC.REF("BENEFICIARY", "L.BEN.CEDULA", L.BEN.CEDULA.POS)
EB.LocalReferences.GetLocRef("BENEFICIARY", "L.BEN.CEDULA", L.BEN.CEDULA.POS);* R22 UTILITY AUTO CONVERSION
            Y.CEDULA = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.CEDULA.POS, 1>

*            CALL GET.LOC.REF("BENEFICIARY", "L.BEN.ACCOUNT", L.BEN.ACCOUNT.POS)
EB.LocalReferences.GetLocRef("BENEFICIARY", "L.BEN.ACCOUNT", L.BEN.ACCOUNT.POS);* R22 UTILITY AUTO CONVERSION
            Y.ACCOUNT = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.ACCOUNT.POS, 1>

*            CALL GET.LOC.REF("BENEFICIARY", "L.BEN.ACH.ARCIB", L.BEN.ACH.ARCIB.POS)
EB.LocalReferences.GetLocRef("BENEFICIARY", "L.BEN.ACH.ARCIB", L.BEN.ACH.ARCIB.POS);* R22 UTILITY AUTO CONVERSION
            Y.ACH.ARCIB = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.ACH.ARCIB.POS, 1>

*            CALL GET.LOC.REF("BENEFICIARY", "L.BEN.DOC.ARCIB", L.BEN.DOC.ARCIB.POS)
EB.LocalReferences.GetLocRef("BENEFICIARY", "L.BEN.DOC.ARCIB", L.BEN.DOC.ARCIB.POS);* R22 UTILITY AUTO CONVERSION
            Y.DOC.ARCIB = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.DOC.ARCIB.POS, 1>

*            CALL GET.LOC.REF("BENEFICIARY", "L.BEN.EMAIL", L.BEN.EMAIL.POS)
EB.LocalReferences.GetLocRef("BENEFICIARY", "L.BEN.EMAIL", L.BEN.EMAIL.POS);* R22 UTILITY AUTO CONVERSION
            Y.EMAIL = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.EMAIL.POS, 1>

*            CALL GET.LOC.REF("BENEFICIARY", "L.BEN.PROD.TYPE", L.BEN.PROD.TYPE.POS)
EB.LocalReferences.GetLocRef("BENEFICIARY", "L.BEN.PROD.TYPE", L.BEN.PROD.TYPE.POS);* R22 UTILITY AUTO CONVERSION
            Y.PROD.TYPE = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.PROD.TYPE.POS, 1>

*            CALL GET.LOC.REF("BENEFICIARY", "L.BEN.GENDER", L.BEN.GENDER.POS)
EB.LocalReferences.GetLocRef("BENEFICIARY", "L.BEN.GENDER", L.BEN.GENDER.POS);* R22 UTILITY AUTO CONVERSION
            Y.GENDER = R.BEN<ARC.BEN.LOCAL.REF, L.BEN.GENDER.POS, 1>

            IF Y.ACH.ARCIB EQ '' AND Y.PROD.TYPE NE 'CARDS'  THEN
                Y.ACCOUNT = R.BEN<ARC.BEN.BEN.ACCT.NO>
                Y.ACH.ARCIB = "APAP"
            END

            IF Y.ACH.ARCIB EQ '' AND Y.PROD.TYPE EQ 'CARDS'  THEN
                Y.ACH.ARCIB = "APAP"
            END

            Y.FINAL<-1> = BEN.ID :"|": Y.NICKNAME :"|": Y.CUST.NAME :"|": Y.CEDULA :"|": Y.ACCOUNT :"|": Y.ACH.ARCIB :"|": Y.DOC.ARCIB :"|": Y.EMAIL :"|": Y.PROD.TYPE

        NEXT A

    REPEAT

END
