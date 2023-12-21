* @ValidationCode : MjoxMjQ0MjE2NjY3OlVURi04OjE3MDI5ODA4MjUwODg6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 15:43:45
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

SUBROUTINE REDO.V.AA.AUT.CP.OVERPAY
*---------------------------------------------------------------------------------
* Description: This routine is to update the contact table REDO.AA.CP.OVERPAYMENT during the
*             AUTH stage of AA overpayment through CASH & CHEQUE version.
*
* Version Involved:
*              VERSION>FT,REDO.MULTI.AA.ACRP.UPD.TR
*              VERSION>FT,REDO.MULTI.AA.ACRP.UPD
* Dev By: V.P.Ashokkumar
*
* Date : 10/10/2016
* Modificación : 28/01/2020
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion             Nochange
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*19-12-2023      Narmadha V                 Manual R22 Conversion           Call Routine Format Modified
*---------------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.AA.CP.OVERPAYMENT
    $INSERT I_F.REDO.AA.OVERPAYMENT
    $INSERT I_F.DATES ;*R22 Auto Conversion - End
    $USING AA.PaymentSchedule ;*Manual R22 Conversion

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.REDO.AA.OVERPAYMENT = 'F.REDO.AA.OVERPAYMENT'; F.REDO.AA.OVERPAYMENT = ''
    CALL OPF(FN.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT)
    FN.REDO.AA.CP.OVERPAYMENT = 'F.REDO.AA.CP.OVERPAYMENT'; F.REDO.AA.CP.OVERPAYMENT = ''
    CALL OPF(FN.REDO.AA.CP.OVERPAYMENT,F.REDO.AA.CP.OVERPAYMENT)
    VAR.AA.ID = ''; FT.TXN.AMT = '' ; Y.FECHA.CORTE = R.DATES(EB.DAT.LAST.WORKING.DAY)
RETURN

PROCESS:
********
    VAR.AA.ID=R.NEW(FT.CREDIT.ACCT.NO)
    FT.TXN.AMT=R.NEW(FT.DEBIT.AMOUNT)
    IF FT.TXN.AMT EQ '' THEN
        FT.TXN.AMT = R.NEW(FT.CREDIT.AMOUNT)
    END
    R.ACCOUNT = ''; ACC.ERR = ''; ERR.REDO.AA.CP.OVERPAYMENT = ''; R.REDO.AA.CP.OVERPAYMENT = ''
    CALL F.READ(FN.ACCOUNT,VAR.AA.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.AA.ID  = R.ACCOUNT<AC.ARRANGEMENT.ID>
    Y.CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
    GOSUB GET.NEXT.DUE.DATE
    IF NOT(Y.NEXT.DUE.DATE) THEN
        RETURN
    END

    Y.CNCT.ID = Y.CUSTOMER.ID:".":VAR.AA.ID
    CALL F.READ(FN.REDO.AA.CP.OVERPAYMENT,Y.CNCT.ID,R.REDO.AA.CP.OVERPAYMENT,F.REDO.AA.CP.OVERPAYMENT,ERR.REDO.AA.CP.OVERPAYMENT)
*-------------------------------------------------------------------------------------------------
*TODO MDP-158 agregando la logica de fecha de corte
    IF R.REDO.AA.CP.OVERPAYMENT AND R.REDO.AA.CP.OVERPAYMENT<REDO.AA.CP.STATUS> EQ "PENDIENTE" AND Y.FECHA.CORTE LT R.REDO.AA.CP.OVERPAYMENT<REDO.AA.CP.NEXT.DUE.DATE> THEN
        RETURN
    END
*------------------------------------------------------------------------------------------------
    R.REDO.AA.CP.OVERPAYMENT<REDO.AA.CP.LOAN.NO> = Y.AA.ID
    R.REDO.AA.CP.OVERPAYMENT<REDO.AA.CP.NEXT.DUE.DATE> = Y.NEXT.DUE.DATE
    R.REDO.AA.CP.OVERPAYMENT<REDO.AA.CP.STATUS> = "PENDIENTE"
    CALL F.WRITE(FN.REDO.AA.CP.OVERPAYMENT,Y.CNCT.ID,R.REDO.AA.CP.OVERPAYMENT)
RETURN

GET.NEXT.DUE.DATE:
******************
    Y.NEXT.DUE.DATE = ''; NO.RESET = ''; DATE.RANGE = ''; SIMULATION.REF = ''
*CALL AA.SCHEDULE.PROJECTOR(Y.AA.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, DUE.DATES, '', DUE.TYPES, DUE.METHODS,DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
    AA.PaymentSchedule.ScheduleProjector(Y.AA.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, DUE.DATES, '', DUE.TYPES, DUE.METHODS,DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS) ;*Manual R22 Conversion - Call Routine Format Modified.
    Y.PAYMENT.DATES.CNT = DCOUNT(DUE.DATES,@FM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.PAYMENT.DATES.CNT
        IF DUE.DATES<Y.VAR1> GT TODAY THEN
            Y.NEXT.DUE.DATE = DUE.DATES<Y.VAR1>
            Y.VAR1 = Y.PAYMENT.DATES.CNT+1
        END
        Y.VAR1 += 1 ;*R22 Auto Conversion
    REPEAT
RETURN
END
