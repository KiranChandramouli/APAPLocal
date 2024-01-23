* @ValidationCode : MjoyMDEwMDkzODA3OkNwMTI1MjoxNzA0NzgxOTMyMDM0OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 12:02:12
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BLD.REINV.ACC(ENQ.DATA)

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Sudharsanan S
* Program Name : REDO.BLD.REINV.ACC
*---------------------------------------------------------
* Description : This build routine is used to get the customer id value based on L.FT.AZ.ACC.REF value
*----------------------------------------------------------
* Linked With :
* In Parameter : None
* Out Parameter : None
*----------------------------------------------------------
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*18/01/2024         Suresh                 R22 UTILITY AUTO CONVERSION   CALL routine Modified
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $USING EB.LocalReferences

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

*    CALL GET.LOC.REF('FUNDS.TRANSFER','L.FT.AZ.ACC.REF',LOC.REF.POS)
    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER','L.FT.AZ.ACC.REF',LOC.REF.POS);* R22 UTILITY AUTO CONVERSION

    Y.AZ.ACC.REF = R.NEW(FT.LOCAL.REF)<1,LOC.REF.POS>

    CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ACC.REF,R.AZ.ACC,F.AZ.ACCOUNT,AZ.ERR)

    VAR.CUSTOMER = R.AZ.ACC<AZ.CUSTOMER>

    ENQ.DATA<2,1> = 'CUSTOMER'
    ENQ.DATA<3,1> = 'EQ'
    ENQ.DATA<4,1> = VAR.CUSTOMER

RETURN

END
