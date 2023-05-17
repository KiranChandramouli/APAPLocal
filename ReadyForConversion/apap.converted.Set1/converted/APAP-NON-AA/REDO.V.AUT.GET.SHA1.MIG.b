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
