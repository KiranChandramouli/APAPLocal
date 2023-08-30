* @ValidationCode : MjotNDY0OTIxOTc5OkNwMTI1MjoxNjgxMTkyMjk5NzM0OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 11:21:39
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
SUBROUTINE REDO.B.GEN.ACH.OUT.FILE.LOAD
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This load routine initialises and opens necessary files
*  and gets the position of the local reference fields
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who             Reference            Description
* 01-SEP-2010     S.R.SWAMINATHAN    ODR-2009-12-0290     Initial Creation
* Date                  who                   Reference              
* 11-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES

*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.GEN.ACH.OUT.FILE.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.ACH.DATE
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.ACH.PARAM
    $INSERT I_F.REDO.ACH.PROCESS
    $INSERT I_F.USER
    $INSERT I_F.REDO.ACH.PROCESS.DET
    $INSERT I_F.LOCKING
*------------------------------------------------------------------------------------------------

    GOSUB OPEN.FILES
    GOSUB ASSIGN.VAL
RETURN
*------------------------------------------------------------------------------------------------
************
OPEN.FILES:
************
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS = ''
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)

    FN.LOCK = 'F.LOCKING'
    F.LOCK = ''
    CALL OPF(FN.LOCK,F.LOCK)

    FN.REDO.ACH.DATE = 'F.REDO.ACH.DATE'
    F.REDO.ACH.DATE = ''
    CALL OPF(FN.REDO.ACH.DATE,F.REDO.ACH.DATE)


    FN.REDO.DUP.ACH.DATE = 'F.REDO.DUP.ACH.DATE'
    F.REDO.DUP.ACH.DATE = ''
    CALL OPF(FN.REDO.DUP.ACH.DATE,F.REDO.DUP.ACH.DATE)

    FN.REDO.INTERFACE.PARAM = 'F.REDO.INTERFACE.PARAM'
    F.REDO.INTERFACE.PARAM = ''
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)


    FN.REDO.ACH.DET.IDS = 'F.REDO.ACH.DET.IDS'
    F.REDO.ACH.DET.IDS = ''
    CALL OPF(FN.REDO.ACH.DET.IDS,F.REDO.ACH.DET.IDS)

    FN.REDO.ACH.PARAM = 'F.REDO.ACH.PARAM'
    F.REDO.ACH.PARAM = ''
    CALL OPF(FN.REDO.ACH.PARAM,F.REDO.ACH.PARAM)

    FN.REDO.ACH.PROCESS = 'F.REDO.ACH.PROCESS'
    F.REDO.ACH.PROCESS = ''
    CALL OPF(FN.REDO.ACH.PROCESS,F.REDO.ACH.PROCESS)

    FN.REDO.ACH.PROCESS.DET = 'F.REDO.ACH.PROCESS.DET'
    F.REDO.ACH.PROCESS.DET = ''
    CALL OPF(FN.REDO.ACH.PROCESS.DET,F.REDO.ACH.PROCESS.DET)

RETURN
*------------------------------------------------------------------------------------------------
************
ASSIGN.VAL:
************
    Y.INTERF.ID = 'ACH001'

    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM,Y.INTERF.ID,R.REDO.INTERFACE.PARAM,Y.ERR)

    Y.OUT.PATH = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.DIR.PATH>

    CALL CACHE.READ(FN.REDO.ACH.PARAM,"SYSTEM",R.REDO.ACH.PARAM,ACH.ERR)

    Y.LENG.LINE = R.REDO.ACH.PARAM<REDO.ACH.PARAM.OUTW.LENG.LINE>
    Y.FILE.PREFIX  = R.REDO.ACH.PARAM<REDO.ACH.PARAM.OUTW.FILE.PREFX>
    Y.OUT.PATH.HIS  = R.REDO.ACH.PARAM<REDO.ACH.PARAM.OUTW.HIST.PATH>
    Y.DATE = TODAY
    Y.ACH.PARAM.TXN.TYPE = R.REDO.ACH.PARAM<REDO.ACH.PARAM.TXN.TYPE>
    Y.ACH.PARAM.RAD.COND = R.REDO.ACH.PARAM<REDO.ACH.PARAM.OUT.RAD.COND.ID>
RETURN
END
