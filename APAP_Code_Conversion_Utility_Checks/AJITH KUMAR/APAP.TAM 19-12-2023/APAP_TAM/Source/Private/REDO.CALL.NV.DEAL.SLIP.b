* @ValidationCode : MjotMzYzMDUzNTQ1OkNwMTI1MjoxNzAyODgxMTgzODg1OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Dec 2023 12:03:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CALL.NV.DEAL.SLIP(Y.INP.DEAL)
*----------------------------------------------------------------------------------------------------------------------
*Description: This routine is call routine from deal slip of AA Payment NV.

*----------------------------------------------------------------------------------------------------------------------
*Input Arg : Y.INP.DEAL
*Out Arg   : Y.INP.DEAL
*Deals With: AA Repayement NV - TELLER, FT.
*----------------------------------------------------------------------------------------------------------------------
* Modification Details:
* =====================
* Date         Who                  Reference      Description
* ------       -----                ------------   -------------
* 30-05-2011   Marimuthu                           INITIAL CREATION
* 31-07-2013   Vignesh Kumaar M R   PACS00305984   CASHIER DEAL SLIP PRINT OPTION
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*04/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION    = TO EQ, ++ TO +=1, VM TO @VM,FM TO @FM
*04/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_REDO.NV.AA.DEAL.SLIP.COMMON
    $INSERT I_F.COMPANY
    $USING AA.PaymentSchedule

    GOSUB PROCESS
RETURN
*-------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------

    Y.FIELD.NAME = Y.INP.DEAL

* Fix for PACS00305984 [CASHIER DEAL SLIP PRINT OPTION]

    FN.REDO.CASHIER.DEALSLIP.INFO = 'F.REDO.CASHIER.DEALSLIP.INFO'
    F.REDO.CASHIER.DEALSLIP.INFO = ''
    CALL OPF(FN.REDO.CASHIER.DEALSLIP.INFO,F.REDO.CASHIER.DEALSLIP.INFO)

    GET.TXN.ID = System.getVariable("CURRENT.WTM.FIRST.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION
        GET.TXN.ID = ""
    END


    IF GET.TXN.ID EQ 'CURRENT.WTM.FIRST.ID' THEN
        GET.TXN.ID = ID.NEW:'-NV.INFO'
    END ELSE
        GET.TXN.ID = GET.TXN.ID:'-NV.INFO'
    END

*  READ R.REDO.CASHIER.DEALSLIP.INFO FROM F.REDO.CASHIER.DEALSLIP.INFO, GET.TXN.ID THEN ;*Tus Start
    CALL F.READ(FN.REDO.CASHIER.DEALSLIP.INFO,GET.TXN.ID,R.REDO.CASHIER.DEALSLIP.INFO,F.REDO.CASHIER.DEALSLIP.INFO,R.REDO.CASHIER.DEALSLIP.INFO.ERR)
    IF R.REDO.CASHIER.DEALSLIP.INFO THEN          ;* Tus End
        IF R.REDO.CASHIER.DEALSLIP.INFO NE '' OR R.REDO.CASHIER.DEALSLIP.INFO NE 0 THEN
            R.DEAL.ARRAY = R.REDO.CASHIER.DEALSLIP.INFO
        END
    END



* End of Fix

    LOCATE ID.NEW IN R.DEAL.ARRAY<1,1> SETTING POS1 THEN
        GOSUB GET.VALUES
    END

    Y.INP.DEAL = Y.RETURN.VALUE

RETURN
*-------------------------------------------------------------
GET.VALUES:
*-------------------------------------------------------------

    Y.RETURN.VALUE = ''

    IF Y.FIELD.NAME EQ 'Y.LOAN.ACCOUNT' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<2,POS1>
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"16R")
        RETURN
    END

    IF Y.FIELD.NAME EQ 'Y.CUST.NAME' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<3,POS1>
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"37R")
        RETURN
    END
    IF Y.FIELD.NAME EQ 'Y.CONCEPT' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<4,POS1>
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"37R")
        RETURN
    END
    IF Y.FIELD.NAME EQ 'Y.CURRENCY' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<5,POS1>
        Y.CURRENCY=Y.RETURN.VALUE
        IF  Y.CURRENCY EQ 'PESOS DOMINICANOS' THEN ;*AUTO R22 CODE CONVERSION
            Y.CURRENCY="RD$(":Y.CURRENCY:")"
        END
        Y.RETURN.VALUE=FMT(Y.CURRENCY,"22R")
        RETURN
    END

    IF Y.FIELD.NAME EQ 'Y.TOT.TXN.AMT' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<6,POS1>
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"18R,2")
        RETURN
    END
    IF Y.FIELD.NAME EQ 'Y.CAPITAL' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<7,POS1>
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"18R,2")
        RETURN
    END
    IF Y.FIELD.NAME EQ 'Y.INTEREST' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<8,POS1>
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"18R,2")
        RETURN
    END
    IF Y.FIELD.NAME EQ 'Y.CHARGE' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<9,POS1>
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"18R,2")
        RETURN
    END
    IF Y.FIELD.NAME EQ 'Y.MORA' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<10,POS1>
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"18R,2")
        RETURN
    END
    IF Y.FIELD.NAME EQ 'Y.BILLS.DATE' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<11,POS1>
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"29R")
        RETURN
    END
    IF Y.FIELD.NAME EQ 'Y.CAPITAL.BALANCE' THEN
        IF R.NEW(FT.TRANSACTION.TYPE) MATCHES 'ACPO':@VM:'ACQP' THEN ;*AUTO R22 CODE CONVERSION
            Y.RETURN.VALUE = FMT("0","18R,2")
            RETURN
        END

        Y.INFO.ID = FIELD(GET.TXN.ID,'-',1)

