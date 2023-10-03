* @ValidationCode : Mjo0Nzg4MjIxNzc6Q3AxMjUyOjE2ODk3NDQ1Njg1NjY6SVRTUzotMTotMTo4ODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Jul 2023 10:59:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 88
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion           VM TO @VM, INCLUDE TO INSERT, BP removed in INSERT file
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.B.OVERDRAFT.ACCT.RTN.SELECT
*********************************************************************************************************
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Dev By       : V.P.Ashokkumar
*
*********************************************************************************************************

    $INSERT I_COMMON  ;*R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_REDO.B.OVERDRAFT.ACCT.RTN.COMMON ;*R22 Auto Conversion - End

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    CALL EB.CLEAR.FILE(FN.DR.OPER.OVERDRAF.WORKFILE, F.DR.OPER.OVERDRAF.WORKFILE)
    R.ACCT.CLASS = ''; ACCT.CLASS.ERR = ''; Y.SAVINGS.CATEG = ''
    SEL.CMD.ACC = ''; SEL.LIST = ''; NO.OF.REC = ''; RET.CODE = ''
    Y.ACC.CLASS.ID = 'SAVINGS'
    CALL F.READ(FN.ACCOUNT.CLASS,Y.ACC.CLASS.ID,R.ACCT.CLASS,F.ACCOUNT.CLASS,ACCT.CLASS.ERR)
    Y.SAVINGS.CATEG = R.ACCT.CLASS<AC.CLS.CATEGORY>
    CHANGE @VM TO ' ' IN Y.SAVINGS.CATEG
RETURN

PROCESS:
********
    SEL.CMD.ACC = "SELECT ":FN.ACCOUNT:" WITH CATEGORY EQ ":Y.SAVINGS.CATEG
    CALL EB.READLIST(SEL.CMD.ACC,SEL.LIST,'',NO.OF.REC,RET.CODE)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN

END
