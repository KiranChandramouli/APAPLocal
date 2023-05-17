SUBROUTINE REDO.B.STAFF.CUST.TRACK.LOAD

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : RAJA SAKTHIVEL K P
* Program Name  : REDO.B.STAFF.CUST.TRACK.LOAD
*-------------------------------------------------------------------------
* Description: This routine is a load routine to load all the necessary variables for the
* multi threaded process
*----------------------------------------------------------
* Linked with: Multi threaded batch routine REDO.B.STAFF.CUST.TRACK
* In parameter : None
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 03-03-10      ODR-2009-10-0532                     Initial Creation
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_REDO.B.STAFF.CUST.TRACK.COMMON
    $INSERT I_F.REDO.EMPLOYEE.ACCOUNTS
    $INSERT I_F.CUSTOMER.ACCOUNT

    GOSUB OPENFILES
RETURN


*-------------
OPENFILES:
*-------------

    FN.REDO.EMPLOYEE.ACCOUNTS = 'F.REDO.EMPLOYEE.ACCOUNTS'
    F.REDO.EMPLOYEE.ACCOUNTS = ''
    CALL OPF(FN.REDO.EMPLOYEE.ACCOUNTS,F.REDO.EMPLOYEE.ACCOUNTS)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUST.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUST.ACCOUNT = ''
    CALL OPF(FN.CUST.ACCOUNT,F.CUST.ACCOUNT)

    FN.JOINT.CONTRACTS.XREF = 'F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF = ''
    CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

    FN.SEC.ACC.MASTER.$HIS = 'F.SEC.ACC.MASTER$HIS'
    F.SEC.ACC.MASTER.$HIS = ''
    CALL OPF(FN.SEC.ACC.MASTER.$HIS,F.SEC.ACC.MASTER.$HIS)

    FN.REDO.W.CUSTOMER.UPDATE = 'F.REDO.W.CUSTOMER.UPDATE'
    F.REDO.W.CUSTOMER.UPDATE = ''
    CALL OPF(FN.REDO.W.CUSTOMER.UPDATE,F.REDO.W.CUSTOMER.UPDATE)

RETURN

*---------------------------------------------------------------------------
END
