SUBROUTINE L.APAP.ACCT.CLOSURE(ENQ.DATA)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT


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
    CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",CUS.POS)
    Y.ACCOUNT = R.AC<AC.LOCAL.REF,CUS.POS>

***SI LA VARIABLE Y.ACCOUNT NO ES IGUAL A YES ENTONCES MUESTRAME EL SIGUIENTE MENSAJE, DE LO CONTRARIO CONTINUA
    IF Y.ACCOUNT NE "YES" THEN

        CALL STORE.END.ERROR
        ENQ.ERROR = "Los Registros No Concuerdan Con La Seleccion"
        ENQ.ERROR<1,2> = 1

    END

RETURN

END
