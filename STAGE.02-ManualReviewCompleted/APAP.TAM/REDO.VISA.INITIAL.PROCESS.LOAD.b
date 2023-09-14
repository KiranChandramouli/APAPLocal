* @ValidationCode : Mjo5NDY5NzM0Mjk6Q3AxMjUyOjE2ODE4MTU1NzA2Mjg6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 16:29:30
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
SUBROUTINE REDO.VISA.INITIAL.PROCESS.LOAD
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.VISA.INITIAL.PROCESS.LOAD
*Date              : 23.11.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*23/11/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.VISA.STLMT.FILE.DETAILS
    $INSERT I_F.REDO.VISA.PROCESS.INFO
    $INSERT I_REDO.VISA.INITIAL.PROCESS.COMMON

    GOSUB INIT
    GOSUB OPEN.FILES

RETURN
*------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------
    FN.REDO.VISA.STLMT.FILE.DETAILS='F.REDO.VISA.STLMT.FILE.DETAILS'
    F.REDO.VISA.STLMT.FILE.DETAILS=''

    FN.REDO.VISA.PROCESS.INFO='F.REDO.VISA.PROCESS.INFO'
    F.REDO.VISA.PROCESS.INFO=''

    FN.REDO.STLMT.CNCT.PROCESS='F.REDO.STLMT.CNCT.PROCESS'
    F.REDO.STLMT.CNCT.PROCESS=''

    FN.REDO.VISA.CNCT.DATE='F.REDO.VISA.CNCT.DATE'
    F.REDO.VISA.CNCT.DATE=''

RETURN
*------------------------------------------------------------------------------------
OPEN.FILES:
*------------------------------------------------------------------------------------
    CALL OPF(FN.REDO.VISA.STLMT.FILE.DETAILS,F.REDO.VISA.STLMT.FILE.DETAILS)
    CALL OPF(FN.REDO.VISA.PROCESS.INFO,F.REDO.VISA.PROCESS.INFO)
    CALL OPF(FN.REDO.STLMT.CNCT.PROCESS,F.REDO.STLMT.CNCT.PROCESS)
    CALL OPF(FN.REDO.VISA.CNCT.DATE,F.REDO.VISA.CNCT.DATE)

RETURN
END
