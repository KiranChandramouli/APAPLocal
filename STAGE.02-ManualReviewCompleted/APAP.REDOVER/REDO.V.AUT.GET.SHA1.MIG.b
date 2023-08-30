* @ValidationCode : MjoxMzg4OTQxMTIwOkNwMTI1MjoxNjgwNzc4NzYzODkxOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 16:29:23
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
SUBROUTINE REDO.V.AUT.GET.SHA1.MIG
*******************************************************************************************************************

*Company   Name    : Asociacion Popular De Ahorros Y Pristamos Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.AUT.GET.SHA1
*------------------------------------------------------------------------------------------------------------------

*Description       : To update SHA related tables during Migration.

*Linked With       : AZ,REDO as AUTH.ROUTINE
*In  Parameter     : -N/A-
*Out Parameter     : -N/A-
*------------------------------------------------------------------------------------------------------------------

*Modification Details:
*=====================
*07/03/2011 - ODR-2009-10-0425 - PACS00032523 - SUDHARSANAN S - Based on customer type the input name parameter is updated
*24/05/2011 - ODR-2009-10-0425 - PACS00054327 - SUDHARSANAN S - Based on customer type the CARD ID value is updated
*------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*06-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*06-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.T.SHA1


    GOSUB INITIALISE
    GOSUB OPEN
    GOSUB PROCESS
RETURN
*------------
INITIALISE:
*------------

    FN.REDO.T.SHA1 = 'F.REDO.T.SHA1'
    F.REDO.T.SHA1 = ''
    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT=''

RETURN

**********************************************
OPEN:
    CALL OPF(FN.REDO.T.SHA1,F.REDO.T.SHA1)
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
RETURN
**************************************************

PROCESS:

    LREF.APPL = 'AZ.ACCOUNT'
    LREF.FIELDS = 'L.AZ.SHA1.CODE'
    LREF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APPL,LREF.FIELDS,LREF.POS)
    SHA1.POS =LREF.POS<1,1>


    SHA1.CODE = R.NEW(AZ.LOCAL.REF)<1,SHA1.POS>
*  R.SHA1.CODE<1> =ID.NEW
* Tus Start
    R.SHA1.CODE<RE.T.SH.AZ.ACCOUNT.NO> =ID.NEW
* Tus End

    CALL F.WRITE(FN.REDO.T.SHA1,SHA1.CODE,R.SHA1.CODE)

RETURN

*------------------------------------------------------------------------------------------
END
