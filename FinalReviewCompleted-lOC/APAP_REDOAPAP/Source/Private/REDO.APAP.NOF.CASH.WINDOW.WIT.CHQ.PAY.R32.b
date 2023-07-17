* @ValidationCode : MjotNTA3MDYwNzM2OkNwMTI1MjoxNjgxNzE3NjE3MDg5OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Apr 2023 13:16:57
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.WIT.CHQ.PAY.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.WIT.CHQ.PAY.R32
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.WIT.CHQ.PAY is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.WIT.SAV.CUR, this routine is used to fetch the CHEQUE PAYMENT
*                    details of WITHDRAWALS from the TELLER transactions
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.WIT
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*                    TELLER.ID      - Holds the teller ID
*                    Y.TT.PARAM.REC - Holds the teller and parameter records
*                    R.REDO.H.TELLER.TXN.CODES - The teller transaction code details record
*Out Parameter     : Y.FINAL.ARRAY  - THe final Array to be passed out
*                    Y.CCY.LIST     - This variable holds the processed currency list
*                    Y.TT.LIST      - This variable holds the processed TELLER records
*Files  Used       : TELLER                           As              I               Mode
*                    CERTIFIED.CHEQUE.DETAILS         As              I               Mode
*                    REDO.ADMIN.CHQ.DETAILS           As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 15 JUN 2011       marimuthu s             ODR-2011-04-0007 32         CHANGES MADE IN REDO.APAP.NOF.CASH.WINDOW.WIT.CHQ.PAY
* 15 Sep 2011       Riyas                        PACS00126012               use category instead of checking account number
*                                                                           in ADMIN CHEQUE DETAILS Table.
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FMto@FM,VMto@VM
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CERTIFIED.CHEQUE.DETAILS
    $INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
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
    FN.CERTIFIED.CHEQUE.DETAILS = 'F.CERTIFIED.CHEQUE.DETAILS'
    F.CERTIFIED.CHEQUE.DETAILS  = ''
    CALL OPF(FN.CERTIFIED.CHEQUE.DETAILS,F.CERTIFIED.CHEQUE.DETAILS)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.HST='F.ACCOUNT$HIS'
    F.ACCOUNT.HST=''
    CALL OPF(FN.ACCOUNT.HST,F.ACCOUNT.HST)

    FN.REDO.ADMIN.CHQ.DETAILS = 'F.REDO.ADMIN.CHQ.DETAILS'
    F.REDO.ADMIN.CHQ.DETAILS  = ''
    CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)
RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    Y.CERT.CHQ = '' ; Y.ADMIN.CHQ = ''
    R.TELLER                     = FIELD(Y.TT.PARAM.REC,'##',1)
    R.REDO.ADMIN.CHQ.PARAM       = FIELD(Y.TT.PARAM.REC,'##',2)
    R.REDO.MANAGER.CHQ.PARAM     = FIELD(Y.TT.PARAM.REC,'##',3)
    R.CERTIFIED.CHEQUE.PARAMETER = FIELD(Y.TT.PARAM.REC,'##',4)
    R.REDO.H.TELLER.TXN.CODES = FIELD(Y.TT.PARAM.REC,'##',5)

    GOSUB FIND.MULTI.LOCAL.REF
    Y.ACCOUNT.LIST = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT>
    Y.CHQ.PAYWDL = Y.ACCOUNT.LIST
    CHANGE @VM TO @FM IN Y.CHQ.PAYWDL

    YG.ACCOUNT.LIST = R.CERTIFIED.CHEQUE.PARAMETER<CERT.CHEQ.ACCOUNT.NO>
    Y.CHQ.CERTWDL = YG.ACCOUNT.LIST
    CHANGE @VM TO @FM IN Y.CHQ.CERTWDL

    Y.TT.CCY  = R.TELLER<TT.TE.CURRENCY.1>
    YTT.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>
    Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
    IF YTT.MARKER EQ 'CREDIT' AND R.TELLER<TT.TE.CURRENCY.1> NE LCCY THEN
        Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
    END
    IF NOT(Y.TT.AMT) THEN
        IF Y.TT.CCY EQ LCCY THEN
            Y.TT.AMT  = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
        END ELSE
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
        END
    END
    IF R.TELLER<TT.TE.LOCAL.REF,LOC.CERT.CHEQUE.NO.POS> THEN
        GOSUB GET.CERT.CHQ.DETAILS
        RETURN
    END
    Y.CACC.POS = ''; YH.CACC.POS = ''
    LOCATE R.TELLER<TT.TE.ACCOUNT.1> IN Y.CHQ.PAYWDL<1> SETTING Y.CACC.POS ELSE
        LOCATE R.TELLER<TT.TE.ACCOUNT.2> IN Y.CHQ.PAYWDL<1> SETTING YH.CACC.POS ELSE
            RETURN
        END
    END
    IF R.TELLER<TT.TE.CHEQUE.NUMBER> THEN
        GOSUB GET.ADMIN.CHQ.DETAILS
    END
