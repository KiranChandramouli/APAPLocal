* @ValidationCode : MjotOTIzMzkyMjQ2OkNwMTI1MjoxNjgxMTkyNzI2NDA5OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 11:28:46
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
SUBROUTINE REDO.B.GEN.ACH.REJINW.FILE.LOAD
*-----------------------------------------------------------------------------
*DESCRIPTION:
*-----------------------------------------------------------------------------
* Input/Output:
*-----------------------------------------------------------------------------
* IN  : -NA-
* OUT : -NA-
*------------------------------------------------------------------------------
* Dependencies:
*-------------------------------------------------------------------------------
* CALLS : -NA-
* CALLED BY : -NA-
*--------------------------------------------------------------------------------
* Revision History:
*---------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 04-Oct-2010        Harish.Y       ODR-2009-12-0290    Initial Creation
* 11-Apr-2013        Sheshraj       PERF-CHANGE
* Date                  who                   Reference              
* 11-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ACH.PROCESS
    $INSERT I_F.REDO.ACH.PROCESS.DET
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.ACH.PARAM
    $INSERT I_REDO.B.GEN.ACH.REJINW.FILE.COMMON

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----
INIT:
*-----
    FN.REDO.ACH.PROCESS ='F.REDO.ACH.PROCESS'
    F.REDO.ACH.PROCESS = ''
    CALL OPF(FN.REDO.ACH.PROCESS,F.REDO.ACH.PROCESS)

    FN.REDO.ACH.PROCESS.DET = 'F.REDO.ACH.PROCESS.DET'
    F.REDO.ACH.PROCESS.DET = ''
    CALL OPF(FN.REDO.ACH.PROCESS.DET,F.REDO.ACH.PROCESS.DET)

    FN.REDO.INTERFACE.PARAM = 'F.REDO.INTERFACE.PARAM'
    F.REDO.INTERFACE.PARAM = ''
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)

    FN.REDO.ACH.PARAM = 'F.REDO.ACH.PARAM'
    F.REDO.ACH.PARAM  =''
    CALL OPF(FN.REDO.ACH.PARAM,F.REDO.ACH.PARAM)

    FN.REDO.ACH.PROC.IDS = 'F.REDO.ACH.PROC.IDS'
    F.REDO.ACH.PROC.IDS = ''
    CALL OPF(FN.REDO.ACH.PROC.IDS,F.REDO.ACH.PROC.IDS)

RETURN
*-------
PROCESS:
*-------

    INT.ID = 'ACH004'
*CALL F.READ(FN.REDO.INTERFACE.PARAM,INT.ID,R.INT.PARAM,F.REDO.INTERFACE.PARAM,INT.PARAM.ERR)
    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM,INT.ID,R.INT.PARAM,INT.PARAM.ERR)     ;* PERF-CHANGE
    IF R.INT.PARAM THEN
        Y.INTERF.ID=INT.ID
        Y.OUT.PATH=R.INT.PARAM<REDO.INT.PARAM.DIR.PATH>
    END
    CALL CACHE.READ(FN.REDO.ACH.PARAM,"SYSTEM",R.REDO.ACH.PARAM,ACH.PARAM.ERR)
*CALL F.READ(FN.REDO.ACH.PARAM,'SYSTEM',R.REDO.ACH.PARAM,F.REDO.ACH.PARAM,ACH.PARAM.ERR)
    IF R.REDO.ACH.PARAM THEN
        Y.FILE.PREFIX  = R.REDO.ACH.PARAM<REDO.ACH.PARAM.INW.REJ.FIL.PRE>
        Y.IN.PATH.HIS = R.REDO.ACH.PARAM<REDO.ACH.PARAM.IN.REJ.HIST.PATH>
        Y.OUT.PATH.HIS  = R.REDO.ACH.PARAM<REDO.ACH.PARAM.OUT.RJ.HIS.PATH>
    END
RETURN
END
