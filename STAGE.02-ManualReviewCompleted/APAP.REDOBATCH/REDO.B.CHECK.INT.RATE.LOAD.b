* @ValidationCode : MjotMTE0MDc1MzMyOTpDcDEyNTI6MTY4MTEwNTM2Njc3NDpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 11:12:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CHECK.INT.RATE.LOAD
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.B.CHECK.INT.RATE.LOAD
*--------------------------------------------------------------------------------
* Description: Subroutine to perform the initialisation of the batch job

* Linked with   : None
* In Parameter  : None
* Out Parameter : None
*--------------------------------------------------------------------------------
* Modification History:
*10/12/2009 - ODR-2009-10-0537
*Development for Subroutine to perform the initialisation of the batch job
**********************************************************************************
*  DATE             WHO         REFERENCE         DESCRIPTION
* 26 Mar 2011    GURU DEV      PACS00033054      Modified as per issue
* Date                  who                   Reference              
* 10-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION FM TO @FM
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_REDO.B.CHECK.INT.RATE.COMMON

    GOSUB INIT
    GOSUB OPENFILES
RETURN
*----
INIT:
*----
    LREF.APP='AZ.ACCOUNT':@FM:'AZ.PRODUCT.PARAMETER'
    LREF.FIELD='ORIG.DEP.AMT':@FM:'L.AP.RENEW.KEY'
    LREF.POS=''

    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT=''

    FN.AZ.PRODUCT.PARAM='F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAM=''

    FN.PERIODIC.INTEREST='F.PERIODIC.INTEREST'
    F.PERIODIC.INTEREST=''

RETURN
*--------
OPENFILES:
*--------
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    CALL OPF(FN.AZ.PRODUCT.PARAM,F.AZ.PRODUCT.PARAM)
    CALL OPF(FN.PERIODIC.INTEREST,F.PERIODIC.INTEREST)
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    AZ.LOCAL.AMT.POS = LREF.POS<1,1>
    AZ.RENEW.KEY.POS = LREF.POS<2,1>
RETURN
END
