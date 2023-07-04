* @ValidationCode : MjoxNjU0NTQ4NjIyOkNwMTI1MjoxNjgxMjgzNDg3NDc0OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:41:27
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
SUBROUTINE REDO.V.INP.LEGAL.ID
*******************************************************************************************************************
*Company   Name    : Asociaciopular de Ahorros y Pramos Bank
*Developed By      : P.ANAND(anandp@temenos.com)
*Date              : 26.10.2009
*Program   Name    : REDO.V.INP.LEGAL.ID
*Reference Number  : ODR-2009-10-0807
*------------------------------------------------------------------------------------------------------------------
*Description       : This subroutine validates the customer's passport document and raise the Error Message
*Linked With       :
*
*

*In  Parameter     : -NA-
*Out Parameter     : -NA-
*------------------------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*12-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*12-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------------------------
 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
*------------------------------------------------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-------------------------------------------------------------------------------------------------------------------
INIT:
******
* This block initialise the local fields and variables used
    Y.LEGAL.ID = R.NEW(EB.CUS.LEGAL.ID)

RETURN
*-------------------------------------------------------------------------------------------------------------------
PROCESS:
********
    IF Y.LEGAL.ID NE '' THEN
        AF = EB.CUS.LEGAL.ID
        AV = 1
        ETEXT = 'EB-REDO.INVALID.DOC'
        CALL STORE.END.ERROR
    END
RETURN
*-------------------------------------------------------------------------------------------------------------------
END
*-------------------------------------------END OF RECORD-----------------------------------------------------------
