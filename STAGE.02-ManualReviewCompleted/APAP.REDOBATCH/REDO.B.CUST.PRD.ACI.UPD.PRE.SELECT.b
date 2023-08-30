* @ValidationCode : MjotMTU0NzUxNTcxNTpDcDEyNTI6MTY4MTE4OTI1MTQ1MzpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 10:30:51
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
SUBROUTINE REDO.B.CUST.PRD.ACI.UPD.PRE.SELECT
****************************************************************
*  originally SUBROUTINE REDO.B.CUST.PRD.ACI.UPD.SELECT
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.CUST.PRD.ACI.UPD.SELECT
* ODR NO        : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.CUST.PRD.ACI.UPD

* 27/apr/2012 : Shek : Performance tuning
*             : Check account/redo records are moved to run routine,
*               to avoid multiple reads and multithreading the checks

* In parameter : None
* out parameter : None
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 11-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.BASIC.INTEREST
    $INSERT I_F.DATES
    $INSERT I_F.REDO.CUST.PRD.LIST
    $INSERT I_F.REDO.ACC.CR.INT
    $INSERT I_REDO.B.CUST.PRD.ACI.UPD.COMMON

    GOSUB PROCESS

RETURN
*--------------------------
PROCESS:
*--------------------------

    PREV.WORKING.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)

    SEL.CMD = "SELECT ":FN.REDO.CUST.PRD.LIST:" WITH PROCESS.DATE EQ ":PREV.WORKING.DAY


    PROCESS.LIST = ''
    PROCESS.LIST<3> = SEL.CMD

    CALL BATCH.BUILD.LIST(PROCESS.LIST,"")

RETURN

END
