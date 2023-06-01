* @ValidationCode : MjoxNjQ0Njk0MzA0OkNwMTI1MjoxNjgyNDEyMzQ4Mjc0OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.CHECK.FT.BENEFICARY

*---------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Riyas
* PROGRAM NAME: REDO.V.INP.CHECK.FT.BENEFICARY
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION: This routine is to make mandatory Beneficary field

*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER & FT

*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE        WHO                REFERENCE           DESCRIPTION
* 26.02.2013  Riyas              ODR-2009-12-0285    INITIAL CREATION
*Modification history
*Date                Who               Reference                  Description
*13-04-2023      conversion tool     R22 Auto code conversion     SM TO @SM,FM TO @FM
*13-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER


    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
******

    LREF.APP   = 'FUNDS.TRANSFER'
    LREF.FIELD = 'BENEFIC.NAME'
    LREF.POS   = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    BENEFICIARY.POS = LREF.POS

RETURN

PROCESS:
*********

    Y.BENE = R.NEW(FT.LOCAL.REF)<1,BENEFICIARY.POS>
    CHANGE @SM TO @FM IN Y.BENE

    IF NOT(Y.BENE<1>) THEN
        AF = FT.LOCAL.REF
        AV = BENEFICIARY.POS
        AS = 1
        ETEXT = "AC-MAND.FLD"
        CALL STORE.END.ERROR
    END

RETURN
*----------------------------------------------------------------------------------------------------------------------
END
