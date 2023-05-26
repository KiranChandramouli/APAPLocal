* @ValidationCode : MjotMzIyOTU2ODkxOkNwMTI1MjoxNjg0ODU0NDAwNDgxOklUU1M6LTE6LTE6MTgzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 183
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPD.SETT.RISK(Y.FX.LIMIT.ID)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.B.UPD.SETT.RISK
*--------------------------------------------------------------------------------------------------------
*Description       : The routine is the process routine for the multi threaded job, the routine
*                    updates the field SETT.RISK of the template REDO.APAP.FX.LIMIT based on certain condition
*In Parameter      : Y.FX.LIMIT.ID
*Out Parameter     :
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                            Reference                      Description
*   ------         ------                         -------------                    -------------
*  11/11/2010    A.SabariKumar                     ODR-2010-07-0075                Initial Creation
*  08/07/2011    Shankar Raju                        PACS00082437          Changing TODAYS date to SYSTEM DATE
* Date                  who                   Reference              
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FX.PARAMETERS
    $INSERT I_F.REDO.APAP.FX.LIMIT
    $INSERT I_REDO.B.UPD.SETT.RISK.COMMON

    GOSUB PROCESS
RETURN

*--------------------------------------------------------------------------------------------------------
PROCESS:
***********
* PACS00082437 - Changing TODAYS date to SYSTEM DATE - S

    Y.TIME.DATE = TIMEDATE()
    Y.DATE = FIELD(Y.TIME.DATE,' ',2,99)
    Y.YEAR = OCONV((ICONV(Y.DATE, "D")),'DY4')
    Y.MONTH = FMT((OCONV((ICONV(Y.DATE, "D")),'DM')),"R%2")
    Y.DAY  = FMT((OCONV((ICONV(Y.DATE, "D")),'DD')), "R%2")
    Y.DATE = Y.YEAR:Y.MONTH:Y.DAY

    Y.TODAY = Y.DATE

* PACS00082437 - Changing TODAYS date to SYSTEM DATE - E

    GOSUB CURR.SERVER.TIME
    CALL F.READ(FN.REDO.APAP.FX.LIMIT,Y.FX.LIMIT.ID,R.FX.LIM,F.REDO.APAP.FX.LIMIT,FX.LIM.ERR)
    Y.PRE.SETT = R.FX.LIM<REDO.FX.LIM.PRE.SETT.RISK>
    Y.REC.STA = R.FX.LIM<REDO.FX.LIM.RECORD.STATUS>
    Y.REC.DATE.TIME = R.FX.LIM<REDO.FX.LIM.DATE.TIME>
    Y.REC.DATE = Y.REC.DATE.TIME[1,6]
    Y.REC.YEAR = '20':Y.REC.DATE
    Y.REC.TIME = Y.REC.DATE.TIME[7,2]
    Y.REC.SEC = Y.REC.DATE.TIME[9,2]
    Y.ACTUAL.TIME = Y.PARAMETER.TIMING + Y.REC.TIME
    Y.ACT.TIME.SEC = Y.ACTUAL.TIME:".":Y.REC.SEC
    Y.DAY.CALCULATION = Y.ACT.TIME.SEC/24
    Y.DAY.ALONE = FIELD(Y.DAY.CALCULATION,'.',1,1)
    Y.DECIMALS =  FIELD(Y.DAY.CALCULATION,'.',2,1)
    IF Y.REC.YEAR NE '' AND Y.DAY.ALONE NE '' THEN
        Y.DAY.ALONE = Y.DAY.ALONE:'C'
        CALL CDT('',Y.REC.YEAR,Y.DAY.ALONE)
    END
    Y.DECIMALS = '.':Y.DECIMALS
    Y.NEXT.TIME = Y.DECIMALS*24
    IF Y.TODAY GE Y.REC.YEAR AND Y.TIME.NOW GE Y.NEXT.TIME THEN
        R.FX.LIM<REDO.FX.LIM.SETT.RISK> = 'YES'
        CALL F.WRITE(FN.REDO.APAP.FX.LIMIT,Y.FX.LIMIT.ID,R.FX.LIM)
    END
RETURN

*--------------------------------------------------------------------------------------------------------
CURR.SERVER.TIME:
*-----------------

    TIME.STAMP = TIMEDATE()
    Y.TIME.NOW = TIME.STAMP[1,5]
    CHANGE ":" TO '.' IN Y.TIME.NOW
RETURN

*--------------------------------------------------------------------------------------------------------
END
