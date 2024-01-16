* @ValidationCode : MjotMTU4MzgyMzg0NjpDcDEyNTI6MTY4MjMzNTk0NTQzNjpJVFNTOi0xOi0xOjIwMDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                BP REMOVED
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*---------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.TIP.CL.JU

    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSIPON START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER ;* AUTO R22 CODE CONVERSIPON END
   $USING EB.LocalReferences

    FN.CUS = "F.CUSTOMER"
    F.CUS =  ""
    R.CUS = ""
    CUS.ERR = ""
    CALL OPF(FN.CUS,F.CUS)

    CUSTOMER.ID = COMI

    CALL F.READ(FN.CUS,CUSTOMER.ID,R.CUS,F.CUS,CUS.ERR)

*    CALL GET.LOC.REF("CUSTOMER", "L.CU.TIPO.CL",AC.POS.1)
EB.LocalReferences.GetLocRef("CUSTOMER", "L.CU.TIPO.CL",AC.POS.1);* R22 UTILITY AUTO CONVERSION
    TIPO.CLIENTE =   R.CUS<EB.CUS.LOCAL.REF,AC.POS.1>

    IF TIPO.CLIENTE NE 'PERSONA JURIDICA' THEN

        MESSAGE = "TIPO DE CLIENTE NO CORRESPONDE CON LA CATEGORIA DE CUENTA"
        E = MESSAGE
        CALL ERR

        RETURN

    END


END
