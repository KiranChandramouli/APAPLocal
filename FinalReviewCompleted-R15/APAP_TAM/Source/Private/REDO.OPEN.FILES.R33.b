$PACKAGE APAP.TAM
SUBROUTINE REDO.OPEN.FILES.R33
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.OPEN.FILES.R33.COMMON
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.OPEN.FILES.R33
* ODR NUMBER    : ODR-2010-03-0131
*-----------------------------------------------------------------------------
* Description   : This routine will be called by main routine REDO.NOF.GEN.CHQ.AGENCY.Purpose of this routine is to initialise variables
* In parameter  : none
* out parameter :
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 10-01-2011      MARIMUTHU s     ODR-2010-03-0131   Initial Creation
** 13-04-2023 R22 Auto Conversion no changes
** 13-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------


    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TELLER.HIS = 'F.TELLER$HIS'
    F.TELLER.HIS = ''
    CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS = ''
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.MULTI.TRANSACTION.SERVICE = 'F.MULTI.TRANSACTION.SERVICE'
    F.MULTI.TRANSACTION.SERVICE = ''
    CALL OPF(FN.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE)

    FN.T24.FUND.SERVICES = 'F.T24.FUND.SERVICES'
    F.T24.FUND.SERVICES = ''
    CALL OPF(FN.T24.FUND.SERVICES,F.T24.FUND.SERVICES)

    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
    CALL OPF(FN.RELATION,F.RELATION)

    FN.REDO.TRANS.TYPES.TT.PARAM = 'F.REDO.TRANS.TYPES.TT.PARAM'
    F.REDO.TRANS.TYPES.TT.PARAM = ''
    CALL OPF(FN.REDO.TRANS.TYPES.TT.PARAM,F.REDO.TRANS.TYPES.TT.PARAM)

    FN.REDO.TRANS.TYPES.FT.PARAM = 'F.REDO.TRANS.TYPES.FT.PARAM'
    F.REDO.TRANS.TYPES.FT.PARAM = ''
    CALL OPF(FN.REDO.TRANS.TYPES.FT.PARAM,F.REDO.TRANS.TYPES.FT.PARAM)

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

RETURN

END
