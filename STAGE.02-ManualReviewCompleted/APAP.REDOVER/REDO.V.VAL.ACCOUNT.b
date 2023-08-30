* @ValidationCode : MjoxODI4MTIyNTI3OkNwMTI1MjoxNjgxMzcyMDQ5MjE3OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 13:17:29
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
SUBROUTINE REDO.V.VAL.ACCOUNT
*------------
*DESCRIPTION:
*------------
*This routine is attached as a validation routine to the version TELLER,REDO.CR.CARD.ACCT.TFR
*it will default USD account in ACCOUNT.2if currency is USD and if currency is DOP then it will
*default DOP Account in ACCOUNT.2

*--------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-

*--------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*------------------
* Revision History:
*------------------
*   Date              who                   Reference                     Description
* 16-APR-2010      Prabhu.N              ODR-2009-10-0536               Initial Creation
*13-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*13-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER

    IF COMI EQ 'USD' THEN
        R.NEW(TT.TE.ACCOUNT.2)='USD128010002'
    END
    IF COMI EQ 'DOP' THEN
        R.NEW(TT.TE.ACCOUNT.2)='DOP128010002'
    END
RETURN
END
