* @ValidationCode : MjozMjEwMDUwNTk6Q3AxMjUyOjE2ODIzMzU5NDMzODg6SVRTUzotMTotMTo1MTk6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 519
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                = TO EQ , F.READ TO CACHE.READ
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*---------------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.TELLERLIMIT.VS.TOTTXN(Y.FINAL)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER.ID
    $INSERT I_F.DATES

*PARA ABRIR EL ARCHIVO DE TELLER
    FN.TABLE = ""
    FT.TT = ""
    RS.TT = ""
    ERR.TT = ""
    Y.POS = ""
    Y.HIS.SUF = ""

*PARA ABRIR EL ACHIVO DE DATES
    FN.DAT = "F.DATES"
    FV.DAT = ""
    CALL OPF(FN.DAT, FV.DAT)
    R.DAT = ""
    DAT.ERR = ""

*ARRAY PARA ALMACENAR LOS MESES
    MONTHS     = ""
    MONTHS<01> = "JAN"
    MONTHS<02> = "FEB"
    MONTHS<03> = "MAR"
    MONTHS<04> = "APR"
    MONTHS<05> = "MAY"
    MONTHS<06> = "JUN"
    MONTHS<07> = "JUL"
    MONTHS<08> = "AUG"
    MONTHS<09> = "SEP"
    MONTHS<10> = "OCT"
    MONTHS<11> = "NOV"
    MONTHS<12> = "DEC"

*PARA EJECUTAR QUERY
    SEL.LIST = ""
    NO.OF.REC = ""
    SEL.ERR = ""

*OBTENEMOS LOS CAMPOS ENVIADOS DESDE EL SS
    LOCATE "AGENCY" IN D.FIELDS<1> SETTING CUS.POS THEN
        TELLER.AGENCIA = D.RANGE.AND.VALUE<CUS.POS>
    END

    LOCATE "DATE" IN D.FIELDS<1> SETTING CUS.POS THEN
        TELLER.FECHA = D.RANGE.AND.VALUE<CUS.POS>
    END

    LOCATE "TELLER.ID" IN D.FIELDS<1> SETTING CUS.POS THEN
        TELLER.ID = D.RANGE.AND.VALUE<CUS.POS>
    END
*FIN

*VALIDAMOS SI DESEAN CONSULTAR EL LIVE O EL HISTORICO

    CALL CACHE.READ(FN.DAT, 'DO0010001', R.DAT, DAT.ERR) ;*AUTO R22 CODE CONVERSION F.READ TO CACHE.READ
    Y.DATE = R.DAT<EB.DAT.TODAY>

    IF Y.DATE EQ TELLER.FECHA THEN ;*AUTO R22 CODE CONVERSION = TO EQ
        FN.TABLE = "F.TELLER.ID"
    END ELSE
        FN.TABLE = "F.TELLER.ID$HIS"
        Y.HIS.SUF = ";1"
    END
*FIN

*PARA ABRIR EL ACHIVO DE TELLER
    CALL OPF(FN.TABLE, FT.TT)

* FORMAMOS EL QUERY A EJECUTAR
    SEL.CMD = "SELECT " : FN.TABLE : " "
    SEL.AND = "WITH"

    IF TELLER.FECHA THEN

        Y.YEAR  = TELLER.FECHA[1,4]
        Y.MONTH = EREPLACE (TELLER.FECHA[5,2], TELLER.FECHA[5,2], MONTHS<TELLER.FECHA[5,2]>)
        Y.DAY   = TELLER.FECHA[7,2]

        TELLER.FECHA = Y.DAY :" ": Y.MONTH :" ": Y.YEAR

        SEL.CMD = SEL.CMD : SEL.AND :" DATE.OF.OPEN EQ '" : TELLER.FECHA : "' "

        SEL.AND = "AND"

    END

    IF TELLER.AGENCIA THEN

        SEL.CMD = SEL.CMD : SEL.AND : " CO.CODE EQ " : TELLER.AGENCIA : " "
        SEL.AND = "AND"
    END

    IF TELLER.ID THEN
        SEL.CMD = SEL.CMD : SEL.AND : " TELLER.ID LIKE " : TELLER.ID : "..."
    END

    SEL.CMD = SEL.CMD : " AND L.TT.USER.TYPE EQ 'TELLER' BY CO.CODE"

