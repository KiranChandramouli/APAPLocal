* @ValidationCode : MjotMTkwNzg0NTQ4NzpDcDEyNTI6MTY4NDg1NDM4MDY3MDpJVFNTOi0xOi0xOjYwMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 600
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.AZ.ACC.BAL.LOAD
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.AZ.ACC.BAL.LOAD
*-------------------------------------------------------------------------

* Description :This routine will open all the files required
*              by the routine REDO.B.AZZ.ACC.BAL.LOAD

* In parameter : None
* out parameter : None
*-------------------------------------------------------------------------------------
*Modification
* Date                   who                   Reference              
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND FM TO @FM 
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.AZ.ACC.BAL.COMMON


    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT=''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.AZ.CUSTOMER='F.AZ.CUSTOMER'
    F.AZ.CUSTOMER=''
    CALL OPF(FN.AZ.CUSTOMER,F.AZ.CUSTOMER)

    FN.PERIODIC.INTEREST='F.PERIODIC.INTEREST'
    F.PERIODIC.INTEREST=''
    CALL OPF(FN.PERIODIC.INTEREST,F.PERIODIC.INTEREST)

    FN.AZ.PRODUCT.PARAMETER='F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAMETER=''
    CALL OPF(FN.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.JOINT.CONTRACTS.XREF = 'F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF = ''
    CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

    LREF.APP='AZ.ACCOUNT':@FM:'AZ.PRODUCT.PARAMETER'
    LREF.FIELD='L.AZ.BAL.CONSOL':@VM:'ORIG.DEP.AMT':@FM:'L.AP.RENEW.KEY'
    LREF.POS=''
    LREF.POSTION=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POSTION)
    LREF.POS=LREF.POSTION<1,1>
    POS.ORIG.DEP.AMT=LREF.POSTION<1,2>
    POS.L.AP.RENEW.KEY = LREF.POSTION<2,1>


    SEL.AZ.ACCOUNT.CMD=''
    SEL.AZ.ACCOUNT.LIST=''
    NO.OF.REC=''
    AZ.CUSTOMER.ERR=''
    AZ.ACCOUNT.ERR=''
    Y.INT.RATE=''

RETURN
END
