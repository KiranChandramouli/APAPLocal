* @ValidationCode : MjoyOTk4Mjc4MDg6Q3AxMjUyOjE2ODEzNjI4NDE3Mzk6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 10:44:01
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
SUBROUTINE REDO.B.STATUS.UPDATE.LOAD
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.B.STATUS.UPDATE.LOAD
*--------------------------------------------------------------------------------
* Description: Subroutine to perform the initialisation of the batch job

* Linked with   : None
* In Parameter  : None
* Out Parameter : None
*--------------------------------------------------------------------------------
* Modification History:
*02/01/2010 - ODR-2009-10-0535
*Development for Subroutine to perform the initialisation of the batch job
*--------------------------------------------------------------------------------
* Revision History:
*------------------
*   Date               who           Reference            Description
* 21-SEP-2011       Pradeeep S      PACS00090815          Credit Card status considered
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM 
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.STATUS.UPDATE.COMMON

    FN.CUST.PRD.LIST='F.REDO.CUST.PRD.LIST'
    F.CUST.PRD.LIST=''
    CALL OPF(FN.CUST.PRD.LIST,F.CUST.PRD.LIST)

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.CUSTOMER.HIS='F.CUSTOMER$HIS'
    F.CUSTOMER.HIS=''
    CALL OPF(FN.CUSTOMER.HIS,F.CUSTOMER.HIS)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT=''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.JOINT.CONTRACTS.XREF='F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF=''
    CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

    FN.CORPORATE.CUSTOMER.LIST = 'F.CORPORATE.CUSTOMER.LIST'
    F.CORPORATE.CUSTOMER.LIST  = ''
    CALL OPF(FN.CORPORATE.CUSTOMER.LIST,F.CORPORATE.CUSTOMER.LIST)

*PACS00090815 - S

    FN.REDO.SUNNEL.PARAMETER='F.REDO.SUNNEL.PARAMETER'
    F.REDO.SUNNEL.PARAMETER=''
    CALL OPF(FN.REDO.SUNNEL.PARAMETER,F.REDO.SUNNEL.PARAMETER)

    FN.REDO.SUNNEL.METHOD='F.REDO.SUNNEL.METHOD'
    F.REDO.SUNNEL.METHOD=''
    CALL OPF(FN.REDO.SUNNEL.METHOD,F.REDO.SUNNEL.METHOD)

    R.REDO.SUNNEL.PARAMETER = ''
    CALL CACHE.READ(FN.REDO.SUNNEL.PARAMETER,'SYSTEM',R.REDO.SUNNEL.PARAMETER,ERR)

    Y.METHOD.NAME = 'P_T24CustomerStatus'
    R.REDO.SUNNEL.METHOD = ''
    CALL CACHE.READ(FN.REDO.SUNNEL.METHOD,Y.METHOD.NAME,R.REDO.SUNNEL.METHOD,ERR)

    LREF.APP='ACCOUNT':@FM:'CUSTOMER'
    LREF.FIELDS='L.AC.STATUS2':@FM:'L.CU.TARJ.CR'
    LRF.POS = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LRF.POS)
    AC.STATUS2.POS = LRF.POS<1,1>
    CU.TARJ.POS    = LRF.POS<2,1>
*PACS00090815 - E

RETURN
END
