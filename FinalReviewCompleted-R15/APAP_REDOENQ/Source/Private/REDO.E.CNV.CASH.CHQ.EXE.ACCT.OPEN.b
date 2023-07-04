$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.CASH.CHQ.EXE.ACCT.OPEN
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : P.Senthilkumar
* Developed on : 18th Nov 2010
* Program Name : REDO.E.CON.CASH.CHQ.EXE.ACCT.OPEN
*------------------------------------------------------------------------------------------------------
* Description : This subroutine is attached as a conversion routine to the Enquiry "REDO.EXE.ACCT.OPEN"
* to get the initial credit payment mode of account either "CASH" or "CHEQUE"
*
*------------------------------------------------------
* Linked With : Enquiry REDO.EXE.ACCT.OPEN
* In Parameter : O.DATA(@ID - Account number)
* Out Parameter : O.DATA(Trancaction description)
*------------------------------------------------------
* Modification History:
*  DATE             WHO                   REFERENCE                  
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion  - F.READ to CACHE.READ and SM to @SM
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
*------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TRANSACTION
    $INSERT I_F.FT.TXN.TYPE.CONDITION

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-------
*
*---/Value assigned to "D.FIELDS" inorder to get the list of STMT.ENTRY ids and TRANS REFERENCE
*---/by calling the subroutine " E.STMT.ENQ.BY.CONCAT"
    Y.ACCOUNT.ID = O.DATA
    O.DATA = ''
    Y.NARATIVE = ''
    Y.OPENING.DATE = R.RECORD<AC.OPENING.DATE>
    D.FIELDS = ''
    Y.START.DATE = Y.OPENING.DATE
    Y.DATE = TODAY
    IF LEN(Y.DATE) EQ '8'  THEN
        CALL CDT('', Y.DATE,'+10W')

        D.FIELDS<1> = 'ACCOUNT'
        D.LOGICAL.OPERANDS<1> = 1
        D.RANGE.AND.VALUE<1> = Y.ACCOUNT.ID

        D.FIELDS<2> = 'BOOKING.DATE'
        D.LOGICAL.OPERANDS<2> = 2
        D.RANGE.AND.VALUE<2> = Y.START.DATE:@SM:Y.DATE
        GOSUB MAIN.PROCESS
    END
RETURN
*------------------------------------------------------------------------------------
MAIN.PROCESS:
*------------

    STMT.ID.LIST = ''
    CALL E.STMT.ENQ.BY.CONCAT(STMT.ID.LIST)

*---/Fetch the transreference id when the transaction amount is credit

    LOOP
        REMOVE Y.ID FROM STMT.ID.LIST SETTING POS
    WHILE Y.ID:POS
        Y.STMT.ENTRY.ID = FIELD(Y.ID,'*',2)
        CALL F.READ(FN.STMT.ENTRY,Y.STMT.ENTRY.ID,R.STMT.ENTRY.ID,F.STMT.ENTRY,Y.STMT.ERR)
        IF NOT(R.STMT.ENTRY.ID) THEN
            CALL F.READ(FN.STMT.ENTRY.DET,Y.STMT.ENTRY.ID,R.STMT.ENTRY.ID,F.STMT.ENTRY.DET,STMT.ENTRY.ERR)
        END
        Y.TRANS.REF = R.STMT.ENTRY.ID<AC.STE.TRANS.REFERENCE>
        Y.TXN.AMT   = FIELD(Y.ID,'*',6)
        IF Y.TXN.AMT GT 0 AND NOT(Y.NARATIVE) THEN
            IF Y.TRANS.REF[1,2]  EQ "TT" THEN
                Y.TT.ID = Y.TRANS.REF
                GOSUB PROCESS.TELLER
                O.DATA = Y.NARATIVE
            END
        END
    REPEAT
RETURN
*-----------------------------------------------------------------------------------------
PROCESS.TELLER:
*-------------*
*---/To extract the the narrative of the transaction whether cash or cheque

    CALL F.READ(FN.TELLER,Y.TT.ID,R.TELLER,F.TELLER,ERR.TELLER)
    IF R.TELLER THEN
        Y.CASHIER = R.TELLER<TT.TE.TELLER.ID.1>
        Y.TXN.CODE = R.TELLER<TT.TE.TRANSACTION.CODE>
        CALL CACHE.READ(FN.TRANSACTION, Y.TXN.CODE, R.TRANSACTION, ERR.TXN)    ;*R22 Auto Conversion  - F.READ to CACHE.READ
        Y.NARATIVE = R.TRANSACTION<AC.TRA.NARRATIVE>
    END ELSE
        Y.TT.HIS.ID = Y.TRANS.REF:";1"
        CALL F.READ(FN.TELLER.HIS,Y.TT.HIS.ID,R.TELLER.HIS,F.TELLER.HIS,ERR.TELLER.HIS)
        Y.CASHIER = R.TELLER.HIS<TT.TE.TELLER.ID.1>
        Y.TXN.CODE = R.TELLER.HIS<TT.TE.TRANSACTION.CODE>
        CALL CACHE.READ(FN.TRANSACTION, Y.TXN.CODE, R.TRANSACTION, ERR.TXN)      ;*R22 Auto Conversion  - F.READ to CACHE.READ
        Y.NARATIVE = R.TRANSACTION<AC.TRA.NARRATIVE>
    END
RETURN
*----------------------------------------------------------------------------------------
INIT:
*----
*
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)
*
    FN.STMT.ENTRY = "F.STMT.ENTRY"
    F.STMT.ENTRY  = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)
*
    FN.STMT.ENTRY.DET = "F.STMT.ENTRY.DETAIL"
    F.STMT.ENTRY.DET  = ''
    CALL OPF(FN.STMT.ENTRY.DET, F.STMT.ENTRY.DET)
*
    FN.TELLER = "F.TELLER"
    F.TELLER = ''
    CALL OPF(FN.TELLER, F.TELLER)
*
    FN.TELLER.HIS = "F.TELLER$HIS"
    F.TELLER.HIS = ''
    CALL OPF(FN.TELLER.HIS, F.TELLER.HIS)
*
    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER"
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)
*
    FN.FUNDS.TRANSFER.HIS = "F.FUNDS.TRANSFER$HIS"
    F.FUNDS.TRANSFER.HIS = ''
    CALL OPF(FN.FUNDS.TRANSFER.HIS, F.FUNDS.TRANSFER.HIS)
*
    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION = ''
    CALL OPF(FN.TRANSACTION, F.TRANSACTION)
*
    FN.FT.TXN.CON = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.CON = ''
    CALL OPF(FN.FT.TXN.CON, F.FT.TXN.CON)
*
RETURN
*-----------------------------------------------------------------------------------------
END
