* @ValidationCode : MjotMTg0MTY0NTQyNTpDcDEyNTI6MTY4MTEwNDU3Nzg0NjpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 10:59:37
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
SUBROUTINE REDO.V.AUT.REQUEST.OPEN.LETTER
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : A Authorisation to generate the PDF for OPEN letter and this routine
* is attached to REDO.ISSUE.REQUESTS,NEW
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
* PROGRAM NAME : REDO.V.AUT.REQUEST.OPEN.LETTER
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 16.AUG.2010       BRENUGADEVI        ODR-2009-12-0283  INITIAL CREATION
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                           = TO EQ
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.REQUESTS

    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****

    FN.REDO.ISSUE.REQUESTS = 'F.REDO.ISSUE.REQUESTS'
    F.REDO.ISSUE.REQUESTS  = ''
    CALL OPF(FN.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS)
RETURN

********
PROCESS:
********
    Y.ID       = ID.NEW
    Y.STATUS   = R.NEW(ISS.REQ.STATUS)
    TASK.NAME  = "ENQ REDO.ENQ.REQUEST.STATUS.OPEN @ID EQ ":Y.ID

    IF Y.STATUS EQ 'OPEN' THEN
        CALL EB.SET.NEW.TASK(TASK.NAME)
    END
RETURN
END
