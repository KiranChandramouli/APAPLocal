* @ValidationCode : MjotMTAyMDk3MDU5MzpDcDEyNTI6MTY4MDc3Nzc2NjM1MjpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 16:12:46
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.COMPLAINT.OPEN.LETTER
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : A Authorisation to generate the PDF for OPEN letter and this routine
* is attached to REDO.ISSUE.COMPLAINTS,NEW
*
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : B RENUGADEVI
* PROGRAM NAME : REDO.V.AUT.COMPLAINT.OPEN.LETTER
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE               WHO                REFERENCE                    DESCRIPTION
* 16.AUG.2010     BRENUGADEVI        ODR-2009-12-0283              INITIAL CREATION
*06-04-2023       Conversion Tool    R22 Auto Code conversion          No Changes
*06-04-2023       Samaran T          R22 Manual Code Conversion         No Changes
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.COMPLAINTS

    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****

    FN.REDO.ISSUE.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'
    F.REDO.ISSUE.COMPLAINTS  = ''
    CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)
RETURN

********
PROCESS:
********
    Y.ID       = ID.NEW
    Y.STATUS   = R.NEW(ISS.COMP.STATUS)
    TASK.NAME  = "ENQ REDO.ENQ.COMPLAINT.STATUS.OPEN @ID EQ ":Y.ID

    IF Y.STATUS EQ 'OPEN' THEN
        CALL EB.SET.NEW.TASK(TASK.NAME)
    END
RETURN
END
