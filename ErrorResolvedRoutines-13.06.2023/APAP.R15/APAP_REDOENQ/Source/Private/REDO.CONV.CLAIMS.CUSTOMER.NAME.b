$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.CLAIMS.CUSTOMER.NAME
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* display the field description of EB.LOOKUP instead of the ID.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 16-SEP-2011         RIYAS      ODR-2011-07-0162     Initial Creation
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.REDO.FRONT.CLAIMS

    GOSUB INITIALSE
    GOSUB CHECK.NOTES

RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.DEPT.ACCT.OFFICER = 'F.DEPT.ACCT.OFFICER'
    F.DEPT.ACCT.OFFICER = ''
    CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)

    FN.REDO.FRONT.CLAIMS = 'F.REDO.FRONT.CLAIMS'
    F.REDO.FRONT.CLAIMS = ''
    CALL OPF(FN.REDO.FRONT.CLAIMS,F.REDO.FRONT.CLAIMS)

RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~
    Y.REC.DATA = O.DATA
    CALL F.READ(FN.REDO.FRONT.CLAIMS,Y.REC.DATA,R.REDO.FRONT.CLAIMS,F.REDO.FRONT.CLAIMS,RFC.ERR)
    Y.SOCIAL.NAME = R.REDO.FRONT.CLAIMS<FR.CL.SOCIAL.NAME>
    IF NOT(Y.SOCIAL.NAME) THEN
        Y.GIVEN.NAMES = R.REDO.FRONT.CLAIMS<FR.CL.GIVEN.NAMES>
        Y.FAMILY.NAMES = R.REDO.FRONT.CLAIMS<FR.CL.FAMILY.NAMES>
        Y.FINAL.NAME = Y.GIVEN.NAMES:' ':Y.FAMILY.NAMES
    END ELSE
        Y.FINAL.NAME = Y.SOCIAL.NAME
    END
    O.DATA = Y.FINAL.NAME
RETURN
*-------------------------------------------------------------------------
END
