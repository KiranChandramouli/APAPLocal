* @ValidationCode : Mjo2Nzk4NzM0OTc6Q3AxMjUyOjE2ODk3NDQ1Njk0MTU6SVRTUzotMTotMTozODg6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Jul 2023 10:59:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 388
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

SUBROUTINE REDO.B.STATUS.UPDATE.CS.LOAD
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*--------------------------------------------------------------------------------
* Revision History:
*------------------
*   Date               who           Reference            Description
*
*13/07/2023      Conversion tool            R22 Auto Conversion            FM TO @FM,INCLUDE TO INSERT, BP removed in INSERT file
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion
    $INSERT I_EQUATE ;*R22 Auto Conversion
    $INSERT I_REDO.B.STATUS.UPDATE.CS.COMMON ;*R22 Auto Conversion

    GOSUB INIT
    GOSUB LOC.REF
RETURN

INIT:
*****
    FN.CUST.PRD.LIST='F.REDO.CUST.PRD.LIST'
    F.CUST.PRD.LIST=''
    CALL OPF(FN.CUST.PRD.LIST,F.CUST.PRD.LIST)

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT=''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
RETURN

LOC.REF:
********
    LREF.APP='ACCOUNT':@FM:'CUSTOMER'
    LREF.FIELDS='L.AC.STATUS2':@FM:'L.CU.TARJ.CR'
    LRF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LRF.POS)
    AC.STATUS2.POS = LRF.POS<1,1>
    CU.TARJ.POS    = LRF.POS<2,1>
RETURN
END
