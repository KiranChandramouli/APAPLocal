* @ValidationCode : MjotMTM1MjcxNDU4MzpDcDEyNTI6MTcwMzc2MjI1ODg0OTp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 28 Dec 2023 16:47:38
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
$PACKAGE APAP.AA
* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.CRE.ARR.AA.OFS.SELECT
*-----------------------------------------------------------------------------
* Fabrica de Credito
* This SERVICE has to check if the AA that was queued by REDO.CREATE.ARRANGEMENT
* is created OK or NOT
*
*        AUTHOR                   DATE
*-----------------------------------------------------------------------------
* hpasquel@temenos.com         2011-01-11
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 20-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 20-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*28-12-2023       VIGNESHWARI S      R22 MANUAL CONVERSTION - call rtn modified
*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$USING EB.Service
*
$INSERT I_REDO.B.CRE.ARR.AA.OFS.COMMON

LIST.PARAMETERS = '' ; ID.LIST = ''

SELECT.STATEMENT = 'SELECT ':FN.REDO.CRE.ARR.AA.OFS.LIST
NO.SELECTED = ''
SYSTEM.RETURN.CODE = ''
CALL EB.READLIST(SELECT.STATEMENT,ID.LIST,'',NO.SELECTED,SYSTEM.RETURN.CODE)

*     LIST.PARAMETERS<2> = 'F.REDO.CRE.ARR.AA.OFS.LIST'
*     LIST.PARAMETERS<3> = 'TRADE.CCY EQ "USD"'

*CALL BATCH.BUILD.LIST(LIST.PARAMETERS,ID.LIST)
EB.Service.BatchBuildList('',SEL.LIST) ;*R22 MANUAL CONVERSTION - call rtn modified
RETURN
END
