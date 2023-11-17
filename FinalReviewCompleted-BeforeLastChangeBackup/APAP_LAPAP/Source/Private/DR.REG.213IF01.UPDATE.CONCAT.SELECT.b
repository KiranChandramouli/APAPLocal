* @ValidationCode : MjotOTg2Mzg0MjM1OkNwMTI1MjoxNjg0MjIyNzcyNjU2OklUU1M6LTE6LTE6LTEyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:09:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -12
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
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
*----------------------------------------------------------------------------------------





*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.TELLER
    $INSERT I_DR.REG.213IF01.UPDATE.CONCAT.COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_F.REDO.AA.OVERPAYMENT ;*R22 AUTO CODE CONVERSION

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
            CALL BATCH.BUILD.LIST(LIST.PARAMETER,"")

        CASE CONTROL.LIST<1,1> EQ 'REDO.TRANSACTION'
            SEL.CMD = ''; SEL.IDS = ''; SEL.LIST = ''; SEL.STS = ''
            SEL.CMD = "SELECT ":FN.REDO.TRANSACTION.CHAIN:" WITH TRANS.DATE EQ ":LAST.WRK.DATE:" AND TRANS.STATUS EQ ''"
            CALL EB.READLIST(SEL.CMD,SEL.IDS,'',SEL.LIST,SEL.STS)
            CALL BATCH.BUILD.LIST('',SEL.IDS)

        CASE CONTROL.LIST<1,1> EQ 'REDO.AA.OVERPAY'
            SEL.CMD = ''; SEL.IDS = ''; SEL.LIST = ''; SEL.STS = ''
            SEL.CMD = "SELECT ":FN.REDO.AA.OVERPAYMENT:" WITH PAYMENT.DATE EQ ":LAST.WRK.DATE
            CALL EB.READLIST(SEL.CMD,SEL.IDS,'',SEL.LIST,SEL.STS)
            CALL BATCH.BUILD.LIST('',SEL.IDS)
    END CASE

RETURN
END
