* @ValidationCode : MjotMTUwMDc5NDkzOkNwMTI1MjoxNjg0NDkxMDI5MjE5OklUU1M6LTE6LTE6LTE1OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -15
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.B.DEBTOR.PUNISH.SELECT
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine selects files in REDO.ACCT.MRKWOF.HIST then check with conditions in AA.ARRANGEMENT
*                         whether status is expired or current and Product line equal to Lending and Product group
*                         equal to HIPOTECARIO, CONSUMO, COMERCIAL, LINEAS.DE.CREDITO, LINEA.CREDITO.TC
*
* Developed By          : Nowful Rahman M
*
* Development Reference : 202_DE05
*
* Attached To           : BNK/REDO.B.DEBTOR.PUNISH
*
* Attached As           : Batch Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*   Date                Author              Modification Description
*
*  01/12/2017          Ashokkumar            CN007886--> Added the product LINEAS.DE.CREDITO.TC to the report.
* 15/01/2018           Ashokkumar            CN008154 -> Added new field to display Currency and amended the Tipo de Operacion field.
** 21-04-2023 R22 Auto Conversion no changes
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_REDO.B.DEBTOR.PUNISH.COMMON ;* R22 Auto conversion


    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB SEL.THE.FILE
RETURN

BUILD.CONTROL.LIST:
*******************
    CALL EB.CLEAR.FILE(FN.DR.REG.DE05.WORKFILE, F.DR.REG.DE05.WORKFILE)
    CONTROL.LIST<-1> = "SELECT.MRKWOF"
    CONTROL.LIST<-1> = "SELECT.AA"
RETURN

*-----------------------------------------------------------------------------------------------------------------
SEL.THE.FILE:
*-----------------------------------------------------------------------------------------------------------------
*Select REDO.ACCT.MRKWOF.HIST
*-----------------------------------------------------------------------------------------------------------------
    LIST.PARAMETER = ""
    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "SELECT.MRKWOF"
            SEL.CMD = "SELECT ":FN.REDO.ACCT.MRKWOF.HIST
            CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
            CALL BATCH.BUILD.LIST('',SEL.LIST)

        CASE CONTROL.LIST<1,1> EQ "SELECT.AA"
            LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
            LIST.PARAMETER<3> = "PRODUCT.GROUP EQ 'LINEAS.DE.CREDITO.TC'"
            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
    END CASE
RETURN
END
