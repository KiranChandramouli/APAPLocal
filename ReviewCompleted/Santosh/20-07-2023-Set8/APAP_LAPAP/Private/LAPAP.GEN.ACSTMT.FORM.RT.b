* @ValidationCode : MjotNjgwNzMxMjg0OkNwMTI1MjoxNjg5MjQzNzMxNjk4OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 15:52:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
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
* <Rating>1150</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.GEN.ACSTMT.FORM.RT(HOLD.ID)

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 20-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts 

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ST.LAPAP.CONTROL.ESTADOS
    $INSERT I_F.ST.LAPAP.EC.CATEGORIA
    $INSERT I_LAPAP.GEN.ACSTMT.FORM.RT.COMMON

INI:
    REC.ID = HOLD.ID

    CALL F.READ(FN.CE, REC.ID, R.CE, F.CE, CE.ERR)
    IF R.CE NE '' THEN
        Y.ACCOUNT.ID = R.CE<ST.LAPCE.ACCOUNT.NO>
        CALL F.READ(FN.ACCOUNT, Y.ACCOUNT.ID, R.AC, F.ACCOUNT, AC.ERR)
        IF R.AC NE '' THEN
            Y.CAT = R.AC<AC.CATEGORY>
            Y.CUS = R.AC<AC.CUSTOMER>
            CALL F.READ(FN.CUS,Y.CUS,R.CUS,F.CUS,CUS.ERR)
            Y.EMAIL = R.CUS<EB.CUS.EMAIL.1>
            CALL F.READ(FN.CAT, "SYSTEM", R.CAT, F.CAT, CAT.ERR)
            Y.CATEGORIAS = R.CAT<1>
            CHANGE @VM TO @FM IN Y.CATEGORIAS
            LOCATE Y.CAT IN Y.CATEGORIAS SETTING POS THEN
                Y.INDICADOR = R.CAT<2,POS>
                IF Y.INDICADOR EQ 'SI' THEN
                    GOSUB PROCESO
                END
            END
        END
    END

RETURN



