* @ValidationCode : MjotMTM4MjIzNTM4OlVURi04OjE2ODU1MzE4NzY4MDY6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 16:47:56
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.CUST.CC(Y.CARD.LIST)

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.E.NOF.CUST.CC
*--------------------------------------------------------------------------------
* Description: This Enquiry nofile routine is to bring all the credit cards from
* sunne that llinked to the customer
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE         WHO         REFERENCE         DESCRIPTION
* 24-May-2011   Pradeep S   PACS00071066      INITIAL CREATION
* 12-APRIL-2023      Harsha                R22 Auto Conversion  - FM to @FM
* 12-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn formate modified
*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.FRONT.REQUESTS
    $USING APAP.TAM

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
******

RETURN

PROCESS:
*********
    LOCATE "CUST.ID" IN D.FIELDS SETTING CUS.POS THEN
        Y.CUST.ID = D.RANGE.AND.VALUE<CUS.POS>
    END

    D.FIELDS = 'CLIENT.ID':@FM:'COMPANY.CODE'
    D.RANGE.AND.VALUE   = Y.CUST.ID:@FM:'1'
    D.LOGICAL.OPERANDS  = '1':@FM:'1'

    APAP.TAM.redoCreditCustomerPositionVp(Y.CC.LIST);*R22 Manual Conversion

    Y.CARD.LIST = FIELDS(Y.CC.LIST,'*',5,1)

RETURN
END
