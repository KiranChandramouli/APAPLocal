* @ValidationCode : MjotNzc2NDg1OTkzOkNwMTI1MjoxNjgxMjkzOTAwNTAwOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 15:35:00
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.DS.STOP.ACC.TITLE(ACC.TITLE)
***************************************************************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RIYAS
* PROGRAM NAME: REDO.APAP.DS.STOP.ACC.TITLE
* ODR NO      : ODR-2009-10-0346
*-------------------------------------------------------------------------------------------------------------
* DESCRIPTION:This is a conversion routine used to display the details from local table REDO.AZ.DISCOUNT.RATE

* PARAMETERS:
* In Parameter        : NA
* Out Parameter       : ACC.TITLE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE           WHO            REFERENCE         DESCRIPTION
* 11.11.2011    RIYAS        ODR-2009-10-0346   INITIAL CREATION

*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.PAYMENT.STOP.ACCOUNT

    GOSUB OPENFILES
    GOSUB PROCESSNEW
RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN
*----------------------------------------------------------------------
PROCESSNEW:
*----------------------------------------------------------------------
    Y.ACCOUNT.NO = R.NEW(REDO.PS.ACCT.ACCOUNT.NUMBER)
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,Y.ACC.ERR)
    Y.TITLE1 = R.ACCOUNT<AC.ACCOUNT.TITLE.1>
    Y.TITLE2 = R.ACCOUNT<AC.ACCOUNT.TITLE.2>
    ACC.TITLE = Y.TITLE1:' ':Y.TITLE2
RETURN
*----------------------------------------------------------------------
END
