* @ValidationCode : MjotMTEwNjY4NjMzNDpDcDEyNTI6MTY4MjA3MzM4MjQ2NjpJVFNTOi0xOi0xOi0xNjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -16
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BUILD.CURRENT.FWD.ID(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.E.BUILD.CURRENT.FWD.ID
*----------------------------------------------------------

* Description   : This subroutine is attached as a conversion routine in the Enquiry REDO.E.AA.ARR.ACTIVITY
*                 to get the old properrty list

* Linked with   : Enquiry REDO.E.BUILD.CURRENT.FWD.ID as conversion routine
* In Parameter  : None
* Out Parameter : None
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
* 17-APR-2023     Conversion tool   R22 Auto conversion    VM to @VM, IF Condition added
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*---------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_System

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----
INIT:
*-----
    Y.VAR.ACCOUNT = System.getVariable('CURRENT.ACCT.NO')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - START
        Y.VAR.ACCOUNT = ""
    END					;*R22 Auto conversion - END
RETURN
*-------
PROCESS:
*-------
    Y.FIELD.COUNT=DCOUNT(ENQ.DATA<2>,@VM)
    ENQ.DATA<2,Y.FIELD.COUNT+1>= 'ACCOUNT.ID'
    ENQ.DATA<3,Y.FIELD.COUNT+1>= 'EQ'
    ENQ.DATA<4,Y.FIELD.COUNT+1> = Y.VAR.ACCOUNT
RETURN
END
