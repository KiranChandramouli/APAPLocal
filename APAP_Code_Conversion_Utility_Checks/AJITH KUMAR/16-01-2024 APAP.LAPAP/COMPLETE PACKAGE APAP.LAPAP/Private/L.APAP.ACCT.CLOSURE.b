* @ValidationCode : MjoxNjk2Mjc1NjU3OkNwMTI1MjoxNzAyOTg4MzQ0NDgxOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ACCT.CLOSURE(ENQ.DATA)
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INCLUDE T24.BP TO $INSERT AND I TO I.VAR
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* 15-12-2023        Santosh C              MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $USING EB.LocalReferences ;*R22 Manual Code Conversion_Utility Check


***ABRIR LA TABLA ACCOUNT
    FN.AC = "F.ACCOUNT"
    FV.AC = ""
    YV.AC = ""
    ERR.AC = ""
    CALL OPF(FN.AC,FV.AC)

    FOR I.VAR = 1 TO 2
***AQUI SE ASIGNA EL ID EN LA VARIABLE ENQ.DATA
        IF ENQ.DATA<2,I.VAR> EQ "@ID" THEN
            YV.AC = ENQ.DATA<4,I.VAR>
        END
    NEXT I.VAR

***SE REALIZA EL LLAMADO DE LA INFORMACION QUE SE VA A UTILIZAR
    CALL F.READ(FN.AC, YV.AC, R.AC, F.AC, ERR.AC)

***SE BUSCA EL CAMPO LOCAL DESDE ACCOUNT
*   CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",CUS.POS)
    EB.LocalReferences.GetLocRef("ACCOUNT", "L.AC.REINVESTED",CUS.POS) ;*R22 Manual Code Conversion_Utility Check
    Y.ACCOUNT = R.AC<AC.LOCAL.REF,CUS.POS>

***SI LA VARIABLE Y.ACCOUNT NO ES IGUAL A YES ENTONCES MUESTRAME EL SIGUIENTE MENSAJE, DE LO CONTRARIO CONTINUA
    IF Y.ACCOUNT NE "YES" THEN

        CALL STORE.END.ERROR
        ENQ.ERROR = "Los Registros No Concuerdan Con La Seleccion"
        ENQ.ERROR<1,2> = 1

    END

RETURN

END
