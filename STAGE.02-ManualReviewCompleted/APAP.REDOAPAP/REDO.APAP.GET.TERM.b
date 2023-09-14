* @ValidationCode : MjotMTUwNzU4OTI0NzpDcDEyNTI6MTY4MDY3Njg1NzkwMDpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 12:10:57
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
SUBROUTINE REDO.APAP.GET.TERM
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.GET.TERM
*----------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.GET.TERM is a conversion routine attached to the ENQUIRY>
*                    REDO.APAP.INVST.RATE, the routine fetches the value from O.DATA delimited
*                    with stars and formats them according to the selection criteria and returns the value
*                     back to O.DATA
*Linked With       :
*In  Parameter     : N/A
*Out Parameter     : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 09 NOV 2010              Dhamu S             ODR-2010-03-0098            Initial Creation
* Date                  who                   Reference              
* 05-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
*--------------------------------------------------------------------------------------------------------

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    AZ.ACCOUNT.ID = FIELD(O.DATA,'\',1)
    CALL F.READ(FN.AZ.ACCOUNT,AZ.ACCOUNT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,ACCT.ERR)
    MAT.DATE.VAL = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
    VALUE.DATE.VAL = R.AZ.ACCOUNT<AZ.VALUE.DATE>
    Y.REG = ''
    Y.DAYS = 'C'

    CALL CDD(Y.REG,MAT.DATE.VAL,VALUE.DATE.VAL,Y.DAYS)
    O.DATA = ''
    O.DATA = ABS(Y.DAYS)
RETURN
END
*------------------------------------------------------------------------------------------------------------------
