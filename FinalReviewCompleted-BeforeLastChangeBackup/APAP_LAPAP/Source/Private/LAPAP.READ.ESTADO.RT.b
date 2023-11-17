* @ValidationCode : MjotNTYyNTI1MjAyOkNwMTI1MjoxNjg0MjIyODE0MzEyOklUU1M6LTE6LTE6NzYyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 762
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

SUBROUTINE LAPAP.READ.ESTADO.RT
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO             REFERENCE                DESCRIPTION

* 21-APR-2023   Conversion tool     R22 Auto conversion     BP is removed in Insert File
* 21-APR-2023    Narmadha V        R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON ;*R22 Auto conversion - END

    FN.ES = "../bnk.interface/ESTADO"
    FV.ES = ""
    R.ES = ""
    ES.ERR = ""
    CALL OPF(FN.ES,FV.ES)
    Y.DUMMY = O.DATA
    REC.ID = O.DATA ;*'18604038771246603'        ;*HOLD ID

    CALL F.READ(FN.ES, REC.ID, R.ES, FV.ES, ES.ERR)

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

*IF A EQ 60 OR A EQ 119 OR A EQ 178 OR A EQ 237 OR A EQ 296 OR A EQ 355 OR A EQ 414 OR A EQ 473 THEN
*SALTO A SIGUIENTE PAGINA TRANSACCIONAL
*    A += 59
*END

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
                Y.TXN := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : "@"
            END
            IF Y.TXN.COUNT GE 28 AND Y.TXN.COUNT LE 58 THEN
                Y.TXN.2 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : "@"
            END
            IF Y.TXN.COUNT GE 59 AND Y.TXN.COUNT LE 89 THEN
                Y.TXN.3 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : "@"
            END
            IF Y.TXN.COUNT GE 90 AND Y.TXN.COUNT LE 120 THEN
                Y.TXN.4 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : "@"
            END
            IF Y.TXN.COUNT GE 121 AND Y.TXN.COUNT LE 151 THEN
                Y.TXN.5 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : "@"
            END
            IF Y.TXN.COUNT GE 152 AND Y.TXN.COUNT LE 182 THEN
                Y.TXN.6 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : "@"
            END
            IF Y.TXN.COUNT GE 183 AND Y.TXN.COUNT LE 213 THEN
                Y.TXN.7 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : "@"
            END
            IF Y.TXN.COUNT GE 214 AND Y.TXN.COUNT LE 244 THEN
                Y.TXN.8 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : "@"
            END
            IF Y.TXN.COUNT GE 245 AND Y.TXN.COUNT LE 275 THEN
                Y.TXN.9 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : "@"
            END
            IF Y.TXN.COUNT GE 276 AND Y.TXN.COUNT LE 306 THEN
                Y.TXN.10 := Y.FECHA.TXN : "|" : Y.REF.TXN : "|" : Y.DES.TXN : "|" : Y.DEB.TXN : "|" : Y.CRE.TXN : "|" : Y.BAL.TXN : "@"
            END
        NEXT A
        Y.LONGITUD.CADENA = LEN(Y.TXN)
        Y.TXN = Y.TXN[1,(Y.LONGITUD.CADENA-1)]
        Y.DES.CATEGORIA = TRIM(V.ARRAY<7>)
        Y.CUENTA.HABIENTE = TRIM(V.ARRAY<11>[1,40])
        Y.DIRECCION = TRIM(V.ARRAY<13>[1,45])
        Y.NUMERO.CUENTA = TRIM(V.ARRAY<12>[1,60])
        Y.PERIODO.1 = TRIM(V.ARRAY<11>[70,10])
        Y.PERIODO.2 = TRIM(V.ARRAY<12>[69,11])
        Y.CORTE = TRIM(V.ARRAY<12>[81,10])
*DEBUG
    END

    ELSE
        CRT "NOT FOUND"
    END

*DEBUG
    O.DATA = Y.TOTAL.CREDITOS : "*" : Y.TOTAL.DEBITOS : "*" : Y.BALANCE.INICIO : "*" : Y.BALANCE.INICIO : "*" : Y.BALANCE.FINAL : "*" : Y.DES.CATEGORIA : "*"
    O.DATA := Y.CUENTA.HABIENTE : "*" : Y.DIRECCION : "*" : Y.DIRECCION : "*" :  Y.NUMERO.CUENTA : "*" : Y.PERIODO.1 : "*" : Y.PERIODO.2 : "*" : Y.CORTE : "*"
    O.DATA := Y.TXN : "*" : Y.TXN.2 : "*" : Y.TXN.3 : "*" : Y.TXN.4 : "*" : Y.TXN.5 : "*" : Y.TXN.6 : "*" : Y.TXN.7 : "*" : Y.TXN.8 : "*" : Y.TXN.9 : "*" : Y.TXN.10

END
