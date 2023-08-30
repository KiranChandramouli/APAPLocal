* @ValidationCode : MjotMTE4MTc0NDkwOTpDcDEyNTI6MTY4MTczNDg0NDA1OTpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Apr 2023 18:04:04
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
SUBROUTINE REDO.V.VAL.UPDATE.CRM.STATUS
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This validation routine is used to update SER.AGR.PERF based on Status selected in closed
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : PRABHU N
* PROGRAM NAME : REDO.V.VAL.UPDATE.CRM.STATUS
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 22.07.2010      PRABHU N            HD1100441         INITIAL CREATION
* 17.05.2011      Pradeep S           PACS00062662      CLOSING.DATE field was defaulted to TODAY
* ----------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*17-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.REDO.ISSUE.COMPLAINTS
    $INSERT I_F.REDO.ISSUE.REQUESTS
    $INSERT I_F.REDO.CLAIM.STATUS.MAP

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-------
INIT:
*-------
    FN.REDO.CLAIM.STAUS.MAP='F.REDO.CLAIM.STATUS.MAP'
    F.REDO.CLAIM.STAUS.MAP=''
    CALL OPF(FN.REDO.CLAIM.STAUS.MAP,F.REDO.CLAIM.STAUS.MAP)
    Y.CLOSING.STATUS=COMI
    Y.MAP.ID = APPLICATION:PGM.VERSION
RETURN
*--------
PROCESS:
*--------

    CALL F.READ(FN.REDO.CLAIM.STAUS.MAP,Y.MAP.ID,R.REDO.CLAIM.STATUS.MAP,F.REDO.CLAIM.STAUS.MAP,ERR)

    IF R.REDO.CLAIM.STATUS.MAP THEN
        Y.CLOSED.STATUS=R.REDO.CLAIM.STATUS.MAP<CR.ST.CLOSED.STATUS>
        CHANGE @VM TO @FM IN Y.CLOSED.STATUS
        LOCATE COMI IN Y.CLOSED.STATUS SETTING Y.CLOSED.POS THEN
            Y.STATUS=R.REDO.CLAIM.STATUS.MAP<CR.ST.STATUS,Y.CLOSED.POS>
        END
        IF APPLICATION EQ 'REDO.ISSUE.CLAIMS' THEN
            R.NEW(ISS.CL.STATUS)=Y.STATUS
            R.NEW(ISS.CL.SER.AGR.PERF)=Y.STATUS
            R.NEW(ISS.CL.CLOSING.DATE)=TODAY
        END
        IF APPLICATION EQ 'REDO.ISSUE.COMPLAINTS' THEN
            R.NEW(ISS.COMP.STATUS)=Y.STATUS
            R.NEW(ISS.COMP.SER.AGR.PERF)=Y.STATUS
            R.NEW(ISS.COMP.CLOSING.DATE)=TODAY
        END
        IF APPLICATION EQ 'REDO.ISSUE.REQUESTS' THEN
            R.NEW(ISS.REQ.STATUS)=Y.STATUS
            R.NEW(ISS.REQ.SER.AGR.PERF)=Y.STATUS
            R.NEW(ISS.REQ.CLOSING.DATE)=TODAY
        END

    END
RETURN
END
