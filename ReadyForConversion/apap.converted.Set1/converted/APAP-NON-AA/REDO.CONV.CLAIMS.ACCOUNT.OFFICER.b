SUBROUTINE REDO.CONV.CLAIMS.ACCOUNT.OFFICER
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
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DEPT.ACCT.OFFICER

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

RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~
    Y.REC.DATA = O.DATA
    CALL F.READ(FN.CUSTOMER,Y.REC.DATA,R.CUSTOMER,F.CUSTOMER,LOOKUP.ERR)
    Y.ACCT.OFF = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
    CALL CACHE.READ(FN.DEPT.ACCT.OFFICER, Y.ACCT.OFF, R.DEPT.ACCT.OFFICER, DAO.ERR)
    O.DATA = R.DEPT.ACCT.OFFICER<EB.DAO.AREA>
RETURN
*-------------------------------------------------------------------------
END