RETURN
*--------------------------------------------------------------------------------------------------------
*********************
GET.CERT.CHQ.DETAILS:
*********************
* In this para of the code, the CERTIFIED CHEQUE details are being processed
    Y.CACC.POS = ''; YH.CACC.POS = ''

    LOCATE R.TELLER<TT.TE.ACCOUNT.1> IN Y.CHQ.CERTWDL<1> SETTING Y.CACC.POS ELSE
        LOCATE R.TELLER<TT.TE.ACCOUNT.2> IN Y.CHQ.CERTWDL<1> SETTING YH.CACC.POS ELSE
            RETURN
        END
    END

    CERTIFIED.CHEQUE.DETAILS.ID = R.TELLER<TT.TE.LOCAL.REF,LOC.CERT.CHEQUE.NO.POS>
    GOSUB READ.CERTIFIED.CHEQUE.DETAILS
    IF NOT(R.CERTIFIED.CHEQUE.DETAILS) THEN
        RETURN
    END

    Y.CERT.CHQ     = 1
    GOSUB CHECK.ACCOUNTS
RETURN
*--------------------------------------------------------------------------------------------------------
**********************
GET.ADMIN.CHQ.DETAILS:
**********************
* In this para of the code, the ADMIN CHEQUE details are being processed

    Y.CHQ.COUNT = DCOUNT(R.TELLER<TT.TE.CHEQUE.NUMBER>,@VM)
    Y.CHQ.START = 1

    LOOP
    WHILE Y.CHQ.START LE Y.CHQ.COUNT
        REDO.ADMIN.CHQ.DETAILS.ID = R.TELLER<TT.TE.CHEQUE.NUMBER,Y.CHQ.START>
        GOSUB READ.REDO.ADMIN.CHQ.DETAILS
        IF NOT(R.REDO.ADMIN.CHQ.DETAILS) THEN
            CONTINUE
        END
        Y.CHQ.START += 1
    REPEAT

    Y.ADMIN.CHQ    = 1
    GOSUB CHECK.ACCOUNTS
RETURN
*--------------------------------------------------------------------------------------------------------
***************
CHECK.ACCOUNTS:
***************
* In this para of the code, the ACCOUNT.1 and ACCOUNT.2 of the TELLER record are checked
    IF Y.ADMIN.CHQ THEN
        Y.VM.POS = 21
    END ELSE
        Y.VM.POS = 22
    END

    IF NOT(Y.VM.POS) THEN
        RETURN
    END

    Y.ADD.AMT = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
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

    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4>  += Y.ADD.AMT

    Y.TT.LIST<-1> = TELLER.ID
RETURN
*--------------------------------------------------------------------------------------------------------
******************************
READ.CERTIFIED.CHEQUE.DETAILS:
******************************
* In this para of the code, file CERTIFIED.CHEQUE.DETAILS is read
    R.CERTIFIED.CHEQUE.DETAILS  = '';    CERTIFIED.CHEQUE.DETAILS.ER = ''
    CALL F.READ(FN.CERTIFIED.CHEQUE.DETAILS,CERTIFIED.CHEQUE.DETAILS.ID,R.CERTIFIED.CHEQUE.DETAILS,F.CERTIFIED.CHEQUE.DETAILS,CERTIFIED.CHEQUE.DETAILS.ER)
RETURN
*--------------------------------------------------------------------------------------------------------
****************************
READ.REDO.ADMIN.CHQ.DETAILS:
****************************
* In this para of the code, file REDO.ADMIN.CHQ.DETAILS is read
    R.REDO.ADMIN.CHQ.DETAILS  = '';    REDO.ADMIN.CHQ.DETAILS.ER = ''
    CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,REDO.ADMIN.CHQ.DETAILS.ID,R.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,REDO.ADMIN.CHQ.DETAILS.ER)
RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'TELLER'
    FLD.ARRAY  = 'CERT.CHEQUE.NO':@VM:'L.DEBIT.AMOUNT':@VM:'L.CREDIT.AMOUNT'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.CERT.CHEQUE.NO.POS  =  FLD.POS<1,1>
    LOC.L.DEBIT.AMOUNT.POS = FLD.POS<1,2>
    LOC.L.CREDIT.AMOUNT.POS = FLD.POS<1,3>
RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
