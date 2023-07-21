* @ValidationCode : MjoxNjAyMjY1NDQ5OkNwMTI1MjoxNjg5NzY2MjQ2NDMzOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Jul 2023 17:00:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP.LOOP.MTS(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,R.REDO.H.TELLER.TXN.CODES,Y.FINAL.ARRAY,Y.TT.LIST)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP.LOOP.MTS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DEP.LOOP.MTS is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.DEP, this routine is used to fetch the term instrument openings
*                    and LOAN payment details
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DEP
*In  Parameter     : R.REDO.H.TELLER.TXN.CODES - The record of REDO.H.TELLER.TXN.CODES
*                    Y.CCY.LIST - This variable holds the processed currency list
*Out Parameter     : Y.FINAL.ARRAY - THe final Array to be passed out
*                    Y.CCY.LIST - This variable holds the processed currency list
*Files  Used       : MULTI.TRANSACTION.SERVICE             As              I               Mode
*                    AA.ARRANGEMENT                        As              I               Mode
*                    TELLER                                As              I               Mode
*                    FUNDS.TRANSFER                        As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 16 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
* 25 May 2011       Marimuthu S                 ODR-2010-03-0086 35         Changes made for loan Payment
* 24 Aug 2011       Pradeep S                   PACS00106559                More product group considered as per setup
* 25 AUG 2011       Jeeva T                     PACS00106559
*13/07/2023      Conversion tool            R22 Auto Conversion           FM TO @FM, VM TO @VM, F.READ TO CACHE.READ
*13/07/2023      Suresh                     R22 Manual Conversion         Variable initialised
*************************************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
* $INCLUDE TAM.BP I_F.MULTI.TRANSACTION.SERVICE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.PRODUCT.GROUP
    $INSERT I_F.REDO.H.TELLER.TXN.CODES
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB OPEN.PARA

    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
*  FN.MULTI.TRANSACTION.SERVICE = 'F.MULTI.TRANSACTION.SERVICE'
*  F.MULTI.TRANSACTION.SERVICE  = ''
*  CALL OPF(FN.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.TELLER = 'F.TELLER'
    F.TELLER  = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.PRD.GRP = 'F.AA.PRODUCT.GROUP'
    F.AA.PRD.GRP = ''
    CALL OPF(FN.AA.PRD.GRP,F.AA.PRD.GRP)


RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
*    GOSUB FORM.SEL.CMD
*    IF NOT(SEL.LIST.MTS) THEN
*        RETURN
*    END

*    GOSUB GET.DETAILS

    CALL F.READ(FN.TELLER,TELLER.ID,R.TELLER,F.TELLER,TEL.ERR)
    Y.TXN.CODE.LN = R.TELLER<TT.TE.TRANSACTION.CODE>
    Y.SET.LOAN = ''
    
    TT.TXN.LOAN.PYMT.CASH='' ;*R22 Manual Conversion- Field is not available in REDO.H.TELLER.TXN.CODES
    TT.TXN.LOAN.PYMT.CHEQUE='' ;*R22 Manual Conversion- Field is not available in REDO.H.TELLER.TXN.CODES
    TT.TXN.LOAN.PYMT.TRANSFER='' ;*R22 Manual Conversion- Field is not available in REDO.H.TELLER.TXN.CODES

    Y.LOAN.PYMNT.CASH = R.REDO.H.TELLER.TXN.CODES<TT.TXN.LOAN.PYMT.CASH>
    Y.LOAN.PYMNT.CHQ = R.REDO.H.TELLER.TXN.CODES<TT.TXN.LOAN.PYMT.CHEQUE>
    Y.LOAN.PYMNT.TRANS = R.REDO.H.TELLER.TXN.CODES<TT.TXN.LOAN.PYMT.TRANSFER>
    Y.LOAN.PRD.GRP.LIST = R.REDO.H.TELLER.TXN.CODES<TT.TXN.LOAN.PRD.GRP>          ;* PACS00106559 - S/E

*PACS00106559 - S
    CHANGE @VM TO @FM IN Y.LOAN.PYMNT.CASH
    CHANGE @VM TO @FM IN Y.LOAN.PYMNT.CHQ
    CHANGE @VM TO @FM IN Y.LOAN.PYMNT.TRANS
*PACS00106559 - E

    LOCATE Y.TXN.CODE.LN IN Y.LOAN.PYMNT.CASH SETTING POS.CASH THEN
        Y.SET.LOAN = 'Y'
        CASH.SET = 'Y'
    END
    LOCATE Y.TXN.CODE.LN IN Y.LOAN.PYMNT.CHQ SETTING POS.CQ THEN
        Y.SET.LOAN = 'Y'
        CHQ.SET = 'Y'
    END
    LOCATE Y.TXN.CODE.LN IN Y.LOAN.PYMNT.TRANS SETTING POS.TRNS THEN
        Y.SET.LOAN = 'Y'
        TRANS.SET = 'Y'
    END
    IF Y.SET.LOAN EQ 'Y' THEN
        GOSUB CHECK.TELLER
        GOSUB CHECK.ARR.PRODUCT.GROUP

        GOSUB GET.AMOUNT
    END ELSE
        RETURN
    END

RETURN
*--------------------------------------------------------------------------------------------------------
CHECK.TELLER:
*--------------------------------------------------------------------------------------------------------
    Y.DR.CR.MARK = R.TELLER<TT.TE.DR.CR.MARKER>
    IF Y.DR.CR.MARK EQ 'DEBIT' THEN
        Y.TT.CCY  = R.TELLER<TT.TE.CURRENCY.2>
        Y.CRED.AC = R.TELLER<TT.TE.ACCOUNT.2>
        CALL F.READ(FN.ACCOUNT,Y.CRED.AC,R.ACCOUNT,F.ACCOUNT,AC.ERR)
        Y.AA.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
        CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)
        IF NOT(R.AA.ARRANGEMENT) THEN
            RETURN
        END ELSE
            IF R.TELLER<TT.TE.CURRENCY.2> EQ LCCY THEN
                Y.ADD.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.2,1>
            END ELSE
                Y.ADD.AMT = R.TELLER<TT.TE.AMOUNT.FCY.2>
            END
        END
    END
    IF Y.DR.CR.MARK EQ 'CREDIT' THEN
        Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>
        Y.CRED.AC = R.TELLER<TT.TE.ACCOUNT.1>
        CALL F.READ(FN.ACCOUNT,Y.CRED.AC,R.ACCOUNT,F.ACCOUNT,AC.ERR)
        Y.AA.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
        CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)
        IF NOT(R.AA.ARRANGEMENT) THEN
            RETURN
        END ELSE
            IF R.TELLER<TT.TE.CURRENCY.1> EQ LCCY THEN
                Y.ADD.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
            END ELSE
                Y.ADD.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
            END
        END
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*************
FORM.SEL.CMD:
*************
* In this para of the code, the SELECT command is formed to get the TELLER transactions IDs for processing

