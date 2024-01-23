* @ValidationCode : MjoyNjk4NjE0MDpDcDEyNTI6MTcwNDc5MTk5NTAwOTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jan 2024 14:49:55
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
* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.CCRG.B.EVA.SELECT
*-----------------------------------------------------------------------------
* Select routine to setup the common area for the multi-threaded Close of Business
* job XX
*REM Just for compile
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*18/01/2024         Suresh                 R22 UTILITY AUTO CONVERSION   CALL routine Modified
*-------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*    $INSERT I_BATCH.FILES ;*R22 Manual Conversion
    $USING EB.Service
*
    $INSERT I_REDO.CCRG.B.EVA.COMMON
*-----------------------------------------------------------------------------
* Setup the parameters for BATCH.BUILD.LIST

* LIST.PARAMETERS<1> = blank, this is the list file name, NEVER enter a value here

* LIST.PARAMETERS<2> = the filename to be selected, e.g. F.ACCOUNT, BATCH.BUILD.LIST will open it

* LIST.PARAMETERS<3> = selection criteria for file, e.g. CURRENCY EQ "GBP", this first WITH is not required

*                      and will be added by BATCH.BUILD.LIST

* ID.LIST = predefined list, for example from a CONCAT file record.

*           ID.LIST will take precedence over LIST.PARAMETERS

* CONTROL.LIST = common list used by BATCH.JOB.CONTROL


    LIST.PARAMETERS = '' ; ID.LIST = ''
 
    LIST.PARAMETERS = ''
    LIST.PARAMETERS<2> = FN.REDO.CCRG.EVA.QUEUE
*    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,ID.LIST)
    EB.Service.BatchBuildList(LIST.PARAMETERS,ID.LIST);* R22 UTILITY AUTO CONVERSION

RETURN
END
