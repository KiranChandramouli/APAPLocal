* @ValidationCode : MjotMTI2MDY3NTQwNzpDcDEyNTI6MTY4NDg1NDM4MTUwMDpJVFNTOi0xOi0xOjM4NDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 384
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CAPITALISE.INT.LOAD
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Arulprakasam P
* Program Name  : REDO.B.CLEAR.OUT.LOAD
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
* 23-11-2010      ODR-2010-09-0251                  Initial Creation
* Date                  who                   Reference              
* 10-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_REDO.B.CAPITALISE.COMMON
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

    FN.INT.REVERSE = 'F.REDO.INTEREST.REVERSE'
    F.INT.REVERSE = ''
    CALL OPF(FN.INT.REVERSE,F.INT.REVERSE)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.INT.REVERSE.HIS = 'F.REDO.INT.REVERSE.HIS'
    F.INT.REVERSE.HIS = ''
    CALL OPF(FN.INT.REVERSE.HIS,F.INT.REVERSE.HIS)


RETURN
*-----------------------------------------------------------------------------------------------------------
READ.FILE:
**********

    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,"SYSTEM",R.REDO.APAP.CLEAR.PARAM,"")

    CAPITALISE.ACCT  = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CAPITALISE.ACCT>

    CAPITAL.CR.CODE = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CAPITAL.CR.CODE>
    CAPITAL.DR.CODE = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CAPITAL.DR.CODE>

RETURN

*----------------------------------------------------------------------------------------------------------------
END
