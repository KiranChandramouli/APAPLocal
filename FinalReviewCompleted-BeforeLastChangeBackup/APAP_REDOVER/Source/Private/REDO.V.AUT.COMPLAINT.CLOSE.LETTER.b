* @ValidationCode : MjoxOTU1MzAyOTc2OkNwMTI1MjoxNjgyNDEyMzMzNTgzOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.COMPLAINT.CLOSE.LETTER
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : A Authorisation to generate the PDF for CLOSE letter and this routine
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
* PROGRAM NAME : REDO.V.AUT.COMPLAINT.CLOSE.LETTER
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                        REFERENCE                    DESCRIPTION
* 16.AUG.2010       BRENUGADEVI              ODR-2009-12-0283             INITIAL CREATION
* 19.MAY.2011       Pradeep S                 PACS00060849                 PDF Generated during notification
*06-04-2023         Conversion Tool        R22 Auto Code conversion          No Changes
*06-04-2023          Samaran T               R22 Manual Code Conversion       No Changes
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
    Y.STATUS   = R.NEW(ISS.COMP.CLOSE.NOTIFICATION)
    TASK.NAME  = "ENQ REDO.ENQ.COMPLAINTS.STATUS.CLOSE @ID EQ ":Y.ID

*IF Y.STATUS EQ 'YES' THEN
    CALL EB.SET.NEW.TASK(TASK.NAME)
*END
RETURN
END
