* @ValidationCode : MjoxMzgyMTIwODA1OkNwMTI1MjoxNjg0ODU0Mzk5MjYzOklUU1M6LTE6LTE6MTg2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 186
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.STO.OVERRIDE.LOAD
*--------------------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is the load routine of the batch job REDO.B.STO.OVERRIDE
* This routine opens the necessary files and read the parameter table.
* -------------------------------------------------------------------------------------------------------
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
*   Date           who           Reference                          Description
* 24-AUG-2011   Sudharsanan   TAM-ODR-2009-10-0331(PACS0054326)   Initial Creation
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND SM TO @SM 
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.STO.OVERRIDE.PARAM
    $INSERT I_REDO.B.STO.OVERRIDE.COMMON

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

*-----------
OPEN.FILES:
*-----------
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.STO.OVERRIDE.PARAM = 'F.REDO.STO.OVERRIDE.PARAM'

RETURN
*----------
PROCESS:
*----------
    STO.PARAM.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.STO.OVERRIDE.PARAM,STO.PARAM.ID,R.STO.OVERRIDE.PARAM,STO.ERR)
    Y.MSG = R.STO.OVERRIDE.PARAM<STO.OVE.MESSAGE>
    CHANGE @SM TO @FM IN Y.MSG
    CHANGE @VM TO @FM IN Y.MSG
RETURN
END
