* @ValidationCode : Mjo2MTEyMDAwNTI6Q3AxMjUyOjE2ODU1Mjg1NjQxODQ6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 15:52:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.GET.CUST.NAM(CUSTOMER.NAME)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Chandra Prakash T
* Program Name  : REDO.S.GET.CUS.NAME
* ODR NUMBER    : ODR-2010-01-0213
*----------------------------------------------------------------------------------
* Description   : Deal slip routine attached to FX.FXSN.PSLIP, TT.FXSN.PSLIP & FT.FXSN.SLIP to retrieve CUSTOMER name from the transaction, which
*                 depends on the application name
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 13-Jul-2010      Chandra Prakash T  ODR-2010-01-0213  Initial creation
*Modification history
*Date                Who               Reference                  Description
*10-04-2023      conversion tool     R22 Auto code conversion     No changes
*10-04-2023      Mohanraj R          R22 Manual code conversion   Add call routine prefix
*----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER

    $USING APAP.REDORETAIL

    GOSUB OPEN.FILES

    GOSUB PROCESS

RETURN


OPEN.FILES:
*----------------------------------------------------------------------------------

RETURN

PROCESS:
*----------------------------------------------------------------------------------
    Y.ACC.NO = R.NEW(FT.DEBIT.CUSTOMER)
*CALL REDO.CUST.IDENTITY.REF(Y.ACC.NO, Y.ALT.ID, Y.CUS.NAME)
    APAP.REDORETAIL.redoCustIdentityRef(Y.ACC.NO, Y.ALT.ID, Y.CUS.NAME);* R22 Manual conversion
    CUSTOMER.NAME = Y.CUS.NAME

RETURN

END
