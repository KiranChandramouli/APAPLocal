SUBROUTINE REDO.VALIDATE.LOAN.STATUS
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is to show an error if user gives any other value other than the defined for L.LOAN.STATUS.1 virtual table
* --------------------------------------------------------------------------------------------------------------------------
*   Date               who           Reference                       Description
*
*
*---------------------------------------------------------------------------------------------------------------------------
*
* All File INSERTS done here
*

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.LOOKUP
*------------------------------------------------------------------------------------------------------------------
*Main Logic of the routine
*
MAIN.LOGIC:

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------------------------------------------
* Initialise the required variables
*
INITIALISE:

    LOAN.POS = ''

    LOAN.STATUS = ""
    LOAN.STATUS = "L.LOAN.STATUS.1"
    CALL EB.LOOKUP.LIST(LOAN.STATUS)
    LOAN.STATUS = LOAN.STATUS<2>
    CHANGE '_' TO @FM IN LOAN.STATUS

    LOAN.ACC.STATUS = COMI

RETURN
*-----------------------------------------------------------------------------------------------------------------
* Check the value is valid ID in L.LOAN.STATUS.1 table
*
PROCESS:

    LOCATE LOAN.ACC.STATUS IN LOAN.STATUS SETTING LOAN.POS ELSE

        E = 'NOT A VALID STATUS'

    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
*
END
