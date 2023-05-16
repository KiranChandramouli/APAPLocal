$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.SRV.GEN.CTA.A.CNL.RT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    Y.DIR.NAME='../interface/T24CTSABAN'
    Y.FILE.NAME='CA02.env'
    Y.DIR.NAME.FINAL='../interface/T24CTSABAN'
    Y.FILE.NAME.FINAL='Cuentas.A.Cancelar.T24.csv'
    Y.DIR.NAME.FINAL.ER='../interface/T24CTSABAN'
    Y.FILE.NAME.FINAL.ER='Cuentas.A.Cancelar.T24.ERROR.csv'
    FN.AC = "F.ACCOUNT"
    F.AC = ""

    OPENSEQ Y.DIR.NAME,Y.FILE.NAME TO FV.PRT ELSE
        PRINT @(12,12): 'NO SE PUDO ABRIR EL DIRECTORIO'
    END

    OPENSEQ Y.DIR.NAME.FINAL,Y.FILE.NAME.FINAL TO FV.PTR.FIN ELSE
        CREATE FV.PTR.FIN ELSE
            PRINT @(12,12): "CANNOT OPEN DIR ": Y.DIR.NAME.FINAL
            STOP
        END
    END

    OPENSEQ Y.DIR.NAME.FINAL.ER,Y.FILE.NAME.FINAL.ER TO FV.PTR.FIN.ER ELSE
        CREATE FV.PTR.FIN.ER ELSE
            PRINT @(12,12): "CANNOT OPEN DIR ": Y.DIR.NAME.FINAL.ER
            STOP
        END
    END

**Y.EOF = 0
    LOOP
        READSEQ Y.REC FROM FV.PRT ELSE Y.EOF = 1
    WHILE NOT(Y.EOF)
**NUMERO CUENTA.
        Y.ACCOUNT.NO = ""
**NUMERO SUCURSAL.
        Y.ACCOUNT.COMPANY = ""
**CUENTA CONTABLE.
        Y.ACCOUNT.CO.ACCT = ""

**El numero de cuenta equivale a las 10 posiciones a partir de la posicion 165 del CA02.
        Y.ACCOUNT.NO = Y.REC[165,10]
**A partir del numero de cuento busco en la tabla FBNK.ACCOUNT.
        CALL F.READ(FN.AC, Y.ACCOUNT.NO, R.AC, F.AC, '')
**El codigo de la sucursal de la cuenta equivale al campo CO.CODE de la tabla FBNK.ACCOUNT.
        Y.ACCOUNT.COMPANY = R.AC<AC.CO.CODE>
        CALL GET.LOC.REF("ACCOUNT", "L.AC.STATUS",AC.POS)
        Y.ACCOUNT.STATUS = R.AC<AC.LOCAL.REF,AC.POS>
        Y.ACCOUNT.COMPANY.NO = Y.ACCOUNT.COMPANY[8,2]
        IF Y.ACCOUNT.COMPANY[8,2] EQ '17' THEN
            Y.ACCOUNT.COMPANY.NO = '01'
        END
        IF Y.ACCOUNT.COMPANY[8,2] EQ '01' THEN
            Y.ACCOUNT.COMPANY.NO = '17'
        END
**La cuenta contable equivale a DOP17615004000 + los 2 ultimos digitos del codigo de la sucursal.
**Y.ACCOUNT.CO.ACCT = "DOP17615004000" : Y.ACCOUNT.COMPANY.NO
        IF Y.ACCOUNT.COMPANY.NO EQ '17' THEN
*Y.ACCOUNT.CO.ACCT = "DOP17615000100" : Y.ACCOUNT.COMPANY.NO
            Y.ACCOUNT.CO.ACCT = "DOP1761500400017"
        END
        IF Y.ACCOUNT.COMPANY.NO NE '17' THEN
            Y.ACCOUNT.CO.ACCT = "DOP17615000400" : Y.ACCOUNT.COMPANY.NO
        END
**Solo procedo a escribir en el archivo en caso de que el estatus del CA02 sea igual a 'A'
**La posicion 245 equivale al estatus en el CA02
        Y.CA02.ESTATUS = Y.REC[245,1]
        IF Y.CA02.ESTATUS EQ 'A' THEN
            IF Y.ACCOUNT.COMPANY NE '' THEN
                Y.FINAL = Y.ACCOUNT.NO : "," : Y.ACCOUNT.COMPANY : "," : Y.ACCOUNT.CO.ACCT : ","
                IF (Y.ACCOUNT.STATUS NE "IM") THEN
                    Y.FINAL.ER = Y.ACCOUNT.NO : "," : Y.ACCOUNT.COMPANY : "," : Y.ACCOUNT.CO.ACCT : "," : Y.ACCOUNT.STATUS : ","
                    WRITESEQ Y.FINAL.ER TO FV.PTR.FIN.ER ELSE
                        PRINT @(12,12): "NO SE PUDO ESCRIBIR EN EL ARCHIVO"
                    END
                    CONTINUE
                END
                WRITESEQ Y.FINAL TO FV.PTR.FIN ELSE
                    PRINT @(12,12): "NO SE PUDO ESCRIBIR EN EL ARCHIVO"
                END
            END

        END

    REPEAT

    CLOSESEQ FV.PRT
    CLOSESEQ FV.PTR.FIN
    PRINT @(12,12): "ARCHIVO GENERADO."


END
