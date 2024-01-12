* @ValidationCode : MjoxMzQ3MDc2MzI1OkNwMTI1MjoxNzAzNjgwMjk3NTc4OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Dec 2023 18:01:37
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
SUBROUTINE REDO.V.AUT.AML.CCY
****************************************************************
*-------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : SUDHARSANAN S
* Program Name : REDO.V.AUT.AML.CCY
* ODR NUMBER : ODR-2009-10-0472
*-------------------------------------------------------------------------

* Description : This Auth routine is attached to the VERSION.CONTROL record of CURRENCY table
* It is used to update the field AMT.LIMIT.LCY in REDO.AML.PARAM table

* In parameter : None
* out parameter : None
*Modification history
*Date                Who               Reference                  Description
*11-04-2023      conversion tool     R22 Auto code conversion     No changes
*11-04-2023      Mohanraj R          R22 Manual code conversion   No changes
* 28-12-2023      AJITHKUMAR      R22 MANUAL CODE CONVERSION
*----------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CURRENCY
    $INSERT I_F.REDO.AML.PARAM
    $USING EB.LocalReferences

*
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------
*****
INIT:
*****
*
    FN.CURRENCY='F.CURRENCY'
    F.CURRENCY=''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

    FN.REDO.AML.PARAM='F.REDO.AML.PARAM'
    F.REDO.AML.PARAM=''
    CALL OPF(FN.REDO.AML.PARAM,F.REDO.AML.PARAM)

    LREF.APP='CURRENCY'
    LREF.FIELD='L.CU.AMLBUY.RT'
    LREF.POS=''
*CALL GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    EB.LocalReferences.GetLocRef(LREF.APP,LREF.FIELD,LREF.POS);*R22 MANUAL CODE CONVERSION

RETURN
*--------
PROCESS:
*--------
*Update the field AMT.LIMIT.LCY in REDO.AML.PARAM table
    Y.AML.RATE=R.NEW(EB.CUR.LOCAL.REF)<1,LREF.POS>
    Y.AML.ID='SYSTEM'
    CALL CACHE.READ(FN.REDO.AML.PARAM,Y.AML.ID,R.AML.PARAM,AML.ERR)
    Y.AML.CCY = R.AML.PARAM<AML.PARAM.AML.CCY>
    IF ID.NEW EQ Y.AML.CCY THEN
        Y.AMT.FCY=R.AML.PARAM<AML.PARAM.AMT.LIMIT.FCY>
        R.AML.PARAM<AML.PARAM.AMT.LIMIT.LCY>=Y.AMT.FCY*Y.AML.RATE
        CALL F.WRITE(FN.REDO.AML.PARAM,Y.AML.ID,R.AML.PARAM)
    END
RETURN
*------------------
END
