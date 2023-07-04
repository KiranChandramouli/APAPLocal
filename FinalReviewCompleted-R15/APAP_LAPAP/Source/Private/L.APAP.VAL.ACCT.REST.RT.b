* @ValidationCode : MjoyMDUwNjE4OTM3OkNwMTI1MjoxNjgyMzM1OTQ0NjA5OklUU1M6LTE6LTE6LTM6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -3
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 BP REMOVED
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.ACCT.REST.RT
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT ;* AUTO R22 CODE CONVERSION END
    FN.AC = "F.ACCOUNT"
    F.AC = ""

    P.ACCOUNT.ID = COMI
*CALL F.READ(FN.AC, P.ACCOUNT.ID, R.AC, F.AC, '')

*CALL GET.LOC.REF("ACCOUNT", "L.AC.STATUS",AC.POS)
*Y.ACCOUNT.STATUS = R.AC<AC.LOCAL.REF,AC.POS>
    T.CANTIDAD.CARACTERES = LEN(P.ACCOUNT.ID )
    IF (T.CANTIDAD.CARACTERES NE 10) THEN

        TEXT = "NUMERO CUENTA INVALIDO "
        E = TEXT
    END
RETURN
END
