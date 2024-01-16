* @ValidationCode : Mjo1ODIwNDUyODg6Q3AxMjUyOjE2ODQyMjI4MTI3NDU6SVRTUzotMTotMToyMDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.MON.SALDO.HIS

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO                REFERENCE            DESCRIPTION

* 21-APR-2023   Conversion tool       R22 Auto conversion    BP is removed in Insert File
* 21-APR-2023    Narmadha V           R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT ;*R22 Auto conversion - END
   $USING EB.LocalReferences

    FN.ACC = "F.ACCOUNT$HIS"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)

    ID = COMI
    CALL F.READ.HISTORY(FN.ACC,ID,R.HIS,F.ACC,ERRH)
*    CALL GET.LOC.REF("ACCOUNT","L.AC.AV.BAL",POS)
EB.LocalReferences.GetLocRef("ACCOUNT","L.AC.AV.BAL",POS);* R22 UTILITY AUTO CONVERSION
    SALDO = R.HIS<AC.LOCAL.REF,POS>
    COMI = SALDO

RETURN

END
