* @ValidationCode : MjotNzAzNDg0MDA3OkNwMTI1MjoxNjgxMzc0Mzc5NTg2OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 13:56:19
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
SUBROUTINE REDO.V.VAL.CLAIM.SPL.DATE.RESOL
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is Validation routine to check the date resolution is not less than today
* at the time of commitment
* This development is for ODR Reference PACS00071941
* Input/Output:
*--------------
* IN  : N/A
* OUT : N/A
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
* Revision History:
*------------------------------------------------------------------------------------------
* Date              who              Reference                         Description
* 25-MAY-2011       Pradeep S        PACS00071941                   Initial Creation
*13-04-2023       Conversion Tool    R22 Auto Code conversion          No Changes
*13-04-2023       Samaran T          R22 Manual Code Conversion         No Changes
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.CLAIMS

    GOSUB PROCESS
RETURN

*********
PROCESS:
*********

    IF COMI AND COMI LT TODAY THEN
        ETEXT = 'EB-DATE.NOT.LT.TODAY'
        CALL STORE.END.ERROR
    END

RETURN

*---------------------------------------------------------------------------------------------------
END
