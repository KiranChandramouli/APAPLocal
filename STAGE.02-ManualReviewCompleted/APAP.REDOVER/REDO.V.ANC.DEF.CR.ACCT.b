* @ValidationCode : MjoxMDU5NTU0Njk2OkNwMTI1MjoxNjgwNzc1NjQ2NTg2OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:37:26
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
SUBROUTINE REDO.V.ANC.DEF.CR.ACCT
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This AUTO.CONTENT.ROUTINE  is used to populate credit account number based on company
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NATCHIMUTHU.P
* PROGRAM NAME : REDO.V.ANC.DEF.CR.ACCT
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                 REFERENCE                      DESCRIPTION
* 20.07.2010       NATCHIMUTHU.P       ODR-2010-02-0001            INITIAL CREATION
*06-04-2023       Conversion Tool      R22 Auto Code conversion          No Changes
*06-04-2023       Samaran T             R22 Manual Code Conversion       No Changes
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.COMPANY

    GOSUB PROCESS
RETURN

PROCESS:
*-------
* USD-12801-0007-0017

    Y.SU.DIV.CODE = R.COMPANY(EB.COM.SUB.DIVISION.CODE)
    Y.CREDIT.ACCT.NO = "USD128010007"
    R.NEW(FT.CREDIT.ACCT.NO)=Y.CREDIT.ACCT.NO:Y.SU.DIV.CODE
RETURN
*------------------------------------------------------------------------------------------------------------
END
