* @ValidationCode : Mjo3NzE3OTYzODY6Q3AxMjUyOjE3MDM1NzE4MjE3NzE6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Dec 2023 11:53:41
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CUST.PRD.ACI.PURGE.SELECT
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.CUST.PRD.ACI.PURGE.SELECT
* ODR NO        : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.CUST.PRD.ACI.PURGE

* In parameter : None
* out parameter : None

*------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion         No changes
* 04-APR-2023      Harishvikram C    Manual R22 conversion       No changes
*26/12/2023         Suresh                R22 Manual Conversion    CALL routine modified

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CUST.PRD.ACI.PURGE.COMMON
    
    $USING EB.Service ;*R22 Manual Conversion

    GOSUB PROCESS

RETURN
*--------------------------
PROCESS:
*--------------------------
    PROCESS.LIST = ''
    PROCESS.LIST<2> = FN.REDO.BATCH.JOB.LIST.FILE
*    CALL BATCH.BUILD.LIST(PROCESS.LIST,"")
    EB.Service.BatchBuildList(PROCESS.LIST,"") ;*R22 Manual Conversion

RETURN
END
