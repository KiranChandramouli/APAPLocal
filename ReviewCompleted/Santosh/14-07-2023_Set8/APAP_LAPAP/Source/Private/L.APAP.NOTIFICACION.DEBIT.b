* @ValidationCode : MjotMTA4MzM5MTQzOkNwMTI1MjoxNjg5MjQ2MjExMDUwOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 16:33:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.NOTIFICACION.DEBIT
*--------------------------------------------------------------------------------
*DESCRIPTION       :Rutina para generar mensaje de error cuando la cuenta tiene
*                   notificacion de PREVELAC
*DESARROLLO        :APAP
*in the FUNDS.TRANSFER
*----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       FM TO @FM, VM to @VM, SM to @SM, BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON                             ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.USER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.LOOKUP                       ;*R22 Auto conversion - End

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
