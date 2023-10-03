* @ValidationCode : MjotNDE4NDkzMjQzOkNwMTI1MjoxNjkxNzUxMzUwMzc2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Aug 2023 16:25:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.CONSULTAR.CATEGORY.DEPOSIT
 
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : LAPAP.CONSULTAR.CATEGORY.DEPOSIT

*--------------------------------------------------------------------------------
* Description: This validation routine is to look for the category linked to a category for reinvested deposit
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO                REFERENCE         DESCRIPTION
* 03-OCT-2022       Estalin Valerio                      INITIAL CREATION
*
*09/08/2023          Suresh       R22 Manual Conversion   T24.BP is removed, FM TO @FM, VM TO @VM
*----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Manual Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER ;*R22 Manual Conversion - End


    IF MESSAGE EQ '' THEN
        GOSUB INIT
        GOSUB PROCESS
        RETURN

    END

 
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.APP = 'F.AZ.PRODUCT.PARAMETER'
    F.APP = ''
    CALL OPF(FN.APP,F.APP)

    LOC.REF.APPLICATION="ACCOUNT":@FM:"AZ.PRODUCT.PARAMETER"
    LOC.REF.FIELDS='L.AZ.APP':@VM:'L.AC.AZ.ACC.REF':@VM:'L.AC.STATUS1':@FM:'L.AZ.RE.INV.CAT'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.L.AZ.RE.INV.CAT = LOC.REF.POS<2,1>

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    Y.APP.ID = COMI
    CALL CACHE.READ(FN.APP,Y.APP.ID,R.APP,APP.ERR)
    COMI = R.APP<AZ.APP.LOCAL.REF,POS.L.AZ.RE.INV.CAT>

RETURN

END
