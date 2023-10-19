* @ValidationCode : MjoxNjAyNTEwOTgwOkNwMTI1MjoxNjg5MzIwNDE1OTE4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Jul 2023 13:10:15
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
$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion           INCLUDE TO INSERT, BP removed in INSERT file
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.B.OVR.LOAN.REPORT.SELECT

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
