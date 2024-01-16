* @ValidationCode : Mjo0MzEwNDQxMDQ6Q3AxMjUyOjE2ODIzMzU5NDQ4NDU6SVRTUzotMTotMToyMDA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.AZ.FA
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
   $USING EB.LocalReferences

    VAR.ID  = ID.NEW

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    CALL F.READ(FN.AZ.ACCOUNT,VAR.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,YERR)

*    CALL GET.LOC.REF("AZ.ACCOUNT","L.AC.STATUS2",ACC.POS)
EB.LocalReferences.GetLocRef("AZ.ACCOUNT","L.AC.STATUS2",ACC.POS);* R22 UTILITY AUTO CONVERSION

    VAR.AZ.STATUS = R.AZ.ACCOUNT<AZ.LOCAL.REF,ACC.POS>

    FINDSTR "DECEASED" IN VAR.AZ.STATUS SETTING STATUS.POS,VALUE.POS THEN

        TEXT="L.APAP.AZ.FA"

        CURR.NO=1

        CALL STORE.OVERRIDE(CURR.NO)

    END

RETURN
