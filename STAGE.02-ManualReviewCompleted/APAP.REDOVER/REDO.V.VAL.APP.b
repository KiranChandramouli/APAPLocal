* @ValidationCode : MjotMTg0NDY2OTUzNDpDcDEyNTI6MTY4MTM3MjY4NTg0MDpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 13:28:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.APP
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.APP
*---------------------------------------------------------------------------------

*DESCRIPTION      :It is attached as valildation routine to the field ALL.IN.ONE.PRODUCT
*                  in the versions AZ.ACCOUNT,REDO.SIN.PROCESS and AZ.ACCOUNT,REDO.MULTI.PROCESS
*
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date              who           Reference                       Description
* 14-JUN-2010       Prabhu.N       ODR-2009-10-0315               Initial Creation
*13-04-2023       Conversion Tool  R22 Auto Code conversion          No Changes
*13-04-2023       Samaran T        R22 Manual Code Conversion        No Changes
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER

    VAR.AZ.PRODUCT.ID=COMI

    LREF.FIELD.APP ='L.AP.ABB.DEPO'
    LREF.APPLICATION.APP='AZ.PRODUCT.PARAMETER'
    LREF.POS.APP=''
    CALL MULTI.GET.LOC.REF(LREF.APPLICATION.APP,LREF.FIELD.APP,LREF.POS.APP)

    LREF.APPLICATION.AZ='AZ.ACCOUNT'
    LREF.FIELD.AZ='L.AZ.DEP.NAME'
    LREF.POS.AZ=''
    CALL MULTI.GET.LOC.REF(LREF.APPLICATION.AZ,LREF.FIELD.AZ,LREF.POS.AZ)

    FN.AZ.PRODUCT.PARAMETER='F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAMETER=''
    CALL OPF(FN.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER)

    CALL F.READ(FN.AZ.PRODUCT.PARAMETER,VAR.AZ.PRODUCT.ID,R.AZ.PRODUCT,F.AZ.PRODUCT.PARAMETER,ERR)
    R.NEW(AZ.LOCAL.REF)<1,LREF.POS.AZ>=R.AZ.PRODUCT<AZ.APP.LOCAL.REF><1,LREF.POS.APP>
RETURN
END
