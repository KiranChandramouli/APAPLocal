SUBROUTINE REDO.ID.NO.NEW.RECORD
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is to show an error if user clicks the new deal button in Modification version
* ------------------------------------------------------------------------
*   Date               who           Reference                       Description
* 26-APR-2011     SHANKAR RAJU    CR.007-CU Version Integration    Initial Creation
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------
INITIALISE:

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    R.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN
*-------------------------------------------------------------------------
PROCESS:

    CALL F.READ(FN.CUSTOMER,COMI,R.CUSTOMER,F.CUSTOMER,ERR.CUS)

    IF R.CUSTOMER EQ '' THEN
        E = 'EB-REDO.NO.NEW.RECORD'
    END
RETURN
*-------------------------------------------------------------------------
END
