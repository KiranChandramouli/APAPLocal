* @ValidationCode : MjotMTc3NjczMjU0MjpDcDEyNTI6MTY4MjMzMTMyMTc3MDpJVFNTOi0xOi0xOjEyNzE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1271
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ENQ.CHEQUES.AGENCIA.CAJA(Y.FINAL)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       F.READ to CACHE.READ, = to EQ
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.DATES
   $USING EB.LocalReferences

*PARA ABRIR EL ACHIVO DE TELLER.TRANSACTION
    FN.TET = "F.TELLER.TRANSACTION"
    FV.TET = ""
    CALL OPF(FN.TET, FV.TET)

*PARA ABRIR EL ACHIVO DE CUSTOMER
    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""
    CALL OPF(FN.CUS, FV.CUS)

*PARA ABRIR EL ACHIVO DE DATES
    FN.DAT = "F.DATES"
    FV.DAT = ""
    CALL OPF(FN.DAT, FV.DAT)

    R.TT = ""
    TT.ERR = ""

    R.FT = ""
    FT.ERR = ""

    R.TET = ""
    TET.ERR = ""

    R.CUS = ""
    CUS.ERR = ""

    R.DAT = ""
    DAT.ERR = ""

    SEL.LIST = ""
    NO.OF.REC = ""
    SEL.ERR = ""

* SENTENCIA LOCATE
    LOCATE "AGENCY" IN D.FIELDS<1> SETTING CUS.POS THEN
        P.AGENCIA = D.RANGE.AND.VALUE<CUS.POS>
    END

    LOCATE "DATE" IN D.FIELDS<1> SETTING CUS.POS THEN
        P.FECHA = D.RANGE.AND.VALUE<CUS.POS>
    END

    LOCATE "TELLER.ID" IN D.FIELDS<1> SETTING CUS.POS THEN
        P.CAJA = D.RANGE.AND.VALUE<CUS.POS>
    END

*VALIDAMOS SI DESEAN CONSULTAR EL LIVE O EL HISTORICO
*    CALL CACHE.READ(FN.DAT, 'DO0010001', R.DAT, DAT.ERR)
IDVAR.1 = 'DO0010001' ;* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.DAT, IDVAR.1, R.DAT, DAT.ERR);* R22 UTILITY AUTO CONVERSION
    Y.DATE = R.DAT<EB.DAT.TODAY>

    FN.TT = ""
    FV.TT = ""
    FN.FT = ""
    FV.FT = ""
    Y.SUF.HIST = ""

    IF Y.DATE EQ P.FECHA THEN
        FN.TT = "F.TELLER"
        FN.FT = "F.FUNDS.TRANSFER"
    END ELSE
        FN.TT = "F.TELLER$HIS"
        FN.FT = "F.FUNDS.TRANSFER$HIS"
        Y.SUF.HIST = ";1"
    END

*PARA ABRIR EL ACHIVO DE FUNDS.TRANSFER
    CALL OPF(FN.FT, FV.FT)

*PARA ABRIR EL ACHIVO DE TELLER
    CALL OPF(FN.TT, FV.TT)

* FORMAMOS EL COMANDO A EJECUTAR
    SEL.CMD = "SELECT " : FN.TT : " WITH TRANSACTION.CODE EQ '8' '9' '27' '39' '41' '69' '96' '137' '181' '428' '432' '435' '444' '445' '447'"

    IF P.AGENCIA THEN
        SEL.CMD = SEL.CMD : " AND CO.CODE EQ " : P.AGENCIA
    END

    IF P.FECHA THEN
        SEL.CMD = SEL.CMD : " AND VALUE.DATE.1 EQ " : P.FECHA
    END

    IF P.CAJA THEN
        SEL.CMD = SEL.CMD : " AND TELLER.ID.1 EQ " : P.CAJA
    END

    SEL.CMD = SEL.CMD : " BY TELLER.ID.1 BY CURRENCY.1"


* REALIZAMOS LA LLAMADA
    CALL EB.READLIST(SEL.CMD, SEL.LIST,"", NO.OF.REC, SEL.ERR)

    LOOP
        REMOVE Y.TT.ID FROM SEL.LIST SETTING TT.POS

    WHILE Y.TT.ID DO

        CALL F.READ(FN.TT,Y.TT.ID,R.TT, FV.TT, TT.ERR)

        Y.FECHA = R.TT<TT.TE.VALUE.DATE.1>
        Y.CAJA = R.TT<TT.TE.TELLER.ID.1>
        Y.AGENCIA = R.TT<TT.TE.CO.CODE>
        Y.TXN.CODE = R.TT<TT.TE.TRANSACTION.CODE>
        Y.MONTO = R.TT<TT.TE.AMOUNT.LOCAL.1>
        Y.INPUTTER = FIELD(R.TT<TT.TE.INPUTTER>,"_",2)
        Y.CUST.2 = R.TT<TT.TE.CUSTOMER.2>
        Y.CUST.1 = R.TT<TT.TE.CUSTOMER.1>
        Y.CTA.1 = R.TT<TT.TE.ACCOUNT.1>
        Y.STATUS = R.TT<TT.TE.RECORD.STATUS>
        Y.CURRENCY = R.TT<TT.TE.CURRENCY.1>

        CALL CACHE.READ(FN.TET, Y.TXN.CODE, R.TET, TET.ERR)
        Y.TYPE.DESC = R.TET<TT.TR.DESC>

        Y.CLIENTE.F = ""
        Y.CTA.F = ""
        Y.CNT_CHQ.F = ""

