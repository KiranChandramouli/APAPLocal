* @ValidationCode : MjotMTgzNjYwODQ4NzpDcDEyNTI6MTcwNTA0NTcyNDEwMjphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jan 2024 13:18:44
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
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.AA.CP.OVERPAY.SELECT

*-------------------------------------------------
*Description: This batch routine is to post the FT OFS messages for overpayment
*             and also to credit the interest in loan..
* Dev by: V.P.Ashokkumar
* Date  : 10/10/2016
*-------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*20-07-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*20-07-2023       Samaran T               R22 Manual Code Conversion       INSERT FILE MODIFIED
*------------------------------------------------------------------------------------------
    $INSERT  I_COMMON ;*R22 MANUAL CODE CONVERSION.START
    $INSERT  I_EQUATE
    $INSERT  I_F.DATES
   * $INSERT  I_BATCH.FILES
    $INSERT  I_F.REDO.AA.CP.OVERPAYMENT
    $INSERT  I_F.REDO.AA.OVERPAYMENT
    $INSERT  I_REDO.B.AA.OVERPAY.COMMON  ;*R22 MANUAL CODE CONVERSION.END
   $USING EB.Service


  *  IF NOT(CONTROL.LIST) THEN
        ControlListVal = EB.Service.getControlList() ;*R22 UTILITY MANUAL CONVERSION
    IF NOT(ControlListVal) THEN ;*R22 UTILITY MANUAL CONVERSION
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************
   * CONTROL.LIST<-1> = "NEW.OVERPAY"
    *CONTROL.LIST<-1> = "OLD.OVERPAY"
    
    ControlListVal<-1> = "NEW.OVERPAY"
    ControlListVal<-1> = "OLD.OVERPAY"
RETURN

PROCESS:
********
    SEL.CMD = ''; SEL.LIST = ''; NO.OF.REC = ''; SEL.ERR = ''
    BEGIN CASE
       * CASE CONTROL.LIST<1,1> EQ 'NEW.OVERPAY'
         CASE    ControlListVal<-1> = "NEW.OVERPAY"
            SEL.CMD = "SELECT ":FN.REDO.AA.CP.OVERPAYMENT:" WITH STATUS EQ 'PENDIENTE' AND (NEXT.DUE.DATE GT ":R.DATES(EB.DAT.LAST.WORKING.DAY):" AND NEXT.DUE.DATE LE ":TODAY:")"
            CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

  *  CASE CONTROL.LIST<1,1> EQ 'OLD.OVERPAY'
       CASE  ControlListVal<-1> = 'OLD.OVERPAY'
            SEL.CMD = "SELECT ":FN.REDO.AA.OVERPAYMENT:" WITH STATUS EQ 'APLICADO' AND NEXT.DUE.DATE GT ":R.DATES(EB.DAT.LAST.WORKING.DAY):" AND NEXT.DUE.DATE LE ":TODAY
            CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    END CASE
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION
RETURN
END