PROCESO:
    CALL F.READ(FN.ES, REC.ID, R.ES, FV.ES, ES.ERR)
    IF R.ES THEN
        V.ARRAY = R.ES
        FINDSTR 'Total de Creditos' IN V.ARRAY SETTING V.FLD, V.VAL THEN
            CRT "Total de Creditos is in field: " : V.FLD, "value: ": V.VAL
            Y.TOTAL.CREDITOS = TRIM(FIELD(V.ARRAY<V.FLD>,':',2))
            Y.TOTAL.DEBITOS = TRIM(FIELD(V.ARRAY<(V.FLD + 1)>,':',2))
            Y.BALANCES.I.F = TRIM(V.ARRAY<(V.FLD + 4)>)
            Y.BALANCE.INICIO = FIELD(Y.BALANCES.I.F,' ',1,1)
            Y.BALANCE.FINAL = FIELD(Y.BALANCES.I.F,' ',2,1)

            Y.FIRST.FM.TXN = 20
            Y.LAST.FM.TXN = (V.FLD - 2)
            Y.TXN = ''
            Y.TXN.2 = ''
            Y.TXN.3 = ''
            Y.TXN.4 = ''
            Y.TXN.5 = ''
            Y.TXN.6 = ''
            Y.TXN.7 = ''
            Y.TXN.8 = ''
            Y.TXN.9 = ''
            Y.TXN.10 = ''
            Y.TXN.COUNT = 0
            FOR A = Y.FIRST.FM.TXN TO Y.LAST.FM.TXN STEP 1
                Y.CURR.TXN = V.ARRAY<A>
                Y.FECHA.ANO = Y.CURR.TXN[7,4]
                IF Y.FECHA.ANO GE 2018 AND Y.FECHA.ANO LE 2100 THEN
                    Y.TXN.COUNT += 1
                END ELSE
                    CONTINUE
                END

                Y.FECHA.TXN = TRIM(Y.CURR.TXN[1,10])
                Y.REF.TXN = TRIM(Y.CURR.TXN[12,12])
                Y.DES.TXN = TRIM(Y.CURR.TXN[25,29])
                Y.DEB.TXN = TRIM(Y.CURR.TXN[55,9])
                Y.CRE.TXN = TRIM(Y.CURR.TXN[67,9])
                Y.BAL.TXN = TRIM(Y.CURR.TXN[81,9])
                IF Y.TXN.COUNT LE 27 THEN
                    Y.TXN := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : @FM
                END
                IF Y.TXN.COUNT GE 28 AND Y.TXN.COUNT LE 58 THEN
                    Y.TXN.2 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : @FM
                END
                IF Y.TXN.COUNT GE 59 AND Y.TXN.COUNT LE 89 THEN
                    Y.TXN.3 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : @FM
                END
                IF Y.TXN.COUNT GE 90 AND Y.TXN.COUNT LE 120 THEN
                    Y.TXN.4 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : @FM
                END
                IF Y.TXN.COUNT GE 121 AND Y.TXN.COUNT LE 151 THEN
                    Y.TXN.5 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : @FM
                END
                IF Y.TXN.COUNT GE 152 AND Y.TXN.COUNT LE 182 THEN
                    Y.TXN.6 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : @FM
                END
                IF Y.TXN.COUNT GE 183 AND Y.TXN.COUNT LE 213 THEN
                    Y.TXN.7 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : @FM
                END
                IF Y.TXN.COUNT GE 214 AND Y.TXN.COUNT LE 244 THEN
                    Y.TXN.8 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : @FM
                END
                IF Y.TXN.COUNT GE 245 AND Y.TXN.COUNT LE 275 THEN
                    Y.TXN.9 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : @FM
                END
                IF Y.TXN.COUNT GE 276 AND Y.TXN.COUNT LE 306 THEN
                    Y.TXN.10 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : @FM
                END
            NEXT A
            Y.TODAS.TXN = Y.TXN : Y.TXN.2 : Y.TXN.3 : Y.TXN.4 : Y.TXN.5 : Y.TXN.6 : Y.TXN.7 : Y.TXN.8 : Y.TXN.9 : Y.TXN.10
            Y.LONGITUD.CADENA = LEN(Y.TODAS.TXN)
            Y.TODAS.TXN = Y.TODAS.TXN[1,(Y.LONGITUD.CADENA-1)]
            Y.DES.CATEGORIA = TRIM(V.ARRAY<7>)
            Y.CUENTA.HABIENTE = TRIM(V.ARRAY<11>[1,40])
            Y.DIRECCION = TRIM(V.ARRAY<13>[1,45])
            Y.NUMERO.CUENTA = TRIM(V.ARRAY<12>[1,60])
            Y.PERIODO.1 = TRIM(V.ARRAY<11>[70,10])
            Y.PERIODO.2 = TRIM(V.ARRAY<12>[69,11])
            Y.CORTE = TRIM(V.ARRAY<12>[81,10])

        END

        ELSE
            CALL OCOMO("NO HAY DATA, REVISAR HOLD " : REC.ID)
        END

        Y.DIR.NAME = "../interface/ESTADOS.OUT"
        Y.FILE.NAME = Y.ACCOUNT.ID:"-":TODAY:".EDC"

        OPENSEQ Y.DIR.NAME,Y.FILE.NAME TO FV.PTR ELSE
            CREATE FV.PTR ELSE
                CRT "CANNOT OPEN DIR ": Y.DIR.NAME
                STOP
            END

        END

        Y.FINAL = Y.DES.CATEGORIA:"|" : Y.CUENTA.HABIENTE:"|":Y.CORTE:"|":Y.NUMERO.CUENTA:"|":Y.PERIODO.1:"|":Y.PERIODO.2:"|":Y.DIRECCION:"|": Y.EMAIL :"|ENVIAR"
        WRITESEQ Y.FINAL TO FV.PTR ELSE
            CALL OCOMO("NO SE PUDO ESCRIBIR " : Y.FILE.NAME)
        END

        Y.FINAL = Y.BALANCE.INICIO:"|" : Y.BALANCE.FINAL:"|":Y.TOTAL.DEBITOS:"|":Y.TOTAL.CREDITOS
        WRITESEQ Y.FINAL TO FV.PTR ELSE
            CALL OCOMO("NO SE PUDO ESCRIBIR " : Y.FILE.NAME)
        END

        Y.QNT.1 = DCOUNT(Y.TODAS.TXN,@FM)
        FOR A = 1 TO Y.QNT.1 STEP 1
            Y.FINAL = Y.TODAS.TXN<A>
            WRITESEQ Y.FINAL TO FV.PTR ELSE
                CALL OCOMO("NO SE PUDO ESCRIBIR " : Y.FILE.NAME)
            END
        NEXT A
    END
RETURN

END
