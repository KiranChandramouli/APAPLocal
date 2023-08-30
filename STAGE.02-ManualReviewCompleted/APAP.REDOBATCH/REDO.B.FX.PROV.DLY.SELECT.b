* @ValidationCode : MjotMTMyNDI1ODc1OkNwMTI1MjoxNjgwNzkwMTA4ODE4OklUU1M6LTE6LTE6LTEwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -10
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.FX.PROV.DLY.SELECT

*DESCRIPTION:
*------------
* This is the COB routine for the ODR-2009-11-0159 and this is Select routine
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
*   ------         ------               -------------            -------------
*  25-OCT-2010     JEEVA T             ODR-2009-11-0159         Initial Creation
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*
*-------------------------------------------------------------------------------------------------------------------

* All File INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.FX.PROV.DLY.COMMON

*------------------------------------------------------------------------------------------------------------------
*Main Logic of the routine
*
    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------------------------------------------------
* Load the Customer ids for Multi-Threaded Processing
*
PROCESS:

*    SELECT.CMD = 'SELECT ':FN.CUSTOMER.ACCOUNT
    SELECT.CMD = 'SELECT ':FN.REDO.CUSTOMER.ARRANGEMENT
    CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.REC,PGM.ERR)

    CALL BATCH.BUILD.LIST('', SEL.LIST)

RETURN
*------------------------------------------------------------------------------------------------------------------
END
