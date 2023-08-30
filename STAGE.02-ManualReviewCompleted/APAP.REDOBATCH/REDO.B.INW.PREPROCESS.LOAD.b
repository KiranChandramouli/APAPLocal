* @ValidationCode : MjotMzI2ODcyMzkyOkNwMTI1MjoxNjgxMTkzMzI5MjYwOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 11:38:49
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
SUBROUTINE REDO.B.INW.PREPROCESS.LOAD

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.B.INW.PREPROCESS.LOAD
*-------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*
*----------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-09-10          ODR-2010-09-0148                  Initial Creation
* Date                  who                   Reference              
* 11-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ALTERNATE.ACCOUNT
    $INSERT I_F.REDO.APAP.CLEARING.INWARD
    $INSERT I_F.REDO.MAPPING.TABLE
    $INSERT I_F.REDO.CLEARING.PROCESS
    $INSERT I_REDO.B.INW.PREPROCESS.COMMON


    GOSUB INIT
    GOSUB OPEN.FILE
RETURN

INIT:

    FN.REDO.CLEARING.PROCESS.ID = 'INW.PROCESS'

    FN.REDO.CLEARING.PROCESS = 'F.REDO.CLEARING.PROCESS'
    F.REDO.CLEARING.PROCESS  = ''
    CALL OPF(FN.REDO.CLEARING.PROCESS,F.REDO.CLEARING.PROCESS)

    CALL F.READ(FN.REDO.CLEARING.PROCESS,FN.REDO.CLEARING.PROCESS.ID,R.REDO.CLEARING.PROCESS,F.REDO.CLEARING.PROCESS,PROC.CLEAR.ERR)
    VAR.FILE.PATH = R.REDO.CLEARING.PROCESS<PRE.PROCESS.IN.PROCESS.PATH>
    VAR.FILE.NAME = R.REDO.CLEARING.PROCESS<PRE.PROCESS.IN.PROCESS.NAME>

RETURN

OPEN.FILE:
*Opening Files

    FN.REDO.CLEARING.PROCESS = 'F.REDO.CLEARING.PROCESS'
    F.REDO.CLEARING.PROCESS  = ''
    CALL OPF(FN.REDO.CLEARING.PROCESS,F.REDO.CLEARING.PROCESS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ALTER = 'F.ALTERNATE.ACCOUNT'
    F.ALTER  = ''
    CALL OPF(FN.ALTER,F.ALTER)

    FN.APERTA = R.REDO.CLEARING.PROCESS<PRE.PROCESS.IN.PROCESS.PATH>
    F.APERTA  = ''
    CALL OPF(FN.APERTA,F.APERTA)

    FN.REDO.MAPPING.TABLE = 'F.REDO.MAPPING.TABLE'
    F.REDO.MAPPING.TABLE = ''
    CALL OPF(FN.REDO.MAPPING.TABLE,F.REDO.MAPPING.TABLE)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.APAP.CLEARING.INWARD = 'F.REDO.APAP.CLEARING.INWARD'
    F.REDO.APAP.CLEARING.INWARD = ''
    CALL OPF(FN.REDO.APAP.CLEARING.INWARD,F.REDO.APAP.CLEARING.INWARD)

    FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.CLEAR.PARAM = ''
    CALL OPF(FN.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)
RETURN

END
