* @ValidationCode : MjoxNjM5NDM4ODE2OkNwMTI1MjoxNjgyNDIxOTUyOTQ2OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 16:55:52
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.PRE.PRIN.INT.PENAL.INT.SELECT
*-----------------------------------------------------------------------------

*DESCRIPTION:
*------------
* This is the COB routine for the B16 development and this is Select routine
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who             Reference            Description
* 02-JUL-2010    Kishore.SP      ODR-2009-10-0325      Initial Creation
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.PRE.PRIN.INT.PENAL.INT.COMMON
*-----------------------------------------------------------------------------
*
    GOSUB PROCESS
RETURN
*
PROCESS:
*-------
* Select the Arrangements
*

    SELECT.CMD = "SELECT ":FN.AA.ARRANGEMENT:" WITH ARR.STATUS EQ AUTH OR ARR.STATUS EQ CURRENT "
    CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN
END
