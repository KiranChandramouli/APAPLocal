* @ValidationCode : Mjo4NjY5MzUzOTg6Q3AxMjUyOjE2OTAxNjc1Mjg4OTg6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.CRED.CAN.LOAND.SELECT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed in INSERTFILE
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON                              ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_F.DATES
    $INSERT I_L.APAP.CRED.CAN.LOAND.COMMON ;* R22 Manual R22 conversion
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.APAP.CREDIT.CARD.DET
    $INSERT I_F.AA.LIMIT
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.ST.LAPAP.REPORTDE16              ;*R22 Auto conversion - End
   $USING EB.Service

*    CALL EB.CLEAR.FILE(FN.LAPAP.REPORTDE16,F.LAPAP.REPORTDE16)
EB.Service.ClearFile(FN.LAPAP.REPORTDE16,F.LAPAP.REPORTDE16);* R22 UTILITY AUTO CONVERSION
    SEL.CMD = " SELECT " : FN.AA.ARRANGEMENT : " WITH PRODUCT.LINE EQ LENDING"
    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.RECS,SEL.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION
RETURN
END
