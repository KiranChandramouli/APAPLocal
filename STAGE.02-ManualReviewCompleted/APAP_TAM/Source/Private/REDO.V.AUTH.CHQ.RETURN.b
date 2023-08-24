* @ValidationCode : Mjo0MTE4MTQyMzA6Q3AxMjUyOjE2ODI1MTg4ODA1Nzc6SVRTUzotMTotMTozNjY6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Apr 2023 19:51:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 366
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,SM TO @SM, CONVERT TO CHANGE
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.V.AUTH.CHQ.RETURN
*------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This routine is used to authorise the CHEQUE.COLLECTION records and creation of Funds transfer
*               records through ofs for RETURNED cheques
*------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.V.AUTH.CHQ.RETURN
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 26-Jul-2010      Naveenkumar N    ODR-2010-02-0290              Initial creation
*----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CHEQUE.COLLECTION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.H.CHECK.CLEARING.SCREEN
*
    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    FN.REDO.H.CHECK.CLEARING.SCREEN = "F.REDO.H.CHECK.CLEARING.SCREEN"
    F.REDO.H.CHECK.CLEARING.SCREEN = ""
    R.REDO.H.CHECK.CLEARING.SCREEN = ""
    E.REDO.H.CHECK.CLEARING.SCREEN = ""
    CALL OPF(FN.REDO.H.CHECK.CLEARING.SCREEN,F.REDO.H.CHECK.CLEARING.SCREEN)
*
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    R.ACCOUNT = ""
    E.ACCOUNT = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
    Y.ONE = "1"
RETURN
*
********
PROCESS:
********
    CHQ.ID = ID.NEW
    TELLER.ID = R.NEW(CHQ.COL.TXN.ID)
    CALL F.READ(FN.REDO.H.CHECK.CLEARING.SCREEN,TELLER.ID,R.REDO.H.CHECK.CLEARING.SCREEN,F.REDO.H.CHECK.CLEARING.SCREEN,E.REDO.H.CHECK.CLEARING.SCREEN)
    IF R.REDO.H.CHECK.CLEARING.SCREEN THEN

        TELLER.ARRAY = R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.INIT.DEP.REF>
        CHQ.ARRAY =    R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.CHECK.NO>
        CR.ACCOUNT.ARRAY = R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.CR.ACCOUNT>
        DR.ACCOUNT.ARRAY = R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.ACCOUNT.NO>

        LOCATE TELLER.ID IN TELLER.ARRAY<1,1> SETTING TELLER.POS THEN
            TT.CC.LIST = CHQ.ARRAY<1,TELLER.POS>
            TT.CC.CR.ACCT = CR.ACCOUNT.ARRAY<1,TELLER.POS>
            TT.CC.DR.ACCT = DR.ACCOUNT.ARRAY<1,TELLER.POS>
*
            CHANGE @SM TO @VM IN TT.CC.LIST ;*R22 AUTO CONVERSION
*
            LOCATE CHQ.ID IN TT.CC.LIST<1,1> SETTING CCS.POS THEN
                CR.ACCOUNT = TT.CC.CR.ACCT<1,TELLER.POS,CCS.POS>
                CR.AMOUNT = R.NEW(CHQ.COL.AMOUNT)
                DR.ACCOUNT = TT.CC.DR.ACCT
                CR.CCY = CR.ACCOUNT[1,3]
                Y.DEBIT.VALUE.DATE = TODAY
                GOSUB AC.READ
                GOSUB FT.CREATION
            END
        END
    END
RETURN
********
AC.READ:
********
    CALL F.READ(FN.ACCOUNT,DR.ACCOUNT,R.ACCOUNT,F.ACCOUNT,E.ACCOUNT)
    Y.ORDERING.CUST = R.ACCOUNT<AC.CUSTOMER>
RETURN
************
FT.CREATION:
************
    OFS.FT.STR = 'FUNDS.TRANSFER,CHQ.RETURN/I/PROCESS,/,,REF.NO:1:1=':',DEBIT.ACCT.NO:1:1:=':DR.ACCOUNT:',CREDIT.AMOUNT:1:1:=':CR.AMOUNT:',CREDIT.ACCT.NO:1:1:=':CR.ACCOUNT:',CREDIT.CURRENCY:1:1:=':CR.CCY:',DEBIT.VALUE.DATE:1:1:=':Y.DEBIT.VALUE.DATE:',ORDERING.CUST:1:1:=':Y.ORDERING.CUST
    OFS.FT.SRC = 'CHQ.OFS'
    OFS.MSG.ID = ""
    OPTIONS = ""
    CALL OFS.POST.MESSAGE(OFS.FT.STR,OFS.MSG.ID,OFS.FT.SRC,OPTIONS)
RETURN
END