* EGECUTAMOS LA CONSULTA A LA TABLA DE TELLER

    CALL EB.READLIST(SEL.CMD, SEL.LIST,"", NO.OF.REC, SEL.ERR)

    LOOP
        REMOVE Y.TT.ID FROM SEL.LIST SETTING TT.POS

    WHILE Y.TT.ID DO

        CALL F.READ(FN.TABLE, Y.TT.ID, RS.TT, FT.TT, ERR.TT)

*SUCURSAL
        VAL.NO1  = RS.TT<TT.TID.CO.CODE>

*OBTENIENDO LOS LIMITES DE LA CAJA DESDE UN CAMPO LOCAL
        CALL GET.LOC.REF("TELLER.ID","L.TT.TILL.LIM",Y.LIM)

*OBTENIENDO LAS MODENAS DE LOS LIMITES DE LA CAJA DESDE UN CAMPO LOCAL
        CALL GET.LOC.REF("TELLER.ID","L.TT.CURRENCY",Y.LIM.CURRENCY)

*OBTENIENDO LAS CATEGORIAS DE LOS LIMITES DE LA CAJA DESDE UN CAMPO LOCAL
        CALL GET.LOC.REF("TELLER.ID","L.CI.CATEG.CARD",Y.LIM.CATEG)

*LIMITES ASIGNADO EN CAJA DOP, USD Y EUR

        VAL.NO2 = '*0.00'
        VAL.NO3 = '*0.00'
        VAL.NO4 = '*0.00'

        FOR A = 1 TO 4 STEP 1

            Y.LIMIT = RS.TT<TT.TID.LOCAL.REF,Y.LIM, A>
            Y.CATEG = RS.TT<TT.TID.LOCAL.REF,Y.LIM.CATEG, A>
            Y.CURRENCY = RS.TT<TT.TID.LOCAL.REF,Y.LIM.CURRENCY, A>

            IF Y.CATEG EQ '10001' AND Y.CURRENCY EQ 'DOP' THEN
                VAL.NO2 = '*' : Y.LIMIT
            END

            IF Y.CURRENCY EQ 'USD' THEN
                VAL.NO3 = '*' : Y.LIMIT
            END

            IF Y.CURRENCY EQ 'EUR' THEN
                VAL.NO4 = '*' : Y.LIMIT
            END

        NEXT A

*MONTOS DE CIERRE EN CAJA DOP, USD Y EUR
        VAL.NO5 = '*0.00'
        VAL.NO6 = '*0.00'
        VAL.NO7 = '*0.00'

        Y.CANT.RECS = DCOUNT(RS.TT<TT.TID.CURRENCY>,@VM)

        FOR A = 1 TO Y.CANT.RECS STEP 1

            Y.LIMIT = RS.TT<TT.TID.TILL.CLOS.BAL, A>
            Y.CATEG = RS.TT<TT.TID.CATEGORY, A>
            Y.CURRENCY = RS.TT<TT.TID.CURRENCY, A>

            IF Y.CATEG EQ '10001' AND Y.CURRENCY EQ 'DOP' THEN
                VAL.NO5 = '*' : Y.LIMIT
            END

            IF Y.CURRENCY EQ 'USD' THEN
                VAL.NO6 = '*' : Y.LIMIT
            END

            IF Y.CURRENCY EQ 'EUR' THEN
                VAL.NO7 = '*' : Y.LIMIT
            END

        NEXT A


*FECHA DE APERTURA Y CIERRE DE CAJA
        VAL.NO8 = '*' : RS.TT<TT.TID.DATE.OF.OPEN> : " " : RS.TT<TT.TID.TIME.OF.OPEN>
        VAL.NO9 = '*' : RS.TT<TT.TID.DATE.OF.CLOSE> : " " : RS.TT<TT.TID.TIME.OF.CLOSE>

*NO. DE CAJERO
        VAL.NO10 = '*' : Y.TT.ID[1,4]

*NO. DE REGISTRO
        VAL.NO11 = '*' : RS.TT<TT.TID.CURR.NO>

        Y.FINAL<-1> = VAL.NO1 : VAL.NO2 : VAL.NO3 : VAL.NO4: VAL.NO5 : VAL.NO6 : VAL.NO7 : VAL.NO8 : VAL.NO9 : VAL.NO10 : VAL.NO11

    REPEAT

END