*    READ R.INFO.ARRAY FROM F.REDO.CASHIER.DEALSLIP.INFO, Y.INFO.ID THEN ;*Tus Start
        CALL F.READ(FN.REDO.CASHIER.DEALSLIP.INFO,Y.INFO.ID,R.INFO.ARRAY,F.REDO.CASHIER.DEALSLIP.INFO,R.INFO.ARRAY.ERR)
        IF R.INFO.ARRAY THEN  ;* Tus End

        END

        IF R.INFO.ARRAY THEN
            Y.RETURN.VALUE = R.DEAL.ARRAY<12,POS1>
            Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"18R,2")
        END ELSE
            GOSUB GET.CAPITAL.BALANCE   ;* Here we will get the capital balance of the loan. if deal slip is prited for the first time then we will calculate the amount using Core API else we will get the amount from concat table. Because during AUTH stage of the FT, we wont have the updated balances in ECB.

        END

        RETURN
    END
    IF Y.FIELD.NAME EQ 'Y.CUR.TIME' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<13,POS1>
        Y.RETURN.VALUE1 =Y.RETURN.VALUE[1,5]
        Y.RETURN.VALUE2 =Y.RETURN.VALUE[10,20]
        Y.RETURN.VALUE=Y.RETURN.VALUE2:"-":Y.RETURN.VALUE1
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"17R")

*** FORMATO DE FECHA
        RETURN
    END
    GOSUB GET.VALUES.1
RETURN
*-----------------------------------------------------------------------------
GET.VALUES.1:
*-----------------------------------------------------------------------------

    IF Y.FIELD.NAME EQ 'Y.COMPANY.DETAILS' THEN
        Y.CMP.LEN = LEN(R.COMPANY(EB.COM.COMPANY.NAME))
        IF Y.CMP.LEN GT 20 THEN
            Y.COMPANY.NAME = R.COMPANY(EB.COM.COMPANY.NAME)[1,20]
        END ELSE
            Y.COMPANY.NAME = R.COMPANY(EB.COM.COMPANY.NAME)
        END
        Y.RETURN.VALUE = R.DEAL.ARRAY<14,POS1>
        Y.RETURN.VALUE = Y.COMPANY.NAME:Y.RETURN.VALUE[10,13]
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"26R")
        RETURN
    END
    IF Y.FIELD.NAME EQ 'Y.CASH.SPENT' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<15,POS1>
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"18R,2")
        RETURN
    END
    IF Y.FIELD.NAME EQ 'Y.ACCOUNT.DEBIT.SPENT' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<16,POS1>
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"12R,2")
        RETURN
    END
    IF Y.FIELD.NAME EQ 'Y.CHEQUE.SPENT' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<17,POS1>
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"18R,2")
        RETURN
    END
    IF Y.FIELD.NAME EQ 'NO.OF.CHEQUES'  THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<18,POS1>
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"3R")
        RETURN
    END
    IF Y.FIELD.NAME EQ 'NCF.NUMBER' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<19,POS1>
        RETURN
    END
    IF Y.FIELD.NAME EQ 'NCF.AMOUNT' THEN
        Y.RETURN.VALUE = R.DEAL.ARRAY<20,POS1>
        Y.RETURN.VALUE = FMT(Y.RETURN.VALUE,"15L,2")
        RETURN
    END
    IF Y.FIELD.NAME EQ 'NEXT.PAY.AMOUNT' THEN

        Y.RETURN.VALUE = R.DEAL.ARRAY<21,POS1>
        IF Y.RETURN.VALUE THEN
            Y.INFO.ID = FIELD(GET.TXN.ID,'-',1)
