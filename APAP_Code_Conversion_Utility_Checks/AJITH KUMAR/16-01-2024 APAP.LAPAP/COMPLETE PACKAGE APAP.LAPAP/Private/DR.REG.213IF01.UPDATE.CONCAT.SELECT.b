* @ValidationCode : MjotMTkxNzg2MTc2NTpDcDEyNTI6MTcwMjk4ODM0MDk4MTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.213IF01.UPDATE.CONCAT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.213IF01.UPDATE.CONCAT
* Date           : 2-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the transactions over 10000 USD made by individual customer
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 21-Mar-2015   Ashokkumar.V.P        PACS00309079:- Added AA overpayment details
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   T24.BP is removed , LAPAP.BP is removed ,TAM.BP is removed,$INCLUDE to $INSERT
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*14-12-2023       Santosh C                   MANUAL R22 CODE CONVERSION NO CHANGE   APAP Code Conversion Utility Check
*----------------------------------------------------------------------------------------





*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_EQUATE
*   $INSERT I_BATCH.FILES ;*R22 Manual Code Conversion_Utility Check
    $INSERT I_F.TELLER
    $INSERT I_DR.REG.213IF01.UPDATE.CONCAT.COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_F.REDO.AA.OVERPAYMENT ;*R22 AUTO CODE CONVERSION
    $USING EB.Service ;*R22 Manual Code Conversion_Utility Check

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.PROCESS
RETURN

BUILD.CONTROL.LIST:
*******************
    CONTROL.LIST<-1> = "ACCT.ENT.LWORK.DAY"
    CONTROL.LIST<-1> = "REDO.TRANSACTION"
    CONTROL.LIST<-1> = "REDO.AA.OVERPAY"
RETURN

SEL.PROCESS:
************
    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ 'ACCT.ENT.LWORK.DAY'
            LIST.PARAMETER = ''
            LIST.PARAMETER<2> = "F.ACCT.ENT.LWORK.DAY"
            LIST.PARAMETER<7> = "FILTER"
*           CALL BATCH.BUILD.LIST(LIST.PARAMETER,"")
            EB.Service.BatchBuildList(LIST.PARAMETER,"") ;*R22 Manual Code Conversion_Utility Check

        CASE CONTROL.LIST<1,1> EQ 'REDO.TRANSACTION'
            SEL.CMD = ''; SEL.IDS = ''; SEL.LIST = ''; SEL.STS = ''
            SEL.CMD = "SELECT ":FN.REDO.TRANSACTION.CHAIN:" WITH TRANS.DATE EQ ":LAST.WRK.DATE:" AND TRANS.STATUS EQ ''"
            CALL EB.READLIST(SEL.CMD,SEL.IDS,'',SEL.LIST,SEL.STS)
*           CALL BATCH.BUILD.LIST('',SEL.IDS)
            EB.Service.BatchBuildList('',SEL.IDS) ;*R22 Manual Code Conversion_Utility Check

        CASE CONTROL.LIST<1,1> EQ 'REDO.AA.OVERPAY'
            SEL.CMD = ''; SEL.IDS = ''; SEL.LIST = ''; SEL.STS = ''
            SEL.CMD = "SELECT ":FN.REDO.AA.OVERPAYMENT:" WITH PAYMENT.DATE EQ ":LAST.WRK.DATE
            CALL EB.READLIST(SEL.CMD,SEL.IDS,'',SEL.LIST,SEL.STS)
*           CALL BATCH.BUILD.LIST('',SEL.IDS)
            EB.Service.BatchBuildList('',SEL.IDS) ;*R22 Manual Code Conversion_Utility Check
    END CASE

RETURN
END
