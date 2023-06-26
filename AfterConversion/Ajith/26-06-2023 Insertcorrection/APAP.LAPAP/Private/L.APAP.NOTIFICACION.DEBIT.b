$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*26-06-2023       Conversion Tool           R22 Auto Code conversion          No Changes
*26-06-2023       S.AJITHKUMAR               R22 Manual Code Conversion       T24.BP IS REMOVED , SM , VM FM to @SM,@FM,@VM,Command this Insert file I_F.T24.FUND.SERVICES
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.NOTIFICACION.DEBIT
*--------------------------------------------------------------------------------
*DESCRIPTION       :Rutina para generar mensaje de error cuando la cuenta tiene
*                   notificacion de PREVELAC
*DESARROLLO        :APAP
*in the FUNDS.TRANSFER
*----------------------------------------------------------------------------------
    $INSERT  I_COMMON ;*R22 manual code conversion
    $INSERT I_EQUATE
    $INSERT  I_F.FUNDS.TRANSFER ;*R22 manual code conversion
    $INSERT  I_F.TELLER
* $INSERT  I_F.T24.FUND.SERVICES ;*R22 manual code conversion
    $INSERT  I_F.USER
    $INSERT  I_F.ACCOUNT ;*R22 manual code conversion
    $INSERT  I_F.EB.LOOKUP ;*R22 manual code conversion

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
    Y.DEBIT.ACCT.NO = R.NEW(FT.DEBIT.ACCT.NO)
    AF = FT.DEBIT.ACCT.NO
    CALL F.READ(FN.ACCOUNT,Y.DEBIT.ACCT.NO,R.ACCOUNT,FV.ACCOUNT,ERRO.ACCOUNT)
    Y.L.AC.NOTIFY.1 = R.ACCOUNT<AC.LOCAL.REF><1,L.AC.NOTIFY.1.POS>
    IF Y.L.AC.NOTIFY.1 NE '' THEN
        GOSUB GET.NOTIFICACION
    END

RETURN

GET.NOTIFICACION:

    LOCATE "NOTIFY.MGMT.MONEY.LAUNDRY.PREV" IN Y.L.AC.NOTIFY.1<1,1,1> SETTING NOTIFY.POS THEN

        Y.PREVELAC = "YES"
        ID.LOOKUP = "L.AC.NOTIFY.1*NOTIFY.MGMT.MONEY.LAUNDRY.PREV"

        CALL F.READ(FN.EB.LOOKUP,ID.LOOKUP,R.LOOKUP,F.EB.LOOKUP,ERROR.LOOKUP)
        Y.DESCRIPTION =  R.LOOKUP<EB.LU.DESCRIPTION>
        Y.DESCRIPTION = CHANGE(Y.DESCRIPTION,@SM,@FM)
        Y.DESCRIPTION = CHANGE(Y.DESCRIPTION,@VM,@FM) ;*R22 manual code conversion
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
            Y.DESCRIPTION = CHANGE(Y.DESCRIPTION,@VM,@FM) ;*R22 manual code conversion
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
