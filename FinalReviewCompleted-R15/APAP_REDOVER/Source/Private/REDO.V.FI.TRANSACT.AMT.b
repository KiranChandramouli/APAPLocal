* @ValidationCode : MjoxODI3NDE0NDMwOkNwMTI1MjoxNjgyNDEyMzQ2NDE2OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE  REDO.V.FI.TRANSACT.AMT

*------------------------------------------------------------------------------------------------------------------
*  Company Name      : APAP Bank
*  Developed By      : Temenos Application Management
*  Program Name      : REDO.V.VAL.PARAM.ENCRIPT
*  Date              : 24.11.2010
*------------------------------------------------------------------------------------------------------------------
*Description:
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : --N/A--
* Out : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : --N/A--
* Called By : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date              Name              Reference                    Version
* -------           ----              ----------                   --------
* 24.11.2010       Joaquin Costa      ODR-2010-03-0025             Initial Version
*11-04-2023        Conversion Tool    R22 Auto Code conversion    FM TO @FM VM TO @VM
*11-04-2023         Samaran T         R22 Manual Code conversion     No Changes
*------------------------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
*
    $INSERT I_F.REDO.FI.LB.BPROC
*
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES

    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
    TRANSACTION.TYPE   = TRANSACTION.ID[1,2]
    TRANSACTION.AMOUNT = 0
    PARAM.TRANSACTION.AMT = R.NEW(REDO.FI.LB.BPROC.TRAN.AMOUNT)
    FILE.TOTAL.AMOUNT = ABS(R.NEW(REDO.FI.LB.BPROC.MONTO.TOTAL))
*
    BEGIN CASE
        CASE TRANSACTION.TYPE EQ 'TT'
            CALL F.READ(FN.TELLER,TRANSACTION.ID,R.TELLER,F.TELLER,YER.TT)
            IF NOT(R.TELLER) THEN
                ETEXT = "EB-Record.&.missing.in.table.&":@FM:TRANSACTION.ID:@VM:FN.TELLER
                AF = REDO.FI.LB.BPROC.TRANSACTION.ID
                CALL STORE.END.ERROR
            END ELSE
                TRANSACTION.AMOUNT = R.TELLER<TT.TE.AMOUNT.LOCAL.1> * 1
            END

        CASE TRANSACTION.TYPE EQ 'FT'
            CALL F.READ(FN.FUNDS.TRANSFER,TRANSACTION.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,YER.FT)
            IF NOT(R.FUNDS.TRANSFER) THEN
                ETEXT = "EB-Record.&.missing.in.table.&":TRANSACTION.ID:@VM:FN.FUNDS.TRANSFER
                AF = REDO.FI.LB.BPROC.TRANSACTION.ID
                CALL STORE.END.ERROR
            END ELSE
                IF R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT> THEN
                    TRANSACTION.AMOUNT = R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>
                END ELSE
                    TRANSACTION.AMOUNT = R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT> * 1
                END
            END

        CASE 1

            ETEXT = "EB-Invalid.Transaction.Reference":@FM:TRANSACTION.ID
            AF = REDO.FI.LB.BPROC.TRANSACTION.ID
            CALL STORE.END.ERROR

    END CASE

*
    IF TRANSACTION.AMOUNT NE PARAM.TRANSACTION.AMT THEN
        ETEXT = "EB-Amount.&.differs.from.transaction.amount.&":@FM:PARAM.TRANSACTION.AMT:@VM:TRANSACTION.AMOUNT
        AF = REDO.FI.LB.BPROC.TRAN.AMOUNT
        CALL STORE.END.ERROR
    END



    IF FILE.TOTAL.AMOUNT GT PARAM.TRANSACTION.AMT THEN

        ETEXT = "EB-Amount.&.Less.then.File.amount.&":@FM:PARAM.TRANSACTION.AMT:@VM:FILE.TOTAL.AMOUNT
        AF = REDO.FI.LB.BPROC.TRAN.AMOUNT
        CALL STORE.END.ERROR

    END
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD           = 0
    LOOP.CNT                  = 1
    MAX.LOOPS                 = 2
*

    PROCESS.GOAHEAD = 1
*
*   TELLER TRANSACTION TABLE
*
    FN.TELLER   = 'F.TELLER'
    F.TELLER    = ''
    R.TELLER    = ''
*
*   FUNDS.TRANSFER TABLE
*
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
    R.FUNDS.TRANSFER  = ''
*
*
*
    TRANSACTION.ID = R.NEW(REDO.FI.LB.BPROC.TRANSACTION.ID)

*
RETURN
*
* =========
OPEN.FILES:
* =========
*

RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1

                IF TRANSACTION.ID EQ ''  THEN
                    PROCESS.GOAHEAD = 0
                    AF = REDO.FI.LB.BPROC.TRANSACTION.ID
                    ETEXT = "EB-Transaction.ID.is.Mandatory"
                    CALL STORE.END.ERROR
                END

            CASE LOOP.CNT EQ 2

                IF COMI EQ ''  THEN
                    PROCESS.GOAHEAD = 0
                    AF = REDO.FI.LB.BPROC.TRAN.AMOUNT
                    ETEXT = "EB-Transaction.Amount.is.Mandatory"
                    CALL STORE.END.ERROR
                END

        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*
END
