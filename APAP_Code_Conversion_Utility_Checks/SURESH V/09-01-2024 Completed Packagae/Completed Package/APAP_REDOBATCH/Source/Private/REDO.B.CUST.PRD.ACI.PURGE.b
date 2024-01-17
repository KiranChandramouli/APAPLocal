* @ValidationCode : MjotMTQyMjg2ODE1NzpDcDEyNTI6MTY4NDg1NDM4Mzg2MjpJVFNTOi0xOi0xOjkxOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 91
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CUST.PRD.ACI.PURGE(Y.ACCT.NO)
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.B.CUST.PRD.ACI.PURGE
* ODR Number    : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description : This batch routine is used to purge the table REDO.BATCH.JOB.LIST.FILE
* Linked with: N/A
* In parameter : None
* out parameter : None
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CUST.PRD.ACI.PURGE.COMMON

    GOSUB PROCESS
RETURN
*
*-------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
    CALL F.DELETE(FN.REDO.BATCH.JOB.LIST.FILE,Y.ACCT.NO)
*-------------------------------------------------------------------------
END
