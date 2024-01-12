* @ValidationCode : MjotNDY1MDU2MDUyOkNwMTI1MjoxNzA0NDQ1ODU1NTQwOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 14:40:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
*Modification history
*Date                Who               Reference                  Description
*18-04-2023      conversion tool     R22 Auto code conversion     No changes
*18-04-2023      Mohanraj R          R22 Manual code conversion   No changes
SUBROUTINE REDO.V.VAL.ACCOUNT.CATEGORY
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.REINV.APP.CHECK
*--------------------------------------------------------------------------------
* Description: This Validation routine is to Populate the value ALLOWED.CATEGORY of AZ.PRODUCT.PARMAETER in ACCOUNT appln.
*
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
* DATE WHO REFERENCE DESCRIPTION
* 22-Jul-2011 Bharath G PACS00085750 INITIAL CREATION
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $USING EB.LocalReferences


    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.AZ.PRODUCT.PARAMETER = 'F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAMETER=''
    CALL OPF(FN.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER)

    LOC.REF.APPLICATION="AZ.PRODUCT.PARAMETER"
    LOC.REF.FIELDS='L.AZ.RE.INV.CAT'
    LOC.REF.POS=''
*    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    EB.LocalReferences.GetLocRef(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS);* R22 UTILITY AUTO CONVERSION
    POS.L.AZ.RE.INV.CAT = LOC.REF.POS<1,1>


RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    Y.APP.ID = COMI
    CALL CACHE.READ(FN.AZ.PRODUCT.PARAMETER,Y.APP.ID,R.APP,APP.ERR)

    Y.REINV.CATEG = R.APP<AZ.APP.ALLOWED.CATEG>

    R.NEW(AC.CATEGORY) = Y.REINV.CATEG

RETURN
END