*Numero de cuenta para la mayoria de las transacciones
        Y.CTA.F = R.TT<TT.TE.ACCOUNT.2>

*Cantidad de cheques para la mayoria de las transacciones
        Y.POS = ""
*        CALL GET.LOC.REF("TELLER","L.TT.NO.OF.CHQ",Y.POS)
EB.LocalReferences.GetLocRef("TELLER","L.TT.NO.OF.CHQ",Y.POS);* R22 UTILITY AUTO CONVERSION
        Y.CNT_CHQ.F = R.TT<TT.TE.LOCAL.REF,Y.POS>

*Nombre del cliente para la mayorma de las transacciones
        Y.POS = ""
*        CALL GET.LOC.REF("TELLER","L.TT.CLIENT.NME",Y.POS)
EB.LocalReferences.GetLocRef("TELLER","L.TT.CLIENT.NME",Y.POS);* R22 UTILITY AUTO CONVERSION
        Y.CLIENTE.F = R.TT<TT.TE.LOCAL.REF,Y.POS>

*En este campo se guarda el FT para las transacciones 96
        Y.POS = ""
*        CALL GET.LOC.REF("TELLER","L.INITIAL.ID",Y.POS)
EB.LocalReferences.GetLocRef("TELLER","L.INITIAL.ID",Y.POS);* R22 UTILITY AUTO CONVERSION
        Y.INITIAL.ID = R.TT<TT.TE.LOCAL.REF,Y.POS>

        BEGIN CASE

            CASE Y.TXN.CODE EQ '181'
*Transacciones de prestamos
                Y.CTA.F = R.TT<TT.TE.NARRATIVE.1>

                Y.POS = ""
*                CALL GET.LOC.REF("TELLER","CERT.CHEQUE.NO",Y.POS)
EB.LocalReferences.GetLocRef("TELLER","CERT.CHEQUE.NO",Y.POS);* R22 UTILITY AUTO CONVERSION
                Y.CNT_CHQ.F = R.TT<TT.TE.LOCAL.REF,Y.POS>
            CASE Y.TXN.CODE EQ '432' OR Y.TXN.CODE EQ '435'
*Transacciones de tarjetas de credito
                Y.POS = ""
*                CALL GET.LOC.REF("TELLER","L.TT.CR.CARD.NO",Y.POS)
EB.LocalReferences.GetLocRef("TELLER","L.TT.CR.CARD.NO",Y.POS);* R22 UTILITY AUTO CONVERSION
                Y.CTA.F = R.TT<TT.TE.LOCAL.REF,Y.POS>
            CASE Y.TXN.CODE EQ '39' OR Y.TXN.CODE EQ '66' OR Y.TXN.CODE EQ '69' OR Y.TXN.CODE EQ '444' OR Y.TXN.CODE EQ '445'
                Y.POS = ""
*                CALL GET.LOC.REF("TELLER","L.TT.LEGAL.ID",Y.POS)
EB.LocalReferences.GetLocRef("TELLER","L.TT.LEGAL.ID",Y.POS);* R22 UTILITY AUTO CONVERSION
                Y.CLIENTE.F = R.TT<TT.TE.LOCAL.REF,Y.POS>
            CASE Y.TXN.CODE EQ '96'
                Y.INITIAL.ID = Y.INITIAL.ID : Y.SUF.HIST
                CALL F.READ(FN.FT,Y.INITIAL.ID,R.FT, FV.FT, FT.ERR)
                Y.CTA.INT = R.FT<FT.CREDIT.ACCT.NO>
                Y.CUST.2 = R.FT<FT.ORDERING.CUST>

                IF Y.CTA.INT THEN
                    Y.CTA.F = Y.CTA.INT
                END

            CASE Y.TXN.CODE EQ '137'
                Y.POS = ""
*                CALL GET.LOC.REF("TELLER","L.TT.CONCEPT",Y.POS)
EB.LocalReferences.GetLocRef("TELLER","L.TT.CONCEPT",Y.POS);* R22 UTILITY AUTO CONVERSION
                Y.CLIENTE.F = R.TT<TT.TE.LOCAL.REF,Y.POS>
        END CASE

        IF Y.TXN.CODE EQ '41' OR Y.TXN.CODE EQ '96' THEN
            IF Y.CUST.2 THEN
                CALL F.READ(FN.CUS,Y.CUST.2,R.CUS, FV.CUS, CUS.ERR)
                Y.CLIENTE.F = R.CUS<EB.CUS.NAME.1>
            END

            IF Y.CUST.2 EQ "" AND Y.CUST.1 NE "" THEN
                CALL F.READ(FN.CUS,Y.CUST.1,R.CUS, FV.CUS, CUS.ERR)
                Y.CLIENTE.F = R.CUS<EB.CUS.NAME.1>
            END

            IF Y.CTA.1 THEN
                Y.CTA.F = Y.CTA.1
            END
        END

        IF Y.CURRENCY NE 'DOP' THEN
            Y.MONTO = R.TT<TT.TE.AMOUNT.FCY.1>
        END

        IF Y.STATUS EQ "REVE" THEN
            Y.MONTO = "-" : Y.MONTO
        END

        Y.FINAL<-1> = Y.TT.ID:"|":Y.FECHA:"|":Y.CAJA:"|":Y.AGENCIA:"|":Y.TXN.CODE:"|":Y.TYPE.DESC:"|":Y.MONTO:"|":Y.CNT_CHQ.F:"|":Y.CTA.F:"|":Y.CLIENTE.F:"|":Y.INPUTTER:"|":Y.CURRENCY

    REPEAT

END
