* @ValidationCode : Mjo2NDEzNzU0Mjc6Q3AxMjUyOjE2ODExOTk2OTAwMjc6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 13:24:50
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
SUBROUTINE REDO.ISSUE.REQUESTS.ID
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to check the ID value for the table REDO.ISSUE.REQUESTS
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.ISSUE.COMPLAINTS.ID
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 22.07.2010      PRABHU             CRM-HD1100464     INITIAL CREATION
*10.03.2010      PRABHU             CRM-HD1100441  Common varible added
* 16.05.2011      PRADEEP S          PACS00060849      PGM.VERSION set to current variable to access from
*                                                      drop down enquiry
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_REDO.SET.REQ.COMP.ID
    $INSERT I_F.REDO.ISSUE.COMPLAINTS
    $INSERT I_F.LOCKING
    $INSERT I_System

    GOSUB PROCESS
RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------------
    FN.FRONT.REQUESTS='F.REDO.FRONT.REQUESTS'
    F.FRONT.REQUESTS=''
    CALL OPF(FN.FRONT.REQUESTS,F.FRONT.REQUESTS)

    Y.ID.NEW=CRM.CUR.TXN.ID

    IF Y.ID.NEW THEN
        ID.NEW=Y.ID.NEW
        Y.FRONT.ID=FIELD(Y.ID.NEW,'.',3)
        CALL F.DELETE(FN.FRONT.REQUESTS,Y.FRONT.ID)
        CRM.CUR.TXN.ID=''
    END

    Y.PGM.VERSION = PGM.VERSION  ; Y.APPLICATION = APPLICATION
    CALL System.setVariable('CURRENT.PGM.VER',Y.PGM.VERSION)
    CALL System.setVariable('CURRENT.APPLICATION',Y.APPLICATION)

RETURN
*------------------------------------------------------------------------------------------------------------
END
