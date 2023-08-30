* @ValidationCode : MjoxNDIwNDYxNjc4OkNwMTI1MjoxNjgyMDcwMzA2Njk0OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:15:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.INACTIVE.STATUS.ACCOUNT
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE           WHO                    REFERENCE           DESCRIPTION

* 21-APR-2023   Conversion tool       R22 Auto conversion      BP is removed in Insert File
* 21-APR-2023    Narmadha V           R22 Manual Conversion    No Changes

*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER ;*R22 Auto conversion - END

*-----------------------------------------------------------------------------------
*-----------CONSULTAMOS EL PENULTIMO REGISTRO DEL HIS DE LA TABLA ACCOUNT-----------
*-----------------------------------------------------------------------------------

*OBTENEMOS EL NUMERO DE TT
    Y.TT.TNX = COMI
    Y.RESULT = ""


*CONSULTA DEL LIVE
    FN.DAT = "F.TELLER"
    FV.DAT = ""
    CALL OPF(FN.DAT, FV.DAT)
    R.DAT = ""
    DAT.ERR = ""

    CALL F.READ(FN.DAT,Y.TT.TNX, R.DAT, FV.DAT, DAT.ERR)
    Y.OVERRIDE = R.DAT<TT.TE.OVERRIDE>
    Y.ACC.ID   = R.DAT<TT.TE.ACCOUNT.2>

    FINDSTR "REDO.AC.CHECK.ACTIVE" IN Y.OVERRIDE SETTING F.P, V.P THEN

*CONSULTA DEL HIS
        FN.AC.HIS = 'F.ACCOUNT$HIS'
        F.AC.HIS = ""
        HIST.REC = ""
        YERROR = ""

        CALL OPF(FN.AC.HIS,F.AC.HIS)
        CALL EB.READ.HISTORY.REC(F.AC.HIS, Y.ACC.ID, HIST.REC, YERROR)

        CALL GET.LOC.REF("ACCOUNT", "L.AC.STATUS1", Y.L.AC.STATUS1.POS)
        Y.RESULT = HIST.REC<AC.LOCAL.REF, Y.L.AC.STATUS1.POS>

    END ELSE

        FN.DAT = "F.ACCOUNT"
        FV.DAT = ""
        CALL OPF(FN.DAT, FV.DAT)
        R.DAT = ""
        DAT.ERR = ""

        CALL F.READ(FN.DAT, Y.ACC.ID, R.DAT, FV.DAT, DAT.ERR)

        CALL GET.LOC.REF("ACCOUNT","L.AC.STATUS1", Y.L.AC.STATUS1.POS)

        Y.RESULT = R.DAT<AC.LOCAL.REF, Y.L.AC.STATUS1.POS>

    END

    COMI = Y.RESULT

RETURN

END
