* @ValidationCode : MjoxNTU0NjYxMDpDcDEyNTI6MTY4MjMzNTk0NTI2NTpJVFNTOi0xOi0xOjgyNDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 824
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                BP REMOVED , I TO I.VAR
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.REL.AP
    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.RELATION ;*AUTO R22 CODE CONVERSION END
   $USING EB.LocalReferences


    Y.ACC.ID = COMI
    Y.CUS.ID = ""
    Y.RELACION.CODE = ""
    Y.JOINT.HOLDER = ""
    Y.CADENA = ""

    R.PASAPORTE = ""
    R.CEDULA = ""
    R.RNC = ""
    R.ACTA = ""
    R.NUMERO.UNICO = ""
    R.IDENTIFICACION = ""

    FN.ACC = "F.ACCOUNT"
    FV.ACC = ""

    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""

    FN.REL = "F.RELATION"
    FV.REL = ""

    CALL OPF(FN.ACC,FV.ACC)
    CALL F.READ(FN.ACC,Y.ACC.ID,R.ACC,FV.ACC,ACC.ERROR)



    Y.CANT.RELACIONES = R.ACC<AC.JOINT.HOLDER>
    Y.CNT = DCOUNT(Y.CANT.RELACIONES,@VM)

    COMI = ""

    FOR I.VAR = 1 TO Y.CNT

        Y.RELACION.CODE = R.ACC<AC.RELATION.CODE , I.VAR >

        Y.CUS.ID = R.ACC<AC.JOINT.HOLDER, I.VAR >

        CALL OPF(FN.CUS,FV.CUS)

        CALL F.READ(FN.CUS,Y.CUS.ID,R.CUS,FV.CUS,CUS.ERROR)

        R.PASAPORTE = R.CUS<EB.CUS.LEGAL.ID>

*        CALL GET.LOC.REF("CUSTOMER","L.CU.RNC",Y.POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.RNC",Y.POS);* R22 UTILITY AUTO CONVERSION
        R.RNC = R.CUS<EB.CUS.LOCAL.REF,Y.POS>

*        CALL GET.LOC.REF("CUSTOMER","L.CU.CIDENT",Y.POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.CIDENT",Y.POS);* R22 UTILITY AUTO CONVERSION
        R.CEDULA = R.CUS<EB.CUS.LOCAL.REF,Y.POS>

*        CALL GET.LOC.REF("CUSTOMER","L.CU.ACTANAC",Y.POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.ACTANAC",Y.POS);* R22 UTILITY AUTO CONVERSION
        R.ACTA = R.CUS<EB.CUS.LOCAL.REF,Y.POS>

*        CALL GET.LOC.REF("CUSTOMER","L.CU.NOUNICO",Y.POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.NOUNICO",Y.POS);* R22 UTILITY AUTO CONVERSION
        R.NUMERO.UNICO = R.CUS<EB.CUS.LOCAL.REF,Y.POS>

        IF R.CEDULA NE "" THEN

            R.IDENTIFICACION = R.CEDULA

        END

        IF R.RNC NE "" THEN

            R.IDENTIFICACION = R.RNC

        END

        IF R.PASAPORTE NE "" THEN

            R.IDENTIFICACION = R.PASAPORTE

        END

        IF R.ACTA NE ""  THEN

            R.IDENTIFICACION = R.ACTA

        END

        IF R.NUMERO.UNICO NE "" THEN

            R.IDENTIFICACION = R.NUMERO.UNICO

        END

        CALL OPF(FN.REL,FV.REL)
        CALL F.READ(FN.REL,Y.RELACION.CODE,R.REL,FV.REL,REL.ERROR)

        R.DES.REL = R.REL<EB.REL.DESCRIPTION>

        IF  R.CUS<EB.CUS.NAME.1> NE "" THEN

            COMI = CADENA :  "*" : R.IDENTIFICACION : ";" : R.CUS<EB.CUS.NAME.1> : ";" : R.DES.REL
            CADENA = CADENA :  "*" : R.IDENTIFICACION : ";" : R.CUS<EB.CUS.NAME.1> : ";" : R.DES.REL

        END
        ELSE
            COMI = "" ;*CADENA :  "*" : R.IDENTIFICACION : ";" : R.CUS<EB.CUS.NAME.1> : ";" : R.DES.REL
        END

    NEXT I.VAR

END
