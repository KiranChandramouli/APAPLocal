* @ValidationCode : Mjo5NDYyNjY3MDU6VVRGLTg6MTY4OTMyMjAyNTAyOTpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Jul 2023 13:37:05
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
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
SUBROUTINE LAPAP.RAISE.ENTRY.IN.SELECT
**==================================================================================================================================
* Reads the details from savedlists and raise entry by calling EB.ACCOUNTING
* We will multiply with -1 in the amount provided in the SL. So you have to give the actual available amount. We will pass the opposite entry for that
* Please make sure - AC.BALANCE.TYPE refered correctly and raising ENTRY
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 14-07-2023    Narmadha V             R22 Manual Conversion     No Changes
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
    $INSERT I_LAPAP.RAISE.ENTRY.IN.COMMON ;*R22 Auto Conversion- END

    CALL F.READ(FN.SAVEDLISTS,LIST.NAME,ARR.IDS,F.SAVEDLISTS,RET.ERR)
    TEMP.REC = ARR.IDS
    CALL BATCH.BUILD.LIST('',TEMP.REC)

RETURN

END