*    LOCATE 'AGENCY' IN D.FIELDS<1> SETTING Y.AGY.POS  THEN
*        Y.AGENCY = D.RANGE.AND.VALUE<Y.AGY.POS>
*    END

*    SEL.CMD.MTS = 'SELECT ':FN.MULTI.TRANSACTION.SERVICE:' WITH CO.CODE EQ ':Y.AGENCY
*    CALL EB.READLIST(SEL.CMD.MTS,SEL.LIST.MTS,'',NO.OF.REC.MTS,SEL.ERR.MTS)

RETURN
*--------------------------------------------------------------------------------------------------------
************
GET.DETAILS:
************
* In this para of the code, the GOSUBs to fetch all the details are written

*    LOOP
*        REMOVE MULTI.TRANSACTION.SERVICE.ID FROM SEL.LIST.MTS SETTING Y.MTS.POS
*    WHILE MULTI.TRANSACTION.SERVICE.ID : Y.MTS.POS
*        GOSUB READ.MULTI.TRANSACTION.SERVICE
*        GOSUB GET.LOAN.PAYMENT.DETAILS
*    REPEAT

*    RETURN
*--------------------------------------------------------------------------------------------------------
*************************
GET.LOAN.PAYMENT.DETAILS:
*************************
* In this para of the code, the MTS records are looped and checked if they satisfy the LOAN payment conditions

*    IF R.MULTI.TRANSACTION.SERVICE<REDO.MTS.OPERATION> EQ 'REPAYMENT' ELSE
*        RETURN
*    END
*    Y.MTS.ARR.ID = R.MULTI.TRANSACTION.SERVICE<REDO.MTS.ARR.ID>
*    Y.ARR.COUNT = DCOUNT(Y.MTS.ARR.ID,VM)
*    Y.ARR.START = 1

*    LOOP
*    WHILE Y.ARR.START LE Y.ARR.COUNT
*        GOSUB CHECK.ARR.PRODUCT.GROUP
*        IF NOT(Y.MORTGAGE) OR NOT(Y.COMERCIAL) OR NOT(Y.CONSUMO) ELSE
*            Y.ARR.START += 1
*            CONTINUE
*        END
*        GOSUB GET.AMOUNT
*        Y.ARR.START += 1
*    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
************************
CHECK.ARR.PRODUCT.GROUP:
************************
* In this para of the code, the ARRANGEMENT record is read and checkd for PRODUCT.GROUP
    Y.MORTGAGE = '' ; Y.COMERCIAL = '' ; Y.CONSUMO = ''

