* @ValidationCode : Mjo3NjY2NDQyOTpDcDEyNTI6MTY4NDgzNjA0NjIyMDpJVFNTOi0xOi0xOjQ5ODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 498
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.WIT.CHQ.PAY(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,R.REDO.H.TELLER.TXN.CODES,Y.FINAL.ARRAY,Y.TT.LIST)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.WIT.CHQ.PAY
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
* 17 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
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

    R.TELLER                     = FIELD(Y.TT.PARAM.REC,'$',1)
    R.REDO.ADMIN.CHQ.PARAM       = FIELD(Y.TT.PARAM.REC,'$',2)
    R.REDO.MANAGER.CHQ.PARAM     = FIELD(Y.TT.PARAM.REC,'$',3)
    R.CERTIFIED.CHEQUE.PARAMETER = FIELD(Y.TT.PARAM.REC,'$',4)

    GOSUB FIND.MULTI.LOCAL.REF
    Y.CASH.CATEG = R.REDO.H.TELLER.TXN.CODES<TT.TXN.CASH.ACC.CATEG>
    CHANGE @VM TO @FM IN Y.CASH.CATEG

    Y.TT.CCY  = R.TELLER<TT.TE.CURRENCY.1>
    IF Y.TT.CCY EQ LCCY THEN
        Y.TT.AMT  = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
    END ELSE
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
    END

    IF R.TELLER<TT.TE.LOCAL.REF,LOC.CERT.CHEQUE.NO.POS> THEN
        GOSUB GET.CERT.CHQ.DETAILS
        RETURN
    END

    LOCATE TELLER.ID IN Y.TT.LIST SETTING POS.CK.DF ELSE
        IF R.TELLER<TT.TE.CHEQUE.NUMBER> THEN
            GOSUB GET.ADMIN.CHQ.DETAILS
        END
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
GET.CERT.CHQ.DETAILS:
*********************
* In this para of the code, the CERTIFIED CHEQUE details are being processed

    CERTIFIED.CHEQUE.DETAILS.ID = R.TELLER<TT.TE.LOCAL.REF,LOC.CERT.CHEQUE.NO.POS>
    GOSUB READ.CERTIFIED.CHEQUE.DETAILS

    IF NOT(R.CERTIFIED.CHEQUE.DETAILS) THEN
        RETURN
    END

    IF R.CERTIFIED.CHEQUE.DETAILS<CERT.DET.STATUS> NE 'PAID' THEN
        RETURN
    END

    Y.ACCOUNT.LIST = R.CERTIFIED.CHEQUE.PARAMETER<CERT.CHEQ.ACCOUNT.NO>
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
        GOSUB CHECK.ADMIN.CHQ.DETAILS
        Y.CHQ.START += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
************************
CHECK.ADMIN.CHQ.DETAILS:
************************
* In this para of the code, the ADMIN CHEQUE details are cross checked for status and other fields

    IF NOT(R.REDO.ADMIN.CHQ.DETAILS) THEN
        RETURN
    END

    IF R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.PAID.DATE> NE TODAY THEN
        RETURN
    END

    IF R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS> NE 'PAID' THEN
        RETURN
    END

    Y.ACCOUNT.LIST = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT>
    Y.ADMIN.CHQ    = 1

    GOSUB CHECK.ACCOUNTS

RETURN
*--------------------------------------------------------------------------------------------------------
***************
CHECK.ACCOUNTS:
***************
* In this para of the code, the ACCOUNT.1 and ACCOUNT.2 of the TELLER record are checked

    CHANGE @VM TO @FM IN Y.ACCOUNT.LIST

    Y.DR.CR.MARK = R.TELLER<TT.TE.DR.CR.MARKER>
    Y.ACC.ID = Y.ACCOUNT.LIST<1>

*PACS00126012-S

*Get cash Account category
    Y.CASH.CATEGORY.1 = R.TELLER<TT.TE.ACCOUNT.1>[4,5]

    Y.CASH.CATEGORY.2 = R.TELLER<TT.TE.ACCOUNT.2>[4,5]

*Get admin cheque Account category

    R.ACCOUNT  = ''
    ACCOUNT.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.CHQ.CATEGORY = R.ACCOUNT<AC.CATEGORY>

*PACS00126012-E

    IF Y.DR.CR.MARK EQ 'DEBIT' THEN
        LOCATE Y.CASH.CATEGORY.1 IN Y.CHQ.CATEGORY SETTING Y.ACC.POS ELSE
            RETURN
        END

        LOCATE R.TELLER<TT.TE.ACCOUNT.2>[4,5] IN Y.CASH.CATEG<1> SETTING Y.CACC.POS ELSE
            RETURN
        END
    END

    IF Y.DR.CR.MARK EQ 'CREDIT' THEN
        LOCATE Y.CASH.CATEGORY.2 IN Y.CHQ.CATEGORY SETTING Y.ACC.POS ELSE
            RETURN
        END

        LOCATE R.TELLER<TT.TE.ACCOUNT.1>[4,5] IN Y.CASH.CATEG<1> SETTING Y.CACC.POS ELSE
            RETURN
        END
    END

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
    R.CERTIFIED.CHEQUE.DETAILS  = ''
    CERTIFIED.CHEQUE.DETAILS.ER = ''
    CALL F.READ(FN.CERTIFIED.CHEQUE.DETAILS,CERTIFIED.CHEQUE.DETAILS.ID,R.CERTIFIED.CHEQUE.DETAILS,F.CERTIFIED.CHEQUE.DETAILS,CERTIFIED.CHEQUE.DETAILS.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
****************************
READ.REDO.ADMIN.CHQ.DETAILS:
****************************
* In this para of the code, file REDO.ADMIN.CHQ.DETAILS is read
    R.REDO.ADMIN.CHQ.DETAILS  = ''
    REDO.ADMIN.CHQ.DETAILS.ER = ''
    CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,REDO.ADMIN.CHQ.DETAILS.ID,R.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,REDO.ADMIN.CHQ.DETAILS.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'TELLER'
    FLD.ARRAY  = 'CERT.CHEQUE.NO'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.CERT.CHEQUE.NO.POS  =  FLD.POS<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
