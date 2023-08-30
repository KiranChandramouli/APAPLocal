* @ValidationCode : Mjo5MDY4NjcyNjU6Q3AxMjUyOjE2ODA3ODA2OTYwNTM6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:01:36
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
SUBROUTINE REDO.B.ADMIN.CHEQUE.LOAD
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.B.ADMIN.CHEQUE.LOAD
* ODR NUMBER    : ODR-2009-10-0795
*----------------------------------------------------------------------------------------------------
* Description   : This is .load routine for REDO.B.ADMIN.CHEQUE, will initialise all the variables
* In parameter  :
* out parameter :
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 11-01-2011      MARIMUTHU s     ODR-2009-10-0795  Initial Creation
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 06-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION VM TO @VM 
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.ADMIN.CHEQUE.COMMON

    GOSUB OPENFILES
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.H.PAY.MODE.PARAM = 'F.REDO.H.PAY.MODE.PARAM'
    F.REDO.H.PAY.MODE.PARAM = ''
    CALL OPF(FN.REDO.H.PAY.MODE.PARAM,F.REDO.H.PAY.MODE.PARAM)

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.REDO.ADMIN.CHEQUE.DETAILS = 'F.REDO.ADMIN.CHEQUE.DETAILS'
    F.REDO.ADMIN.CHEQUE.DETAILS = ''
    CALL OPF(FN.REDO.ADMIN.CHEQUE.DETAILS,F.REDO.ADMIN.CHEQUE.DETAILS)

    FN.DATES = 'F.DATES'
    F.DATES = ''
    CALL OPF(FN.DATES,F.DATES)

    FN.STMT.ENTRY.DETAIL = 'F.STMT.ENTRY.DETAIL'
    F.STMT.ENTRY.DETAIL = ''
    CALL OPF(FN.STMT.ENTRY.DETAIL,F.STMT.ENTRY.DETAIL)

    APPLN = 'AZ.ACCOUNT'
    FIELD.APL = 'ORIG.DEP.AMT':@VM:'BENEFIC.NAME'
    CALL MULTI.GET.LOC.REF(APPLN,FIELD.APL,POS.LOC)
    POS.DEP.AMT = POS.LOC<1,1>
    POS.BEN.NAME = POS.LOC<1,2>

RETURN
*-----------------------------------------------------------------------------
END
