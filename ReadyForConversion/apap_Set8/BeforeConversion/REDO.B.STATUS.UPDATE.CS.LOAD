*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.STATUS.UPDATE.CS.LOAD
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*--------------------------------------------------------------------------------
* Revision History:
*------------------
*   Date               who           Reference            Description
*
*---------------------------------------------------------------------------------------------
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE LAPAP.BP I_REDO.B.STATUS.UPDATE.CS.COMMON

    GOSUB INIT
    GOSUB LOC.REF
    RETURN

INIT:
*****
    FN.CUST.PRD.LIST='F.REDO.CUST.PRD.LIST'
    F.CUST.PRD.LIST=''
    CALL OPF(FN.CUST.PRD.LIST,F.CUST.PRD.LIST)

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT=''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    RETURN

LOC.REF:
********
    LREF.APP='ACCOUNT':FM:'CUSTOMER'
    LREF.FIELDS='L.AC.STATUS2':FM:'L.CU.TARJ.CR'
    LRF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LRF.POS)
    AC.STATUS2.POS = LRF.POS<1,1>
    CU.TARJ.POS    = LRF.POS<2,1>
    RETURN
END
