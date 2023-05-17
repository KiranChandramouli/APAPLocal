SUBROUTINE REDO.B.ADMIN.CHEQUE.LOAD
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.B.ADMIN.CHEQUE.LOAD
* ODR NUMBER    : ODR-2009-10-0795
*----------------------------------------------------------------------------------------------------
* Description   : This is .load routine for REDO.B.ADMIN.CHEQUE, will initialise all the variables
* In parameter  :
* out parameter :
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 11-01-2011      MARIMUTHU s     ODR-2009-10-0795  Initial Creation
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.ADMIN.CHEQUE.COMMON

    GOSUB OPENFILES
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.H.PAY.MODE.PARAM = 'F.REDO.H.PAY.MODE.PARAM'
    F.REDO.H.PAY.MODE.PARAM = ''
    CALL OPF(FN.REDO.H.PAY.MODE.PARAM,F.REDO.H.PAY.MODE.PARAM)

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.REDO.ADMIN.CHEQUE.DETAILS = 'F.REDO.ADMIN.CHEQUE.DETAILS'
    F.REDO.ADMIN.CHEQUE.DETAILS = ''
    CALL OPF(FN.REDO.ADMIN.CHEQUE.DETAILS,F.REDO.ADMIN.CHEQUE.DETAILS)

    FN.DATES = 'F.DATES'
    F.DATES = ''
    CALL OPF(FN.DATES,F.DATES)

    FN.STMT.ENTRY.DETAIL = 'F.STMT.ENTRY.DETAIL'
    F.STMT.ENTRY.DETAIL = ''
    CALL OPF(FN.STMT.ENTRY.DETAIL,F.STMT.ENTRY.DETAIL)

    APPLN = 'AZ.ACCOUNT'
    FIELD.APL = 'ORIG.DEP.AMT':@VM:'BENEFIC.NAME'
    CALL MULTI.GET.LOC.REF(APPLN,FIELD.APL,POS.LOC)
    POS.DEP.AMT = POS.LOC<1,1>
    POS.BEN.NAME = POS.LOC<1,2>

RETURN
*-----------------------------------------------------------------------------
END
