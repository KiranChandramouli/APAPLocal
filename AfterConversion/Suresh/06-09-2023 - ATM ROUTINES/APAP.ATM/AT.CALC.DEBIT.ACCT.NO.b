* @ValidationCode : MjotMjA0MzQ1NjMwOkNwMTI1MjoxNjkzODkzNTAyMTQ5OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Sep 2023 11:28:22
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
$PACKAGE APAP.ATM
*-----------------------------------------------------------------------------
* <Rating>-45</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE AT.CALC.DEBIT.ACCT.NO(COMP.ACCT.NO,ACCT.NO)
*-------------------------------------------------------------------------------
* Subroutine to determine Debit Account No. for the ATM transaction
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*05/09/2023      Conversion tool            R22 Auto Conversion             Nochange
*05/09/2023      Suresh                     R22 Manual Conversion           Nochange
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATM.PARAMETER
    $INSERT I_F.ATM.BIN.ACCT
    $INSERT I_F.INTERCO.PARAMETER
    $INSERT I_F.ACCOUNT
*
* INCOMING - COMP.ACCT.NO ---> 2[1,6]*18*102

    GOSUB OPEN.FILES
    DEFAULT.BIN = '123123'

    PRINT "OUR.BIN = " : OUR.BIN
    PRINT "BIN.NO  = " : BIN.NO

* added by SARATH for KBL
    OUR.USD.BIN = '439129'

    IF BIN.NO EQ OUR.BIN OR BIN.NO EQ OUR.USD.BIN THEN
        GOSUB OUR.BNK.PROCESS
    END ELSE
        GOSUB OTH.BNK.PROCESS
    END

RETURN          ;* Main return

*-------------------------------------------------------------------------------
OPEN.FILES:
*
    FN.ATM.PARAMETER = 'F.ATM.PARAMETER'
    CALL OPF(FN.ATM.PARAMETER,F.ATM.PARAMETER)
*
*    CALL F.READ(FN.ATM.PARAMETER,'SYSTEM',R.ATM.PARAMETER,F.ATM.PARAMETER,ER.ATM.PARAMETER)        ;*/ TUS START/END
    CALL CACHE.READ(FN.ATM.PARAMETER,'SYSTEM',R.ATM.PARAMETER,ER.ATM.PARAMETER)
    OUR.BIN = R.ATM.PARAMETER<ATM.PARA.BANK.IMD>
    BIN.NO = COMP.ACCT.NO[1,6]
*
    FN.ATM.BIN.ACCT = 'F.ATM.BIN.ACCT'
    CALL OPF(FN.ATM.BIN.ACCT,F.ATM.BIN.ACCT)
*
RETURN          ;* From openfiles

*-------------------------------------------------------------------------------
OUR.BNK.PROCESS:
*
    ACCT.LEN = R.INTERCO.PARAMETER<ST.ICP.ACCOUNT.NO.LENGTH>
    ACCT.NO = COMP.ACCT.NO[11,ACCT.LEN]

***Modified for HNB since the length of field 102 is 14 characters and HNB account number is only 10 characters
*    ACCT.NO = COMP.ACCT.NO[15,ACCT.LEN]
    ACCT.NO = FMT(ACCT.NO,'R%':ACCT.LEN)

***modified on 19/11/2005 to accomodate HNB cobas customer
*    CALL DBR("ACCOUNT":FM:AC.CATEGORY,ACCT.NO,ACTEXIST)
    CALL GET.ACCT.BRANCH(ACCT.NO,Y.ACCT.BR.MNE,Y.ACCT.COMP.CDE)
    FN.ACCOUNT = 'F':Y.ACCT.BR.MNE:'.ACCOUNT'
*    FN.ACCOUNT = 'F.ACCOUNT'
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)      ;*open after changing company
    CALL F.READ(FN.ACCOUNT,ACCT.NO,ACTEXIST,F.ACCOUNT,ACCTERR)

    IF ACTEXIST EQ '' THEN
        CALL F.READ(FN.ATM.BIN.ACCT,'CWDRL',ABA.REC,F.ATM.BIN.ACCT,ABAERR)
        ACCT.NO = ABA.REC<BIN.RECEIVE.ACCOUNT.NO>
    END
***end

RETURN          ;* From OUR.BNK.PROCESS

*-------------------------------------------------------------------------------
OTH.BNK.PROCESS:
*
    CALL F.READ(FN.ATM.BIN.ACCT,BIN.NO,R.ATM.BIN.ACCT,F.ATM.BIN.ACCT,ER.ATM.BIN.ACCT)

* for booking all in one acct
    IF NOT(R.ATM.BIN.ACCT) THEN
        CALL F.READ(FN.ATM.BIN.ACCT,DEFAULT.BIN,R.ATM.BIN.ACCT,F.ATM.BIN.ACCT,ER.ATM.BIN.ACCT)
    END
* end of booking all in one acct

    ACCT.NO = R.ATM.BIN.ACCT<BIN.RECEIVE.ACCOUNT.NO>

RETURN          ;* From oth.bnk.process

*-------------------------------------------------------------------------------
