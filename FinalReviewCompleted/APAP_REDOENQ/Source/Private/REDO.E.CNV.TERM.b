* @ValidationCode : MjotMjUzODM4MzA4OkNwMTI1MjoxNjgxOTk1OTg2NDM2OklUU1M6LTE6LTE6NzA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Apr 2023 18:36:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 70
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.TERM

************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.E.CNV.TERM.DETAILS
*----------------------------------------------------------

* Description : This subroutine is attached as a conversion routine in the Enquiry REDO.E.ROLLOVER.DETAILS
*               to calculate the new term for rollover deposit

* Linked with : Enquiry REDO.E.ROLLOVER.DETAILS as conversion routine
* In Parameter : None
* Out Parameter : None
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*02/12/2009 - ODR-2009-10-0537
*Development for conversion routine in the Enquiry REDO.E.ROLLOVER.DETAILS

* 13-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_ENQUIRY.COMMON

    GOSUB INITIALISE
    GOSUB OPENING
    GOSUB READ.AND.ASSIGN
    GOSUB CHECK.VALUES
RETURN

*----------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------


    Y.ACCOUNT.ID = ''

RETURN

*-----------------------------------------------------------------
OPENING:
*-----------------------------------------------------------------

    FN.AZ.ACCOUNT= 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

RETURN

*-----------------------------------------------------------------
READ.AND.ASSIGN:
*-----------------------------------------------------------------
* Value of O.DATA is assigned to Customer ID to read the particular customer data
*-----------------------------------------------------------------

    Y.ACCOUNT.ID = O.DATA
    Y.VALUE.DATE=R.RECORD<AZ.VALUE.DATE>
    Y.MATURITY.DATE=R.RECORD<AZ.MATURITY.DATE>
*---------------------------------------------------------------------
CHECK.VALUES:
*---------------------------------------------------------------------

    DAYS='C'
    CALL CDD('',Y.VALUE.DATE,Y.MATURITY.DATE,DAYS)
    O.DATA=DAYS:'D'
RETURN
END
