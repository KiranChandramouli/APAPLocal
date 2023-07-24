* @ValidationCode : MjotMTEwMTYxMTM2NjpDcDEyNTI6MTY4OTc0NDU2ODg0MDpJVFNTOi0xOi0xOi0xOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Jul 2023 10:59:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.OVR.LOAN.REPORT.SELECT
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion           INCLUDE TO INSERT, BP removed in INSERT file
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion  - Start
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.REDO.H.CUSTOMER.PROVISIONING
    $INSERT I_REDO.B.OVR.LOAN.REPORT.COMMON ;*R22 Auto Conversion - End


    CALL EB.CLEAR.FILE(FN.DR.REG.OVR.LOAN.WORKFILE,F.DR.REG.OVR.LOAN.WORKFILE)
    SEL.CMD = ''; SEL.LIST =''; NO.OF.REC = ''; REC.ERR = '';

    SEL.CMD = 'SELECT ':FN.AA:' WITH (ARR.STATUS EQ CURRENT OR ARR.STATUS EQ EXPIRED)'
*SEL.CMD = 'SELECT ':FN.AA:' WITH PRODUCT.GROUP EQ PRODUCTOS.WOF'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,REC.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
