* @ValidationCode : MjotMTUyNjM4ODk5MTpDcDEyNTI6MTcwNDk3MzU0NzUxMzp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Jan 2024 17:15:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.ARRANGEMENT.STATUS.SELECT    

*DESCRIPTION:
*------------
* This is the COB routine for the B51 development and this is Select routine
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
* 02 Sep 2010    Ravikiran AV              B.51                  Initial Creation
*
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-------------------------------------------------------------------------------------------------------------------

* All File INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
   $USING EB.Service

*------------------------------------------------------------------------------------------------------------------
*Main Logic of the routine
*
MAIN.LOGIC:

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------------------------------------------------
* Files to be opened for processing
*
OPEN.FILES:

    FN.REDO.AA.OVERDUE.LOAN.STATUS = 'F.REDO.AA.OVERDUE.LOAN.STATUS'
    F.REDO.AA.OVERDUE.LOAN.STATUS = ''
    CALL OPF(FN.REDO.AA.OVERDUE.LOAN.STATUS, F.REDO.AA.OVERDUE.LOAN.STATUS)

RETURN
*------------------------------------------------------------------------------------------------------------------
* Load the Arrangement ids for Multi-Threaded Processing
*
PROCESS:

    SELECT.CMD = "SELECT ":FN.REDO.AA.OVERDUE.LOAN.STATUS
    CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.REC,PGM.ERR)

*    CALL BATCH.BUILD.LIST('', SEL.LIST)
EB.Service.BatchBuildList('', SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN
*------------------------------------------------------------------------------------------------------------------
END
