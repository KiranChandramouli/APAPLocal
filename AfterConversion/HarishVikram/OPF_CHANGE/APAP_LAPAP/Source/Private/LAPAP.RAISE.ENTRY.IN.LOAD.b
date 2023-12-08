* @ValidationCode : Mjo4NDI4NzkxMDk6Q3AxMjUyOjE3MDIwMzM4MjYwMDI6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Dec 2023 16:40:26
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
*08-12-2023      AJITH KUMAR               R22 MANUAL CODE COVERISON    OPF TO OPEN
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
*CALL OPF(FN.SAVEDLISTS,F.SAVEDLISTS)
	OPEN  FN.SAVEDLISTS TO F.SAVEDLISTS ELSE ;*R22 MANUAL CODE CONVERISON - START
	END

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
*CALL OPF(FN.COMO,F.COMO)
	OPEN FN.COMO TO F.COMO ELSE ;*R22 MANUAL CODE CONVERISON - START
        
    END ;*R22 MANUAL CODE CONVERSION - END

    FN.SL='&SAVEDLISTS&'
    F.SL=''
*CALL OPF(FN.SL,F.SL)
	OPEN  FN.SL TO F.SL ELSE ;*R22 MANUAL CODE CONVERISON - START
    END  ;*R22 MANUAL CODE CONVERISON - END

    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FAILED = ''; PROCESSED = ''

    LIST.NAME = "AA.ADJ.CLEAR.BAL"

RETURN

END
