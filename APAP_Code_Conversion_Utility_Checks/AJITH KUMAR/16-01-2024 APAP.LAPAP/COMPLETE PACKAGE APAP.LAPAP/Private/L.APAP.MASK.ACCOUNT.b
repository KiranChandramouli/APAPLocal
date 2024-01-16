$PACKAGE APAP.LAPAP
*-------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>597</Rating>
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*19/10/2023         Suresh                 R22 Manual Conversion          T24.BP FILE REMOVED
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.MASK.ACCOUNT(AMT.LCY)
*-------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Ftrinidad
*Date              :03 Agosto 2023
*Program   Name    :L.APAP.MASK.ACCOUNT
*-------------------------------------------------------------------------------
*DESCRIPTION       : Esta rutina ofusca la cuenta regional y la cuenta contable
*                  : con los siguientes formatos XXXX********************XXXX y
*                  : ******XXXX respectivamente
*-------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Manual Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER ;*R22 Manual Conversion - End
   $USING EB.LocalReferences

    Y.IS.ACC = 0
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-------
PROCESS:
*-------
    BEGIN CASE

        CASE AMT.LCY EQ 'DEBIT.ACCT.NO'
            Y.IS.ACC = 1
            GOSUB GET.ACCOUNT
            AMT.LCY = FMT(Y.ACC,"16R")

        CASE AMT.LCY EQ 'ACCOUNT'
            Y.IS.ACC = 1
            GOSUB GET.ACCOUNT
            AMT.LCY = FMT(Y.ACC,"20R")

            RETURN

        CASE AMT.LCY EQ 'ACCOUNT.1'
            Y.IS.ACC = 1
            GOSUB GET.ACCOUNT
            AMT.LCY = FMT(Y.ACC,"18R")

            RETURN

        CASE AMT.LCY EQ 'ACCOUNT.2'
            Y.IS.ACC = 1
            GOSUB GET.ACCOUNT
            AMT.LCY = FMT(Y.ACC,"21R")

            RETURN

        CASE AMT.LCY EQ 'ACCOUNT.3'
            Y.IS.ACC = 1
            GOSUB GET.ACCOUNT
            AMT.LCY = FMT(Y.ACC,"16L")

            RETURN

        CASE AMT.LCY EQ 'ACCOUNT.4'
            Y.IS.ACC = 1
            GOSUB GET.ACCOUNT
            AMT.LCY = FMT(Y.ACC,"18R")

            RETURN
        CASE AMT.LCY EQ 'ACCOUNT.5'
            Y.IS.ACC = 1
            GOSUB GET.ACCOUNT
            AMT.LCY = FMT(Y.ACC,"16R")

        CASE AMT.LCY EQ 'ACCOUNT.6'
            Y.IS.ACC = 1
            GOSUB GET.ACCOUNT
            AMT.LCY = FMT(Y.ACC,"16R")

        CASE AMT.LCY EQ 'L.AC.ALPH.AC.NO'
            Y.IS.ACC = 0
            GOSUB GET.ACC.REG
            AMT.LCY = FMT(Y.ACC,"30R")

            RETURN

        CASE AMT.LCY EQ 'L.AC.ALPH.AC.NO.2'
            Y.IS.ACC = 0
            GOSUB GET.ACC.REG
            AMT.LCY = FMT(Y.ACC,"28R")
            RETURN

        CASE AMT.LCY EQ 'L.AC.ALPH.AC.NO.3'
            Y.IS.ACC = 0
            GOSUB GET.ACC.REG
            AMT.LCY = FMT(Y.ACC,"28R")

            RETURN

        CASE AMT.LCY EQ 'L.AC.ALPH.AC.NO.4'
            Y.IS.ACC = 0
            GOSUB GET.ACC.REG
            AMT.LCY = FMT(Y.ACC,"28R")

            RETURN

        CASE AMT.LCY EQ 'L.AC.ALPH.AC.NO.5'
            Y.IS.ACC = 0
            GOSUB GET.ACC.REG
            AMT.LCY = FMT(Y.ACC,"28L")

        CASE AMT.LCY EQ 'L.AC.ALPH.AC.NO.6'
            Y.IS.ACC = 0
            GOSUB GET.ACC.REG
            AMT.LCY = FMT(Y.ACC,"28L")

            RETURN

