* @ValidationCode : MjotMTkyNzQ4MjM5MjpDcDEyNTI6MTY5MTU2NjI5MDYzMTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Aug 2023 13:01:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

SUBROUTINE LAPAP.BLD.CC.RNC.RT(ENQ.DATA)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 09-AUG-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY

    GOSUB INITIALISE
    GOSUB PROCESS
    GOSUB PGM.END

RETURN

INITIALISE:
    FN.CUSTOMER.RNC = 'F.CUSTOMER.L.CU.RNC'
    F.CUSTOMER.RNC = ''
    CALL OPF(FN.CUSTOMER.RNC,F.CUSTOMER.RNC)

RETURN

PROCESS:

    Y.FLD = ENQ.DATA<2,1>
    Y.ID = ENQ.DATA<4,1>
    CALL F.READ(FN.CUSTOMER.RNC,Y.ID,R.CUSTOMER.RNC,F.CUSTOMER.RNC,ERR)

    IF R.CUSTOMER.RNC AND Y.FLD EQ 'L.CU.RNC' ELSE
*Si llego aca es que no existe el registro
        ENQ.ERROR = 'EB-INVALID.RNC'
        CALL STORE.END.ERROR

        RETURN
*----------------------------------------------------------
PGM.END:
*----------------------------------------------------------
    END
