* @ValidationCode : Mjo2NjUxNzY4NDpDcDEyNTI6MTY4MTMwMjc3NjcxNzpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 18:02:56
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
SUBROUTINE REDO.V.REINV.CHECK.TRANSIT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.V.REINV.CHECK.TRANSIT
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
* This validation routine should be attached to the VERSION
* AZ.ACCOUNT,REVINV.AZ.CLOSE to close the AZ.ACCOUNT
*--------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
* DATE WHO REFERENCE DESCRIPTION
* 16-06-2010 SUJITHA.S ODR-2009-10-0332 INITIAL CREATION
*
*----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*12-04-2023       Conversion Tool        R22 Auto Code conversion          VM TO @VM
*12-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER

    GOSUB INIT
    GOSUB PROCESS
RETURN

*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------


    LOC.REF.APPL='AZ.ACCOUNT'
    LOC.REF.FLD='L.AZ.IN.TRANSIT'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPL,LOC.REF.FLD,LOC.REF.POS)
RETURN

*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------

    Y.INTRANSIT=R.NEW(AZ.LOCAL.REF)<1,LOC.REF.POS>

    IF COMI EQ 'YES' THEN
        TEXT = "AZ.IN.TRANSIT"
        CURR.NO = DCOUNT(R.NEW(AZ.OVERRIDE),@VM)
        CALL STORE.OVERRIDE(CURR.NO+1)
    END ELSE
    END

RETURN
END
