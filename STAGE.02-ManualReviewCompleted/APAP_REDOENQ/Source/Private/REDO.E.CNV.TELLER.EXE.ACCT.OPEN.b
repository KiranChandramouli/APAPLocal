* @ValidationCode : MjotMTg0NDMyOTQ0MjpDcDEyNTI6MTY4MjA3MzM4MjkxNTpJVFNTOi0xOi0xOjExNTc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1157
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.TELLER.EXE.ACCT.OPEN
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : P.Senthilkumar
* Developed on : 18th Nov 2010
* Program Name : REDO.E.CON.TELLER.EXE.ACCT.OPEN
*---------------------------------------------------------

* Description : This subroutine is attached as a conversion routine to the Enquiry "REDO.EXE.ACCT.OPEN"
* to get the Teller number of the initial credit payment done to the account
*
*-----------------------------------------------------------------------------------------------------
* Linked With : Enquiry REDO.EXE.ACCT.OPEN
* In Parameter : O.DATA(@ID - Account number)
* Out Parameter : O.DATA(TELLER.ID)
*----------------------------------------------------------
* Modification History:
* DATE              WHO                REFERENCE                 DESCRIPTION
* 17-APR-2023     Conversion tool   R22 Auto conversion  	 SM to @SM
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*----------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TRANSACTION
    $INSERT I_F.FT.TXN.TYPE.CONDITION

    GOSUB INIT
    GOSUB PROCESS
    O.DATA = Y.CASHIER
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-------
*
*---/Value assigned to "D.FIELDS" inorder to get the list of STMT.ENTRY ids and TRANS REFERENCE
*---/by calling the subroutine " E.STMT.ENQ.BY.CONCAT"
    Y.ACCOUNT.ID = O.DATA
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
*---------------------------------------------------------------------
MAIN.PROCESS:
*-------------
    STMT.ID.LIST = ''
    CALL E.STMT.ENQ.BY.CONCAT(STMT.ID.LIST)

*---/Fetch the transreference id when the transaction amount is credit

    LOOP
        REMOVE Y.ID FROM STMT.ID.LIST SETTING POS
    WHILE Y.ID:POS
        Y.STMT.ID = FIELD(Y.ID,'*',2,1)
        CALL F.READ(FN.STMT.ENTRY,Y.STMT.ID,R.STMT.ENTRY.ID,F.STMT.ENTRY,Y.STMT.ERR)
        IF NOT(R.STMT.ENTRY.ID) THEN
            CALL F.READ(FN.STMT.ENTRY.DET,Y.STMT.ID,R.STMT.ENTRY.ID,F.STMT.ENTRY.DET,STMT.ENTRY.ERR)
        END
        Y.TRANS.REF = R.STMT.ENTRY.ID<AC.STE.TRANS.REFERENCE>
        Y.AMOUNT =  FIELD(Y.ID,'*',6,1)
        IF Y.AMOUNT GT 0 AND NOT(Y.CASHIER) THEN
            IF Y.TRANS.REF[1,2]  EQ "TT" THEN
                Y.TT.ID = Y.TRANS.REF
                GOSUB PROCESS.TELLER
            END
        END
    REPEAT
*
RETURN
*---------------------------------------------------------------------------------------
PROCESS.TELLER:
*-------------*
*---/To extract the TELLER ID of the transaction
*
    CALL F.READ(FN.TELLER,Y.TT.ID,R.TELLER,F.TELLER,ERR.TELLER)
    IF R.TELLER THEN
        Y.CASHIER = R.TELLER<TT.TE.TELLER.ID.1>
    END ELSE
        Y.TT.HIS.ID = Y.TRANS.REF:";1"
        CALL F.READ(FN.TELLER.HIS,Y.TT.HIS.ID,R.TELLER.HIS,F.TELLER.HIS,ERR.TELLER.HIS)
        Y.CASHIER = R.TELLER.HIS<TT.TE.TELLER.ID.1>
    END
    O.DATA = Y.CASHIER
RETURN
*----------------------------------------------------------------------------------------
INIT:
*----
*
    Y.CASHIER = ''

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)
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
    FN.TELLER.USER = 'F.TELLER.USER'
    F.TELLER.USER = ''
    CALL OPF(FN.TELLER.USER, F.TELLER.USER)

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY  = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.STMT.ENTRY.DET = "F.STMT.ENTRY.DETAIL"
    F.STMT.ENTRY.DET  = ''
    CALL OPF(FN.STMT.ENTRY.DET, F.STMT.ENTRY.DET)
*
RETURN
*-----------------------------------------------------------------------------------------
END
