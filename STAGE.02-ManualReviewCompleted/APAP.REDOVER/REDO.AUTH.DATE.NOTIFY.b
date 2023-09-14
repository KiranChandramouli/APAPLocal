* @ValidationCode : MjotMTA2NTY5NjIwMjpDcDEyNTI6MTY4MDc3Njk1MTE5MDptdXRodTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:59:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : muthu
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.DATE.NOTIFY
*-----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.AUTH.DATE.NOTIFY
*------------------------------------------------------------------------------
*IN PARAMETER  : NA
*OUT PARAMETER : NA
*LINKED WITH   : REDO.ISSUE.CLAIMS,NOTIFY , REDO.ISSUE.REQUESTS,NOTIFY , REDO.ISSUE.COMPLAINTS,NOTIFY
*------------------------------------------------------------------------------
* AUTHOR               DATE         REFERENCE                DESCRIPTION
* S.Sudharsanan      23/09/2011     PACS00115270             Update date.notification field based on condition.
* CONVERSION TOOL    06-04-2023	        AUTO R22 CODE CONVERSION	 NO CHANGE
* MUTHUKUMAR M       06-04-2023		MANUAL R22 CODE CONVERSION	 NO CHANGE
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.REDO.ISSUE.REQUESTS
    $INSERT I_F.REDO.ISSUE.COMPLAINTS

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*-----------
OPEN.FILES:
*-----------
    FN.REDO.ISSUE.CLAIMS = 'F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)

    FN.REDO.ISSUE.REQUESTS = 'F.REDO.ISSUE.REQUESTS'
    F.REDO.ISSUE.REQUESTS = ''
    CALL OPF(FN.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS)

    FN.REDO.ISSUE.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'
    F.REDO.ISSUE.COMPLAINTS = ''
    CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)

RETURN
*-----------
PROCESS:
*-----------
    BEGIN CASE
        CASE APPLICATION EQ 'REDO.ISSUE.CLAIMS'
            VAR.CLOSE.NOTIFY = R.NEW(ISS.CL.CLOSE.NOTIFICATION)
            VAR.CLIENT.CONTACT = R.NEW(ISS.CL.CLIENT.CONTACTED)
            IF (VAR.CLOSE.NOTIFY EQ 'YES' OR VAR.CLOSE.NOTIFY EQ 'SI') AND (VAR.CLIENT.CONTACT EQ 'YES' OR VAR.CLIENT.CONTACT EQ 'SI') THEN
                R.NEW(ISS.CL.DATE.NOTIFICATION) = TODAY
            END

        CASE APPLICATION EQ 'REDO.ISSUE.REQUESTS'
            VAR.CLOSE.NOTIFY = R.NEW(ISS.REQ.CLOSE.NOTIFICATION)
            VAR.CLIENT.CONTACT = R.NEW(ISS.REQ.CLIENT.CONTACTED)
            IF (VAR.CLOSE.NOTIFY EQ 'YES' OR VAR.CLOSE.NOTIFY EQ 'SI') AND (VAR.CLIENT.CONTACT EQ 'YES' OR VAR.CLIENT.CONTACT EQ 'SI') THEN
                R.NEW(ISS.REQ.DATE.NOTIFICATION) = TODAY
            END


        CASE APPLICATION EQ 'REDO.ISSUE.COMPLAINTS'
            VAR.CLOSE.NOTIFY = R.NEW(ISS.COMP.CLOSE.NOTIFICATION)
            VAR.CLIENT.CONTACT = R.NEW(ISS.COMP.CLIENT.CONTACTED)
            IF (VAR.CLOSE.NOTIFY EQ 'YES' OR VAR.CLOSE.NOTIFY EQ 'SI') AND (VAR.CLIENT.CONTACT EQ 'YES' OR VAR.CLIENT.CONTACT EQ 'SI') THEN
                R.NEW(ISS.COMP.DATE.NOTIFICATION) = TODAY
            END
    END CASE
RETURN
*----------------------
END
