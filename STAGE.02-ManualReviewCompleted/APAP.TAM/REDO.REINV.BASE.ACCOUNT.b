* @ValidationCode : MjotNjM2OTI0MjE1OkNwMTI1MjoxNjgxMzczNjIyMjU1OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 13:43:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.REINV.BASE.ACCOUNT

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.REINV.BASE.ACCOUNT
*--------------------------------------------------------------------------------
* Description: This Autom new content routine to default the values from previous version
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 04-Jul-2011     H GANESH    PACS00072695_N.11   INITIAL CREATION
*
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          FM TO @FM, VM TO @VM, IF CONDITION ADDED
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER

    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.AZ.PRODUCT.PARAMETER = 'F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAMETER=''
    CALL OPF(FN.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER)

    LOC.REF.APPLICATION="ACCOUNT"
    LOC.REF.FIELDS='L.AZ.APP':@VM:'L.AC.REINVESTED'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.L.AZ.APP = LOC.REF.POS<1,1>
    POS.L.AC.REINVESTED = LOC.REF.POS<1,2>

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------


    Y.CURRENT.REC = System.getVariable("CURRENT.REC")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION - START
        Y.CURRENT.REC = ""
    END ;*AUTO R22 CODE CONVERSION - END

    CHANGE '*##' TO @FM IN Y.CURRENT.REC
    MATPARSE R.NEW FROM Y.CURRENT.REC

    Y.APP.ID = R.NEW(AC.LOCAL.REF)<1,POS.L.AZ.APP>
    CALL CACHE.READ(FN.AZ.PRODUCT.PARAMETER,Y.APP.ID,R.APP,APP.ERR)
    Y.ALLOWED.CATEGORY = R.APP<AZ.APP.ALLOWED.CATEG>
    R.NEW(AC.CATEGORY) = Y.ALLOWED.CATEGORY
    R.NEW(AC.LOCAL.REF)<1,POS.L.AC.REINVESTED> = 'YES'

RETURN
END
