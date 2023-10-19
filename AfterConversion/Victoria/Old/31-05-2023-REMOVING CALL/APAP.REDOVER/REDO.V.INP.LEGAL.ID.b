* @ValidationCode : MjoxNjU0NTQ4NjIyOkNwMTI1MjoxNjg0ODQ1NjIwMTYyOklUU1M6LTE6LTE6LTE3OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 18:10:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -17
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