*      READ R.INFO.ARRAY FROM F.REDO.CASHIER.DEALSLIP.INFO, Y.INFO.ID THEN       ;* During first print of the dealslip we will not have any value in the record. ;*Tus Start
            CALL F.READ(FN.REDO.CASHIER.DEALSLIP.INFO,Y.INFO.ID,R.INFO.ARRAY,F.REDO.CASHIER.DEALSLIP.INFO,R.INFO.ARRAY.ERR)
            IF R.INFO.ARRAY THEN        ;* Tus End
            END
            IF R.INFO.ARRAY THEN
                Y.RETURN.VALUE = 'Para el proximo mes su nueva cuota sera de RD$':FMT(R.DEAL.ARRAY<21,POS1>,'L2,')
            END ELSE
                GOSUB GET.NEXT.REPAYMENT.AMT
            END
        END
        RETURN
    END

RETURN
*-----------------------------------------------------------------------------

*** <region name= GET.CAPITAL.BALANCE>
GET.CAPITAL.BALANCE:
*** <desc>Here we will get the capital balance of the loan. if deal slip is prited for the first time then we will calculate the amount using Core API else we will get the amount from concat table. Because during AUTH stage of the FT, we wont have the updated balances in ECB.</desc>
    Y.LOAN.ACC = R.DEAL.ARRAY<2,POS1>
    Y.BALANCE.TO.CHECK = 'ACCBALSINUNCUND'
    Y.TODAY            = TODAY
    CALL AA.GET.ECB.BALANCE.AMOUNT(Y.LOAN.ACC,Y.BALANCE.TO.CHECK,Y.TODAY,BALANCE.AMOUNT,RET.ERROR)
    Y.CAPITAL.BALANCE = ABS(BALANCE.AMOUNT)
    Y.RETURN.VALUE = FMT(Y.CAPITAL.BALANCE,"18R,2")
    R.REDO.CASHIER.DEALSLIP.INFO<12,POS1> = Y.CAPITAL.BALANCE

*  WRITE R.REDO.CASHIER.DEALSLIP.INFO TO F.REDO.CASHIER.DEALSLIP.INFO, GET.TXN.ID ;*Tus Start
    CALL F.WRITE(FN.REDO.CASHIER.DEALSLIP.INFO,GET.TXN.ID,R.REDO.CASHIER.DEALSLIP.INFO)   ;*Tus end

RETURN
*-----------------------------------------------------------------------------
GET.NEXT.REPAYMENT.AMT:
*-----------------------------------------------------------------------------
* Here we will get the next repayment amount using the schedule projector routine.if deal slip is prited for the first time then we will calculate the amount using Core API else we will get the amount from concat table.
    Y.LOAN.ACC = R.DEAL.ARRAY<2,POS1>
    ARR.ID     = ""
*APAP.TAM.REDO.CONVERT.ACCOUNT(Y.LOAN.ACC,"",ARR.ID,ERR.TEXT)
    APAP.TAM.redoConvertAccount(Y.LOAN.ACC,"",ARR.ID,ERR.TEXT) ;* R22 manual conversion
    Y.NEXT.PAY.AMT = ''
    SIMULATION.REF = ''
    NO.RESET       = '1'
    YREGION        = ''
    DATE.RANGE     = ""       ;* Date range is passed for 2 years to avoid building schedule for whole loan term
*CALL AA.SCHEDULE.PROJECTOR(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)
*AA.PaymentScheule.ScheduleProjector(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)
    AA.PaymentSchedule.ScheduleProjector(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)
    GOSUB GET.NEXT.AMOUNT
    Y.RETURN.VALUE = 'Para el proximo mes su nueva cuota sera de RD$':FMT(Y.NEXT.PAY.AMT,'L2,')
    R.DEAL.ARRAY<21,POS1> = Y.NEXT.PAY.AMT

*  WRITE R.REDO.CASHIER.DEALSLIP.INFO TO F.REDO.CASHIER.DEALSLIP.INFO, GET.TXN.ID ;*Tus Start
    CALL F.WRITE(FN.REDO.CASHIER.DEALSLIP.INFO,GET.TXN.ID,R.REDO.CASHIER.DEALSLIP.INFO)
    CALL JOURNAL.UPDATE('')   ;*Tus end
RETURN
*----------------------------------------------------------------------------------
GET.NEXT.AMOUNT:
*----------------------------------------------------------------------------------
    Y.DATES.CNT = DCOUNT(PAYMENT.DATES,@FM) ;*AUTO R22 CODE CONVERSION
    Y.VAR3=1
    LOOP
    WHILE Y.VAR3 LE Y.DATES.CNT
        Y.PAY.DATE = PAYMENT.DATES<Y.VAR3>
        IF Y.PAY.DATE GT TODAY THEN
            Y.NEXT.PAY.AMT = TOT.PAYMENT<Y.VAR3>
            Y.VAR3 = Y.DATES.CNT+1
        END
        Y.VAR3 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

RETURN

END
