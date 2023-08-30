* @ValidationCode : Mjo5MzgxMTIzMzg6Q3AxMjUyOjE2ODE3MjY3NjAyODE6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 15:49:20
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
SUBROUTINE REDO.APAP.NOF.FT.REVERSE.AUTH(Y.FIN.ARR)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.APAP.NOF.FT.REVERSE
* ODR NUMBER    : ODR-2010-03-0131
*-----------------------------------------------------------------------------
* Description   : This is nofile routine, will fetch the values to pass to enquiry
* In parameter  : none
* out parameter : Y.FIN.ARR
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  NO CHANGE
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*----------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.APAP.REVERSAL.FTTC

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB OPEN.FILES
    GOSUB GET.LOCAL.FIELD.POS
    GOSUB PROCESS
    GOSUB PROGRAM.END
RETURN

*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------



    FN.FUNDS.TRANSFER.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER.NAU  =''
    CALL OPF(FN.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU)


RETURN
*-----------------------------------------------------------------------------
GET.LOCAL.FIELD.POS:
*-----------------------------------------------------------------------------
    APPLN = 'FUNDS.TRANSFER'
    FIELD.NAMES = 'L.FT.ADD.INFO'
    CALL MULTI.GET.LOC.REF(APPLN,FIELD.NAMES,FIELD.POS)
    Y.POS.FT.CR = FIELD.POS<1,1>
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------



    CALL REDO.E.FORM.SEL.STMT(FN.FUNDS.TRANSFER.NAU, '', '', SEL.LIVE.CMD)
    IF D.RANGE.AND.VALUE THEN
        SEL.LIVE.CMD := ' AND PAYMENT.DETAILS LIKE ':'REVERSO-...'
    END
    IF NOT(D.RANGE.AND.VALUE) THEN
        SEL.LIVE.CMD := ' WITH PAYMENT.DETAILS LIKE ':'REVERSO-...'
    END

    CALL EB.READLIST(SEL.LIVE.CMD,SEL.FT.LIST,'',NO.OF.REC.LIVE.FT,SEL.FT.LIVE.ERR)

    LOOP
        REMOVE Y.FT.ID FROM SEL.FT.LIST SETTING POS.LIST
    WHILE Y.FT.ID:POS.LIST

        CALL F.READ(FN.FUNDS.TRANSFER.NAU,Y.FT.ID,R.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU,FT.NAU.ERR)

        GOSUB FT.LIVE.PROCESS


    REPEAT
RETURN
*-----------------------------------------------------------------------------
FT.LIVE.PROCESS:
*-----------------------------------------------------------------------------
    Y.TXN.CODE = R.FUNDS.TRANSFER.NAU<FT.TRANSACTION.TYPE>
    Y.DR.ACCT = R.FUNDS.TRANSFER.NAU<FT.DEBIT.ACCT.NO>
    Y.CR.ACCT = R.FUNDS.TRANSFER.NAU<FT.CREDIT.ACCT.NO>

    Y.FT.AMT = R.FUNDS.TRANSFER.NAU<FT.DEBIT.AMOUNT>
    IF NOT(Y.FT.AMT) THEN
        Y.FT.AMT = R.FUNDS.TRANSFER.NAU<FT.CREDIT.AMOUNT>
    END

    Y.FT.CUR = R.FUNDS.TRANSFER.NAU<FT.DEBIT.CURRENCY>
    IF NOT(Y.FT.CUR) THEN
        Y.FT.CUR = R.FUNDS.TRANSFER.NAU<FT.CREDIT.CURRENCY>
    END

    Y.FT.DATE  = R.FUNDS.TRANSFER.NAU<FT.PROCESSING.DATE>
    Y.FT.INP   = FIELD(R.FUNDS.TRANSFER.NAU<FT.INPUTTER>,'_',2)
    Y.FT.AUT   = FIELD(R.FUNDS.TRANSFER.NAU<FT.AUTHORISER>,'_',2)
    Y.FT.COM   = R.FUNDS.TRANSFER.NAU<FT.CO.CODE>

    Y.FIN.ARR<-1> = Y.FT.ID:'*':Y.DR.ACCT:'*':Y.CR.ACCT:'*':Y.FT.AMT:'*':Y.FT.CUR:'*':Y.FT.DATE:'*':Y.FT.INP:'*':Y.FT.AUT:'*':Y.FT.COM

RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------
END
