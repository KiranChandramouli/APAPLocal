* @ValidationCode : Mjo3Nzc5MTY3NjI6Q3AxMjUyOjE2ODIzMzEzMjA0OTM6SVRTUzotMTotMTo1Njk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 569
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.COMPRA.PAS.ACT.POST

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       F.READ to CACHE,READ, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - start
    $INSERT I_EQUATE
    $INSERT I_F.DATES ;*R22 Auto conversion - end

    GOSUB GET.LOARD.TABLE
    GOSUB GET.CONTANTES.VAR
    GOSUB SET.ESCRITURA.FINAL
GET.LOARD.TABLE:
****************
    FN.DATES = 'F.DATES'
    FV.DATES = ''
    CALL OPF(FN.DATES,FV.DATES)
RETURN
GET.CONTANTES.VAR:
*******************
    GOSUB GET.FECHA.CORTE
    Y.DDMMYYYY = Y.FECHA.CORTE[7,2]:Y.FECHA.CORTE[5,2]:Y.FECHA.CORTE[1,4]
    Y.DIR.NAME = "../bnk.interface/REG.REPORTS"
    Y.FILE.NAME = "AR014" : Y.DDMMYYYY : ".TXT"
    Y.SAVE.NAME = 'F.TASA.AR014'
    Y.SAVE.DIR = '&SAVEDLISTS&'
RETURN
GET.FECHA.CORTE:
****************
    R.FECHAS = ''; ERR.FECHAS = ''
    CALL CACHE.READ(FN.DATES, 'DO0010001', R.FECHAS, ERR.FECHAS) ;*R22 Auto conversion
    Y.FECHA.CORTE = R.FECHAS<EB.DAT.LAST.WORKING.DAY>
RETURN
SET.ESCRITURA.FINAL:
**********************
    Y.SECUENCIA = 0
    DELETESEQ Y.DIR.NAME, Y.FILE.NAME ELSE NULL
    OPENSEQ Y.DIR.NAME,Y.FILE.NAME TO FV.PTR ELSE
        CREATE FV.PTR ELSE
            CRT "NO SE PUEDE ABRIR ARCHIVO: " : Y.FILE.NAME : " DEL DIRECTORIO: " : Y.DIR.NAME
            STOP
        END
    END
    EXECUTE "GET.LIST F.TASA.AR014"
    READLIST ID.LIST ELSE
        ID.LIST = ''
        STOP
    END
    LOOP
        REMOVE Y.ID.CADENA FROM ID.LIST SETTING Y.STATUS
    WHILE Y.ID.CADENA DO
        Y.SECUENCIA += 1
        CAMPO.VAL1 = FMT(Y.SECUENCIA,'L#25')
        Y.FINAL = CAMPO.VAL1 :"|":Y.ID.CADENA
        WRITESEQ Y.FINAL TO FV.PTR ELSE
            CRT "NO SE PRUEDE ESCRIBIR EL ARCHIVO: " : Y.FILE.NAME
        END
    REPEAT
    CLOSESEQ FV.PTR
    GOSUB DELETE.SAVELIST
RETURN
DELETE.SAVELIST:
****************
    DELETESEQ Y.SAVE.DIR, Y.SAVE.NAME ELSE NULL
RETURN
END
