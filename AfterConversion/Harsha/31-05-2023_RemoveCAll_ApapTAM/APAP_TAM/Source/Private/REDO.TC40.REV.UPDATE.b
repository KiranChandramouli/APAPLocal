* @ValidationCode : MjoxOTk1MjcwMTAzOkNwMTI1MjoxNjgzMDE4MDk1NDYyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 May 2023 14:31:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.TC40.REV.UPDATE
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.TC40.REV.UPDATE
*Date              : 07.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --REC.ID--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*07/12/2010           H GANESH             ODR-2010-08-0469       Initial Version
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
 
    GOSUB PROCESS
RETURN
 


*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------

    FN.REDO.VISA.GEN.OUT='F.REDO.VISA.GEN.OUT'
    F.REDO.VISA.GEN.OUT=''
    CALL OPF(FN.REDO.VISA.GEN.OUT,F.REDO.VISA.GEN.OUT)

    Y.WRITE.ID=ID.NEW:'*':APPLICATION
    R.ARR=''
    CALL F.WRITE(FN.REDO.VISA.GEN.OUT,Y.WRITE.ID,R.ARR)

RETURN

END
