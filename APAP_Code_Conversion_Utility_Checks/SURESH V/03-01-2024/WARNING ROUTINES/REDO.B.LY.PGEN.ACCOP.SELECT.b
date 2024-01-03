* @ValidationCode : MjotMTQwODE3NTkxODpDcDEyNTI6MTY4MTExMTg5NDk4NTpJVFNTOi0xOi0xOi03OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:01:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LY.PGEN.ACCOP.SELECT
*-------------------------------------------------------------------------------------------------
*DESCRIPTION:
*  This routine selects all accounts with current opening date
*  This routine is the SELECT routine of the batch REDO.B.LY.PGEN.ACCOP which updates
*   REDO.LY.POINTS table based on the data defined in the parameter table
*   REDO.LY.MODALITY & REDO.LY.PROGRAM
* ------------------------------------------------------------------------------------------------
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
*   Date               who           Reference            Description
* 17-JUN-2013   RMONDRAGON        ODR-2011-06-0243       Initial Creation
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*----------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
   $USING EB.Service

$INSERT I_REDO.B.LY.PGEN.ACCOP.COMMON

GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

SEL.LIST = ''
IF PRG.RECSEL EQ 'Y' THEN
SEL.ACC.CMD = 'SSELECT ':FN.ACCOUNT:' WITH ':Y.DATE.TO.SELECT
SEL.LIST = ''
CALL EB.READLIST(SEL.ACC.CMD,SEL.LIST,'',ID.CNT,'')
END
*CALL BATCH.BUILD.LIST('',SEL.LIST)
EB.Service.BatchBuildList('',SEL.LIST);* R22 AUTO CONVERSION

RETURN

END
