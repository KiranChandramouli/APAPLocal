* @ValidationCode : MjotODkxMzYyNzA6VVRGLTg6MTY4MzYxNjA4MTIxNjpJVFNTOi0xOi0xOi0zMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 May 2023 12:38:01
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -30
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
******************************************************************************
SUBROUTINE REDO.FC.ARRANGEMENT.AUTH
******************************************************************************
* Company Name:   Asociacion Popular de Ahorro y Prestamo (APAP)
* Developed By:   Reginal Temenos Application Management
* ----------------------------------------------------------------------------
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose : CALL the REDO.FC.CL.PROCCES TO CREACTE A RECORD IN REDO.FC.CL.BALANCE
* Incoming        : NA
* Outgoing        : NA
*
* ----------------------------------------------------------------------------
* Modification History:
* ====================
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : Junio 01 2011
*
*  DATE             WHO                   REFERENCE
* 04-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 04-APRIL-2023      Harsha                R22 Manual Conversion - Added APAP.REDOFCFI to CALL
*------------------------------------------------------------------------
******************************************************************************

******************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE


******************************************************************************

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN

* =========
INITIALISE:
* =========
    LOOP.CNT        = 1
    MAX.LOOPS       = 1
    PROCESS.GOAHEAD = 1


RETURN

* =========
OPEN.FILES:
* =========

RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================

RETURN

* ======
PROCESS:
* ======

*CALL APAP.REDOFCFI.REDO.FC.CL.PROCESS("CREACION")
    CALL APAP.REDOFCFI.redoFcClProcess("CREACION");*R22 Manual Conversion - Added APAP.REDOFCFI
RETURN

END
