* @ValidationCode : MjotOTE2NTg2OTg0OkNwMTI1MjoxNjgxMTExODkyNjA5OklUU1M6LTE6LTE6MTAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:01:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 100
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CUST.PRD.ACI.PURGE.LOAD
****************************************************************
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.B.CUST.PRD.ACI.UPD.LOAD
* ODR Number    : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description :This routine will open all the files required
*              by the routine REDO.B.CUST.PRD.ACI.PURGE.LOAD

* In parameter : None
* out parameter : None
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CUST.PRD.ACI.PURGE.COMMON

    FN.REDO.BATCH.JOB.LIST.FILE = 'F.REDO.BATCH.JOB.LIST.FILE'
    F.REDO.BATCH.JOB.LIST.FILE = ''
    CALL OPF(FN.REDO.BATCH.JOB.LIST.FILE, F.REDO.BATCH.JOB.LIST.FILE)

RETURN
END
