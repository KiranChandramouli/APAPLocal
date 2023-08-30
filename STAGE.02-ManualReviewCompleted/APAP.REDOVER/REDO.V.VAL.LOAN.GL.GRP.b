* @ValidationCode : MjotMTE4MjEyNzc2NzpDcDEyNTI6MTY4MTcyOTMwNDQxNzpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Apr 2023 16:31:44
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
SUBROUTINE REDO.V.VAL.LOAN.GL.GRP
*-----------------------------------------------------------------------------
*Company Name: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program Name: REDO.V.VAL.LOAN.GL.GRP
*---------------------------------------------------------------------------------
* DESCRIPTION:
*---------------------------------------------------------------------------------
*            This routine is a validation routine to populate the value from field
* PRODUCT.GROUP in AA.PRODUCT to the local field L.AA.LOAN.GL.GRP and
* attached to the version AA.ARRANGEMENT.ACTIVITY,AA.NEW
*----------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 26-06-2010      SUJITHA.S   ODR-2009-10-0326 N.3  INITIAL CREATION
*
*----------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                     F.READ TO CACHE.READ
*17-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*---------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PRODUCT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_AA.LOCAL.COMMON

    GOSUB INIT
    GOSUB OPEN
    GOSUB PROCESS
RETURN

*------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------

    FN.AA.PRODUCT="F.AA.PRODUCT"
    F.AA.PRODUCT=''
    Y.PRODUCTID=R.NEW(AA.ARR.ACT.PRODUCT)
RETURN

*-------------------------------------------------------------------------------
OPEN:
*-------------------------------------------------------------------------------

    CALL OPF(FN.AA.PRODUCT,F.AA.PRODUCT)
    CALL CACHE.READ(FN.AA.PRODUCT, Y.PRODUCTID, R.AA.PRODUCT, Y.ERR)     ;*R22 AUTO CODE CONVERSION
*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    COMI=R.AA.PRODUCT<AA.PDT.PRODUCT.GROUP>

RETURN
END
