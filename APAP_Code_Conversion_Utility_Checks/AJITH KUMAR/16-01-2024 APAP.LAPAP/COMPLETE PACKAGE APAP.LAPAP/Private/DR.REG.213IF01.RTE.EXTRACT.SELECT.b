* @ValidationCode : Mjo0NjU0OTU0Njg6Q3AxMjUyOjE3MDI5ODgzNDA1MDk6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
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
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.213IF01.RTE.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.213IF01.RTE.EXTRACT.SELECT
* Date           : 07-Mar-2018
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the transactions over 15000 USD made by individual customer
*-----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
* 07-Mar-2018     Bernard Gladin S    Initial Version
* 06-11-2023      HARISHVIKRAM C   R22 Manual Conversion  / removed in INSERT file "I_DR.REG.213IF01.RTE.EXTRACT.COMMON"
* 14-12-2023       Santosh C        MANUAL R22 CODE CONVERSION NO CHANGE   APAP Code Conversion Utility Check
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*   $INSERT I_BATCH.FILES
    $INSERT I_F.CURRENCY

    $INSERT I_DR.REG.213IF01.RTE.EXTRACT.COMMON
    $INSERT I_F.DR.REG.213IF01.PARAM
    $USING EB.Service ;*R22 Manual Code Conversion_Utility Check

    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
*
* Clear workfile before build for this run.
*   CALL EB.CLEAR.FILE(FN.REDO.RTE.IF.WORKFILE,F.REDO.RTE.IF.WORKFILE) ;*R22 Manual Code Conversion_Utility Check
    EB.Service.ClearFile(FN.REDO.RTE.IF.WORKFILE,F.REDO.RTE.IF.WORKFILE)

    SEL.CMD = ''; BUILD.LIST = ''; Y.SEL.CNT = ''; Y.ERR = ''; YID.VAL = ''
*    Y.START.DATE = '20170915'
    IF ymend EQ 1 THEN
        YID.VAL = 'FIELD(@ID,".",2)'
        SEL.CMD = "SELECT ":FN.REDO.RTE.CUST.CASHTXN:" WITH (EVAL'":YID.VAL:"' GE ":Y.START.DATE:" AND EVAL'":YID.VAL:"' LE ":Y.END.DATE:")"
    END ELSE
        SEL.CMD = "SELECT ":FN.REDO.RTE.CUST.CASHTXN:" WITH @ID LIKE ....":Y.START.DATE
    END

    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
*   CALL BATCH.BUILD.LIST('',BUILD.LIST) ;*R22 Manual Code Conversion_Utility Check
    EB.Service.BatchBuildList('',BUILD.LIST)
RETURN

END
