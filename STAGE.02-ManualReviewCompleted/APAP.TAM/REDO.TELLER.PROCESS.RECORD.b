* @ValidationCode : MjotMTQ4MzUxNDE4OTpDcDEyNTI6MTY4MTg4ODU1OTQ3NDpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 12:45:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TELLER.PROCESS.RECORD
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------
* DESCRIPTION :  This is routine is needed to automatically populate
* the field BRANCH.CODE in the template REDO.TELLER.PROCESS
*----------------------------------------------------------------------------------------
*----------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*----------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.TELLER.PROCESS.RECORD
*----------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 13.05.2010      SUDHARSANAN S     ODR-2009-10-0322  INITIAL CREATION
* ---------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*19-04-2023            Conversion Tool             R22 Auto Code conversion                           = TO EQ
*19-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-----------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.TELLER.PROCESS
    $INSERT I_F.REDO.USER.ACCESS
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
    FN.REDO.USER.ACCESS = 'F.REDO.USER.ACCESS'
    F.REDO.USER.ACCESS = ''
    CALL OPF(FN.REDO.USER.ACCESS,F.REDO.USER.ACCESS)
RETURN
*----------------------------------------------------------------------------
PROCESS:
*Update branch code field  in the REDO.TELLER.PROCESS table

    IF V$FUNCTION EQ "I" AND PGM.VERSION EQ ",PROCESS" THEN
*T(TEL.PRO.BRANCH.DES)<3> = 'NOINPUT'
    END
RETURN
*--------------------------------------------------------------------------
END
