SUBROUTINE REDO.E.NOF.PAYMENT.TYPE(Y.TXN.SYS.ID,Y.TXN.CONT.ID,Y.CANCEL.AGENCY,Y.CANCEL.USER)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : T.Jeeva, Temenos Application Management
*Program   Name    : REDO.E.NOF.PAYMENT.TYPE
*ODR Reference     : ODR-2010-03-0171
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.E.NOF.PAYMENT.TYPE is call routine used to fetch the value of user name and agency from TELLER and FUNDS TRANSFER
*In Parameter : Y.TXN.CONT.ID,Y.TXN.SYS.ID
*Out Parameter: Y.CANCEL.USER,Y.CANCEL.AGENCY
*LINKED WITH  : ROUTINE>REDO.APAP.NOFILE.CANC.LOAN.DET
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_ENQUIRY.COMMON

    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
OPENFILES:
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

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    IF Y.TXN.SYS.ID EQ 'TT' THEN
        GOSUB CHEK.TT.TYPE
    END

    IF Y.TXN.SYS.ID EQ 'FT' THEN
        GOSUB CHEK.FT.TYPE
    END

RETURN
*-----------------------------------------------------------------------------
CHEK.TT.TYPE:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.TELLER,Y.TXN.CONT.ID,R.TELLER,F.TELLER,TELL.ERR)

    IF R.TELLER EQ '' THEN

        CALL EB.READ.HISTORY.REC(F.TELLER.HIS,Y.TXN.CONT.ID,R.TELLER.HIS,YERR)
        Y.CANCEL.AGENCY = R.TELLER.HIS<TT.TE.CO.CODE>
        Y.CAN.USER = R.TELLER.HIS<TT.TE.INPUTTER>
        Y.CANCEL.USER=FIELD(Y.CAN.USER,'_',2)

    END ELSE

        Y.CANCEL.AGENCY  = R.TELLER<TT.TE.CO.CODE>
        Y.CAN.USER = R.TELLER<TT.TE.INPUTTER>
        Y.CANCEL.USER=FIELD(Y.CAN.USER,'_',2)
    END

RETURN
*-------------------------------------------------------------------
CHEK.FT.TYPE:
*----------------------------------------------------------------------

    CALL F.READ(FN.FUNDS.TRANSFER,Y.TXN.CONT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FT.ERR)

    IF R.FUNDS.TRANSFER EQ '' THEN

        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,Y.TXN.CONT.ID,R.FT.HIS,FT.ERROR)
        Y.CANCEL.AGENCY = R.FT.HIS<FT.CO.CODE>
        Y.CAN.USER = R.FT.HIS<FT.INPUTTER>
        Y.CANCEL.USER=FIELD(Y.CAN.USER,'_',2)

    END ELSE

        Y.CANCEL.AGENCY = R.FUNDS.TRANSFER<FT.CO.CODE>
        Y.CAN.USER = R.FUNDS.TRANSFER<FT.INPUTTER>
        Y.CANCEL.USER=FIELD(Y.CAN.USER,'_',2)

    END

RETURN
*-----------------------------------------------------------------------------
END
