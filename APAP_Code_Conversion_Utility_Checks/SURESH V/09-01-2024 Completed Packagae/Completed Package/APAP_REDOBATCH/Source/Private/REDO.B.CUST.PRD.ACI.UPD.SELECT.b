* @ValidationCode : Mjo5MzM3NTU0Njk6Q3AxMjUyOjE3MDM1NzI1ODkwODM6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Dec 2023 12:06:29
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
SUBROUTINE REDO.B.CUST.PRD.ACI.UPD.SELECT
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.CUST.PRD.ACI.UPD.SELECT
* ODR NO        : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.CUST.PRD.ACI.UPD

* 27/apr/2012 : Shek : Performance tuning
*             : initial .select routine is now multithreaded as REDO.B.CUST.PRD.ACI.UPD.PRE job
*               This job selects FN.REDO.BATCH.JOB.LIST.FILE, which is build by the .pre job

* In parameter : None
* out parameter : None
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                R22 Manual Conversion    CALL routine modified
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
