* @ValidationCode : Mjo5MTE2MjQ5NDQ6Q3AxMjUyOjE2ODIzMzU5NDU4MjI6SVRTUzotMTotMTo1OTk6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 599
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                BP REMOVED
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------------------
SUBROUTINE LAPAP.ACTUAL.STATUS.ACC
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER ;* AUTO R22 CODE CONVERSION END
   $USING EB.LocalReferences

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

    FN.TELLENAU = "F.TELLER$NAU"
    FV.TELLENAU = ""
    CALL OPF (FN.TELLENAU,FV.TELLENAU)

    FN.ACCOUNT = "F.ACCOUNT"
    FV.ACCOUNT = ""
    CALL OPF(FN.ACCOUNT, FV.ACCOUNT)

    CALL F.READ(FN.DAT,Y.TT.TNX, R.DAT, FV.DAT, DAT.ERR)
    Y.OVERRIDE = R.DAT<TT.TE.OVERRIDE>
    Y.ACC.ID   = R.DAT<TT.TE.ACCOUNT.1>

    IF NOT (R.DAT) THEN
        CALL F.READ(FN.TELLENAU,Y.TT.TNX, R.DAT, FV.TELLENAU, DAT.ERR)
        Y.OVERRIDE = R.DAT<TT.TE.OVERRIDE>
        Y.ACC.ID   = R.DAT<TT.TE.ACCOUNT.1>
    END

    R.DAT = ""
    DAT.ERR = ""
    CALL F.READ(FN.ACCOUNT, Y.ACC.ID, R.ACCOUNT, FV.ACCOUNT, DAT.ERR)
*    CALL GET.LOC.REF("ACCOUNT","L.AC.STATUS1", Y.L.AC.STATUS1.POS)
EB.LocalReferences.GetLocRef("ACCOUNT","L.AC.STATUS1", Y.L.AC.STATUS1.POS);* R22 UTILITY AUTO CONVERSION
    COMI = R.ACCOUNT<AC.LOCAL.REF, Y.L.AC.STATUS1.POS>

RETURN

END
