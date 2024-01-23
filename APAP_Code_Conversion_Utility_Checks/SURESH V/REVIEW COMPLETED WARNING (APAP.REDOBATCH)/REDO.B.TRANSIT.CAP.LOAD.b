* @ValidationCode : MjotMTcxOTYwNTYzMDpDcDEyNTI6MTcwNDQ0NTUwODk2MzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jan 2024 14:35:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.TRANSIT.CAP.LOAD

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : KAVITHA
* Program Name  : REDO.B.TRANSIT.CAP.LOAD
*-------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*
*-----------------------------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------------
*   DATE                ODR                             DESCRIPTION
* 2-04-2012         ODR-2010-09-0251                  Initial Creation
* Date                  who                   Reference
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*18/01/2024         Suresh                 R22 UTILITY AUTO CONVERSION   IDVAR Variable Changed
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_REDO.B.TRANSIT.CAP.COMMON
    $INSERT I_F.REDO.APAP.CLEAR.PARAM


    GOSUB INIT
    GOSUB READ.FILE

RETURN

*-----------------------------------------------------------------------------------------------------------
*****
INIT:
*****

    FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.CLEAR.PARAM = ''
    CALL OPF(FN.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)

    FN.REDO.TRANUTIL.INTAMT = 'F.REDO.TRANUTIL.INTAMT'
    F.REDO.TRANUTIL.INTAMT = ''
    CALL OPF(FN.REDO.TRANUTIL.INTAMT,F.REDO.TRANUTIL.INTAMT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


RETURN
*-----------------------------------------------------------------------------------------------------------
READ.FILE:
**********

*    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,"SYSTEM",R.REDO.APAP.CLEAR.PARAM,"")
    IDVAR.1 = "SYSTEM" ;* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,IDVAR.1,R.REDO.APAP.CLEAR.PARAM,"");* R22 UTILITY AUTO CONVERSION

    TRANCAP.ACCT = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.TRANCAP.ACCT>
 
    TRANCAP.CR.CODE = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.TRANCAP.CR.CODE>
    TRANCAP.DR.CODE = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.TRANCAP.DR.CODE>

RETURN

*----------------------------------------------------------------------------------------------------------------
END
