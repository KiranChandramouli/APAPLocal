$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION

*26-06-2023       S.AJITHKUMAR               R22 Manual Code Conversion       T24.BP IS REMOVED.SM to@SM,FM to @FM,VMto @VM,Command this Insert file I_F.T24.FUND.SERVICES
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.NOTIFICACION.CREDIT
*--------------------------------------------------------------------------------
*DESCRIPTION       :Rutina para generar mensaje de error cuando la cuenta tiene
*                   notificacion de PREVELAC
*DESARROLLO        :APAP
*in the FUNDS.TRANSFER
*----------------------------------------------------------------------------------
    $INSERT  I_COMMON ;*R22 maNUAL CODE CONVERSION
    $INSERT  I_EQUATE
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.TELLER ;*R22 maNUAL CODE CONVERSION
*   $INSERT  I_F.T24.FUND.SERVICES ;*R22 maNUAL CODE CONVERSION
    $INSERT  I_F.USER
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.EB.LOOKUP ;*R22 maNUAL CODE CONVERSION

    GOSUB TABLAS
    GOSUB GET.VALIDATE.DEBIT.ACC

RETURN
TABLAS:
    FN.ACCOUNT = 'F.ACCOUNT'
    FV.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,FV.ACCOUNT)

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP  = ''
    CALL OPF (FN.EB.LOOKUP,F.EB.LOOKUP)

    CALL GET.LOC.REF("ACCOUNT","L.AC.NOTIFY.1",L.AC.NOTIFY.1.POS)
RETURN


GET.VALIDATE.DEBIT.ACC:

    BEGIN CASE

        CASE ID.NEW[1,2] EQ "TT"
            Y.CREDIT.ACCT.NO = R.NEW(TT.TE.ACCOUNT.2)
        CASE ID.NEW[1,2] EQ "FT"
            Y.CREDIT.ACCT.NO = R.NEW(FT.CREDIT.ACCT.NO)
    END CASE
    CALL F.READ(FN.ACCOUNT,Y.CREDIT.ACCT.NO,R.ACCOUNT,FV.ACCOUNT,ERRO.ACCOUNT)
    Y.L.AC.NOTIFY.1 = R.ACCOUNT<AC.LOCAL.REF><1,L.AC.NOTIFY.1.POS>
    IF Y.L.AC.NOTIFY.1 NE '' THEN

        IF ID.NEW[1,2] EQ "FT" THEN
            AF =   FT.CREDIT.ACCT.NO
        END
        IF ID.NEW[1,2] EQ "TT" THEN
            AF =   TT.TE.ACCOUNT.2
        END
        GOSUB GET.NOTIFICACION
    END

RETURN

GET.NOTIFICACION:

    LOCATE "NOTIFY.MGMT.MONEY.LAUNDRY.PREV" IN Y.L.AC.NOTIFY.1<1,1,1> SETTING NOTIFY.POS THEN
        ID.LOOKUP = "L.AC.NOTIFY.1*NOTIFY.MGMT.MONEY.LAUNDRY.PREV"
        CALL F.READ(FN.EB.LOOKUP,ID.LOOKUP,R.LOOKUP,F.EB.LOOKUP,ERROR.LOOKUP)
        Y.DESCRIPTION =  R.LOOKUP<EB.LU.DESCRIPTION>
        Y.DESCRIPTION = CHANGE(Y.DESCRIPTION,@SM,@FM)
        Y.DESCRIPTION = CHANGE(Y.DESCRIPTION,@VM,@FM)
        Y.DESCRIPTION = Y.DESCRIPTION<1>
        MESSAGE = "La cuenta tiene bloqueo de: ":Y.DESCRIPTION
        E = MESSAGE
        ETEXT = E
        CALL ERR

        RETURN

    END ELSE
        LOCATE "NO.CR.XPREVELAC" IN Y.L.AC.NOTIFY.1<1,1,1> SETTING NOTIFY.POS THEN
            Y.PREVELAC = "YES"
            ID.LOOKUP = "L.AC.NOTIFY.1*NO.CR.XPREVELAC"
            CALL F.READ(FN.EB.LOOKUP,ID.LOOKUP,R.LOOKUP,F.EB.LOOKUP,ERROR.LOOKUP)
            Y.DESCRIPTION =  R.LOOKUP<EB.LU.DESCRIPTION>
            Y.DESCRIPTION = CHANGE(Y.DESCRIPTION,@SM,@FM)
            Y.DESCRIPTION = CHANGE(Y.DESCRIPTION,@VM,@FM)
            Y.DESCRIPTION = Y.DESCRIPTION<1>
            MESSAGE = "La cuenta tiene bloqueo de: ":Y.DESCRIPTION
            E = MESSAGE
            ETEXT = E
            CALL ERR
            RETURN
        END
    END

RETURN

END
