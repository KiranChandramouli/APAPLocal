SUBROUTINE REDO.B.DEAL.SLIP.QUEUE.PURGE.LOAD
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Sakthi Sellappillai
* Program Name  : REDO.B.DEAL.SLIP.QUEUE.PURGE.LOAD
* ODR           :
*-----------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*-----------------------------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*-----------------------------------------------------------------------------
* MODIFICATION HISTORY
*-----------------------------------------------------------------------------
*   DATE         WHO                    ODR                   DESCRIPTION
*============    ==============         ================      ================
*13-12-2010      SRIRAMAN.C             CR020                 Initial Creation
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.B.DEAL.SLIP.QUEUE.PURGE.COMMON
    $INSERT I_F.REDO.APAP.H.DEAL.SLIP.QUEUE
    $INSERT I_F.REDO.APAP.H.DEAL.SLIP.QUEUE.PARAM
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.DATES
    $INSERT I_F.ACCOUNT


    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    FN.REDO.APAP.H.DEAL.SLIP.QUEUE = 'F.REDO.APAP.H.DEAL.SLIP.QUEUE'
    F.REDO.APAP.H.DEAL.SLIP.QUEUE = ''
    CALL OPF(FN.REDO.APAP.H.DEAL.SLIP.QUEUE,F.REDO.APAP.H.DEAL.SLIP.QUEUE)

    R.REDO.APAP.H.DEAL.SLIP.QUEUE = ''


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.APAP.H.DEAL.SLIP.QUEUE.PARAM = 'F.REDO.APAP.H.DEAL.SLIP.QUEUE.PARAM'
    F.REDO.APAP.H.DEAL.SLIP.QUEUE.PARAM  = ''
    CALL OPF(FN.REDO.APAP.H.DEAL.SLIP.QUEUE.PARAM,F.REDO.APAP.H.DEAL.SLIP.QUEUE.PARAM)

    R.REDO.APAP.H.DEAL.SLIP.QUEUE.PARAM.REC = ''



    Y.DS.QUEUE.PARAM.ID = 'SYSTEM'
    Y.DS.QUEUE.PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.APAP.H.DEAL.SLIP.QUEUE.PARAM,Y.DS.QUEUE.PARAM.ID,R.REDO.APAP.H.DEAL.SLIP.QUEUE.PARAM.REC,Y.DS.QUEUE.PARAM.ERR)


    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS = ''
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)


    R.FUNDS.TRANSFER.REC = ''

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)


    FN.TELLER.HIS = 'F.TELLER$HIS'
    F.TELLER.HIS = ''
    CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)

    R.TELLER.REC = ''

    FN.T24.FUND.SERVICES = 'F.T24.FUND.SERVICES'
    F.T24.FUND.SERVICES = ''
    CALL OPF(FN.T24.FUND.SERVICES,F.T24.FUND.SERVICES)


    FN.T24.FUND.SERVICES.HIS = 'F.T24.FUND.SERVICES$HIS'
    F.T24.FUND.SERVICES.HIS = ''
    CALL OPF(FN.T24.FUND.SERVICES.HIS,F.T24.FUND.SERVICES.HIS)


    R.T24.FUND.SERVICES.REC = ''

    FN.DATES = 'F.DATES'
    F.DATES = ''
    CALL OPF(FN.DATES,F.DATES)

    R.DATES.REC = ''

RETURN
****************************************************************
END
*-----------------------------------------------------------------------------
