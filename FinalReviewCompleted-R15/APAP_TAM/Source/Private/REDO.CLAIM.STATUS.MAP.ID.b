* @ValidationCode : MjotOTYzODIyNTgxOkNwMTI1MjoxNjgwNjc5MTk5MzYxOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 12:49:59
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
SUBROUTINE REDO.CLAIM.STATUS.MAP.ID
*------------------------------------------------------------------------------
*------------------------------------------------------------------------------
* DESCRIPTION : This routine is used to check the ID value for the table
* REDO.CLAIM.STATUS.MAP
*------------------------------------------------------------------------------
*------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : PRADEEP S
* PROGRAM NAME : REDO.CLAIM.STATUS.MAP.ID
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE           DESCRIPTION
* 13-MAY-2011      Pradeep S          PACS00060849        INITIAL CREATION
** 05-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 05-04-2023 Skanda R22 Manual Conversion - No changes
* ----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB PROCESS
RETURN

********
PROCESS:
********
    Y.ID = ID.NEW
    Y.VALID.ID = 'REDO.ISSUE.CLAIMS,CLOSE':@VM:'REDO.ISSUE.COMPLAINTS,CLOSE':@VM:'REDO.ISSUE.REQUESTS,CLOSE':@VM:'REDO.ISSUE.CLAIMS,NOTIFY':@VM:'REDO.ISSUE.COMPLAINTS,NOTIFY':@VM:'REDO.ISSUE.REQUESTS,NOTIFY'

    IF Y.ID MATCHES Y.VALID.ID ELSE
        E = "Enter Valid Reference"
    END
RETURN
END