*    AA.ARRANGEMENT.ID = R.MULTI.TRANSACTION.SERVICE<REDO.MTS.ARR.ID,Y.ARR.START>
*    GOSUB READ.AA.ARRANGEMENT
*    IF NOT(R.AA.ARRANGEMENT) THEN
*        RETURN
*    END

    LOCATE R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP> IN Y.LOAN.PRD.GRP.LIST<1,1> SETTING GRP.POS THEN
        GOSUB GET.GRP.DESP
        BEGIN CASE
            CASE R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP> EQ 'HIPOTECARIO'
                Y.MORTGAGE = 1

            CASE R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP> EQ 'COMERCIAL'
                Y.COMERCIAL = 1

            CASE R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP> EQ 'CONSUMO'
                Y.CONSUMO = 1

            CASE 1
                Y.OTHER = 1
            END  CASE
        END

        RETURN
*--------------------------------------------------------------------------------------------------------

***************
GET.GRP.DESP:
***************
        Y.AA.PRD.GRP.ID = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
        R.AA.PRD.GRP = ''
        CALL CACHE.READ(FN.AA.PRD.GRP, Y.AA.PRD.GRP.ID, R.AA.PRD.GRP, ERR.GRP) ;*R22 Auto Conversion

        Y.PRD.GRP.DESP = R.AA.PRD.GRP<AA.PG.DESCRIPTION,2>
        IF NOT(Y.PRD.GRP.DESP) THEN
            Y.PRD.GRP.DESP = R.AA.PRD.GRP<AA.PG.DESCRIPTION,1>
        END

        RETURN

***********
GET.AMOUNT:
***********
* In this para of the code, the TT and FT records are read and the amounts are fetched
        Y.MORTGAGE.CASH = '' ; Y.MORTGAGE.CHQ = '' ; Y.MORTGAGE.TFR = ''

        IF CASH.SET EQ 'Y' THEN
            IF Y.MORTGAGE THEN
                Y.MORTGAGE.CASH = 1
                Y.VM.POS        = 11
                GOSUB AMEND.FINAL.ARRAY
            END

            IF Y.COMERCIAL THEN
                Y.COMERCIAL.CASH = 1
                Y.VM.POS         = 12
                GOSUB AMEND.FINAL.ARRAY
            END

            IF Y.CONSUMO THEN
                Y.CONSUMO.CASH = 1
                Y.VM.POS       = 13
                GOSUB AMEND.FINAL.ARRAY
            END

            IF Y.OTHER THEN

                Y.OTHER.CASH   = 1
                Y.OTR.LOAN     = FIELD(Y.FINAL.ARRAY,@VM,31,99)
                Y.OTR.LOAN.CNT = DCOUNT(Y.OTR.LOAN,@VM)
*---------------------JEEVA -PACS00106559--------------
                IF Y.OTR.LOAN THEN
                    Y.VM.POS       = 30 + Y.OTR.LOAN.CNT
                END ELSE
                    Y.VM.POS       = 30 + Y.OTR.LOAN.CNT + 1
                END
*--------------------JEEVA -ENDS-------------
                GOSUB AMEND.FINAL.ARRAY
            END


        END

        IF CHQ.SET EQ 'Y' THEN
            IF Y.MORTGAGE THEN
                Y.MORTGAGE.CHQ = 1
                Y.VM.POS        = 11
                GOSUB AMEND.FINAL.ARRAY
            END

            IF Y.COMERCIAL THEN
                Y.COMERCIAL.CHQ = 1
                Y.VM.POS        = 12
                GOSUB AMEND.FINAL.ARRAY
            END

            IF Y.CONSUMO THEN
                Y.CONSUMO.CHQ = 1
                Y.VM.POS      = 13
                GOSUB AMEND.FINAL.ARRAY
            END

            IF Y.OTHER THEN

                Y.OTHER.CHQ = 1
                Y.OTR.LOAN     = FIELD(Y.FINAL.ARRAY,@VM,31,99)
                Y.OTR.LOAN.CNT = DCOUNT(Y.OTR.LOAN,@VM)
*---------------------JEEVA -PACS00106559--------------
                IF Y.OTR.LOAN THEN
                    Y.VM.POS       = 30 + Y.OTR.LOAN.CNT
                END ELSE
                    Y.VM.POS       = 30 + Y.OTR.LOAN.CNT + 1
                END
