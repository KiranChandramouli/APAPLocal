* @ValidationCode : MjoxODE4MzA5MjU4OkNwMTI1MjoxNjg2MDUzODA2MTUzOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Jun 2023 17:46:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.213IF01.TXN.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.213IF01.TXN.EXTRACT
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
*
* 28-Jul-2014     V.P.Ashokkumar      PACS00309079 - Changed the selection to get correct amount
* 14-Oct-2014     V.P.Ashokkumar      PACS00309079 - Updated to filter AML transaction.
* 23-Feb-2017     Bernard Gladin S    Modified based on the RTE process change
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   = to EQ
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION ymend,FN.REDO.RTE.CUST.CASHTXN added in insert file 'I_DR.REG.213IF01.TXN.EXTRACT.COMMON'
*----------------------------------------------------------------------------------------





*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.CURRENCY

    $INSERT I_DR.REG.213IF01.TXN.EXTRACT.COMMON
    $INSERT I_F.DR.REG.213IF01.PARAM

    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
*
* Clear workfile before build for this run.
    CALL EB.CLEAR.FILE(FN.DR.REG.213IF01.WORKFILE,F.DR.REG.213IF01.WORKFILE)

    SEL.CMD = ''; BUILD.LIST = ''; Y.SEL.CNT = ''; Y.ERR = ''; YID.VAL = ''

    IF ymend EQ 1 THEN
        YID.VAL = 'FIELD(@ID,".",2)'
        SEL.CMD = "SELECT ":FN.REDO.RTE.CUST.CASHTXN:" WITH (EVAL'":YID.VAL:"' GE ":Y.START.DATE:" AND EVAL'":YID.VAL:"' LE ":Y.END.DATE:")"
    END ELSE
        SEL.CMD = "SELECT ":FN.REDO.RTE.CUST.CASHTXN:" WITH @ID LIKE ....":Y.START.DATE
    END

    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
    CALL BATCH.BUILD.LIST('',BUILD.LIST)
RETURN

END
