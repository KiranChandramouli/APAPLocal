* @ValidationCode : MjoxNDQ4ODY0NDQwOkNwMTI1MjoxNjgzNTI4NTMzNDc4OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 May 2023 12:18:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS
SUBROUTINE AI.REDO.V.BEN.EMAIL
*-----------------------------------------------------------------------------
* This subroutine will validate a field containing an e-mail address.
*-----------------------------------------------------------------------------
*       Revision History
*
*       First Release:  February 8th
*       Developed for:  APAP
*       Developed by:   Martin Macias - Temenos - MartinMacias@temenos.com
*
* 10-APR-2023     Conversion tool   R22 Auto conversion      VM to @VM
* 10-APR-2023     Conversion tool    R22 Auto conversion      CALL routine format modified
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY

    GOSUB VALIDA
RETURN

*---------
VALIDA:
*---------

    LOC.REF.APPLICATION="BENEFICIARY"
    LOC.REF.FIELDS='L.BEN.EMAIL':@VM
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.BEN.EMAIL = LOC.REF.POS<1,1>
    Y.EMAIL = R.NEW(ARC.BEN.LOCAL.REF)<1,POS.L.BEN.EMAIL>

    IF LEN(Y.EMAIL) EQ 0 THEN
        RETURN
    END

    AF = ARC.BEN.LOCAL.REF
    AV = LOC.REF.POS<1,1>

*CALL APAP.REDOCHNLS.AI.REDO.V.EMAIL(Y.EMAIL) ;*Manual R22 conversion
    CALL APAP.REDOCHNLS.aiRedoVEmail(Y.EMAIL) ;*Manual R22 conversion
RETURN

END