*---------------------JEEVA -PACS00106559--------------
                GOSUB AMEND.FINAL.ARRAY
            END
        END

        IF TRANS.SET EQ 'Y' THEN
            IF Y.MORTGAGE THEN
                Y.MORTGAGE.TFR = 1
                Y.VM.POS        = 11
                GOSUB AMEND.FINAL.ARRAY
            END

            IF Y.COMERCIAL THEN
                Y.COMERCIAL.TFR = 1
                Y.VM.POS        = 12
                GOSUB AMEND.FINAL.ARRAY
            END

            IF Y.CONSUMO THEN
                Y.CONSUMO.TFR = 1
                Y.VM.POS      = 13
                GOSUB AMEND.FINAL.ARRAY
            END

            IF Y.OTHER THEN

                Y.OTHER.TFR = 1
                Y.OTR.LOAN     = FIELD(Y.FINAL.ARRAY,@VM,31,99)
                Y.OTR.LOAN.CNT = DCOUNT(Y.OTR.LOAN,@VM)
*---------------------JEEVA -PACS00106559--------------
                IF Y.OTR.LOAN THEN
                    Y.VM.POS       = 30 + Y.OTR.LOAN.CNT
                END ELSE
                    Y.VM.POS       = 30 + Y.OTR.LOAN.CNT + 1
                END
*---------------------JEEVA -PACS00106559--------------
                GOSUB AMEND.FINAL.ARRAY
            END

        END

        RETURN
*--------------------------------------------------------------------------------------------------------
******************
AMEND.FINAL.ARRAY:
******************
* In this para of the code, the Y.FINAL.ARRAY is amended with increment in the total number of transactions
** and the amount is added up

        LOCATE Y.TT.CCY IN Y.CCY.LIST<1> SETTING Y.CCY.POS ELSE
            Y.CCY.LIST<-1> = Y.TT.CCY
            Y.CCY.POS = DCOUNT(Y.CCY.LIST,@FM)
        END

        IF Y.MORTGAGE.CASH OR Y.COMERCIAL.CASH OR Y.CONSUMO.CASH OR Y.OTHER.CASH THEN
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4> += Y.ADD.AMT
        END
        IF Y.MORTGAGE.CHQ OR Y.COMERCIAL.CHQ OR Y.CONSUMO.CHQ OR Y.OTHER.CHQ THEN
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5> += Y.ADD.AMT
        END

        IF Y.MORTGAGE.TFR OR Y.COMERCIAL.TFR OR Y.CONSUMO.TFR OR Y.OTHER.TFR THEN
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6> += Y.ADD.AMT
        END

        IF Y.OTHER THEN
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,2> = Y.PRD.GRP.DESP
        END

        Y.TT.LIST<-1> = TELLER.ID

        RETURN
*--------------------------------------------------------------------------------------------------------
*******************************
READ.MULTI.TRANSACTION.SERVICE:
*******************************
* In this para of the code, file MULTI.TRANSACTION.SERVICE is read
        R.MULTI.TRANSACTION.SERVICE  = ''
        MULTI.TRANSACTION.SERVICE.ER = ''
        CALL F.READ(FN.MULTI.TRANSACTION.SERVICE,MULTI.TRANSACTION.SERVICE.ID,R.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE,MULTI.TRANSACTION.SERVICE.ER)

        RETURN
*--------------------------------------------------------------------------------------------------------
********************
READ.AA.ARRANGEMENT:
********************
* In this para of the code, file AA.ARRANGEMENT is read
        R.AA.ARRANGEMENT  = ''
        AA.ARRANGEMENT.ER = ''
        CALL F.READ(FN.AA.ARRANGEMENT,AA.ARRANGEMENT.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ER)

        RETURN
*--------------------------------------------------------------------------------------------------------
************
READ.TELLER:
************
* In this para of the code, file TELLER is read
        R.TELLER  = ''
        TELLER.ER = ''
        CALL F.READ(FN.TELLER,TELLER.ID,R.TELLER,F.TELLER,TELLER.ER)

        RETURN
*--------------------------------------------------------------------------------------------------------
********************
READ.FUNDS.TRANSFER:
********************
* In this para of the code, file FUNDS.TRANSFER is read
        R.FUNDS.TRANSFER  = ''
        FUNDS.TRANSFER.ER = ''
        CALL F.READ(FN.FUNDS.TRANSFER,FUNDS.TRANSFER.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ER)

        RETURN
*--------------------------------------------------------------------------------------------------------
    END       ;* End of Program
