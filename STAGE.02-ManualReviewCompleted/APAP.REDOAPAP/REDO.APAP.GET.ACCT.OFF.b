* @ValidationCode : MjoxMDc3Mzc2ODU0OkNwMTI1MjoxNjgwNjc1NjIxMDUyOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 11:50:21
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.GET.ACCT.OFF
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.GET.ACCT.OFF
*---------------------------------------------------------------------------------------------------------
*Description   : REDO.APAP.GET.ACCT.OFF  is a conversion routine attached to the ENQUIRY>
*                REDO.APAP.INVST.RATE , the routine fetches the value of account officer
*                from O.DATA
*Linked With   :
*In Parameter  : N/A
*Out Parameter : N/A
*----------------------------------------------------------------------------------------------------------
*Modification Details:
*---------------------
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 20 OCT 2010              Dhamu S             ODR-2010-03-0098            Initial Creation
* Date                  who                   Reference              
* 05-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
***********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
*-------------------------------------------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    ACCT.ID = O.DATA
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    O.DATA = R.ACCOUNT<AC.ACCOUNT.OFFICER>
RETURN
END
*-----------------------------------------------------------------------------------------------------------
