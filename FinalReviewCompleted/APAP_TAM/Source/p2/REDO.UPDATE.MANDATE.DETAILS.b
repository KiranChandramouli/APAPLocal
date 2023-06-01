* @ValidationCode : MjotMTQ5NTEyMzA1NDpDcDEyNTI6MTY4NDQ5MTA0MjM0ODpJVFNTOi0xOi0xOjE4MToxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 181
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.UPDATE.MANDATE.DETAILS

*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : GANESH H
* Program Name : REDO.UPDATE.MANDATE.DETAILS
*-----------------------------------------------------------------------------
* Description : This is an auth routine attached to EB.MDANTE,AI.REDO.CORP.MANDATE
* Linked with : to update the CUSTOMER application
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*29/05/11                              GANESH H                INITIAL CREATION
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.EB.MANDATE
    $INSERT I_F.EB.MANDATE.PARAMETER

*-----------*
MAIN.PROCESS:
*-----------*
    GOSUB FILE.OPEN
    GOSUB UPDATE.CUSTOMER

RETURN
*---------*
FILE.OPEN:
*---------*


    FN.CUSTOMER = 'F.CUSTOMER'
    FV.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,FV.CUSTOMER)

    CUSTOMER.ID =ID.NEW
    CUSTOMER.ID=FIELD(CUSTOMER.ID,'.',1)

    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,FV.CUSTOMER,CUST.ERR)
RETURN
*--------------*
UPDATE.CUSTOMER:
*-------------*
    IF NOT(CUST.ERR) THEN
        COMP.ID=ID.COMPANY
        APP.NAME = 'CUSTOMER'
        OFSFUNCT = 'I'
        PROCESS  = 'PROCESS'
        OFSVERSION = 'CUSTOMER,AI.REDO.MANDATE'
        GTSMODE = ''
        NO.OF.AUTH = '0'
        TRANSACTION.ID = CUSTOMER.ID
        OFSRECORD = ''

        OFS.MSG.ID =''
        OFS.SOURCE.ID = 'REDO.OFS.ACI.UPDATE'
        OFS.ERR = ''

        R.CUSTOMER<EB.CUS.MANDATE.APPL> = 'FUNDS.TRANSFER'
        R.CUSTOMER<EB.CUS.MANDATE.RECORD>=ID.NEW
        CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.CUSTOMER,OFSRECORD)
        CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
    END
RETURN
END
