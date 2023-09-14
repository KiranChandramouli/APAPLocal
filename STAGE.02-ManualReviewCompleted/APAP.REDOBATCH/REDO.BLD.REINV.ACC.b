* @ValidationCode : MjotNDczMjA4NzQzOkNwMTI1MjoxNjgxNzEwNTExNTI0OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 11:18:31
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
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    CALL GET.LOC.REF('FUNDS.TRANSFER','L.FT.AZ.ACC.REF',LOC.REF.POS)

    Y.AZ.ACC.REF = R.NEW(FT.LOCAL.REF)<1,LOC.REF.POS>

    CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ACC.REF,R.AZ.ACC,F.AZ.ACCOUNT,AZ.ERR)

    VAR.CUSTOMER = R.AZ.ACC<AZ.CUSTOMER>

    ENQ.DATA<2,1> = 'CUSTOMER'
    ENQ.DATA<3,1> = 'EQ'
    ENQ.DATA<4,1> = VAR.CUSTOMER

RETURN

END
