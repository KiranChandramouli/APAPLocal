* @ValidationCode : MjoyNTU5Njc2NTc6Q3AxMjUyOjE2ODIzMzU5NDUxMTI6SVRTUzotMTotMToyMDA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:25
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
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 BP REMOVED, VM TO @VM , FM TO @FM
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.INAC
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT ;* AUTO R22 CODE CONVERSION END
   $USING EB.LocalReferences


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


    VAR.ID =  R.NEW(AZ.NOMINATED.ACCOUNT)

    CALL F.READ(FN.ACCOUNT,VAR.ID,R.ACCOUNT,F.ACCOUNT,YERR)

*    CALL GET.LOC.REF("ACCOUNT","L.AC.STATUS1",ACC.POS)
EB.LocalReferences.GetLocRef("ACCOUNT","L.AC.STATUS1",ACC.POS);* R22 UTILITY AUTO CONVERSION

    VAR.AZ.STATUS = R.ACCOUNT<AC.LOCAL.REF,ACC.POS>

    IF VAR.AZ.STATUS EQ "3YINACTIVE" THEN

        TEXT='REDO.AC.CHECK.ACTIVE':@FM:VAR.ID:@VM:' INACTIVA 3 ANOS'

        CURR.NO=1

        CALL STORE.OVERRIDE(CURR.NO)

    END

RETURN

IF VAR.AZ.STATUS EQ "ABANDONED" THEN
    TEXT='REDO.AC.CHECK.ACTIVE':@FM:VAR.ID:@VM:' ABANDONADA'

    CURR.NO=1

    CALL STORE.OVERRIDE(CURR.NO)

END

RETURN

IF VAR.AZ.STATUS EQ "6MINACTIVE" THEN

    TEXT='REDO.AC.CHECK.ACTIVE':@FM:VAR.ID:@VM:' INACTIVIDAD INTERNA'

    CURR.NO=1

    CALL STORE.OVERRIDE(CURR.NO)

END

RETURN

END
