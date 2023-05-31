* @ValidationCode : MjoxMTM4MzI4ODk0OkNwMTI1MjoxNjgxOTk1OTg4MDAxOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Apr 2023 18:36:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.SELECT.AZ.ACC(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.E.INS.SELECT
*----------------------------------------------------------

* Description   : This subroutine will return the list of AZ PRODUCT PARAMETERS
* Linked with   : Enquiry REDO.E.INS.SELECT as conversion routine
* In Parameter  : None
* Out Parameter : None

* 13-APR-2023     Conversion tool   R22 Auto conversion   VM to @VM
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_System
    VAR.SEL.LIST =ENQ.DATA<2>
    VAR.SEL.SIZE =DCOUNT(VAR.SEL.LIST,@VM)

    ENQ.DATA<2,VAR.SEL.SIZE+1>= 'CUSTOMER'
    ENQ.DATA<3,VAR.SEL.SIZE+1>= 'EQ'
    ENQ.DATA<4,VAR.SEL.SIZE+1>= System.getVariable("EXT.SMS.CUSTOMERS")

RETURN
END
