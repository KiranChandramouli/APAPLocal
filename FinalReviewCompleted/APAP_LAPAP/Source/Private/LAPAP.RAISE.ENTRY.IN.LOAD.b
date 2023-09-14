* @ValidationCode : MjoxMzQzMjExMzY2OlVURi04OjE2ODk3NDk2NTcxMzI6SVRTUzotMTotMToxMTg4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:17
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1188
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
**==================================================================================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.RAISE.ENTRY.IN.LOAD
**==================================================================================================================================
* Reads the details from savedlists and raise entry by calling EB.ACCOUNTING
* We will multiply with -1 in the amount provided in the SL. So you have to give the actual available amount. We will pass the opposite entry for that
* Please make sure - AC.BALANCE.TYPE refered correctly and raising ENTRY
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 14-07-2023    Narmadha V             R22 Manual Conversion   No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion -START
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.COMPANY
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AC.BALANCE.TYPE
    $INSERT I_LAPAP.RAISE.ENTRY.IN.COMMON ;*R22 Auto Conversion -END


    GOSUB INITIALISE
    GOSUB OPENFILES

RETURN

INITIALISE:
*==========
RETURN
OPENFILES:
*=========

    FN.SAVEDLISTS = '&SAVEDLISTS&'
    F.SAVEDLISTS = ''
    CALL OPF(FN.SAVEDLISTS,F.SAVEDLISTS)

    FN.AA.ARR = 'F.AA.ARRANGEMENT'
    F.AA.ARR = ''
    CALL OPF(FN.AA.ARR,F.AA.ARR)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.CLOSURE = 'F.ACCOUNT.CLOSURE'
    F.ACCOUNT.CLOSURE = ''
    CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)

    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.AC='F.ACCOUNT'
    F.AC=''
    CALL OPF(FN.AC,F.AC)

    FN.AC.HIS='F.ACCOUNT$HIS'
    F.AC.HIS=''
    CALL OPF(FN.AC.HIS,F.AC.HIS)

    FN.AC.ACT = 'F.ACCOUNT.ACT'
    FV.AC.ACT = ''
    CALL OPF(FN.AC.ACT, FV.AC.ACT)

    FN.AC.ENT.TODAY = 'F.ACCT.ENT.TODAY'
    FV.AC.ENT.TODAY = ''
    CALL OPF(FN.AC.ENT.TODAY, FV.AC.ENT.TODAY)

    AA.SEP = '#'
    FN.COMO='&COMO&'
    F.COMO=''
    CALL OPF(FN.COMO,F.COMO)

    FN.SL='&SAVEDLISTS&'
    F.SL=''
    CALL OPF(FN.SL,F.SL)

    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FAILED = ''; PROCESSED = ''

    LIST.NAME = "AA.ADJ.CLEAR.BAL"

RETURN

END