*--Cta Regulatoria Cierre de Cuenta
        CASE AMT.LCY EQ 'L.TT.AZ.ACC.REF'
            Y.IS.ACC = 1
            GOSUB GET.ACCT.TITLE
            GOSUB SET.MASK.ACC
            AMT.LCY = FMT(Y.ACC,"24R")
            RETURN

*--Cta Regulatoria Cierre de Cuenta
        CASE AMT.LCY EQ 'Y.ACCT.REGULARORY'
            Y.IS.ACC = 0
            GOSUB GET.ACCT.REGULATORY
            AMT.LCY = FMT(Y.ACC,"30R")

            RETURN

    END CASE

RETURN

*-----------
GET.ACCOUNT:
*-----------
    GOSUB GET.DATA.ACC
    GOSUB SET.MASK.ACC
RETURN

*-----------
GET.ACC.REG:
*-----------
    GOSUB GET.DATA.ACC
    GOSUB OPEN.FILE

    Y.CUENTA = VAR.ACC
    CALL F.READ (FN.ACCOUNT,Y.CUENTA,R.ACCOUNT,FV.ACCOUNT,ERROR.ACCOUNT)
    VAR.ACC =  R.ACCOUNT<AC.LOCAL.REF,L.AC.ALPH.AC.NO.POS>

    GOSUB SET.MASK.ACC

RETURN

*---------
OPEN.FILE:
*---------
    FN.ACCOUNT = 'F.ACCOUNT'
    FV.ACCOUNT = '';
    CALL OPF (FN.ACCOUNT,FV.ACCOUNT)
    L.AC.ALPH.AC.NO.POS = '';
*    CALL GET.LOC.REF("ACCOUNT","L.AC.ALPH.AC.NO",L.AC.ALPH.AC.NO.POS)
EB.LocalReferences.GetLocRef("ACCOUNT","L.AC.ALPH.AC.NO",L.AC.ALPH.AC.NO.POS);* R22 UTILITY AUTO CONVERSION
RETURN

*------------
GET.DATA.ACC:
*------------
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        VAR.ACC = R.NEW(FT.DEBIT.ACCT.NO)
    END ELSE
        IF AMT.LCY EQ 'ACCOUNT.1' OR AMT.LCY EQ 'ACCOUNT.5' OR AMT.LCY EQ 'L.AC.ALPH.AC.NO.3' THEN
            VAR.ACC = R.NEW(TT.TE.ACCOUNT.1)
        END ELSE
            IF Y.DR.CR.MARKER EQ "DEBIT" THEN
                VAR.ACC = R.NEW(TT.TE.ACCOUNT.2)
                RETURN
            END

*            CALL GET.LOC.REF('TELLER','L.ACTUAL.VERSIO',Y.FIELD.POS)
EB.LocalReferences.GetLocRef('TELLER','L.ACTUAL.VERSIO',Y.FIELD.POS);* R22 UTILITY AUTO CONVERSION
            Y.VERSION = R.NEW(TT.TE.LOCAL.REF)<1,Y.FIELD.POS>

            IF Y.VERSION EQ 'TELLER,REDO.FCY.CASHCHQ' OR Y.VERSION EQ 'TELLER,REDO.FCY.CASHCHQ.FIM' THEN
                VAR.ACC = R.NEW(TT.TE.ACCOUNT.2)
            END ELSE
                IF Y.VERSION EQ 'TELLER,REDO.LCY.FCY.CASHCHQ' OR Y.VERSION EQ 'TELLER,REDO.LCY.FCY.CASHCHQ.FIM' THEN
                    IF AMT.LCY EQ 'ACCOUNT.3' THEN
                        VAR.ACC = R.NEW(TT.TE.ACCOUNT.1)
                        RETURN
                    END

                    IF AMT.LCY EQ 'L.AC.ALPH.AC.NO.4' OR AMT.LCY EQ 'ACCOUNT' OR AMT.LCY EQ 'L.AC.ALPH.AC.NO' THEN
                        VAR.ACC = R.NEW(TT.TE.ACCOUNT.2)
                        RETURN
                    END
                END

                IF Y.DR.CR.MARKER EQ "CREDIT" THEN
                    IF Y.CCY.1 EQ LCCY THEN
                        VAR.ACC = R.NEW(TT.TE.ACCOUNT.2)
                    END ELSE
                        VAR.ACC = R.NEW(TT.TE.ACCOUNT.1)
                    END
                END
            END
        END
    END
