SUBROUTINE REDO.E.BLD.VAL.STATUS(ENQ.DATA)

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : H GANESH
* Program Name  : REDO.E.BLD.VAL.ACCOUNT
*-------------------------------------------------------------------------
* Description: This routine is a build routine attached to all enquiries
* which have account no as selection field to restrict unauthorised access
*----------------------------------------------------------
* Linked with: All enquiries with Customer no as selection field
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 01-09-10          ODR-2010-08-0031              Routine to validate Account

*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.UNAUTH.STAFF.LOG
    $INSERT I_F.REDO.EMPLOYEE.ACCOUNTS

    GOSUB OPENFILES

RETURN

*---------
OPENFILES:
*---------

    LOCATE 'ORDER.STATUS' IN ENQ.DATA<2,1> SETTING POS1 THEN
        Y.VALUE = ENQ.DATA<4,POS1>
    END
    Y.NEW.VAL = "'":Y.VALUE:"'"
    ENQ.DATA<4,POS1> = Y.NEW.VAL

RETURN

*-----------------------------------------
PROCESS:
*-----------------------------------------


END