RETURN

*------------
SET.MASK.ACC:
*------------
    Y.CUENTA.REGIONAL =''; Y.LONGITUD = 0; Y.MASCARA = ''; Y.LOGINTUD2 = ''
    Y.VALOR.INICIAR = ''

*--Valido para que si es una cuenta interna la devuelva sin Ofuscar
    IF Y.IS.ACC THEN
        IF NOT (NUM(SUBSTRINGS(TRIM(VAR.ACC),0,1))) THEN
            Y.ACC = TRIM(VAR.ACC)
            RETURN
        END
    END

    Y.CUENTA.REGIONAL = TRIM(VAR.ACC)
    Y.LONGITUD = LEN(Y.CUENTA.REGIONAL)

    IF Y.IS.ACC THEN
        Y.VALOR.MEDIO = Y.CUENTA.REGIONAL[1,(Y.LONGITUD-4)]
        Y.VALOR.FINAL = Y.CUENTA.REGIONAL[(Y.LONGITUD - 3),Y.LONGITUD]
    END ELSE
        Y.VALOR.INICIAR = Y.CUENTA.REGIONAL[1,4]
        Y.LONGITUD2 = Y.CUENTA.REGIONAL[5,(Y.LONGITUD-4)]
        Y.VALOR.MEDIO = Y.CUENTA.REGIONAL[5,LEN(Y.LONGITUD2)-4]
        Y.VALOR.FINAL = Y.CUENTA.REGIONAL[(Y.LONGITUD - 3 ),Y.LONGITUD]
    END

    FOR I =  1 TO LEN(Y.VALOR.MEDIO)
        Y.MASK:= "*"
    NEXT I

    Y.ACC = Y.VALOR.INICIAR : Y.MASK : Y.VALOR.FINAL
RETURN

*-------------------
GET.ACCT.REGULATORY:
*-------------------

    GOSUB GET.ACCT.TITLE

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LOC.REF.FIELD = 'L.AC.ALPH.AC.NO'
    LOC.REF.APP = 'ACCOUNT'
    LOC.POS = ''
*    CALL GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,L.AC.ALPH.AC.NO.POS)
EB.LocalReferences.GetLocRef(LOC.REF.APP,LOC.REF.FIELD,L.AC.ALPH.AC.NO.POS);* R22 UTILITY AUTO CONVERSION

    CALL F.READ(FN.ACCOUNT,VAR.ACC,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

    IF ACCOUNT.ERR NE '' THEN
        FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
        F.ACCOUNT.HIS = ''
        CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)

        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIS,VAR.ACC,R.ACCOUNT,ACC.ERR)
    END

    Y.ACCT.REF= R.ACCOUNT<AC.LOCAL.REF,L.AC.ALPH.AC.NO.POS>
    VAR.ACC = Y.ACCT.REF

    GOSUB SET.MASK.ACC

RETURN

*--------------
GET.ACCT.TITLE:
*--------------
    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

*    CALL GET.LOC.REF('TELLER','L.TT.AZ.ACC.REF',L.TT.AZ.ACC.REF.POS)
EB.LocalReferences.GetLocRef('TELLER','L.TT.AZ.ACC.REF',L.TT.AZ.ACC.REF.POS);* R22 UTILITY AUTO CONVERSION
    VAR.ACC = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.AZ.ACC.REF.POS>
RETURN

*----
INIT:
*----
    Y.CCY.1        = ""
    Y.DR.CR.MARKER = ""

    IF APPLICATION EQ "TELLER" THEN
        Y.CCY.1  = R.NEW(TT.TE.CURRENCY.1)
    END

    Y.DR.CR.MARKER   = R.NEW(TT.TE.DR.CR.MARKER)

RETURN
END
